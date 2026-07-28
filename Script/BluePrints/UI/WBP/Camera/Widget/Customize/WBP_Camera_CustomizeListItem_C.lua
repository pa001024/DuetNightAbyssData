require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local SwitcherIndex = {
  [Utils.ItemType.Action] = 0,
  [Utils.ItemType.Switch] = 1,
  [Utils.ItemType.Selection] = 2,
  [Utils.ItemType.Slide] = 3
}

local function StopWidgetNavigation(Widget)
  if not Widget then
    return
  end
  local Rule = not EUINavigationRule and UE4 and UE4.EUINavigationRule
  if Widget.SetAllNavigationRules and Rule then
    Widget:SetAllNavigationRules(Rule.Stop, 0)
    return
  end
  local Navigation = UE4 and UE4.EUINavigation or EUINavigation
  if Widget.SetNavigationRuleBase and Navigation and Rule then
    Widget:SetNavigationRuleBase(Navigation.Up, Rule.Stop)
    Widget:SetNavigationRuleBase(Navigation.Down, Rule.Stop)
    Widget:SetNavigationRuleBase(Navigation.Left, Rule.Stop)
    Widget:SetNavigationRuleBase(Navigation.Right, Rule.Stop)
  end
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Config = Content and Content.Config
  self.OwnerPanel = Content and Content.OwnerPanel
  if Content and Content.ParentList then
    Content.ParentList:RegisterEntry(Content, self)
  end
  self:Init(self.Config, self.OwnerPanel)
end

function M:Init(ItemConfig, OwnerPanel)
  self.Config = ItemConfig
  self.OwnerPanel = OwnerPanel
  self.bWasFocused = false
  self.bFocusAnimInited = false
  local Widget = self:GetActiveChild()
  Utils.SetSwitcherWidget(self.WS_Item, Widget, SwitcherIndex[ItemConfig and ItemConfig.Type])
  if Widget and Widget.Init then
    Widget:Init(ItemConfig, OwnerPanel)
  end
  self:ApplyOuterOnlyGamePadNavigation()
  self:RefreshNewState()
  self:RefreshFocus()
end

function M:GetActiveChild()
  if not self.Config then
    return nil
  end
  if self.Config.Type == Utils.ItemType.Action then
    return self.Action
  elseif self.Config.Type == Utils.ItemType.Switch then
    return self.SwitchCheckBox
  elseif self.Config.Type == Utils.ItemType.Selection then
    return self.SelectionCheckBox
  elseif self.Config.Type == Utils.ItemType.Slide then
    return self.Slide
  end
end

function M:IsOuterOnlyGamePadItem()
  return self.Config and (self.Config.Type == Utils.ItemType.Switch or self.Config.Type == Utils.ItemType.Slide)
end

function M:ApplyOuterOnlyGamePadNavigation()
  if not self:IsOuterOnlyGamePadItem() then
    return
  end
  StopWidgetNavigation(self)
  local Widget = self:GetActiveChild()
  StopWidgetNavigation(Widget)
  if self.Config.Type == Utils.ItemType.Switch then
    StopWidgetNavigation(Widget and Widget.CheckBox)
    StopWidgetNavigation(Widget and Widget.CheckBox and Widget.CheckBox.ButtonArea)
    StopWidgetNavigation(Widget and Widget.CheckBox and Widget.CheckBox.Btn_Click)
  elseif self.Config.Type == Utils.ItemType.Slide then
    StopWidgetNavigation(Widget and Widget.Slider)
    StopWidgetNavigation(Widget and Widget.Slider and Widget.Slider.Btn_Add)
    StopWidgetNavigation(Widget and Widget.Slider and Widget.Slider.Btn_Sub)
    StopWidgetNavigation(Widget and Widget.Slider and Widget.Slider.Slider)
  end
end

function M:EnsureOuterGamePadFocus()
  if not (self:IsOuterOnlyGamePadItem() and self.Content) or self.Content.IsFocused ~= true then
    return
  end
  local ParentList = self.Content.ParentList
  if ParentList and ParentList.UpdateGamePadFocusWidget then
    ParentList:UpdateGamePadFocusWidget(self.Content, true)
  end
end

function M:Refresh(NewState)
  self:RefreshValue(NewState)
  self:RefreshNewState()
  self:RefreshFocus()
end

function M:RefreshValue(NewState)
  local Widget = self:GetActiveChild()
  if Widget and Widget.RefreshValue then
    Widget:RefreshValue(NewState)
  elseif Widget and Widget.Refresh then
    Widget:Refresh(NewState)
  end
end

function M:RefreshNewState()
  local Widget = self:GetActiveChild()
  if Widget and Widget.RefreshNewState then
    Widget:RefreshNewState()
  elseif Widget and Widget.Refresh then
    Widget:Refresh()
  end
end

function M:RefreshFocus(FocusEnterReason)
  local Widget = self:GetActiveChild()
  local bFocused = self.Content and self.Content.IsFocused == true
  if not self:IsGamePadFocusAnimationEnabled() then
    self:ResetGamePadFocusStyle()
    return
  end
  self:RefreshFocusAnimation(bFocused)
  if Widget and Widget.RefreshFocus then
    Widget:RefreshFocus(bFocused)
  end
  if "Navigation" == FocusEnterReason and bFocused and not self.bWasFocused and Widget and Widget.OnParentFocusGained then
    Widget:OnParentFocusGained()
  end
  if bFocused then
    self:EnsureOuterGamePadFocus()
  end
  self.bWasFocused = bFocused
end

function M:IsGamePadFocusAnimationEnabled()
  local Host = self.OwnerPanel and self.OwnerPanel.OwnerPanel
  return Host and Host.IsCustomizeOpened and Host:IsCustomizeOpened() == true and Host.IsCameraCustomizeGamePadInput and true == Host:IsCameraCustomizeGamePadInput()
end

function M:PlayFocusAnimation(Animation)
  if Animation and self.PlayAnimation then
    self:PlayAnimation(Animation)
  end
end

function M:RefreshFocusAnimation(bFocused)
  if not self:IsGamePadFocusAnimationEnabled() then
    self:ResetGamePadFocusStyle()
    return
  end
  if not self.bFocusAnimInited then
    self.bFocusAnimInited = true
    self:PlayFocusAnimation(bFocused and self.Hover or self.Normal)
    return
  end
  if bFocused == self.bWasFocused then
    return
  end
  self:PlayFocusAnimation(bFocused and self.Hover or self.UnHover or self.Normal)
end

function M:ResetGamePadFocusStyle()
  self.bFocusAnimInited = false
  self.bWasFocused = false
  self:PlayFocusAnimation(self.Normal)
  local Widget = self:GetActiveChild()
  if Widget and Widget.ResetGamePadFocusStyle then
    Widget:ResetGamePadFocusStyle()
  elseif Widget and Widget.RefreshFocus then
    Widget:RefreshFocus(false)
  end
end

function M:ClearNew()
  local Widget = self:GetActiveChild()
  if Widget and Widget.ClearNew then
    Widget:ClearNew()
  end
end

function M:HandleConfirm()
  local Widget = self:GetActiveChild()
  if Widget and Widget.HandleConfirm then
    return Widget:HandleConfirm() ~= false
  end
  return false
end

function M:GetControllerOpInfo()
  if not self.Config then
    return nil
  end
  if self.Config.Type == Utils.ItemType.Switch then
    return {
      Key = "A",
      TextKey = "UI_CTL_On/Off"
    }
  elseif self.Config.Type == Utils.ItemType.Action then
    local Widget = self:GetActiveChild()
    if Widget and Widget.GetControllerOpInfo then
      return Widget:GetControllerOpInfo()
    end
    return {
      Key = "A",
      TextKey = "UI_CTL_Play"
    }
  end
  return nil
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandlePreviewGamePadKey(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleGamePadKeyUp(InKeyName) then
    self:EnsureOuterGamePadFocus()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold or InKeyName == UIConst.GamePadKey.RightStickLeft or InKeyName == UIConst.GamePadKey.RightStickRight then
    self:EnsureOuterGamePadFocus()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:HandlePreviewGamePadKey(InKeyName)
  if not self.Content or self.Content.IsFocused ~= true then
    return false
  end
  local ParentList = self.Content.ParentList
  if self.Config and self.Config.Type == Utils.ItemType.Action and (InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadRight) then
    return true == self:HandleGamePadDirection(InKeyName)
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    local bHandled = self:HandleConfirm()
    self:EnsureOuterGamePadFocus()
    return bHandled
  elseif InKeyName == UIConst.GamePadKey.DPadUp then
    if ParentList and ParentList.MoveFocus then
      ParentList:MoveFocus(-1)
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadDown then
    if ParentList and ParentList.MoveFocus then
      ParentList:MoveFocus(1)
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadLeft then
    self:HandleLeftRight(-1)
    self:EnsureOuterGamePadFocus()
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    self:HandleLeftRight(1)
    self:EnsureOuterGamePadFocus()
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold or InKeyName == UIConst.GamePadKey.RightStickLeft or InKeyName == UIConst.GamePadKey.RightStickRight then
    self:HandleGamePadKeyDown(InKeyName)
    self:EnsureOuterGamePadFocus()
    return true
  end
  local Host = self.OwnerPanel and self.OwnerPanel.OwnerPanel
  if Host and Host.HandleCameraCustomizeGamePadDown then
    return true == Host:HandleCameraCustomizeGamePadDown(InKeyName)
  end
  return false
end

function M:HandleLeftRight(Delta)
  local Widget = self:GetActiveChild()
  if Widget and Widget.HandleLeftRight then
    return Widget:HandleLeftRight(Delta)
  end
  return false
end

function M:HandleGamePadDirection(DirectionKey)
  local Widget = self:GetActiveChild()
  if Widget and Widget.HandleGamePadDirection then
    return Widget:HandleGamePadDirection(DirectionKey)
  end
  return false
end

function M:HandleGamePadKeyDown(InKeyName)
  local Widget = self:GetActiveChild()
  if Widget and Widget.HandleGamePadKeyDown then
    return Widget:HandleGamePadKeyDown(InKeyName)
  elseif Widget and Widget.Handle_KeyDownEventOnGamePad then
    return Widget:Handle_KeyDownEventOnGamePad(InKeyName)
  end
  return false
end

function M:HandleGamePadKeyUp(InKeyName)
  local Widget = self:GetActiveChild()
  if Widget and Widget.HandleGamePadKeyUp then
    return Widget:HandleGamePadKeyUp(InKeyName)
  elseif Widget and Widget.Handle_KeyUpEventOnGamePad then
    return Widget:Handle_KeyUpEventOnGamePad(InKeyName)
  end
  return false
end

function M:HandleGamePadAnalog(AxisName, DirectionKey, Value)
  local Widget = self:GetActiveChild()
  if Widget and Widget.HandleGamePadAnalog then
    return Widget:HandleGamePadAnalog(AxisName, DirectionKey, Value)
  end
  return false
end

return M
