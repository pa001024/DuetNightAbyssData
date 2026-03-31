local Component = {}

function Component:CreateDragUI(DisPlayItemId, ShapeOffsets, SyncData)
  local DragUI = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
  DragUI:InitAsDragUI(DisPlayItemId, ShapeOffsets, SyncData)
  return DragUI
end

function Component:InitAsDragUI(DisPlayItemId, ShapeOffsets, SyncData)
  self.LinkWidgets = {}
  self.ActiveLinkWidgets = {}
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.DisPlayItemId = DisPlayItemId
  self.TemplateId = SyncData and SyncData.TemplateId or DisPlayItemId
  self.DragSyncData = SyncData
  if self.SetShape and ShapeOffsets then
    self:SetShape(ShapeOffsets)
  end
  if self.ApplyDragSyncData and SyncData then
    self:ApplyDragSyncData(SyncData)
  end
  self:PlayAnimation(self.Size_In)
end

function Component:SetCallbacks(Callbacks)
  self.OnDragCancelCallback = Callbacks.OnDragCancelCallback
  self.OnDropCallback = Callbacks.OnDropCallback
  self.OnDragEnterCallback = Callbacks.OnDragEnterCallback
  self.OnDragLeaveCallback = Callbacks.OnDragLeaveCallback
  self.OnDragDetectedCallback = Callbacks.OnDragDetectedCallback
  self.OnRemovedFromFocusPathCallback = Callbacks.OnRemovedFromFocusPathCallback
end

function Component:OnDragDetectedComponent(MyGeometry, PointerEvent, DisPlayItemId, ShapeOffsets)
  local DragDropOperation = NewObject(UIUtils.GetCommonDragDropOperationClass())
  local SyncData
  if self.GetDragSyncData then
    SyncData = self:GetDragSyncData()
  end
  local DragUI = self:CreateDragUI(DisPlayItemId, ShapeOffsets, SyncData)
  if DragUI and DragUI.SetItemSize then
    DragUI:SetItemSize()
  end
  DragDropOperation.DefaultDragVisual = DragUI
  DragDropOperation.Pivot = UE.EDragPivot.CenterCenter
  DragDropOperation.InSlotUIData = self.SlotUIData
  DragDropOperation.Tag = "BagGameDisPlayItem"
  DragDropOperation.SourceDisPlayItem = self
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
end

function Component:OnDrop(MyGeometry, PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return
  end
  if self.bIsConfirmed and self.PlayScreen and self.PlayScreen.PlaceItemAtCell then
    local DragUI = Operation.DefaultDragVisual
    if DragUI then
      local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
      local Record = BagGameModel:FindPlacedItemByWidget(self)
      if Record and Record.Cells and #Record.Cells > 0 then
        local Cell = Record.Cells[1]
        if self.PlayScreen.FinalizeDropHighlight then
          self.PlayScreen:FinalizeDropHighlight(Cell.Row, Cell.Col, DragUI)
        end
        local bSuccess = self.PlayScreen:PlaceItemAtCell(Cell.Row, Cell.Col, DragUI, Operation)
        return bSuccess
      end
    end
  end
  if self.OnDropCallback then
    self.OnDropCallback(self, PointerEvent, Operation)
  end
  return true
end

return Component
