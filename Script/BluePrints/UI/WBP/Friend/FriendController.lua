local FriendModel = require("BluePrints.UI.WBP.Friend.FriendModel")
local FriendCommon = require("BluePrints.UI.WBP.Friend.FriendCommon")
local CommonUtils = require("Utils.CommonUtils")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
  self._Dialog = nil
  self.FriendRequest_Dialog = nil
  self.BlackList_Dialog = nil
  self.RefreshRecommandTimer = nil
  self.ReqRecvTimer = "Friend_ReqRecvTimer"
  self:GetAvatar()
end

function M:GetModel()
  return FriendModel
end

function M:GetEventName()
  return EventID.FriendControllerEvent
end

function M:OpenView(WorldContex, TabType)
  return M.Super.OpenView(self, WorldContex, FriendCommon.MainUIId, false, TabType)
end

function M:OpenDialog(WorldContex, DialogType)
  if DialogType == FriendCommon.FriendDialogType.FriendRequest then
    local Params_FriendRequest = {
      Type = DialogType,
      Title = GText("UI_Friend_FriendRequest"),
      HintText = GText("UI_TRAIN_CLOSE"),
      ButtonBarName = "Dialog_Button_L",
      ShowBKeyClose = true,
      TitleWidget = "DialogTitle_Number"
    }
    self.FriendRequest_Dialog = self:GetUIMgr(WorldContex):ShowCommonPopupUI(100131, Params_FriendRequest, self:GetView(WorldContex))
  elseif DialogType == FriendCommon.FriendDialogType.BlackList then
    local Params_BlackList = {
      Type = DialogType,
      Title = GText("UI_Friend_BlackList"),
      HintText = GText("UI_TRAIN_CLOSE"),
      ButtonBarName = nil,
      TitleWidget = "DialogTitle_Number"
    }
    self.BlackList_Dialog = self:GetUIMgr(WorldContex):ShowCommonPopupUI(100132, Params_BlackList, self:GetView(WorldContex))
  end
end

function M:GetView(WorldContex)
  return M.Super.GetView(self, WorldContex, FriendCommon.UIName)
end

function M:GetDialog(WorldContex)
  if IsValid(self.BlackList_Dialog) then
    return self.BlackList_Dialog
  else
    self.BlackList_Dialog = nil
  end
  if IsValid(self.FriendRequest_Dialog) then
    return self.FriendRequest_Dialog
  else
    self.FriendRequest_Dialog = nil
  end
end

function M:OpenAddFriendDialog(WorldContext, AvatarInfo)
  DebugPrint("OpenAddFriendDialog", AvatarInfo)
  local Params = {
    UseGenaral = true,
    MultilineType = 1,
    TextLenMax = DataMgr.GlobalConstant.FriendReqMaxLen.ConstantValue,
    DefaultText = GText("UI_Friend_ReDef"),
    HintText = GText("UI_Friend_RequestHint"),
    OnSDKChecked = function(bRes, InputWidget, ...)
      if not bRes then
        return
      end
      local TargetUid = self:GetSocialUid(AvatarInfo.Uid, AvatarInfo)
      self:SendRequest(FriendCommon.EventId.AddFriend, TargetUid, (...), AvatarInfo)
    end,
    EditTextConfig = {Owner = self, IsMultiLine = false}
  }
  if self:IsGamepad() then
    Params.AutoFocus = true
  end
  self:GetUIMgr(WorldContext):ShowCommonPopupUI(FriendCommon.RequestDialogNotInput, Params, self:GetView(WorldContext))
end

function M:OpenAddBlacklistDialog(WorldContext, AvatarInfo)
  local Params = {
    RightCallbackFunction = function()
      local TargetUid = self:GetSocialUid(AvatarInfo.Uid, AvatarInfo)
      self:SendRequest(FriendCommon.EventId.AddBlackList, TargetUid, AvatarInfo)
    end
  }
  if self:IsGamepad() then
    Params.AutoFocus = true
  end
  self:GetUIMgr(WorldContext):ShowCommonPopupUI(FriendCommon.PullBlackDialog, Params, self:GetView(WorldContext))
end

function M:OverrideButtonSound(button, soundEvent, eventKey)
  button:TryOverrideSoundFunc(function()
    AudioManager(button):PlayUISound(button, soundEvent, eventKey, nil)
  end)
end

function M:SendRequest(Reason, ...)
  DebugPrint("+++++++++++++++FriendController:SendRequest  Reason =" .. Reason)
  if M["Send" .. Reason] then
    if M["Recv" .. Reason] then
    end
    M["Send" .. Reason](M, ...)
  end
end

function M:RecvResponse(Reason, ...)
  if M["Recv" .. Reason] then
    M["Recv" .. Reason](M, ...)
  end
end

function M:SendAddFriend(TargetUid, Message, AvatarInfo)
  Message = Message or GText("UI_Friend_ReDef")
  if not TargetUid then
    self:CheckError(ErrorCode.RET_FRIEND_UID_NOT_EXIST, true)
    return
  end
  self:GetAvatar():FriendSendAddRequest(TargetUid, Message)
end

function M:RecvRefreshMatchFriend(ErrCode, ...)
  if not self:CheckError(ErrCode, true) then
    return
  end
  self:NotifyEvent(FriendCommon.EventId.RefreshMatchFriendUI)
end

function M:SendRefreshMatchFriend()
  self:GetAvatar():RefreshRecentMatchedFriend()
end

function M:RecvAddFriend(ErrCode, ...)
  local Uid, bToast = ...
  if nil == bToast then
    bToast = true
  end
  ChatController:GetModel():AddFriendReddotNode(Uid, true)
  if not self:CheckError(ErrCode, true) then
    return
  end
  if bToast then
    self:ShowToast(GText("UI_Toast_Friend_AddRequestSend"))
  end
  self:NotifyEvent(FriendCommon.EventId.AddFriend, Uid)
end

function M:SendRefreshFriend()
  if 0 == FriendModel:GetFriendDict():Length() then
    self:RecvResponse(FriendCommon.EventId.RefreshFriend, ErrorCode.RET_SUCCESS)
    return
  end
  self:GetAvatar():RefreshFriendData()
end

function M:RecvRefreshFriend(ErrCode)
  if ErrCode == ErrorCode.RET_FRIEND_REFRESH_TOO_FAST then
    ErrCode = ErrorCode.RET_SUCCESS
  end
  if not self:CheckError(ErrCode, true) then
    return
  end
  self:NotifyEvent(FriendCommon.EventId.RefreshFriend, ErrCode)
end

function M:SendAgreeAdd(Uid, Coroutine)
  self:GetAvatar():FriendAgreeAddRequest(Uid, Coroutine)
  DebugPrint("SendAgreeAdd ++++++++++++++++++++++++++++++++++++++")
end

function M:RecvAgreeAdd(ErrCode, ...)
  local Uid, Coroutine = ...
  if not Coroutine then
    self:NotifyEvent(FriendCommon.EventId.UnblockUI)
  else
    coroutine.resume(Coroutine, ErrCode)
    return
  end
  if not self:CheckError(ErrCode) then
    if ErrCode == ErrorCode.RET_FRIEND_OTHER_PARTY_HOLD_MAX or ErrCode == ErrorCode.RET_FRIEND_REQUEST_TIMEOUT then
      self:NotifyEvent(FriendCommon.EventId.AgreeAdd, false, Uid)
    end
    return
  end
  self:TryProcessNextFriendReq(Uid)
  self:GetModel():RemoveLastRequests(Uid)
  local FriendName = self:GetModel():GetFriendDict()[Uid].Info.Nickname
  self:ShowToast(string.format(GText("UI_Toast_Friend_PassRequest"), FriendName))
  self:NotifyEvent(FriendCommon.EventId.AgreeAdd, false, Uid)
end

function M:TryProcessNextFriendReq(Uid)
  local PopReq = FriendModel:PopFriendReqInfo()
  if PopReq and PopReq.Uid == Uid then
    if self:IsExistTimer(self.ReqRecvTimer) then
      self:StopTimer(self.ReqRecvTimer)
    end
    self:AddTimer(0.01, function()
      self:SetUpFriendReqTimer(TeamCommon.LoopTimerInterval)
    end)
  end
end

function M:SendRefuseAdd(Uid, Coroutine)
  self:TryProcessNextFriendReq(Uid)
  local FriendName = self:GetModel():GetRequestRecvBox()[Uid].Info.Nickname
  self:GetAvatar():FriendRefuseAddRequest(Uid, FriendName, Coroutine)
end

function M:RecvRefuseAdd(ErrCode, ...)
  local Uid, FriendName, Coroutine = ...
  if not Coroutine then
    self:NotifyEvent(FriendCommon.EventId.UnblockUI)
  else
    coroutine.resume(Coroutine, ErrCode)
    return
  end
  if not self:CheckError(ErrCode) then
    if ErrCode == ErrorCode.RET_FRIEND_OTHER_PARTY_HOLD_MAX or ErrCode == ErrorCode.RET_FRIEND_REQUEST_TIMEOUT then
      self:NotifyEvent(FriendCommon.EventId.RefuseAdd, false, Uid)
    end
    return
  end
  self:GetModel():RemoveLastRequests(Uid)
  self:ShowToast(string.format(GText("UI_Toast_Friend_RejectRequest"), FriendName))
  self:NotifyEvent(FriendCommon.EventId.RefuseAdd, false, Uid)
end

function M:SendDeleteFriend(Uid)
  local FriendName = self:GetModel():GetFriendDict()[Uid].Info.Nickname
  self:GetAvatar():FriendSendDeleteRequest(Uid, FriendName)
end

function M:RecvDeleteFriend(ErrCode, ...)
  if not self:CheckError(ErrCode) then
    return
  end
  local Uid, FriendName = ...
  ChatController:SendChatNewMsgRead(Uid)
  ChatController:GetModel():ReadChannelMessage(ChatCommon.ChannelDef.Friend, Uid)
  if FriendName then
    self:ShowToast(string.format(GText("UI_Toast_Friend_DeleteSuccess"), FriendName))
  end
  self:NotifyEvent(FriendCommon.EventId.DeleteFriend, false, Uid)
end

function M:SendSetRemark(Uid, Remark)
  self:GetAvatar():FriendSetRemark(Uid, Remark)
end

function M:RecvSetRemark(ErrCode, ...)
  if not self:CheckError(ErrCode) then
    return
  end
  local Uid = (...)
  self:NotifyEvent(FriendCommon.EventId.SetRemark, Uid)
end

function M:SendSetStar(Uid, bStar)
  if bStar then
    self:GetAvatar():FriendSetStar(Uid, bStar)
  else
    self:GetAvatar():FriendCancleStar(Uid, bStar)
  end
end

function M:RecvSetStar(ErrCode, ...)
  if not self:CheckError(ErrCode) then
    return
  end
  local Uid, bStar = ...
  self:ShowToast(GText(bStar and "UI_Toast_Friend_SetStarSuccess" or "UI_Toast_Friend_RemoveStarSuccess"))
  self:NotifyEvent(FriendCommon.EventId.SetStar, true)
end

function M:SendSearch(Uid)
  self:GetAvatar():FriendSearch(Uid)
end

function M:RecvSearch(ErrCode, ...)
  local Uid, AvatarInfo = ...
  self:GetModel():CacheSearchRes(AvatarInfo)
  if not self:CheckError(ErrCode) then
    self:NotifyEvent(FriendCommon.EventId.Search, false)
    return
  end
  AvatarInfo.Uid = Uid
  self:NotifyEvent(FriendCommon.EventId.Search, true)
end

function M:GetSocialUid(Uid, AvatarInfo)
  return AvatarInfo and AvatarInfo.RealUID or Uid
end

function M:SendAddBlackList(TargetUid, AvatarInfo)
  DebugPrint("SendAddBlackList TargetUid", TargetUid)
  if not TargetUid or TargetUid < 10000 then
    self:CheckError(ErrorCode.RET_FRIEND_UID_NOT_EXIST, true)
    return
  end
  local PureAvatarInfo = {
    Uid = TargetUid,
    Nickname = AvatarInfo.Nickname,
    HeadIconId = AvatarInfo.HeadIconId,
    HeadFrameId = AvatarInfo.HeadFrameId,
    Level = AvatarInfo.Level
  }
  self:GetAvatar():FriendAddBlackList(TargetUid, PureAvatarInfo)
end

function M:RecvAddBlackList(ErrCode, ...)
  if not self:CheckError(ErrCode) then
    return
  end
  local Uid, FriendName = ...
  ChatController:GetModel():ClearReddotCount(ChatCommon.ChannelDef.Friend, Uid)
  ChatController:GetModel():SetCurrentFriendUid(nil)
  self:ShowToast(string.format(GText("UI_Toast_Friend_AddBlcakListSuccess"), FriendName))
  self:NotifyEvent(FriendCommon.EventId.AddBlackList, false, Uid)
end

function M:SendCancelBlackList(TargetUid, AvatarInfo)
  DebugPrint("SendCancelBlackList TargetUid", TargetUid)
  local BlackInfo = self:GetModel():GetBlackListDict()[TargetUid]
  local Nickname = BlackInfo and BlackInfo.Nickname or AvatarInfo and AvatarInfo.Nickname or ""
  self:GetAvatar():FriendCancleBlackList(TargetUid, Nickname)
end

function M:RecvCancelBlackList(ErrCode, ...)
  if not self:CheckError(ErrCode) then
    return
  end
  local Uid, Nickname = ...
  self:ShowToast(string.format(GText("UI_Toast_Friend_CancelBlcakListSuccess"), Nickname))
  self:NotifyEvent(FriendCommon.EventId.CancelBlackList, false)
end

function M:SendAgreeAll()
  local Coroutine
  local NewErrCode = ErrorCode.RET_SUCCESS
  DebugPrint("SendAgreeAll ++++++++++++++++++++++++++++++++++++++")
  Coroutine = coroutine.create(function()
    for _, Uid in ipairs(CommonUtils.Keys(self:GetModel():GetRequestRecvBox())) do
      self:SendAgreeAdd(Uid, Coroutine)
      NewErrCode = coroutine.yield()
      if NewErrCode == ErrorCode.RET_SUCCESS or NewErrCode == ErrorCode.RET_FRIEND_OTHER_PARTY_HOLD_MAX or NewErrCode == ErrorCode.RET_FRIEND_REQUEST_TIMEOUT then
      else
        break
      end
      self:GetModel():RemoveLastRequests(Uid)
    end
    self:RecvResponse(FriendCommon.EventId.AgreeAll, NewErrCode)
  end)
  coroutine.resume(Coroutine)
end

function M:RecvAgreeAll(ErrCode)
  DebugPrint("RecvAgreeAll ++++++++++++++++++++++++++++++++++++++")
  if not self:CheckError(ErrCode) then
    if ErrCode == ErrorCode.RET_FRIEND_OTHER_PARTY_HOLD_MAX or ErrCode == ErrorCode.RET_FRIEND_REQUEST_TIMEOUT then
      ErrCode = ErrorCode.RET_SUCCESS
    else
      return
    end
  end
  self:ShowToast(GText("UI_Toast_Friend_PassAllRequest"))
  self:NotifyEvent(FriendCommon.EventId.AgreeAll, false)
end

function M:SendRefuseAll()
  local Coroutine
  local NewErrCode = ErrorCode.RET_SUCCESS
  Coroutine = coroutine.create(function()
    for _, Uid in ipairs(CommonUtils.Keys(self:GetModel():GetRequestRecvBox())) do
      self:SendRefuseAdd(Uid, Coroutine)
      NewErrCode = coroutine.yield()
      if NewErrCode == ErrorCode.RET_SUCCESS or NewErrCode == ErrorCode.RET_FRIEND_OTHER_PARTY_HOLD_MAX or NewErrCode == ErrorCode.RET_FRIEND_REQUEST_TIMEOUT then
      else
        break
      end
      self:GetModel():RemoveLastRequests(Uid)
    end
    self:RecvResponse(FriendCommon.EventId.RefuseAll, NewErrCode)
  end)
  coroutine.resume(Coroutine)
end

function M:RecvRefuseAll(ErrCode)
  if not self:CheckError(ErrCode) then
    if ErrCode == ErrorCode.RET_FRIEND_OTHER_PARTY_HOLD_MAX or ErrCode == ErrorCode.RET_FRIEND_REQUEST_TIMEOUT then
      ErrCode = ErrorCode.RET_SUCCESS
    else
      return
    end
  end
  self:ShowToast(GText("UI_Toast_Friend_RejectAllRequest"))
  self:NotifyEvent(FriendCommon.EventId.RefuseAll, false)
end

function M:SendGetRecommandList()
  self:GetAvatar():FriendGenerateRecommendList()
  self:GetModel():ClearSearchRes()
  self:StopTimer(self.RefreshRecommandTimer)
  self:StartRefreshRecommandTimer()
end

function M:RecvGetRecommandList(ErrCode, ...)
  if not self:CheckError(ErrCode) then
    return
  end
  self:NotifyEvent(FriendCommon.EventId.GetRecommandList, true)
end

function M:RecvRealUpdateFriendInfo(AvatarInfo)
  if TeamController then
    TeamController:RecvTeamMemberPropChange(AvatarInfo, AvatarInfo.Uid)
  end
  FriendModel:GetFriendList(true)
  self:NotifyEvent(FriendCommon.EventId.UpdateOneFriend, AvatarInfo.Uid)
end

function M:RecvNewFriendRequestReceiveBox(Keys)
  FriendModel:GetFriendRequestList(true)
  FriendModel:AddReddotCount()
  for _, ReqUid in ipairs(Keys) do
    local FriendReq = FriendModel:GetRequestRecvBox()[ReqUid]
    if FriendReq then
      FriendReq.Info.Remark = FriendReq.Remark
      FriendModel:PushFriendReqInfo(FriendReq.Info)
      self:SetUpFriendReqTimer(TeamCommon.LoopTimerInterval)
    end
  end
end

function M:StartRefreshRecommandTimer()
  local Interval = 0.2
  local TotalTime = DataMgr.GlobalConstant.RecommandFriendCD.ConstantValue + 0.2
  local Timer = self:AddTimer(Interval, function()
    TotalTime = TotalTime - Interval
    if TotalTime <= 0 then
      self:NotifyEvent(FriendCommon.EventId.RecommandCdUpdate, true)
      self:StopTimer(self.RefreshRecommandTimer)
      self.RefreshRecommandTimer = nil
      TotalTime = DataMgr.GlobalConstant.RecommandFriendCD.ConstantValue + 0.2
      return
    end
    local Percent = TotalTime / DataMgr.GlobalConstant.RecommandFriendCD.ConstantValue
    self:NotifyEvent(FriendCommon.EventId.RecommandCdUpdate, false, Percent)
  end, true, 0, nil, true)
  self.RefreshRecommandTimer = Timer
end

function M:SetUpFriendReqTimer(Interval)
  self.bProcessingFriendReq = true
  local CurrReq = FriendModel:GetBackFriendReqInfo()
  local FriendView = M.Super.GetView(self, GWorld.GameInstance, FriendCommon.TipUIName)
  if not CurrReq then
    DebugPrint(LXYTag, "SetUpFriendReqTimer，队列空了，好友申请流程退出")
    if IsValid(FriendView) then
      FriendView:Close("FriendReqQueue Empty")
      DebugPrint(LXYTag, "SetUpFriendReqTimer::关闭申请UI")
    end
    self:ShutDownFriendReqTip()
    return
  end
  if TeamController.bProcessingTeamInvite then
    return
  end
  DebugPrint(LXYTag, "开始好友申请定时器")
  if not self:GetUIMgr():GetUIObj("CommonChangeScene") then
    if not IsValid(FriendView) then
      DebugPrint(LXYTag, "打开好友申请UI")
      FriendView = M.Super.OpenView(self, GWorld.GameInstance, FriendCommon.TipUIName, CurrReq, true)
    else
      DebugPrint(LXYTag, "重用好友申请UI")
      FriendView:StopAllAnimations()
      FriendView:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      FriendView:Construct()
      FriendView:InitUIInfo(FriendCommon.TipUIName, false, nil, CurrReq, true)
    end
  end
  local MaxRemainTime = FriendCommon.TipsMaxRemainTime
  local FriendReqRemainTime = MaxRemainTime
  self:AddTimer(Interval, function()
    FriendReqRemainTime = FriendReqRemainTime - Interval
    if IsValid(FriendView) and not FriendView:HasFocusedDescendants() and self:IsGamepad() then
      DebugPrint(LXYTag, WarningTag, "好友申请UI需要抢夺聚焦！！！！！！")
      FriendView:SetFocus()
    end
    if FriendReqRemainTime > 0 then
      TeamController:NotifyEvent(TeamCommon.EventId.TeamInviteWaiting, FriendReqRemainTime / MaxRemainTime)
      return
    end
    self:StopTimer(self.ReqRecvTimer)
    TeamController:NotifyEvent(TeamCommon.EventId.TeamInviteWaiting, 0)
  end, true, 0, self.ReqRecvTimer)
end

function M:ShutDownFriendReqTip()
  if self:IsExistTimer(self.ReqRecvTimer) then
    self:StopTimer(self.ReqRecvTimer)
  end
  self.bProcessingFriendReq = false
  if TeamController.bProcessingTeamInvite then
    self:AddTimer(0.1, function()
      TeamController:SetUpBeInviteTimer(TeamCommon.LoopTimerInterval)
    end)
  end
  FriendModel:ClearFriendReqInfo()
end

function M:GenAddBlackListFunc(Widget, HeadAnchor)
  return function(Content, AvatarInfo)
    local TargetUid = self:GetSocialUid(AvatarInfo.Uid, AvatarInfo)
    if FriendModel:GetBlackListDict()[TargetUid] then
      Content.Text = GText("UI_Friend_DelBlackList")
      
      function Content.Callback()
        self:SendCancelBlackList(TargetUid, AvatarInfo)
        HeadAnchor:Close()
      end
    else
      Content.Text = GText("UI_Friend_AddBlackList")
      
      function Content.Callback()
        self:OpenAddBlacklistDialog(Widget, AvatarInfo)
        HeadAnchor:Close()
      end
    end
  end
end

function M:GenAccusePlayerFunc(Widget, HeadAnchor, ...)
  local MsgContent, HideItemTips, OnTextChange, OnTextComposing, OnEditTextFocusReceived = ...
  local IsInDungeon = GWorld:GetAvatar():IsInDungeon()
  local IsInHardBoss = GWorld:GetAvatar():IsInHardBoss()
  return function(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_Accuse")
    
    function Content.Callback()
      local Params = {
        Nickname = AvatarInfo.Nickname,
        UID = AvatarInfo.Uid,
        RealUID = AvatarInfo.RealUID,
        Level = AvatarInfo.Level,
        TextLenMax = 50,
        ChatMessage = MsgContent,
        ForbidRightBtn = true,
        DontCloseWhenRightBtnClicked = true
      }
      Params.HideItemTips = HideItemTips
      Params.EditTextConfig = {
        Owner = Widget,
        TextLimit = 50,
        Events = {
          OnTextChanged = OnTextChange,
          OnTextComposing = OnTextComposing,
          OnEditTextFocusReceived = OnEditTextFocusReceived
        }
      }
      Params.InGameOnly = Widget.InGameOnly
      Params.AllowNegativeAttitude = IsInDungeon or IsInHardBoss
      ChatController:OpenChatReportDialog(Params)
      HeadAnchor:Close()
    end
  end
end

_G.FriendController = M
return M
