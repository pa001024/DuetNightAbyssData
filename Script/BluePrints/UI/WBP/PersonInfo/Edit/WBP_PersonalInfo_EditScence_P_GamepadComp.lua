local Component = {}
local GAMEPAD_UP_KEYS = {
  [UIConst.GamePadKey.DPadUp] = true,
  [UIConst.GamePadKey.LeftStickUp] = true
}
local GAMEPAD_DOWN_KEYS = {
  [UIConst.GamePadKey.DPadDown] = true,
  [UIConst.GamePadKey.LeftStickDown] = true
}
local GAMEPAD_LEFT_KEYS = {
  [UIConst.GamePadKey.DPadLeft] = true,
  [UIConst.GamePadKey.LeftStickLeft] = true
}
local GAMEPAD_RIGHT_KEYS = {
  [UIConst.GamePadKey.DPadRight] = true,
  [UIConst.GamePadKey.LeftStickRight] = true
}
local LEFT_STICK_X_KEY_NAME = "Gamepad_LeftX"
local ANALOG_DEAD_ZONE = 0.35
local GAMEPAD_SLIDER_STEP = 0.02
local SCENE_TIPS_LONG_PRESS_DURATION = 1
local SCENE_TIPS_LONG_PRESS_TIMER_KEY = "SceneTipsGamepadLongPress"

local function IsGamepadInput(Owner)
  if Owner.CurInputDeviceType ~= nil then
    return Owner.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = Owner.EditRootController and Owner.EditRootController.OwnerWidget or nil
  return nil ~= RootOwner and RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
end

local function GetTimerOwner(Owner)
  local EditRootController = Owner and Owner.EditRootController or nil
  if not EditRootController then
    return nil
  end
  return EditRootController.RootViewPanel or EditRootController.OwnerWidget
end

local function RefreshRootGamepadKeyState(Owner)
  local RootOwner = Owner.EditRootController and Owner.EditRootController.RootViewPanel or nil
  if RootOwner and RootOwner.RefreshCustomEditGamepadPageState then
    RootOwner:RefreshCustomEditGamepadPageState()
  end
end

function Component:_EnsureSceneTipsGamepadKeyInitialized()
  if self._bSceneTipsGamepadKeyInitialized then
    return
  end
  if not self.Key_Check or not self.Key_Check.CreateCommonKey then
    return
  end
  self.Key_Check:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.SpecialRight,
        bSpecialLongPress = true
      }
    },
    bLongPress = true
  })
  self._bSceneTipsGamepadKeyInitialized = true
end

function Component:_PlaySceneTipsGamepadKeyProgress()
  self:_EnsureSceneTipsGamepadKeyInitialized()
  if not self.Key_Check or not self.Key_Check.OnButtonPressed then
    return
  end
  self.Key_Check:OnButtonPressed(false, true, 0, SCENE_TIPS_LONG_PRESS_DURATION - Const.ShortPressThreshold)
end

function Component:_StopSceneTipsGamepadKeyProgress()
  if not self.Key_Check then
    return
  end
  if self.Key_Check.OnButtonReleased then
    self.Key_Check:OnButtonReleased()
  end
  if self.Key_Check.StopAllAnimations then
    self.Key_Check:StopAllAnimations()
  end
  if self.Key_Check.Normal and self.Key_Check.PlayAnimation then
    self.Key_Check:PlayAnimation(self.Key_Check.Normal)
  end
end

function Component:RefreshScenePageGamepadState()
  local RootOwner = self.EditRootController and self.EditRootController.OwnerWidget or nil
  local InputType = RootOwner and RootOwner.CurInputDeviceType or self.CurInputDeviceType
  local GamepadName = RootOwner and RootOwner.CurGamepadName or self.CurGamepadName
  for _, AxisName in ipairs(self:_GetSceneLightSliderOrder()) do
    local SliderItem = self:_GetSceneLightSliderWidget(AxisName)
    SliderItem:RefreshInputStyle(InputType, GamepadName)
  end
  if InputType == ECommonInputType.Gamepad then
    self:_EnsureSceneTipsGamepadKeyInitialized()
  end
  if self.Key_Check and self.Key_Check.SetVisibility then
    local bShow = InputType == ECommonInputType.Gamepad and self:IsSceneTipsOpened() ~= true
    self.Key_Check:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if InputType ~= ECommonInputType.Gamepad then
    self:_CancelSceneTipsGamepadLongPress()
    self:EndSceneLightSliderAdjust()
  end
end

function Component:RefreshView()
  self:RefreshScenePageGamepadState()
  if not IsGamepadInput(self) then
    return
  end
  
  local function RefreshFocus()
    if not IsGamepadInput(self) then
      return
    end
    if not self:_FocusSelectedSceneItem() then
      self:SetFocus()
    end
  end
  
  local TimerOwner = GetTimerOwner(self)
  if TimerOwner and TimerOwner.AddTimer then
    TimerOwner:AddTimer(0.05, RefreshFocus)
    return
  end
  RefreshFocus()
end

function Component:FocusGamepadDefaultSceneItem()
  self:RefreshView()
end

function Component:_FocusSelectedSceneItem(bAllowRetry)
  if not (self.List_Scence and self.SceneItemContents) or 0 == #self.SceneItemContents then
    return false
  end
  local SelectedContent
  if self.List_Scence.BP_GetSelectedItem then
    SelectedContent = self.List_Scence:BP_GetSelectedItem()
  end
  if not SelectedContent then
    for _, Content in ipairs(self.SceneItemContents) do
      if Content.IsSelected == true then
        SelectedContent = Content
        break
      end
    end
  end
  SelectedContent = SelectedContent or self.SceneItemContents[1]
  if self.List_Scence.BP_NavigateToItem then
    self.List_Scence:BP_NavigateToItem(SelectedContent)
  elseif self.List_Scence.SetFocus then
    self.List_Scence:SetFocus()
  end
  local SceneId = SelectedContent.SceneId
  local EntryWidget = self.SceneEntryWidgetMap and self.SceneEntryWidgetMap[SceneId] or nil
  local FocusWidget = EntryWidget and EntryWidget.Btn_Area or EntryWidget
  if FocusWidget and FocusWidget.SetFocus then
    FocusWidget:SetFocus()
    RefreshRootGamepadKeyState(self)
    return true
  end
  if false ~= bAllowRetry then
    local TimerOwner = GetTimerOwner(self)
    if TimerOwner and TimerOwner.AddTimer then
      TimerOwner:AddTimer(0.05, function()
        if IsGamepadInput(self) then
          self:_FocusSelectedSceneItem(false)
        end
      end)
    end
  end
  RefreshRootGamepadKeyState(self)
  return self.List_Scence.HasAnyUserFocus and true == self.List_Scence:HasAnyUserFocus()
end

function Component:FocusGamepadSceneLightPanel()
  return self:_FocusSceneLightSliderByIndex(1)
end

function Component:ShouldShowSceneLightAdjustGamepadKey()
  return IsGamepadInput(self) and self:_HasWidgetFocus(self.List_Scence)
end

function Component:Handle_ScenePageGamepadKeyDown(InKeyName, bIsRepeat)
  if not IsGamepadInput(self) then
    return false
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    if bIsRepeat then
      return true
    end
    return self:_BeginSceneTipsGamepadLongPress()
  end
  local FocusedSliderItem, FocusedSliderIndex = self:_GetFocusedSceneLightSliderItem()
  if FocusedSliderItem then
    if GAMEPAD_LEFT_KEYS[InKeyName] or GAMEPAD_RIGHT_KEYS[InKeyName] then
      local Offset = GAMEPAD_LEFT_KEYS[InKeyName] and -GAMEPAD_SLIDER_STEP or GAMEPAD_SLIDER_STEP
      FocusedSliderItem:_AdjustSliderByGamepadStep(Offset)
      return true
    end
    if GAMEPAD_UP_KEYS[InKeyName] then
      if 1 == FocusedSliderIndex then
        self:_FocusSelectedSceneItem()
      else
        self:_FocusSceneLightSliderByIndex(FocusedSliderIndex - 1)
      end
      return true
    end
    if GAMEPAD_DOWN_KEYS[InKeyName] then
      self:_FocusSceneLightSliderByIndex(math.min(FocusedSliderIndex + 1, #self:_GetSceneLightSliderOrder()))
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:_FocusSelectedSceneItem()
      return true
    end
  end
  if self:_HasWidgetFocus(self.List_Scence) and GAMEPAD_DOWN_KEYS[InKeyName] then
    return self:_FocusSceneLightSliderByIndex(1)
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self:_HasWidgetFocus(self.List_Scence) then
    return self:FocusGamepadSceneLightPanel()
  end
  return false
end

function Component:Handle_ScenePageGamepadKeyUp(InKeyName)
  if InKeyName ~= UIConst.GamePadKey.SpecialRight then
    return false
  end
  if not self._bSceneTipsGamepadLongPressing then
    return false
  end
  self:_CancelSceneTipsGamepadLongPress()
  return true
end

function Component:_BeginSceneTipsGamepadLongPress()
  if self:IsSceneTipsOpened() then
    return true
  end
  if self._bSceneTipsGamepadLongPressing then
    return true
  end
  local TimerOwner = GetTimerOwner(self)
  if not TimerOwner or not TimerOwner.AddTimer then
    return false
  end
  TimerOwner.GamepadPressedKeyMap = TimerOwner.GamepadPressedKeyMap or {}
  TimerOwner.GamepadPressedKeyMap[UIConst.GamePadKey.SpecialRight] = true
  self._bSceneTipsGamepadLongPressing = true
  self:_PlaySceneTipsGamepadKeyProgress()
  TimerOwner:AddTimer(SCENE_TIPS_LONG_PRESS_DURATION, function()
    if not IsValid(self) then
      return
    end
    self._bSceneTipsGamepadLongPressing = false
    self:_StopSceneTipsGamepadKeyProgress()
    if not IsGamepadInput(self) then
      return
    end
    if self:IsSceneTipsOpened() then
      return
    end
    if self.ShowSceneTips then
      self:ShowSceneTips()
    end
  end, false, 0, SCENE_TIPS_LONG_PRESS_TIMER_KEY, true)
  return true
end

function Component:_CancelSceneTipsGamepadLongPress()
  if not self._bSceneTipsGamepadLongPressing then
    return
  end
  self._bSceneTipsGamepadLongPressing = false
  self:_StopSceneTipsGamepadKeyProgress()
  local TimerOwner = GetTimerOwner(self)
  if TimerOwner and TimerOwner.RemoveTimer then
    TimerOwner:RemoveTimer(SCENE_TIPS_LONG_PRESS_TIMER_KEY)
  end
end

function Component:Handle_ScenePageGamepadAnalog(InKeyName, AnalogValue)
  if not IsGamepadInput(self) or InKeyName ~= LEFT_STICK_X_KEY_NAME then
    return false
  end
  local FocusedSliderItem = self:_GetFocusedSceneLightSliderItem()
  if not FocusedSliderItem then
    self:EndSceneLightSliderAdjust()
    return false
  end
  local AxisValue = AnalogValue or 0
  if math.abs(AxisValue) <= ANALOG_DEAD_ZONE then
    self:EndSceneLightSliderAdjust()
    return true
  end
  self:BeginSceneLightSliderAdjust(FocusedSliderItem.AxisName)
  FocusedSliderItem:HandleLeftStickXInput(AxisValue)
  return true
end

function Component:BeginSceneLightSliderAdjust(AxisName)
  if self.GamepadAdjustingSceneLightAxisName == AxisName then
    return
  end
  self:EndSceneLightSliderAdjust()
  self.GamepadAdjustingSceneLightAxisName = AxisName
  self:OnBeginTransformSliderDrag(AxisName)
end

function Component:EndSceneLightSliderAdjust()
  if not self.GamepadAdjustingSceneLightAxisName then
    return
  end
  self:OnEndTransformSliderDrag(self.GamepadAdjustingSceneLightAxisName)
  self.GamepadAdjustingSceneLightAxisName = nil
end

function Component:_FocusSceneLightSliderByIndex(SliderIndex)
  local AxisName = self:_GetSceneLightSliderOrder()[SliderIndex]
  local SliderItem = AxisName and self:_GetSceneLightSliderWidget(AxisName) or nil
  if not SliderItem or not SliderItem.SetFocus then
    return false
  end
  SliderItem:SetFocus()
  RefreshRootGamepadKeyState(self)
  return true
end

function Component:_GetFocusedSceneLightSliderItem()
  for SliderIndex, AxisName in ipairs(self:_GetSceneLightSliderOrder()) do
    local SliderItem = self:_GetSceneLightSliderWidget(AxisName)
    if self:_HasWidgetFocus(SliderItem) then
      return SliderItem, SliderIndex
    end
  end
  return nil, nil
end

return Component
