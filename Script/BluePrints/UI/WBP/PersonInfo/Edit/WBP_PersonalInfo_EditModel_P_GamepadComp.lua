local Component = {}
local ANALOG_DEAD_ZONE = 0.35
local LEFT_STICK_X_KEY_NAME = "Gamepad_LeftX"

local function IsGamepadInput(Owner)
  return Owner.CurInputDeviceType == ECommonInputType.Gamepad
end

function Component:Construct()
  self.GamepadAdjustingAxisName = nil
end

function Component:RefreshView()
  if not IsGamepadInput(self) then
    self:EndCurrentSliderAdjust()
  end
end

function Component:FocusGamepadDefaultPanelItem()
  local SliderItem = self:_GetSliderWidget("FrontBack")
  if SliderItem and SliderItem.SetFocus then
    SliderItem:SetFocus()
    return true
  end
  return false
end

function Component:Handle_EditModelGamepadAnalog(InKeyName, AnalogValue)
  if not IsGamepadInput(self) then
    return false
  end
  if InKeyName ~= LEFT_STICK_X_KEY_NAME then
    return false
  end
  local FocusedSliderItem = self:_GetFocusedSliderItem()
  if not FocusedSliderItem or not FocusedSliderItem.HandleLeftStickXInput then
    self:EndCurrentSliderAdjust()
    return false
  end
  local AxisValue = AnalogValue or 0
  if math.abs(AxisValue) <= ANALOG_DEAD_ZONE then
    self:EndCurrentSliderAdjust()
    return false
  end
  self:BeginSliderAdjustIfNeeded(FocusedSliderItem.AxisName)
  return FocusedSliderItem:HandleLeftStickXInput(AxisValue)
end

function Component:BeginSliderAdjustIfNeeded(AxisName)
  if not AxisName then
    return
  end
  if self.GamepadAdjustingAxisName == AxisName then
    return
  end
  self:EndCurrentSliderAdjust()
  self.GamepadAdjustingAxisName = AxisName
  self:OnBeginTransformSliderDrag(AxisName)
end

function Component:EndCurrentSliderAdjust()
  if not self.GamepadAdjustingAxisName then
    return
  end
  self:OnEndTransformSliderDrag(self.GamepadAdjustingAxisName)
  self.GamepadAdjustingAxisName = nil
end

function Component:_GetFocusedSliderItem()
  local SliderItems = {
    self:_GetSliderWidget("FrontBack"),
    self:_GetSliderWidget("LeftRight"),
    self:_GetSliderWidget("Horizontal")
  }
  for _, SliderItem in ipairs(SliderItems) do
    if SliderItem and SliderItem.HasAnyUserFocus and SliderItem:HasAnyUserFocus() then
      return SliderItem
    end
  end
  return nil
end

return Component
