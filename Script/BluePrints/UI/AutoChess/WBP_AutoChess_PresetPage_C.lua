require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.Owner = (...)
  self.Com_Bg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Text_Tip:SetText(GText("UI_RougeLike_End__ClickEmpty"))
  self:InitPresets()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  self:InitButtonNavigation()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_team_preset_in", "AutoChessPresetPage_InSound", nil)
end

function M:InitButtonNavigation()
  self.Preset_01.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
    self,
    function()
      if 0 == self.Preset_02.WS_Type:GetActiveWidgetIndex() then
        self.Preset_02:OnClickPreset()
        return self.Preset_02.Btn_Click
      else
        return self.Preset_02.Btn_Add
      end
    end
  })
  self.Preset_02.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
    self,
    function()
      if 0 == self.Preset_01.WS_Type:GetActiveWidgetIndex() then
        self.Preset_01:OnClickPreset()
        return self.Preset_01.Btn_Click
      else
        return self.Preset_01.Btn_Add
      end
    end
  })
  self.Preset_02.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
    self,
    function()
      if 0 == self.Preset_03.WS_Type:GetActiveWidgetIndex() then
        self.Preset_03:OnClickPreset()
        return self.Preset_03.Btn_Click
      else
        return self.Preset_03.Btn_Add
      end
    end
  })
  self.Preset_03.Btn_Add:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
    self,
    function()
      if 0 == self.Preset_02.WS_Type:GetActiveWidgetIndex() then
        self.Preset_02:OnClickPreset()
        return self.Preset_02.Btn_Click
      else
        return self.Preset_02.Btn_Add
      end
    end
  })
  self.Preset_01.Btn_Add:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Preset_02.Btn_Add:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Preset_03.Btn_Add:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Preset_01.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
    self,
    function()
      if 0 == self.Preset_02.WS_Type:GetActiveWidgetIndex() then
        self.Preset_02:OnClickPreset()
        return self.Preset_02.Btn_Click
      else
        return self.Preset_02.Btn_Add
      end
    end
  })
  self.Preset_02.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
    self,
    function()
      if 0 == self.Preset_01.WS_Type:GetActiveWidgetIndex() then
        self.Preset_01:OnClickPreset()
        return self.Preset_01.Btn_Click
      else
        return self.Preset_01.Btn_Add
      end
    end
  })
  self.Preset_02.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
    self,
    function()
      if 0 == self.Preset_03.WS_Type:GetActiveWidgetIndex() then
        self.Preset_03:OnClickPreset()
        return self.Preset_03.Btn_Click
      else
        return self.Preset_03.Btn_Add
      end
    end
  })
  self.Preset_03.Btn_Click:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
    self,
    function()
      if 0 == self.Preset_02.WS_Type:GetActiveWidgetIndex() then
        self.Preset_02:OnClickPreset()
        return self.Preset_02.Btn_Click
      else
        return self.Preset_02.Btn_Add
      end
    end
  })
  self.Preset_01.Btn_Click:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Preset_02.Btn_Click:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Preset_03.Btn_Click:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

function M:InitPresets()
  self:InitButton()
  self.Preset_01:InitContent({
    IsSet = false,
    Owner = self,
    PresetIndex = 1
  })
  self.Preset_02:InitContent({
    IsSet = false,
    Owner = self,
    PresetIndex = 2
  })
  self.Preset_03:InitContent({
    IsSet = false,
    Owner = self,
    PresetIndex = 3
  })
end

function M:InitButton()
  self.Btn_Close.OnClicked:Add(self, self.CloseSelf)
end

function M:CloseSelf()
  AudioManager(self):SetEventSoundParam(nil, "AutoChessPresetPage_InSound", {ToEnd = 1})
  self:Close()
end

function M:RefreshSelect(PresetIndex)
  self.Preset_01:RefreshSelect(PresetIndex)
  self.Preset_02:RefreshSelect(PresetIndex)
  self.Preset_03:RefreshSelect(PresetIndex)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Right" == InKeyName then
      IsEventHandled = true
      self:CloseSelf()
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:CloseSelf()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:InitKeyboardView()
  self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)
end

function M:InitGamepadView()
  if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
    self.Preset_01:SetFocus()
    self.Preset_01:InitGamepadView()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamepadView()
  elseif CurInputType == ECommonInputType.MouseAndKeyboard then
    self:InitKeyboardView()
  end
end

return M
