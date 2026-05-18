local GuildBaseInfo = require("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildRequestInfo = GuildDatas.GuildRequestInfo
local GuildListInfo = GuildDatas.GuildListInfo
local InviteQueueManager = require("BluePrints.UI.Common.InviteQueueManager")
local Component = {}

function Component:OnInit()
  self.GuildGetListTimer = nil
  self.GuildSearchTimer = nil
  self.GetGuildIdListTimestamp = 0
end

function Component:OnDestory()
end

function Component:OnOpenView(ViewObj)
end

function Component:OnGuildIdChanged(GuildId)
end

function Component:SendRequestJoinGuild(GuildId, bInvited)
  if true == bInvited then
    bInvited = 1
  else
    bInvited = 0
  end
  self:GetAvatar():RequestJoinGuild(nil, GuildId, bInvited)
end

function Component:RecvRequestJoinGuild(SrcParams, Ret)
  local GuildId, bInvited = table.unpack(SrcParams)
  local Param
  if Ret == ErrorCode.RET_SUCCESS then
    InviteQueueManager:FinishCurrentInvite(InviteQueueManager.InviteType.Guild)
    if 1 == bInvited then
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("AlreadyInThisGuild"))
    else
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_ApplicationAlreadySent"))
    end
  elseif Ret == ErrorCode.RET_GUILD_REQUEST_JOIN_CD then
    local Avatar = GWorld:GetAvatar()
    local RequestJoinTime = Avatar.RequestJoinGuildTime[SrcParams[1]]
    Param = UIUtils.GetLeftTimeStrStyle1(RequestJoinTime + GuildCommon.RequestJoinCD, TimeUtils.NowTime())
  elseif Ret == ErrorCode.RET_GUILD_REJECTED_JOIN_CD then
    local Avatar = GWorld:GetAvatar()
    local RequestJoinTime = Avatar.RejectedJoinGuildRecord[SrcParams[1]]
    Param = UIUtils.GetLeftTimeStrStyle1(RequestJoinTime + GuildCommon.RejectedJoinCD, TimeUtils.NowTime())
  elseif Ret == ErrorCode.RET_GUILD_QUIT_GUILD_CD then
    local Avatar = GWorld:GetAvatar()
    local RequestJoinTime = Avatar.LastQuitGuildTime
    Param = UIUtils.GetLeftTimeStrStyle1(RequestJoinTime + GuildCommon.QuitGuildCD, TimeUtils.NowTime())
  end
  self:RecvParam(Ret, GuildCommon.EventID.OnRequestJoinGuild, Param, bInvited)
end

function Component:SendRequestJoinGuildBatch(GuildIds)
  self:GetAvatar():RequestJoinGuildBatch(nil, GuildIds)
end

function Component:RecvRequestJoinGuildBatch(SrcParams, Ret)
  if Ret == ErrorCode.RET_SUCCESS then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_ApplicationAlreadySent"))
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnRequestJoinGuildBatch)
end

function Component:SendGuildLeave()
  self:GetAvatar():GuildLeave(nil)
end

function Component:RecvGuildLeave(SrcParams, Ret)
  if Ret == ErrorCode.RET_SUCCESS and self:GetModel():GetCurrGuild() then
    self:GetModel():SetCurrGuild(nil)
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildLeave)
end

function Component:SendGuildGetList()
  if self:IsExistTimer(self.GuildGetListTimer) then
    return
  end
  local NowTime = TimeUtils.NowTime()
  if not self.GetGuildIdListTimestamp then
    self.GetGuildIdListTimestamp = 0
  end
  if NowTime - self.GetGuildIdListTimestamp > GuildCommon.GuildIdListRefreshSec then
    self:GetAvatar():GuildGetList(nil)
    self.GetGuildIdListTimestamp = NowTime
    return false
  else
    self:RecvGuildGetList(nil, ErrorCode.RET_SUCCESS, self:GetModel().SortedGuildList, self:GetModel().FriendGuildList)
    return true
  end
end

function Component:RecvGuildGetList(SrcParams, Ret, GuildList, FriendGuildList)
  if Ret == ErrorCode.RET_SUCCESS then
    self:GetModel():CacheGuildIdList(GuildList, FriendGuildList)
    local PickedGuildIds = self:GetModel():PickGuildIdFromList()
    self:SendGetGuildSimpleInfoBatch(PickedGuildIds)
  else
    self:CheckError(Ret)
  end
end

function Component:SendGetGuildSimpleInfoBatch(GuildIds)
  self:GetAvatar():GetGuildSimpleInfoBatch(nil, GuildIds)
end

function Component:RecvGetGuildSimpleInfoBatch(SrcParams, Ret, GuildInfos)
  local GuildList
  if Ret == ErrorCode.RET_SUCCESS then
    self:GetModel():SetGuildList(GuildInfos)
    GuildList = self:GetModel():GetGuildList()
    self:_SetTimerForGuildGetList()
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildGetList, GuildList)
end

function Component:_SetTimerForGuildGetList()
  local Interval = GuildCommon.GuildGetListCDInterval
  local TotalTime = GuildCommon.GuildListMinRefreshSec + 0.1
  local Timer = self:AddTimer(Interval, function()
    TotalTime = TotalTime - Interval
    if TotalTime <= 0 then
      self:NotifyEvent(GuildCommon.EventID.OnGuildGetListCDTick, 0)
      self:StopTimer(self.GuildGetListTimer)
      self.GuildGetListTimer = nil
    end
    local Percent = TotalTime / GuildCommon.GuildListMinRefreshSec
    self:NotifyEvent(GuildCommon.EventID.OnGuildGetListCDTick, Percent)
  end, true, 0, nil, true)
  self.GuildGetListTimer = Timer
end

function Component:SendGuildSearch(Keyword)
  self:GetAvatar():GuildSearch(nil, Keyword)
end

function Component:RecvGuildSearch(SrcParams, Ret, ServerGuildInfo)
  local GuildList
  if Ret == ErrorCode.RET_SUCCESS then
    self:GetModel():SetGuildSearchRes({ServerGuildInfo})
    GuildList = self:GetModel():GetGuildSearchRes()
    self:_SetTimerForGuildSearch()
  else
    self:NotifyEvent(GuildCommon.EventID.OnGuildSearchFail)
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSearch, GuildList)
end

function Component:_SetTimerForGuildSearch()
  local Interval = GuildCommon.GuildGetListCDInterval
  local TotalTime = GuildCommon.GuildListMinRefreshSec + 0.1
  local Timer = self:AddTimer(Interval, function()
    TotalTime = TotalTime - Interval
    if TotalTime <= 0 then
      self:NotifyEvent(GuildCommon.EventID.OnGuildSearchCDTick, 0)
      self:StopTimer(self.GuildSearchTimer)
      self.GuildSearchTimer = nil
    end
    local Percent = TotalTime / GuildCommon.GuildListMinRefreshSec
    self:NotifyEvent(GuildCommon.EventID.OnGuildSearchCDTick, Percent)
  end, true, 0, nil, true)
  self.GuildSearchTimer = Timer
end

function Component:SendGuildReport(GuildId, ReasonType, ReportText)
  self:GetAvatar():GuildReport(nil, GuildId, ReasonType, ReportText)
end

function Component:ShowGuildReportRetTip(Ret)
  Ret = Ret or ErrorCode.RET_SUCCESS
  if not self:CheckError(Ret) then
    return false
  end
  self:ShowToast(GText("UI_Chat_ReportSuccess"))
  return true
end

function Component:RecvGuildReport(SrcParams, Ret)
  if not self:ShowGuildReportRetTip(Ret) then
    return
  end
  self:NotifyEvent(GuildCommon.EventID.OnGuildReport)
end

function Component:SendGuildQuestGetReward(QuestId, Callback)
  if self:GetModel():CanQuestReceive(QuestId) then
    self:GetAvatar():CommonQuestActivityGetReward(function(Ret, Rewards)
      self:RecvGuildQuestGetReward({QuestId}, Ret, Rewards)
      if Callback then
        Callback(Ret, Rewards)
      end
    end, GuildCommon.GuildDummyEventId, QuestId)
  end
end

function Component:RecvGuildQuestGetReward(SrcParams, Ret, Rewards)
  if Ret == ErrorCode.RET_SUCCESS then
    local QuestId = table.unpack(SrcParams)
    local QuestConf = DataMgr.CommonQuestDetail[QuestId]
    if QuestConf.QuestType == CommonConst.CommonQuestType.Daily then
      self:GetModel():TrySubReddotCount("GuildDailyTask", {QuestId = QuestId})
    elseif QuestConf.QuestType == CommonConst.CommonQuestType.Weekly then
      self:GetModel():TrySubReddotCount("GuildWeekTask", {QuestId = QuestId})
    end
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildQuestGetReward, Rewards)
end

function Component:RecvNotifyInvitedJoinGuild(SrcParams, GuildId, InviterInfo)
  local function Callback()
    InviteQueueManager:FinishCurrentInvite(InviteQueueManager.InviteType.Guild)
  end
  
  InviteQueueManager:EnqueueInvite({
    Type = InviteQueueManager.InviteType.Guild,
    Uid = InviterInfo.Uid,
    Nickname = InviterInfo.Nickname,
    Level = InviterInfo.Level,
    HeadIconId = InviterInfo.HeadIconId,
    HeadFrameId = InviterInfo.HeadFrameId,
    MaxRemainTime = GuildCommon.GuildInviteTotalTime,
    GuildId = InviterInfo.GuildId,
    GuildName = InviterInfo.GuildSimpleInfo.Name,
    OnAccept = function()
      self:SendRequestJoinGuild(GuildId, true)
    end,
    OnRefuse = Callback,
    OnTimeout = Callback
  })
  self:RecvCommon(nil, GuildCommon.EventID.OnNotifyInvitedJoinGuild, GuildId, InviterInfo)
end

function Component:SendQueryGuildMemberInfo(Uids)
  self:GetAvatar():QueryGuildMemberInfo(nil, Uids)
end

function Component:RecvQueryGuildMemberInfo(SrcParams, Ret, MemberInfos)
  local CurrGuild = self:GetModel():GetCurrGuild()
  self:UpdateCurrGuildProp(Ret, "Members", function()
    for Uid, Info in pairs(MemberInfos) do
      Info.Uid = Uid
      local Member = CurrGuild:GetMemberByUid(Uid)
      if Member then
        Member:Merge(Info)
      end
    end
    return CurrGuild.Members
  end)
  self:RecvCommon(nil, GuildCommon.EventID.OnQueryGuildMemberInfo, CurrGuild.Members)
end

function Component:RecvNotifyInviteFailed(SrcParams, Uid, ErrCode)
  self:RecvCommon(ErrCode, nil, Uid)
end

function Component:RecvGuildJoinNotify(SrcParams, GuildId)
  self:UpdateCurrGuildCommon(ErrorCode.RET_SUCCESS, GuildId)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildJoinNotify, GuildId)
end

function Component:RecvGuildKickNotify(SrcParams, RequestUid, GuildId, GuildName)
  self:GetModel():SetCurrGuild(nil)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildKickNotify, RequestUid, GuildId, GuildName)
end

function Component:RecvGuildReplyJoinInvite(SrcParams, GuildId, IsAccept)
  if IsAccept then
  else
  end
end

function Component:RecvGuildMessageMarkDirty(SrcParams)
  self:UpdateCurrGuildCommon(ErrorCode.RET_SUCCESS, self:GetAvatar().GuildId)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildMessageMarkDirty)
  if self._BeginGuildChannelSnapshotLoad then
    self:_BeginGuildChannelSnapshotLoad(self:GetAvatar().GuildId)
  end
end

function Component:SendGuildGetIdByName(Name)
  self:GetAvatar():GuildGetIdByName(nil, Name)
end

function Component:RecvGuildGetIdByName(SrcParams, Ret, GuildId)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildGetIdByName, GuildId)
end

return Component
