require("UnLua")
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitData(OwnerWidget, MoveCallback)
  self.OwnerWidget = OwnerWidget
  self.MoveCallback = MoveCallback
  self.StartPosition = UE4.FVector2D(0, 0)
  self.LastPosition = UE4.FVector2D(0, 0)
end

function M:UpdateLayoutWhenMoved(StartPosition, CurPosition)
  if type(self.MoveCallback) == "function" then
    self.MoveCallback(self.OwnerWidget, StartPosition, CurPosition)
  end
end

function M:OnTouchStarted(MyGeometry, InGestureEvent)
  self.bIsDragging = true
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
  self.StartPosition = ScreenSpacePosition
  self.LastPosition = ScreenSpacePosition
  local Handled = UE4.UWidgetBlueprintLibrary.Handled()
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(Handled, self)
end

function M:OnTouchMoved(MyGeometry, InGestureEvent)
  if not self.bIsDragging then
    return UIUtils.Unhandled
  end
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InGestureEvent)
  self:UpdateLayoutWhenMoved(self.LastPosition, ScreenSpacePosition)
  self.LastPosition = ScreenSpacePosition
  DebugPrint("WBP_SettingVisualJoystick_C== Dragging OnTouchMoved to Next Pos is :  ", ScreenSpacePosition)
  return UIUtils.Handled
end

function M:OnTouchEnded(MyGeometry, MouseEvent)
  self.bIsDragging = false
  if self:HasMouseCapture() then
    local Handled = UE4.UWidgetBlueprintLibrary.Handled()
    return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(Handled)
  else
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
end

return M
