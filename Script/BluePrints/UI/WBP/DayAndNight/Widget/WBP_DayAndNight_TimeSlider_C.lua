require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function ScreenPrint()
  return DebugPrint
end

local Unhandled = UE4.UWidgetBlueprintLibrary.Handled()

function M:Construct()
  self.Slider_Time.OnValueChanged:Add(self, self.OnValueChanged)
  self.Slider_Time.OnMouseCaptureBegin:Add(self, self.OnMouseCaptureBegin)
  self.Slider_Time.OnMouseCaptureEnd:Add(self, self.OnMouseCaptureEnd)
  self.CurrentValue = 0
end

function M:BindScroolEvent(obj, callback, speed)
  self.ScroolEventObj = obj
  self.ScroolEvent = callback
  self.ScroolSpeed = speed or 1
end

function M:BindDragEvent(obj, callback, speed)
  self.DragEventObj = obj
  self.DragEvent = callback
  self.DragSpeed = speed or 1
end

function M:BindDragEndEvent(obj, callback, bIsDay)
  self.DragEndEventObj = obj
  self.DragEndEvent = callback
  self.bIsDay = bIsDay or false
end

function M:Tick(MyGeometry, InDeltaTime)
  ScreenPrint("DayAndNight_TimeSlider_C:Tick")
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent) * -1
  ScreenPrint("DayAndNight_TimeSlider_C:OnMouseWheelScroll" .. WheelDelta)
  if self.ScroolEvent then
    self.ScroolEvent(self.ScroolEventObj, WheelDelta * self.ScroolSpeed)
  end
  return Unhandled
end

function M:OnValueChanged(Value)
  if self.DragStart then
    self.CurrentValue = Value
    self.DragStart = false
  else
    self.DragEvent(self.ScroolEventObj, (Value - self.CurrentValue) * self.DragSpeed)
    self.CurrentValue = Value
  end
end

function M:OnMouseCaptureBegin()
  ScreenPrint("DayAndNight_TimeSlider_C:OnMouseCaptureBegin")
  self.DragStart = true
end

function M:OnMouseCaptureEnd()
  ScreenPrint("DayAndNight_TimeSlider_C:OnMouseCaptureEnd")
  if self.DragEndEvent then
    self.DragEndEvent(self.DragEndEventObj, self.bIsDay)
  end
end

return M
