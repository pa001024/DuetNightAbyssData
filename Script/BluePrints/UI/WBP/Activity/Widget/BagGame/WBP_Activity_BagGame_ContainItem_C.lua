require("UnLua")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
M.GRID_ROWS = BagGameModel.GRID_ROWS
M.GRID_COLS = BagGameModel.GRID_COLS
M.VALUE_UNCLICKABLE = BagGameModel.VALUE_UNCLICKABLE
M.VALUE_SINGLE_REWARD = BagGameModel.VALUE_SINGLE_REWARD
M.VALUE_DOUBLE_REWARD = BagGameModel.VALUE_DOUBLE_REWARD
M.VALUE_BLOCKED = BagGameModel.VALUE_BLOCKED

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
    if self.PlayScreen and self.PlayScreen._RequestActivateShapeArea then
      self.PlayScreen:_RequestActivateShapeArea(self.Row, self.Col, DragUI)
    end
    self:UpdateDragUI(DragUI)
  end
end

function M:UpdateDragUI(DragUI)
  DragUI:PlayAnimation(DragUI.Btn_In)
end

function M:OnDragLeave(PointerEvent, Operation)
  if Operation.Tag == "BagGameDisPlayItem" and self.PlayScreen and self.PlayScreen.OnCellDragLeave then
    self.PlayScreen:OnCellDragLeave(self.Row, self.Col)
  end
end

function M:OnDragCancelled(PointerEvent, Operation)
  if self.PlayScreen then
    if self.PlayScreen.TryHandleSameFrameDragRelease and self.PlayScreen:TryHandleSameFrameDragRelease(Operation, Operation and Operation.DefaultDragVisual) then
      return
    end
    if self.PlayScreen.HandleCancelledDragReturnToList then
      self.PlayScreen:HandleCancelledDragReturnToList(Operation, Operation and Operation.DefaultDragVisual)
      return
    end
    if self.PlayScreen.ForceExitDragState then
      self.PlayScreen:ForceExitDragState()
    else
      if self.PlayScreen._CancelPendingHighlight then
        self.PlayScreen:_CancelPendingHighlight()
      end
      if self.PlayScreen.DeactivateShapeArea then
        self.PlayScreen:DeactivateShapeArea()
      end
      if self.PlayScreen.OnDragStateChanged then
        self.PlayScreen:OnDragStateChanged(false)
      end
    end
  end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  if Operation.Tag ~= "BagGameDisPlayItem" then
    return false
  end
  local bSuccess = false
  local DragUI = Operation.DefaultDragVisual
  if self.PlayScreen and self.PlayScreen.TryHandleSameFrameDragRelease and self.PlayScreen:TryHandleSameFrameDragRelease(Operation, DragUI) then
    return true
  end
  if self.PlayScreen and self.PlayScreen.FinalizeDropHighlight then
    self.PlayScreen:FinalizeDropHighlight(self.Row, self.Col, DragUI)
  elseif self.PlayScreen and self.PlayScreen._FlushPendingHighlight then
    self.PlayScreen:_FlushPendingHighlight()
  end
  if self.PlayScreen and self.PlayScreen.PlaceItemAtCell then
    bSuccess = self.PlayScreen:PlaceItemAtCell(self.Row, self.Col, DragUI, Operation)
    if bSuccess then
      AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_cell_click_replace", nil, nil)
    end
  end
  if self.OnDropCallback then
    self.OnDropCallback(self, PointerEvent, Operation)
  end
  return bSuccess
end

function M:ActivateHighlight(bCanPlace)
  self.bIsHighlighted = true
  self.bIsLoadHighlight = false
  self.bIsStackHighlight = false
  self:StopAllHighlightAnimations()
  self:StopDoubleLoopAnimation()
  if bCanPlace and self.Value ~= M.VALUE_UNCLICKABLE then
    self:PlayAnimation(self.Able)
  else
    self:PlayAnimation(self.Disable)
  end
end

function M:ActivateLoadHighlight(bCanLoad)
  self.bIsHighlighted = true
  self.bIsLoadHighlight = true
  self.bIsStackHighlight = false
  self:StopAllHighlightAnimations()
  self:StopDoubleLoopAnimation()
  if bCanLoad then
    self:PlayAnimation(self.Able)
  else
    self:PlayAnimation(self.Disable)
  end
end

function M:ActivateStackHighlight(bCanStack)
  self.bIsHighlighted = true
  self.bIsLoadHighlight = false
  self.bIsStackHighlight = true
  self:StopAllHighlightAnimations()
  self:StopDoubleLoopAnimation()
  if bCanStack then
    self:PlayAnimation(self.Able)
  else
    self:PlayAnimation(self.Disable)
  end
end

function M:StopAllHighlightAnimations()
  if self.Normal then
    self:StopAnimation(self.Normal)
  end
  if self.Able then
    self:StopAnimation(self.Able)
  end
  if self.Disable then
    self:StopAnimation(self.Disable)
  end
  if self.Put_Normal then
    self:StopAnimation(self.Put_Normal)
  end
  if self.Put_GetPoint then
    self:StopAnimation(self.Put_GetPoint)
  end
  if self.Put_Flash then
    self:StopAnimation(self.Put_Flash)
  end
  if self.Double_Loop then
    self:StopAnimation(self.Double_Loop)
  end
end

function M:StopDoubleLoopAnimation()
  if self.Double_Loop and self:IsAnimationPlaying(self.Double_Loop) then
    self:StopAnimation(self.Double_Loop)
  end
  if self.VX_Loop2 then
    self.VX_Loop2:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetDoubleLoopVisible(bVisible)
  if self.VX_Loop2 then
    if bVisible then
      self.VX_Loop2:SetVisibility(UIConst.VisibilityOp.Visible)
    else
      self.VX_Loop2:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:PlayPutNormal()
  self:StopAllHighlightAnimations()
  self:StopDoubleLoopAnimation()
  if self.Put_Normal then
    self:PlayAnimation(self.Put_Normal)
  end
end

function M:PlayPutGetPoint()
  self:StopAllHighlightAnimations()
  if self.Put_GetPoint then
    self:PlayAnimation(self.Put_GetPoint)
  end
end

function M:PlayPutFlash()
  if self.Put_Flash then
    self:PlayAnimation(self.Put_Flash)
  end
end

function M:PlayDoubleLoop()
  if self.Double_Loop then
    self:PlayAnimation(self.Double_Loop)
    if self.VX_Loop2 then
      self.VX_Loop2:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
end

function M:DeactivateHighlight()
  self.bIsHighlighted = false
  self.bIsLoadHighlight = false
  self.bIsStackHighlight = false
  self:StopAllHighlightAnimations()
  if self.Able then
    self:SetAnimationCurrentTime(self.Able, 0)
  end
  if self.Disable then
    self:SetAnimationCurrentTime(self.Disable, 0)
  end
  if self.PlayScreen and self.PlayScreen.GetConfirmedPlacedItemAtCell then
    local PlacedRecord = self.PlayScreen:GetConfirmedPlacedItemAtCell(self.Row, self.Col)
    if PlacedRecord then
      local bDouble = PlacedRecord.IsDoubleReward
      if bDouble then
        self:PlayPutGetPoint()
        self:PlayDoubleLoop()
      else
        self:StopDoubleLoopAnimation()
        self:PlayPutNormal()
      end
      return
    end
  end
  self:StopDoubleLoopAnimation()
  self:PlayAnimation(self.Normal)
end

function M:IsHighlighted()
  return self.bIsHighlighted == true
end

function M:SetPlayScreen(PlayScreen)
  self.PlayScreen = PlayScreen
end

return M
