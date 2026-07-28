require("UnLua")
local PersonInfoCustomEditPageController = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditPageController")
local PersonInfoCustomEditMainPageBase = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditMainPageBase")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditMainPageBase"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditPointerInputComponent",
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoCameraRoamComponent"
}

local function GetMobileJoystickRoamSpeed()
  local CameraInputConfig = PersonInfoCommon.CameraInputConfig or {}
  return CameraInputConfig.MobileJoystickRoamSpeed or 20
end

function M:OnLoaded(OpenArg)
  self.Super.OnLoaded(self, OpenArg)
  self.TouchInfo = self.TouchInfo or {}
  self.MobileTouchState = self.MobileTouchState or {}
  self.EnableDrag = true
  self.EnableMouseWheel = true
  self.RotateCameraByPointer = false
  self.RotPitch = 0
  self.RotYaw = 0
  local TabName = type(OpenArg) == "table" and OpenArg.TabName or OpenArg
  local OpenContext = type(OpenArg) == "table" and OpenArg or nil
  self.PageController = PersonInfoCustomEditPageController:New(self)
  self.PageController:InitPageController(TabName, OpenContext)
  self:InitCameraRoam()
  self.bIsFocusable = true
  self:SetFocus()
  self:_BindMobileCameraJoystick()
  self:_BindMobileActionButtons()
  self:_RefreshMobileActionButtonGroupView()
  self:_RefreshMobileChangeModelView()
  self:_ResumeEditPreviewCameraControl()
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  self:SetFocus()
  self:_RefreshMobileActionButtonGroupView()
  self:_RefreshMobileChangeModelView()
  self:_ResumeEditPreviewCameraControl()
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  self:SetFocus()
  if self.bHiddenUI then
    self:OnHideUIClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:TryCloseCharacterTipsByMask() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self.ActorController and self.ActorController.BeginPointerSelection then
    self.ActorController:BeginPointerSelection(MyGeometry, MouseEvent)
  end
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  self:SetFocus()
  local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)
  if self:IsPreviewCameraRoamEnabled() and self.ActorController and 0 ~= WheelDelta then
    local bHandled = self.ActorController:OnScrolling(WheelDelta)
    if bHandled then
      self:_RefreshMobileResetCameraButtonState()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self:SetFocus()
  self.RotateCameraByPointer = false
  self.RotPitch = 0
  self.RotYaw = 0
  local WasDraggingWithoutMove = self.IsDragging and not self.MovedWhileDragging
  if self.ActorController then
    self.ActorController:CommitWheelCameraPreviewTransaction()
    self.ActorController:CommitCameraPreviewTransaction()
  end
  local Reply = self:OnPointerUp(MyGeometry, MouseEvent)
  if WasDraggingWithoutMove then
    self:TrySelectPreviewEntityByPointer()
  elseif self.ActorController and self.ActorController.ClearPendingPointerSelection then
    self.ActorController:ClearPendingPointerSelection()
  end
  return Reply
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  if self.IsDragging and self:IsPreviewCameraRoamEnabled() and UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.RightMouseButton) then
    self:SetFocus()
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    if self.ActorController then
      if 0 == CursorDelta.X and 0 == CursorDelta.Y then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
      end
      self.MovedWhileDragging = true
      self.ActorController:BeginCameraPreviewTransaction()
      local bHandled = self.ActorController:OrbitCameraByCursorDelta({
        X = CursorDelta.X or 0,
        Y = CursorDelta.Y or 0
      })
      if bHandled then
        self:_RefreshMobileResetCameraButtonState()
      end
      if not self:HasMouseCapture() then
        return UE4.UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(), self)
      end
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if self.IsDragging and UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnMouseCaptureLost()
  self:SetFocus()
  self.RotateCameraByPointer = false
  self.RotPitch = 0
  self.RotYaw = 0
  if self.ActorController and self.ActorController.ClearPendingPointerSelection then
    self.ActorController:ClearPendingPointerSelection()
  end
  if self.ActorController then
    self.ActorController:CommitWheelCameraPreviewTransaction()
    self.ActorController:CommitCameraPreviewTransaction()
  end
  self:_PauseMobileCameraJoyStickMoveSound()
  self:ResetCameraRoamInput()
  self:OnPointerCaptureLost()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:OnCameraRoamKeyUp(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:Tick(MyGeometry, InDeltaTime)
  self:TickCameraRoamInput(InDeltaTime)
end

function M:RealClose()
  if self.IsInUIMode then
    self:SetInputUIOnly(false)
  end
  self.Super.RealClose(self)
end

function M:TickCameraRoamInput(InDeltaTime)
  if not self:IsPreviewCameraRoamEnabled() then
    self.RotateCameraByPointer = false
    self.RotPitch = 0
    self.RotYaw = 0
    self:_PauseMobileCameraJoyStickMoveSound()
    return false
  end
  local Handled = self:TickCameraRoam(InDeltaTime)
  if self.RotateCameraByPointer and self.ActorController and (0 ~= self.RotPitch or 0 ~= self.RotYaw) then
    self.ActorController:OrbitCameraByCursorDelta({
      X = self.RotYaw,
      Y = -self.RotPitch
    })
    Handled = true
  end
  self.RotateCameraByPointer = false
  self.RotPitch = 0
  self.RotYaw = 0
  return Handled
end

function M:RefreshCommonActionState()
  PersonInfoCustomEditMainPageBase.RefreshCommonActionState(self)
  self:_RefreshMobileActionButtonGroupView()
  self:_RefreshMobileResetCameraButtonState()
  self:_RefreshMobileChangeModelView()
end

function M:_RefreshMobileActionButtonGroupView()
  if self.VB_Btn then
    local Visibility = UIConst.VisibilityOp.SelfHitTestInvisible
    local bShowActionButtons = not self.PageController or not self.PageController.IsChoosePageActive or not self.PageController:IsChoosePageActive()
    self.VB_Btn:SetVisibility(bShowActionButtons and Visibility or UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Invisible and self.Btn_Invisible.SetText then
    self.Btn_Invisible:SetText(GText("UI_Dye_HideUI"))
  end
  if self.Btn_Screenshot and self.Btn_Screenshot.SetText then
    self.Btn_Screenshot:SetText(GText("UI_PersonalPage_Screenshot"))
  end
end

function M:_RefreshMobileChangeModelView()
  local Visibility = UIConst.VisibilityOp.SelfHitTestInvisible
  local bShowChangeModel = self.PageController and self.PageController.IsMobileCharacterEditToggleAvailable and self.PageController:IsMobileCharacterEditToggleAvailable()
  local bShowLeftPanel = self.PageController and self.PageController.ShouldShowMobileCharacterEditPanel and self.PageController:ShouldShowMobileCharacterEditPanel()
  local bShowJoystick = self:ShouldShowMobileCameraJoystick()
  if self.PageController and self.PageController.CharacterEditPanel then
    self.PageController.CharacterEditPanel:SetVisibility(bShowLeftPanel and Visibility or UIConst.VisibilityOp.Collapsed)
  end
  if self.WBP_Camera_Roll_M then
    self.WBP_Camera_Roll_M:SetVisibility(bShowJoystick and Visibility or UIConst.VisibilityOp.Collapsed)
    if bShowJoystick and self.WBP_Camera_Roll_M.Roll_Normal and self.WBP_Camera_Roll_M.PlayAnimation then
      self.WBP_Camera_Roll_M:PlayAnimation(self.WBP_Camera_Roll_M.Roll_Normal)
    end
    if self.WBP_Camera_Roll_M.SetJoyStickLocked then
      self.WBP_Camera_Roll_M:SetJoyStickLocked(not bShowJoystick)
    end
  end
  if self.Btn_ChangeModel then
    self.Btn_ChangeModel:SetVisibility(bShowChangeModel and Visibility or UIConst.VisibilityOp.Collapsed)
    self.Btn_ChangeModel.Text_Btn:SetText(GText(bShowLeftPanel and "UI_PersonalPage_MoveCamera" or "UI_PersonalPage_AdjustParameters"))
  end
end

function M:_RefreshMobileResetCameraButtonState()
  if not self.Btn_ResetCamera then
    return
  end
  local _, bEnableResetCamera = self:GetMobileResetCameraState()
  self.Btn_ResetCamera.Btn_Click:SetForbidden(not bEnableResetCamera)
  if self.Btn_ResetCamera.SetText then
    self.Btn_ResetCamera:SetText(GText("UI_PersonalPage_ResetCamera"))
  end
end

function M:OnDestroyed()
  self:ResetCameraRoamInput()
  if self.PageController then
    self.PageController:OnDestructPageController()
  end
  self.PageController = nil
  self.Super.OnDestroyed(self)
end

function M:GetZOrder()
  return 200
end

function M:GetCustomEditRootController()
  return self.PageController
end

function M:IsPreviewCameraRoamEnabled()
  return self.PageController and self.PageController:IsPreviewCameraRoamEnabled() or false
end

function M:TryCloseCharacterTipsByMask()
  if self.PageController and self.PageController.TryCloseCharacterTipsByMask then
    return self.PageController:TryCloseCharacterTipsByMask()
  end
  return false
end

function M:TrySelectPreviewEntityByPointer()
  if self.PageController and self.PageController.TrySelectPreviewEntityByPointer then
    return self.PageController:TrySelectPreviewEntityByPointer()
  end
  return false
end

function M:ShouldShowMobileCameraJoystick()
  return self.PageController and self.PageController:ShouldShowMobileCameraJoystick() or false
end

function M:GetMobileResetCameraState()
  if self.PageController and self.PageController.GetMobileResetCameraState then
    return self.PageController:GetMobileResetCameraState()
  end
  return false, false
end

function M:ResetCameraToSceneDefault()
  if self.PageController and self.PageController.ResetCameraToSceneDefault then
    return self.PageController:ResetCameraToSceneDefault()
  end
  return false
end

function M:GetMainPageView()
  if self.PageController and self.PageController.GetMainPageView then
    return self.PageController:GetMainPageView()
  end
  return nil
end

function M:ToggleMobileLeftPanelMode()
  if self.PageController and self.PageController.ToggleMobileLeftPanelMode then
    self.PageController:ToggleMobileLeftPanelMode()
  end
end

function M:_ResumeEditPreviewCameraControl()
  if not self.ActorController then
    return
  end
  if self.ActorController.ResumePreviewControl then
    self.ActorController:ResumePreviewControl()
  end
  if self.ActorController.ViewTarget then
    self.ActorController:ViewTarget()
  end
end

function M:_BindMobileCameraJoystick()
  if not self.WBP_Camera_Roll_M or self._bMobileCameraJoystickBound then
    return
  end
  self._bMobileCameraJoystickBound = true
  self.WBP_Camera_Roll_M:BindEvnetOnJoyStick(self, {
    OnMoved = self.OnMobileCameraJoyStickMove,
    OnPointerDown = self.OnMobileCameraJoyStickPointerDown,
    OnPointerUp = self.OnMobileCameraJoyStickPointerUp
  })
  self:_RefreshMobileChangeModelView()
end

function M:_BindMobileActionButtons()
  if self._bMobileActionButtonsBound then
    return
  end
  self._bMobileActionButtonsBound = true
  self.Btn_CameraSet.Btn_ClickBack.OnClicked:Clear()
  self.Btn_CameraSet.Btn_ClickBack.OnClicked:Add(self, self.OnClickUndo)
  self.Btn_CameraSet.Btn_ClickReset.OnClicked:Clear()
  self.Btn_CameraSet.Btn_ClickReset.OnClicked:Add(self, self.OnClickRedo)
  if self.Btn_ResetCamera then
    self.Btn_ResetCamera.Btn_Click.OnClicked:Clear()
    self.Btn_ResetCamera.Btn_Click.OnClicked:Add(self, self.OnClickResetCamera)
  end
  if self.Btn_Invisible then
    self.Btn_Invisible.Btn_Click.OnClicked:Clear()
    self.Btn_Invisible.Btn_Click.OnClicked:Add(self, self.OnHideUIClick)
  end
  self.Btn_ChangeModel.Btn_Click.OnClicked:Clear()
  self.Btn_ChangeModel.Btn_Click.OnClicked:Add(self, self.OnClickChangeModel)
  if self.Btn_Screenshot then
    self.Btn_Screenshot:UnBindEventOnClickedByObj(self)
    self.Btn_Screenshot:BindEventOnClicked(self, self.OnClickMobileScreenshot)
  end
end

function M:OnClickResetCamera()
  local _, bEnabled = self:GetMobileResetCameraState()
  if not bEnabled then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_DefaultCamera"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self:ResetCameraToSceneDefault() then
    self:_RefreshMobileResetCameraButtonState()
  end
end

function M:OnClickMobileHideUI()
  if self._bMobileHideUI then
    return
  end
  self._bMobileHideUI = not self._bMobileHideUI
  if self._bMobileHideUI then
    self:PlayAnimation(self.HideUi)
  else
    self:PlayAnimation(self.ShowUi)
  end
end

function M:OnClickChangeModel()
  if self.PageController and self.PageController.ToggleMobileLeftPanelMode then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    self.PageController:ToggleMobileLeftPanelMode()
    self:_RefreshMobileChangeModelView()
  end
end

function M:OnClickMobileScreenshot()
  local MainPageView = self:GetMainPageView()
  if MainPageView and MainPageView.OnScreenshotKeyDown then
    MainPageView:OnScreenshotKeyDown()
  end
end

function M:OnMobileCameraJoyStickMove(Dir, Percent)
  if not (self:IsPreviewCameraRoamEnabled() and self.ActorController) or not Dir then
    self:_PauseMobileCameraJoyStickMoveSound()
    return
  end
  self:_PlayMobileCameraJoyStickMoveSound()
  AudioManager(self):SetEventSoundParam(self, "PersonInfoMobileCameraMove", {
    drag = (Percent or 0) > 0 and 1 or 0
  })
  self.ActorController:BeginCameraPreviewTransaction()
  local bHandled = self:MoveCameraRoamByDelta((Dir.X or 0) * (Percent or 0) * GetMobileJoystickRoamSpeed(), (Dir.Y or 0) * (Percent or 0) * GetMobileJoystickRoamSpeed())
  if bHandled then
    self:_RefreshMobileResetCameraButtonState()
  end
end

function M:OnMobileCameraJoyStickPointerDown()
  if not self:IsPreviewCameraRoamEnabled() or not self.ActorController then
    return
  end
  self:_PlayMobileCameraJoyStickMoveSound()
  AudioManager(self):SetEventSoundParam(self, "PersonInfoMobileCameraMove", {drag = 0})
  self.ActorController:BeginCameraPreviewTransaction()
end

function M:OnMobileCameraJoyStickPointerUp()
  self:_PauseMobileCameraJoyStickMoveSound()
  if self.ActorController then
    self.ActorController:CommitCameraPreviewTransaction()
  end
end

function M:_PlayMobileCameraJoyStickMoveSound()
  local AudioMgr = AudioManager(self)
  if not AudioMgr:IsSoundPlaying(self, "PersonInfoMobileCameraMove") then
    AudioMgr:PlayUISound(self, "event:/ui/common/camera_move", "PersonInfoMobileCameraMove", nil)
  end
  AudioMgr:SetEventSoundParam(self, "PersonInfoMobileCameraMove", {drag = 1})
end

function M:_PauseMobileCameraJoyStickMoveSound()
  AudioManager(self):SetEventSoundParam(self, "PersonInfoMobileCameraMove", {drag = 0})
end

AssembleComponents(M)
return M
