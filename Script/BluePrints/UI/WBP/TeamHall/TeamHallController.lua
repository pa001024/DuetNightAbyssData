local TeamHallModel = require("BluePrints.UI.WBP.TeamHall.TeamHallModel")
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local MiscUtils = require("Utils.MiscUtils")
local TeamHallRecruitShareModel = require("BluePrints.UI.WBP.TeamHall.TeamHallRecruitShareModel")
local TeamHallRecruitModel = require("BluePrints.UI.WBP.TeamHall.TeamHallRecruitModel")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local PlayerMenuActionRegistry = require("BluePrints.UI.WBP.Chat.View.PlayerMenuActionRegistry")
local TeamController = require("BluePrints.UI.WBP.Team.TeamController")
local EMCache = require("EMCache.EMCache")
local GlobalConstant = DataMgr.GlobalConstant
local M = Class("BluePrints.Common.MVC.Controller")
local TeamRequestReddotName = TeamHallCommon.ReddotName.TeamRequest
local InviteQueueManager = require("BluePrints.UI.Common.InviteQueueManager")
local RecruitmentListRefreshTimerKey = "TeamHallRecruitmentListRefreshTimer"
local RecruitmentPublishCooldownTimerKey = "TeamHallRecruitmentPublishCooldownTimer"
local RecruitmentStartTimeCacheKey = "TeamHallRecruitmentStartTime"
local RecruitShareRetryTimerPrefix = "TeamHallRecruitShareRetry:"
local RecruitShareFailureReason = {
  InvalidState = "invalid_recruitment_state",
  SnapshotMissing = "recruitment_snapshot_missing",
  SnapshotInvalid = "recruitment_snapshot_invalid",
  RequestFailed = "recruitment_snapshot_request_failed"
}
local RecruitShareFailureTextKey = {
  [RecruitShareFailureReason.InvalidState] = "UI_TeamRecruitCancelled",
  [RecruitShareFailureReason.SnapshotMissing] = "UI_TeamRecruitCancelled",
  [RecruitShareFailureReason.SnapshotInvalid] = "UI_TeamRecruitCancelled"
}
local RecruitmentAvatarMenuActionId = PlayerMenuActionRegistry.ActionId

local function TableToLogString(Data)
  if CommonUtils and CommonUtils.TableToString then
    return CommonUtils.TableToString(Data, 6)
  end
  return tostring(Data)
end

local function ToInteger(Value)
  if type(Value) == "number" then
    return math.tointeger(Value)
  end
  if type(Value) ~= "string" or not string.match(Value, "^%d+$") then
    return nil
  end
  return math.tointeger(tonumber(Value))
end

local function IsSameInteger(Left, Right)
  local LeftInteger = ToInteger(Left)
  local RightInteger = ToInteger(Right)
  return nil ~= LeftInteger and LeftInteger == RightInteger
end

local function RemoveRecruitmentAvatarMenuAction(ActionIds, TargetActionId)
  for Index, ActionId in ipairs(ActionIds or {}) do
    if ActionId == TargetActionId then
      table.remove(ActionIds, Index)
      return
    end
  end
end

local function IsTeamHallVerboseLogEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableVerboseLog
end

local function IsTeamHallSourceTraceEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableSourceTraceScreenPrint
end

local function BuildSourceTraceText(Message)
  local FinalMessage = tostring(Message or "")
  if string.len(FinalMessage) > 140 then
    FinalMessage = string.sub(FinalMessage, 1, 140) .. "..."
  end
  return "[TH] " .. FinalMessage
end

local function BuildFiltersBrief(Filters)
  if not Filters or #Filters <= 0 then
    return "-"
  end
  local MaxCount = math.min(#Filters, 3)
  local Parts = {}
  for Index = 1, MaxCount do
    Parts[Index] = tostring(Filters[Index])
  end
  local Text = table.concat(Parts, ",")
  if MaxCount < #Filters then
    Text = Text .. "+" .. tostring(#Filters - MaxCount)
  end
  return Text
end

local function BuildPendingReason(bRequesting, bCoolingDown)
  if bRequesting and bCoolingDown then
    return "req+cd"
  end
  if bRequesting then
    return "req"
  end
  if bCoolingDown then
    return "cd"
  end
  return "-"
end

function M:Init()
  if self.bInited then
    return
  end
  M.Super.Init(self)
  self.RecruitmentRequestTraceId = 0
  self.LastRecruitmentListSuccessTraceId = 0
  self.RecruitmentListRefreshCooldownEndTime = 0
  self.RecruitmentPublishCooldownEndTime = 0
  self.PendingRecruitmentListRequest = nil
  self.bRecruitmentListCoolingDown = false
  self.bRecruitmentListRequesting = false
  self.bLastTeamRecruitingState = self:GetModel():IsTeamInRecruiting()
  EventManager:AddEvent(EventID.OnAvatarStatusUpdate, self, self.OnAvatarStatusUpdate)
  EventManager:AddEvent(EventID.OnAvatarLogout, self, self.OnAvatarLogout)
  self:EnsureTeamRequestReddotNode()
end

function M:SetTeamHallRecruitmentStartTime(RecruitStartTime)
  if RecruitStartTime then
    EMCache:Set(RecruitmentStartTimeCacheKey, RecruitStartTime, true)
    EMCache:SaveUser(false)
  end
end

function M:GetTeamHallRecruitmentStartTime()
  return tonumber(EMCache:Get(RecruitmentStartTimeCacheKey, true))
end

function M:ClearTeamHallRecruitmentStartTime()
  EMCache:Remove(RecruitmentStartTimeCacheKey, true)
  EMCache:SaveUser(false)
end

function M:OpenTeamHall()
  return UIManager(self):LoadUINew("TeamHall")
end

function M:OpenTeamHallInvite()
  local UIMgr = UIManager(self)
  local TeamHallView = UIMgr:GetUIObj("TeamHall")
  if not IsValid(TeamHallView) then
    TeamHallView = self:OpenTeamHall()
  end
  if IsValid(TeamHallView) and TeamHallView.OpenInviteFriendTab then
    TeamHallView:OpenInviteFriendTab()
  end
  return TeamHallView
end

function M:OpenRecruit(Owner, Params)
  Params = Params or {}
  Params.DontCloseWhenRightBtnClicked = true
  Params.RightGamepadKey = UIConst.GamePadKey.FaceButtonLeft
  Params.RightGamepadImg = UIConst.GamePadImgKey.FaceButtonLeft
  Params.ShowBKeyClose = true
  Params.RightCallbackObj = self
  
  function Params.RightCallbackFunction(_, _, Dialog)
    if not Dialog or not Dialog.GetContentWidgetByName then
      return
    end
    local RecruitWidget = Dialog:GetContentWidgetByName("WBP_Team_Recruit")
    if RecruitWidget and RecruitWidget.RequestPublish then
      RecruitWidget:RequestPublish()
    end
  end
  
  return UIManager(self):ShowCommonPopupUI(TeamHallCommon.Recruit.PopupId, Params, Owner)
end

function M:_GetCurrentRecruitmentFilters()
  local HallModel = self:GetModel()
  local FilterState = HallModel:GetRecruitBoardFilterState()
  local FirstTypeId = FilterState and FilterState.FirstTypeId or nil
  if not FirstTypeId then
    return {}
  end
  return HallModel:BuildRecruitmentRequestFilters(FirstTypeId)
end

function M:_ShowRecruitPublishTip(TextKey)
  if TextKey then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(TextKey), 1.5)
  end
end

function M:CanPublishRecruitment(Avatar)
  if not Avatar or not Avatar.PublishRecruitmentInTeamHall then
    return false
  end
  if self:IsRecruitmentPublishCoolingDown() then
    self:ShowRecruitmentPublishCooldownTip()
    return false
  end
  if self:GetModel():IsTeamInRecruiting() then
    return false
  end
  local TeamModel = TeamController and TeamController.GetModel and TeamController:GetModel() or nil
  local TeamData = TeamModel and TeamModel:GetTeam() or nil
  if TeamData and TeamData.Members and #TeamData.Members > 1 then
    local LeaderUid = TeamModel:GetTeamLeaderId()
    if LeaderUid and not IsSameInteger(LeaderUid, Avatar.Uid) then
      self:_ShowRecruitPublishTip("UI_TeamOnlyLeaderCanRecruit")
      return false
    end
  end
  return true
end

function M:PublishRecruitment(RecruitmentInfo, PersistedSnapshot, Complete)
  local Avatar = self:GetAvatar()
  local FrozenRecruitmentInfo = TeamHallRecruitModel.DeepCopy(RecruitmentInfo)
  local FrozenPersistedSnapshot = TeamHallRecruitModel.BuildPersistedSnapshot(PersistedSnapshot)
  if not (self:CanPublishRecruitment(Avatar) and FrozenRecruitmentInfo) or not FrozenPersistedSnapshot then
    if Complete then
      Complete(false, nil)
    end
    return false
  end
  local bCompleted = false
  
  local function Finish(bSuccess, RetCode)
    if bCompleted then
      return
    end
    bCompleted = true
    if bSuccess then
      FrozenRecruitmentInfo.RecruitStartTime = TimeUtils.NowTime()
      self:GetModel():SetLocalRecruitmentInfo(FrozenRecruitmentInfo)
      self:SetTeamHallRecruitmentStartTime(FrozenRecruitmentInfo.RecruitStartTime)
      self.bLastTeamRecruitingState = true
      self:NotifyEvent(TeamHallCommon.EventId.RecruitmentStateChanged, true)
      TeamHallRecruitModel.SavePersistedSnapshot(FrozenPersistedSnapshot)
      self:RequestRecruitmentList(nil, self:_GetCurrentRecruitmentFilters(), "PublishRecruitment")
    end
    if Complete then
      Complete(true == bSuccess, RetCode)
    end
  end
  
  local bCallSuccess, bRequestStarted = pcall(Avatar.PublishRecruitmentInTeamHall, Avatar, nil, FrozenRecruitmentInfo, Finish)
  if not bCallSuccess then
    DebugPrint("TeamHallController:PublishRecruitment failed: " .. tostring(bRequestStarted))
    Finish(false, nil)
    return false
  end
  if false == bRequestStarted then
    Finish(false, nil)
    return false
  end
  return true
end

function M:IsRecruitmentPublishCoolingDown()
  return (self.RecruitmentPublishCooldownEndTime or 0) > TimeUtils.NowTime()
end

function M:GetRecruitmentPublishCooldownRemainingSeconds()
  local RemainingTime = math.max((self.RecruitmentPublishCooldownEndTime or 0) - TimeUtils.NowTime(), 0)
  return math.ceil(RemainingTime)
end

function M:ShowRecruitmentPublishCooldownTip()
  local RemainingSeconds = self:GetRecruitmentPublishCooldownRemainingSeconds()
  if RemainingSeconds <= 0 then
    return false
  end
  self:ShowToast(string.format(GText("UI_teamHallTagRecruitmentCDTip"), RemainingSeconds))
  return true
end

function M:ResolveRecruitmentPlayerAvatarInfo(MemberInfo, Complete)
  local Uid = ToInteger(MemberInfo and (MemberInfo.Uid or MemberInfo.Uuid))
  if not Uid then
    if Complete then
      Complete(nil)
    end
    return
  end
  local CachedAvatarInfo = MemberInfo and MemberInfo.TeamHallMenuAvatarInfo or nil
  if type(CachedAvatarInfo) == "table" and IsSameInteger(CachedAvatarInfo.Uid or CachedAvatarInfo.Uuid, Uid) then
    if Complete then
      Complete(CachedAvatarInfo)
    end
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar then
    if Complete then
      Complete(nil)
    end
    return
  end
  if IsSameInteger(Avatar.Uid, Uid) then
    local SelfAvatarInfo = Avatar.GetAvatarInfo and Avatar:GetAvatarInfo() or Avatar
    if MemberInfo then
      MemberInfo.TeamHallMenuAvatarInfo = SelfAvatarInfo
    end
    if Complete then
      Complete(SelfAvatarInfo)
    end
    return
  end
  Avatar:GetOtherAvatarInfo(function(OtherAvatarInfo)
    if type(OtherAvatarInfo) ~= "table" then
      if Complete then
        Complete(nil)
      end
      return
    end
    OtherAvatarInfo.Uid = OtherAvatarInfo.Uid or Uid
    OtherAvatarInfo.HeadIconId = not OtherAvatarInfo.HeadIconId and MemberInfo and MemberInfo.HeadIconId
    OtherAvatarInfo.HeadFrameId = not OtherAvatarInfo.HeadFrameId and MemberInfo and MemberInfo.HeadFrameId
    if MemberInfo then
      MemberInfo.TeamHallMenuAvatarInfo = OtherAvatarInfo
    end
    if Complete then
      Complete(OtherAvatarInfo)
    end
  end, Uid)
end

function M:BuildRecruitmentPlayerMenuActionIds(AvatarInfo)
  return PlayerMenuActionRegistry:BuildDefaultActionIds({
    AvatarInfo = AvatarInfo,
    bIncludeGuildAction = false,
    bApplyChatChannelFilter = false
  })
end

function M:OpenRecruitmentPlayerMenu(Owner, AvatarInfo, HeadAnchor)
  local ActionIds = self:BuildRecruitmentPlayerMenuActionIds(AvatarInfo)
  local FuncList = PlayerMenuActionRegistry:BuildMenuFuncList(ActionIds, {
    Owner = Owner,
    AvatarInfo = AvatarInfo,
    CloseMenu = function()
      if HeadAnchor then
        HeadAnchor:Close()
      end
    end
  })
  return ChatController:OpenPlayerBtnList(Owner, AvatarInfo, FuncList, nil, {AllowReportInNonChatContext = true})
end

function M:OpenRecruitShare(Owner, Params)
  Params = Params or {}
  if type(Params.OnShareRequested) ~= "function" then
    function Params.OnShareRequested(ChannelType, RecruitmentData, Complete)
      self:ShareRecruitmentToChannel(ChannelType, RecruitmentData, function(bSuccess, RetCode, LocalReason)
        if Complete then
          Complete(bSuccess, RetCode, LocalReason)
        end
        if bSuccess then
          UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_TeamRecruitAlreadyShared"), 1.5)
        end
      end)
    end
  end
  return UIManager(self):ShowCommonPopupUI(TeamHallCommon.RecruitShare.PopupId, Params, Owner)
end

function M:_ShowRecruitShareFailure(FailureReason)
  local TextKey = RecruitShareFailureTextKey[FailureReason]
  if not TextKey then
    return
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(TextKey), 1.5)
end

function M:ShareRecruitmentToChannel(ChannelType, RecruitmentData, Complete)
  local bCompleted = false
  
  local function Finish(bSuccess, RetCode, LocalReason)
    if bCompleted then
      return
    end
    bCompleted = true
    if Complete then
      Complete(true == bSuccess, RetCode, LocalReason)
    end
  end
  
  if ChannelType ~= ChatCommon.ChannelDef.TeamUp and ChannelType ~= ChatCommon.ChannelDef.InGuild then
    Finish(false)
    return
  end
  self:ResolveRecruitShareSnapshot(RecruitmentData, function(Snapshot, RetCode, LocalReason)
    if not Snapshot then
      Finish(false, RetCode, LocalReason)
      return
    end
    local Avatar = self:GetAvatar()
    if not Avatar or not Avatar.Uid then
      self:_ShowRecruitShareFailure(RecruitShareFailureReason.InvalidState)
      Finish(false, nil, RecruitShareFailureReason.InvalidState)
      return
    end
    local Content, EncodeError = TeamHallRecruitShareModel.Encode(Snapshot, Avatar.Uid)
    if not Content then
      DebugPrint("TeamHallController:ShareRecruitmentToChannel encode failed: " .. tostring(EncodeError))
      self:_ShowRecruitShareFailure(RecruitShareFailureReason.SnapshotInvalid)
      Finish(false, nil, RecruitShareFailureReason.SnapshotInvalid)
      return
    end
    local ChatControllerInstance = _G.ChatController or require("BluePrints.UI.WBP.Chat.ChatController")
    local bCallSuccess, bRequestStarted = pcall(function()
      if ChannelType == ChatCommon.ChannelDef.TeamUp then
        return ChatControllerInstance:SendChatToWorld(ChannelType, Content, Finish)
      end
      return ChatControllerInstance:SendChatToGuild(Content, Finish)
    end)
    if not bCallSuccess then
      DebugPrint("TeamHallController:ShareRecruitmentToChannel send failed: " .. tostring(bRequestStarted))
      Finish(false)
    elseif false == bRequestStarted then
      Finish(false)
    end
  end)
end

function M:ResolveRecruitShareSnapshot(RecruitmentData, Complete)
  local bCompleted = false
  
  local function Finish(Snapshot, RetCode, LocalReason)
    if bCompleted then
      return
    end
    bCompleted = true
    if Complete then
      Complete(Snapshot, RetCode, LocalReason)
    end
  end
  
  local Avatar = self:GetAvatar()
  local RawExpectedRecruitmentId = RecruitmentData and RecruitmentData.RecruitmentId or nil
  local ExpectedRecruitmentId = ToInteger(RawExpectedRecruitmentId)
  if nil ~= RawExpectedRecruitmentId and (not ExpectedRecruitmentId or ExpectedRecruitmentId <= 0) then
    self:_ShowRecruitShareFailure(RecruitShareFailureReason.InvalidState)
    Finish(nil, nil, RecruitShareFailureReason.InvalidState)
    return
  end
  local bStateValid, _, FailureReason, CurrentRecruitmentId = self:ValidateRecruitShareState(Avatar, ExpectedRecruitmentId)
  if not bStateValid then
    self:_ShowRecruitShareFailure(FailureReason)
    Finish(nil, nil, FailureReason)
    return
  end
  ExpectedRecruitmentId = CurrentRecruitmentId
  
  local function RequestLatestSnapshot(bRetried)
    local bStillValid, _, CurrentFailureReason = self:ValidateRecruitShareState(Avatar, ExpectedRecruitmentId)
    if not bStillValid then
      self:_ShowRecruitShareFailure(CurrentFailureReason)
      Finish(nil, nil, CurrentFailureReason)
      return
    end
    local bRequestSuccess, RequestError = pcall(Avatar.RefreshTeamHallList, Avatar, function(ErrCode, RawData)
      if ErrCode == ErrorCode.RET_TEAM_HALL_REFRESH_FREQUENTLY and not bRetried then
        self.RecruitShareRequestSerial = (self.RecruitShareRequestSerial or 0) + 1
        local RetrySeconds = self:GetRecruitShareRefreshRetrySeconds()
        local TimerKey = RecruitShareRetryTimerPrefix .. tostring(self.RecruitShareRequestSerial)
        self:AddTimer(RetrySeconds, function()
          RequestLatestSnapshot(true)
        end, false, 0, TimerKey)
        return
      end
      if not self:CheckError(ErrCode, true) then
        Finish(nil, ErrCode, nil)
        return
      end
      local bCurrentStateValid, RecruitmentOwnerUid, CurrentFailureReason = self:ValidateRecruitShareState(Avatar, ExpectedRecruitmentId)
      if not bCurrentStateValid then
        self:_ShowRecruitShareFailure(CurrentFailureReason)
        Finish(nil, nil, CurrentFailureReason)
        return
      end
      local LatestRecruitment = TeamHallRecruitShareModel.FindRecruitment(RawData, ExpectedRecruitmentId)
      if not LatestRecruitment then
        self:_ShowRecruitShareFailure(RecruitShareFailureReason.SnapshotMissing)
        Finish(nil, nil, RecruitShareFailureReason.SnapshotMissing)
        return
      end
      local LatestMembers = LatestRecruitment.Members or {}
      local LatestLeader = LatestMembers[1]
      local bAvatarInRecruitment = false
      for _, Member in ipairs(LatestMembers) do
        if IsSameInteger(Member.Uid, Avatar.Uid) then
          bAvatarInRecruitment = true
          break
        end
      end
      if not (LatestLeader and IsSameInteger(LatestLeader.Uid, RecruitmentOwnerUid)) or not bAvatarInRecruitment then
        self:_ShowRecruitShareFailure(RecruitShareFailureReason.InvalidState)
        Finish(nil, nil, RecruitShareFailureReason.InvalidState)
        return
      end
      local Snapshot, SnapshotError = TeamHallRecruitShareModel.BuildSnapshot(LatestRecruitment, RecruitmentOwnerUid, #LatestMembers)
      if not Snapshot then
        DebugPrint("TeamHallController:ResolveRecruitShareSnapshot invalid snapshot: " .. tostring(SnapshotError))
        self:_ShowRecruitShareFailure(RecruitShareFailureReason.SnapshotInvalid)
        Finish(nil, nil, RecruitShareFailureReason.SnapshotInvalid)
        return
      end
      Finish(Snapshot, ErrCode, nil)
    end, {})
    if not bRequestSuccess then
      DebugPrint("TeamHallController:ResolveRecruitShareSnapshot request failed: " .. tostring(RequestError))
      self:_ShowRecruitShareFailure(RecruitShareFailureReason.RequestFailed)
      Finish(nil, nil, RecruitShareFailureReason.RequestFailed)
    end
  end
  
  RequestLatestSnapshot(false)
end

function M:ValidateRecruitShareState(Avatar, ExpectedRecruitmentId)
  if not (Avatar and Avatar.Uid) or not self:GetModel():IsTeamInRecruiting() then
    return false, nil, RecruitShareFailureReason.InvalidState, nil
  end
  local TeamModel = TeamController and TeamController.GetModel and TeamController:GetModel() or nil
  local TeamData = TeamModel and TeamModel:GetTeam() or nil
  local LeaderUid = Avatar.Uid
  local CurrentRecruitmentId
  if TeamData then
    local Members = TeamData.Members or {}
    LeaderUid = TeamModel:GetTeamLeaderId()
    if not LeaderUid or #Members <= 0 then
      return false, nil, RecruitShareFailureReason.InvalidState, nil
    end
    local LeaderMember
    local bAvatarInTeam = false
    for _, Member in ipairs(Members) do
      if IsSameInteger(Member.Uid, LeaderUid) then
        LeaderMember = Member
      end
      if IsSameInteger(Member.Uid, Avatar.Uid) then
        bAvatarInTeam = true
      end
    end
    if not LeaderMember or not bAvatarInTeam then
      return false, nil, RecruitShareFailureReason.InvalidState, nil
    end
    local LeaderRecruitmentId = ToInteger(LeaderMember.TeamHallId)
    if IsSameInteger(LeaderUid, Avatar.Uid) then
      CurrentRecruitmentId = ToInteger(Avatar.TeamHallId)
      if not CurrentRecruitmentId or CurrentRecruitmentId <= 0 then
        CurrentRecruitmentId = LeaderRecruitmentId
      end
    else
      CurrentRecruitmentId = LeaderRecruitmentId
    end
  else
    CurrentRecruitmentId = ToInteger(Avatar.TeamHallId)
  end
  ExpectedRecruitmentId = ToInteger(ExpectedRecruitmentId)
  if ExpectedRecruitmentId and ExpectedRecruitmentId <= 0 then
    ExpectedRecruitmentId = nil
  end
  if CurrentRecruitmentId and CurrentRecruitmentId <= 0 then
    CurrentRecruitmentId = nil
  end
  if ExpectedRecruitmentId and CurrentRecruitmentId and ExpectedRecruitmentId < CurrentRecruitmentId then
    return false, nil, RecruitShareFailureReason.InvalidState, nil
  end
  CurrentRecruitmentId = ExpectedRecruitmentId or CurrentRecruitmentId
  if not CurrentRecruitmentId then
    return false, nil, RecruitShareFailureReason.InvalidState, nil
  end
  return true, LeaderUid, nil, CurrentRecruitmentId
end

function M:GetRecruitShareRefreshRetrySeconds()
  local Config = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.TeamListRefreshCD
  local RetrySeconds = tonumber(Config and Config.ConstantValue) or 1
  return math.max(RetrySeconds, 0.1)
end

function M:RequestEnterTeamFromChat(RecruitmentId, RecruitmentOwnerUid, MessageSenderUid, Complete)
  local ExpectedRecruitmentId = ToInteger(RecruitmentId)
  local OwnerUid = ToInteger(RecruitmentOwnerUid)
  local SenderUid = ToInteger(MessageSenderUid)
  if not (ExpectedRecruitmentId and not (ExpectedRecruitmentId <= 0) and OwnerUid and not (OwnerUid <= 0) and SenderUid) or SenderUid <= 0 then
    return false
  end
  local Avatar = self:GetAvatar()
  if not Avatar or type(Avatar.RefreshTeamHallList) ~= "function" or "function" ~= type(Avatar.RequestEnterTeam) then
    return false
  end
  local bCompleted = false
  
  local function Finish(bSuccess, RetCode)
    if bCompleted then
      return
    end
    bCompleted = true
    if Complete then
      Complete(true == bSuccess, RetCode)
    end
  end
  
  local function SendRequest()
    local bCallSuccess, RequestError = pcall(Avatar.RequestEnterTeam, Avatar, nil, OwnerUid, function(bSuccess, RetCode)
      Finish(bSuccess, RetCode)
    end, ExpectedRecruitmentId)
    if not bCallSuccess then
      DebugPrint("TeamHallController:RequestEnterTeamFromChat failed: " .. tostring(RequestError))
      Finish(false)
    end
  end
  
  local function ValidateSender(bRetried)
    local bRefreshSuccess, RefreshError = pcall(Avatar.RefreshTeamHallList, Avatar, function(ErrCode, RawData)
      if ErrCode == ErrorCode.RET_TEAM_HALL_REFRESH_FREQUENTLY and not bRetried then
        self.RecruitShareRequestSerial = (self.RecruitShareRequestSerial or 0) + 1
        local RetrySeconds = self:GetRecruitShareRefreshRetrySeconds()
        local TimerKey = RecruitShareRetryTimerPrefix .. tostring(self.RecruitShareRequestSerial)
        self:AddTimer(RetrySeconds, function()
          ValidateSender(true)
        end, false, 0, TimerKey)
        return
      end
      if not self:CheckError(ErrCode, true) then
        Finish(false, ErrCode)
        return
      end
      local LatestRecruitment = TeamHallRecruitShareModel.FindRecruitment(RawData, ExpectedRecruitmentId)
      if not LatestRecruitment then
        self:_ShowRecruitShareFailure(RecruitShareFailureReason.SnapshotMissing)
        Finish(false)
        return
      end
      local LatestMembers = LatestRecruitment.Members or {}
      local LatestLeader = LatestMembers[1]
      if not LatestLeader or not IsSameInteger(LatestLeader.Uid, OwnerUid) then
        self:_ShowRecruitShareFailure(RecruitShareFailureReason.InvalidState)
        Finish(false)
        return
      end
      local bSenderInRecruitment = false
      for _, Member in ipairs(LatestMembers) do
        if IsSameInteger(Member.Uid, SenderUid) then
          bSenderInRecruitment = true
          break
        end
      end
      if not bSenderInRecruitment then
        self:_ShowRecruitShareFailure(RecruitShareFailureReason.InvalidState)
        Finish(false)
        return
      end
      SendRequest()
    end, {})
    if not bRefreshSuccess then
      DebugPrint("TeamHallController:RequestEnterTeamFromChat refresh failed: " .. tostring(RefreshError))
      Finish(false)
    end
  end
  
  ValidateSender(false)
  return true
end

function M:OpenRecruitSharePreview(Owner, RecruitmentData)
  return self:OpenRecruitShare(Owner, {
    RecruitmentData = RecruitmentData,
    OnShareRequested = function(ChannelType, ShareRecruitmentData, Complete)
      if Complete then
        Complete(true)
      end
    end
  })
end

function M:GetModel()
  return TeamHallModel
end

function M:GetEventName()
  return EventID.TeamHallControllerEvent
end

function M:_GreenPrintRecruitmentLog(Stage, Payload)
  if not IsTeamHallVerboseLogEnabled() then
    return
  end
  MiscUtils.GreenPrint("TeamHallController", Stage, TableToLogString(Payload))
end

function M:_ScreenPrintRequestSource(Message)
  if not IsTeamHallSourceTraceEnabled() or not ScreenPrint then
    return
  end
  ScreenPrint(BuildSourceTraceText(Message))
end

function M:_ScreenPrintRecruitmentTrace(Request, Stage, Extra)
  local Message = string.format("#%s[%s] src=%s tags=%s", tostring(Request and Request.TraceId or "-"), tostring(Stage or "-"), tostring(Request and Request.Source or "Unknown"), BuildFiltersBrief(Request and Request.Filters or nil))
  if Extra and "" ~= Extra then
    Message = Message .. " " .. tostring(Extra)
  end
  self:_ScreenPrintRequestSource(Message)
end

function M:SetHallData(RawData)
  self:GetModel():SetRawHallData(RawData)
  local HallData = self:GetModel():GetHallData()
  self:NotifyEvent(TeamHallCommon.EventId.HallDataChanged, HallData and HallData:GetRecruitmentList() or {}, HallData)
end

function M:RemoveExpiredRecruitment(RecruitmentId)
  local ExpectedRecruitmentId = ToInteger(RecruitmentId)
  if not ExpectedRecruitmentId then
    return false
  end
  local HallData = self:GetModel():GetHallData()
  local RecruitmentList = HallData and HallData:GetRecruitmentList() or nil
  if not RecruitmentList then
    return false
  end
  for Index, RecruitmentData in ipairs(RecruitmentList) do
    if IsSameInteger(RecruitmentData and RecruitmentData.RecruitmentId, ExpectedRecruitmentId) then
      table.remove(RecruitmentList, Index)
      if HallData.RawData then
        table.remove(HallData.RawData, Index)
      end
      self:NotifyEvent(TeamHallCommon.EventId.RecruitmentExpired, ExpectedRecruitmentId)
      return true
    end
  end
  return false
end

function M:ClearHallData()
  self:GetModel():ClearHallData()
  self:NotifyEvent(TeamHallCommon.EventId.HallDataCleared)
end

function M:GetTeamRequestList()
  return self:GetModel():GetTeamRequestList()
end

function M:PublishDefaultRecruitment(FirstTypeId, Callback)
  local Avatar = self:GetAvatar()
  local RecruitmentInfo = self:GetModel():BuildDefaultRecruitmentInfo(FirstTypeId)
  self:_GreenPrintRecruitmentLog("PublishDefaultRecruitment.Prepare", {FirstTypeId = FirstTypeId, RecruitmentInfo = RecruitmentInfo})
  if not (Avatar and Avatar.PublishRecruitmentInTeamHall) or not RecruitmentInfo then
    self:_GreenPrintRecruitmentLog("PublishDefaultRecruitment.Abort", {
      HasAvatar = nil ~= Avatar,
      HasRpc = Avatar and Avatar.PublishRecruitmentInTeamHall ~= nil or false,
      RecruitmentInfo = RecruitmentInfo
    })
    return false
  end
  Avatar:PublishRecruitmentInTeamHall(function()
    RecruitmentInfo.RecruitStartTime = TimeUtils.NowTime()
    self:_GreenPrintRecruitmentLog("PublishDefaultRecruitment.Success", RecruitmentInfo)
    self:GetModel():SetLocalRecruitmentInfo(RecruitmentInfo)
    self:SetTeamHallRecruitmentStartTime(RecruitmentInfo.RecruitStartTime)
    if Callback then
      Callback(RecruitmentInfo)
    end
  end, RecruitmentInfo)
  return true
end

function M:CancelRecruitment(Callback)
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.CancelRecruitmentInTeamHall then
    return false
  end
  Avatar:CancelRecruitmentInTeamHall(function()
    self:GetModel():ClearLocalRecruitmentInfo()
    self:ClearTeamHallRecruitmentStartTime()
    self:_StartRecruitmentPublishCooldown()
    self:RequestRecruitmentList(function()
      if Callback then
        Callback()
      end
    end, self:_GetCurrentRecruitmentFilters(), "CancelRecruitment")
  end)
  return true
end

function M:RequestRecruitmentList(RefreshFunc, Filters, Source)
  local Avatar = self:GetAvatar()
  self:_TryRecoverRecruitmentListRefreshState()
  self.RecruitmentRequestTraceId = (self.RecruitmentRequestTraceId or 0) + 1
  local Request = {
    Filters = Filters or {},
    RefreshFunc = RefreshFunc,
    RetryCount = 0,
    Source = Source or "Unknown",
    TraceId = self.RecruitmentRequestTraceId
  }
  self:_GreenPrintRecruitmentLog("RequestRecruitmentList.Enqueue", {
    Filters = Request.Filters,
    bRequesting = self.bRecruitmentListRequesting,
    bCoolingDown = self.bRecruitmentListCoolingDown,
    HasRefreshFunc = nil ~= RefreshFunc,
    Source = Request.Source
  })
  if not Avatar or not Avatar.RefreshTeamHallList then
    self:_GreenPrintRecruitmentLog("RequestRecruitmentList.Abort", {
      HasAvatar = nil ~= Avatar,
      HasRpc = Avatar and nil ~= Avatar.RefreshTeamHallList or false,
      Filters = Request.Filters,
      Source = Request.Source
    })
    self:_ScreenPrintRecruitmentTrace(Request, "ABORT", "reason=no_rpc")
    self:NotifyEvent(TeamHallCommon.EventId.RequestFailed, nil, Request.Filters)
    return
  end
  if self.bRecruitmentListRequesting or self.bRecruitmentListCoolingDown then
    self.PendingRecruitmentListRequest = Request
    self:_GreenPrintRecruitmentLog("RequestRecruitmentList.Pending", {
      Filters = Request.Filters,
      bRequesting = self.bRecruitmentListRequesting,
      bCoolingDown = self.bRecruitmentListCoolingDown,
      Source = Request.Source
    })
    self:_ScreenPrintRecruitmentTrace(Request, "QUEUE", "wait=" .. BuildPendingReason(self.bRecruitmentListRequesting, self.bRecruitmentListCoolingDown))
    return
  end
  self:_RequestRecruitmentListNow(Request)
end

function M:GetFiltterTeamInfo(RefreshFunc, Filters)
  self:RequestRecruitmentList(RefreshFunc, Filters, "LegacyGetFiltterTeamInfo")
end

function M:CanManualRefreshRecruitmentList()
  self:_TryRecoverRecruitmentListRefreshState()
  return not self.bRecruitmentListRequesting and not self.bRecruitmentListCoolingDown
end

function M:EnsureTeamRequestReddotNode()
  if not ReddotManager.GetTreeNode(TeamRequestReddotName) then
    ReddotManager.AddNodeEx(TeamRequestReddotName)
  end
end

function M:OnAvatarStatusUpdate(OldStatus, NewStatus)
  self:_SyncTeamRecruitingState()
end

function M:OnTeamRecruitingStateBridge(bSuppressCancelRecruitmentToast)
  self:_SyncTeamRecruitingState(bSuppressCancelRecruitmentToast)
end

function M:_SyncTeamRecruitingState(bSuppressCancelRecruitmentToast)
  local HallModel = self:GetModel()
  local bNewRecruiting = HallModel:IsTeamInRecruiting()
  local bStateChanged = self.bLastTeamRecruitingState ~= bNewRecruiting
  local bNeedClearLocalRecruitment = not bNewRecruiting and HallModel:HasLocalRecruitmentInfo()
  if not bStateChanged and not bNeedClearLocalRecruitment then
    return
  end
  self.bLastTeamRecruitingState = bNewRecruiting
  if bStateChanged and not bNewRecruiting and not bSuppressCancelRecruitmentToast then
    self:ShowToast(GText("UI_TeamHall_CancelRecruitment"))
  end
  if bNeedClearLocalRecruitment then
    HallModel:ClearLocalRecruitmentInfo()
    self:ClearTeamRequestReddot()
  end
  self:NotifyEvent(TeamHallCommon.EventId.RecruitmentStateChanged, bNewRecruiting)
end

function M:OnTeamRequestListChanged()
  local CurrentTeamRequestList = self:GetTeamRequestList()
  if not self:GetModel():IsRecruiting() then
    self:ClearTeamRequestReddot()
  end
  self:NotifyEvent(TeamHallCommon.EventId.TeamRequestListChanged)
end

function M:OnTeamRequestReceived(TeamJoinInfo)
  if not self:GetModel():IsRecruiting() then
    return
  end
  local Uid = TeamJoinInfo and TeamJoinInfo.Uid
  if not Uid then
    return
  end
  self:_TryAddTeamRequestReddot(Uid)
  self:NotifyEvent(TeamHallCommon.EventId.TeamRequestNew)
  local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  local IsHide = false
  local IsInRouge = self:GetAvatar():IsInRougeLike()
  local IsInDG = self:GetAvatar():IsInDungeon()
  local IsInHB = self:GetAvatar():IsInHardBoss()
  IsHide = IsInRouge or IsInDG or IsInHB
  if not IsHide then
    self:RecvTeamBeInvited(TeamJoinInfo)
  end
end

function M:RecvTeamBeInvited(InviteInfo)
  InviteQueueManager:EnqueueInvite({
    Type = InviteQueueManager.InviteType.TeamHall,
    Uid = InviteInfo.Uid,
    Nickname = InviteInfo.Nickname,
    Level = InviteInfo.Level,
    HeadIconId = InviteInfo.HeadIconId,
    HeadFrameId = InviteInfo.HeadFrameId,
    MaxRemainTime = GlobalConstant.TeamInviteStayTime.ConstantValue,
    OnAccept = function()
      self:SendTeamAgreeInvite(InviteInfo.Uid)
    end,
    OnRefuse = function(bAutoRefuse)
      self:SendTeamRefuseInvite(bAutoRefuse)
    end,
    OnTimeout = function()
      self:SendTeamRefuseInvite(false)
    end
  })
end

function M:SendTeamAgreeInvite(Uid)
  self:GetAvatar():ApprovalTeamRequest(nil, Uid, true)
  InviteQueueManager:FinishCurrentInvite(InviteQueueManager.InviteType.TeamHall)
end

function M:SendTeamRefuseInvite(bAutoRefuse)
  local InviteInfo = InviteQueueManager:GetCurrentInvite()
  
  local function Callback(ret)
  end
  
  local Uid = InviteInfo.Uid
  self:GetAvatar():ApprovalTeamRequest(Callback, Uid, false, bAutoRefuse)
  InviteQueueManager:FinishCurrentInvite(InviteQueueManager.InviteType.TeamHall)
end

function M:OnTeamRequestHandled(Uid, bAgree)
  if not Uid then
    return
  end
  self:_TryClearTeamRequestReddot(Uid)
  if bAgree then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("TeamHall_SuccessJoinTeam"))
  end
end

function M:OnTeamRequestPanelClosed()
  self:ClearTeamRequestReddot()
  self:NotifyEvent(TeamHallCommon.EventId.TeamRequestPanelClosed)
end

function M:ClearTeamRequestReddot()
  self:EnsureTeamRequestReddotNode()
  ReddotManager.ClearLeafNodeCount(TeamRequestReddotName, true)
end

function M:OnAvatarLogout()
  self:StopTimer(RecruitmentPublishCooldownTimerKey)
  self.RecruitmentPublishCooldownEndTime = 0
  self:GetModel():ClearLocalRecruitmentInfo()
  self.bLastTeamRecruitingState = false
end

function M:Destory()
  EventManager:RemoveEvent(EventID.OnAvatarStatusUpdate, self)
  EventManager:RemoveEvent(EventID.OnAvatarLogout, self)
  self:StopTimer(RecruitmentListRefreshTimerKey)
  self:StopTimer(RecruitmentPublishCooldownTimerKey)
  self.PendingRecruitmentListRequest = nil
  self.RecruitmentListRefreshCooldownEndTime = 0
  self.RecruitmentPublishCooldownEndTime = 0
  self:GetModel():ClearLocalRecruitmentInfo()
  self.bLastTeamRecruitingState = false
  self:_SetRecruitmentListRequesting(false)
  self:_SetRecruitmentListCoolingDown(false)
  self:ClearTeamRequestReddot()
  M.Super.Destory(self)
end

function M:_StartRecruitmentPublishCooldown()
  local GlobalConstant = DataMgr.GlobalConstant or {}
  local CooldownConfig = GlobalConstant.TeamRecruitmentCD
  local CooldownSeconds = CooldownConfig and CooldownConfig.ConstantValue or 0
  self:StopTimer(RecruitmentPublishCooldownTimerKey)
  self.RecruitmentPublishCooldownEndTime = CooldownSeconds > 0 and TimeUtils.NowTime() + CooldownSeconds or 0
  if CooldownSeconds <= 0 then
    self:NotifyEvent(TeamHallCommon.EventId.RecruitmentPublishCooldownStateChanged)
    return
  end
  self:AddTimer(CooldownSeconds, function()
    self:_OnRecruitmentPublishCooldownReady()
  end, false, 0, RecruitmentPublishCooldownTimerKey, true)
  self:NotifyEvent(TeamHallCommon.EventId.RecruitmentPublishCooldownStateChanged)
end

function M:_OnRecruitmentPublishCooldownReady()
  if self:IsRecruitmentPublishCoolingDown() then
    local RemainingTime = math.max((self.RecruitmentPublishCooldownEndTime or 0) - TimeUtils.NowTime(), 0)
    self:AddTimer(RemainingTime, function()
      self:_OnRecruitmentPublishCooldownReady()
    end, false, 0, RecruitmentPublishCooldownTimerKey, true)
    return
  end
  self.RecruitmentPublishCooldownEndTime = 0
  self:NotifyEvent(TeamHallCommon.EventId.RecruitmentPublishCooldownStateChanged)
end

function M:_RequestRecruitmentListNow(Request)
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.RefreshTeamHallList then
    self.PendingRecruitmentListRequest = nil
    self:_SetRecruitmentListRequesting(false)
    self:_SetRecruitmentListCoolingDown(false)
    self:_GreenPrintRecruitmentLog("RequestRecruitmentList.SendAbort", {
      HasAvatar = nil ~= Avatar,
      HasRpc = Avatar and Avatar.RefreshTeamHallList ~= nil or false,
      Request = Request
    })
    self:_ScreenPrintRecruitmentTrace(Request, "ABORT", "reason=no_rpc")
    self:NotifyEvent(TeamHallCommon.EventId.RequestFailed, nil, Request and Request.Filters or nil)
    return
  end
  Request = Request or {}
  Request.Filters = Request.Filters or {}
  Request.RetryCount = Request.RetryCount or 0
  Request.Source = Request.Source or "Unknown"
  self:_GreenPrintRecruitmentLog("RequestRecruitmentList.Send", {
    Filters = Request.Filters,
    RetryCount = Request.RetryCount,
    PendingFilters = self.PendingRecruitmentListRequest and self.PendingRecruitmentListRequest.Filters or nil,
    Source = Request.Source
  })
  self:_ScreenPrintRecruitmentTrace(Request, "SEND", "retry=" .. tostring(Request.RetryCount))
  self:_SetRecruitmentListRequesting(true)
  Avatar:RefreshTeamHallList(function(ErrCode, RawData)
    self:_GreenPrintRecruitmentLog("RequestRecruitmentList.Response", {
      ErrCode = ErrCode,
      Filters = Request.Filters,
      RetryCount = Request.RetryCount,
      Source = Request.Source
    })
    self:_SetRecruitmentListRequesting(false)
    if ErrCode == ErrorCode.RET_TEAM_HALL_REFRESH_FREQUENTLY and Request.RetryCount < 1 then
      if self:_IsOutdatedRecruitmentRequest(Request) then
        return
      end
      Request.RetryCount = Request.RetryCount + 1
      if not self.PendingRecruitmentListRequest then
        self.PendingRecruitmentListRequest = Request
      end
      self:_GreenPrintRecruitmentLog("RequestRecruitmentList.RetryPending", {
        Filters = Request.Filters,
        RetryCount = Request.RetryCount,
        Source = Request.Source
      })
      self:_ScreenPrintRecruitmentTrace(Request, "FREQ", "retry_in=" .. tostring(self:_GetRecruitmentListRefreshCD()))
      self:_StartRecruitmentListRefreshCooldown()
      return
    end
    self:_StartRecruitmentListRefreshCooldown()
    if not self:CheckError(ErrCode, true) then
      self:_ScreenPrintRecruitmentTrace(Request, "FAIL", "err=" .. tostring(ErrCode))
      self:NotifyEvent(TeamHallCommon.EventId.RequestFailed, ErrCode, Request.Filters)
      return
    end
    self.LastRecruitmentListSuccessTraceId = math.max(self.LastRecruitmentListSuccessTraceId or 0, Request.TraceId or 0)
    self:_DiscardOutdatedPendingRecruitmentRequest()
    self:SetHallData(RawData)
    local HallData = self:GetModel():GetHallData()
    local RecruitmentList = HallData and HallData:GetRecruitmentList() or {}
    self:_ScreenPrintRecruitmentTrace(Request, "OK", string.format("count=%s cd=%s", tostring(#RecruitmentList), tostring(self:_GetRecruitmentListRefreshCD())))
    if Request.RefreshFunc then
      Request.RefreshFunc(HallData and HallData:GetRecruitmentList() or {}, HallData, Request.Filters)
    end
  end, Request.Filters)
end

function M:_StartRecruitmentListRefreshCooldown()
  local RefreshCD = self:_GetRecruitmentListRefreshCD()
  local Now = TimeUtils.NowTime()
  self:StopTimer(RecruitmentListRefreshTimerKey)
  self.RecruitmentListRefreshCooldownEndTime = RefreshCD > 0 and Now + RefreshCD or 0
  self:_SetRecruitmentListCoolingDown(RefreshCD > 0)
  if RefreshCD > 0 then
    self:AddTimer(RefreshCD, function()
      self:_OnRecruitmentListRefreshCooldownReady()
    end, false, 0, RecruitmentListRefreshTimerKey, true)
    return
  end
  self:_OnRecruitmentListRefreshCooldownReady()
end

function M:_OnRecruitmentListRefreshCooldownReady()
  if self:_IsRecruitmentListCoolingDown() then
    self:_EnsureRecruitmentListCooldownTimer()
    return
  end
  self.RecruitmentListRefreshCooldownEndTime = 0
  self:_DiscardOutdatedPendingRecruitmentRequest()
  local PendingRequest = self.PendingRecruitmentListRequest
  if PendingRequest then
    self.PendingRecruitmentListRequest = nil
    self:_RequestRecruitmentListNow(PendingRequest)
    return
  end
  self:_SetRecruitmentListCoolingDown(false)
end

function M:_TryRecoverRecruitmentListRefreshState()
  if self.bRecruitmentListRequesting then
    return
  end
  local bShouldCoolingDown = self:_IsRecruitmentListCoolingDown()
  if self.bRecruitmentListCoolingDown ~= bShouldCoolingDown then
    self:_SetRecruitmentListCoolingDown(bShouldCoolingDown)
  end
  if not bShouldCoolingDown then
    self.RecruitmentListRefreshCooldownEndTime = 0
    return
  end
  self:_EnsureRecruitmentListCooldownTimer()
end

function M:_GetRecruitmentListRefreshCD()
  local GlobalConstant = DataMgr.GlobalConstant or {}
  local RefreshCD = GlobalConstant.TeamListRefreshCD
  return RefreshCD and RefreshCD.ConstantValue or 0
end

function M:_SetRecruitmentListCoolingDown(bCoolingDown)
  local bNewState = bCoolingDown and true or false
  if self.bRecruitmentListCoolingDown == bNewState then
    return
  end
  self.bRecruitmentListCoolingDown = bNewState
  self:_NotifyRecruitmentListRefreshStateChanged()
end

function M:_SetRecruitmentListRequesting(bRequesting)
  local bNewState = bRequesting and true or false
  if self.bRecruitmentListRequesting == bNewState then
    return
  end
  self.bRecruitmentListRequesting = bNewState
  self:_NotifyRecruitmentListRefreshStateChanged()
end

function M:_NotifyRecruitmentListRefreshStateChanged()
  self:NotifyEvent(TeamHallCommon.EventId.RecruitmentListRefreshStateChanged, self.bRecruitmentListRequesting or self.bRecruitmentListCoolingDown)
end

function M:_TryAddTeamRequestReddot(Uid)
  self:EnsureTeamRequestReddotNode()
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(TeamRequestReddotName)
  local CacheKey = self:_GetTeamRequestReddotCacheKey(Uid)
  if not CacheDetail or CacheDetail[CacheKey] then
    return
  end
  CacheDetail[CacheKey] = true
  ReddotManager.IncreaseLeafNodeCount(TeamRequestReddotName, 1, {CacheKey = CacheKey})
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(TeamRequestReddotName)
end

function M:_TryClearTeamRequestReddot(Uid)
  self:EnsureTeamRequestReddotNode()
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(TeamRequestReddotName)
  local CacheKey = self:_GetTeamRequestReddotCacheKey(Uid)
  if not CacheDetail or not CacheDetail[CacheKey] then
    return
  end
  CacheDetail[CacheKey] = nil
  ReddotManager.DecreaseLeafNodeCount(TeamRequestReddotName, 1, {CacheKey = CacheKey})
end

function M:_GetTeamRequestReddotCacheKey(Uid)
  return Uid
end

function M:_IsRecruitmentListCoolingDown()
  local CooldownEndTime = self.RecruitmentListRefreshCooldownEndTime or 0
  return CooldownEndTime > 0 and CooldownEndTime > TimeUtils.NowTime()
end

function M:_EnsureRecruitmentListCooldownTimer()
  if not self:_IsRecruitmentListCoolingDown() then
    return
  end
  if self:IsExistTimer(RecruitmentListRefreshTimerKey) then
    return
  end
  local RemainingTime = math.max((self.RecruitmentListRefreshCooldownEndTime or 0) - TimeUtils.NowTime(), 0)
  if RemainingTime <= 0 then
    self:_OnRecruitmentListRefreshCooldownReady()
    return
  end
  self:AddTimer(RemainingTime, function()
    self:_OnRecruitmentListRefreshCooldownReady()
  end, false, 0, RecruitmentListRefreshTimerKey, true)
end

function M:_IsOutdatedRecruitmentRequest(Request)
  if not Request or not Request.TraceId then
    return false
  end
  return Request.TraceId < (self.LastRecruitmentListSuccessTraceId or 0)
end

function M:_DiscardOutdatedPendingRecruitmentRequest()
  if not self:_IsOutdatedRecruitmentRequest(self.PendingRecruitmentListRequest) then
    return
  end
  self.PendingRecruitmentListRequest = nil
end

_G.TeamHallController = M
return M
