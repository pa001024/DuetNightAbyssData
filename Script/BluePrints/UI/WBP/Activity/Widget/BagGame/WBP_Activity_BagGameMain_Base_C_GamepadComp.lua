local Component = {}
local Const = UIConst.GamePadKey

function Component:InitListenEvent()
  local PlayerController = self:GetOwningPlayer()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function Component:RefreshBaseInfo()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local PrevInputDevice = self.CurInputDevice
  self.CurGamepadName = CurGamepadName
  self.CurInputDevice = CurInputDevice
  local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
  self:RefreshBeginKeyVisibility()
  local ArrowSwitcherIndex = IsUseGamepad and 1 or 0
  self.Arrow_R.WS_Arrow:SetActiveWidgetIndex(ArrowSwitcherIndex)
  self.Arrow_L.WS_Arrow:SetActiveWidgetIndex(ArrowSwitcherIndex)
  if IsUseGamepad and PrevInputDevice ~= ECommonInputType.Gamepad then
    self:_RestoreMainFocusForGamepad()
    self:_ScheduleRestoreMainFocusForGamepad()
  end
end

function Component:InitGamePadKey()
  self.BeginKey:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    },
    ClickCallback = self.OnBeginBtnClicked,
    Owner = self
  })
  self.Arrow_R.Key_Arrow:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    },
    Owner = self
  })
  self.Arrow_L.Key_Arrow:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    },
    Owner = self
  })
end

function Component:_GetFocusPlayerController()
  return self:GetOwningPlayer()
end

function Component:_HasFocusOnWidget(Widget)
  if not Widget then
    return false
  end
  local PlayerController = self:_GetFocusPlayerController()
  if PlayerController and Widget.HasUserFocus and Widget:HasUserFocus(PlayerController) then
    return true
  end
  if Widget.HasAnyUserFocus and Widget:HasAnyUserFocus() then
    return true
  end
  return false
end

function Component:_RestoreMainFocusForGamepad()
  if self.CurInputDevice ~= ECommonInputType.Gamepad then
    return
  end
  if not self:_HasFocusOnWidget(self) then
    self:SetFocus()
  end
end

function Component:_ScheduleRestoreMainFocusForGamepad()
  local TimerKey = "BagGameMainRestoreFocusAfterInputSwitch"
  self:RemoveTimer(TimerKey)
  self:AddTimer(0.12, function()
    self:_RestoreMainFocusForGamepad()
  end, false, 0, TimerKey)
end

function Component:HandleGamepadInput(InKeyName)
  if InKeyName == Const.LeftShoulder then
    self:ScrollToPreviousItem()
    return true
  elseif InKeyName == Const.RightShoulder then
    self:ScrollToNextItem()
    return true
  elseif InKeyName == Const.FaceButtonBottom then
    self:_RestoreMainFocusForGamepad()
    return true
  elseif InKeyName == Const.FaceButtonLeft then
    self:OnBeginBtnClicked()
    return true
  elseif InKeyName == Const.FaceButtonTop then
    if self.Btn_Arward and self.Btn_Arward.HandleKeyDownOnGamePad then
      self.Btn_Arward:HandleKeyDownOnGamePad(InKeyName)
    end
    return true
  elseif InKeyName == Const.FaceButtonRight then
    self:CloseSelf()
    return true
  end
  return false
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

return Component
