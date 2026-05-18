local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self:BindButtonPerformances()
  self.SelectGlowFX = self.Select_Glow
  self.OnClickEvent = nil
  self.Checked = false
  self.IsEnabled = true
  self.IsHovering = false
  self.IsPressing = false
  self.SelectGlow = nil
end

function M:Destruct()
  self.OnClickEvent = nil
  self:UnBindButtonPerformances()
end

function M:Init(Index, ChangeAttrPage, IsEnabled)
  if not ChangeAttrPage then
    GWorld.logger.error("WBP_Abyss_AttributeSelection_C@Init, ChangeAttrPage is nil!")
    return
  end
  self.Checked = false
  self.IsHovering = false
  self.IsPressing = false
  self.Index = Index
  self.ChangeAttrPage = ChangeAttrPage
  self:SetEnableState(true == IsEnabled, true)
end

function M:SetAttribute(AttrId, AttrIcon)
  self.AttrId = AttrId
  if IsValid(AttrIcon) then
    local IconMaterial = self.Attribute and self.Attribute:GetDynamicMaterial()
    if IconMaterial then
      IconMaterial:SetTextureParameterValue("MainTex", AttrIcon)
    end
  end
  local Color = self["Color_" .. AttrId]
  if IsValid(self.SelectGlowFX) then
    self.SelectGlowFX:SetColorAndOpacity(Color and Color.SpecifiedColor)
  end
end

function M:OnClicked()
  if self.ChangeAttrPage then
    self.ChangeAttrPage:AttrSelectionChanged(self.Index)
  else
    GWorld.logger.error("WBP_Abyss_AttributeSelection_C@OnClicked, ChangeAttrPage is nil!")
  end
end

function M:OnForbiddenClicked()
  if self.ChangeAttrPage then
    self.ChangeAttrPage:OnForbiddenAttrClicked(self.AttrId)
  end
end

function M:BindSelectGlow(SelectGlow)
  self.SelectGlow = SelectGlow
end

function M:PlaySelectGlow(IsChecked, bIniting)
  if not self.SelectGlow then
    return
  end
  if IsChecked then
    local SelectAnim = bIniting and self.SelectGlow.Select_In or self.SelectGlow.Select
    self.SelectGlow:StopAnimation(self.SelectGlow.Unselect)
    if SelectAnim then
      self.SelectGlow:PlayAnimation(SelectAnim)
    end
  elseif self.SelectGlow.Unselect then
    self.SelectGlow:StopAnimation(self.SelectGlow.Select)
    self.SelectGlow:StopAnimation(self.SelectGlow.Select_In)
    self.SelectGlow:PlayAnimation(self.SelectGlow.Unselect)
  end
end

function M:SetEnableState(IsEnabled, bIniting)
  self.IsEnabled = IsEnabled
  if not self.IsEnabled then
    local bWasChecked = self.Checked == true
    self.Checked = false
    self.IsHovering = false
    self.IsPressing = false
    if bWasChecked or bIniting then
      self:PlaySelectGlow(false)
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Forbidden)
  elseif self.Checked == true then
    self:PlayButtonCheckAnimation()
  else
    self:SwitchNormalAnimation()
  end
end

function M:IsBtnEnabled()
  return self.IsEnabled == true
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.IsEnabled == true and self.ChangeAttrPage.UsingGamepad then
    self:OnBtnClicked()
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:BindButtonPerformances()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
  self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
  self:BindToAnimationFinished(self.Click, {
    self,
    self.OnClickAnimationFinished
  })
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
  end
end

function M:UnBindButtonPerformances()
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnPressed:Clear()
  self.Btn_Click.OnReleased:Clear()
  self:UnbindFromAnimationFinished(self.Click, {
    self,
    self.OnClickAnimationFinished
  })
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnhovered:Clear()
  end
end

function M:SwitchNormalAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:PlayButtonClickSound()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_challenge_type_select_btn_click", nil, nil)
end

function M:PlayButtonClickAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnBtnClicked()
  if not self:IsBtnEnabled() then
    self:OnForbiddenClicked()
    return
  end
  if self.Checked == false then
    self:SetIsChecked(true, true)
    self:OnClicked()
  end
end

function M:PlayButtonPressAnim()
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnBtnPressed()
  if not self:IsBtnEnabled() then
    return
  end
  if self.Checked == true then
    return
  end
  self:PlayButtonClickSound()
  self.IsPressing = true
  self:PlayButtonPressAnim()
end

function M:PlayButtonHoverAnim()
  if not self:IsBtnEnabled() then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnBtnHovered()
  if not self:IsBtnEnabled() then
    return
  end
  if self.Checked == true then
    return
  end
  self.IsHovering = true
  self:PlayButtonHoverAnim()
end

function M:SetBtnHovered(IsHovered)
  if IsHovered then
    self:OnBtnHovered()
  else
    self:OnBtnUnhovered()
  end
end

function M:PlayButtonReleaseButHoverAnim()
  self:StopAllAnimations()
  self:PlayButtonHoverAnim()
end

function M:PlayButtonReleaseAndUnHoverAnim()
  self:StopAllAnimations()
  self:SwitchNormalAnimation()
end

function M:OnBtnReleased()
  if not self:IsBtnEnabled() then
    return
  end
  self.IsPressing = false
  if self.Checked == true then
    return
  end
  if not self.IsHovering then
    self:PlayButtonReleaseAndUnHoverAnim()
  else
    self:PlayButtonReleaseButHoverAnim()
  end
end

function M:PlayButtonUnHoverAnim()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnBtnUnhovered()
  if not self:IsBtnEnabled() then
    return
  end
  self.IsHovering = false
  if self.Checked == true then
    return
  end
  if not self.IsPressing then
    self:PlayButtonUnHoverAnim()
  end
end

function M:SetIsChecked(IsChecked, IsPlaySound, bIniting)
  if not self:IsBtnEnabled() then
    return
  end
  if self.Checked == false and true == IsChecked then
    self.Checked = true
    if IsPlaySound then
      self:PlayCheckSound(true)
    end
    self:PlayButtonCheckAnimation()
    self:PlaySelectGlow(true, bIniting)
  elseif false == IsChecked then
    if self.Checked == true then
      self.Checked = false
      if IsPlaySound then
        self:PlayCheckSound(false)
      end
      self:PlayButtonUnCheckAnimation()
      self:PlaySelectGlow(false, bIniting)
    elseif true == bIniting then
      self:PlaySelectGlow(false, bIniting)
    end
  end
end

function M:PlayButtonCheckAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Select)
end

function M:PlayButtonUnCheckAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.UnSelect)
end

function M:PlayCheckSound(IsChecked)
  if IsChecked then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
  else
  end
end

return M
