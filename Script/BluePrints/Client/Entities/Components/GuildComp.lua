local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildModel = GuildController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local Decorator = require("BluePrints.Client.Wrapper.Decorator")
local GuildTypes = require("BluePrints.Client.CustomTypes.Guild")
local GuildAttr = GuildTypes.GuildAttr
local CommonUtils = require("Utils.CommonUtils")
local Component = {}
Decorator:ApplyDecorator(Component)

local function DispatchGuildController(FuncName, SrcParams, ...)
  if not GuildController then
    return
  end
  if type(GuildController[FuncName]) == "function" then
    return GuildController[FuncName](GuildController, SrcParams, ...)
  end
  local RecvFuncName = "Recv" .. FuncName
  if type(GuildController[RecvFuncName]) == "function" then
    return GuildController[RecvFuncName](GuildController, SrcParams, ...)
  end
end

local function CallGuildRpc(self, RpcName, Callback, ...)
  DebugPrint("CallGuildRpc", RpcName, ...)
  local SrcParams = table.pack(...)
  self:CallServer(RpcName, function(...)
    DebugPrint("CallGuildRpc Callback", RpcName, ...)
    PrintTable(table.pack(...), 5)
    if Callback then
      Callback(...)
    end
    DispatchGuildController(RpcName, SrcParams, ...)
  end, ...)
end

local function CallGuildLocalCallback(RpcName, Callback, SrcParams, ErrCode, ...)
  if Callback then
    Callback(ErrCode, ...)
  end
  DispatchGuildController(RpcName, SrcParams, ErrCode, ...)
end

local function BuildGuildSimpleInfo(GuildInfo)
  if type(GuildInfo) ~= "table" then
    return {}
  end
  local GuildHomeData = "table" == type(GuildInfo.GuildHomeData) and GuildInfo.GuildHomeData or {}
  local HeatData = "table" == type(GuildHomeData.Heat) and GuildHomeData.Heat or {}
  local Heat = math.max(0, math.floor(tonumber(GuildInfo.Heat or GuildInfo.GuildHomeHeatRank or HeatData.RankValue) or 0))
  return {
    GuildId = tonumber(GuildInfo.GuildId or 0) or 0,
    Name = GuildInfo.Name or "",
    Logo = GuildInfo.Logo or "",
    Level = tonumber(GuildInfo.Level or 1) or 1,
    ActivityLevel = tonumber(GuildInfo.ActivityLevel or 0) or 0,
    Heat = Heat,
    MemberCount = tonumber(GuildInfo.MemberCount or 0) or 0,
    OwnerUid = tonumber(GuildInfo.OwnerUid or 0) or 0,
    AutoAgreeJoinRequest = GuildInfo.AutoAgreeJoinRequest == true
  }
end

local function DumpLocalGuildInfo(GuildInfo)
  local Result = {}
  for PropName, AttrProp in pairs(GuildAttr) do
    if type(PropName) == "string" and type(AttrProp) == "table" and AttrProp.is_prop then
      local DumpValue = AttrProp:GetBinaryDump(GuildInfo[PropName])
      if nil ~= DumpValue then
        Result[PropName] = DumpValue
      end
    end
  end
  return Result
end

local function BuildLocalGuildMemberInfo(Uid, Member)
  if type(Member) ~= "table" then
    return nil
  end
  return {
    Uid = tonumber(Member.Uid) or tonumber(Uid) or 0,
    Title = tonumber(Member.Title) or 1,
    LastLogin = tonumber(Member.LastLogin) or 0,
    WeekActivity = tonumber(Member.WeekActivity) or 0,
    JoinTime = tonumber(Member.JoinTime) or 0
  }
end

local function CloneLocalGuildValue(Value, Depth)
  if type(Value) ~= "table" then
    return Value
  end
  Depth = (Depth or 0) + 1
  if Depth > 8 then
    return Value
  end
  local Result = {}
  local HasArrayValue = false
  for Index, Child in ipairs(Value) do
    HasArrayValue = true
    Result[Index] = CloneLocalGuildValue(Child, Depth)
  end
  if HasArrayValue then
    return Result
  end
  for Key, Child in pairs(Value) do
    if type(Key) ~= "string" or string.sub(Key, 1, 2) ~= "__" then
      Result[Key] = CloneLocalGuildValue(Child, Depth)
    end
  end
  return Result
end

local function GetLocalGuildInfo(self, GuildId)
  local GuildInfo = type(self.GuildInfo) == "table" and self.GuildInfo or nil
  local LocalGuildId = math.floor(tonumber((GuildInfo or {}).GuildId) or 0)
  GuildId = math.floor(tonumber(GuildId) or 0)
  if GuildId <= 0 then
    GuildId = math.floor(tonumber(self.GuildId) or 0)
  end
  if GuildId > 0 and LocalGuildId == GuildId then
    return GuildInfo, GuildId
  end
  return nil, GuildId
end

local NormalizeInt = CommonUtils.NormalizeInt

function Component:_OnLoginSuccess()
  GuildController:Init()
end

function Component:LeaveWorld()
  GuildController:Destory()
end

function Component:_OnPropChangeGuildId()
  local GuildId = tonumber(self.GuildId or 0) or 0
  local GuildSimpleInfo = type(self.GuildSimpleInfo) == "table" and self.GuildSimpleInfo or nil
  local GuildSimpleInfoGuildId = tonumber((GuildSimpleInfo or {}).GuildId or 0) or 0
  if 0 == GuildId or 0 ~= GuildSimpleInfoGuildId and GuildSimpleInfoGuildId ~= GuildId then
    self:SetGuildSimpleInfo({})
  end
  if not GuildModel:GetCurrGuild() and 0 ~= GuildId then
    self:GuildJoinNotify(self.GuildId)
  end
  if 0 ~= GuildId then
    GuildModel:RefreshGuildBossPersonPointRewardReddot()
  end
  DispatchGuildController("GuildIdChanged", nil, self.GuildId)
end

function Component:SetGuildSimpleInfo(GuildSimpleInfo)
  if type(GuildSimpleInfo) ~= "table" then
    GuildSimpleInfo = {}
  end
  self.GuildSimpleInfo = GuildSimpleInfo
end

function Component:DispatchGuildPropChange(PropName, NewValue, OldValue, ChangeKeys)
  if type(PropName) ~= "string" or "" == PropName then
    return
  end
  local FuncName = "GuildPropChange" .. PropName
  local Func = self[FuncName]
  if type(Func) == "function" then
    Func(self, NewValue, OldValue, self.GuildInfo or {}, ChangeKeys or {})
  end
  DispatchGuildController("NotifyGuildPropChanged", nil, PropName, NewValue, OldValue, self.GuildInfo or {}, ChangeKeys or {})
end

function Component:GuildPropChangeOwnerUid(NewValue, OldValue, GuildInfo, ChangeKeys)
end

function Component:_OnPropChangeGuildInfo(ChangeKeys, OldValue)
  local GuildInfo = self.GuildInfo
  local GuildId = tonumber((GuildInfo or {}).GuildId or 0) or 0
  if GuildId <= 0 then
    self:SetGuildSimpleInfo({})
  else
    self:SetGuildSimpleInfo(BuildGuildSimpleInfo(GuildInfo))
  end
  local PropName = type(ChangeKeys) == "table" and ChangeKeys[1] or nil
  if type(PropName) == "string" then
    self:DispatchGuildPropChange(PropName, GuildInfo and GuildInfo[PropName], OldValue, ChangeKeys)
  end
  DispatchGuildController("GuildInfoChanged", nil, GuildInfo or {})
end

function Component:_OnPropChangeGuildActivityLevel()
  GuildModel:TryAddReddotCount("GuildWeekActivity")
end

function Component:_OnPropChangeGuildBossData(ChangeKeys, OldValue)
  GuildModel:RefreshGuildBossPersonPointRewardReddot()
end

function Component:CreateGuild(Callback, GuildName, GuildDecl, GuildExtInfo)
  CallGuildRpc(self, "CreateGuild", Callback, GuildName, GuildDecl, GuildExtInfo or {})
end

function Component:RequestJoinGuild(Callback, GuildId, bInvited)
  CallGuildRpc(self, "RequestJoinGuild", Callback, GuildId, bInvited)
end

function Component:RequestJoinGuildBatch(Callback, GuildIds)
  CallGuildRpc(self, "RequestJoinGuildBatch", Callback, GuildIds or {})
end

function Component:InviteJoinGuild(Callback, Uid)
  CallGuildRpc(self, "InviteJoinGuild", Callback, Uid)
end

function Component:GuildReplyJoinInvite(Callback, GuildId, IsAccept)
  CallGuildRpc(self, "GuildReplyJoinInvite", Callback, GuildId or 0, IsAccept and true or false)
end

function Component:GuildGetJoinRequests(Callback)
  CallGuildRpc(self, "GuildGetJoinRequests", Callback)
end

function Component:GuildAgreeJoinRequest(Callback, Uids)
  CallGuildRpc(self, "GuildAgreeJoinRequest", Callback, Uids or {})
end

function Component:GuildRejectJoinRequest(Callback, Uids)
  CallGuildRpc(self, "GuildRejectJoinRequest", Callback, Uids or {})
end

function Component:GuildLeave(Callback)
  local function InnerCallback(...)
    DebugPrint("GuildLeave")
    
    if Callback then
      Callback(...)
    end
  end
  
  CallGuildRpc(self, "GuildLeave", InnerCallback)
end

function Component:GuildKickMember(Callback, TargetUid)
  local function InnerCallback(...)
    if Callback then
      Callback(...)
    end
  end
  
  CallGuildRpc(self, "GuildKickMember", InnerCallback, TargetUid)
end

function Component:GuildSetAutoAgreeJoinRequest(Callback, Switch)
  CallGuildRpc(self, "GuildSetAutoAgreeJoinRequest", Callback, Switch and true or false)
end

function Component:GuildSetOwner(Callback, TargetUid)
  CallGuildRpc(self, "GuildSetOwner", Callback, TargetUid)
end

function Component:GuildSetTitle(Callback, TargetUid, Title)
  CallGuildRpc(self, "GuildSetTitle", Callback, TargetUid, Title)
end

function Component:GuildSetPermissionSwitch(Callback, TargetTitle, Permission, IsOpen)
  CallGuildRpc(self, "GuildSetPermissionSwitch", Callback, TargetTitle, Permission, IsOpen and true or false)
end

function Component:GuildGetList(Callback)
  CallGuildRpc(self, "GuildGetList", Callback)
end

function Component:GuildSearch(Callback, Keyword)
  CallGuildRpc(self, "GuildSearch", Callback, Keyword or "")
end

function Component:GetGuildInfo(Callback, GuildId)
  local SrcParams = table.pack(GuildId or 0)
  local GuildInfo, TargetGuildId = GetLocalGuildInfo(self, GuildId)
  if GuildInfo then
    CallGuildLocalCallback("GetGuildInfo", Callback, SrcParams, ErrorCode.RET_SUCCESS, DumpLocalGuildInfo(GuildInfo))
    return
  end
  CallGuildRpc(self, "GetGuildInfo", Callback, TargetGuildId)
end

function Component:GetGuildSimpleInfo(Callback, GuildId)
  local SrcParams = table.pack(GuildId or 0)
  local GuildInfo, TargetGuildId = GetLocalGuildInfo(self, GuildId)
  if GuildInfo then
    CallGuildLocalCallback("GetGuildSimpleInfo", Callback, SrcParams, ErrorCode.RET_SUCCESS, BuildGuildSimpleInfo(GuildInfo))
    return
  end
  CallGuildRpc(self, "GetGuildSimpleInfo", Callback, TargetGuildId)
end

function Component:GetGuildSimpleInfoBatch(Callback, GuildIds)
  GuildIds = type(GuildIds) == "table" and GuildIds or {}
  local UniqueGuildIds = {}
  local LocalGuildInfos = {}
  local RemoteGuildIds = {}
  local UniqueCount = 0
  for _, GuildId in ipairs(GuildIds) do
    GuildId = NormalizeInt(GuildId, 0)
    if GuildId > 0 and not UniqueGuildIds[GuildId] then
      UniqueGuildIds[GuildId] = true
      UniqueCount = UniqueCount + 1
      local GuildInfo = GetLocalGuildInfo(self, GuildId)
      if GuildInfo then
        table.insert(LocalGuildInfos, BuildGuildSimpleInfo(GuildInfo))
      else
        table.insert(RemoteGuildIds, GuildId)
      end
    end
  end
  if UniqueCount <= 0 then
    CallGuildLocalCallback("GetGuildSimpleInfoBatch", Callback, table.pack(GuildIds), ErrorCode.RET_SUCCESS, {}, {})
    return
  end
  if #RemoteGuildIds <= 0 then
    CallGuildLocalCallback("GetGuildSimpleInfoBatch", Callback, table.pack(GuildIds), ErrorCode.RET_SUCCESS, LocalGuildInfos, {})
    return
  end
  local SrcParams = table.pack(GuildIds)
  self:CallServer("GetGuildSimpleInfoBatch", function(ErrCode, GuildInfos, Failed)
    GuildInfos = type(GuildInfos) == "table" and GuildInfos or {}
    for _, GuildInfo in ipairs(GuildInfos) do
      table.insert(LocalGuildInfos, GuildInfo)
    end
    CallGuildLocalCallback("GetGuildSimpleInfoBatch", Callback, SrcParams, ErrCode, LocalGuildInfos, Failed or {})
  end, RemoteGuildIds)
end

function Component:QueryGuildAttrs(Callback, GuildId, PropNames)
  PropNames = type(PropNames) == "table" and PropNames or {}
  local SrcParams = table.pack(GuildId or 0, PropNames)
  local GuildInfo, TargetGuildId = GetLocalGuildInfo(self, GuildId)
  if GuildInfo then
    local Attrs = GuildAttr.Merge({}, GuildInfo, PropNames)
    CallGuildLocalCallback("QueryGuildAttrs", Callback, SrcParams, ErrorCode.RET_SUCCESS, Attrs)
    return
  end
  CallGuildRpc(self, "QueryGuildAttrs", Callback, TargetGuildId, PropNames)
end

function Component:QueryGuildMembers(Callback, GuildId, Uids)
  Uids = type(Uids) == "table" and Uids or {}
  local SrcParams = table.pack(GuildId or 0, Uids)
  local GuildInfo, TargetGuildId = GetLocalGuildInfo(self, GuildId)
  if GuildInfo then
    local Members = "table" == type(GuildInfo.Members) and GuildInfo.Members or {}
    local Result = {}
    if #Uids <= 0 then
      for Uid, Member in pairs(Members) do
        local Info = BuildLocalGuildMemberInfo(Uid, Member)
        if Info then
          Result[Info.Uid] = Info
        end
      end
    else
      local Used = {}
      for _, Uid in ipairs(Uids) do
        Uid = tonumber(Uid) or 0
        if Uid > 0 and not Used[Uid] then
          Used[Uid] = true
          local Info = BuildLocalGuildMemberInfo(Uid, Members[Uid] or Members[tostring(Uid)])
          if Info then
            Result[Uid] = Info
          end
        end
      end
    end
    CallGuildLocalCallback("QueryGuildMembers", Callback, SrcParams, ErrorCode.RET_SUCCESS, Result)
    return
  end
  CallGuildRpc(self, "QueryGuildMembers", Callback, TargetGuildId, Uids)
end

function Component:GuildGetIdByName(Callback, Name)
  CallGuildRpc(self, "GuildGetIdByName", Callback, Name or "")
end

function Component:RpcGetGuildActivityPointReward(Callback, Index)
  CallGuildRpc(self, "RpcGetGuildActivityPointReward", Callback, Index)
end

function Component:GuildBossClaimPointReward(Callback, RewardIndex)
  CallGuildRpc(self, "GuildBossClaimPointReward", Callback, RewardIndex or 0)
end

function Component:GuildBossClaimAllPointReward(Callback)
  CallGuildRpc(self, "GuildBossClaimAllPointReward", Callback)
end

function Component:GuildBossClaimStageReward(Callback, TargetGuildId, BossId, StageId)
  CallGuildRpc(self, "GuildBossClaimStageReward", Callback, TargetGuildId or 0, BossId or 0, StageId or 0)
end

function Component:GuildBossClaimAllReward(Callback)
  CallGuildRpc(self, "GuildBossClaimAllReward", Callback)
end

function Component:GuildHomeGetBuildData(Callback, TargetGuildId)
  CallGuildRpc(self, "GuildHomeGetBuildData", Callback, TargetGuildId or 0)
end

function Component:GuildHomeEnterBuild(Callback)
  CallGuildRpc(self, "GuildHomeEnterBuild", Callback)
end

function Component:GuildHomeExitBuild(Callback)
  CallGuildRpc(self, "GuildHomeExitBuild", Callback)
end

function Component:GuildHomeBuyComponent(Callback, ComponentId, Count)
  CallGuildRpc(self, "GuildHomeBuyComponent", Callback, ComponentId or 0, Count or 0)
end

function Component:GuildHomeExchangeFund(Callback, Count)
  CallGuildRpc(self, "GuildHomeExchangeFund", Callback, Count or 0)
end

function Component:GuildHomePublishLayout(Callback, BaseVersion, FullSnapshot)
  CallGuildRpc(self, "GuildHomePublishLayout", Callback, BaseVersion or 0, FullSnapshot or {})
end

function Component:GuildHomeGetRandomVisitGuild(Callback, ExcludeGuildId)
  CallGuildRpc(self, "GuildHomeGetRandomVisitGuild", Callback, ExcludeGuildId or 0)
end

function Component:GetGuildMessage(Callback)
  local SrcParams = table.pack()
  if NormalizeInt(self.GuildId, 0) <= 0 then
    CallGuildLocalCallback("GetGuildMessage", Callback, SrcParams, ErrorCode.RET_GUILD_NOT_IN_GUILD, {})
    return
  end
  local GuildInfo = GetLocalGuildInfo(self, self.GuildId)
  if GuildInfo then
    CallGuildLocalCallback("GetGuildMessage", Callback, SrcParams, ErrorCode.RET_SUCCESS, CloneLocalGuildValue(GuildInfo.GuildMessages or {}))
    return
  end
  CallGuildRpc(self, "GetGuildMessage", Callback)
end

function Component:GetGuildChatHistory(Callback)
  CallGuildRpc(self, "GetGuildChatHistory", Callback)
end

function Component:SetGuildChatOpen(Callback, IsOpen)
  CallGuildRpc(self, "SetGuildChatOpen", Callback, IsOpen and true or false)
end

function Component:QueryGuildChatOpen(Callback, Uid, bCallbackOnly)
  Uid = NormalizeInt(Uid, 0)
  if Uid > 0 and Uid == NormalizeInt(self.Uid, 0) then
    if bCallbackOnly then
      if Callback then
        Callback(ErrorCode.RET_SUCCESS, self.GuildChatOpen ~= false)
      end
    else
      CallGuildLocalCallback("QueryGuildChatOpen", Callback, table.pack(Uid), ErrorCode.RET_SUCCESS, self.GuildChatOpen ~= false)
    end
    return
  end
  if bCallbackOnly then
    self:CallServer("QueryGuildChatOpen", function(...)
      if Callback then
        Callback(...)
      end
    end, Uid)
  else
    CallGuildRpc(self, "QueryGuildChatOpen", Callback, Uid)
  end
end

function Component:QueryGuildMemberInfo(Callback, Uids, bCallbackOnly)
  if bCallbackOnly then
    self:CallServer("QueryGuildMemberInfo", function(...)
      if Callback then
        Callback(...)
      end
    end, Uids or {})
  else
    CallGuildRpc(self, "QueryGuildMemberInfo", Callback, Uids or {})
  end
end

function Component:ChatToGuildMember(Callback, Uid, Content)
  CallGuildRpc(self, "ChatToGuildMember", Callback, Uid, Content or "")
end

function Component:ReadGuildPrivateChat(Callback, Uid, SubTabType)
  if type(Callback) ~= "function" then
    if nil == Uid then
      Uid = Callback
    end
    Callback = nil
  end
  
  local function InnerCallback(Ret, ...)
    if Callback then
      Callback(Ret, ...)
    end
    if not ChatController:CheckError(Ret, true) then
      return
    end
    ChatController:RecvChatNewMsgRead(Uid, SubTabType)
  end
  
  self:CallServer("ReadGuildPrivateChat", InnerCallback, Uid)
end

function Component:ClearGuildPrivateChat(Callback, Uid)
  CallGuildRpc(self, "ClearGuildPrivateChat", Callback, Uid)
end

function Component:GuildReport(Callback, GuildId, ReasonType, ReportText)
  CallGuildRpc(self, "GuildReport", Callback, GuildId, ReasonType, ReportText or "")
end

function Component:GuildSubmitEdit(Callback, EditInfo)
  CallGuildRpc(self, "GuildSubmitEdit", Callback, EditInfo or {})
end

function Component:RpcGuildCheckName(Callback, Name)
  CallGuildRpc(self, "RpcGuildCheckName", Callback, Name or "")
end

function Component:GuildEditName(Callback, Name)
  CallGuildRpc(self, "GuildEditName", Callback, Name or "")
end

function Component:GuildEditDeclaration(Callback, Declaration)
  CallGuildRpc(self, "GuildEditDeclaration", Callback, Declaration or "")
end

function Component:GuildEditLogo(Callback, Logo)
  CallGuildRpc(self, "GuildEditLogo", Callback, Logo or "")
end

function Component:NotifyInvitedJoinGuild(GuildId, InviterInfo)
  DispatchGuildController("NotifyInvitedJoinGuild", nil, GuildId, InviterInfo)
end

function Component:NotifyInviteFailed(Uid, ErrCode)
  DispatchGuildController("NotifyInviteFailed", nil, Uid, ErrCode)
end

function Component:NotifyGuildJoinInviteReply(InviteeUid, GuildId, IsAccept, InvitedName)
  DispatchGuildController("NotifyGuildJoinInviteReply", nil, InviteeUid, GuildId, IsAccept and true or false, InvitedName or "")
end

function Component:NotifyGuildRecvNewJoinRequest(RequestInfo)
  DispatchGuildController("NotifyGuildRecvNewJoinRequest", nil, RequestInfo)
end

function Component:NotifyGuildRemoveJoinRequests(Uids)
  DispatchGuildController("NotifyGuildRemoveJoinRequests", nil, Uids or {})
end

function Component:GuildJoinNotify(GuildId)
  local CurrentSimpleInfoGuildId = tonumber((self.GuildSimpleInfo or {}).GuildId or 0) or 0
  if 0 ~= CurrentSimpleInfoGuildId and CurrentSimpleInfoGuildId ~= tonumber(GuildId or 0) then
    self:SetGuildSimpleInfo({})
  end
  self.GuildId = GuildId
  DispatchGuildController("GuildJoinNotify", nil, GuildId)
end

function Component:GuildKickNotify(RequestUid, GuildId, GuildName)
  if tonumber(self.GuildId or 0) == tonumber(GuildId or 0) then
    self:SetGuildSimpleInfo({})
    self.GuildId = 0
  end
  DispatchGuildController("GuildKickNotify", nil, RequestUid, GuildId, GuildName)
end

function Component:GuildDissolveNotify(GuildId)
  if tonumber(self.GuildId or 0) == tonumber(GuildId or 0) then
    self:SetGuildSimpleInfo({})
    self.GuildId = 0
  end
  DispatchGuildController("GuildDissolveNotify", nil, GuildId)
end

function Component:BecomeGuildOwerMail(Uid)
  DispatchGuildController("BecomeGuildOwerMail", nil, Uid)
end

function Component:GuildOwnerInactiveWarningMail(Uid, LeftDays)
  DispatchGuildController("GuildOwnerInactiveWarningMail", nil, Uid, LeftDays)
end

function Component:GuildCreateAuditRejected(GuildId, GuildName, ResourceId, Count, Reason)
  DispatchGuildController("GuildCreateAuditRejected", nil, GuildId, GuildName, ResourceId, Count, Reason)
end

function Component:GuildMessageMarkDirty()
  DispatchGuildController("GuildMessageMarkDirty", nil)
end

function Component:NotifyGuildPrivateChat(message, by_myself, other_info)
  DebugPrint("NotifyGuildPrivateChat", message, by_myself)
  if not message then
    return
  end
  message.IsGuildPrivate = true
  message.ChannelType = CommonConst.ChatChannel.Friend
  local bBySelf = by_myself and true or false
  local OtherUid, Other
  if bBySelf then
    OtherUid = message.ReceiverUid
    Other = other_info
  else
    OtherUid = message.Sender and message.Sender.Uid
    Other = message.Sender or other_info
  end
  if not OtherUid or not Other then
    return
  end
  local Chat = self.GuildChats[OtherUid]
  if not Chat then
    Chat = self.GuildChats:NewChat(Other)
  else
    Chat.PlayerInfo = Other
  end
  Chat:AddMessage(message, bBySelf)
  self.GuildChats[OtherUid] = Chat
  ChatController:HandleChatMessage(message)
end

function Component:ReceiveGuildChatMsg(message)
  DebugPrint("ReceiveGuildChatMsg", message)
  message.ChannelType = CommonConst.ChatChannel.InGuild
  ChatController:HandleChatMessage(message)
end

function Component:ChatToGuild(Callback, Content)
  DebugPrint("ChatToGuild", Content)
  
  local function InnerCallback(...)
    local Ret = (...)
    DebugPrint("ChatToGuild: ErrorCode: " .. Ret)
    if Callback then
      Callback(...)
    end
    if not ChatController:CheckError(Ret, true) then
      return
    end
  end
  
  CallGuildRpc(self, "ChatToGuild", InnerCallback, Content)
end

function Component:GuildHomeExchangeFund(Callback, Count)
  CallGuildRpc(self, "GuildHomeExchangeFund", Callback, Count or 0)
end

function Component:GuildHomeBuyComponent(Callback, ComponentId, Count)
  CallGuildRpc(self, "GuildHomeBuyComponent", Callback, ComponentId or 0, Count or 0)
end

return Component
