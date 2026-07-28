require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(Config, OwnerPanel)
  self.Config = Config
  self.OwnerPanel = OwnerPanel
  self.Value = OwnerPanel and OwnerPanel:GetValue(Config) or Config.DefaultValue
  self.MinValue = Config.Min or 0
  self.MaxValue = Config.Max or 100
  self.Step = Config.Step or 1
  self.bForbiddenAnimState = nil
  Utils.SetText(self.Text, Config.Text or "")
  self:RefreshText()
  self:InitSlider()
  self:Refresh()
end

function M:InitSlider()
  if self.Slider and self.Slider.Init then
    self.Slider:Init({
      InitValue = self.Value,
      MinValue = self.MinValue,
      MaxValue = self.MaxValue,
      ClickInterval = self.Step,
      OwnerPanel = self,
      bDisableAutoHandleInputDeviceChange = true,
      bForbidPressAccelerate = true,
      SliderChangeCallback = function(_, Value)
        self:OnSliderChanged(Value)
      end,
      MinusBtnCallback = function(_, Value)
        self:OnSliderChanged(Value)
      end,
      AddBtnCallback = function(_, Value)
        self:OnSliderChanged(Value)
      end,
      MinusBtnForbidCallback = function()
        self:OnSliderOperationForbidden()
      end,
      AddBtnForbidCallback = function()
        self:OnSliderOperationForbidden()
      end
    })
  elseif self.Slider and self.Slider.SetValue then
    self.Slider:SetValue(self:NormalizeValue(self.Value))
  end
end

function M:NormalizeValue(Value)
  if self.MaxValue == self.MinValue then
    return 0
  end
  return (Value - self.MinValue) / (self.MaxValue - self.MinValue)
end

function M:ClampValue(Value)
  Value = tonumber(Value) or self.MinValue
  Value = math.floor(Value / self.Step + 0.5) * self.Step
  if Value < self.MinValue then
    Value = self.MinValue
  elseif Value > self.MaxValue then
    Value = self.MaxValue
  end
  return Value
end

function M:RefreshText()
  Utils.SetText(self.Text_Num, tostring(self.Value))
end

function M:Refresh()
  Utils.SetNew(self.New, self.OwnerPanel and self.OwnerPanel:IsNewVisible(self.Config and self.Config.NewKey))
  self:RefreshText()
  self:RefreshInteractableState()
end

function M:RefreshValue()
  if self.OwnerPanel then
    self.Value = self:ClampValue(self.OwnerPanel:GetValue(self.Config))
  end
  if self.Slider and self.Slider.ChangeSliderValueByInputNumber then
    self.Slider:ChangeSliderValueByInputNumber(self.Value, true)
  elseif self.Slider and self.Slider.SetValue then
    self.Slider:SetValue(self:NormalizeValue(self.Value))
  end
  self:RefreshText()
  self:RefreshInteractableState()
end

function M:IsRoleRotationItem()
  return self.Config and self.Config.Id == "RoleRotation"
end

function M:GetHost()
  return self.OwnerPanel and self.OwnerPanel.OwnerPanel
end

function M:IsRoleRotationOperationForbidden()
  if not self:IsRoleRotationItem() then
    return false
  end
  local Host = self:GetHost()
  if not Host then
    return false
  end
  if Host.IsCameraCustomizeRoleRotationForbidden then
    return Host:IsCameraCustomizeRoleRotationForbidden() == true
  end
  return Host.IsCameraCustomizeRoleRotationBlockedByLookAt and true == Host:IsCameraCustomizeRoleRotationBlockedByLookAt()
end

function M:IsRoleRotationBlockedByMount()
  local Host = self:GetHost()
  return self:IsRoleRotationItem() and Host and Host.IsCameraCustomizeRoleRotationBlockedByMount and Host:IsCameraCustomizeRoleRotationBlockedByMount() == true
end

function M:OnSliderOperationForbidden()
  local Host = self:GetHost()
  if self:IsRoleRotationItem() and Host and Host.ShowCameraCustomizeRoleRotationForbiddenToast then
    Host:ShowCameraCustomizeRoleRotationForbiddenToast()
    return
  end
  if self:IsRoleRotationBlockedByMount() and Host and Host.ShowCameraCustomizeRoleRotationMountToast then
    Host:ShowCameraCustomizeRoleRotationMountToast()
  end
end

function M:RefreshInteractableState()
  if not self.Slider then
    return
  end
  if self:IsRoleRotationOperationForbidden() then
    self:RefreshForbiddenAnimation(true)
    self:SetSliderOperationForbidden(true)
    return
  end
  self:RefreshForbiddenAnimation(false)
  self:SetSliderOperationForbidden(false)
end

function M:SetSliderOperationForbidden(bForbidden)
  if not self.Slider then
    return
  end
  if self.Slider.SetExternalOperationForbidden then
    self.Slider:SetExternalOperationForbidden(true == bForbidden)
    return
  end
  if true == bForbidden then
    if self.Slider.TriggerKeyUpEvent then
      self.Slider:TriggerKeyUpEvent()
    end
    if self.Slider.ForbidMinOperation then
      self.Slider:ForbidMinOperation(true)
    end
    if self.Slider.ForbidAddOperation then
      self.Slider:ForbidAddOperation(true)
    end
  elseif self.Slider.RefreshBtnState then
    self.Slider:RefreshBtnState()
  end
end

function M:PlayStateAnimation(Animation)
  if Animation and self.PlayAnimation then
    self:PlayAnimation(Animation)
  end
end

function M:RefreshForbiddenAnimation(bForbidden)
  if self.bForbiddenAnimState == bForbidden then
    return
  end
  self.bForbiddenAnimState = bForbidden
  if bForbidden then
    self:PlayStateAnimation(self.Forbbiden or self.Forbidden)
  else
    self:PlayStateAnimation(self.Normal)
  end
end

function M:ResetGamePadFocusStyle()
  if self.Slider and self.Slider.UpdateUIStyleInPlatform then
    self.Slider:UpdateUIStyleInPlatform(false)
  end
end

function M:ClearNew()
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
  end
  self:Refresh()
end

function M:OnSliderChanged(Value)
  local OldValue = self.OwnerPanel and self.Config and self:ClampValue(self.OwnerPanel:GetValue(self.Config))
  self.Value = self:ClampValue(Value)
  if self.OwnerPanel then
    local bSuccess = self.OwnerPanel:OnItemValueChanged(self.Config, self.Value)
    if false == bSuccess then
      self.Value = OldValue or self.Value
      self:RefreshValue()
      return false
    end
  end
  self:ClearNew()
  self:RefreshText()
  return true
end

function M:HandleLeftRight(Delta)
  local KeyName = Delta and Delta > 0 and UIConst.GamePadKey.RightTriggerThreshold or UIConst.GamePadKey.LeftTriggerThreshold
  if self.Slider and self.Slider.Handle_KeyDownEventOnGamePad then
    local bHandled = self.Slider:Handle_KeyDownEventOnGamePad(KeyName)
    if self.Slider.Handle_KeyUpEventOnGamePad then
      self.Slider:Handle_KeyUpEventOnGamePad(KeyName)
    end
    if bHandled then
      return true
    end
  end
  self:OnSliderChanged((self.Value or self.MinValue) + (Delta or 0) * self.Step)
  return true
end

function M:RefreshFocus(bFocused)
  if self.Slider and self.Slider.UpdateUIStyleInPlatform then
    self.Slider:UpdateUIStyleInPlatform(true == bFocused, UIUtils and UIUtils.UtilsGetCurrentGamepadName and UIUtils.UtilsGetCurrentGamepadName())
  end
  if not bFocused then
    self:ReleaseGamePadSliderKey()
  end
end

function M:ReleaseGamePadSliderKey()
  if self.GamePadSliderKeyDown and self.Slider and self.Slider.Handle_KeyUpEventOnGamePad then
    self.Slider:Handle_KeyUpEventOnGamePad(self.GamePadSliderKeyDown)
  end
  self.GamePadSliderKeyDown = nil
end

function M:HandleGamePadKeyDown(InKeyName)
  if InKeyName ~= UIConst.GamePadKey.LeftTriggerThreshold and InKeyName ~= UIConst.GamePadKey.RightTriggerThreshold and InKeyName ~= UIConst.GamePadKey.RightStickLeft and InKeyName ~= UIConst.GamePadKey.RightStickRight then
    return false
  end
  if self.GamePadSliderKeyDown and self.GamePadSliderKeyDown ~= InKeyName then
    self:ReleaseGamePadSliderKey()
  end
  self.GamePadSliderKeyDown = InKeyName
  return self:Handle_KeyDownEventOnGamePad(InKeyName) == true
end

function M:HandleGamePadKeyUp(InKeyName)
  if InKeyName ~= UIConst.GamePadKey.LeftTriggerThreshold and InKeyName ~= UIConst.GamePadKey.RightTriggerThreshold and InKeyName ~= UIConst.GamePadKey.RightStickLeft and InKeyName ~= UIConst.GamePadKey.RightStickRight then
    return false
  end
  if self.GamePadSliderKeyDown == InKeyName then
    self.GamePadSliderKeyDown = nil
  end
  return self:Handle_KeyUpEventOnGamePad(InKeyName) == true
end

function M:HandleGamePadAnalog(AxisName, DirectionKey, Value)
  if AxisName ~= UIConst.GamePadKey.RightAnalogX then
    return false
  end
  if not DirectionKey then
    self:ReleaseGamePadSliderKey()
    return true
  end
  return self:HandleGamePadKeyDown(DirectionKey)
end

function M:Handle_KeyDownEventOnGamePad(Key, EventType)
  if self.Slider and self.Slider.Handle_KeyDownEventOnGamePad then
    return self.Slider:Handle_KeyDownEventOnGamePad(Key, EventType)
  end
end

function M:Handle_KeyUpEventOnGamePad(Key, EventType)
  if self.Slider and self.Slider.Handle_KeyUpEventOnGamePad then
    return self.Slider:Handle_KeyUpEventOnGamePad(Key, EventType)
  end
end

return M
