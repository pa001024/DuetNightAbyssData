require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.Activity.WBP_Activity_EntryBase_C",
  "BluePrints.Common.DelayFrameComponent"
})
M._components = {
  "BluePrints.UI.WBP.Activity.Widget.View.ActivityEntryBaseView"
}

function M:Initialize(Initializer)
  self.Super.Initialize(self)
  self.OwnerPlayer = nil
  self.CurTabId = nil
  self.CurTabIndex = nil
  self.IsNotFirstOpenSystem = false
  self.AllCurrentActivityID = {}
  self.AllCurrentActivityPage = {}
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.OwnerPlayer, self.NeedJumpToTabId, self.NeedJumpToActivityId, self.TryOutActivityNeedJumpToTabIndex, self.NeedJumpToCharId = ...
  if self.OwnerPlayer == nil or not UE4.UKismetSystemLibrary.IsValid(self.OwnerPlayer) then
    self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  end
  local Info = {}
  Info.OwnerPanel = self
  self.EventTypeTab:Init(Info)
  self:InitListenEvent()
  self:GenerateAllDataInfo()
  self:PlayInAnim()
  self.EventTypeTab:InitReddotTreeInfo()
  self:AddTimer(0.05, function()
    if not self or not self.EventTypeTab then
      return
    end
    if not self.NeedJumpToTabId then
      self.EventTypeTab:ResetPos()
      self.NeedJumpToTabId = nil
    end
  end)
  self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenEvent")
  EventManager:AddEvent(EventID.OnReturnToActivityEntry, self, self.OnReturnToActivityEntry)
  EventManager:AddEvent(EventID.OnLeaveActivityEntry, self, self.OnLeaveActivityEntry)
  EventManager:AddEvent(EventID.OnActivityEntryShowVisible, self, self.OnActivityEntryShowVisible)
  EventManager:AddEvent(EventID.OnActivityComplete, self, self.OnActivityComplete)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self.Activity_Tab.WBP_Com_Tab_ResourceBar:SetGetReplyOnBack(function()
    self:OnResourceBarBackToPage()
  end)
end

function M:OnResourceBarBackToPage()
  self:UpdateUIStyleInPlatform(true)
  self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Visible)
  self:AddDelayFrameFunc(function()
    local currentActivePage = self.AllCurrentActivityPage and self.AllCurrentActivityPage[self.CurTabId]
    if currentActivePage and type(currentActivePage.NotifyGamepadActionHintsChanged) == "function" then
      currentActivePage:NotifyGamepadActionHintsChanged()
    end
  end, 1, "ActivityEntry_ResourceBarBackRefresh")
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDevice = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:UpdateUIStyleInPlatform(CurInputDevice == ECommonInputType.Gamepad)
  if CurInputDevice == ECommonInputType.Gamepad then
    if not self:HasFocusedDescendants() or not self:HasAnyUserFocus() then
      return
    end
    if self.CurFocusWidgetItem then
      self.CurFocusWidgetItem:SetFocus()
    else
      self.List_Tab:SetFocus()
    end
  end
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnUpdateActivityEvent, self, self.OnUpdateActivityByAction)
  self:AddDispatcher(EventID.ActivityControllerEvent, self, self.OnUpdateActivityByControllerEvent)
end

function M:ReceiveEnterState(StackAction)
  if 1 == StackAction then
    self:OnRefreshCurrentPageAfterJump()
    self:UpdateActivityKeyTips()
    self:JudgeNeedShowVersionView()
  end
  self.Super.ReceiveEnterState(self, StackAction)
  local CurrentActivePage = self.AllCurrentActivityPage[self.CurTabId]
  if nil ~= CurrentActivePage and type(CurrentActivePage.ReceiveEnterStateSelf) == "function" then
    CurrentActivePage:ReceiveEnterStateSelf(StackAction)
  end
  if nil ~= self.CurrentActiveBg and self.CurrentActiveBg.ReceiveEnterStateSelf and "function" == type(self.CurrentActiveBg.ReceiveEnterStateSelf) then
    self.CurrentActiveBg:ReceiveEnterStateSelf(StackAction)
  end
end

function M:Close()
  self.Super.Close(self)
end

function M:Destruct()
  self.WidgetBGAnchor:ClearChildren()
  self.Group_Anchor:ClearChildren()
  self.List_Tab.OnCreateEmptyContent:Unbind()
  EventManager:RemoveEvent(EventID.OnReturnToActivityEntry, self)
  EventManager:RemoveEvent(EventID.OnLeaveActivityEntry, self)
  EventManager:RemoveEvent(EventID.OnActivityComplete, self)
  local BattleView = UIManager():GetUIObj("BattleMain")
  if BattleView then
    BattleView:Show("Temp1.4Fix")
  end
  self.NeedShowVersionView = nil
  self.Super.Destruct(self)
end

function M:RefreshBaseInfo(TopTabInfo, SubTabItems, BtnClickFunction, VirtualClickFunction, SelectTabIndex)
  local SubTabInfo = {
    Tabs = SubTabItems,
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
    end
  }
  self:InitTabView(TopTabInfo, SubTabInfo, BtnClickFunction, VirtualClickFunction, SelectTabIndex)
  self:ShowContentView(nil == SubTabItems or 0 == #SubTabItems, false)
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
  local ActiveWidgetIndex = IsUseGamePad and 1 or 0
  local CurrentActivePage, CurFocusWidgetName, CurFocusWidgetItem = self.AllCurrentActivityPage[self.CurTabId]
  if nil ~= CurrentActivePage then
    if type(CurrentActivePage.OnUpdateSubUIViewStyle) == "function" then
      CurrentActivePage:OnUpdateSubUIViewStyle(IsUseGamePad, true)
    end
    if "function" == type(CurrentActivePage.GetCurFocusWidgetInfo) then
      CurFocusWidgetName, CurFocusWidgetItem = CurrentActivePage:GetCurFocusWidgetInfo()
    end
    self:UpdateActivityKeyTips(CurFocusWidgetName, CurFocusWidgetItem)
  end
  self:UpdateCommonWidgetsStyleInPlatform(IsUseGamePad)
  if self.EventTypeTab then
    self.EventTypeTab:UpdateUIStyleInPlatform(IsUseGamePad)
  end
end

function M:UpdateCommonWidgetsStyleInPlatform(IsUseGamePad)
  if IsUseGamePad then
    self.EventTypeTab.Key_Left:CreateGamepadKey(UIConst.GamePadImgKey.LeftShoulder)
    self.EventTypeTab.Key_Left:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.EventTypeTab.Key_Right:CreateGamepadKey(UIConst.GamePadImgKey.RightShoulder)
    self.EventTypeTab.Key_Right:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Activity_Tab.Btn_RewardPreview.Key_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.EventTypeTab.Key_Left:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.EventTypeTab.Key_Right:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Activity_Tab.Btn_RewardPreview.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:GetTopTabInfo()
  local TopTabInfo = {
    LeftKey = "NotShow",
    RightKey = "NotShow",
    Tabs = {},
    DynamicNode = {"Back", "BottomKey"},
    StyleName = "Text",
    OwnerPanel = self,
    TitleName = GText("MAIN_UI_GAMEEVENT"),
    BackCallback = self.OnReturnKeyDown,
    InfoCallback = "NotShow"
  }
  return TopTabInfo
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local CurrentActivePage = self.AllCurrentActivityPage[self.CurTabId]
  if nil ~= CurrentActivePage then
    IsEventHandled = CurrentActivePage:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  end
  if not IsEventHandled and self.CurrentActiveBg and self.CurrentActiveBg.HandleKeyDownInBg then
    IsEventHandled = self.CurrentActiveBg:HandleKeyDownInBg(MyGeometry, InKeyEvent)
  end
  if not IsEventHandled then
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
      IsEventHandled = self:OnGamePadDown(InKeyName)
    else
      IsEventHandled = self.Activity_Tab:Handle_KeyEventOnPC(InKeyName)
    end
  end
  if InKeyName == self.OpenKey then
    IsEventHandled = true
    self:OnReturnKeyDown()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  IsEventHandled = IsEventHandled or self.Activity_Tab:Handle_KeyEventOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    return false
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    if self.Activity_Tab.WBP_Com_Tab_ResourceBar:IsVisible() then
      self.Activity_Tab.WBP_Com_Tab_ResourceBar:SetFocus()
      self:UpdateUIStyleInPlatform(false)
      self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
      return true
    end
    return false
  end
  return false
end

function M:Hide(HideTag)
  if "UIStackChange" == HideTag then
    self:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, true)
  else
    M.Super.Hide(self, HideTag)
  end
end

function M:HandleVirtualClickInGamePad(TabWidget)
  if self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  local CurrentActivePage = self.AllCurrentActivityPage[self.CurTabId]
  if nil ~= CurrentActivePage then
    CurrentActivePage:OnGamePadButtonDown(UIConst.GamePadKey.FaceButtonBottom)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local CurrentActivePage = self.AllCurrentActivityPage[self.CurTabId]
  if nil ~= CurrentActivePage and nil ~= CurrentActivePage.HandlePreviewKeyDownInPage then
    IsEventHandled = CurrentActivePage:HandlePreviewKeyDownInPage(MyGeometry, InKeyEvent)
  end
  if not IsEventHandled and self.CurrentActiveBg and self.CurrentActiveBg.HandleKeyDownInBg then
    IsEventHandled = self.CurrentActiveBg:HandleKeyDownInBg(MyGeometry, InKeyEvent)
  end
  if self.IsEnterForbiddenState then
    if "Gamepad_DPad_Left" == InKeyName then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    if "Gamepad_LeftShoulder" == InKeyName or "Gamepad_RightShoulder" == InKeyName then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if not IsEventHandled and not self.EventTypeTab:IsForbidden() then
    IsEventHandled = self.EventTypeTab:Handle_KeyEventOnGamePad(InKeyName)
  end
  if "Gamepad_DPad_Left" == InKeyName then
    self.Activity_Tab:OnRewardPreviewClick()
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnReturnToActivityEntry()
  if self:IsPlayingAnimation(self.In) then
    DebugPrint("OnReturnToActivityEntry IsPlayingAnimation In")
    return
  end
  self:StopAllAnimations()
  self:PlayAnimationForward(self.In)
end

function M:OnLeaveActivityEntry()
  if self:IsPlayingAnimation(self.Out) then
    DebugPrint("OnReturnToActivityEntry IsPlayingAnimation Out")
    return
  end
  self:StopAllAnimations()
  self:PlayAnimationForward(self.Out)
end

function M:OnActivityComplete(EventID)
  self:SetActivityComplete(EventID)
end

function M:OnActivityEntryShowVisible()
  self:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false)
end

function M:EnterForbiddenState()
  self.IsEnterForbiddenState = true
end

function M:LeaveForbiddenState()
  self.IsEnterForbiddenState = false
end

AssembleComponents(M)
return M
