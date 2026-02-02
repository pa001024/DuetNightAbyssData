local OnlineActionModel = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel")
local OnlineActionCommon = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init(bClear)
  if self.bInited and not bClear then
    return
  end
  DebugPrint("OnlineActionController Init")
  M.Super.Init(self)
  OnlineActionModel:Init(bClear)
  self.OpenReason = nil
  self.MainPage = nil
  self.OnlineActionBtn = nil
  self:InitEvent()
end

function M:InitEvent()
  EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionApplication, self)
  EventManager:AddEvent(EventID.ReceivedOthersOnlineActionApplication, self, self.OnReceiveApplyInfo)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationReject, self)
  EventManager:AddEvent(EventID.OnReceivedOnlineActionApplicationReject, self, self.OnReceivedRejectApply)
  EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionInvitation, self)
  EventManager:AddEvent(EventID.ReceivedOthersOnlineActionInvitation, self, self.OnReceivedInvitation)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationReject, self)
  EventManager:AddEvent(EventID.OnReceivedOnlineActionInvitationReject, self, self.OnReceivedRejectInvitation)
  EventManager:RemoveEvent(EventID.RequestDeadRegionOnlineItem, self)
  EventManager:AddEvent(EventID.RequestDeadRegionOnlineItem, self, self.OnRequestDeadRegionOnlineItem)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationAgree, self)
  EventManager:AddEvent(EventID.OnReceivedOnlineActionApplicationAgree, self, self.OnReceivedOnlineActionApplicationAgree)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationAgree, self)
  EventManager:AddEvent(EventID.OnReceivedOnlineActionInvitationAgree, self, self.OnReceivedOnlineActionInvitationAgree)
end

function M:RemoveEvent()
  EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionApplication, self)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationReject, self)
  EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionInvitation, self)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationReject, self)
  EventManager:RemoveEvent(EventID.RequestDeadRegionOnlineItem, self)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationAgree, self)
  EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationAgree, self)
end

function M:OnCreatOnlineAction(UniqueId)
  if not OnlineActionModel:IsInRegionOnline() then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local CurResourceId = Player.CurResourceId
  if 0 == CurResourceId then
    DebugPrint("角色已停止联机动作")
    return false
  end
  if not OnlineActionCommon.UseSyncNearbyPlayers then
    DebugPrint("关闭多线程查找附近玩家，在Lua层寻找")
    OnlineActionModel:FindPlayerAroundOld()
  else
    local Sync = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
    if Sync then
      Sync:StartNearbyQuery()
    end
  end
  self.OpenReason = 1
  self:ChangeAction(UniqueId)
  self:ShowBtn(1)
  DebugPrint("yklua :角色创建联机机关 UniqueId " .. UniqueId)
end

function M:ChangeAction(UniqueId)
  OnlineActionModel:ChangeAction(UniqueId)
end

function M:OnRequestDeadRegionOnlineItem()
  DebugPrint("联机动作Btn收到动作关系消息，开始隐藏OnRequestDeadRegionOnlineItem")
  self:OnEndOnlineAction()
end

function M:OnEndOnlineAction()
  if OnlineActionCommon.UseSyncNearbyPlayers then
    local Sync = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
    if Sync then
      Sync:StopNearbyQuery()
    end
  end
  OnlineActionModel:ClearAllApply()
  if 1 == self.OpenReason then
    if OnlineActionModel:HaveOtherInvitation() then
      self.OpenReason = 2
    else
      self.OpenReason = nil
      self:HideBtn()
    end
  end
end

function M:IsShowingBtn()
  return self.OpenReason ~= nil
end

function M:ShowBtn(Reason)
  self.OpenReason = Reason
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if not BattleMain then
    ScreenPrint("yklua OnlineAction:ShowBtn 没有拿到BattleMain")
    return
  end
  local OnlineActionBtn = UIManager(self):CreateWidget(OnlineActionCommon.OnlineActionBtnBPPath)
  if not OnlineActionBtn then
    ScreenPrint("yklua OnlineAction:ShowBtn 创建按钮失败")
    return
  end
  self.OnlineActionBtn = OnlineActionBtn
  BattleMain.Pos_OnlineAction:ClearChildren()
  BattleMain.Pos_OnlineAction:AddChild(OnlineActionBtn)
  BattleMain.Pos_OnlineAction:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  BattleMain.OnlineActionBtn = OnlineActionBtn
  OnlineActionBtn.Parent = BattleMain
  OnlineActionBtn:Show()
end

function M:ShowBtnBubble(BubbleKind)
  if self.OnlineActionBtn then
    self.OnlineActionBtn:ShowOrHideBubble(BubbleKind)
  end
end

function M:HideBtn()
  DebugPrint("OnlineAction:HideBtn")
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if not BattleMain then
    ScreenPrint("yklua OnlineAction:HideBtn 没有拿到BattleMain")
    return
  end
  if self.OnlineActionBtn and IsValid(self.OnlineActionBtn) then
    self.OnlineActionBtn:PlayOutAni(function()
      BattleMain.Pos_OnlineAction:ClearChildren()
      BattleMain.OnlineActionBtn = nil
      self.OnlineActionBtn = nil
      self.OpenReason = nil
    end)
  else
    BattleMain.Pos_OnlineAction:ClearChildren()
    BattleMain.OnlineActionBtn = nil
    self.OnlineActionBtn = nil
    self.OpenReason = nil
  end
end

function M:OpenView(PlayerInfo, ForceServerData)
  DebugPrint("OnlineAction:OpenView")
  if 1 == self.OpenReason then
    OnlineActionModel:FindPlayerAround()
  end
  AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_panel_expand", "OnlineActionPageOpen", nil)
  self.MainPage = M.Super.OpenView(self, nil, OnlineActionCommon.UIName)
  self.MainPage:InitBaseView(self.OpenReason)
  return self.MainPage
end

function M:SetBtnReddotRead()
  if self.OnlineActionBtn then
    self.OnlineActionBtn:ShowOrHideReddot(false)
    self.OnlineActionBtn:ShowOrHideBubble(0)
  end
end

function M:CloseView()
  if self.OnlineActionBtn and IsValid(self.OnlineActionBtn) then
    self.OnlineActionBtn:ShowOrHideReddot(false)
    self.OnlineActionBtn:ShowOrHideBubble(0)
  end
  self:CheckHideBtn()
  AudioManager(self):SetEventSoundParam(self.OnlineActionBtn, "OnlineActionPageOpen", {ToEnd = 1})
  OnlineActionModel:SetAllInfoRead()
  self.MainPage = nil
end

function M:CheckHideBtn()
  local isDoingAction = OnlineActionModel:GetActionUniqueId() ~= nil
  local hasInvitation = OnlineActionModel:HaveOtherInvitation()
  local hasApply = OnlineActionModel:HaveOtherApply()
  if not isDoingAction and not hasInvitation and not hasApply then
    self:HideBtn()
  end
end

function M:NotifyTick(InDeltaTime)
  if self.IsDestroied then
    return
  end
  OnlineActionModel:NotifyTick(InDeltaTime)
  if self.MainPage then
    self.MainPage:NotifyTick(InDeltaTime)
  end
end

function M:SendMessage(Message)
  OnlineActionModel:SendMessage(Message)
end

function M:SendApplication(ApplyInfo)
end

function M:RejectAllApplications()
  DebugPrint("OnlineAction:RejectAllApplications")
  local applyInfos = OnlineActionModel:GetApplyInfos()
  if not applyInfos then
    return
  end
  for i = #applyInfos, 1, -1 do
    self:SendRejectApplication(applyInfos[i])
  end
end

function M:SendAcceptApplication(ApplyInfo)
  local applicant = OnlineActionModel:GetPlayerActor(ApplyInfo.Eid)
  if applicant and applicant.IsInRideMove and applicant:IsInRideMove() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_TargetCannotInteract"))
    OnlineActionModel:RemoveApplyInfo(ApplyInfo)
    return
  end
  DebugPrint("OnlineAction:SendAcceptApplication", ApplyInfo)
  local toReject = {}
  local applyInfos = OnlineActionModel:GetApplyInfos()
  if applyInfos then
    for _, otherApplyInfo in ipairs(applyInfos) do
      if otherApplyInfo.InteractiveId == ApplyInfo.InteractiveId and otherApplyInfo.Eid ~= ApplyInfo.Eid then
        DebugPrint("拒绝其他申请加入" .. otherApplyInfo.InteractiveId .. " " .. otherApplyInfo.Eid .. " " .. ApplyInfo.InteractiveId .. " " .. ApplyInfo.Eid)
        table.insert(toReject, otherApplyInfo)
      end
    end
  end
  local CanSit = self:CheckCanSit(ApplyInfo.UniqueId, ApplyInfo.Eid, true)
  OnlineActionModel:RemoveApplyInfo(ApplyInfo)
  if true ~= CanSit then
    return
  end
  if OnlineActionModel._Avatar and ApplyInfo.UniqueId then
    OnlineActionModel._Avatar:OnRequestUseOwnerRegionOnlineItem(ApplyInfo.Eid, true, OnlineActionModel:GetActionUniqueId(), ApplyInfo.InteractiveId)
  else
    DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
  end
  for _, rejectInfo in ipairs(toReject) do
    self:SendRejectApplication(rejectInfo)
    OnlineActionModel:RemoveApplyInfo(rejectInfo)
  end
  local Player = GWorld:GetAvatar():GetBornedChar(ApplyInfo.Eid)
  local GameState = UE4.UGameplayStatics.GetGameState(Player)
  local Mechanism = GameState.RegionOnlineMechanismMap:Find(ApplyInfo.UniqueId)
  local InteractiveComp = Mechanism.ChestInteractiveComponent
  print(_G.LogTag, "LXZ SendAcceptApplication", Mechanism, Mechanism:IsCanOnlineInteractive())
  if Mechanism and Mechanism:IsCanOnlineInteractive(Player) then
    Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, ApplyInfo.InteractiveId or 0)
  end
end

function M:SendRejectApplication(Application)
  OnlineActionModel:RemoveApplyInfo(Application)
  DebugPrint("OnlineAction:SendRejectApplication", Application)
  if Application.UniqueId == nil then
    DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
    return
  end
  if OnlineActionModel._Avatar then
    OnlineActionModel._Avatar:OnRequestUseOwnerRegionOnlineItem(Application.Eid, false, Application.UniqueId, Application.InteractiveId or 0)
  end
end

function M:RejectAllInvitations()
  DebugPrint("OnlineAction:RejectAllInvitations")
  local invitationInfos = OnlineActionModel:GetInvitationInfos()
  if not invitationInfos then
    return
  end
  for i = #invitationInfos, 1, -1 do
    self:SendRejectInvitation(invitationInfos[i])
  end
end

function M:SendInvitation(InvitationInfo, Index)
  if OnlineActionModel:GetActionUniqueId() == nil then
    DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
    return
  end
  local ret = OnlineActionModel:CheckNearbyInfoVaild(InvitationInfo, Index)
  if -1 == ret then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invite_State"))
    return
  end
  if -2 == ret then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invite_Sitting"))
    return
  end
  if -3 == ret then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_SitOccupied"))
    return
  end
  DebugPrint("OnlineAction:SendInvitation", InvitationInfo)
  if OnlineActionModel._Avatar then
    local interactiveId0 = math.max(0, (Index or 1) - 1)
    OnlineActionModel._Avatar:RequestHostInvitationOther(InvitationInfo.Eid, OnlineActionModel:GetActionUniqueId(), interactiveId0, 0)
  end
end

function M:SendRejectInvitation(InvitationInfo)
  OnlineActionModel:RemoveInvitationInfo(InvitationInfo)
  DebugPrint("OnlineAction:SendRejectInvitation", InvitationInfo)
  if InvitationInfo.UniqueId == nil then
    DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
    return
  end
  if OnlineActionModel._Avatar then
    OnlineActionModel._Avatar:OnRequestOtherUserRegionOnlineItem(InvitationInfo.Eid, false, InvitationInfo.UniqueId, InvitationInfo.InteractiveId or 0)
  end
end

function M:SendAcceptInvitation(InvitationInfo)
  OnlineActionModel:RemoveInvitationInfo(InvitationInfo)
  DebugPrint("OnlineAction:SendAcceptInvitation", InvitationInfo)
  if InvitationInfo.UniqueId == nil then
    DebugPrint("缺少了UniqueId，应该是假数据OnlineAction:OnReceivedRejectApply")
    return
  end
  local player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if player and player.IsInRideMove and player:IsInRideMove() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_CannotInteract"))
    return
  end
  local SelfEid = OnlineActionModel:GetAvatar().Eid
  local CanSit = self:CheckCanSit(InvitationInfo.UniqueId, SelfEid, InvitationInfo.InteractiveId, true)
  if not CanSit then
    OnlineActionModel:RemoveInvitationInfo(InvitationInfo)
    return
  end
  if OnlineActionModel._Avatar then
    OnlineActionModel._Avatar:OnRequestOtherUserRegionOnlineItem(InvitationInfo.Eid, true, InvitationInfo.UniqueId, InvitationInfo.InteractiveId or 0)
  end
  self:RejectAllInvitations()
end

function M:CheckSeatFree(InteractiveId, UniqueId)
  UniqueId = UniqueId or OnlineActionModel:GetActionUniqueId()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
  if not Mechanism then
    ScreenPrint("交互失败：座椅不存在")
    return false
  end
  local Res = Mechanism:CheckInteractiveIdValid(InteractiveId)
  if not Res then
    ScreenPrint("交互失败：座椅被占用或者无效")
  end
  return Res
end

function M:CheckCanSit(UniqueId, PlayerEid, InteractiveId, bInvite)
  local code = OnlineActionModel:CheckJoinValid(PlayerEid, UniqueId, InteractiveId)
  if 0 ~= code then
    local tipKey = bInvite and "UI_RegionOnline_Invitation_Invalid" or "UI_RegionOnline_Apply_Invalid"
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(tipKey))
    return false
  end
  return true
end

function M:RealSit(UniqueId, PlayerEid, InteractiveId)
  local Player = GWorld:GetAvatar().Player or GWorld:GetMainPlayer()
  local GameState = UE4.UGameplayStatics.GetGameState(Player)
  local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
  local InteractiveComp = Mechanism.ChestInteractiveComponent
  print(_G.LogTag, "LXZ RealSit111", Mechanism, Mechanism:IsCanOnlineInteractive())
  if Mechanism then
    Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, InteractiveId)
  else
  end
end

function M:OnReceivedInvitation(RequestEid, UniqueId, InteractiveId)
  AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_request", "OnlineActionReceived", nil)
  ReddotManager.IncreaseLeafNodeCount("OnlineActionBtn", 1)
  DebugPrint("OnlineAction:OnReceivedInvitation", RequestEid, UniqueId, InteractiveId)
  local NewInfo = OnlineActionModel:AddInvitationInfo(RequestEid, UniqueId, InteractiveId)
  if self.OnlineActionBtn then
  else
    self:ShowBtn(2)
  end
  self:ShowBtnBubble(2)
  if self.MainPage and self.MainPage:IsVisible() then
    self.MainPage:OnReceivedNewInvitation(NewInfo)
  end
end

function M:OnReceiveApplyInfo(OwnerEid, UniqueId, InteractiveId)
  AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_request", "OnlineActionReceived", nil)
  if OnlineActionModel:GetAutoAcceptOnlineAction() == true then
    local ApplyInfo = {
      Eid = OwnerEid,
      UniqueId = UniqueId,
      InteractiveId = InteractiveId
    }
    self:SendAcceptApplication(ApplyInfo)
    return
  end
  ScreenPrint("联机动作收到申请" .. OwnerEid .. UniqueId .. InteractiveId)
  ReddotManager.IncreaseLeafNodeCount("OnlineActionBtn", 1)
  DebugPrint("OnlineAction:OnReceiveApplyInfo", OwnerEid, UniqueId, InteractiveId)
  local NewInfo = OnlineActionModel:AddApplyInfo(OwnerEid, UniqueId, InteractiveId)
  if self.OnlineActionBtn then
  else
    self:ShowBtn(2)
  end
  self:ShowBtnBubble(1)
  if self.MainPage and self.MainPage:IsVisible() then
    self.MainPage:OnReceivedNewApplication(NewInfo)
  end
end

function M:OnReceivedRejectInvitation(RequestEid, UniqueId, InteractiveId)
  DebugPrint("OnlineAction:OnReceivedRejectInvitation", RequestEid, UniqueId, InteractiveId)
end

function M:OnReceivedRejectApply(OwnerEid, UniqueId, InteractiveId)
  DebugPrint("OnlineAction:OnReceivedRejectApply", OwnerEid, UniqueId, InteractiveId)
  local PlayerName = OnlineActionModel:GetPlayerName(OwnerEid)
  local Text = string.format(GText("UI_RegionOnline_Apply_Refused"), PlayerName)
  AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_reject", "OnlineActionRejected", nil)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, Text)
end

function M:OnReceivedOnlineActionApplicationAgree(OwnerEid, UniqueId, InteractiveId)
  AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_accept", "OnlineActionAgreed", nil)
end

function M:OnReceivedOnlineActionInvitationAgree(RequestEid, UniqueId, InteractiveId)
  AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_accept", "OnlineActionAgreed", nil)
end

function M:ShowToastByErrorCode(IsInvite, ErrorCode)
  local Text = ""
  if IsInvite then
    Text = GText("UI_RegionOnline_Invitation_Invalid")
  else
    Text = GText("UI_RegionOnline_Apply_Invalid")
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, Text)
end

function M:Destory()
  DebugPrint("yklua 联机动作相关数据销毁OnlineAction:Destory")
  if self.OnlineActionBtn then
    self:HideBtn()
  end
  self.OpenReason = nil
  self.MainPage = nil
  M.Super.Destory(self)
end

function M:GetModel()
  return OnlineActionModel
end

function M:GetEventName()
  return ""
end

function M:GetView(WorldContex)
  return M.Super.GetView(self, WorldContex, OnlineActionCommon.UIName)
end

return M
