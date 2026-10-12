require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local DEFAULT_FILTER_SLIDER_VALUE = 50
local FORBIDDEN_FILTER_INTENSITY = 100
local ANALOG_DEAD_ZONE = 0.35
local LEFT_STICK_X_KEY_NAME = "Gamepad_LeftX"
local FILTER_SLIDER_AXIS_NAME = "FilterIntensity"

function M:Initialize(Initializer)
  self.Content = nil
  self.HostPage = nil
  self.bSliderExpanded = false
  self.IsBindingFinished = false
  self.bFilterSliderInited = false
  self.GamepadAdjustingAxisName = nil
end

function M:OnListItemObjectSet(ListItemObject)
  self.Content = ListItemObject
  self.HostPage = ListItemObject and ListItemObject.OwnerPage or nil
  self:_BindTitleEvents()
  self:_InitFilterSlider()
  self:RefreshEntry()
  if not self.bSliderExpanded then
    self:_PlayTitleNormal()
  end
end

function M:BP_OnEntryReleased()
  self:EndCurrentSliderAdjust()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  self:SetSliderExpanded(false, true)
  self.Content = nil
  self.HostPage = nil
end

function M:RefreshEntry()
  local Content = self.Content
  if not Content then
    return
  end
  if self:_IsNoneFilterItem() then
    if self.Text_Title_DetailItem then
      self.Text_Title_DetailItem:SetText(GText("UI_PersonalPage_None"))
    end
    if self.WS_Icon then
      self.WS_Icon:SetActiveWidgetIndex(0)
    end
    self:SyncSliderExpandFromHost()
    return
  end
  if self.Text_Title_DetailItem then
    self.Text_Title_DetailItem:SetText(Content.Name or "")
  end
  if self.WS_Icon then
    if Content.Icon then
      local Texture = LoadObject(Content.Icon)
      if Texture and self.Image_Icon then
        self.Image_Icon:SetBrushFromTexture(Texture, true)
      end
      self.WS_Icon:SetActiveWidgetIndex(1)
    else
      self.WS_Icon:SetActiveWidgetIndex(0)
    end
  end
  self:SyncSliderExpandFromHost()
end

function M:SyncSliderExpandFromHost()
  local bSelected = self.HostPage and self.HostPage.IsFilterEntrySelected and self.HostPage:IsFilterEntrySelected(self.Content)
  self:SetSliderExpanded(true == bSelected, true)
end

function M:SetSliderExpanded(bExpanded, bSilent)
  bExpanded = true == bExpanded
  local bIsNone = self:_IsNoneFilterItem()
  local bShowSlider = bExpanded and not bIsNone and not self:_IsIntensityAdjustForbidden()
  if self.bSliderExpanded == bExpanded then
    if self.Group_Select then
      self.Group_Select:SetVisibility(bExpanded and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    end
    if self.SliderItem then
      self.SliderItem:SetVisibility(bShowSlider and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
      if bShowSlider then
        self:_RefreshFilterSliderInputStyle()
      end
    end
    return
  end
  self.bSliderExpanded = bExpanded
  if self.Group_Select then
    self.Group_Select:SetVisibility(bExpanded and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if bExpanded then
    self:_PlayTitleClickHold()
    if bShowSlider then
      local Intensity = self:_ResolveExpandIntensity()
      if self.SliderItem then
        self.SliderItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:_SetFilterSliderIntensity(Intensity)
        self:_RefreshFilterSliderInputStyle()
      end
      self:_ApplyCachedFilterEffect(Intensity)
    else
      if self.SliderItem then
        self.SliderItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      if not bIsNone then
        self:_ApplyCachedFilterEffect(FORBIDDEN_FILTER_INTENSITY)
      end
    end
  else
    self:EndCurrentSliderAdjust()
    if self.SliderItem then
      self.SliderItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:_PlayTitleNormal()
  end
end

function M:PlayEntryIn()
  if not self.In then
    return
  end
  self:StopAnimation(self.In)
  self:PlayAnimation(self.In)
end

function M:PrepareEntryIn()
  local Overlay = self.Overlay_Root
  if not Overlay and self.GetWidgetFromName then
    Overlay = self:GetWidgetFromName("Overlay_Root")
  end
  if Overlay then
    Overlay:SetRenderOpacity(0)
  end
  if self.In then
    self:StopAnimation(self.In)
  end
end

function M:OnClickFilterButton()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_content", nil, nil)
  if not self.bSliderExpanded and self.Click then
    self:PlayAnimation(self.Click)
  end
  if not (self.Content and self.HostPage) or not self.HostPage.RequestToggleFilterItem then
    return
  end
  if self:_IsNoneFilterItem() then
    self.HostPage:RequestToggleFilterItem(nil)
    if self:_IsGamepadInput() then
      self:FocusGamepadTitle()
    end
    return
  end
  self.HostPage:RequestToggleFilterItem(self.Content.FilterId)
  if self:_IsGamepadInput() and not self:FocusFilterSlider() then
    self:FocusGamepadTitle()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.FaceButtonBottom then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self:_IsFilterSliderFocused() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:OnClickFilterButton()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= LEFT_STICK_X_KEY_NAME then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if not self:_IsFilterSliderFocused() then
    self:EndCurrentSliderAdjust()
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  local AxisValue = AnalogValue or 0
  if math.abs(AxisValue) <= ANALOG_DEAD_ZONE then
    self:EndCurrentSliderAdjust()
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:BeginSliderAdjustIfNeeded(FILTER_SLIDER_AXIS_NAME)
  if self.SliderItem and self.SliderItem.HandleLeftStickXInput and self.SliderItem:HandleLeftStickXInput(AxisValue) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:FocusFilterSlider()
  if not self:_CanFocusFilterSlider() then
    return false
  end
  self:_RefreshFilterSliderInputStyle()
  if self.SliderItem.SetFocus then
    self.SliderItem:SetFocus()
  end
  return true
end

function M:FocusGamepadTitle()
  if self.Btn_Click and self.Btn_Click.SetFocus then
    self.Btn_Click:SetFocus()
    return true
  end
  return false
end

function M:OnGamepadBackFromSlider()
  self:EndCurrentSliderAdjust()
  return self:FocusGamepadTitle()
end

function M:OnAddedToFocusPath(InFocusEvent)
  if not self:_IsGamepadInput() then
    return
  end
  if self.HostPage and self.HostPage.ScrollGamepadFocusedWidgetIntoView then
    self.HostPage:ScrollGamepadFocusedWidgetIntoView(self)
  end
  if self:_IsFilterSliderFocused() then
    return
  end
  if self.SliderItem and self.SliderItem.HasFocusedDescendants and self.SliderItem:HasFocusedDescendants() then
    return
  end
  if self.HasUserFocus and self:HasUserFocus() then
    self:FocusGamepadTitle()
  end
end

function M:BeginSliderAdjustIfNeeded(AxisName)
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

function M:EndCurrentSliderAdjust()
  if not self.GamepadAdjustingAxisName then
    return
  end
  self:OnEndTransformSliderDrag(self.GamepadAdjustingAxisName)
  self.GamepadAdjustingAxisName = nil
end

function M:_HandleSliderFocused(AxisName)
  self:_RefreshFilterSliderInputStyle()
  if self.SliderItem and self.SliderItem.SetGamepadFocused then
    self.SliderItem:SetGamepadFocused(true)
  end
end

function M:_HandleSliderFocusLost(AxisName)
  self:EndCurrentSliderAdjust()
  if self.SliderItem and self.SliderItem.SetGamepadFocused then
    self.SliderItem:SetGamepadFocused(false)
  end
end

function M:OnTitleHovered()
  if self.bSliderExpanded then
    return
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnTitleUnhovered()
  if self.bSliderExpanded then
    return
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:BindToAnimationFinished(self.UnHover, {
      self,
      self._OnTitleUnHoverFinished
    })
    self:PlayAnimation(self.UnHover)
    return
  end
  self:_PlayTitleNormal()
end

function M:OnTitlePressed()
  if self.bSliderExpanded then
    return
  end
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:OnBeginTransformSliderDrag(AxisName)
  if self.HostPage and self.HostPage.BeginFilterIntensityPreview then
    self.HostPage:BeginFilterIntensityPreview()
  end
end

function M:OnEndTransformSliderDrag(AxisName)
  if self.HostPage and self.HostPage.CommitFilterIntensityPreview then
    self.HostPage:CommitFilterIntensityPreview()
  end
end

function M:OnTransformSliderValueChanged(AxisName, SliderValue)
  self:SetSliderTextValue(SliderValue)
  if self:_IsNoneFilterItem() then
    return
  end
  local Intensity = math.floor((SliderValue or 0) * 100 + 0.5)
  self:_ApplyCachedFilterEffect(Intensity)
  local FilterId = self.Content and self.Content.FilterId or nil
  if nil ~= FilterId and self.HostPage and self.HostPage.PreviewFilterIntensity then
    self.HostPage:PreviewFilterIntensity(FilterId, Intensity)
  end
end

function M:SetFilterIntensityPresentation(Intensity)
  self:_SetFilterSliderIntensity(Intensity)
  self:_ApplyCachedFilterEffect(Intensity)
end

function M:SetSliderTextValue(Value)
  if not self.SliderItem or not self.SliderItem.Text_Num then
    return
  end
  local DisplayValue = math.floor((Value or 0) * 100 + 0.5)
  self.SliderItem.Text_Num:SetText(tostring(DisplayValue))
end

function M:ApplyFilterEffect(FilterData, Intensity)
  local HostPage = self.HostPage
  local Controller = HostPage and HostPage.EditRootController or nil
  local DisplayController = Controller and Controller.DisplayController or nil
  if not DisplayController or not DisplayController.ApplyFilterEffect then
    return
  end
  if nil == FilterData then
    DisplayController:ApplyFilterEffect(nil)
    return
  end
  DisplayController:ApplyFilterEffect({
    FilterId = FilterData.FilterId or FilterData.Id,
    Intensity = Intensity
  })
end

function M:Destruct()
  self:EndCurrentSliderAdjust()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  self.Content = nil
  self.HostPage = nil
  self.bSliderExpanded = nil
  self.IsBindingFinished = nil
  self.bFilterSliderInited = nil
  self.GamepadAdjustingAxisName = nil
end

function M:_IsNoneFilterItem()
  return self.Content == nil or nil == self.Content.FilterId
end

function M:_IsIntensityAdjustForbidden()
  local Content = self.Content
  return nil ~= Content and Content.ForbidIntensityAdjust == true
end

function M:_IsGamepadInput()
  if UIUtils and UIUtils.IsGamepadInput then
    return UIUtils.IsGamepadInput() == true
  end
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

function M:_CanFocusFilterSlider()
  return self.bSliderExpanded == true and not self:_IsNoneFilterItem() and not self:_IsIntensityAdjustForbidden() and self.SliderItem ~= nil and IsValid(self.SliderItem)
end

function M:_IsFilterSliderFocused()
  return self.SliderItem ~= nil and IsValid(self.SliderItem) and self.SliderItem.HasAnyUserFocus and self.SliderItem:HasAnyUserFocus() == true
end

function M:_RefreshFilterSliderInputStyle()
  if not self.SliderItem or not self.SliderItem.RefreshInputStyle then
    return
  end
  local InputType = UIUtils.UtilsGetCurrentInputType()
  local GamepadName = UIUtils.UtilsGetCurrentGamepadName and UIUtils.UtilsGetCurrentGamepadName() or nil
  self.SliderItem:RefreshInputStyle(InputType, GamepadName)
end

function M:_ApplyCachedFilterEffect(Intensity)
  if self:_IsNoneFilterItem() then
    self:ApplyFilterEffect(nil)
    return
  end
  local FilterData = self.Content and self.Content.FilterData or nil
  self:ApplyFilterEffect(FilterData, Intensity)
end

function M:_InitFilterSlider()
  if self.bFilterSliderInited or not self.SliderItem then
    return
  end
  if self.SliderItem.InitSliderItem then
    self.SliderItem:InitSliderItem(self, FILTER_SLIDER_AXIS_NAME)
  end
  if self.SliderItem.Text_SliderTitle then
    self.SliderItem.Text_SliderTitle:SetText(GText("UI_PersonalPage_FilterIntensity"))
  end
  if self.SliderItem.SetClickInterval then
    self.SliderItem:SetClickInterval(1)
  end
  self:_RefreshFilterSliderInputStyle()
  self.bFilterSliderInited = true
end

function M:_ResolveExpandIntensity()
  local FilterId = self.Content and self.Content.FilterId or nil
  if nil ~= FilterId and self.HostPage and self.HostPage.GetSelectedFilterIntensity then
    local Intensity = self.HostPage:GetSelectedFilterIntensity(FilterId)
    if type(Intensity) == "number" then
      return Intensity
    end
  end
  return DEFAULT_FILTER_SLIDER_VALUE or 50
end

function M:_SetFilterSliderIntensity(Intensity)
  if not self.SliderItem then
    return
  end
  local Value = Intensity or DEFAULT_FILTER_SLIDER_VALUE or 50
  local NormalizedValue = math.max(0, math.min(1, Value / 100))
  if self.SliderItem.SetSliderValue then
    self.SliderItem:SetSliderValue(NormalizedValue)
  end
  if self.SliderItem.Text_Num then
    self.SliderItem.Text_Num:SetText(tostring(math.floor(Value + 0.5)))
  end
end

function M:_ResetFilterSliderToDefault()
  self:_SetFilterSliderIntensity(DEFAULT_FILTER_SLIDER_VALUE or 50)
end

function M:_BindTitleEvents()
  if self.IsBindingFinished or not self.Btn_Click then
    return
  end
  local Btn = self.Btn_Click
  Btn.OnClicked:Clear()
  Btn.OnClicked:Add(self, self.OnClickFilterButton)
  Btn.OnHovered:Clear()
  Btn.OnHovered:Add(self, self.OnTitleHovered)
  Btn.OnUnhovered:Clear()
  Btn.OnUnhovered:Add(self, self.OnTitleUnhovered)
  Btn.OnPressed:Clear()
  Btn.OnPressed:Add(self, self.OnTitlePressed)
  self.IsBindingFinished = true
end

function M:_OnTitleUnHoverFinished()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  if self.bSliderExpanded then
    return
  end
  self:_PlayTitleNormal()
end

function M:_PlayTitleNormal()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:_PlayTitleClickHold()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Click then
    self:PlayAnimation(self.Click)
  end
end

return M
