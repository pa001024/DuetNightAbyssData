require("UnLua")
local M = Class("BluePrints.UI.WBP.MiniGame.WBP_MiniGame_Hammer_Base")
local GAMEPAD_B_LONG_PRESS_DURATION = 1
local GAMEPAD_START_KEY = "Gamepad_FaceButton_Bottom"
local GAMEPAD_KEY_TO_CONFIG_KEY = {
  Gamepad_FaceButton_Left = "A",
  [GAMEPAD_START_KEY] = "W",
  Gamepad_FaceButton_Right = "D"
}
local CONFIG_KEY_TO_GAMEPAD_ICON = {
  A = "X",
  W = "A",
  D = "B"
}

local function HideWidgetNavigateGuide(Widget)
  if not Widget then
    return
  end
  Widget.bIsShowNavigateGuide = false
  if Widget.SetIsShowNavigateGuide then
    Widget:SetIsShowNavigateGuide(false)
  end
  if Widget.Btn and Widget.Btn ~= Widget then
    Widget.Btn.bIsShowNavigateGuide = false
    if Widget.Btn.SetIsShowNavigateGuide then
      Widget.Btn:SetIsShowNavigateGuide(false)
    end
  end
end

function M:Initialize(Initializer)
  self.Super.Initialize(self, Initializer)
  self.bIsFocusable = true
  self.bIsShowNavigateGuide = false
end

function M:InitPlatform()
  self.bIsFocusable = true
  self.bIsShowNavigateGuide = false
  self:SetIsDealWithVirtualAccept(true)
  self.HeldInputKeys = {}
  self.bGamepadStartKeyDown = false
  self.bHammerInteractiveActionPressed = false
  self.bHammerAttackActionPressed = false
  self.bHammerAvoidActionPressed = false
  self.bHammerAvoidInputActive = false
  self.bHammerGamepadActionReady = false
  self:HideHammerInputHint()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if self.SetIsShowNavigateGuide then
    self:SetIsShowNavigateGuide(false)
  end
  self:HideHammerButtonNavigateGuide()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshInfoByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType())
  end
  self:ListenHammerGamepadInputActions()
  self:RefreshHammerInputFocus()
  self:ScheduleCloseResidualInteractiveUI()
end

function M:ScheduleCloseResidualInteractiveUI()
  self:AddTimer(0.01, function()
    local bClosed = self:CloseResidualInteractiveUI()
    if bClosed and self.IsInUIMode and not self.bHammerGameEnded and not self.IsMarkToRemove then
      self:AddTimer(0.01, function()
        if self.IsInUIMode and not self.bHammerGameEnded and not self.IsMarkToRemove then
          self:RefreshHammerInputFocus()
        end
      end, false, 0, "HammerFocusAfterCloseInteractiveUI", true)
    end
    self:DelayEnableHammerGamepadAction()
  end, false, 0, "HammerCloseResidualInteractiveUI", true)
end

function M:DelayEnableHammerGamepadAction()
  self:AddTimer(0.05, function()
    if self.IsInUIMode and not self.bHammerGameEnded and not self.IsMarkToRemove then
      self.bHammerGamepadActionReady = true
    end
  end, false, 0, "HammerGamepadActionReady", true)
end

function M:CloseResidualInteractiveUI()
  local UIManagerComp = UIManager(self)
  if not UIManagerComp or not UIManagerComp.GetUIObj then
    return false
  end
  local InteractiveUI = UIManagerComp:GetUIObj("InteractiveUI")
  if not InteractiveUI or InteractiveUI == self or InteractiveUI.IsMarkToRemove then
    return false
  end
  InteractiveUI:Close()
  return true
end

function M:HideHammerButtonNavigateGuide()
  if self.Btn_Start then
    HideWidgetNavigateGuide(self.Btn_Start)
    HideWidgetNavigateGuide(self.Btn_Start.Btn_Click)
  end
  if self.Btn_Crack then
    HideWidgetNavigateGuide(self.Btn_Crack)
    HideWidgetNavigateGuide(self.Btn_Crack.Btn_Click)
  end
end

function M:IsHammerGamepadInput()
  return self.CurrentInputType == ECommonInputType.Gamepad
end

function M:HandleHammerStartInput()
  if self.bHammerStarted then
    self:SubmitHammerInput(GAMEPAD_KEY_TO_CONFIG_KEY[GAMEPAD_START_KEY])
  else
    self:StartHammerGame()
  end
end

function M:BeginHammerAvoidInput()
  if self.bHammerAvoidInputActive then
    return
  end
  self.bHammerAvoidInputActive = true
  self.Key_Close:OnButtonPressed(nil, true, 0, GAMEPAD_B_LONG_PRESS_DURATION)
  self:SubmitHammerInput(GAMEPAD_KEY_TO_CONFIG_KEY.Gamepad_FaceButton_Right)
end

function M:EndHammerAvoidInput()
  if not self.bHammerAvoidInputActive then
    return
  end
  self.bHammerAvoidInputActive = false
  self.Key_Close:OnButtonReleased()
end

function M:OnHammerInteractiveActionPressed()
  if not (self:IsHammerGamepadInput() and self.bHammerGamepadActionReady) or self.bHammerInteractiveActionPressed then
    return
  end
  self.HeldInputKeys = self.HeldInputKeys or {}
  if self.HeldInputKeys[GAMEPAD_START_KEY] then
    return
  end
  self.bHammerInteractiveActionPressed = true
  self.bGamepadStartKeyDown = true
  self.HeldInputKeys[GAMEPAD_START_KEY] = true
  self:HandleHammerStartInput()
end

function M:OnHammerInteractiveActionReleased()
  if not self.bHammerInteractiveActionPressed then
    return
  end
  self.bHammerInteractiveActionPressed = false
  self.bGamepadStartKeyDown = false
  if self.HeldInputKeys then
    self.HeldInputKeys[GAMEPAD_START_KEY] = nil
  end
  if self.bDelayDisableStartButton then
    self.bDelayDisableStartButton = false
    self:RefreshHammerButtonEnabled()
    self:RefreshHammerInputFocus()
  end
end

function M:OnHammerAttackActionPressed()
  if not (self:IsHammerGamepadInput() and self.bHammerGamepadActionReady) or self.bHammerAttackActionPressed then
    return
  end
  self.HeldInputKeys = self.HeldInputKeys or {}
  if self.HeldInputKeys.Gamepad_FaceButton_Left then
    return
  end
  self.bHammerAttackActionPressed = true
  self.HeldInputKeys.Gamepad_FaceButton_Left = true
  self:SubmitHammerInput(GAMEPAD_KEY_TO_CONFIG_KEY.Gamepad_FaceButton_Left)
end

function M:OnHammerAttackActionReleased()
  if not self.bHammerAttackActionPressed then
    return
  end
  self.bHammerAttackActionPressed = false
  if self.HeldInputKeys then
    self.HeldInputKeys.Gamepad_FaceButton_Left = nil
  end
end

function M:OnHammerAvoidActionPressed()
  if not (self:IsHammerGamepadInput() and self.bHammerGamepadActionReady) or self.bHammerAvoidActionPressed then
    return
  end
  self.HeldInputKeys = self.HeldInputKeys or {}
  if self.HeldInputKeys.Gamepad_FaceButton_Right then
    return
  end
  self.bHammerAvoidActionPressed = true
  self.HeldInputKeys.Gamepad_FaceButton_Right = true
  self:BeginHammerAvoidInput()
end

function M:OnHammerAvoidActionReleased()
  if not self.bHammerAvoidActionPressed then
    return
  end
  self.bHammerAvoidActionPressed = false
  if self.HeldInputKeys then
    self.HeldInputKeys.Gamepad_FaceButton_Right = nil
  end
  self:EndHammerAvoidInput()
end

function M:ListenHammerGamepadInputActions()
  self:StopHammerGamepadInputActions()
  self:ListenForInputAction("Interactive", UE4.EInputEvent.IE_Pressed, true, {
    self,
    self.OnHammerInteractiveActionPressed
  })
  self:ListenForInputAction("Interactive", UE4.EInputEvent.IE_Released, true, {
    self,
    self.OnHammerInteractiveActionReleased
  })
  self:ListenForInputAction("Attack", UE4.EInputEvent.IE_Pressed, true, {
    self,
    self.OnHammerAttackActionPressed
  })
  self:ListenForInputAction("Attack", UE4.EInputEvent.IE_Released, true, {
    self,
    self.OnHammerAttackActionReleased
  })
  self:ListenForInputAction("Avoid", UE4.EInputEvent.IE_Pressed, true, {
    self,
    self.OnHammerAvoidActionPressed
  })
  self:ListenForInputAction("Avoid", UE4.EInputEvent.IE_Released, true, {
    self,
    self.OnHammerAvoidActionReleased
  })
end

function M:StopHammerGamepadInputActions()
  self:StopListeningForInputAction("Interactive", UE4.EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("Interactive", UE4.EInputEvent.IE_Released)
  self:StopListeningForInputAction("Attack", UE4.EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("Attack", UE4.EInputEvent.IE_Released)
  self:StopListeningForInputAction("Avoid", UE4.EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("Avoid", UE4.EInputEvent.IE_Released)
end

function M:OnFocusLost(InFocusEvent)
  if self.IsInUIMode and not self.bHammerGameEnded and not self.IsMarkToRemove then
    self:AddTimer(0.01, function()
      if self.IsInUIMode and not self.bHammerGameEnded and not self.IsMarkToRemove then
        self:RefreshHammerInputFocus()
      end
    end, false, 0, "HammerRestoreFocusAfterLost", true)
  end
  if M.Super.OnFocusLost then
    return M.Super.OnFocusLost(self, InFocusEvent)
  end
end

function M:HideHammerNavigateGuide()
  self.bIsShowNavigateGuide = false
  if self.SetIsShowNavigateGuide then
    self:SetIsShowNavigateGuide(false)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    if self.GameInputModeSubsystem.SetNavigateWidgetOpacity then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0.0)
    end
  end
end

function M:RestoreNavigateGuide()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
    if self.GameInputModeSubsystem.SetNavigateWidgetOpacity then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1.0)
    end
  end
end

function M:BP_GetDesiredFocusTarget()
  return self.Btn_Start and self.Btn_Start.Btn_Click or self
end

function M:RefreshHammerInputFocus()
  self:HideHammerNavigateGuide()
  local FocusTarget = self:BP_GetDesiredFocusTarget()
  if IsValid(self.GameInputModeSubsystem) and self.GameInputModeSubsystem.SetTargetUIFocusWidget then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(FocusTarget)
  end
  if FocusTarget and FocusTarget.SetFocus then
    FocusTarget:SetFocus()
  elseif self.SetFocus then
    self:SetFocus()
  end
  self:HideHammerNavigateGuide()
end

function M:OnUpdateUIStyleByInputTypeChange(InputType)
  self:RefreshInfoByInputTypeChange(InputType)
end

function M:RefreshInfoByInputTypeChange(InputType)
  self.CurrentInputType = InputType
  local bGamepad = InputType == ECommonInputType.Gamepad
  self:RefreshHammerTipKeyHint()
  self.Bar.WS_Mode:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self.Btn_Start.WS_Controller:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self.Btn_Crack.WS_Controller:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self:RefreshStartButtonKeyHint()
  self:RefreshCrackButtonKeyHint()
  self.Key_Close:CreateCommonKey({
    KeyInfoList = bGamepad and {
      {Type = "Img", ImgShortPath = "B"}
    } or {
      {Type = "Text", Text = "Escape"}
    },
    bLongPress = bGamepad,
    Desc = GText("UI_BACK")
  })
  self.Key_Close:AddExecuteLogic(self, self.OnCloseButtonClicked)
  self:RefreshComboKeyHints()
end

function M:RefreshHammerTipKeyHint()
  local HammerKeyCombos = self.UseActor and self.UseActor.HammerKeyCombos
  if not (self.Tip and self.Tip.WBox_Key) or not HammerKeyCombos then
    return
  end
  local bGamepad = self.CurrentInputType == ECommonInputType.Gamepad
  self.Tip.WBox_Key:ClearChildren()
  local AddedKeys = {}
  for _, Combo in ipairs(HammerKeyCombos) do
    for _, Key in ipairs(Combo.Keys or {}) do
      local DisplayKey = bGamepad and CONFIG_KEY_TO_GAMEPAD_ICON[Key] or Key
      if DisplayKey and not AddedKeys[Key] then
        AddedKeys[Key] = true
        local KeyWidget = self:CreateWidgetNew("ComKeyTextDesc")
        KeyWidget:CreateCommonKey({
          KeyInfoList = {
            bGamepad and {Type = "Img", ImgShortPath = DisplayKey} or {Type = "Text", Text = DisplayKey}
          },
          Desc = ""
        })
        self.Tip.WBox_Key:AddChild(KeyWidget)
      end
    end
  end
  if self.Tip.Panel_KeyTip then
    self.Tip.Panel_KeyTip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshStartButtonKeyHint()
  if self.Btn_Start.Key then
    self.Btn_Start.Key:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "Space"}
      }
    })
  end
  if self.Btn_Start.Key_Controller then
    self.Btn_Start.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      }
    })
  end
end

function M:RefreshCrackButtonKeyHint()
  if self.Btn_Crack.Key then
    self.Btn_Crack.Key:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "F"}
      }
    })
  end
  if self.Btn_Crack.Key_Controller then
    self.Btn_Crack.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
  end
end

function M:OnHammerGameStarted()
  M.Super.OnHammerGameStarted(self)
  self:RefreshHammerButtonEnabled()
  self:RefreshHammerInputFocus()
end

function M:RefreshHammerStartButtonState()
  if not self.Btn_Start or not self.Btn_Start.Btn_Click then
    return
  end
  local bStartForbidden = self.bHammerStarted and not self.bHammerGameEnded
  local bDelayDisableStartButton = bStartForbidden and self.HeldInputKeys and (self.HeldInputKeys[GAMEPAD_START_KEY] == true or true == self.bGamepadStartKeyDown)
  self:SetHammerStartButtonForbidden(bStartForbidden)
  self.Btn_Start.Btn_Click:SetIsEnabled(not bStartForbidden or bDelayDisableStartButton)
  self.bDelayDisableStartButton = bDelayDisableStartButton
end

function M:RefreshComboKeyHints()
  local CurrentComboKeys = self.CurrentComboKeys or {}
  if 0 == #CurrentComboKeys then
    return
  end
  local KeyboardKeyInfo = {}
  local GamepadKeyInfo = {}
  for _, Key in ipairs(CurrentComboKeys) do
    table.insert(KeyboardKeyInfo, {Type = "Text_L", Text = Key})
    table.insert(GamepadKeyInfo, {
      Type = "Img_L",
      ImgShortPath = CONFIG_KEY_TO_GAMEPAD_ICON[Key]
    })
  end
  local bGamepad = self.CurrentInputType == ECommonInputType.Gamepad
  local bMultiKey = #CurrentComboKeys > 1
  self.Bar.WS_Mode:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self.Bar.WS_Key:SetActiveWidgetIndex(bMultiKey and 1 or 0)
  self.Bar.WS_Controller:SetActiveWidgetIndex(bMultiKey and 1 or 0)
  if bMultiKey then
    self.Bar.Key_Add:CreateCommonKey({KeyInfoList = KeyboardKeyInfo})
    self.Bar.Controller_Add:CreateCommonKey({KeyInfoList = GamepadKeyInfo})
  else
    local KeyText = KeyboardKeyInfo[1].Text
    local KeyTextConfig = DataMgr.KeyboardText[KeyText]
    self.Bar.Key.Text_Key:SetText(KeyTextConfig and KeyTextConfig.KeyText or KeyText)
    self.Bar.Controller:CreateCommonKey({KeyInfoList = GamepadKeyInfo})
  end
end

function M:OnHammerInputHintReady(bSkipAppearAnimation)
  if self.Bar then
    self.Bar.Panel_Key:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:SetHammerInputHintVisible(true)
  self:RefreshComboKeyHints()
  if not bSkipAppearAnimation then
    self:PlayHammerInputHintAppearAnimation()
  end
end

function M:OnHammerInputEnabledChanged(bEnabled)
  if bEnabled then
    self.HeldInputKeys[GAMEPAD_START_KEY] = nil
    self.bGamepadStartKeyDown = false
    self.bHammerInteractiveActionPressed = false
    self.bDelayDisableStartButton = false
  end
  self:RefreshHammerInputReadyAnimation()
end

function M:HideHammerInputHint()
  if self.Bar and self.Bar.Panel_Key then
    self.Bar.Panel_Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:SetHammerInputHintVisible(false)
end

function M:GetHammerHitResultAnimation(bSuccess)
  if not self.Bar then
    return
  end
  return bSuccess and self.Bar.Success_PC or self.Bar.Fail_PC
end

function M:HandleKeyboardKey(KeyName)
  if "Escape" == KeyName then
    self:OnCloseButtonClicked()
    return true
  end
  if "SpaceBar" == KeyName and not self.bHammerStarted then
    self:HandleHammerStartInput()
    return true
  end
  if "F" == KeyName then
    self:OnCrackButtonClicked()
    return true
  end
  if "A" == KeyName or "W" == KeyName or "D" == KeyName then
    self:SubmitHammerInput(KeyName)
    return true
  end
  return false
end

function M:HandleGamepadKeyDown(KeyName)
  if "Gamepad_FaceButton_Right" == KeyName then
    self:BeginHammerAvoidInput()
    return true
  end
  if KeyName == GAMEPAD_START_KEY then
    self:HandleHammerStartInput()
    return true
  end
  if "Gamepad_FaceButton_Left" == KeyName then
    self:SubmitHammerInput(GAMEPAD_KEY_TO_CONFIG_KEY[KeyName])
    return true
  end
  if "Gamepad_FaceButton_Top" == KeyName then
    self:OnCrackButtonClicked()
    return true
  end
  return false
end

function M:HandleGamepadKeyUp(KeyName)
  if "Gamepad_FaceButton_Right" == KeyName then
    self:EndHammerAvoidInput()
    return true
  end
  return false
end

function M:HandleKeyDown(InKey, KeyName)
  self.HeldInputKeys = self.HeldInputKeys or {}
  if self.HeldInputKeys[KeyName] then
    return true
  end
  local bIsGamepadKey = UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)
  local bIsGamepadStartKey = bIsGamepadKey and KeyName == GAMEPAD_START_KEY
  if bIsGamepadStartKey then
    self.bGamepadStartKeyDown = true
  end
  local bHandled = bIsGamepadKey and self:HandleGamepadKeyDown(KeyName) or self:HandleKeyboardKey(KeyName)
  if bHandled then
    self.HeldInputKeys[KeyName] = true
  elseif bIsGamepadStartKey then
    self.bGamepadStartKeyDown = false
  end
  return bHandled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleKeyDown(InKey, KeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bHandled = self:HandleKeyDown(InKey, KeyName)
  return bHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  self.HeldInputKeys = self.HeldInputKeys or {}
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bWasHandled = self.HeldInputKeys[KeyName] == true
  self.HeldInputKeys[KeyName] = nil
  if KeyName == GAMEPAD_START_KEY then
    self.bGamepadStartKeyDown = false
  end
  local bHandled = bWasHandled and UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamepadKeyUp(KeyName)
  if self.bDelayDisableStartButton and KeyName == GAMEPAD_START_KEY then
    self.bDelayDisableStartButton = false
    self:RefreshHammerButtonEnabled()
    self:RefreshHammerInputFocus()
  end
  return (bHandled or bWasHandled) and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:DestructPlatform()
  self:StopHammerGamepadInputActions()
  self:SetIsDealWithVirtualAccept(false)
  self:RestoreNavigateGuide()
end

return M
