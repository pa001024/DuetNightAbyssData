require("UnLua")
local InvestigationUtils = require("BluePrints.UI.WBP.Investigation.InvestigationUtils")
local EPanelState = InvestigationUtils.EPanelState
local InputModeTag = "InvestigationObservation"
local GamepadRotateSpeed = 15
local M = Class("BluePrints.UI.WBP.Investigation.WBP_Investigation_Observation_C")

function M:Construct()
  M.Super.Construct(self)
  self.Btn_Finish:SetPCImg("Esc")
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:InitShortCuts()
  self:RefreshBaseInfo()
  self:LockObservationMouse()
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:SetObservationInputMode(bLockMouse)
  if not self.GameInputModeSubsystem then
    return
  end
  if bLockMouse then
    local Params = FGameInputModeParams()
    Params.WidgetToFocus = self
    Params.MouseLockMode = EMouseLockMode.LockAlways
    Params.bHideCursorDuringCapture = true
    Params.bShowMouseCursor = false
    self.GameInputModeSubsystem:EnableInputMode(InputModeTag, EGameInputMode.GameAndUI, Params)
    return
  end
  self.GameInputModeSubsystem:DisableInputMode(InputModeTag)
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  local IsGamepad = CurInputType == ECommonInputType.Gamepad
  self.UsingGamepad = IsGamepad
  self:RefreshShortcutInfo(IsGamepad)
  self:SetFocusTarget()
end

function M:ShouldFocus()
  return not self.bExitPopupOpened
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

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self:SetFocusTarget()
end

function M:InitShortCuts()
  self.Key_Aim:AddExecuteLogic(self, self.OnAimClicked)
  self.Key_Esc:AddExecuteLogic(self, self.OnEscClicked)
  self.Key_Skip:AddExecuteLogic(self, self.OnSkipClicked)
  self.Key_Hide:AddExecuteLogic(self, self.OnHideClicked)
  self.Key_Auto:AddExecuteLogic(self, self.OnAutoPlayClicked)
  self.Key_Continue:AddExecuteLogic(self, self.OnContinueClicked)
  self.bHasShownAim = nil
  self.ContinuePressTime = nil
end

function M:RefreshShortcutInfo(bUseGamePad)
  local KeyType = bUseGamePad and "Img" or "Text"
  self.Key_Hide:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "U",
        ImgShortPath = UIConst.GamePadImgKey.RightThumb
      }
    },
    Desc = GText("UI_Dye_HideUI")
  })
  local ExitDesc = GText("Impression_UI_Back")
  if self.PanelState == EPanelState.Completed then
    ExitDesc = GText("UI_Observation_Finsh")
  end
  self.Key_Esc:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "Esc",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
      }
    },
    Desc = ExitDesc
  })
  if not bUseGamePad then
    if self.bShowEsc then
      self.Key_Esc:SetVisibility(ESlateVisibility.Visible)
    end
  elseif self.bShowEsc and self.PanelState == EPanelState.Completed then
    self.Key_Esc:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Key_Auto:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "Tab",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
      }
    },
    Desc = GText("UI_TALK_AUTO_1")
  })
  self.Key_Skip:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "Space",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
      }
    },
    bLongPress = true,
    Desc = GText("UI_TALK_SKIP")
  })
  self.Key_Continue:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "Space",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
      }
    },
    Desc = GText("UI_CTL_Continue")
  })
  if bUseGamePad then
    if self.bShowConfirm then
      self.Key_Continue:SetVisibility(ESlateVisibility.Visible)
    end
  else
    self.Key_Continue:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Key_Aim:CreateCommonKey({
    KeyInfoList = {
      {
        Type = KeyType,
        Text = "F",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
      }
    }
  })
  self:AddTimer(0.1, function()
    self.AutoPlayTimer = nil
    self:SetAutoPlay(self.bAutoPlay)
  end, nil, nil, "AutoPlayTimer", true)
end

function M:ChangeAutoPlayUI(bAutoPlay)
  if bAutoPlay then
    self.Key_Auto:SetDescription(GText("UI_TALK_AUTO_2"))
    self.Key_Auto:StopAllAnimations()
    self.Key_Auto:PlayLoopAnim()
    return
  end
  self.Key_Auto:SetDescription(GText("UI_TALK_AUTO_1"))
  self.Key_Auto:StopAllAnimations()
  self.Key_Auto:StopLoopAnim()
end

function M:ShowAimButton(bShow)
  if bShow then
    self.bShowAim = true
  else
    self.bShowAim = false
    self.bHasShownAim = false
    self.Key_Aim:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:ShowSkipButton(bShow)
  if bShow then
    self.Key_Skip:SetVisibility(ESlateVisibility.Visible)
    self.Key_Skip:_Reset2InitState()
    self.Key_Skip:_ForeachChildren(function(v)
      v:_Reset2InitState()
    end)
  else
    self.Key_Skip:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:ShowConfirmButton(bShow)
  if bShow then
    self.bShowConfirm = true
    if not self.UsingGamepad then
      self.Key_Continue:SetVisibility(ESlateVisibility.Collapsed)
      return
    end
    self.Key_Continue:SetVisibility(ESlateVisibility.Visible)
  else
    self.bShowConfirm = false
    self.Key_Continue:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:ShowEscButton(bShow)
  if bShow then
    self.bShowEsc = true
    if self.PanelState == EPanelState.Completed and self.UsingGamepad then
      self.Key_Esc:SetVisibility(ESlateVisibility.Collapsed)
      return
    end
    self.Key_Esc:SetVisibility(ESlateVisibility.Visible)
  else
    self.bShowEsc = false
    self.Key_Esc:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:ClickConfirmButton()
  if not self.bShowConfirm then
    return
  end
  self.Key_Continue:OnShortCutPressed()
  if self.ConfirmTimer then
    self:RemoveTimer(self.ConfirmTimer)
  end
  self.ConfirmTimer = self:AddTimer(self.Key_Continue.Press:GetEndTime(), function()
    self:OnKeyReleased(self.Key_Continue)
    self.ConfirmTimer = nil
  end, nil, nil, nil, true)
end

function M:OnEscClicked()
  if self.PanelState == EPanelState.Hidden then
    self:TogglePanelHidden()
    return
  end
  self:OnExitClicked()
end

function M:OnHideClicked()
  self:TogglePanelHidden()
end

function M:LockObservationMouse()
  if self.MouseCaptured then
    return
  end
  self:SetFocus()
  self:SetObservationInputMode(true)
  self.HasMoveDelta = false
  self.LastRealMousePos = nil
  self:SetCursor(EMouseCursor.None)
  self.MouseCaptured = true
end

function M:UnlockObservationMouse()
  if not self.MouseCaptured then
    return
  end
  self:ResetCursor()
  self:SetObservationInputMode(false)
  self.MouseCaptured = false
end

function M:UpdateKeyState(State, bUseCamera)
  if State == EPanelState.Loading then
    self.Key_Hide:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self:ShowEscButton(false)
    self:ShowAimButton(false)
    self:ShowSkipButton(false)
    self:ShowConfirmButton(false)
  elseif State == EPanelState.Hidden then
    self.Key_Hide:SetVisibility(ESlateVisibility.Visible)
    self.Key_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Esc:SetDescription(GText("Impression_UI_Back"))
    self:ShowEscButton(true)
    self:ShowAimButton(false)
    self:ShowSkipButton(false)
    self:ShowConfirmButton(false)
  elseif State == EPanelState.Dialog then
    if bUseCamera then
      self.Key_Hide:SetVisibility(ESlateVisibility.Collapsed)
      self:ShowEscButton(false)
    else
      self.Key_Hide:SetVisibility(ESlateVisibility.Visible)
      self:ShowEscButton(true)
    end
    self.Key_Auto:SetVisibility(ESlateVisibility.Visible)
    self:ShowAimButton(false)
    self:ShowSkipButton(true)
    self:ShowConfirmButton(true)
  elseif State == EPanelState.Normal then
    self.Key_Hide:SetVisibility(ESlateVisibility.Visible)
    self.Key_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self:ShowEscButton(true)
    self:ShowAimButton(true)
    self:ShowSkipButton(false)
    self:ShowConfirmButton(false)
  elseif State == EPanelState.Completed then
    self.Key_Hide:SetVisibility(ESlateVisibility.Visible)
    self.Key_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Esc:SetDescription(GText("UI_Observation_Finsh"))
    self:ShowEscButton(true)
    self:ShowAimButton(false)
    self:ShowSkipButton(false)
    self:ShowConfirmButton(false)
  end
end

function M:ApplyPanelState(bUseCamera)
  M.Super.ApplyPanelState(self, bUseCamera)
  local State = self.PanelState
  if State == EPanelState.Dialog then
    self:UnlockObservationMouse()
    return
  end
  self:LockObservationMouse()
end

function M:Cleanup()
  self:UnlockObservationMouse()
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  M.Super.Cleanup(self)
end

function M:RefreshCheckpointAimState()
  M.Super.RefreshCheckpointAimState(self)
  if self.CurrentAimCheckpointIndex then
    if not self.bHasShownAim and self.bShowAim then
      self.bHasShownAim = true
      self.Key_Aim:SetVisibility(ESlateVisibility.Visible)
    end
  elseif self.bHasShownAim then
    self.bHasShownAim = false
    self.Key_Aim:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:Tick(MyGeometry, InDeltaTime)
  M.Super.Tick(self, MyGeometry, InDeltaTime)
  local MoveDeltaX, MoveDeltaY
  if self.HasMoveDelta then
    if self.UsingGamepad then
      MoveDeltaX, MoveDeltaY = self.GamepadMoveDeltaX or 0, self.GamepadMoveDeltaY or 0
      self:ProcessRotateInput(MoveDeltaX, MoveDeltaY)
      self.GamepadMoveDeltaX = 0
      self.GamepadMoveDeltaY = 0
    else
      if self.LastRealMousePos then
        local CurRealMousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
        MoveDeltaX = CurRealMousePos.X - self.LastRealMousePos.X
        MoveDeltaY = self.LastRealMousePos.Y - CurRealMousePos.Y
        self:ProcessRotateInput(MoveDeltaX, MoveDeltaY)
      end
      ULowEntryExtendedStandardLibrary.SetMousePositionInPercentages(0.5, 0.5)
      self.LastRealMousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    end
    self.HasMoveDelta = false
  end
  self:SnapAimToCheckpoint(MoveDeltaX, MoveDeltaY)
end

function M:OnMouseMove(_, MouseEvent)
  if self.PanelState == EPanelState.Dialog then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.HasMoveDelta = true
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
    self.GamepadMoveDeltaX = AnalogValue * GamepadRotateSpeed
    self.HasMoveDelta = true
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_RightY" == InKeyName then
    self.GamepadMoveDeltaY = AnalogValue * GamepadRotateSpeed
    self.HasMoveDelta = true
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(_, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Key_Esc:IsVisible() and not self.Key_Esc.bHasButtonPressed then
    self.Key_Esc:OnShortCutPressed()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if ("Tab" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonTop) and self.Key_Auto:IsVisible() and not self.Key_Auto.bHasButtonPressed then
    self.Key_Auto:OnShortCutPressed()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "U" == InKeyName or InKeyName == UIConst.GamePadKey.RightThumb then
    if self.Key_Hide:IsVisible() and not self.Key_Hide.bHasButtonPressed then
      self.Key_Hide:OnShortCutPressed()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if "F" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.Key_Aim:IsVisible() and not self.Key_Aim.bHasButtonPressed then
      self.Key_Aim:OnShortCutPressed()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnPreviewKeyDown(_, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName then
    local Handled = false
    if self.Btn_Finish:IsVisible() and not self.Btn_Finish.IsPressing then
      self.Btn_Finish:OnBtnPressed()
      Handled = true
    end
    if self.Key_Esc:IsVisible() and not self.Key_Esc.bHasButtonPressed then
      self.Key_Esc:OnShortCutPressed()
      Handled = true
    end
    if Handled then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "SpaceBar" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      if self.Btn_Finish:IsVisible() and not self.Btn_Finish.IsPressing and not self.BottomKeyPressing then
        self.Btn_Finish:OnBtnPressed()
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
      self.BottomKeyPressing = true
    end
    if not self.ContinuePressTime then
      self.ContinuePressTime = UGameplayStatics.GetTimeSeconds(self)
    end
    if self.Key_Skip:IsVisible() and not self.Key_Skip.bHasButtonPressed then
      self.Key_Skip:OnShortCutPressed()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(_, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if "Escape" == InKeyName and self.Btn_Finish:IsVisible() and self.Btn_Finish.IsPressing then
      self.Btn_Finish:OnBtnReleased()
      self.Btn_Finish:OnBtnClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self.Key_Esc:IsVisible() and self.Key_Esc.bHasButtonPressed then
      self:OnKeyReleased(self.Key_Esc)
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if ("Tab" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonTop) and self.Key_Auto:IsVisible() and self.Key_Auto.bHasButtonPressed then
    self:OnKeyReleased(self.Key_Auto)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "U" == InKeyName or InKeyName == UIConst.GamePadKey.RightThumb then
    if self.Key_Hide:IsVisible() and self.Key_Hide.bHasButtonPressed then
      self:OnKeyReleased(self.Key_Hide)
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if "SpaceBar" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      if self.Btn_Finish:IsVisible() and self.Btn_Finish.IsPressing then
        self.Btn_Finish:OnBtnReleased()
        self.Btn_Finish:OnBtnClicked()
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
      self.BottomKeyPressing = false
    end
    if self.ContinuePressTime then
      local CurTime = UGameplayStatics.GetTimeSeconds(self)
      if CurTime - self.ContinuePressTime < Const.ShortPressThreshold then
        self:ClickConfirmButton()
      end
      self.ContinuePressTime = nil
    end
    if self.Key_Skip:IsVisible() and self.Key_Skip.bHasButtonPressed then
      self.Key_Skip:OnShortCutReleased()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if "F" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.Key_Aim:IsVisible() and self.Key_Aim.bHasButtonPressed then
      self:OnKeyReleased(self.Key_Aim)
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyReleased(Key)
  if not IsValid(Key) then
    return
  end
  Key:OnShortCutReleased()
  Key:OnButtonReleasedInsideButtonFrame()
end

function M:ResetBtnAnimations()
  M.Super.ResetBtnAnimations(self)
  self.Key_Aim:OnShortCutReleased()
  self.Key_Esc:OnShortCutReleased()
  self.Key_Skip:OnShortCutReleased()
  self.Key_Hide:OnShortCutReleased()
  self.Key_Auto:OnShortCutReleased()
  self.Key_Continue:OnShortCutReleased()
end

return M
