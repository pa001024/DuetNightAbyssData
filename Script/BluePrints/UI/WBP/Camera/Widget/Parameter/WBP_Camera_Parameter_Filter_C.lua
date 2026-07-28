require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Camera.Widget.Parameter.Camera_Parameter_Widget_Base"
})

function M:SetTitle(Text)
  self.Text:SetText(Text)
end

function M:Init(Content)
  M.Super.Init(self, Content)
  rawset(self, "Config", Content.Config)
  rawset(self, "FilterData", Content.FilterData)
  rawset(self, "RedDotInfos", Content.RedDotInfos or {})
  rawset(self, "_OnItemSelectionChanged", Content.OnItemSelectionChanged)
  self:CreateContents()
  self:InitList(Content.CurrentFilter)
end

function M:CreateContents()
  if self.ItemContents then
    return self.ItemContents
  end
  self.ItemContents = {}
  local NoneItem = NewObject(UIUtils.GetCommonItemContentClass())
  rawset(NoneItem, "Data", {
    TextmapID = "UI_CameraSystem_LensParam_NoFilter"
  })
  rawset(NoneItem, "Owner", self)
  rawset(NoneItem, "OnClicked", self.OnFilterItemSelectionChanged)
  rawset(NoneItem, "OnAddedToFocusPath", self.OnItemAddedToFocusPath)
  table.insert(self.ItemContents, NoneItem)
  for _, Item in ipairs(self.FilterData or {}) do
    local Obj = {}
    rawset(Obj, "Data", Item)
    rawset(Obj, "Owner", self)
    rawset(Obj, "RedDotType", self.RedDotInfos[Item.ID] or nil)
    rawset(Obj, "OnClicked", self.OnFilterItemSelectionChanged)
    rawset(Obj, "OnAddedToFocusPath", self.OnItemAddedToFocusPath)
    table.insert(self.ItemContents, Obj)
  end
  return self.ItemContents
end

function M:InitList(CurrentFilter)
  local UIMgr = UIManager(self)
  self.Panel_Filter:ClearChildren()
  for index, value in ipairs(self.ItemContents) do
    if value.Data.PPEnum == CurrentFilter then
      self:SetSelectedFilterItem(value)
    end
    local Widget = UIMgr:CreateWidget(self.EntryClass)
    self.Panel_Filter:AddChild(Widget)
    Widget.bIsFocusable = true
    Widget:OnListItemObjectSet(value)
  end
  self:InitNavigationRules()
end

function M:InitNavigationRules()
  local AllWidget = self.Panel_Filter:GetAllChildren():ToTable() or {}
  local WidgetPerRow = 2
  for index, Widget in ipairs(AllWidget) do
    local ZeroIndex = index - 1
    local Row = math.floor(ZeroIndex / WidgetPerRow)
    local Col = ZeroIndex % WidgetPerRow
    if 0 == Col then
      Widget.Btn_Click:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Escape)
    else
      Widget.Btn_Click:SetNavigationRuleExplicit(UE4.EUINavigation.Left, AllWidget[index - 1])
    end
    if Col == WidgetPerRow - 1 or not AllWidget[index + 1] then
      Widget.Btn_Click:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Escape)
    else
      Widget.Btn_Click:SetNavigationRuleExplicit(UE4.EUINavigation.Right, AllWidget[index + 1])
    end
    if 0 == Row then
      Widget.Btn_Click:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Escape)
    else
      Widget.Btn_Click:SetNavigationRuleExplicit(UE4.EUINavigation.Up, AllWidget[index - WidgetPerRow])
    end
    if not AllWidget[index + WidgetPerRow] then
      Widget.Btn_Click:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Escape)
    else
      Widget.Btn_Click:SetNavigationRuleExplicit(UE4.EUINavigation.Down, AllWidget[index + WidgetPerRow])
    end
  end
end

function M:OnFilterItemSelectionChanged(FilterItem)
  self:SetSelectedFilterItem(FilterItem)
  if self._OnItemSelectionChanged then
    self._OnItemSelectionChanged(self.Owner, FilterItem, self.Content)
  end
end

function M:SetSelectedFilterItem(FilterItem)
  if self.SelectedFilterItem then
    self.SelectedFilterItem.IsSelected = false
    if self.SelectedFilterItem.Widget then
      self.SelectedFilterItem.Widget:SetIsSelected(false)
    end
  end
  self.SelectedFilterItem = FilterItem
  if self.SelectedFilterItem then
    self.SelectedFilterItem.IsSelected = true
    if self.SelectedFilterItem.Widget then
      self.SelectedFilterItem.Widget:SetIsSelected(true)
    end
  end
end

function M:OnConfirmKeyDown()
  return UIUtils.Handled, true
end

function M:OnItemAddedToFocusPath(Widget)
  DebugPrint("OnItemAddedToFocusPath", Widget)
  rawset(self, "FocusedWidget", Widget)
  if self.IsGamePadInput then
    DebugPrint("ScrollWidgetIntoView", Widget)
    self.Owner.ScrollBox_Parameter:ScrollWidgetIntoView(Widget, false, 0)
  end
end

function M:GetDesiredFocusTarget()
  if not self.IsGamePadInput then
    return self
  end
  if IsValid(self.FocusedWidget) then
    return self.FocusedWidget
  end
  return self.Panel_Filter:GetChildAt(0)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  if rawget(self, "IsInFocusPath") then
    local Widget = self:GetDesiredFocusTarget()
    if IsValid(Widget) then
      Widget:SetFocus()
    end
  end
end

return M
