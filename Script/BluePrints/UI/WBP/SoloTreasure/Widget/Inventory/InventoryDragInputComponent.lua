require("UnLua")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local Component = {}

local function GetKeyName(MouseEvent)
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName ~= "None" then
    return MouseButton.KeyName
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(MouseEvent)
  return UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
end

local function FireHoverWithDebounce(self, callback, delayFrames)
  self._hoverToken = (self._hoverToken or 0) + 1
  local token = self._hoverToken
  self:AddDelayFrameFunc(function()
    if self.bMouseEntering and self._hoverToken == token then
      self._hoverTriggered = true
      callback()
    end
  end, delayFrames)
end

local function StartDragHoldTimer(self)
  local holdTime = InventoryController.MainWidget and InventoryController.MainWidget.DetectDragHoldTime or 0.2
  self:AddTimer(holdTime, function()
    if InventoryController.bDetectDrag then
      InventoryController.StartDetectDragGrid:CustomOnDragDetected()
    end
  end, false, 0, "RequestAdsorptionToFirst")
end

local function ClearDetectDragState()
  InventoryController.bDetectDrag = false
  InventoryController.bDetectDragIsMouse = false
  InventoryController.StartDetectDragGrid = nil
  InventoryController.StartDetectDragPos = nil
end

function Component:OnPreviewMouseButtonDown(MyGeometry, MouseEvent)
  local KeyName = GetKeyName(MouseEvent)
  local IsHandled = false
  if self.CustomOnPreviewMouseButtonDown then
    IsHandled = self:CustomOnPreviewMouseButtonDown(MyGeometry, MouseEvent)
  end
  if self.PocketData == nil then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local GridData = InventoryController:GetGridData(self.PocketData.Name, self.Position)
  local TreasureData = GridData and GridData.TreasureData or nil
  local isConfirmKey = "LeftMouseButton" == KeyName or KeyName == Const.GamepadFaceButtonDown
  if isConfirmKey and not InventoryController.bDetectDrag and TreasureData then
    if not UIUtils.IsGamepadInput() then
      InventoryController.bDetectDrag = true
      InventoryController.StartDetectDragGrid = self
      InventoryController.StartDetectDragPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
      InventoryController.bDetectDragIsMouse = UIUtils.IsKeyboardInput()
      StartDragHoldTimer(self)
    end
    IsHandled = true
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function Component:OnMouseButtonUp(MyGeometry, MouseEvent)
  local KeyName = GetKeyName(MouseEvent)
  local IsHandled = false
  if self.CustomOnMouseButtonUp then
    IsHandled = self:CustomOnMouseButtonUp(MyGeometry, MouseEvent)
  end
  local isConfirmKey = "LeftMouseButton" == KeyName or KeyName == Const.GamepadFaceButtonDown
  if isConfirmKey then
    if InventoryController.bDraging and self.CustomOnDrop and not self.bRecycle then
      ClearDetectDragState()
      self:CustomOnDrop()
      IsHandled = true
    elseif not InventoryController.bDraging and UIUtils.IsGamepadInput() then
      ClearDetectDragState()
      InventoryController.StartDetectDragGrid = self
      self:CustomOnDragDetected()
      IsHandled = true
    else
      ClearDetectDragState()
    end
  end
  return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

function Component:OnMouseEnter(MyGeometry, MouseEvent)
  if UIUtils.IsGamepadInput() then
    self.bMouseEntering = true
    if self.bRecycle then
      if self.CustomOnMouseEnter then
        self:CustomOnMouseEnter(MyGeometry, MouseEvent)
      end
    else
      FireHoverWithDebounce(self, function()
        if self.CustomOnMouseEnter then
          self:CustomOnMouseEnter(MyGeometry, MouseEvent)
        end
      end, 3)
    end
  elseif self.CustomOnMouseEnter then
    self:CustomOnMouseEnter(MyGeometry, MouseEvent)
  end
  if InventoryController.bDraging and self.CustomOnDragEnter then
    self:CustomOnDragEnter(MyGeometry, MouseEvent)
  end
end

function Component:OnMouseLeave(MouseEvent)
  if UIUtils.IsGamepadInput() then
    self.bMouseEntering = false
    self._leaveToken = (self._leaveToken or 0) + 1
    local token = self._leaveToken
    if self.bRecycle then
      if self.CustomOnMouseLeave then
        self:CustomOnMouseLeave(MouseEvent)
      end
    else
      self:AddDelayFrameFunc(function()
        if not self.bMouseEntering and self._leaveToken == token and self.CustomOnMouseLeave and self._hoverTriggered then
          self._hoverTriggered = false
          self:CustomOnMouseLeave(MouseEvent)
        end
      end, 3)
    end
  elseif self.CustomOnMouseLeave then
    self:CustomOnMouseLeave(MouseEvent)
  end
  if InventoryController.bDraging and self.CustomOnDragLeave then
    self:CustomOnDragLeave(MouseEvent)
  end
end

function Component:OnMouseMove(MyGeometry, MouseEvent)
  local IsHandled = false
  if self.CustomOnMouseMove then
    IsHandled = self:CustomOnMouseMove(MyGeometry, MouseEvent)
  end
  if InventoryController.bDraging and self.CustomOnDragOver then
    self:CustomOnDragOver(MyGeometry, MouseEvent)
    IsHandled = true
  end
  if InventoryController.bDetectDrag then
    local MovePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    local StartPos = InventoryController.StartDetectDragPos
    if MovePos and StartPos then
      if InventoryController.bDetectDragIsMouse then
        local dx = MovePos.X - StartPos.X
        local dy = MovePos.Y - StartPos.Y
        local threshold = InventoryCommonConst.DragDetectedThreshold
        if dx * dx + dy * dy >= threshold * threshold then
          InventoryController.bDetectDrag = false
          InventoryController.StartDetectDragGrid:CustomOnDragDetected()
        end
      elseif MovePos.X ~= StartPos.X or MovePos.Y ~= StartPos.Y then
        InventoryController.bDetectDrag = false
      end
    else
      InventoryController.bDetectDrag = false
    end
  end
  return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

function Component:OnTouchStarted(MyGeometry, TouchEvent)
  if InventoryController.MainWidget and InventoryController.MainWidget.OnTouchStarted then
    InventoryController.MainWidget:OnTouchStarted(MyGeometry, TouchEvent)
  end
  return self:OnPreviewMouseButtonDown(MyGeometry, TouchEvent)
end

function Component:OnTouchEnded(MyGeometry, TouchEvent)
  if InventoryController.MainWidget and InventoryController.MainWidget.OnTouchEnded then
    InventoryController.MainWidget:OnTouchEnded(MyGeometry, TouchEvent, true)
  end
  return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function Component:OnTouchMoved(MyGeometry, TouchEvent)
  if InventoryController.MainWidget and InventoryController.MainWidget.OnTouchMoved then
    InventoryController.MainWidget:OnTouchMoved(MyGeometry, TouchEvent)
  end
  return self:OnMouseMove(MyGeometry, TouchEvent)
end

return Component
