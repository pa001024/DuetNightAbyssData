local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildRequestInfo = GuildDatas.GuildRequestInfo
local Component = {}

function Component:OnInit()
end

function Component:OnDestory()
end

function Component:OnOpenView(ViewObj)
end

function Component:OnGuildIdChanged(GuildId)
end

function Component:SendCreateGuild(GuildName, GuildDecl, bAutoJoin, GuildLogoInfo)
  GuildLogoInfo = GuildLogoInfo or self:GetModel():GetEditingLogoInfo()
  if nil == bAutoJoin then
    bAutoJoin = false
  end
  local GuildExtInfo = {
    Logo = GuildLogoInfo:Pack(),
    AutoAgreeJoinRequest = bAutoJoin
  }
  self:GetAvatar():CreateGuild(nil, GuildName, GuildDecl, GuildExtInfo)
end

function Component:RecvCreateGuild(SrcParams, Ret, GuildId)
  if Ret == ErrorCode.RET_GUILD_CREATE_NAME_DUPLICATE then
    self:NotifyEvent(GuildCommon.EventID.OnGuildCreateNameDuplicate)
    return
  elseif Ret == ErrorCode.RET_GUILD_CREATE_NAME_INVALID then
    self:NotifyEvent(GuildCommon.EventID.OnGuildCreateNameInvalid)
    return
  elseif Ret == ErrorCode.RET_GUILD_CREATE_DECL_INVALID then
    self:NotifyEvent(GuildCommon.EventID.OnGuildCreateDescInvalid)
    return
  end
  self:UpdateCurrGuildCommon(Ret, GuildId)
  self:RecvCommon(Ret, GuildCommon.EventID.OnCreateGuild, GuildId)
end

function Component:SendInviteJoinGuild(Uid)
  self:GetAvatar():InviteJoinGuild(nil, Uid)
end

function Component:RecvInviteJoinGuild(SrcParams, Ret)
  local Param
  if Ret == ErrorCode.RET_GUILD_INVITE_JOIN_CD then
    local Avatar = GWorld:GetAvatar()
    local RequestJoinTime = Avatar.GuildInviteRecord[SrcParams[1]]
    Param = UIUtils.GetLeftTimeStrStyle1(RequestJoinTime + GuildCommon.InviteJoinCD, TimeUtils.NowTime())
  elseif Ret == ErrorCode.RET_SUCCESS then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("InvitationSent"))
  end
  self:RecvParam(Ret, GuildCommon.EventID.OnInviteJoinGuild, Param)
end

function Component:SendGuildGetJoinRequests()
  self:GetAvatar():GuildGetJoinRequests(nil)
end

function Component:RecvGuildGetJoinRequests(SrcParams, Ret, RequestTable, OrderedRequestList)
  local ReqLookTable = self:GetModel():CreateReqLookTable(OrderedRequestList)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildGetJoinRequests, ReqLookTable)
end

function Component:SendGuildAgreeJoinRequest(Uids)
  self:GetAvatar():GuildAgreeJoinRequest(nil, Uids)
end

function Component:RecvGuildAgreeJoinRequest(SrcParams, Ret)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildAgreeJoinRequest)
end

function Component:SendGuildRejectJoinRequest(Uids)
  self:GetAvatar():GuildRejectJoinRequest(nil, Uids)
end

function Component:RecvGuildRejectJoinRequest(SrcParams, Ret)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildRejectJoinRequest)
end

function Component:SendGuildKickMember(TargetUid)
  self:GetAvatar():GuildKickMember(nil, TargetUid)
end

function Component:RecvGuildKickMember(SrcParams, Ret)
  if Ret == ErrorCode.RET_SUCCESS then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_MemberKickedSuccessfully"))
  end
  self:UpdateCurrGuildCommon(Ret)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildKickMember)
end

function Component:SendGuildSetAutoAgreeJoinRequest(Switch)
  self:GetAvatar():GuildSetAutoAgreeJoinRequest(nil, Switch)
end

function Component:RecvGuildSetAutoAgreeJoinRequest(SrcParams, Ret)
  local AutoAgreeJoinRequest = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "AutoAgreeJoinRequest", AutoAgreeJoinRequest)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSetAutoAgreeJoinRequest)
end

function Component:SendGuildSetOwner(TargetUid)
  self:GetAvatar():GuildSetOwner(nil, TargetUid)
end

function Component:RecvGuildSetOwner(SrcParams, Ret)
  local OwnerUid = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "OwnerUid", OwnerUid)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSetOwner)
end

function Component:SendGuildSetTitle(TargetUid, Title)
  self:GetAvatar():GuildSetTitle(nil, TargetUid, Title)
end

function Component:RecvGuildSetTitle(SrcParams, Ret)
  if Ret == ErrorCode.RET_SUCCESS then
    GWorld.GameInstance:GetGameUIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_RoleAdjustedSuccessfully"))
  elseif Ret == ErrorCode.RET_GUILD_TITLE_FULL then
    GWorld.GameInstance:GetGameUIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_RolePositionFull"))
  end
  self:UpdateCurrGuildCommon(Ret)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSetTitle)
end

function Component:SendGuildSetPermissionSwitch(TargetTitle, Permission, IsOpen, Callback)
  self:GetAvatar():GuildSetPermissionSwitch(Callback, TargetTitle, Permission, IsOpen)
end

function Component:RecvGuildSetPermissionSwitch(SrcParams, Ret)
  self:UpdateCurrGuildCommon(Ret)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSetPermissionSwitch)
end

function Component:SendGuildSubmitEdit(EditInfo)
  self:GetAvatar():GuildSubmitEdit(nil, EditInfo)
end

function Component:RecvGuildSubmitEdit(SrcParams, Ret)
  self:UpdateCurrGuildCommon(Ret)
  self:UpdateCurrGuildProp(Ret, "LastNameEditTime", TimeUtils.NowTime())
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSubmitEdit)
end

function Component:SendGuildEditName(Name)
  self:GetAvatar():GuildEditName(nil, Name)
end

function Component:RecvGuildEditName(SrcParams, Ret)
  local Name = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "Name", Name)
  self:UpdateCurrGuildProp(Ret, "LastNameEditTime", TimeUtils.NowTime())
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildEditName)
end

function Component:SendGuildEditDeclaration(Declaration)
  self:GetAvatar():GuildEditDeclaration(nil, Declaration)
end

function Component:RecvGuildEditDeclaration(SrcParams, Ret)
  local Declaration = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "Declaration", Declaration)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildEditDeclaration)
end

function Component:SendRpcGuildCheckName(Name)
  self:GetAvatar():RpcGuildCheckName(nil, Name)
end

function Component:RecvRpcGuildCheckName(SrcParams, Ret)
  local SameName = false
  if Ret ~= ErrorCode.RET_SUCCESS then
    SameName = true
  end
  self:RecvCommon(nil, GuildCommon.EventID.OnRpcGuildCheckName, SameName)
end

function Component:SendGuildEditLogo(GuildLogoInfo)
  GuildLogoInfo = GuildLogoInfo or self:GetModel():GetEditingLogoInfo()
  self:GetAvatar():GuildEditLogo(nil, GuildLogoInfo:Pack())
end

function Component:RecvGuildEditLogo(SrcParams, Ret)
  local Logo = table.unpack(SrcParams)
  self:UpdateCurrGuildCommon(Ret, "LogoInfo", function()
    return GuildLogoInfo.New(Logo)
  end)
  if Ret ~= ErrorCode.RET_SUCCESS then
    local CurrGuild = self:GetModel():GetCurrGuild()
    if CurrGuild then
      self:GetModel():SetEditingLogoInfo(CurrGuild.LogoInfo)
    else
      self:GetModel():SetEditingLogoInfo(GuildLogoInfo.Empty())
    end
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildEditLogo)
end

function Component:RecvBecomeGuildOwerMail(SrcParams, Uid)
  local OwnerUid = Uid
  self:UpdateCurrGuildProp(ErrorCode.RET_SUCCESS, "OwnerUid", OwnerUid)
  self:RecvCommon(nil, GuildCommon.EventID.OnBecomeGuildOwerMail, Uid)
end

function Component:RecvGuildOwnerInactiveWarningMail(SrcParams, Uid, LeftDays)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildOwnerInactiveWarningMail, Uid, LeftDays)
end

function Component:RecvGuildCreateAuditRejected(SrcParams, GuildId, GuildName, ResourceId, Count, Reason)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildCreateAuditRejected, GuildId, GuildName, ResourceId, Count, Reason)
end

function Component:RecvGuildDissolveNotify(SrcParams, GuildId)
  self:GetModel():SetCurrGuild(nil)
  self:RecvCommon(nil, GuildCommon.EventID.OnGuildDissolveNotify, GuildId)
end

function Component:RecvNotifyGuildRecvNewJoinRequest(SrcParams, RequestInfo)
  local GuildReqInfo = GuildRequestInfo.New(RequestInfo)
  local ReqTable = self:GetModel():GetReqLookTable()
  if ReqTable then
    ReqTable:AddNewReq(GuildReqInfo)
  end
  self:UpdateCurrGuildProp(ErrorCode.RET_SUCCESS, "JoinRequestUids", function()
    local JoinRequestUids = self:GetModel():GetCurrGuild().JoinRequestUids
    if not JoinRequestUids[GuildReqInfo.Uid] then
      JoinRequestUids[GuildReqInfo.Uid] = GuildReqInfo.ApplyTime
      self:GetModel():TryAddReddotCount("GuildNewRequest")
    end
    return JoinRequestUids
  end)
  self:RecvCommon(nil, GuildCommon.EventID.OnNotifyGuildRecvNewJoinRequest, GuildReqInfo)
end

function Component:RecvNotifyGuildRemoveJoinRequests(SrcParams, RemoveUids)
  local ReqTable = self:GetModel():GetReqLookTable()
  if ReqTable then
    for _, Uid in ipairs(RemoveUids) do
      ReqTable:RemoveReqByUid(Uid)
    end
  end
  self:UpdateCurrGuildProp(ErrorCode.RET_SUCCESS, "JoinRequestUids", function()
    local JoinRequestUids = self:GetModel():GetCurrGuild().JoinRequestUids
    for _, Uid in ipairs(RemoveUids) do
      if JoinRequestUids[Uid] then
        JoinRequestUids[Uid] = nil
        self:GetModel():TrySubReddotCount("GuildNewRequest")
      end
    end
    return JoinRequestUids
  end)
  self:RecvCommon(nil, GuildCommon.EventID.OnNotifyGuildRemoveJoinRequests, RemoveUids)
end

return Component
