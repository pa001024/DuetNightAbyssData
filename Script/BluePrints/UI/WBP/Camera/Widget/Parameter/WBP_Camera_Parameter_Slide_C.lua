require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Camera.Widget.Parameter.Camera_Parameter_Widget_Base"
})

function M:Init(Content)
  M.Super.Init(self, Content)
  rawset(self, "_OnValueChanged", Content.OnValueChanged)
  local Params = {}
  Params.AddBtnCallback = self.OnSliderValueChanged
  Params.MinusBtnCallback = self.OnSliderValueChanged
  Params.MaxBtnCallback = self.OnSliderValueChanged
  Params.SliderChangeCallback = self.OnSliderValueChanged
  Params.OwnerPanel = self
  Params.InitValue = Content.Default
  Params.MinValue = Content.Min
  Params.MaxValue = Content.Max
  Params.EnableMiniBtn = Content.EnableMiniBtn
  Params.EnableMaxBtn = Content.EnableMaxBtn
  Params.ClickInterval = Content.Step
  Params.bDisableAutoHandleInputDeviceChange = true
  Params.SoundResPath = {
    Slider = "event:/ui/common/slider_value_change"
  }
  self.Slider:Init(Params)
  self.Slider:UpdateUIStyleInPlatform(false)
  self:UpdateValue()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  if self.IsInFocusPath and self.IsGamePadInput then
    self.Slider:UpdateUIStyleInPlatform(true, CurGamepadName)
  else
    self.Slider:UpdateUIStyleInPlatform(false, CurGamepadName)
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  M.Super.OnAddedToFocusPath(self, InFocusEvent)
  if self.IsGamePadInput then
    self.Slider:UpdateUIStyleInPlatform(true, self.CurGamepadName)
  else
    self.Slider:UpdateUIStyleInPlatform(false, self.CurGamepadName)
  end
end

function M:OnRemovedFromFocusPath()
  M.Super.OnRemovedFromFocusPath(self)
  self.Slider:TriggerKeyUpEvent()
  self.Slider:UpdateUIStyleInPlatform(false, self.CurGamepadName)
end

function M:OnSliderValueChanged(CurrentValue)
  self:UpdateValue()
  if self._OnValueChanged then
    self._OnValueChanged(self.Owner, CurrentValue, self.Content)
  end
end

function M:SetTitle(Title)
  self.Text:SetText(Title)
end

function M:SetValue(Value)
  self.Slider:SetValue(Value)
  self.Slider:UpdateSliderAndProgress(false)
  self:UpdateValue()
end

function M:UpdateValue()
  local Value = self.Slider.CurrentCount or 0
  Value = math.floor(Value)
  if type(self.Content.Suffix) == "string" then
    self.Text_Num:SetText(string.format("%d%s", Value, self.Content.Suffix))
  else
    self.Text_Num:SetText(Value)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = self.Slider:Handle_KeyDownEventOnGamePad(InKeyName)
  if IsHandled then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = self.Slider:Handle_KeyUpEventOnGamePad(InKeyName)
  if IsHandled then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
