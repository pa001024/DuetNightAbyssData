require("UnLua")
local PersonInfoCustomEditPageController = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditPageController")
local PersonInfoCustomEditMainPageBase = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditMainPageBase")
local CommonUtils = require("Utils.CommonUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditMainPageBase"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditPointerInputComponent",
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoCameraRoamComponent",
  "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditRoot_P_GamepadComp"
}

function M:OnLoaded(OpenArg)
  self.Super.OnLoaded(self, OpenArg)
  local TabName = type(OpenArg) == "table" and OpenArg.TabName or OpenArg
  local OpenContext = type(OpenArg) == "table" and OpenArg or nil
  self.PageController = PersonInfoCustomEditPageController:New(self)
  self.PageController:InitPageController(TabName, OpenContext)
  self:_InitCustomEditHideUIKey()
  self.HideUI_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.TouchInfo = self.TouchInfo or {}
  self.EnableDrag = true
  self.EnableMouseWheel = true
  self.RotateCameraByPointer = false
  self.RotPitch = 0
  self.RotYaw = 0
  self.CurInputDeviceType = self.CurInputDeviceType or nil
  self.CurGamepadName = self.CurGamepadName or nil
  self:InitCameraRoam()
  self.bIsFocusable = true
  self:_ResumeEditPreviewCameraControl()
  self:FirstInitGamePadView()
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  self:SetFocus()
  self:_ResumeEditPreviewCameraControl()
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
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
  local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)
  if self:IsPreviewCameraRoamEnabled() and self.ActorController and 0 ~= WheelDelta then
    self.ActorController:OnScrolling(WheelDelta)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
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
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    if self.ActorController then
      if 0 == CursorDelta.X and 0 == CursorDelta.Y then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
      end
      self.MovedWhileDragging = true
      self.ActorController:BeginCameraPreviewTransaction()
      self.ActorController:OrbitCameraByCursorDelta({
        X = CursorDelta.X or 0,
        Y = CursorDelta.Y or 0
      })
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
  self:ResetCameraRoamInput()
  self:OnPointerCaptureLost()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_KeyUpOnGamePad and self:Handle_KeyUpOnGamePad(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:OnCameraRoamKeyUp(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local SuperReply = self.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_PreviewKeyDownOnGamePad and self:Handle_PreviewKeyDownOnGamePad(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return SuperReply or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName and self.bHiddenUI then
    self:OnHideUIClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_KeyDownOnGamePad and self:Handle_KeyDownOnGamePad(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return PersonInfoCustomEditMainPageBase.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_CustomEditGamepadAnalog then
    local AnalogValue = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if self:Handle_CustomEditGamepadAnalog(InKeyName, AnalogValue) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
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

function M:OnDestroyed()
  self:_CancelScheduledGamepadDefaultFocus()
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

function M:_InitCustomEditHideUIKey()
  self.HideUI_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("U"),
        ClickCallback = self.OnHideUIClick,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.RightThumb,
        ClickCallback = self.OnHideUIClick,
        Owner = self
      }
    },
    Desc = GText("UI_Dye_HideUI"),
    bLongPress = false
  })
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

AssembleComponents(M)
return M
