local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildModel = GuildController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local Decorator = require("BluePrints.Client.Wrapper.Decorator")
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
  DispatchGuildController("GuildIdChanged", nil, self.GuildId)
end

function Component:SetGuildSimpleInfo(GuildSimpleInfo)
  if type(GuildSimpleInfo) ~= "table" then
    GuildSimpleInfo = {}
  end
  self.GuildSimpleInfo = GuildSimpleInfo
end

function Component:_OnPropChangeGuildActivityLevel()
  GuildModel:TryAddReddotCount("GuildWeekActivity")
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
  CallGuildRpc(self, "GetGuildInfo", Callback, GuildId)
end

function Component:GetGuildSimpleInfo(Callback, GuildId)
  CallGuildRpc(self, "GetGuildSimpleInfo", Callback, GuildId)
end

function Component:GetGuildSimpleInfoBatch(Callback, GuildIds)
  CallGuildRpc(self, "GetGuildSimpleInfoBatch", Callback, GuildIds or {})
end

function Component:GuildGetIdByName(Callback, Name)
  CallGuildRpc(self, "GuildGetIdByName", Callback, Name or "")
end

function Component:RpcGetGuildActivityPointReward(Callback, Index)
  CallGuildRpc(self, "RpcGetGuildActivityPointReward", Callback, Index)
end

function Component:GetGuildMessage(Callback)
  CallGuildRpc(self, "GetGuildMessage", Callback)
end

function Component:GetGuildChatHistory(Callback)
  CallGuildRpc(self, "GetGuildChatHistory", Callback)
end

function Component:SetGuildChatOpen(Callback, IsOpen)
  CallGuildRpc(self, "SetGuildChatOpen", Callback, IsOpen and true or false)
end

function Component:QueryGuildChatOpen(Callback, Uid)
  CallGuildRpc(self, "QueryGuildChatOpen", Callback, Uid)
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

return Component
