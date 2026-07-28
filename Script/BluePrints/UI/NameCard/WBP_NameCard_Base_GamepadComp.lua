local Component = {}

function Component:InitGamepadComp()
  if UIUtils.IsMobileInput() then
    return
  end
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:AddTimer(0.1, function()
      self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end)
  end
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsMobileInput() then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self:SwitchToMouseAndKeyboard()
  else
    self:SwitchToGamepad()
  end
end

function Component:SwitchToMouseAndKeyboard()
end

function Component:SwitchToGamepad()
  self:SetGamepadDefaultFocus()
end

function Component:SetGamepadDefaultFocus()
  if self.CurrentWidget and self.CurrentWidget.SetGamepadDefaultFocus then
    self.CurrentWidget:SetGamepadDefaultFocus()
  end
end

function Component:HandleGamepadInput(InKeyName)
  if "Gamepad_LeftShoulder" == InKeyName and self.Com_Tab and self.Com_Tab.TabToLeft then
    self.Com_Tab:TabToLeft()
    return true
  end
  if "Gamepad_RightShoulder" == InKeyName and self.Com_Tab and self.Com_Tab.TabToRight then
    self.Com_Tab:TabToRight()
    return true
  end
  if "Gamepad_FaceButton_Right" == InKeyName then
    self:OnClickBack()
    return true
  end
  if self.CurrentWidget and self.CurrentWidget.HandleGamepadInput then
    return self.CurrentWidget:HandleGamepadInput(InKeyName)
  end
  return false
end

function Component:OnDestroyedGamepadComp()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self.GameInputModeSubsystem = nil
end

return Component
