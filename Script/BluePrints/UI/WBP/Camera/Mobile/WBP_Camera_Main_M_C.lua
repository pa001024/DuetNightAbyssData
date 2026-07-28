require("UnLua")
local M = Class("BluePrints.UI.WBP.Camera.WBP_CameraBase_C")
M.CameraCustomizePlatform = "Mobile"
M._components = {
  "BluePrints.UI.WBP.Camera.WBP_Camera_Main_Base_C"
}
local ModeInfo = {
  GText("UI_CameraSystem_CameraModeSelfie"),
  GText("UI_CameraSystem_CameraModeDefault"),
  GText("UI_CameraSystem_CameraModePhotography")
}
local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:EnsureCameraMainInputFocus()
  self.bIsFocusable = true
  if self.SetFocus then
    self:SetFocus()
  end
  if self.GameInputModeSubsystem and self.GameInputModeSubsystem.SetTargetUIFocusWidget then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
  end
end

function M:Construct()
  self.bIsFocusable = true
  self.CameraInfo = {
    1,
    0,
    2
  }
  self.MainCameraIndex = 2
  self:RefreshPauseButtonState(true)
  self.TouchInfo = {}
  self.Btn_Close.Btn_Close.OnClicked:Clear()
  self.Btn_Close.Btn_Close.OnClicked:Add(self, self.OnCameraMainCloseClicked)
  self.TabConfig = {
    Tabs = {
      {
        Text = GText("UI_CameraSystem_CameraModeDefault"),
        CameraIndex = 0
      },
      {
        Text = GText("UI_CameraSystem_CameraModeSelfie"),
        CameraIndex = 1
      },
      {
        Text = GText("UI_CameraSystem_CameraModePhotography"),
        CameraIndex = 2
      }
    },
    SoundFunc = function()
    end
  }
  self.Btn_HideUI:BindEventOnClicked(self, self.OnHideUIBtnClicked, self.Btn_HideUI)
  self.Btn_Reset:BindEventOnClicked(self, self.OnResetCameraBtnClicked, self.Btn_Reset)
  self.Btn_SwitchMode:BindEventOnClicked(self, self.SwitchMode, self.Btn_SwitchMode)
  self.Btn_Pause:BindEventOnClicked(self, self.BtnPause, self.Btn_Pause)
  self.Btn_Parameter:BindEventOnClicked(self, self.OnShowParameterBtnClicked)
  self.Roll:BindEvnetOnJoyStick(self, {
    OnMoved = self.OnJoyStickMove,
    OnPointerDown = self.OnJoyStickPointerDown,
    OnPointerUp = self.OnJoyStickPointerUp
  })
  self.Btn_Shoot:BindEventOnClicked(self, self.OnCheeseBtnClicked)
  self.FocalLengthSlider = self.WBP_Camera_Bar
  self:FlushAnimations()
  self:PlayAnimation(self.BtnHideRole_Normal)
  self.bHasAnyCharacterHidden = false
  M.Super.Construct(self)
  self:InitCameraCustomizeMain()
  self:EnsureCameraMainInputFocus()
  self:UpdateCheckBox()
  self:UpdateHideCharacterBtn()
end

function M:RefreshPauseButtonState(IsGamePause)
  self.IsPause = true == IsGamePause
  local PauseTypeSwitcher = self.Btn_Pause and self.Btn_Pause.WS_Type
  if PauseTypeSwitcher then
    PauseTypeSwitcher:SetActiveWidgetIndex(self.IsPause and 0 or 1)
  end
end

function M:BtnPause(FromBtn)
  local bTargetPause = UE4.UGameplayStatics.IsGamePaused(self) ~= true
  if self:NotifyGamePauseChange(bTargetPause) == false then
    return
  end
end

function M:HideMenu(FromBtn)
  self.Btn_HideUI:Unclicked()
end

function M:SwitchMode()
  self.MainCameraIndex = self.MainCameraIndex + 1
  if self.MainCameraIndex >= 4 then
    self.MainCameraIndex = 1
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ModeInfo[self.MainCameraIndex])
  self:ChangeCamera(self.CameraInfo[self.MainCameraIndex])
end

function M:OnShowRollScrollBarBtnClicked(FromBtn)
  UIUtils.PlayCommonBtnSe(self)
  self:HideMenu(FromBtn)
end

function M:ToggleShowRollScrollBar(FromBtn)
end

function M:OnShowTabBtnClicked(FromBtn)
  UIUtils.PlayCommonBtnSe(self)
  self:HideMenu(FromBtn)
  self:ToggleShowTab(FromBtn)
end

function M:ToggleShowTab(FromBtn)
  self.IsTabShowed = not self.IsTabShowed
  if self.IsTabShowed then
    self:StopAnimation(self.CameraTab_Out)
    self:PlayAnimation(self.CameraTab_In)
  else
    self:StopAnimation(self.CameraTab_In)
    self:PlayAnimation(self.CameraTab_Out)
    if FromBtn then
      FromBtn:Unclicked()
    end
  end
end

function M:OnTabSelected(TabWidget, Tab)
  self:ChangeCamera(Tab.CameraIndex)
  self.Text_Tab:SetText(Tab.Text)
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  local PointerIndex = UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InTouchEvent)
  self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
  if self.TouchInfo[0] and self.TouchInfo[1] then
    self.DualTouchDistance = (self.TouchInfo[0] - self.TouchInfo[1]):Size()
  end
  if self.bScreenshotWidgetShow then
    return Unhandle
  end
  return UWidgetBlueprintLibrary.CaptureMouse(Handle, self)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  local PointerIndex = UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InTouchEvent)
  self.TouchInfo[PointerIndex] = nil
  if not self.TouchInfo[0] or not self.TouchInfo[1] then
    self.DualTouchDistance = 0
  end
  if not self.HasTouchMove and self.bSelfHidden then
    self:ToggleHideSelf()
  end
  if not self.HasTouchMove then
    self:HideMenu()
  end
  self.HasTouchMove = false
  return UWidgetBlueprintLibrary.ReleaseMouseCapture(Handle)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  if self.bScreenshotWidgetShow then
    return Unhandle
  end
  local RealMove = false
  local PointerIndex = UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InTouchEvent)
  self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
  if self.TouchInfo[0] then
    if self.TouchInfo[1] then
      local NewDistance = (self.TouchInfo[0] - self.TouchInfo[1]):Size()
      self:MoveCamera((NewDistance - self.DualTouchDistance) / 5, 0, 0)
      self.DualTouchDistance = NewDistance
    else
      local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(InTouchEvent)
      RealMove = 0 ~= CursorDelta.Y or 0 ~= CursorDelta.X
      self:RotateCamera(0, -CursorDelta.Y, CursorDelta.X)
    end
  end
  self.HasTouchMove = self.HasTouchMove or RealMove
  return Unhandle
end

function M:OnMouseCaptureLost()
  self.HasTouchMove = false
end

function M:OnJoyStickMove(Dir, Percent)
  self.bCameraMovedByJoyStick = not self.bLockCameraPos
  self:MoveCamera(0, Dir.X * Percent, Dir.Y * Percent)
end

function M:OnJoyStickPointerDown()
  if self.bLockCameraPos then
    self.Roll:PlayAnimation(self.Roll.Warning)
  end
end

function M:OnJoyStickPointerUp()
  self.bCameraMovedByJoyStick = false
end

function M:OnRemovedFromFocusPath()
  self:StopCameraMove()
end

function M:StopCameraMove()
  self.HasTouchMove = false
  self.bCameraMovedByJoyStick = false
end

function M:OnRollScrollBarPercentChanged(Percent)
  self.bRollScrollBarPointerDown = true
  self:SetRollPercent(Percent)
end

function M:OnRollScrollBarInertialScrollingEnd()
  M.Super.OnRollScrollBarInertialScrollingEnd(self)
  self.bRollScrollBarPointerDown = false
end

function M:OnHideUIBtnClicked()
  self:HideMenu()
  self:ToggleHideSelf()
end

function M:OnHideCharacterBtnClicked(FromBtn)
  UIUtils.PlayCommonBtnSe(self)
  self:HideMenu(FromBtn)
  self:ToggleShowHideCharacterWidget(FromBtn)
end

function M:ToggleShowHideCharacterWidget(FromBtn)
  self.IsHideCharacterWidgetShowed = not self.IsHideCharacterWidgetShowed
  if self.IsHideCharacterWidgetShowed then
    self:StopAnimation(self.Menu_Out)
    self:PlayAnimation(self.Menu_In)
    self.CanvasPanel_HideRole:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self:StopAnimation(self.Menu_In)
    self:PlayAnimation(self.Menu_Out)
    self.CanvasPanel_HideRole:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if FromBtn then
      FromBtn:Unclicked()
    end
  end
end

function M:OnHideBtnClickedImp(HiddenButtonType, CharacterType)
  M.Super.OnHideBtnClickedImp(self, HiddenButtonType, CharacterType)
  local HiddenButton = self[HiddenButtonType]
  if not HiddenButton or not HiddenButton.bLocked then
    self:UpdateHideCharacterBtn()
  end
end

function M:UpdateCheckBox()
end

function M:UpdateHideCharacterBtn()
  local HasAnyCharacterHidden = 0 ~= self.CurCharHiddenState
  if self.bHasAnyCharacterHidden ~= HasAnyCharacterHidden then
    self.bHasAnyCharacterHidden = HasAnyCharacterHidden
    if HasAnyCharacterHidden then
      self:StopAnimation(self.BtnHideRole_Normal)
      self:PlayAnimation(self.BtnHideRole_Click)
    else
      self:StopAnimation(self.BtnHideRole_Click)
      self:PlayAnimation(self.BtnHideRole_Normal)
    end
  end
end

function M:OnCheckBoxClicked()
  if self.CurCharHiddenState ~= self.CharType.All then
    self:SetCharHiddengState(self.CharType.All)
  else
    self:SetCharHiddengState(0)
  end
  self:UpdateHideCharacterBtn()
end

function M:OnResetCameraBtnClicked()
  self:HideMenu()
  self:ResetCamera()
  if self.IsCustomizeOpened and self:IsCustomizeOpened() and self.ResetCameraCustomizeRoleRotationToDefault then
    self:ResetCameraCustomizeRoleRotationToDefault()
  end
  self.Btn_Reset:Unclicked()
end

function M:OnAddFocalLengthBtnClicked()
  self.FocalLengthSlider:AddValue()
end

function M:OnSubFocalLengthBtnClicked()
  self.FocalLengthSlider:SubValue()
end

function M:OnFocalLengthSliderValueChanged(Value)
  self:SetFocalLength(Value)
end

function M:OnCameraMainCloseClicked()
  if self.IsCustomizeOpened and self:IsCustomizeOpened() then
    self:CloseCameraCustomizePanel()
    return
  end
  if self:IsParameterWidgetShowed() then
    self:HideParameterWidget()
    return
  end
  self:OnBackBtnClicked()
end

function M:OnBackBtnClicked()
  self:CheckHasAnyOperationOrClose()
  self:HideMenu()
end

function M:OnCheeseBtnClicked()
  self:Screenshot()
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.bIsFocusable = true
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self:EnsureCameraMainInputFocus()
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.HasTouchMove or self.bCameraMovedByJoyStick then
    self.SoundFlags.Camera_Motor = true
  else
    self.SoundFlags.Camera_Motor = false
  end
  M.Super.Tick(self, MyGeometry, InDeltaTime)
  if self.UpdateCameraCustomizeLookAtCamera then
    self:UpdateCameraCustomizeLookAtCamera()
  end
  if self.UpdateCameraCustomizeWheelActionTransition then
    self:UpdateCameraCustomizeWheelActionTransition()
  end
end

function M:TickFindTargets()
  M.Super.TickFindTargets(self)
  if self.InitParams and self.InitParams.IsAprilFoolsDayActivity then
    self.Btn_Shoot:StopLoopRemind()
    return
  end
  if self.bScreenshotWidgetShow or self.IsShotTargetSucceeded then
    self.Btn_Shoot:StopLoopRemind()
    return
  end
  if self.bFindTarget then
    self.Btn_Shoot:PlayLoopRemind()
  else
    self.Btn_Shoot:StopLoopRemind()
  end
end

function M:SetLockGamePause(bNewLock)
  M.Super.SetLockGamePause(self, bNewLock)
end

function M:SetLockHiddenButton(HiddenButton, bNewLock)
  M.Super.SetLockHiddenButton(self, HiddenButton, bNewLock)
  if bNewLock then
    self:SetLockHiddenAllButton(bNewLock)
  end
end

function M:SetLockAllHiddenButton(bNewLock)
  M.Super.SetLockAllHiddenButton(self, bNewLock)
  self:SetLockHiddenAllButton(bNewLock)
end

function M:SetLockCameraPos(bNewLock)
  M.Super.SetLockCameraPos(self, bNewLock)
  if bNewLock then
    self.Roll:PlayAnimation(self.Roll.Roll_Lock)
  else
    self.Roll:PlayAnimation(self.Roll.Roll_Normal)
  end
  self.Roll:SetJoyStickLocked(bNewLock)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow and self.ScreenshotWidget and self.ScreenshotWidget.OnPreviewKeyDown then
    return self.ScreenshotWidget:OnPreviewKeyDown(MyGeometry, InKeyEvent) and UIUtils.Handled or UIUtils.Unhandled
  end
  if self.HandleCameraCustomizePreviewKeyDown and not self.bDisableCustom then
    local Reply = self:HandleCameraCustomizePreviewKeyDown(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow then
    self.ScreenshotWidget:OnKeyDown(MyGeometry, InKeyEvent)
    return UIUtils.Handled
  end
  if self.HandleCameraCustomizeKeyDown and not self.bDisableCustom then
    local Reply = self:HandleCameraCustomizeKeyDown(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or "Android_Back" == InKeyName or InKeyName == Const.GamepadFaceButtonRight then
    self:OnCameraMainCloseClicked()
  end
  return UIUtils.Handled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if self.HandleCameraCustomizeKeyUp then
    local Reply = self:HandleCameraCustomizeKeyUp(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  if self.HandleCameraCustomizeRepeatKeyDown then
    local Reply = self:HandleCameraCustomizeRepeatKeyDown(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if (InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadRight) and self.HandleCameraCustomizeKeyDown then
    local Reply = self:HandleCameraCustomizeKeyDown(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self.HandleCameraCustomizeAnalog then
    local Reply = self:HandleCameraCustomizeAnalog(MyGeometry, InAnalogInputEvent)
    if Reply then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:NotifyGamePauseChange(IsGamePause)
  if self.CanChangeCameraCustomizePause and not self:CanChangeCameraCustomizePause(IsGamePause) then
    return false
  end
  if false == IsGamePause and self.RestoreCameraCustomizeRoleRotation then
    self:RestoreCameraCustomizeRoleRotation()
  end
  M.Super.NotifyGamePauseChange(self, IsGamePause)
  self:RefreshPauseButtonState(IsGamePause)
  local bSuppressPauseToast = self.bCameraCustomizeSuppressNextPauseStateToast == true
  self.bCameraCustomizeSuppressNextPauseStateToast = false
  if not bSuppressPauseToast and self.bCameraCustomizePauseToastReady and self.ShowCameraCustomizePauseStateToast then
    self:ShowCameraCustomizePauseStateToast(IsGamePause)
  else
    self.bCameraCustomizePauseToastReady = true
  end
  return true
end

function M:Close()
  if self.StopCameraCustomizeLookAtCamera then
    self:StopCameraCustomizeLookAtCamera()
  end
  if self.StopCameraCustomizeWheelAction then
    self:StopCameraCustomizeWheelAction()
  end
  if self.RestoreCameraCustomizeRoleRotation then
    self:RestoreCameraCustomizeRoleRotation()
  end
  M.Super.Close(self)
end

function M:Destruct()
  if self.StopCameraCustomizeLookAtCamera then
    self:StopCameraCustomizeLookAtCamera()
  end
  if self.StopCameraCustomizeWheelAction then
    self:StopCameraCustomizeWheelAction()
  end
  if self.RestoreCameraCustomizeRoleRotation then
    self:RestoreCameraCustomizeRoleRotation()
  end
  if self.UnbindCameraCustomizeInputModeEvent then
    self:UnbindCameraCustomizeInputModeEvent()
  end
  if self.UnbindCameraCustomizeRegionOnlineInteractionEvent then
    self:UnbindCameraCustomizeRegionOnlineInteractionEvent()
  end
  M.Super.Destruct(self)
end

AssembleComponents(M)
return M
