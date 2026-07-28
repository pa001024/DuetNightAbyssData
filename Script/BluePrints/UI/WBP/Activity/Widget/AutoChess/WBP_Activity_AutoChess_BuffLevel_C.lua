require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(ListItemObject)
  self.Content = ListItemObject
  if not ListItemObject then
    return
  end
  ListItemObject.Widget = self
  self.bIsListItemSelected = false
  if self.Text_BuffName then
    self.Text_BuffName:SetText(ListItemObject.BuffName or "")
  end
  if self.TextDescribe then
    self.TextDescribe:SetText(ListItemObject.BuffDesc or "")
  end
  if self.TextStarNum then
    self.TextStarNum:SetText(tostring(ListItemObject.DifficultyStar or 0))
  end
  if self.Image_Star then
    self.Image_Star:SetVisibility(ListItemObject.DifficultyStar and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.WBP_Com_Btn then
    self.WBP_Com_Btn:UnBindEventOnClickedByObj(self)
    self.WBP_Com_Btn:BindEventOnClicked(self, self.OnBtnClicked)
    if self.WBP_Com_Btn.OverriddenSoundFunc then
      self.WBP_Com_Btn:OverriddenSoundFunc("event:/ui/common/click_btn_minus")
    elseif self.WBP_Com_Btn.TryOverrideSoundFunc then
      self.WBP_Com_Btn:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", "", nil)
      end)
    end
  end
  if self.WBP_Com_KeyImg and self.WBP_Com_KeyImg.CreateGamepadKey then
    self.WBP_Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
  end
  self:RefreshEntryGamepadState()
end

function M:BP_OnItemSelectionChanged(bIsSelected)
  self.bIsListItemSelected = bIsSelected
  self:RefreshEntryGamepadState()
end

function M:BP_OnEntryReleased()
  self.bIsListItemSelected = false
  self.Content = nil
end

function M:RefreshEntryGamepadState()
  if self.WsBtn then
    local bShowGamepadKey = self.Content and self.Content.Owner and UIUtils.IsGamepadInput() and self.Content.Owner.bListLevelGamepadFocused and self.bIsListItemSelected
    self.WsBtn:SetActiveWidgetIndex(bShowGamepadKey and 1 or 0)
  end
  self:InitEntryNavigation()
end

function M:GetNavigationWidgets()
  local Widgets = {self}
  if self.WsBtn and self.WsBtn.GetActiveWidget then
    local ActiveWidget = self.WsBtn:GetActiveWidget()
    if ActiveWidget then
      table.insert(Widgets, ActiveWidget)
    end
  elseif self.WBP_Com_Btn then
    table.insert(Widgets, self.WBP_Com_Btn)
  end
  return Widgets
end

function M:InitEntryNavigation()
  for _, Widget in ipairs(self:GetNavigationWidgets()) do
    if Widget and Widget.SetNavigationRuleCustom then
      Widget:SetNavigationRuleCustom(UE4.EUINavigation.Up, {
        self,
        self.HandleNavigationUp
      })
      Widget:SetNavigationRuleCustom(UE4.EUINavigation.Down, {
        self,
        self.HandleNavigationDown
      })
      Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
      Widget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
    end
  end
end

function M:TryNavigateListLevel(Offset)
  local Owner = self.Content and self.Content.Owner
  if not Owner or not Owner.bListLevelGamepadFocused then
    return nil
  end
  Owner:NavigateListLevelByOffset(Offset)
  return nil
end

function M:HandleNavigationUp()
  return self:TryNavigateListLevel(-1)
end

function M:HandleNavigationDown()
  return self:TryNavigateListLevel(1)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local Owner = self.Content and self.Content.Owner
  if Owner and Owner:HandleListLevelAnalogInput(InAnalogInputEvent) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnBtnClicked()
  if not self.Content or self.Content.IsEmpty then
    return
  end
  if self.Content.Owner and self.Content.Owner.OnLevelItemRemove then
    self.Content.Owner:OnLevelItemRemove(self.Content)
  end
end

return M
