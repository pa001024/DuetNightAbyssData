require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local DEFAULT_SCROLL_OFFSET_EPSILON = 0.1

local function StopUINavigation(Widget)
  if not Widget or not Widget.SetNavigationRuleBase then
    return
  end
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
end

local function CanBindUserScrolled(Widget)
  return Widget and Widget.OnUserScrolled and Widget.OnUserScrolled.Add and Widget.OnUserScrolled.Remove
end

local function CanBindEntryLifecycle(Widget)
  return Widget and Widget.BP_OnEntryGenerated and Widget.BP_OnEntryGenerated.Add and Widget.BP_OnEntryGenerated.Remove and Widget.BP_OnEntryReleased and Widget.BP_OnEntryReleased.Add and Widget.BP_OnEntryReleased.Remove
end

local function GetWidgetCount(WidgetArray)
  if not WidgetArray then
    return 0
  end
  if WidgetArray.ToTable then
    return #WidgetArray:ToTable()
  end
  if type(WidgetArray) == "table" then
    return #WidgetArray
  end
  return 0
end

local function GetWidgetArrayTable(WidgetArray)
  if not WidgetArray then
    return {}
  end
  if WidgetArray.ToTable then
    return WidgetArray:ToTable()
  end
  if type(WidgetArray) == "table" then
    return WidgetArray
  end
  return {}
end

local function SetWidgetScrollOffset(Widget, Offset, OffsetEpsilon)
  if not Widget or type(Offset) ~= "number" then
    return false
  end
  if Widget.SetScrollOffset then
    Widget:SetScrollOffset(Offset)
    return true
  end
  if Widget.SetCurrentScrollOffset then
    Widget:SetCurrentScrollOffset(Offset)
    return true
  end
  local Epsilon = type(OffsetEpsilon) == "number" and OffsetEpsilon or DEFAULT_SCROLL_OFFSET_EPSILON
  if Offset <= Epsilon and Widget.ScrollToStart then
    Widget:ScrollToStart()
    return true
  end
  return false
end

local function SetArrowVisible(ArrowWidget, bVisible)
  if ArrowWidget and ArrowWidget.SetVisibility then
    ArrowWidget:SetVisibility(bVisible and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  end
end

function M:StopNativeUINavigation()
  StopUINavigation(self)
  StopUINavigation(self.List_PopItem)
  StopUINavigation(self.ScrollPopItem)
end

function M:GetListView()
  return self.List_PopItem
end

function M:GetScrollBox()
  return self.ScrollPopItem
end

function M:GetViewportWidget()
  return self.ScrollPopItem
end

function M:GetArrowScrollWidget()
  local ScrollPopItem = self:GetScrollBox()
  if ScrollPopItem and ScrollPopItem.GetScrollOffset and ScrollPopItem.GetScrollOffsetOfEnd then
    return ScrollPopItem
  end
  return nil
end

function M:GetScrollOffsetInfo()
  local ScrollWidget = self:GetArrowScrollWidget()
  if not ScrollWidget or not ScrollWidget.GetScrollOffset then
    return nil, nil, nil
  end
  local CurrentOffset = ScrollWidget:GetScrollOffset()
  local EndOffset = ScrollWidget.GetScrollOffsetOfEnd and ScrollWidget:GetScrollOffsetOfEnd() or nil
  return ScrollWidget, CurrentOffset, EndOffset
end

function M:SetScrollOffset(Offset, OffsetEpsilon)
  local ScrollWidget = self:GetArrowScrollWidget() or self:GetScrollBox()
  return SetWidgetScrollOffset(ScrollWidget, Offset, OffsetEpsilon)
end

function M:ResetScrollOffset()
  local ScrollPopItem = self:GetScrollBox()
  if ScrollPopItem then
    if ScrollPopItem.ScrollToStart then
      ScrollPopItem:ScrollToStart()
    elseif ScrollPopItem.SetScrollOffset then
      ScrollPopItem:SetScrollOffset(0)
    end
  end
  local ListPopItem = self:GetListView()
  if not ListPopItem then
    return
  end
  if ListPopItem.ScrollIndexIntoView then
    ListPopItem:ScrollIndexIntoView(0)
    return
  end
  if ListPopItem.NavigateToIndex then
    ListPopItem:NavigateToIndex(0)
  end
end

function M:SetListVisible(bVisible)
  local ListPopItem = self:GetListView()
  if ListPopItem and ListPopItem.SetVisibility then
    ListPopItem:SetVisibility(bVisible and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  end
end

function M:ClearItems()
  local ListPopItem = self:GetListView()
  if ListPopItem and ListPopItem.ClearListItems then
    ListPopItem:ClearListItems()
  end
end

function M:AddItem(Content)
  local ListPopItem = self:GetListView()
  if not ListPopItem or not ListPopItem.AddItem then
    return false
  end
  ListPopItem:AddItem(Content)
  return true
end

function M:GetItems()
  local ListPopItem = self:GetListView()
  if not ListPopItem or not ListPopItem.GetListItems then
    return {}
  end
  return GetWidgetArrayTable(ListPopItem:GetListItems())
end

function M:GetItemCount()
  local ListPopItem = self:GetListView()
  if not ListPopItem or not ListPopItem.GetListItems then
    return 0
  end
  return GetWidgetCount(ListPopItem:GetListItems())
end

function M:GetItemByIndex(Index)
  local ContentList = self:GetItems()
  return ContentList[Index]
end

function M:GetDisplayedEntryWidgets()
  local ListPopItem = self:GetListView()
  if not ListPopItem or not ListPopItem.GetDisplayedEntryWidgets then
    return {}
  end
  return GetWidgetArrayTable(ListPopItem:GetDisplayedEntryWidgets())
end

function M:BindListEvents(OwnerWidget, OnScrolled, OnEntryGenerated, OnEntryReleased)
  self:UnBindListEvents()
  if not OwnerWidget then
    return
  end
  self.BoundEventOwner = OwnerWidget
  self.BoundOnScrolled = OnScrolled
  self.BoundOnEntryGenerated = OnEntryGenerated
  self.BoundOnEntryReleased = OnEntryReleased
  self.BoundScrollWidgets = {}
  self.BoundEntryLifecycleWidgets = {}
  
  local function BindScrollWidget(Widget)
    if not CanBindUserScrolled(Widget) or not OnScrolled then
      return
    end
    Widget.OnUserScrolled:Remove(OwnerWidget, OnScrolled)
    Widget.OnUserScrolled:Add(OwnerWidget, OnScrolled)
    table.insert(self.BoundScrollWidgets, Widget)
  end
  
  local function BindEntryLifecycle(Widget)
    if not (CanBindEntryLifecycle(Widget) and OnEntryGenerated) or not OnEntryReleased then
      return
    end
    Widget.BP_OnEntryGenerated:Remove(OwnerWidget, OnEntryGenerated)
    Widget.BP_OnEntryGenerated:Add(OwnerWidget, OnEntryGenerated)
    Widget.BP_OnEntryReleased:Remove(OwnerWidget, OnEntryReleased)
    Widget.BP_OnEntryReleased:Add(OwnerWidget, OnEntryReleased)
    table.insert(self.BoundEntryLifecycleWidgets, Widget)
  end
  
  local ScrollPopItem = self:GetArrowScrollWidget()
  local ListPopItem = self:GetListView()
  BindScrollWidget(ScrollPopItem)
  if not ScrollPopItem then
    BindScrollWidget(ListPopItem)
  end
  BindEntryLifecycle(ListPopItem)
end

function M:UnBindListEvents()
  local OwnerWidget = self.BoundEventOwner
  if OwnerWidget and self.BoundScrollWidgets then
    for _, Widget in ipairs(self.BoundScrollWidgets) do
      if CanBindUserScrolled(Widget) and self.BoundOnScrolled then
        Widget.OnUserScrolled:Remove(OwnerWidget, self.BoundOnScrolled)
      end
    end
  end
  if OwnerWidget and self.BoundEntryLifecycleWidgets then
    for _, Widget in ipairs(self.BoundEntryLifecycleWidgets) do
      if CanBindEntryLifecycle(Widget) then
        if self.BoundOnEntryGenerated then
          Widget.BP_OnEntryGenerated:Remove(OwnerWidget, self.BoundOnEntryGenerated)
        end
        if self.BoundOnEntryReleased then
          Widget.BP_OnEntryReleased:Remove(OwnerWidget, self.BoundOnEntryReleased)
        end
      end
    end
  end
  self.BoundEventOwner = nil
  self.BoundOnScrolled = nil
  self.BoundOnEntryGenerated = nil
  self.BoundOnEntryReleased = nil
  self.BoundScrollWidgets = nil
  self.BoundEntryLifecycleWidgets = nil
end

function M:UpdateArrow(ArrowTop, ArrowBottom, OffsetEpsilon)
  local Epsilon = type(OffsetEpsilon) == "number" and OffsetEpsilon or DEFAULT_SCROLL_OFFSET_EPSILON
  local ArrowScrollWidget = self:GetArrowScrollWidget()
  if ArrowScrollWidget then
    local CurrentOffset = ArrowScrollWidget:GetScrollOffset()
    local EndOffset = ArrowScrollWidget:GetScrollOffsetOfEnd()
    if type(CurrentOffset) ~= "number" or type(EndOffset) ~= "number" or Epsilon >= EndOffset then
      SetWidgetScrollOffset(ArrowScrollWidget, 0, Epsilon)
      SetArrowVisible(ArrowTop, false)
      SetArrowVisible(ArrowBottom, false)
      return false
    end
    if CurrentOffset > EndOffset then
      SetWidgetScrollOffset(ArrowScrollWidget, EndOffset, Epsilon)
      CurrentOffset = EndOffset
    elseif Epsilon >= CurrentOffset then
      SetWidgetScrollOffset(ArrowScrollWidget, 0, Epsilon)
      CurrentOffset = 0
    end
    SetArrowVisible(ArrowTop, Epsilon < CurrentOffset)
    SetArrowVisible(ArrowBottom, Epsilon < EndOffset - CurrentOffset)
    return false
  end
  local ListPopItem = self:GetListView()
  if not ListPopItem then
    SetArrowVisible(ArrowTop, false)
    SetArrowVisible(ArrowBottom, false)
    return false
  end
  local ListItemCount = ListPopItem.GetListItems and GetWidgetCount(ListPopItem:GetListItems()) or 0
  local DisplayedWidgetCount = ListPopItem.GetDisplayedEntryWidgets and GetWidgetCount(ListPopItem:GetDisplayedEntryWidgets()) or 0
  if ListItemCount > 0 and 0 == DisplayedWidgetCount then
    SetArrowVisible(ArrowTop, false)
    SetArrowVisible(ArrowBottom, false)
    return true
  end
  UIUtils.UpdateListArrow(ListPopItem, ArrowTop, ArrowBottom)
  return false
end

return M
