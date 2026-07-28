require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function GetSortGroup(Content)
  if Content.bSelectTag then
    return 3
  end
  if Content.bOccupied then
    return 1
  end
  return 2
end

function M:Init(Parent, Params)
  self.Parent = Parent
  self.Params = Params or {}
  self.ItemContents = self.Params.ItemContents or {}
  self:ApplyNavigationRule()
  self:FillList()
end

function M:ApplyNavigationRule()
  if not IsValid(self.ListRoom) then
    return
  end
  self.ListRoom:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.ListRoom:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.ListRoom:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.ListRoom:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:SortItemContents()
  table.sort(self.ItemContents, function(a, b)
    local AGroup = GetSortGroup(a)
    local BGroup = GetSortGroup(b)
    if AGroup ~= BGroup then
      return AGroup > BGroup
    end
    return (a.SortId or a.UniqueId or 0) < (b.SortId or b.UniqueId or 0)
  end)
end

function M:FillList()
  self.SelectItem = nil
  local ListView = self.ListRoom
  if not IsValid(ListView) then
    return
  end
  self:SortItemContents()
  ListView:ClearListItems()
  for _, Content in ipairs(self.ItemContents) do
    Content.Owner = self
    Content.OnSelect = self.OnSelectAffix
    ListView:AddItem(Content)
  end
end

function M:OnSelectAffix(AffixId, Content, Item)
  if not Content then
    return
  end
  local OnSelect = self.Params and self.Params.OnSelect
  if self.Parent and OnSelect then
    OnSelect(self.Parent, AffixId, Content)
  end
  if Content.bOccupied then
    return
  end
  for _, ItemContent in ipairs(self.ItemContents) do
    local bSelected = ItemContent.UniqueId == Content.UniqueId
    ItemContent.bSelectTag = bSelected
    ItemContent.SortSelected = bSelected and 1 or 0
  end
  if self.SelectItem then
    self.SelectItem:PlayItem_Unselect()
  end
  self.SelectItem = Item
  Item:PlayItem_Select()
end

return M
