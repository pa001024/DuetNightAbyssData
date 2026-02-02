local Component = {}

function Component:CreateDragUI(DisPlayItemId, ShapeOffsets)
  local DragUI = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
  DragUI:InitAsDragUI(DisPlayItemId, ShapeOffsets)
  return DragUI
end

function Component:InitAsDragUI(DisPlayItemId, ShapeOffsets)
  self.LinkWidgets = {}
  self.ActiveLinkWidgets = {}
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.DisPlayItemId = DisPlayItemId
  if self.SetShape and ShapeOffsets then
    self:SetShape(ShapeOffsets)
  end
  self:PlayAnimation(self.Size_In)
end

function Component:OnDragDetectedComponent(MyGeometry, PointerEvent, DisPlayItemId, ShapeOffsets)
  local DragDropOperation = NewObject(UIUtils.GetCommonDragDropOperationClass())
  local DragUI = self:CreateDragUI(DisPlayItemId, ShapeOffsets)
  DragDropOperation.DefaultDragVisual = DragUI
  DragDropOperation.Pivot = UE.EDragPivot.CenterCenter
  DragDropOperation.InSlotUIData = self.SlotUIData
  DragDropOperation.Tag = "BagGameDisPlayItem"
  if self.OnDragDetectedCallback then
    self.OnDragDetectedCallback(self, PointerEvent, DragDropOperation)
  end
  return DragDropOperation
end

function Component:OnDragEnter(MyGeometry, PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return
  end
  if self.OnDragEnterCallback then
    self.OnDragEnterCallback(self, PointerEvent, Operation)
  end
end

function Component:OnDragLeave(PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return
  end
  if self.OnDragLeaveCallback then
    self.OnDragLeaveCallback(self, PointerEvent, Operation)
  end
end

function Component:OnDragCancelled(PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return
  end
  if self.OnDragCancelCallback then
    self.OnDragCancelCallback(self, PointerEvent, Operation)
  end
  if not Operation.InSlotUIData then
    return
  end
end

function Component:OnDrop(MyGeometry, PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return
  end
  if self.OnDropCallback then
    self.OnDropCallback(self, PointerEvent, Operation)
  end
  return true
end

return Component
