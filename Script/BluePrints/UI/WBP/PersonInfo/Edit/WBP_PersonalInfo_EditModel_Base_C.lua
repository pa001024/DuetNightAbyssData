require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M.SliderConfigMap = {
  FrontBack = {
    TitleKey = "UI_Accessory_Rotation_Front",
    Field = "X"
  },
  LeftRight = {
    TitleKey = "UI_Accessory_Rotation_Left",
    Field = "Y"
  },
  Horizontal = {
    TitleKey = "UI_Accessory_Custom_Rotation",
    Field = "Yaw"
  }
}

function M:Construct()
  self.RootEditPage = nil
  self.CurrentTransformEditData = nil
  self.CurrentTransformSliderRangeMap = nil
  self.GameInputModeSubsystem = nil
  self.IsSyncingSliderValue = false
  self.IsBindingFinished = false
end

function M:Destruct()
  if self.EndCurrentSliderAdjust then
    self:EndCurrentSliderAdjust()
  end
  self:RemoveInputMethodChangedListen()
  self.RootEditPage = nil
  self.CurrentTransformEditData = nil
  self.CurrentTransformSliderRangeMap = nil
  self.GameInputModeSubsystem = nil
  self.IsSyncingSliderValue = false
end

function M:InitCharacterEditPanel(RootEditPage)
  self:ApplyCharacterEditContext(RootEditPage)
  self.CurrentTransformEditData = nil
  self.CurrentTransformSliderRangeMap = nil
  self:BindPanelEvents()
  self:AddInputMethodChangedListen()
  self:RefreshView()
end

function M:ApplyCharacterEditContext(RootEditPage)
  self.RootEditPage = RootEditPage
end

function M:BindPanelEvents()
  if self.IsBindingFinished then
    return
  end
  self.Btn_Action.Button_Area.OnClicked:Clear()
  self.Btn_Weapon.Button_Area.OnClicked:Clear()
  self.Btn_Action.Button_Area.OnClicked:Add(self, self.OnClickAction)
  self.Btn_Weapon.Button_Area.OnClicked:Add(self, self.OnClickWeapon)
  self:_InitButtonText()
  self:_BindButtonFocusEvents()
  self:_InitSliderItemWidget("FrontBack", self.EditModel_SliderItem_FrontBack)
  self:_InitSliderItemWidget("LeftRight", self.EditModel_SliderItem_LeftRight)
  self:_InitSliderItemWidget("Horizontal", self.EditModel_SliderItem_Horizontal)
  self.IsBindingFinished = true
end

function M:RefreshView()
  self:RefreshSelectedCharacterPanel()
end

function M:RefreshSelectedCharacterPanel()
  local ViewData = self.RootEditPage:BuildSelectedCharacterViewData()
  local CharData = ViewData.CharData
  local CharCfg = CharData and DataMgr.Char and DataMgr.Char[CharData.CharId] or nil
  self.Text_Name:SetText(CharCfg and GText(CharCfg.CharName) or "")
  self:_RefreshHeadIcon(CharCfg)
  self.Text_TitlePosition:SetText(GText("UI_Accessory_Custom_Location"))
  self.Text_TitleRotate:SetText(GText("UI_Opition_ToCharacter"))
  self.CurrentTransformEditData = {
    X = ViewData.Translation.X or 0,
    Y = ViewData.Translation.Y or 0,
    Z = ViewData.Translation.Z or 0,
    Pitch = ViewData.Rotation.Pitch or 0,
    Yaw = ViewData.Rotation.Yaw or 0,
    Roll = ViewData.Rotation.Roll or 0
  }
  self.CurrentTransformSliderRangeMap = ViewData.TransformRange or {}
  self:_RefreshSliderPresentation("FrontBack")
  self:_RefreshSliderPresentation("LeftRight")
  self:_RefreshSliderPresentation("Horizontal")
end

function M:_InitButtonText()
  self.Btn_Action.Text:SetText(GText("UI_PersonalPage_SetAction"))
  self.Btn_Weapon.Text:SetText(GText("UI_PersonalPage_SetWeapon"))
end

function M:OnClickAction()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self.RootEditPage:OpenActionChoosePage()
end

function M:OnClickWeapon()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self.RootEditPage:OpenWeaponChoosePage()
end

function M:HandleGamepadClickAction()
  return self:_ExecuteGamepadClick(self._CanGamepadOpenCharacterChooseSubPage, self.OnClickAction)
end

function M:HandleGamepadClickWeapon()
  return self:_ExecuteGamepadClick(self._CanGamepadOpenCharacterChooseSubPage, self.OnClickWeapon)
end

function M:FocusGamepadDefaultPanelItem()
  local SliderItem = self:_GetSliderWidget("FrontBack")
  if SliderItem and SliderItem.SetFocus then
    SliderItem:SetFocus()
    return true
  end
  return false
end

function M:OnBeginTransformSliderDrag(AxisName)
  if self.RootEditPage then
    self.RootEditPage:BeginCharacterTransformPreview()
  end
end

function M:OnTransformSliderValueChanged(AxisName, Value)
  if not self.RootEditPage or not self.CurrentTransformEditData then
    return
  end
  local SliderConfig = self:_BuildAxisSliderConfig(AxisName)
  if not SliderConfig then
    return
  end
  local FieldName = SliderConfig.Field
  self.CurrentTransformEditData[FieldName] = self:_ConvertSliderValueToBusinessValue(SliderConfig, Value)
  self.RootEditPage:PreviewCharacterTransform(self.CurrentTransformEditData)
  self:_RefreshSliderPresentation(AxisName)
end

function M:OnEndTransformSliderDrag(AxisName)
  if self.RootEditPage then
    self.RootEditPage:CommitCharacterTransformPreview()
  end
end

function M:AddInputMethodChangedListen()
  local GameInputModeSubsystem = self:_GetGameInputModeSubsystem()
  if not GameInputModeSubsystem then
    return
  end
  GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
  GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:RemoveInputMethodChangedListen()
  local GameInputModeSubsystem = self:_GetGameInputModeSubsystem()
  if not GameInputModeSubsystem then
    return
  end
  GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType ~= ECommonInputType.Gamepad and self.EndCurrentSliderAdjust then
    self:EndCurrentSliderAdjust()
  end
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  self:_RefreshSliderInputStyle("FrontBack")
  self:_RefreshSliderInputStyle("LeftRight")
  self:_RefreshSliderInputStyle("Horizontal")
  self:_RefreshAllSliderGamepadFocusState()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_EditModelGamepadKeyDown and self:Handle_EditModelGamepadKeyDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_EditModelGamepadAnalog then
    local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if self:Handle_EditModelGamepadAnalog(InKeyName, AnalogValue) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:_RefreshSliderPresentation(AxisName)
  local SliderConfig = self:_BuildAxisSliderConfig(AxisName)
  local SliderItem = self:_GetSliderWidget(AxisName)
  if not SliderConfig or not SliderItem then
    return
  end
  local CurrentValue = self.CurrentTransformEditData[SliderConfig.Field] or 0
  SliderItem:RefreshSliderPresentation(SliderConfig, CurrentValue)
end

function M:_InitSliderItemWidget(AxisName, SliderItem)
  SliderItem:InitSliderItem(self, AxisName)
  self:_RefreshSliderInputStyle(AxisName)
end

function M:_GetSliderWidget(AxisName)
  if "FrontBack" == AxisName then
    return self.EditModel_SliderItem_FrontBack
  end
  if "LeftRight" == AxisName then
    return self.EditModel_SliderItem_LeftRight
  end
  if "Horizontal" == AxisName then
    return self.EditModel_SliderItem_Horizontal
  end
  return nil
end

function M:_GetGameInputModeSubsystem()
  if IsValid(self.GameInputModeSubsystem) then
    return self.GameInputModeSubsystem
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if not PlayerController then
    return nil
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  return self.GameInputModeSubsystem
end

function M:_ExecuteGamepadClick(ValidateFunc, ClickFunc, ...)
  if type(ValidateFunc) == "function" and true ~= ValidateFunc(self, ...) then
    return false
  end
  if type(ClickFunc) ~= "function" then
    return false
  end
  ClickFunc(self, ...)
  return true
end

function M:_CanGamepadOpenCharacterChooseSubPage()
  return self.RootEditPage ~= nil and nil ~= self.RootEditPage.HasSelectedCharacter and self.RootEditPage:HasSelectedCharacter() == true
end

function M:_RefreshSliderInputStyle(AxisName)
  local SliderItem = self:_GetSliderWidget(AxisName)
  if not SliderItem then
    return
  end
  local InputType = self.CurInputDeviceType
  if nil == InputType then
    local GameInputModeSubsystem = self:_GetGameInputModeSubsystem()
    InputType = GameInputModeSubsystem and GameInputModeSubsystem:GetCurrentInputType() or ECommonInputType.MouseAndKeyboard
  end
  SliderItem:RefreshInputStyle(InputType, self.CurGamepadName)
  self:_RefreshSingleSliderGamepadFocusState(AxisName)
end

function M:_HandleSliderFocused(AxisName)
  self.GamepadFocusedAxisName = AxisName
  self:_RefreshAllSliderGamepadFocusState()
end

function M:_HandleSliderFocusLost(AxisName)
  if self.GamepadFocusedAxisName == AxisName then
    self.GamepadFocusedAxisName = nil
  end
  self:_RefreshAllSliderGamepadFocusState()
end

function M:_HandleButtonFocused(ButtonName)
  self.GamepadFocusedAxisName = nil
  self:_RefreshAllSliderGamepadFocusState()
end

function M:_RefreshAllSliderGamepadFocusState()
  self:_RefreshSingleSliderGamepadFocusState("FrontBack")
  self:_RefreshSingleSliderGamepadFocusState("LeftRight")
  self:_RefreshSingleSliderGamepadFocusState("Horizontal")
end

function M:_RefreshSingleSliderGamepadFocusState(AxisName)
  local SliderItem = self:_GetSliderWidget(AxisName)
  if not SliderItem or not SliderItem.SetGamepadFocused then
    return
  end
  local bGamepadFocused = self.CurInputDeviceType == ECommonInputType.Gamepad and self.GamepadFocusedAxisName == AxisName
  SliderItem:SetGamepadFocused(bGamepadFocused)
end

function M:_BindButtonFocusEvents()
  if self.Btn_Weapon and self.Btn_Weapon.BindEventOnAddedToFocusPath then
    self.Btn_Weapon:BindEventOnAddedToFocusPath(self, self.OnWeaponButtonAddedToFocusPath)
  end
  if self.Btn_Action and self.Btn_Action.BindEventOnAddedToFocusPath then
    self.Btn_Action:BindEventOnAddedToFocusPath(self, self.OnActionButtonAddedToFocusPath)
  end
end

function M:OnWeaponButtonAddedToFocusPath()
  self:_HandleButtonFocused("Btn_Weapon")
end

function M:OnActionButtonAddedToFocusPath()
  self:_HandleButtonFocused("Btn_Action")
end

function M:_GetHeadImageWidget()
  return self.Image_Head
end

function M:_RefreshHeadIcon(CharCfg)
  local HeadImage = self:_GetHeadImageWidget()
  if not HeadImage then
    return
  end
  local BattleCharConfig = CharCfg and CharCfg.CharId and DataMgr.BattleChar and DataMgr.BattleChar[CharCfg.CharId] or nil
  local GuideIconImg = BattleCharConfig and BattleCharConfig.GuideIconImg or nil
  local HeadIcon
  if GuideIconImg and "" ~= GuideIconImg then
    local IconName = "T_Normal_" .. GuideIconImg
    local HeadIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/" .. IconName .. "." .. IconName .. "'"
    HeadIcon = LoadObject(HeadIconPath)
  end
  local DynamicMaterial = HeadImage:GetDynamicMaterial()
  if DynamicMaterial then
    DynamicMaterial:SetTextureParameterValue("IconMap", HeadIcon)
    return
  end
  HeadImage:SetBrushResourceObject(HeadIcon)
end

function M:_ConvertSliderValueToBusinessValue(SliderConfig, SliderValue)
  local MinValue = SliderConfig.Min or 0
  local MaxValue = SliderConfig.Max or 1
  return MinValue + (MaxValue - MinValue) * (SliderValue or 0)
end

function M:_ConvertBusinessValueToSliderValue(SliderConfig, BusinessValue)
  local MinValue = SliderConfig.Min or 0
  local MaxValue = SliderConfig.Max or 1
  if MaxValue == MinValue then
    return 0
  end
  return math.max(0, math.min(1, (BusinessValue - MinValue) / (MaxValue - MinValue)))
end

function M:_BuildAxisSliderConfig(AxisName)
  local BaseConfig = M.SliderConfigMap[AxisName]
  local AxisRange = self:_GetCurrentAxisRange(BaseConfig.Field)
  return {
    Title = GText(BaseConfig.TitleKey),
    Field = BaseConfig.Field,
    Min = AxisRange.Min,
    Max = AxisRange.Max
  }
end

function M:_GetCurrentAxisRange(FieldName)
  local RangeMap = self.CurrentTransformSliderRangeMap or {}
  local AxisRange = RangeMap[FieldName]
  if AxisRange and AxisRange.Min ~= nil and nil ~= AxisRange.Max then
    return AxisRange
  end
  if "Yaw" == FieldName then
    return {Min = -180, Max = 180}
  end
  if "Z" == FieldName then
    return {Min = -100, Max = 150}
  end
  return {Min = -300, Max = 300}
end

return M
