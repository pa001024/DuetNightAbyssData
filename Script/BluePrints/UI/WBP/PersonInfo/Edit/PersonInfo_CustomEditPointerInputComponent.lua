require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = {}
local MOBILE_PINCH_SCROLL_SCALE = 0.02
local MOBILE_TOUCH_ORBIT_SCALE_X = 1
local MOBILE_TOUCH_ORBIT_SCALE_Y = 1

function M:OnMouseWheelScroll(_MyGeometry, _MouseEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPointerDown(_MyGeometry, _PointerEvent)
  self.IsDragging = true
  self.MovedWhileDragging = false
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPointerUp(_MyGeometry, _PointerEvent)
  self.MovedWhileDragging = false
  self.IsDragging = false
  if self:HasMouseCapture() then
    return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.UnHandled())
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPointerMove(_MyGeometry, PointerEvent)
  if not self.IsDragging then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(PointerEvent)
  if CursorDelta and (0 ~= (CursorDelta.X or 0) or 0 ~= (CursorDelta.Y or 0)) then
    self.MovedWhileDragging = true
    if not self:HasMouseCapture() then
      return UE4.UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(), self)
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPointerCaptureLost()
  self.IsDragging = false
  self.MovedWhileDragging = false
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  if not UIUtils.IsMobileInput() then
    return self:OnPointerDown(MyGeometry, InTouchEvent)
  end
  if self.ActorController and self.ActorController.BeginPointerSelection then
    self.ActorController:BeginPointerSelection(MyGeometry, InTouchEvent)
  end
  self:_RecordMobileTouchPoint(InTouchEvent, true)
  return self:OnPointerDown(MyGeometry, InTouchEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  local bShouldCommitPointerSelection = false
  if UIUtils.IsMobileInput() then
    bShouldCommitPointerSelection = self.IsDragging and not self.MovedWhileDragging and self:_GetMobileTouchPointCount() <= 1
    self:_RemoveMobileTouchPoint(InTouchEvent)
  end
  local Reply = self:OnPointerUp(MyGeometry, InTouchEvent)
  if not UIUtils.IsMobileInput() then
    return Reply
  end
  if bShouldCommitPointerSelection then
    if self.TrySelectPreviewEntityByPointer then
      self:TrySelectPreviewEntityByPointer()
    end
  elseif self.ActorController and self.ActorController.ClearPendingPointerSelection then
    self.ActorController:ClearPendingPointerSelection()
  end
  return Reply
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  if UIUtils.IsMobileInput() and self:_HandleMobileTouchCameraGesture(InTouchEvent) then
    self.MovedWhileDragging = true
    if not self:HasMouseCapture() then
      return UE4.UWidgetBlueprintLibrary.CaptureMouse(UE4.UWidgetBlueprintLibrary.Handled(), self)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:_GetMobileTouchPointId(PointerEvent)
  if not PointerEvent then
    return nil
  end
  if UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex then
    return UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(PointerEvent)
  end
  return nil
end

function M:_GetMobileTouchScreenPosition(PointerEvent)
  local ScreenPosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
  return {
    X = ScreenPosition.X or 0,
    Y = ScreenPosition.Y or 0
  }
end

function M:_RecordMobileTouchPoint(PointerEvent, bResetPrevious)
  local PointerId = self:_GetMobileTouchPointId(PointerEvent)
  if nil == PointerId then
    return nil
  end
  self.MobileTouchState = self.MobileTouchState or {}
  local Position = self:_GetMobileTouchScreenPosition(PointerEvent)
  local PointState = self.MobileTouchState[PointerId] or {}
  if bResetPrevious or not PointState.Position then
    PointState.PreviousPosition = Position
  else
    PointState.PreviousPosition = PointState.Position
  end
  PointState.Position = Position
  self.MobileTouchState[PointerId] = PointState
  return PointState
end

function M:_RemoveMobileTouchPoint(PointerEvent)
  local PointerId = self:_GetMobileTouchPointId(PointerEvent)
  if nil == PointerId then
    return
  end
  self.MobileTouchState = self.MobileTouchState or {}
  self.MobileTouchState[PointerId] = nil
  if self:_GetMobileTouchPointCount() <= 0 and self.ActorController then
    self.ActorController:CommitCameraPreviewTransaction()
  end
end

function M:_GetMobileTouchPointCount()
  local Count = 0
  for _, _ in pairs(self.MobileTouchState or {}) do
    Count = Count + 1
  end
  return Count
end

function M:_GetSortedMobileTouchPoints()
  local Points = {}
  for PointerId, PointData in pairs(self.MobileTouchState or {}) do
    Points[#Points + 1] = {
      PointerId = PointerId,
      Position = PointData.Position,
      PreviousPosition = PointData.PreviousPosition
    }
  end
  table.sort(Points, function(A, B)
    return (A.PointerId or 0) < (B.PointerId or 0)
  end)
  return Points
end

function M:_HandleMobileTouchCameraGesture(PointerEvent)
  if not self:IsPreviewCameraRoamEnabled() or not self.ActorController then
    return false
  end
  local PointState = self:_RecordMobileTouchPoint(PointerEvent, false)
  if not PointState then
    return false
  end
  self.ActorController:BeginCameraPreviewTransaction()
  local TouchPoints = self:_GetSortedMobileTouchPoints()
  if #TouchPoints >= 2 then
    return self:_HandleMobilePinchGesture(TouchPoints)
  end
  local Position = PointState.Position
  local DeltaX = (Position.X or 0) - (PointState.PreviousPosition.X or 0)
  local DeltaY = (Position.Y or 0) - (PointState.PreviousPosition.Y or 0)
  if 0 == DeltaX and 0 == DeltaY then
    return false
  end
  local bHandled = self.ActorController:OrbitCameraByCursorDelta({
    X = DeltaX * MOBILE_TOUCH_ORBIT_SCALE_X,
    Y = DeltaY * MOBILE_TOUCH_ORBIT_SCALE_Y
  })
  if bHandled and self._RefreshMobileResetCameraButtonState then
    self:_RefreshMobileResetCameraButtonState()
  end
  return true == bHandled
end

function M:_HandleMobilePinchGesture(TouchPoints)
  local FirstPoint = TouchPoints[1]
  local SecondPoint = TouchPoints[2]
  if not FirstPoint or not SecondPoint then
    return false
  end
  local CurrentDeltaX = (FirstPoint.Position.X or 0) - (SecondPoint.Position.X or 0)
  local CurrentDeltaY = (FirstPoint.Position.Y or 0) - (SecondPoint.Position.Y or 0)
  local PreviousDeltaX = (FirstPoint.PreviousPosition.X or 0) - (SecondPoint.PreviousPosition.X or 0)
  local PreviousDeltaY = (FirstPoint.PreviousPosition.Y or 0) - (SecondPoint.PreviousPosition.Y or 0)
  local CurrentDistance = math.sqrt(CurrentDeltaX * CurrentDeltaX + CurrentDeltaY * CurrentDeltaY)
  local PreviousDistance = math.sqrt(PreviousDeltaX * PreviousDeltaX + PreviousDeltaY * PreviousDeltaY)
  local DeltaDistance = CurrentDistance - PreviousDistance
  if 0 == DeltaDistance then
    return false
  end
  local bHandled = self.ActorController:OnScrolling(DeltaDistance * MOBILE_PINCH_SCROLL_SCALE)
  if bHandled and self._RefreshMobileResetCameraButtonState then
    self:_RefreshMobileResetCameraButtonState()
  end
  return true == bHandled
end

return M
