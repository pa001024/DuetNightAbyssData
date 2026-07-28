require("UnLua")
local IllustratedItem = require("BluePrints.UI.UI_PC.SoloTreasure.WBP_SoloTreasure_Permanent_Illustrated_Item_C")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
M._components = {
  "BluePrints.UI.UI_PC.SoloTreasure.WBP_SoloTreasure_Permanent_Illustrated_ItemGroup_View"
}
M.GROUP_SLOT_COUNT = 7
M.LARGE_SLOT_MAP = {
  [2] = true,
  [5] = true
}

local function PopFirst(Queue)
  if #Queue > 0 then
    return table.remove(Queue, 1)
  end
  return nil
end

local function HasQueueItem(LargeQueue, SmallMediumQueue)
  return #LargeQueue > 0 or #SmallMediumQueue > 0
end

function M.IsLargeSlotIndex(SlotIndex)
  return M.LARGE_SLOT_MAP[SlotIndex] == true
end

function M.BuildOneGroupTreasureIds(LargeQueue, SmallMediumQueue)
  local TreasureIds = {}
  local FilledCount = 0
  for SlotIndex = 1, M.GROUP_SLOT_COUNT do
    if M.IsLargeSlotIndex(SlotIndex) then
      local TreasureId = PopFirst(LargeQueue)
      if nil ~= TreasureId then
        TreasureIds[SlotIndex] = TreasureId
        FilledCount = FilledCount + 1
      end
    end
  end
  for SlotIndex = 1, M.GROUP_SLOT_COUNT do
    if nil == TreasureIds[SlotIndex] then
      local TreasureId = PopFirst(SmallMediumQueue) or PopFirst(LargeQueue)
      if nil ~= TreasureId then
        TreasureIds[SlotIndex] = TreasureId
        FilledCount = FilledCount + 1
      end
    end
  end
  if FilledCount <= 0 then
    return nil
  end
  return TreasureIds
end

function M.BuildGroupTreasureIdsList(LargeIdList, SmallMediumIdList)
  local LargeQueue = {}
  local SmallMediumQueue = {}
  for _, TreasureId in ipairs(LargeIdList) do
    table.insert(LargeQueue, TreasureId)
  end
  for _, TreasureId in ipairs(SmallMediumIdList) do
    table.insert(SmallMediumQueue, TreasureId)
  end
  local GroupTreasureIdsList = {}
  while HasQueueItem(LargeQueue, SmallMediumQueue) do
    local TreasureIds = M.BuildOneGroupTreasureIds(LargeQueue, SmallMediumQueue)
    if nil == TreasureIds then
      break
    end
    table.insert(GroupTreasureIdsList, TreasureIds)
  end
  return GroupTreasureIdsList
end

function M:OnListItemObjectSet(Content)
  if nil == Content then
    return
  end
  self.OwningContent = Content.OwnerContent
  self.GroupIndex = Content.GroupIndex
  self.IsLastIndex = Content.IsLastIndex
  self:LogItemGroupInEntryPool(false, "OnListItemObjectSet")
  self:RefreshItemGroup(Content.TreasureIds)
  local IsShowSpacerLast = Content.IsLastIndex and (nil ~= Content.TreasureIds[7] or nil ~= Content.TreasureIds[4])
  local IsShowSpacerFirst = Content.IsFirstIndex
  self:SetSpacerFirstVisibility(IsShowSpacerFirst)
  self:SetSpacerLastVisibility(IsShowSpacerLast)
end

function M:BP_OnEntryReleased()
  self:LogItemGroupInEntryPool(true, "BP_OnEntryReleased")
  self:ReleaseItemGroupView()
end

function M:RefreshItemGroup(TreasureIds)
  self:RefreshItemGroupView(TreasureIds)
end

function M:BuildItemInfo(TreasureId, SlotIndex)
  return {
    Type = self:GetItemTypeByTreasureId(TreasureId, SlotIndex),
    TreasureId = TreasureId,
    State = self:IsTreasureUnlocked(TreasureId) and IllustratedItem.EItemState.UnLocked or IllustratedItem.EItemState.Locked
  }
end

function M:GetItemTypeByTreasureId(TreasureId, SlotIndex)
  local IsItemLarge = 1 == DataMgr.ExtractionTreasure[TreasureId].TreasureArchiveBigSize
  if M.IsLargeSlotIndex(SlotIndex) and IsItemLarge then
    return IllustratedItem.EItemType.Large
  end
  local TreasureData = DataMgr.ExtractionTreasure[TreasureId]
  if nil == TreasureData then
    return IllustratedItem.EItemType.Small
  end
  local Shape = TreasureData.Shape
  if Shape and 1 == Shape[1] and 1 == Shape[2] then
    return IllustratedItem.EItemType.Small
  end
  return IllustratedItem.EItemType.Medium
end

function M:IsTreasureUnlocked(TreasureId)
  local ManualInfo = self:GetManualInfo()
  if nil == ManualInfo or nil == ManualInfo.Manual then
    return false
  end
  return ManualInfo.Manual:HasElement(TreasureId)
end

function M:GetManualInfo()
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar or nil == Avatar.TreasureHuntManualInfo then
    return nil
  end
  return Avatar.TreasureHuntManualInfo
end

AssembleComponents(M)
return M
