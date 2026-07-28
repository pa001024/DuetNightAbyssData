require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local GAMEPAD_SLIDER_KEY = UIConst.GamePadImgKey.LeftThumb
local GAMEPAD_SLIDER_THUMB_KEY = "LH"
local GAMEPAD_LEFT_KEYS = {
  [UIConst.GamePadKey.DPadLeft] = true,
  [UIConst.GamePadKey.LeftStickLeft] = true
}
local GAMEPAD_RIGHT_KEYS = {
  [UIConst.GamePadKey.DPadRight] = true,
  [UIConst.GamePadKey.LeftStickRight] = true
}
local GAMEPAD_UP_KEYS = {
  [UIConst.GamePadKey.DPadUp] = true,
  [UIConst.GamePadKey.LeftStickUp] = true
}
local GAMEPAD_DOWN_KEYS = {
  [UIConst.GamePadKey.DPadDown] = true,
  [UIConst.GamePadKey.LeftStickDown] = true
}
local GAMEPAD_SLIDER_STEP = 0.02
local GAMEPAD_ANALOG_STEP = 0.02
local GAMEPAD_ANALOG_DEAD_ZONE = 0.35

function M:Construct()
  self.OwnerWidget = nil
  self.AxisName = nil
  self.IsBindingFinished = false
  self.IsFocusBindingFinished = false
  self.IsSyncingSliderValue = false
  self.IsGamepadFocused = false
  self.GamepadKeyInited = false
  self.CurInputDeviceType = nil
  self.CurGamepadName = nil
end

function M:Destruct()
  self.OwnerWidget = nil
  self.AxisName = nil
  self.IsBindingFinished = false
  self.IsFocusBindingFinished = false
  self.IsSyncingSliderValue = false
  self.IsGamepadFocused = false
  self.GamepadKeyInited = false
  self.CurInputDeviceType = nil
  self.CurGamepadName = nil
end

function M:InitSliderItem(OwnerWidget, AxisName)
  self.OwnerWidget = OwnerWidget
  self.AxisName = AxisName
  self:BindSliderEvents()
  self:BindFocusEvents()
end

function M:RefreshInputStyle(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  self:_InitGamepadControllerKey()
  self:_RefreshSliderBranchStyle()
  self:_RefreshGamepadControllerVisibility()
  self:_UpdateControllerThumbImage()
  self:_RefreshGamepadVisualState()
end

function M:RefreshSliderPresentation(SliderConfig, CurrentValue)
  local SliderValue = self:_ConvertBusinessValueToSliderValue(SliderConfig, CurrentValue)
  self.Text_SliderTitle:SetText(SliderConfig.Title)
  self.Text_Num:SetText(tostring(math.floor((CurrentValue or 0) + 0.5)))
  self:SetSliderValue(SliderValue)
end

function M:SetSliderValue(SliderValue)
  local NormalizedValue = math.max(0, math.min(1, SliderValue or 0))
  self.IsSyncingSliderValue = true
  self.Slider:SetValue(NormalizedValue)
  self.Slider_Controller:SetValue(NormalizedValue)
  self.ProgressBar_Slider:SetPercent(NormalizedValue)
  self.IsSyncingSliderValue = false
end

function M:AdjustSliderByOffset(Offset)
  local CurrentValue = self.Slider_Controller:GetValue()
  local TargetValue = math.max(0, math.min(1, CurrentValue + (Offset or 0)))
  if math.abs(TargetValue - CurrentValue) <= 1.0E-4 then
    return false
  end
  self:ApplySliderValueFromGamepad(TargetValue)
  return true
end

function M:HandleSliderCaptureBegin()
  if self.OwnerWidget then
    self.OwnerWidget:OnBeginTransformSliderDrag(self.AxisName)
  end
end

function M:HandleSliderCaptureEnd()
  SPrint("HandleSliderCaptureEnd")
  if self.OwnerWidget then
    self.OwnerWidget:OnEndTransformSliderDrag(self.AxisName)
  end
end

function M:HandleSliderValueChanged(SliderValue)
  if self.IsSyncingSliderValue then
    return
  end
  self:SetSliderValue(SliderValue)
  AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
  if self.OwnerWidget then
    self.OwnerWidget:OnTransformSliderValueChanged(self.AxisName, SliderValue)
  end
end

function M:HandleControllerFocusAdded()
  if self.OwnerWidget and self.OwnerWidget._HandleSliderFocused then
    self.OwnerWidget:_HandleSliderFocused(self.AxisName)
  end
end

function M:HandleControllerFocusRemoved()
  if self.OwnerWidget and self.OwnerWidget._HandleSliderFocusLost then
    self.OwnerWidget:_HandleSliderFocusLost(self.AxisName)
  end
end

function M:ApplySliderValueFromGamepad(SliderValue)
  self:SetSliderValue(SliderValue)
  AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
  if self.OwnerWidget then
    self.OwnerWidget:OnTransformSliderValueChanged(self.AxisName, SliderValue)
  end
end

function M:HandleLeftStickXInput(AnalogValue)
  local AxisValue = AnalogValue or 0
  if math.abs(AxisValue) <= GAMEPAD_ANALOG_DEAD_ZONE then
    return false
  end
  return self:AdjustSliderByOffset(AxisValue * GAMEPAD_ANALOG_STEP)
end

function M:BindSliderEvents()
  if self.IsBindingFinished then
    return
  end
  self:_BindSingleSliderEvents(self.Slider)
  self:_BindSingleSliderEvents(self.Slider_Controller)
  self.IsBindingFinished = true
end

function M:BindFocusEvents()
  if self.IsFocusBindingFinished then
    return
  end
  self.IsFocusBindingFinished = true
end

function M:OnAddedToFocusPath(InFocusEvent)
  self:SetGamepadFocused(true)
  self:HandleControllerFocusAdded()
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self:SetGamepadFocused(false)
  self:HandleControllerFocusRemoved()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusLost(InFocusEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if GAMEPAD_UP_KEYS[InKeyName] or GAMEPAD_DOWN_KEYS[InKeyName] then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if GAMEPAD_LEFT_KEYS[InKeyName] then
    if self:_AdjustSliderByGamepadStep(-GAMEPAD_SLIDER_STEP) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if GAMEPAD_RIGHT_KEYS[InKeyName] then
    if self:_AdjustSliderByGamepadStep(GAMEPAD_SLIDER_STEP) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:_BindSingleSliderEvents(Slider)
  Slider.OnMouseCaptureBegin:Clear()
  Slider.OnMouseCaptureEnd:Clear()
  Slider.OnControllerCaptureBegin:Clear()
  Slider.OnControllerCaptureEnd:Clear()
  Slider.OnValueChanged:Clear()
  Slider.OnMouseCaptureBegin:Add(self, self.HandleSliderCaptureBegin)
  Slider.OnMouseCaptureEnd:Add(self, self.HandleSliderCaptureEnd)
  Slider.OnControllerCaptureBegin:Add(self, self.HandleSliderCaptureBegin)
  Slider.OnControllerCaptureEnd:Add(self, self.HandleSliderCaptureEnd)
  Slider.OnValueChanged:Add(self, self.HandleSliderValueChanged)
end

function M:_ConvertBusinessValueToSliderValue(SliderConfig, BusinessValue)
  local MinValue = SliderConfig.Min or 0
  local MaxValue = SliderConfig.Max or 1
  if MaxValue == MinValue then
    return 0
  end
  return math.max(0, math.min(1, ((BusinessValue or 0) - MinValue) / (MaxValue - MinValue)))
end

function M:_InitGamepadControllerKey()
  if self.GamepadKeyInited or not self.Controller then
    return
  end
  self.Controller:CreateGamepadKey(GAMEPAD_SLIDER_KEY)
  self.GamepadKeyInited = true
end

function M:_RefreshGamepadControllerVisibility()
  if not self.Controller then
    return
  end
  local Visibility = self.CurInputDeviceType == ECommonInputType.Gamepad and self.IsGamepadFocused and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  self.Controller:SetVisibility(Visibility)
end

function M:_UpdateControllerThumbImage()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  local ResourceIconPath = UIUtils.UtilsGetKeyIconPathInGamepad(GAMEPAD_SLIDER_THUMB_KEY, self.CurGamepadName)
  local Img = LoadObject(ResourceIconPath)
  if not IsValid(Img) then
    return
  end
  self.Slider_Controller.WidgetStyle.NormalThumbImage.ResourceObject = Img
  self.Slider_Controller.WidgetStyle.DisabledThumbImage.ResourceObject = Img
  self.Slider_Controller.WidgetStyle.HoveredThumbImage.ResourceObject = Img
end

function M:SetGamepadFocused(IsFocused)
  self.IsGamepadFocused = true == IsFocused
  self:_RefreshSliderBranchStyle()
  self:_RefreshGamepadControllerVisibility()
  self:_RefreshGamepadVisualState()
end

function M:_RefreshSliderBranchStyle()
  if not self.WS_Slider then
    return
  end
  local bUseGamepadBranch = self.CurInputDeviceType == ECommonInputType.Gamepad and self.IsGamepadFocused
  self.WS_Slider:SetActiveWidgetIndex(bUseGamepadBranch and 1 or 0)
end

function M:_RefreshGamepadVisualState()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    if self.GamePad_Select then
      self:StopAnimation(self.GamePad_Select)
    end
    if self.GamePad_Normal then
      self:PlayAnimation(self.GamePad_Normal)
    end
    return
  end
  if self.IsGamepadFocused then
    if self.GamePad_Normal then
      self:StopAnimation(self.GamePad_Normal)
    end
    if self.GamePad_Select then
      self:PlayAnimation(self.GamePad_Select)
    end
    return
  end
  if self.GamePad_Select then
    self:StopAnimation(self.GamePad_Select)
  end
  if self.GamePad_Normal then
    self:PlayAnimation(self.GamePad_Normal)
  end
end

function M:_AdjustSliderByGamepadStep(Offset)
  if not self.OwnerWidget then
    return false
  end
  self.OwnerWidget:OnBeginTransformSliderDrag(self.AxisName)
  local bChanged = self:AdjustSliderByOffset(Offset)
  self.OwnerWidget:OnEndTransformSliderDrag(self.AxisName)
  return bChanged
end

return M
