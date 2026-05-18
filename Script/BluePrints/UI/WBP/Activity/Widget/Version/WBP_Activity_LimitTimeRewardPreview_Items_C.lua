require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local ITEM_WIDGET_BP_PATH = "/Game/UI/WBP/Activity/Widget/LimitTimeRewardPreView/WBP_Activity_LimitTimeRewardPreview_Item.WBP_Activity_LimitTimeRewardPreview_Item"

local function BuildInnerContent(Entry, PreviewState, ParentWidget, ParentSection, Index, FocusIndex)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.EventId = Entry.eventId
  Content.PreviewState = PreviewState
  Content.bActivitySucc = Entry.bActivitySucc
  Content.ParentWidget = ParentWidget
  Content.Parent = ParentSection
  Content.Index = Index
  Content.IsSelected = FocusIndex == Index
  return Content
end

function M:RefreshInnerNavigation()
  local widgets = self.InnerEntryWidgets or {}
  local count = #widgets
  for i = 1, count do
    local widget = widgets[i]
    if i > 1 then
      widget:SetNavigationRuleExplicit(EUINavigation.Up, widgets[i - 1])
    else
      widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    end
    if i < count then
      widget:SetNavigationRuleExplicit(EUINavigation.Down, widgets[i + 1])
    else
      widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    end
  end
end

function M:FocusInnerEntryByIndex(Index)
  local widgets = self.InnerEntryWidgets or {}
  local target = widgets[(Index or 0) + 1]
  if target then
    self.LastFocusItem = target
    target:SetFocus()
  end
end

function M:GetFirstEntryWidget()
  local widgets = self.InnerEntryWidgets or {}
  return widgets[1]
end

function M:GetLastEntryWidget()
  local widgets = self.InnerEntryWidgets or {}
  return widgets[#widgets]
end

function M:OnListItemObjectSet(ListItemObject)
  self.ListItemObject = ListItemObject
  self.ListItemObject.UI = self
  if not ListItemObject then
    return
  end
  self:PlayAnimation(self.In)
  if ListItemObject.TitleKey then
    local title = GText(ListItemObject.TitleKey)
    self.Text_TitleIng:SetText(title)
    self.Text_TitleIOther:SetText(title)
  end
  if self.WS_TextTitle and ListItemObject.WSTitleIndex ~= nil then
    self.WS_TextTitle:SetActiveWidgetIndex(ListItemObject.WSTitleIndex)
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local EventList = ListItemObject.EventList or {}
  local previewState = ListItemObject.PreviewState or 0
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  local notSucc, succ = {}, {}
  for _, eventId in ipairs(EventList) do
    local cfg = eventId and DataMgr.EventMain[eventId]
    local bActivitySucc = false
    if cfg and cfg.EventSuccCondition and Avatar then
      bActivitySucc = ConditionUtils.CheckCondition(Avatar, cfg.EventSuccCondition) and true or false
    end
    local entry = {eventId = eventId, bActivitySucc = bActivitySucc}
    if bActivitySucc then
      table.insert(succ, entry)
    else
      table.insert(notSucc, entry)
    end
  end
  local entries = {}
  for _, entry in ipairs(notSucc) do
    table.insert(entries, entry)
  end
  for _, entry in ipairs(succ) do
    table.insert(entries, entry)
  end
  local FocusIndex = self.ListItemObject.ParentWidget.LastFocusIndex[self.ListItemObject.Index] or 0
  self.LastFocusItem = nil
  self.InnerEntryWidgets = {}
  self.List_Items:ClearChildren()
  if #entries > 0 then
    for index, entry in ipairs(entries) do
      local Content = BuildInnerContent(entry, previewState, self.ListItemObject.ParentWidget, self, index - 1, FocusIndex)
      local EntryWidget = UIManager(self):CreateWidget(ITEM_WIDGET_BP_PATH)
      if EntryWidget then
        self.List_Items:AddChild(EntryWidget)
        EntryWidget:OnListItemObjectSet(Content)
        self.InnerEntryWidgets[index] = EntryWidget
      end
    end
  end
  self:RefreshInnerNavigation()
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.LastFocusItem == nil then
    local index = self.ListItemObject.ParentWidget.LastFocusIndex[self.ListItemObject.Index] or 0
    self:FocusInnerEntryByIndex(index)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self.LastFocusItem = nil
end

return M
