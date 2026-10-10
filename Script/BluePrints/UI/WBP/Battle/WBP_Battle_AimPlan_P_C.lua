require("UnLua")
local AimPlanData = require("BluePrints.UI.WBP.Battle.WBP_Battle_AimPlan_P_Data")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}
local GAMEPAD_CONFIRM_KEY = UIConst.GamePadKey.FaceButtonBottom
local GAMEPAD_CONFIRM_HOLD_DURATION = 0.5

local function SetText(Widget, TextKey)
  if Widget and Widget.SetText then
    Widget:SetText(GText(TextKey))
  end
end

function M:Construct()
  self.bIsFocusable = true
  self.bIsDealWithVirtualAccept = true
  self.PlanWidgets = {
    self.Layout_01,
    self.Layout_02
  }
  self:AddLongPressEvent(GAMEPAD_CONFIRM_KEY, GAMEPAD_CONFIRM_HOLD_DURATION, nil, self.OnGamepadConfirmLongPressCancel, self.OnGamepadConfirmLongPressEnd)
  self:InitGamepadNavigation()
  self.Btn_Confirm.Button_Area:SetVisibility(ESlateVisibility.Visible)
  self.Btn_Confirm:BindEventOnClicked(self, self.OnClickConfirm)
  self.Layout_01.Btn_Area.OnClicked:Add(self, self.OnClickPlan1)
  self.Layout_02.Btn_Area.OnClicked:Add(self, self.OnClickPlan2)
  if self.Layout_02.Tag_Recommend then
    self.Layout_02.Tag_Recommend:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    SetText(self.Layout_02.Tag_Recommend.Text_Tag, AimPlanData.RecommendKey)
  end
end

function M:OnLoaded()
  self:ResetAimPlanState()
  self:InitText()
  self:RefreshGamepadView(UIUtils.IsGamepadInput())
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/complete_trial_level_panel_show", "AimPlan", nil)
end

function M:ResetAimPlanState()
  self:CancelGamepadConfirmLongPress()
  self.CurSelectIndex = nil
  self.IsClosing = false
  self.IsClosingAnimationStarted = nil
  for _, Widget in ipairs(self.PlanWidgets) do
    Widget:StopAllAnimations()
    Widget:PlayAnimation(Widget.Normal)
    Widget.LayoutState = UIConst.ButtonState.None
  end
  self.Btn_Confirm:ForbidBtn(true)
end

function M:InitGamepadNavigation()
  local Layout1 = self.Layout_01
  local Layout2 = self.Layout_02
  if not Layout1 or not Layout2 then
    return
  end
  Layout1:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  Layout1:SetNavigationRuleExplicit(EUINavigation.Right, Layout2)
  Layout1:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  Layout1:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  Layout2:SetNavigationRuleExplicit(EUINavigation.Left, Layout1)
  Layout2:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  Layout2:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  Layout2:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

function M:GetDesiredFocusTarget()
  local PlanWidget = self.PlanWidgets and self.PlanWidgets[self.CurSelectIndex or 1]
  return PlanWidget
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if M.Super.OnUpdateUIStyleByInputTypeChange then
    M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
  end
  self:RefreshGamepadView(CurInputType == ECommonInputType.Gamepad)
end

function M:RefreshGamepadView(bIsGamepad)
  self.Btn_Confirm:SetButtonIsLongPress(bIsGamepad)
  if not bIsGamepad then
    return
  end
  self.Btn_Confirm:SetLongPressDuration(GAMEPAD_CONFIRM_HOLD_DURATION)
  self.Btn_Confirm:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonBottom)
  if not self.CurSelectIndex then
    self:SelectPlan(1, self.Layout_01)
  end
  local FocusTarget = self:GetDesiredFocusTarget()
  if FocusTarget then
    FocusTarget:SetFocus()
  end
end

function M:OnPlanCardKeyDown(MyGeometry, InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  if InKeyName ~= GAMEPAD_CONFIRM_KEY then
    return UIUtils.Unhandled
  end
  if not self.IsKeyDown[GAMEPAD_CONFIRM_KEY] and not self.IsClosing and self.CurSelectIndex and not self.Btn_Confirm.IsForbidden then
    self:PlayGamepadConfirmLongPressImmediately()
  end
  self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  return UIUtils.Handled
end

function M:OnPlanCardKeyUp(MyGeometry, InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  if InKeyName ~= GAMEPAD_CONFIRM_KEY then
    return UIUtils.Unhandled
  end
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  self:OnGamepadConfirmLongPressCancel()
  return IsHandled and Reply or UIUtils.Handled
end

function M:PlayGamepadConfirmLongPressImmediately()
  local KeyWidget = self.Btn_Confirm and self.Btn_Confirm.Key_GamePad
  if not KeyWidget or not KeyWidget.LongPress then
    return
  end
  local AnimationLength = KeyWidget.LongPress:GetEndTime() - KeyWidget.LongPress:GetStartTime()
  if AnimationLength <= 0 then
    return
  end
  KeyWidget:PlayAnimation(KeyWidget.LongPress, 0, 1, EUMGSequencePlayMode.Forward, AnimationLength / GAMEPAD_CONFIRM_HOLD_DURATION, false)
end

function M:OnGamepadConfirmLongPressCancel()
  if self.Btn_Confirm then
    self.Btn_Confirm:StopLongPressAnimation()
  end
end

function M:CancelGamepadConfirmLongPress()
  self:RemoveTimer(GAMEPAD_CONFIRM_KEY .. "_LongPress")
  self:RemoveTimer(GAMEPAD_CONFIRM_KEY .. "_LongPressEnd")
  if self.IsKeyDown then
    self.IsKeyDown[GAMEPAD_CONFIRM_KEY] = false
  end
  if self.IsLongPressing then
    self.IsLongPressing[GAMEPAD_CONFIRM_KEY] = false
  end
  self:OnGamepadConfirmLongPressCancel()
end

function M:OnGamepadConfirmLongPressEnd()
  if not self.IsClosing and self.CurSelectIndex and not self.Btn_Confirm.IsForbidden then
    self:OnClickConfirm()
  end
end

function M:InitText()
  SetText(self.Text_Title, AimPlanData.TitleKey)
  SetText(self.Text_Desc, AimPlanData.SettingsTipKey)
  SetText(self.Btn_Confirm and self.Btn_Confirm.Text_Button, AimPlanData.ApplyKey)
  if self.Layout_01 and self.Layout_01.Init then
    self.Layout_01:Init(self, 1, self:GetCurrentKeyboardKeyMap(1))
  end
  if self.Layout_02 and self.Layout_02.Init then
    self.Layout_02:Init(self, 2)
  end
end

function M:GetCurrentKeyboardKeyMap(PlanIndex)
  local CurrentKeyMap = {}
  local PlanData = AimPlanData.Plans[PlanIndex]
  for _, Row in ipairs(PlanData and PlanData.KeyRows or {}) do
    local ActionName = Row.ActionName
    local ActionData = DataMgr.KeyboardMap[ActionName]
    if ActionName then
      CurrentKeyMap[ActionName] = ActionData and ActionData.Key or ""
    end
  end
  local InputSetting = UE4.UInputSettings.GetInputSettings()
  if not InputSetting then
    return CurrentKeyMap
  end
  for _, ActionMapping in ipairs(InputSetting.ActionMappings:ToTable()) do
    local ActionName = ActionMapping.ActionName
    local KeyName = ActionMapping.Key and ActionMapping.Key.KeyName
    if CurrentKeyMap[ActionName] and KeyName and not string.find(KeyName, "Gamepad") then
      CurrentKeyMap[ActionName] = KeyName
    end
  end
  return CurrentKeyMap
end

function M:ApplyAimPlanActionMapping(PlanIndex)
  local PlanData = AimPlanData.Plans[PlanIndex]
  if not PlanData then
    return false
  end
  local TargetMappings = PlanData.ActionKeyMappings
  if not TargetMappings or not next(TargetMappings) then
    return true
  end
  local InputSetting = UE4.UInputSettings.GetInputSettings()
  if not InputSetting then
    return false
  end
  local MappingByAction = {}
  local MappingByKey = {}
  for _, ActionMapping in ipairs(InputSetting.ActionMappings:ToTable()) do
    local ActionName = ActionMapping.ActionName
    local KeyName = ActionMapping.Key and ActionMapping.Key.KeyName
    local KeyData = DataMgr.KeyboardMap[ActionName]
    if KeyData and KeyData.IsShowInSetting and KeyName and not string.find(KeyName, "Gamepad") then
      MappingByAction[ActionName] = ActionMapping
      MappingByKey[KeyName] = ActionMapping
    end
  end
  local TargetKeySet = {}
  for ActionName, KeyName in pairs(TargetMappings) do
    if not UE4.EKeys[KeyName] or TargetKeySet[KeyName] then
      return false
    end
    TargetKeySet[KeyName] = true
  end
  local FinalKeyByAction = {}
  local HasIncomingTargetAction = {}
  for ActionName, KeyName in pairs(TargetMappings) do
    local OwnerMapping = MappingByKey[KeyName]
    local OwnerActionName = OwnerMapping and OwnerMapping.ActionName
    if OwnerActionName and TargetMappings[OwnerActionName] then
      HasIncomingTargetAction[OwnerActionName] = true
    end
  end
  
  local function ResolveSwapChain(RootActionName)
    local RootMapping = MappingByAction[RootActionName]
    if not RootMapping then
      FinalKeyByAction[RootActionName] = TargetMappings[RootActionName]
      return
    end
    local RootKeyName = RootMapping.Key.KeyName
    local VisitedActions = {}
    local ActionName = RootActionName
    while ActionName and not VisitedActions[ActionName] do
      VisitedActions[ActionName] = true
      local TargetKeyName = TargetMappings[ActionName]
      FinalKeyByAction[ActionName] = TargetKeyName
      local OwnerMapping = MappingByKey[TargetKeyName]
      local OwnerActionName = OwnerMapping and OwnerMapping.ActionName
      if not OwnerActionName then
        return
      end
      if not TargetMappings[OwnerActionName] then
        FinalKeyByAction[OwnerActionName] = RootKeyName
        return
      end
      ActionName = OwnerActionName
    end
  end
  
  for ActionName in pairs(TargetMappings) do
    if not HasIncomingTargetAction[ActionName] then
      ResolveSwapChain(ActionName)
    end
  end
  for ActionName in pairs(TargetMappings) do
    if not FinalKeyByAction[ActionName] then
      ResolveSwapChain(ActionName)
    end
  end
  local ChangedMappings = {}
  for ActionName, KeyName in pairs(FinalKeyByAction) do
    local ActionMapping = MappingByAction[ActionName]
    if not ActionMapping then
      table.insert(ChangedMappings, {ActionName = ActionName, KeyName = KeyName})
    elseif ActionMapping.Key.KeyName == KeyName then
      goto lbl_164
    else
      table.insert(ChangedMappings, {
        ActionName = ActionName,
        KeyName = KeyName,
        Mapping = ActionMapping
      })
    end
    ::lbl_164::
  end
  for _, Change in ipairs(ChangedMappings) do
    if Change.Mapping then
      InputSetting:RemoveActionMapping(Change.Mapping)
    end
  end
  for _, Change in ipairs(ChangedMappings) do
    local ActionMapping = Change.Mapping
    if not ActionMapping then
      ActionMapping = UE4.FInputActionKeyMapping()
      ActionMapping.ActionName = Change.ActionName
    end
    ActionMapping.Key = UE4.EKeys[Change.KeyName]
    InputSetting:AddActionMapping(ActionMapping)
  end
  InputSetting:SaveKeyMappings()
  local AvatarMappings = {}
  for ActionName, KeyName in pairs(FinalKeyByAction) do
    if DataMgr.KeyboardMap[ActionName] then
      AvatarMappings[ActionName] = KeyName
    end
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and next(AvatarMappings) then
    Avatar:UpdateActionMapping(AvatarMappings, function(Ret)
      if ErrorCode:Check(Ret) then
        EventManager:FireEvent(EventID.OnChangeKeyBoardSet)
      end
    end)
  else
    EventManager:FireEvent(EventID.OnChangeKeyBoardSet)
  end
  return true
end

function M:OnClickPlan1()
  self:SelectPlan(1, self.Layout_01)
end

function M:OnClickPlan2()
  self:SelectPlan(2, self.Layout_02)
end

function M:SelectPlan(PlanIndex, PlanWidget)
  for _, Widget in ipairs(self.PlanWidgets) do
    if Widget ~= PlanWidget and Widget.LayoutState == UIConst.ButtonState.Click then
      Widget:PlayAnimation(Widget.Normal)
      Widget.LayoutState = UIConst.ButtonState.None
    end
  end
  if PlanWidget.LayoutState ~= UIConst.ButtonState.Click then
    PlanWidget:PlayAnimation(PlanWidget.Click)
  end
  PlanWidget.LayoutState = UIConst.ButtonState.Click
  self.Btn_Confirm:ForbidBtn(false)
  self.CurSelectIndex = PlanIndex
end

function M:OnClickConfirm()
  if self.IsClosing or not self.CurSelectIndex then
    return
  end
  if not self:ApplyAimPlanActionMapping(self.CurSelectIndex) then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SetPreviewShow()
  end
  self.IsClosing = true
  self:CloseSelf()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:CloseSelf()
  if self.IsClosing and self.IsClosingAnimationStarted then
    return
  end
  self:OnGamepadConfirmLongPressCancel()
  self.IsClosing = true
  self.IsClosingAnimationStarted = true
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "AimPlan", {ToEnd = 1})
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self:Close()
  end
end

AssembleComponents(M)
return M
