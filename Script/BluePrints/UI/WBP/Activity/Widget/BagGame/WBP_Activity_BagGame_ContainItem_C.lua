require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
M.GRID_ROWS = 8
M.GRID_COLS = 10
M.VALUE_UNCLICKABLE = 0
M.VALUE_SINGLE_REWARD = 1
M.VALUE_DOUBLE_REWARD = 2
M.VALUE_BLOCKED = -1

function M:Construct()
  self.Row = 0
  self.Col = 0
  self.Value = 0
  self:PlayAnimation(self.Normal)
end

function M:Destruct()
end

function M:Init(Row, Col, Value)
  self.Row = Row or 0
  self.Col = Col or 0
  self.Value = Value or 0
  self:UpdateDisplay()
end

function M:SetValue(Value)
  self.Value = Value
  self:UpdateDisplay()
end

function M:GetValue()
  return self.Value
end

function M:GetPosition()
  return self.Row, self.Col
end

function M:IsEmpty()
  return self.Value == M.VALUE_EMPTY
end

function M:IsAvailable()
  return self.Value ~= M.VALUE_BLOCKED
end

function M:UpdateDisplay()
  if self.Value == M.VALUE_UNCLICKABLE then
    self.Switch_Type:SetActiveWidgetIndex(0)
  elseif self.Value == M.VALUE_SINGLE_REWARD then
    self.Switch_Type:SetActiveWidgetIndex(1)
  elseif self.Value == M.VALUE_DOUBLE_REWARD then
    self.Switch_Type:SetActiveWidgetIndex(2)
  end
end

function M:OnDragEnter(MyGeometry, PointerEvent, Operation)
  if Operation.Tag == "BagGameDisPlayItem" then
    local DragUI = Operation.DefaultDragVisual
    if self.PlayScreen and self.PlayScreen.ActivateShapeArea then
      self.PlayScreen:ActivateShapeArea(self.Row, self.Col, DragUI)
    end
    self:UpdateDragUI(DragUI)
  end
end

function M:UpdateDragUI(DragUI)
  DragUI:PlayAnimation(DragUI.Btn_In)
end

function M:OnDragLeave(PointerEvent, Operation)
  if Operation.Tag == "BagGameDisPlayItem" and self.PlayScreen and self.PlayScreen.DeactivateShapeArea then
    self.PlayScreen:DeactivateShapeArea()
  end
end

function M:OnDragCancelled(MyGeometry, PointerEvent, Operation)
  if self.PlayScreen and self.PlayScreen.DeactivateShapeArea then
    self.PlayScreen:DeactivateShapeArea()
  end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return
  end
  if self.PlayScreen and self.PlayScreen.PlaceItemAtCell then
    local DragUI = Operation.DefaultDragVisual
    local bSuccess = self.PlayScreen:PlaceItemAtCell(self.Row, self.Col, DragUI, Operation)
    if bSuccess and self.PlayScreen.DeactivateShapeArea then
      self.PlayScreen:DeactivateShapeArea()
    end
  end
  if self.OnDropCallback then
    self.OnDropCallback(self, PointerEvent, Operation)
  end
  return true
end

function M:ActivateHighlight(bCanPlace)
  self.bIsHighlighted = true
  if self.Value ~= M.VALUE_UNCLICKABLE then
    self:PlayAnimation(self.Able)
  else
    self:PlayAnimation(self.Disable)
  end
end

function M:DeactivateHighlight()
  self.bIsHighlighted = false
  self:PlayAnimation(self.Normal)
end

function M:IsHighlighted()
  return self.bIsHighlighted == true
end

function M:SetPlayScreen(PlayScreen)
  self.PlayScreen = PlayScreen
end

return M
