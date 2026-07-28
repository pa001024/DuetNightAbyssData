require("UnLua")
local IllustratedItemGroup = require("BluePrints.UI.UI_PC.SoloTreasure.WBP_SoloTreasure_Permanent_Illustrated_ItemGroup_C")
local IllustratedItemGroupView = require("BluePrints.UI.UI_PC.SoloTreasure.WBP_SoloTreasure_Permanent_Illustrated_ItemGroup_View")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function GetWidgetLocalSize(Widget)
  if nil == Widget then
    return nil
  end
  local Geometry = Widget:GetCachedGeometry()
  local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
  if LocalSize.X <= 0 or LocalSize.Y <= 0 then
    Geometry = Widget:GetPaintSpaceGeometry()
    LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
  end
  if LocalSize.X <= 0 or LocalSize.Y <= 0 then
    return nil
  end
  return LocalSize
end

function M:Construct()
  if self.List_Treasure and self.List_Treasure.DisableScroll then
    self.List_Treasure:DisableScroll(true)
  end
  self:EnsureScrollBoxBound()
end

function M:EnsureScrollBoxBound()
  if self.bScrollBoxBound or self.EMScrollBox == nil then
    return
  end
  self.EMScrollBox.OnUserScrolled:Add(self, self.OnTreasureScrollBoxScrolled)
  self.bScrollBoxBound = true
end

function M:OnTreasureScrollBoxScrolled()
  self:NotifyDisplayedItemGroupsScrollChanged()
end

function M:NotifyDisplayedItemGroupsScrollChanged()
  if self.List_Treasure == nil then
    return
  end
  local EntryWidgets = self.List_Treasure:GetDisplayedEntryWidgets()
  for i = 1, EntryWidgets:Length() do
    local Entry = EntryWidgets:GetRef(i)
    if Entry and Entry.TryStaggerRefreshViewportItems then
      Entry:TryStaggerRefreshViewportItems()
    end
  end
end

function M:ResetTreasureScrollOffset()
  if self.EMScrollBox then
    self.EMScrollBox:SetScrollOffset(0)
  end
  self.MaxScrollOffset = nil
end

function M:GetTreasureScrollBox()
  return self.EMScrollBox
end

function M:GetTreasureScrollOffset()
  if self.EMScrollBox == nil or nil == self.EMScrollBox.GetScrollOffset then
    return 0
  end
  return self.EMScrollBox:GetScrollOffset()
end

function M:GetTreasureScrollViewportWidth()
  local LocalSize = GetWidgetLocalSize(self.EMScrollBox)
  return LocalSize and LocalSize.X or 0
end

function M:ClearItemGroupLayoutMetrics()
  self.FirstItemGroupWidth = nil
  self.MiddleItemGroupWidth = nil
  self.MeasuredItemGroupWidthMap = {}
end

function M:UpdateItemGroupWidth(GroupIndex, GroupWidth, IsLastIndex)
  if nil == GroupIndex or nil == GroupWidth or GroupWidth <= 0 then
    return
  end
  if nil == self.MeasuredItemGroupWidthMap then
    self.MeasuredItemGroupWidthMap = {}
  end
  self.MeasuredItemGroupWidthMap[GroupIndex] = GroupWidth
  if 1 == GroupIndex then
    self.FirstItemGroupWidth = GroupWidth
  elseif not IsLastIndex then
    self.MiddleItemGroupWidth = GroupWidth
  elseif nil == self.MiddleItemGroupWidth then
    self.MiddleItemGroupWidth = GroupWidth
  end
end

function M:GetItemGroupScrollBounds(GroupIndex)
  if nil == GroupIndex then
    return nil, nil
  end
  local GroupWidth = self.MeasuredItemGroupWidthMap and self.MeasuredItemGroupWidthMap[GroupIndex]
  if 1 == GroupIndex then
    GroupWidth = GroupWidth or self.FirstItemGroupWidth
    if nil == GroupWidth then
      return nil, nil
    end
    return 0, GroupWidth
  end
  local FirstWidth = self.FirstItemGroupWidth
  local MiddleWidth = self.MiddleItemGroupWidth
  if nil == FirstWidth or nil == MiddleWidth then
    return nil, nil
  end
  local Left = FirstWidth + (GroupIndex - 2) * MiddleWidth
  return Left, Left + (GroupWidth or MiddleWidth)
end

local function SortTreasureIdList(IdList)
  table.sort(IdList, function(a, b)
    return b < a
  end)
end

local function GetOrCreateTabCache(CacheRoot, TabId)
  if nil == CacheRoot[TabId] then
    CacheRoot[TabId] = {
      LargeIdList = {},
      SmallMediumIdList = {}
    }
  end
  return CacheRoot[TabId]
end

function M:InitTreasureIdCache()
  if self.TreasureIdCache ~= nil then
    return
  end
  self.TreasureIdCache = {}
  local AllCache = GetOrCreateTabCache(self.TreasureIdCache, 0)
  for TreasureId, Info in pairs(DataMgr.ExtractionTreasure) do
    local TabId = Info.TreasureType
    local TypeCache = GetOrCreateTabCache(self.TreasureIdCache, TabId)
    if Info.TreasurePlayModeType then
      if 1 == Info.TreasureArchiveBigSize then
        table.insert(AllCache.LargeIdList, TreasureId)
        table.insert(TypeCache.LargeIdList, TreasureId)
      else
        table.insert(AllCache.SmallMediumIdList, TreasureId)
        table.insert(TypeCache.SmallMediumIdList, TreasureId)
      end
    end
  end
  for _, TabCache in pairs(self.TreasureIdCache) do
    SortTreasureIdList(TabCache.LargeIdList)
    SortTreasureIdList(TabCache.SmallMediumIdList)
  end
end

function M:ClearTreasureIdCache()
  self.TreasureIdCache = nil
end

function M:GetTreasureIdListByTabId(TabId)
  self:InitTreasureIdCache()
  TabId = TabId or 0
  local TabCache = self.TreasureIdCache[TabId] or self.TreasureIdCache[0]
  return TabCache.LargeIdList, TabCache.SmallMediumIdList
end

function M:RefreshListView(GroupTreasureIdsList)
  if self.List_Treasure == nil then
    return
  end
  self:ResetTreasureScrollOffset()
  self:ClearItemGroupLayoutMetrics()
  self.List_Treasure:ClearListItems()
  local ClassPath = UIUtils.GetCommonItemContentClass()
  for Index, TreasureIds in ipairs(GroupTreasureIdsList) do
    local Content = NewObject(ClassPath)
    Content.OwnerContent = self
    Content.TreasureIds = TreasureIds
    Content.GroupIndex = Index
    Content.IsFirstIndex = 1 == Index
    Content.IsLastIndex = Index == #GroupTreasureIdsList
    self.List_Treasure:AddItem(Content)
  end
  if self.List_Treasure.RegenerateAllEntries then
    self.List_Treasure:RegenerateAllEntries()
  end
  if self.EMScrollBox and self.EMScrollBox.GetScrollOffsetOfEnd then
    self.MaxScrollOffset = self.EMScrollBox:GetScrollOffsetOfEnd()
  end
end

function M:RefreshContent(TabId)
  TabId = TabId or self.CurTabId or -1
  self.CurTabId = TabId
  IllustratedItemGroupView.ClearAnimatedTreasureCache()
  local LargeIdList, SmallMediumIdList = self:GetTreasureIdListByTabId(TabId)
  local GroupTreasureIdsList = IllustratedItemGroup.BuildGroupTreasureIdsList(LargeIdList, SmallMediumIdList)
  self:RefreshListView(GroupTreasureIdsList)
end

return M
