require("UnLua")
local M = Class("BluePrints.UI.WBP.Investigation.WBP_Investigation_Observation_C")

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
end

function M:OnHideClicked()
  self:TogglePanelHidden()
end

function M:UpdateKeyState(State)
  if "Dialog" == State then
    self.Key_Hide:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Exit:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Skip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Key_Hide:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Exit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Skip:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnTouchStarted(_, TouchEvent)
  self:BeginRotate()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchMoved(_, TouchEvent)
  if not self.bRotating then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local ScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(TouchEvent)
  if not self.LastMousePos then
    self.LastMousePos = ScreenPos
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local DX = ScreenPos.X - self.LastMousePos.X
  local DY = ScreenPos.Y - self.LastMousePos.Y
  self.LastMousePos = ScreenPos
  self:ProcessRotateInput(DX, DY)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(_, TouchEvent)
  self:EndRotate()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
