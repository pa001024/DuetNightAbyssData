require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnSlotPropObjectSet(Content)
  self.IsDrop = true
  self.Content = Content
  Content.SelfWidget = self
  self.WidgetMap = self.WidgetMap or {}
  self.ParentWidget = Content.ParentWidget
  self.EnableDrag = true
  self.bEnableDragAndDrop = true
  self.bEnableDrag = true
  self.bEnablePointerDetection = true
  self.bIsFocusable = true
  self.bIsInteractive = true
  self.SlotIndex = Content.SlotIndex
  self.Btn_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Icon_Gesture:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:OnSlotPropObjectUpdate(Content)
  self.AnimationTime = self.Click:GetEndTime()
end

function M:OnBtnClicked()
  if self._QuickSlotClicked then
    self._QuickSlotClicked(self.ParentWidget, self.SlotIndex)
  end
  if self.Content.Id then
    AudioManager(self):PlayItemSound(self, self.Content.Id, "Click", CommonConst.DataType.Resource)
  else
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
  end
end

function M:QuickSlotClicked(SlotIndex)
  if SlotIndex == self.SlotIndex then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:InitData(Content)
  self.bHovered = false
  self.bPressed = false
  self.bEnableDrag = Content.bEnableDrag
  self.UnitId = Content.UnitId
  self.DragPivot = Content.DragPivot
  self.DragOffset = Content.DragOffset
  self.AudioType = Content.AudioType or self.ItemType
  self._OnUnLoadUI = Content.OnUnLoadUI
  self._OnDragCancelled = Content.OnDragCancelled
  self._OnDragEnter = Content.OnDragEnter
  self._OnDragLeave = Content.OnDragLeave
  self._CreateDragWidget = Content.CreateDragWidget
  self._QuickSlotClicked = Content.QuickSlotClicked
  self._OnMouseButtonDownEarly = Content.OnMouseButtonDownEarly
  self.bAllUseAsyncLoadWidget = false
end

function M:OnSlotPropObjectUpdate(Content)
  if Content.Icon then
    local IconTexture = LoadObject(Content.Icon)
    self.WS_State:SetActiveWidgetIndex(0)
    self.Icon_Gesture:SetBrushFromTexture(IconTexture)
    self.Content = Content
    self.Content.SlotIndex = self.SlotIndex
  else
    self.WS_State:SetActiveWidgetIndex(1)
  end
  self:InitData(Content)
end

function M:OnDragDetected()
  self:OnPressedChanged(false)
  if not self.bEnableDrag and not self._OnDragLeave then
    return
  end
  local DragDropOperation = NewObject(UIUtils.GetCommonDragDropOperationClass())
  DragDropOperation.Payload = self.Content
  if self.Content.Id and not DragDropOperation.Payload then
    self.ParentWidget:UpdateQuickSlotItem()
  end
  if self._CreateDragWidget then
    DragDropOperation.DefaultDragVisual = self._CreateDragWidget(self.ParentWidget, self.Content)
  end
  if not (DragDropOperation.DefaultDragVisual and DragDropOperation.Payload) or not DragDropOperation.Payload.Id then
    return nil
  end
  DragDropOperation.Tag = "WBP_GestureBtn_C"
  DragDropOperation.Pivot = self.DragPivot or UE4.EDragPivot.CenterCenter
  DragDropOperation.Offset = self.DragOffset or DragDropOperation.Offset
  return DragDropOperation
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self:PlayAnimation(self.Hover)
  if not self.bEnableDrag then
    return
  end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Unhover)
  if not self.bEnableDrag then
    return
  end
end

function M:OnMouseMove(MyGeometry, InKeyEvent)
  if self.bEnableDrag and self:HasMouseCapture() then
    return UE4.UWidgetBlueprintLibrary.DetectDrag(UWidgetBlueprintLibrary.ReleaseMouseCapture(UWidgetBlueprintLibrary.Unhandled()), self, UE4.EKeys.LeftMouseButton)
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnMouseMove(MyGeometry, InTouchEvent)
end

function M:OnPressedChanged(bPressed)
  self.bPressed = bPressed
  if self.Content.IsSelect then
    return
  end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  if not self.IsDrop then
    return
  end
  local DragContent = Operation.Payload
  if not DragContent then
    return
  end
  if Operation.Tag == "WBP_Com_Item_Universal_L_C" then
    self.ParentWidget:UpdateQucikSlotItem(DragContent, self.SlotIndex, false)
    return true
  elseif Operation.Tag == "WBP_GestureBtn_C" and self.SlotIndex ~= nil and -1 ~= self.SlotIndex and -1 ~= DragContent.SlotIndex then
    local SrcSlotIndex = self.SlotIndex
    local DragSlotIndex = DragContent.SlotIndex
    self.ParentWidget:UpdateQucikSlotItem(DragContent, SrcSlotIndex, true)
    return true
  end
end

function M:OnMouseButtonDown(MyGeometry, InKeyEvent)
  if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(InKeyEvent, EKeys.RightMouseButton) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.MouseDownPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InKeyEvent)
  self:OnPressedChanged(true)
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(), self)
end

function M:OnMouseButtonUp(MyGeometry, InKeyEvent)
  self.MouseDownPos = nil
  self:OnPressedChanged(false)
  if self.ParentWidget.CurInputDeviceType == ECommonInputType.Gamepad then
    self.ParentWidget:OnBtnGamePadClick()
  end
  self:OnBtnClicked()
  if self:HasMouseCapture() then
    return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled(), self)
  end
end

function M:OnMouseCaptureLost()
  self:OnPressedChanged(false)
end

function M:OnDragEnter(MyGeometry, PointerEvent, Operation)
  if not self.bEnableDrag then
    return
  end
  if self._OnDragEnter then
    self._OnDragEnter(self.ParentWidget, self.Content)
  end
  if Operation.DefaultDragVisual then
    self:OnDragEnter_Lua(Operation.DefaultDragVisual)
  end
  local DragContent = Operation.Payload
  if DragContent and DragContent.Id ~= self.Content.Id then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnDragEnter_Lua(CreateDragUI)
  CreateDragUI.IsDraging = true
end

function M:OnDragLeave(PointerEvent, Operation)
  if not self.bEnableDrag then
    return
  end
  if self._OnDragLeave then
    self._OnDragLeave(self.ParentWidget, self.Content, PointerEvent, Operation.DefaultDragVisual)
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Unhover)
end

function M:OnDragCancelled(PointerEvent, Operation)
  if self._OnDragCancelled then
    self._OnDragCancelled(self.ParentWidget, self.Content, Operation, PointerEvent)
  end
  if Operation.DefaultDragVisual then
    self:OnDragCancel_Lua(Operation.DefaultDragVisual)
  end
end

function M:OnDragCancel_Lua(CreateDragUI)
  if not CreateDragUI.Content or CreateDragUI.IsCancel then
    return
  end
  CreateDragUI.IsDraging = false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.ParentWidget.CurInputDeviceType == ECommonInputType.Gamepad then
    self:OnBtnClicked()
  end
  return self.CaptureMouse
end

return M
