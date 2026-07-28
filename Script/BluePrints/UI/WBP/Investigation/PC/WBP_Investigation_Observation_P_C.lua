require("UnLua")
local InvestigationUtils = require("BluePrints.UI.WBP.Investigation.InvestigationUtils")
local EPanelState = InvestigationUtils.EPanelState
local M = Class("BluePrints.UI.WBP.Investigation.WBP_Investigation_Observation_C")

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:RefreshBaseInfo()
  self:LockObservationMouse()
  self:InitPlayKey()
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  local IsGamepad = CurInputType == ECommonInputType.Gamepad
  self:UpdatePlayKeyImg(IsGamepad)
  if IsGamepad then
    self:SetFocusTarget()
  end
  self.UsingGamepad = IsGamepad
end

function M:ShouldFocus()
  return true
end

function M:GotFocus()
  return self:HasAnyUserFocus() or self:HasFocusedDescendants()
end

function M:SetFocusTarget()
  if not self:ShouldFocus() then
    return
  end
  if not self:GotFocus() then
    self:SetFocus()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.UsingGamepad then
    self:SetFocusTarget()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitPlayKey()
  self.Key_Hide:AddExecuteLogic(self, self.OnHideClicked)
  self.Key_Exit:AddExecuteLogic(self, self.OnExitClicked)
  self.Key_Skip:AddExecuteLogic(self, self.OnSkipClicked)
end

function M:UpdatePlayKeyImg(bUseGamePad)
  local KeyType = bUseGamePad and "Img" or "Text"
  self.Key_Hide:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "U",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
      }
    },
    Desc = GText("UI_Observation_Hide")
  })
  self.Key_Exit:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "Esc",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
      }
    },
    Desc = GText("UI_Observation_Exit")
  })
  self.Key_Skip:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "Space",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
      }
    },
    Desc = GText("UI_TALK_SKIP")
  })
end

function M:OnHideClicked()
  self:TogglePanelHidden()
end

function M:LockObservationMouse()
  if self.MouseCaptured then
    return
  end
  self:SetFocus()
  self.CapturedAndRealMouseMoved = false
  self.LastRealMousePos = nil
  self:SetCursor(EMouseCursor.None)
  UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(), self)
  self.MouseCaptured = true
end

function M:UnlockObservationMouse()
  if not self.MouseCaptured then
    return
  end
  self:ResetCursor()
  UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled())
  self.MouseCaptured = false
end

function M:UpdateKeyState(State)
  if "Dialog" == State then
    self.Key_Hide:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Exit:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Skip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Key_Hide:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Exit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Skip:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:ApplyPanelState()
  M.Super.ApplyPanelState(self)
  if self.PanelState == EPanelState.Dialog then
    self:UnlockObservationMouse()
    return
  end
  self:LockObservationMouse()
end

function M:Cleanup()
  M.Super.Cleanup(self)
  self:UnlockObservationMouse()
  self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.CapturedAndRealMouseMoved then
    if self.LastRealMousePos then
      local CurRealMousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
      local MoveDelta = CurRealMousePos - self.LastRealMousePos
      self:ProcessRotateInput(MoveDelta.X, -MoveDelta.Y)
    end
    ULowEntryExtendedStandardLibrary.SetMousePositionInPercentages(0.5, 0.5)
    self.LastRealMousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    self.CapturedAndRealMouseMoved = false
  end
end

function M:OnMouseMove(_, MouseEvent)
  if self.PanelState == EPanelState.Dialog then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.CapturedAndRealMouseMoved = true
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonDown(_, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(_, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnalogValueChanged(_, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local AnalogValue = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if math.abs(AnalogValue) < 0.15 then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if "Gamepad_RightX" == InKeyName then
    self:ProcessRotateInput(AnalogValue * 30, 0)
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_RightY" == InKeyName then
    self:ProcessRotateInput(0, AnalogValue * 30)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(_, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName then
    self:OnExitClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "F" == InKeyName and self:ObserveCurrentCheckpoint() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "Enter" == InKeyName then
    self:CloseWithResult(true, "Confirm")
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
