local M = {}

function M:Construct()
  self.IsShowGuideLine = {}
  self.Parameter:Hide()
  self.Parameter:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.GuideLine:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:SetParameterBtnRedDotType(RedDotType)
  if RedDotType == UIConst.RedDotType.NewRedDot then
    self.Btn_Parameter.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Btn_Parameter.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:ShowParameterWidget()
  if self.bDisableCameraParameter then
    return
  end
  self.Parameter:Show()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
end

function M:OnParameterWidgetShowed()
  self:StopCameraMove()
  if self.RefreshFocalLengthSliderKeyInfo then
    self:RefreshFocalLengthSliderKeyInfo()
  end
  if self.PushOperationStack then
    self:PushOperationStack("ParameterWidget")
  end
end

function M:OnParameterWidgetHidden()
  if self.PopOperationStack then
    self:PopOperationStack("ParameterWidget")
  end
  if self.RefreshFocalLengthSliderKeyInfo then
    self:RefreshFocalLengthSliderKeyInfo()
  end
end

function M:PlayParameterInAnim()
  self:StopAnimation(self.Parameter_Out)
  self:PlayAnimation(self.Parameter_In)
  if self:IsCustomizeOpened() then
    self:CloseCameraCustomizePanel()
  end
end

function M:PlayParameterOutAnim()
  self:StopAnimation(self.Parameter_In)
  self:PlayAnimation(self.Parameter_Out)
end

function M:HideParameterWidget()
  self.Parameter:Hide()
end

function M:IsParameterWidgetShowed()
  return self.Parameter:IsShowed()
end

function M:ToggleShowHideParameterWidget()
  if self.bDisableCameraParameter then
    return
  end
  self.Parameter:ToggleShowHide()
end

function M:SetIsShowGuideLine(bShow)
  self.bHasAnyOperation = true
  self.IsShowGuideLine[self.CurCameraIndex] = bShow
  if bShow then
    self.GuideLine:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.GuideLine:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:GetIsShowGuideLine()
  return self.IsShowGuideLine[self.CurCameraIndex] or false
end

function M:EnableFocusMethod(bEnable)
  self.bHasAnyOperation = true
  self.Camera:EnableFocusMethod(bEnable)
end

function M:IsFocusMethodEnabled()
  return self.Camera:IsFocusMethodEnabled()
end

function M:GetContrast()
  return self.Camera:GetContrast() * 100
end

function M:SetContrast(Contrast)
  self.bHasAnyOperation = true
  self.Camera:SetContrast(Contrast / 100)
end

function M:GetSaturation()
  return self.Camera:GetSaturation() * 100
end

function M:SetSaturation(Saturation)
  self.bHasAnyOperation = true
  self.Camera:SetSaturation(Saturation / 100)
end

function M:GetTemperature()
  return self.Camera:GetTemperature()
end

function M:SetTemperature(Temperature)
  self.bHasAnyOperation = true
  self.Camera:SetTemperature(Temperature)
end

function M:GetTemperature()
  return self.Camera:GetTemperature()
end

function M:GetSceneColorTintR()
  return self.Camera:GetSceneColorTintR() * 100
end

function M:SetSceneColorTintR(R)
  self.bHasAnyOperation = true
  self.Camera:SetSceneColorTintR(R / 100)
end

function M:GetSceneColorTintG()
  return self.Camera:GetSceneColorTintG() * 100
end

function M:SetSceneColorTintG(G)
  self.bHasAnyOperation = true
  self.Camera:SetSceneColorTintG(G / 100)
end

function M:GetSceneColorTintB()
  return self.Camera:GetSceneColorTintB() * 100
end

function M:SetSceneColorTintB(B)
  self.bHasAnyOperation = true
  self.Camera:SetSceneColorTintB(B / 100)
end

function M:GetWhiteTint()
  return self.Camera:GetWhiteTint() * 100
end

function M:SetWhiteTint(WhiteTint)
  self.bHasAnyOperation = true
  self.Camera:SetWhiteTint(WhiteTint / 100)
end

function M:GetFilterIntensity()
  return self.Camera:GetFilterIntensity() * 100
end

function M:SetFilterIntensity(Intensity)
  self.bHasAnyOperation = true
  self:AddTimer(0.1, function()
    self.Camera:SetFilterIntensity(Intensity / 100)
  end)
end

function M:GetFilterData()
  return self.Camera:GetFilterData()
end

function M:GetFilterType()
  return self.Camera:GetFilterType()
end

function M:SetFilter(EFilterType)
  self.bHasAnyOperation = true
  self.Camera:SetFilter(EFilterType)
end

function M:BindEventOnCameraChanged(Owner, Func)
  rawset(self, "_OnCameraChangedOwner", Owner)
  rawset(self, "_OnCameraChanged", Func)
end

function M:FireEventOnCameraChanged()
  if self._OnCameraChanged then
    self._OnCameraChanged(self._OnCameraChangedOwner, self.CurCameraIndex)
  end
end

function M:BindEventOnGuideLineChanged(Owner, Func, Params)
  rawset(self, "_OnGuideLineChangedOwner", Owner)
  rawset(self, "_OnGuideLineChanged", Func)
  rawset(self, "_OnGuideLineChangedArgs", Params)
end

function M:FireEventOnGuideLineChanged()
  self:SetIsShowGuideLine(self:GetIsShowGuideLine())
  if self._OnGuideLineChanged then
    self._OnGuideLineChanged(self._OnGuideLineChangedOwner, self:GetIsShowGuideLine(), self._OnGuideLineChangedArgs)
  end
end

function M:BindEventOnFocusMethodChanged(Owner, Func, Params)
  rawset(self, "_OnFocusMethodChangedOwner", Owner)
  rawset(self, "_OnFocusMethodChanged", Func)
  rawset(self, "_OnFocusMethodChangedArgs", Params)
end

function M:FireEventOnFocusMethodChanged()
  if self._OnFocusMethodChanged then
    self._OnFocusMethodChanged(self._OnFocusMethodChangedOwner, self:IsFocusMethodEnabled(), self._OnFocusMethodChangedArgs)
  end
end

function M:BindEventOnRollChanged(Owner, Func)
  rawset(self, "_OnRollChangedOwner", Owner)
  rawset(self, "_OnRollChanged", Func)
end

function M:FireEventOnRollChanged()
  if self._OnRollChanged then
    self._OnRollChanged(self._OnRollChangedOwner, self.Camera.DesiredRotation.Roll)
  end
end

function M:ChangeCamera()
  self:FireEventOnCameraChanged()
  self:FireEventOnGuideLineChanged()
  self:FireEventOnRollChanged()
  self:FireEventOnFocusMethodChanged()
end

function M:SetRoll(DesiredRoll, bNotifyEvent)
  if bNotifyEvent then
    self:FireEventOnRollChanged()
  end
end

function M:RotateCameraRoll(Roll)
  self:FireEventOnRollChanged()
end

return M
