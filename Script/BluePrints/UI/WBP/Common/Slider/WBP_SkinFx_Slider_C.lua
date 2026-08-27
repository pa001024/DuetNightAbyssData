require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})
local GamePadAddKey = {
  Vertical = UIConst.GamePadKey.RightStickUp,
  Horizontal = UIConst.GamePadKey.RightStickRight
}
local GamePadMinKey = {
  Vertical = UIConst.GamePadKey.RightStickDown,
  Horizontal = UIConst.GamePadKey.RightStickLeft
}
local LongPressInterval = 0.5
local SkinFxScale = 10.0

function M:Construct()
  self.CurrentCount = nil
  self.CurInputDeviceType = nil
  self.CurGamepadNameName = nil
  self.StepCount = 1
  self.AddTime = 0
  self.MinTime = 0
  self.ExternalOperationForbidden = false
end

function M:OnNavigateLeft()
  self:OnMinusBtnClicked()
end

function M:OnNavigateRight()
  self:OnAddBtnClicked()
end

function M:Destruct()
  self.Binded = false
  self:ClearListenEvent()
  M.Super.Destruct(self)
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner = Owner
  self.SkinId = Params.SkinId
  self.CharId = Params.CharId
  self.SkinWidget = Params.SkinWidget
  self:Init(Params)
  self.Owner.ButtonBar.Btn_Yes:SetText(GText("UI_PATCH_ENSURE"))
  self.Owner.ButtonBar.Btn_Quit:SetText(GText("UI_Skin_Upgrade_Reset"))
  self.Owner:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
    self,
    self.OnNavigateLeft
  })
  self.Owner:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
    self,
    self.OnNavigateRight
  })
  self.Owner.bLimitNavigation = false
end

function M:Init(ConfigData)
  self.ConfigData = ConfigData
  self.ExternalOperationForbidden = false
  self.NewEffectInterval = ConfigData.EffectIntervalText or 1
  self.Unit = 1 / DataMgr.GlobalConstant.SkinIntervalUnit.ConstantValue
  self.CurrentCount = ConfigData.EffectIntervalText or 1
  self.MinValue = DataMgr.GlobalConstant.SkinIntervalMin.ConstantValue
  self.MaxValue = DataMgr.GlobalConstant.SkinIntervalMax.ConstantValue
  rawset(self, "MiniBtnGamePadKey", self.EnableMiniBtn and (ConfigData.MiniBtnGamePadKey or "DPadLeft") or nil)
  rawset(self, "MaxBtnGamePadKey", self.EnableMaxBtn and (ConfigData.MaxBtnGamePadKey or "DPadRight") or nil)
  self.SliderChangeCallback = ConfigData.SliderChangeCallback
  self.SoundResPath = {
    Slider = "event:/ui/common/slider_value_change"
  }
  self.OwnerPanel = ConfigData.OwnerPanel
  self.ForbidGamePadLTRTKey = ConfigData.ForbidGamePadLTRTKey or false
  self.ForbidGamePadRSKey = ConfigData.ForbidGamePadRSKey or false
  self.GamePadRSRate = ConfigData.GamePadRSRate or 1
  self.bDisableAutoHandleInputDeviceChange = ConfigData.bDisableAutoHandleInputDeviceChange or false
  self.bForbidPressAccelerate = ConfigData.bForbidPressAccelerate or false
  self.bUseDefaultKeyInit = ConfigData.bUseDefaultKeyInit or true
  rawset(self, "bEnableMinusSpecificBtn", ConfigData.bEnableMinusSpecificBtn or false)
  rawset(self, "bEnableAddSpecificBtn", ConfigData.bEnableAddSpecificBtn or false)
  rawset(self, "SpecificChangeCount", ConfigData.SpecificChangeCount or DataMgr.GlobalConstant.SkinIntervalUnit.ConstantValue)
  rawset(self, "MinusSpecificBtnGamePadKey", self.bEnableMinusSpecificBtn and (ConfigData.MinusSpecificBtnGamePadKey or "DPadLeft") or nil)
  rawset(self, "AddSpecificBtnGamePadKey", self.bEnableAddSpecificBtn and (ConfigData.AddSpecificBtnGamePadKey or "DPadRight") or nil)
  rawset(self, "GamePadMinKeyPath", self.GamePadMinKeyPath and self.GamePadMinKeyPath or "LT")
  rawset(self, "GamePadAddKeyPath", self.GamePadAddKeyPath and self.GamePadAddKeyPath or "RT")
  self:AddTimer(0.01, function()
    self:BindAllClickAction()
    self:RefreshBaseInfo()
    self:InitListenEvent()
  end)
  self:InitWidget()
  self:AddDispatcher(EventID.OnCharSkinFxCountChanged, self, self.OnCharSkinFxCountChanged)
  self:AddDispatcher(EventID.OnCharSkinFxCountSet, self, self.OnCharSkinFxCountSet)
end

function M:InitWidget()
  local Count = (self.MaxValue - self.MinValue) / 4
  self.FXTime.Time_FX:SetText(self.MinValue)
  self.FXTime_1.Time_FX:SetText(self.MinValue + Count * 1)
  self.FXTime_2.Time_FX:SetText(self.MinValue + Count * 2)
  self.FXTime_3.Time_FX:SetText(self.MinValue + Count * 3)
  self.FXTime_4.Time_FX:SetText(self.MinValue + Count * 4)
  local Avatar = GWorld:GetAvatar()
  local CommonChar = Avatar.CommonChars[self.CharId]
  local CharSkin = CommonChar.OwnedSkins[self.SkinId]
  local EffectIntervalText = 0
  if -1 ~= CharSkin.EffectInterval then
    EffectIntervalText = math.floor(CharSkin.EffectInterval * SkinFxScale + 0.5) / SkinFxScale
  else
    EffectIntervalText = self:GetSkinDefaultFxCount()
  end
  self.Text_FX:SetText(string.format(GText("UI_Skin_Upgrade_Conetnt_1"), EffectIntervalText))
  self.Owner.Tips[1].Text_Tips:SetText(GText("UI_Skin_Upgrade_Conetnt_2"), EffectIntervalText)
end

function M:OnCharSkinFxCountChanged()
  self:ResetSkinFxCount()
  self:OnRefreshFxRightBtn()
end

function M:OnCharSkinFxCountSet(SkinId, SkinFxCountSetCB)
  local function InCallBack(Ret, SkinId, NewEffectInterval)
    local TimerIntervalText = math.floor(NewEffectInterval * SkinFxScale + 0.5) / SkinFxScale
    
    SkinFxCountSetCB(TimerIntervalText)
    self.NewEffectInterval = TimerIntervalText
    self.Owner.Tips[1].Text_Tips:SetText(string.format(GText("UI_Skin_Upgrade_Conetnt_2"), TimerIntervalText))
    self:OnRefreshFxRightBtn()
  end
  
  local Avatar = GWorld:GetAvatar()
  Avatar:SetCharSkinEffectInterval(InCallBack, SkinId, self.CurrentCount)
end

function M:ResetSkinFxCount()
  local EffectIntervalText = self:GetSkinDefaultFxCount()
  self.Text_FX:SetText(string.format(GText("UI_Skin_Upgrade_Conetnt_1"), EffectIntervalText))
  self.CurrentCount = EffectIntervalText
  self:UpdateSliderAndProgress()
end

function M:GetSkinFxCount()
  local SkinConfig = DataMgr.Skin[self.SkinId]
  if SkinConfig and SkinConfig.TimerInterval then
    local TimerInterval = SkinConfig.TimerInterval[3]
    local EffectIntervalText = math.floor(TimerInterval * SkinFxScale + 0.5) / SkinFxScale
    return EffectIntervalText
  end
  return 0
end

function M:GetSkinDefaultFxCount()
  local SkinConfig = DataMgr.Skin[self.SkinId]
  if SkinConfig and SkinConfig.TimerInterval and SkinConfig.MinInterval then
    local TimerInterval = SkinConfig.TimerInterval[3]
    local MinInterval = SkinConfig.MinInterval
    local DefaultEffectIntervalText = math.floor((TimerInterval - MinInterval) * SkinFxScale + 0.5) / SkinFxScale
    return DefaultEffectIntervalText
  end
  return 0
end

function M:OnRefreshFxRightBtn()
  if math.abs(self.CurrentCount - self.NewEffectInterval) < 0.01 then
    self.Owner:ForbidRightBtn(true)
    self.Owner.ButtonBar.Btn_Yes:SetText(GText("UI_Skin_Upgrade_Using"))
  else
    self.Owner:ForbidRightBtn(false)
    self.Owner.ButtonBar.Btn_Yes:SetText(GText("UI_PATCH_ENSURE"))
  end
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Top" == InKeyName then
    self:ResetSkinFxCount()
    self:UpdateSliderAndProgress()
    return true
  elseif "Gamepad_FaceButton_Bottom" == InKeyName then
    self.SkinWidget:OnClickFxRightBtn()
    return true
  end
  return false
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return false
end

function M:OnMinusKeyUp()
  self:RemoveTimer("PreAddLoop", true)
  local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
  if AddTimerKey then
    self:UnPauseTimer("PreMinusLoop")
  end
end

function M:OnAddKeyUp()
  self:RemoveTimer("PreMinusLoop", true)
  local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
  if AddTimerKey then
    self:UnPauseTimer("PreAddLoop")
  end
end

function M:OnMinusKeyDown()
  if self.ExternalOperationForbidden then
    return
  end
  self:AddTimer(LongPressInterval, self.OnMinusBtnClicked, true, 0, "PreMinusLoop", true)
  local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
  if AddTimerKey then
    self.AddTime = 0
    self:PauseTimer("PreAddLoop")
    self:PauseTimer("PreMinusLoop")
  else
    self:OnMinusBtnClicked()
  end
end

function M:OnMinusKeyUp()
  self.MinTime = 0
  self:RemoveTimer("PreMinusLoop", true)
  local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
  if AddTimerKey then
    self:UnPauseTimer("PreAddLoop")
  end
end

function M:OnAddKeyDown()
  if self.ExternalOperationForbidden then
    return
  end
  self:AddTimer(LongPressInterval, self.OnAddBtnClicked, true, 0, "PreAddLoop", true)
  local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
  if AddTimerKey then
    self.MinTime = 0
    self:PauseTimer("PreMinusLoop")
    self:PauseTimer("PreAddLoop")
  else
    self:OnAddBtnClicked()
  end
end

function M:OnAddKeyUp()
  self.AddTime = 0
  self:RemoveTimer("PreAddLoop", true)
  local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
  if AddTimerKey then
    self:UnPauseTimer("PreMinusLoop")
  end
end

function M:OnMinusBtnClicked()
  local FinalCount = self.SpecificChangeCount
  if FinalCount > self.CurrentCount - self.MinValue then
    FinalCount = self.CurrentCount - self.MinValue
  end
  if FinalCount <= 0 then
    return
  end
  if self.CurrentCount - FinalCount < self.MinValue then
    if not self.ForbidMin then
      self:ForbidMinOperation(true)
    end
    return
  end
  self.CurrentCount = self.CurrentCount - FinalCount
  self:UpdateSliderAndProgress()
end

function M:OnAddBtnClicked()
  local FinalCount = self.SpecificChangeCount
  if FinalCount > self.MaxValue - self.CurrentCount then
    FinalCount = self.MaxValue - self.CurrentCount
  end
  if FinalCount <= 0 then
    return
  end
  if self.CurrentCount + FinalCount > self.MaxValue then
    if not self.ForbidAdd then
      self:ForbidAddOperation(true)
    end
    return
  end
  self.CurrentCount = self.CurrentCount + FinalCount
  self:UpdateSliderAndProgress()
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self.StepCount = 0 == self.MaxValue - self.MinValue and 1 or self.MaxValue - self.MinValue
  self.Slider:SetStepSize(1 / self.StepCount)
  self.Slider_Controller:SetStepSize(1 / self.StepCount)
  self:UpdateSliderAndProgress()
  if self.MaxValue - self.MinValue <= 0 then
    self.Slider:SetLocked(true)
    self.Slider_Controller:SetLocked(true)
  else
    self.Slider:SetLocked(false)
    self.Slider_Controller:SetLocked(false)
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.bDisableAutoHandleInputDeviceChange then
    return
  end
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  local IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
  self:UpdateUIStyleInPlatform(IsUseGamePad, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
end

function M:UpdateUIStyleInPlatform(IsUseGamePad, CurGamepadName)
  self:SliderUseGamePadStyle(IsUseGamePad)
  if IsUseGamePad then
    self.InGamePadMode = true
    self:UpdateMouseGamePadImage(CurGamepadName)
  else
    self.InGamePadMode = false
    self.AddPressed = false
    self:OnMinusKeyUp()
    self:OnAddKeyUp()
  end
end

function M:SliderUseGamePadStyle(UseGamePadStyle)
  if self.ForbidGamePadRSKey then
    UseGamePadStyle = false
  end
  if UseGamePadStyle then
    self.SliderInGamePadStyle = true
  else
    self.SliderInGamePadStyle = false
  end
  local ActiveWidgetIndex = UseGamePadStyle and 1 or 0
  self.WS_Slider:SetActiveWidgetIndex(ActiveWidgetIndex)
end

function M:BindAllClickAction()
  if self.Binded then
    return
  end
  self.Slider.OnValueChanged:Add(self, self.OnSliderValueChanged)
  self.Slider.OnMouseCaptureBegin:Add(self, self.OnSelectedSlider)
  self.Slider.OnMouseCaptureEnd:Add(self, self.OnUnSelectedSlider)
  self.Binded = true
end

function M:UpdateSliderValue()
  local Value = (self.CurrentCount - self.MinValue) / self.StepCount
  if 0 ~= self.MaxValue and self.CurrentCount == self.MaxValue then
    Value = 1
  end
  self.Slider:SetValue(Value)
  self.Slider_Controller:SetValue(Value)
  local SlideValue = math.floor(self.CurrentCount * SkinFxScale + 0.5) / SkinFxScale
  local NewCount = math.max(self.MinValue, math.min(SlideValue, self.MaxValue))
  self.Text_FX:SetText(GText(string.format(GText("UI_Skin_Upgrade_Conetnt_1"), NewCount)))
end

function M:OnSliderValueChanged(Value)
  local SlideValue = Value * self.StepCount + self.MinValue
  SlideValue = math.floor(SlideValue * SkinFxScale + 0.5) / SkinFxScale
  local NewCount = math.max(self.MinValue, math.min(SlideValue, self.MaxValue))
  NewCount = math.floor(NewCount * self.Unit) / self.Unit
  self:UpdateSliderValue()
  if NewCount ~= self.CurrentCount then
    self.CurrentCount = NewCount
    self:UpdateSliderAndProgress(true)
    if self.SelectedSlider then
      local EventSoundPath = self.SoundResPath.Slider or "event:/ui/common/click"
      AudioManager(self):PlayUISound(self.WS_Slider, EventSoundPath, nil, nil)
    end
  end
end

function M:OnSelectedSlider()
  self.SelectedSlider = true
end

function M:OnUnSelectedSlider()
  self.SelectedSlider = false
end

function M:SetValue(Value)
  self.CurrentCount = Value
end

function M:SetMinValue(MinValue)
  self.MinValue = MinValue
end

function M:SetMaxValue(MaxValue)
  self.MaxValue = MaxValue
end

function M:OverrideValueLimit(InitValue, MaxValue, MinValue, bRefresh)
  self.CurrentCount = InitValue or 1
  self.MaxValue = MaxValue or 999
  self.MinValue = MinValue or 1
  if bRefresh then
    self:RefreshBaseInfo()
  else
    self:ForbidAddOperation(self.CurrentCount >= self.MaxValue, true)
    self:ForbidMinOperation(self.CurrentCount <= self.MinValue, true)
  end
end

function M:SetEnabled(IsEnabled)
  if IsEnabled then
    self.Slider:SetIsEnabled(true)
    self.Slider:SetRenderOpacity(1)
    self.Slider_Controller:SetIsEnabled(true)
    self.Slider_Controller:SetRenderOpacity(1)
    self.ProgressBar_Slider:SetRenderOpacity(1)
  else
    self.Slider:SetIsEnabled(false)
    self.Slider:SetRenderOpacity(0.6)
    self.Slider_Controller:SetIsEnabled(false)
    self.Slider_Controller:SetRenderOpacity(0.6)
    self.ProgressBar_Slider:SetRenderOpacity(0.6)
  end
end

function M:SetExternalOperationForbidden(bForbidden)
  local Forbidden = true == bForbidden
  if self.ExternalOperationForbidden == Forbidden then
    if Forbidden then
      self:ForbidMinOperation(true, true)
      self:ForbidAddOperation(true, true)
    end
    return
  end
  self.ExternalOperationForbidden = Forbidden
  self:TriggerKeyUpEvent()
  if Forbidden then
    self:ForbidMinOperation(true, true)
    self:ForbidAddOperation(true, true)
  else
    self:RefreshBtnState()
  end
end

function M:UpdateSliderAndProgress(NeedCallback)
  self:UpdateSliderValue()
  self:OnRefreshFxRightBtn()
  self.ProgressBar_Slider:SetPercent(self.Slider:GetValue())
  if NeedCallback and type(self.SliderChangeCallback) == "function" then
    self.SliderChangeCallback(self.OwnerPanel, self.CurrentCount)
  end
end

function M:RefreshCurInputNumber(NewNumber)
  self.CurrentCount = NewNumber or 1
  self:UpdateSliderAndProgress()
  self:RefreshBtnState()
end

function M:RefreshBtnState()
  self:ForbidAddOperation(self.CurrentCount >= self.MaxValue, true)
  self:ForbidMinOperation(self.CurrentCount <= self.MinValue, true)
end

function M:UpdateMouseGamePadImage(CurGamepadName)
  if self.CurGamepadNameName == CurGamepadName then
    return
  end
  local ResourceIconPath = UIUtils.UtilsGetKeyIconPathInGamepad("LH", CurGamepadName)
  local Img = LoadObject(ResourceIconPath)
  if not IsValid(Img) then
    return
  end
  self.Slider_Controller.WidgetStyle.NormalThumbImage.ResourceObject = Img
  self.Slider_Controller.WidgetStyle.DisabledThumbImage.ResourceObject = Img
  self.Slider_Controller.WidgetStyle.HoveredThumbImage.ResourceObject = Img
end

return M
