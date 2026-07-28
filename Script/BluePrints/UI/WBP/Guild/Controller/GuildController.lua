local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildFullInfo = GuildDatas.GuildFullInfo
local GuildBaseInfo = require("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local M = Class("BluePrints.Common.MVC.Controller")
M._components = {
  "BluePrints.UI.WBP.Guild.Controller.GuildController_ManagerOpComp",
  "BluePrints.UI.WBP.Guild.Controller.GuildController_VisitorOpComp",
  "BluePrints.UI.WBP.Guild.Controller.GuildController_ChatComp"
}

function M:OnInit()
end

function M:OnDestory()
end

function M:OnOpenView(ViewObj)
end

function M:OnGuildIdChanged(GuildId)
end

function M:Init()
  M.Super.Init(self)
  self:OnInit()
  EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
end

function M:Destory()
  self:OnDestory()
  M.Super.Destory(self)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
end

function M:OnCloseLoading()
  if not self:GetAvatar() then
    return
  end
  local GuildId = self:GetAvatar().GuildId
  self:UpdateCurrGuildCommon(ErrorCode.RET_SUCCESS, GuildId)
  self:SendGuildGetList()
end

function M:GetModel()
  return GuildModel
end

function M:GetEventName()
  return EventID.GuildControllerEvent
end

function M:OpenView(WorldContext, ViewNameOrMainUIId, ...)
  local ViewObj = M.Super.OpenView(self, WorldContext, ViewNameOrMainUIId, ...)
  self:OnOpenView(ViewObj)
  return ViewObj
end

function M:OpenGuildDetailPopup(WorldContext, GuildId)
  GuildId = tonumber(GuildId or 0) or 0
  if GuildId <= 0 then
    self:ShowToast(GText("CannotViewGuildDetails"))
    return
  end
  return M.Super.OpenView(self, self:GetUIMgr(), GuildCommon.CheckGuildPage, GuildId)
end

function M:RecvCommon(RetCode, EventId, ...)
  RetCode = RetCode or ErrorCode.RET_SUCCESS
  local IsShowTip = true
  if EventId == GuildCommon.EventID.OnGuildSearch then
    IsShowTip = false
  end
  if not self:CheckError(RetCode, IsShowTip) then
    return
  end
  if EventId then
    self:NotifyEvent(EventId, ...)
  end
end

function M:RecvParam(RetCode, EventId, LeftTime, bInvited)
  RetCode = RetCode or ErrorCode.RET_SUCCESS
  if not self:CheckError(RetCode, nil, LeftTime) then
    return
  end
  if EventId then
    self:NotifyEvent(EventId, bInvited)
  end
end

function M:SendGetGuildInfo(GuildId)
  GuildId = GuildId or self:GetAvatar().GuildId
  if not GuildId then
    DebugPrint(ErrorTag, "SendGetGuildInfo:没有公会ID")
    return
  end
  self:GetAvatar():GetGuildInfo(nil, GuildId)
end

function M:RecvGetGuildInfo(SrcParams, Ret, ServerGuildInfo)
  local Info
  local GuildId = table.unpack(SrcParams)
  if Ret == ErrorCode.RET_SUCCESS then
    Info = GuildFullInfo.New(ServerGuildInfo)
    if GuildId == self:GetAvatar().GuildId then
      self.GetModel():SetCurrGuild(Info)
      ChatController:LoadGuildChannelSnapshot(nil, Info.GuildMessages, Info.GuildId)
    end
  else
    self:NotifyEvent(GuildCommon.EventID.OnGetGuildInfoFail, GuildId)
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGetGuildInfo, Info)
end

function M:SendGetGuildSimpleInfo(GuildId)
  self:GetAvatar():GetGuildSimpleInfo(nil, GuildId)
end

function M:RecvGetGuildSimpleInfo(SrcParams, Ret, ServerGuildSimpleInfo)
  local Info = GuildBaseInfo.New(ServerGuildSimpleInfo)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGetGuildSimpleInfo, Info)
end

function M:UpdateCurrGuildCommon(Ret, GuildId)
  if Ret == ErrorCode.RET_SUCCESS then
    local CurrGuild = self:GetModel():GetCurrGuild()
    if not GuildId and CurrGuild then
      GuildId = CurrGuild.GuildId
    end
    if not self:GetModel():IsInGuild() then
      self:GetModel():SetCurrGuild(nil)
    else
      self:SendGetGuildInfo(GuildId, true)
    end
  end
end

function M:UpdateCurrGuildProp(Ret, PropName, NewValueOrCb)
  if self:GetModel():UpdateCurrGuildProp(Ret, PropName, NewValueOrCb) then
    local Info = self:GetModel():GetCurrGuild()
    self:RecvCommon(Ret, GuildCommon.EventID.OnGetGuildInfo, Info)
  end
end

function M:RecvGuildIdChanged(SrcParams, GuildId)
  self:OnGuildIdChanged(GuildId)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildIdChanged, GuildId)
end

function M:OpenGuildEditView(ConfirmCallbackInfo)
  M.Super.OpenView(self, self:GetUIMgr(), "GuildEditLogo", ConfirmCallbackInfo)
end

function M:OpenGuildJoinView(ConfirmCallbackInfo)
  M.Super.OpenView(self, self:GetUIMgr(), "GuildMain", ConfirmCallbackInfo)
end

function M:SendRpcGetGuildActivityPointReward(ActivityPoint)
  local MaxActiPointStage = 0
  for ActiPointStage, Data in pairs(DataMgr.GuildWeekReward) do
    if ActiPointStage <= ActivityPoint then
      MaxActiPointStage = math.max(MaxActiPointStage, ActiPointStage)
    end
  end
  self:GetAvatar():RpcGetGuildActivityPointReward(nil, MaxActiPointStage)
end

function M:RecvRpcGetGuildActivityPointReward(SrcParams, Ret, RewardBox)
  if Ret == ErrorCode.RET_SUCCESS then
    GuildModel:TryClearReddotCount("GuildWeekActivity")
    local ActivityPoint = table.unpack(SrcParams)
    if ActivityPoint >= GuildCommon.MaxActivityPoint then
      GuildModel:TryClearReddotCount("GuildTaskHub")
    end
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildActivityPointReward, RewardBox)
end

function M:ShowJobLevelView(MemberUid, MemberGuildFullInfo, LastChangeJobLevel)
  local Params = {
    MemberUid = MemberUid,
    MemberGuildFullInfo = MemberGuildFullInfo,
    LastChangeJobLevel = LastChangeJobLevel,
    RightCallbackFunction = function(_, FirstData, FirstPopUIWidget)
      local CurJobLevel = FirstPopUIWidget.Contents[1]:GetCurJobLevel()
      local ChangeJobLevel = FirstPopUIWidget.Contents[1]:GetChangeJobLevel()
      local GuildFullInfo = FirstPopUIWidget.Contents[1]:GetGuildFullInfo()
      self.AdjustMemberRoleInfo = {
        CurJobLevel = CurJobLevel,
        ChangeJobLevel = ChangeJobLevel,
        TargetUid = MemberUid,
        GuildFullIndo = GuildFullInfo
      }
      self:ShowChangeJobLevelConfirmView()
    end
  }
  GWorld.GameInstance:GetGameUIManager():ShowCommonPopupUI(GuildCommon.GuildRole, Params)
end

function M:ShowChangeJobLevelConfirmView()
  local CurJobTitleName = GText(DataMgr.GuildTitle[self.AdjustMemberRoleInfo.CurJobLevel].TitleName)
  local ChangeJobTitleName = GText(DataMgr.GuildTitle[self.AdjustMemberRoleInfo.ChangeJobLevel].TitleName)
  local Params = {
    LeftCallbackFunction = function()
      GuildController:ShowJobLevelView(self.AdjustMemberRoleInfo.TargetUid, self.AdjustMemberRoleInfo.GuildFullIndo, self.AdjustMemberRoleInfo.ChangeJobLevel)
      self.AdjustMemberRoleInfo = nil
    end,
    RightCallbackFunction = function()
      if 5 == self.AdjustMemberRoleInfo.ChangeJobLevel then
        GuildController:SendGuildSetOwner(self.AdjustMemberRoleInfo.TargetUid, self.AdjustMemberRoleInfo.ChangeJobLevel)
      else
        GuildController:SendGuildSetTitle(self.AdjustMemberRoleInfo.TargetUid, self.AdjustMemberRoleInfo.ChangeJobLevel)
      end
      self.AdjustMemberRoleInfo = nil
    end,
    ShortText = string.format(GText("UI_ConfirmRoleAdjustment"), CurJobTitleName, ChangeJobTitleName)
  }
  GWorld.GameInstance:GetGameUIManager():ShowCommonPopupUI(GuildCommon.GuildJobLevelChange, Params)
end

function M.GetGuildMember(Members, CurUid)
  for _, Member in pairs(Members) do
    if Member.Uid == CurUid then
      return Member
    end
  end
end

function M:NotifyGuildPropChanged(SrcParams, PropName, NewValue, OldValue, GuildInfo, ChangeKeys)
  local CurrGuild = self:GetModel():GetCurrGuild()
  if "Members" == PropName then
    if not CurrGuild then
      return
    end
    self:UpdateCurrGuildProp(ErrorCode.RET_SUCCESS, "Members", function()
      CurrGuild.Members = {}
      for i, MemberInfo in pairs(CommonUtils.BinaryDump(NewValue)) do
        CurrGuild:AddMember(MemberInfo)
      end
      return CurrGuild.Members
    end)
  elseif "MemberCount" == PropName then
    if not CurrGuild then
      return
    end
    CurrGuild.MemberCount = NewValue
  end
end

AssembleComponents(M)
_G.GuildController = M
return M
