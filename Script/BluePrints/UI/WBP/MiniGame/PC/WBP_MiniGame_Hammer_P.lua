require("UnLua")
local M = Class("BluePrints.UI.WBP.MiniGame.WBP_MiniGame_Hammer_Base")
local GAMEPAD_B_LONG_PRESS_DURATION = 1
local GAMEPAD_KEY_TO_CONFIG_KEY = {
  Gamepad_FaceButton_Left = "A",
  Gamepad_FaceButton_Bottom = "W",
  Gamepad_FaceButton_Right = "D"
}
local CONFIG_KEY_TO_GAMEPAD_ICON = {
  A = "X",
  W = "A",
  D = "B"
}

function M:InitPlatform()
  self.bIsFocusable = true
  self.HeldInputKeys = {}
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshInfoByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:SetFocus()
end

function M:OnUpdateUIStyleByInputTypeChange(InputType, GamepadName)
  self:RefreshInfoByInputTypeChange(InputType, GamepadName)
end

function M:RefreshInfoByInputTypeChange(InputType, GamepadName)
  self.CurrentInputType = InputType
  self.CurrentGamepadName = GamepadName
  local bGamepad = InputType == ECommonInputType.Gamepad
  if bGamepad then
    self:SetFocus()
  end
  self.Bar.WS_Mode:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self.Btn_Start.WS_Controller:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self.Btn_Crack.WS_Controller:SetActiveWidgetIndex(bGamepad and 1 or 0)
  self:RefreshStartButtonKeyHint()
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

function M:OnHammerGameStarted()
  self:RefreshHammerButtonEnabled()
end

function M:RefreshHammerButtonEnabled()
  M.Super.RefreshHammerButtonEnabled(self)
  if not self.Btn_Start or not self.Btn_Start.Btn_Click then
    return
  end
  local bStartForbidden = self.bHammerStarted and not self.bHammerGameEnded
  self.Btn_Start.Btn_Click:SetForbidden(bStartForbidden)
  self.Btn_Start.Btn_Click:SetIsEnabled(not bStartForbidden)
end

function M:RefreshComboKeyHints()
  local CurrentComboKeys = self.CurrentComboKeys or {}
  if 0 == #CurrentComboKeys then
    return
  end
  local KeyboardKeyInfo = {}
  local GamepadKeyInfo = {}
  for _, Key in ipairs(CurrentComboKeys) do
    table.insert(KeyboardKeyInfo, {Type = "Text", Text = Key})
    table.insert(GamepadKeyInfo, {
      Type = "Img",
      ImgShortPath = CONFIG_KEY_TO_GAMEPAD_ICON[Key]
    })
  end
  local bMultiKey = #CurrentComboKeys > 1
  local KeyboardWidget = bMultiKey and self.Bar.Key_Add or self.Bar.Key
  local GamepadWidget = bMultiKey and self.Bar.Controller_Add or self.Bar.Controller
  self.Bar.Key:SetVisibility(bMultiKey and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Bar.Key_Add:SetVisibility(bMultiKey and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  self.Bar.Controller:SetVisibility(bMultiKey and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Bar.Controller_Add:SetVisibility(bMultiKey and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  KeyboardWidget:CreateCommonKey({KeyInfoList = KeyboardKeyInfo})
  GamepadWidget:CreateCommonKey({KeyInfoList = GamepadKeyInfo})
end

function M:HandleKeyboardKey(KeyName)
  if "Escape" == KeyName then
    self:OnCloseButtonClicked()
    return true
  end
  if "SpaceBar" == KeyName and not self.bHammerStarted then
    self:StartHammerGame()
    return true
  end
  if "X" == KeyName then
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
    self.Key_Close:OnButtonPressed(nil, true, 0, GAMEPAD_B_LONG_PRESS_DURATION)
    return true
  end
  if "Gamepad_FaceButton_Bottom" == KeyName then
    if self.bHammerStarted then
      self:SubmitHammerInput(GAMEPAD_KEY_TO_CONFIG_KEY[KeyName])
    else
      self:StartHammerGame()
    end
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
    local bCloseTriggered = self.Key_Close.bHasTriggerLongRelease == true
    self.Key_Close:OnButtonReleased()
    if not bCloseTriggered then
      self:SubmitHammerInput(GAMEPAD_KEY_TO_CONFIG_KEY[KeyName])
    end
    return true
  end
  return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  self.HeldInputKeys = self.HeldInputKeys or {}
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.HeldInputKeys[KeyName] then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local bIsGamepadKey = UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)
  local bHandled = bIsGamepadKey and self:HandleGamepadKeyDown(KeyName) or self:HandleKeyboardKey(KeyName)
  if bHandled then
    self.HeldInputKeys[KeyName] = true
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  self.HeldInputKeys = self.HeldInputKeys or {}
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bWasHandled = self.HeldInputKeys[KeyName] == true
  self.HeldInputKeys[KeyName] = nil
  local bHandled = UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamepadKeyUp(KeyName)
  return (bHandled or bWasHandled) and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:DestructPlatform()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshInfoByInputTypeChange)
  end
end

return M
