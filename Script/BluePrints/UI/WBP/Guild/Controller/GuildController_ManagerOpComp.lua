local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local GuildRequestInfo = GuildDatas.GuildRequestInfo
local GuildRenameCardDialogId = 100362
local GuildRenameCardPermission = "ModifyNameEmblem"
local GuildRenameCardInputName = "Dialog_Input_new"
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

function Component:SendGuildAgreeJoinRequest(Uids, Callback)
  self:GetAvatar():GuildAgreeJoinRequest(Callback, Uids)
end

function Component:RecvGuildAgreeJoinRequest(SrcParams, Ret)
  local Uids = table.unpack(SrcParams)
  self:_JoinRequestRemovedCommon(Ret, Uids)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildAgreeJoinRequest)
end

function Component:SendGuildRejectJoinRequest(Uids)
  self:GetAvatar():GuildRejectJoinRequest(nil, Uids)
end

function Component:RecvGuildRejectJoinRequest(SrcParams, Ret)
  local Uids = table.unpack(SrcParams)
  self:_JoinRequestRemovedCommon(Ret, Uids)
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
  self:UpdateCurrGuildProp(Ret, "LastLogoEditTime", TimeUtils.NowTime())
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildSubmitEdit)
end

function Component:SendGuildEditName(Name)
  self:GetAvatar():GuildEditName(nil, Name)
end

function Component:RecvGuildEditName(SrcParams, Ret)
  local Name = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "Name", Name)
  self:UpdateCurrGuildProp(Ret, "LastNameEditTime", TimeUtils.NowTime())
  self:ApplyRenamedGuildBadgeText(Name, Ret)
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

function Component:SendRpcGuildCheckName(Name, Callback)
  if Callback then
    self.PendingGuildCheckNameCallback = Callback
  end
  self:GetAvatar():RpcGuildCheckName(nil, Name)
end

function Component:RecvRpcGuildCheckName(SrcParams, Ret)
  local SameName = false
  if Ret ~= ErrorCode.RET_SUCCESS then
    SameName = true
  end
  local PendingCallback = self.PendingGuildCheckNameCallback
  self.PendingGuildCheckNameCallback = nil
  if PendingCallback then
    PendingCallback(SameName)
    return
  end
  self:RecvCommon(nil, GuildCommon.EventID.OnRpcGuildCheckName, SameName)
end

function Component:SendGuildEditLogo(GuildLogoInfo)
  GuildLogoInfo = GuildLogoInfo or self:GetModel():GetEditingLogoInfo()
  self:GetAvatar():GuildEditLogo(nil, GuildLogoInfo:Pack())
end

function Component:RecvGuildEditLogo(SrcParams, Ret)
  local Logo = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "LogoInfo", function()
    local LogoInfo = GuildLogoInfo.New(Logo)
    return LogoInfo
  end)
  self:UpdateCurrGuildProp(Ret, "LastLogoEditTime", TimeUtils.NowTime())
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

function Component:SendGuildEditBadgeText(BadgeText)
  self:GetAvatar():GuildEditBadgeText(nil, BadgeText or "")
end

function Component:RecvGuildEditBadgeText(SrcParams, Ret)
  local BadgeText = table.unpack(SrcParams)
  self:UpdateCurrGuildProp(Ret, "BadgeText", BadgeText)
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildEditBadgeText)
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
  self:_JoinRequestRemovedCommon(ErrorCode.RET_SUCCESS, RemoveUids)
  self:RecvCommon(nil, GuildCommon.EventID.OnNotifyGuildRemoveJoinRequests, RemoveUids)
end

function Component:_JoinRequestRemovedCommon(Ret, RemoveUids)
  local ReqTable = self:GetModel():GetReqLookTable()
  if ReqTable then
    for _, Uid in ipairs(RemoveUids) do
      ReqTable:RemoveReqByUid(Uid)
    end
  end
  self:UpdateCurrGuildProp(Ret, "JoinRequestUids", function()
    local JoinRequestUids = self:GetModel():GetCurrGuild().JoinRequestUids
    for _, Uid in ipairs(RemoveUids) do
      if JoinRequestUids[Uid] then
        JoinRequestUids[Uid] = nil
        self:GetModel():TrySubReddotCount("GuildNewRequest")
      end
    end
    return JoinRequestUids
  end)
end

function Component:TryOpenGuildRenameCardDialog(ResourceId, ParentWidget)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local Model = self:GetModel()
  if not Model:IsInGuild() then
    self:GetUIMgr():ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoInGuild"))
    return
  end
  local GuildInfo = Model:GetSyncedGuildInfo()
  if not GuildInfo then
    self:GetUIMgr():ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_OperationCoolDown"))
    return
  end
  local Title = Model:GetSyncedMemberTitle(Avatar.Uid)
  local IsPermitted = nil ~= Title and GuildPermissionUtils.GetEffectivePermission(GuildInfo.ClosedPermission, Title, GuildRenameCardPermission)
  if not IsPermitted then
    self:GetUIMgr():ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoEditPermission"))
    return
  end
  if Avatar:GetResourceNum(ResourceId) <= 0 then
    self:CheckError(ErrorCode.RET_ITEM_NOT_ENOUGH)
    return
  end
  self:OpenGuildRenameCardDialog(ResourceId, ParentWidget)
end

function Component:OpenGuildRenameCardDialog(ResourceId, ParentWidget)
  local SubmitState = {
    IsSubmitting = false,
    IsClosed = false,
    NeedCheckName = true,
    IsCheckingName = false,
    GuildHasSameName = false,
    CheckingName = ""
  }
  if not IsValid(ParentWidget) then
    ParentWidget = nil
  end
  local DialogHolder = {Dialog = nil}
  
  function SubmitState.OnCheckNameCallback(SameName)
    SubmitState.IsCheckingName = false
    SubmitState.GuildHasSameName = SameName
    if SubmitState.IsClosed then
      return
    end
    local Dialog = DialogHolder.Dialog
    if not IsValid(Dialog) then
      return
    end
    local InputWidget = Dialog:GetContentWidgetByName(GuildRenameCardInputName)
    if not IsValid(InputWidget) then
      return
    end
    local CurrentName = string.trim(InputWidget:GetText() or "")
    if CurrentName ~= SubmitState.CheckingName then
      SubmitState.NeedCheckName = true
      return
    end
    self:OnGuildRenameCardSubmit(Dialog, ResourceId, SubmitState)
  end
  
  local Dialog = self:GetUIMgr():ShowCommonPopupUI(GuildRenameCardDialogId, {
    EditTextConfig = {
      Text = "",
      IsMultiLine = false,
      TextLimit = GuildCommon.GuildNameMaxLen,
      bLimitSpaces = true,
      ResidentTipText = GText("UI_Guild_RenameCardNoResetCd"),
      Events = {
        OnTextChanged = function(_, Text)
          SubmitState.NeedCheckName = true
          local TargetDialog = DialogHolder.Dialog
          if not IsValid(TargetDialog) then
            return
          end
          local ButtonBar = TargetDialog:GetButtonBar()
          if not (ButtonBar and ButtonBar.Btn_Yes) or not ButtonBar.Btn_Yes.ForbidBtn then
            return
          end
          ButtonBar.Btn_Yes:ForbidBtn(string.trim(Text or "") == "")
        end
      }
    },
    DontCloseWhenRightBtnClicked = true,
    RightCallbackFunction = function(_, _, ClickedDialog)
      self:OnGuildRenameCardSubmit(ClickedDialog, ResourceId, SubmitState)
    end,
    OnCloseCallbackFunction = function()
      SubmitState.IsClosed = true
    end
  }, ParentWidget)
  DialogHolder.Dialog = Dialog
  return Dialog
end

function Component:OnGuildRenameCardSubmit(Dialog, ResourceId, SubmitState)
  if not IsValid(Dialog) or SubmitState.IsClosed or SubmitState.IsSubmitting then
    return
  end
  local InputWidget = Dialog:GetContentWidgetByName(GuildRenameCardInputName)
  if not IsValid(InputWidget) then
    return
  end
  local Name = string.trim(InputWidget:GetText() or "")
  if "" == Name then
    InputWidget:ShowTips(GText("UI_REGISTER_EMPTY"), 2)
    return
  end
  if GuildCommon.IsPureNumberOrSymbolName(Name) then
    InputWidget:ShowTips(GText("GuildNameNoPureNumber"), 1)
    return
  end
  if SubmitState.IsCheckingName then
    return
  end
  if SubmitState.NeedCheckName then
    SubmitState.NeedCheckName = false
    SubmitState.GuildHasSameName = false
    SubmitState.IsCheckingName = true
    SubmitState.CheckingName = Name
    self:SendRpcGuildCheckName(Name, SubmitState.OnCheckNameCallback)
    return
  end
  if SubmitState.GuildHasSameName then
    InputWidget:ShowTips(GText("UI_GuildNameDuplicate"), 1)
    SubmitState.NeedCheckName = true
    return
  end
  SubmitState.IsSubmitting = true
  HeroUSDKUtils.CheckStringSensitive(InputWidget, Name, function()
    SubmitState.IsSubmitting = false
    if not SubmitState.IsClosed and IsValid(InputWidget) then
      InputWidget:ShowTips(GText("UI_REGISTER_BANNEDINPUT"), 1)
    end
  end, function()
    if not IsValid(self) then
      SubmitState.IsSubmitting = false
      return
    end
    self:SendUseChangeGuildNameResourceInBag(ResourceId, Name, function(Ret)
      SubmitState.IsSubmitting = false
      if Ret == ErrorCode.RET_SUCCESS and not SubmitState.IsClosed and IsValid(Dialog) then
        Dialog:OnClose()
      end
    end)
  end, false)
end

function Component:SendUseChangeGuildNameResourceInBag(ResourceId, Name, Callback)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:UseChangeGuildNameResourceInBag(ResourceId, Name, function(Ret)
    if IsValid(self) then
      self:RecvUseChangeGuildNameResourceInBag(Ret, Name)
    end
    if Callback then
      Callback(Ret)
    end
  end)
end

function Component:RecvUseChangeGuildNameResourceInBag(Ret, Name)
  self:UpdateCurrGuildProp(Ret, "Name", Name)
  self:ApplyRenamedGuildBadgeText(Name, Ret)
  if Ret == ErrorCode.RET_SUCCESS then
    self:GetUIMgr():ShowUITip(UIConst.Tip_CommonToast, GText("UI_EditSuccessful"))
  end
  self:RecvCommon(Ret, GuildCommon.EventID.OnGuildRenameByCard)
end

function Component:ApplyRenamedGuildBadgeText(Name, Ret)
  if Ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  local CurrGuild = self:GetModel():GetCurrGuild()
  local OldBadgeText = CurrGuild and CurrGuild.BadgeText or ""
  local BadgeText = GuildCommon.NormalizeGuildBadgeText(Name, OldBadgeText)
  self:UpdateCurrGuildProp(Ret, "BadgeText", BadgeText)
end

return Component
