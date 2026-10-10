local D4SeasonItemUtils = {}

function D4SeasonItemUtils.GetFirstFreeContainerSlot(Avatar, ContainerType)
  local D4Season = Avatar and Avatar.D4Season
  local ItemModule = D4Season and D4Season.D4SeasonItemModule
  if not ItemModule then
    return -1
  end
  if ContainerType == CommonConst.D4SeasonItemContainerType.Bag then
    for i = 1, ItemModule.BagCapacity do
      if ItemModule.Bag[i] == nil then
        return i
      end
    end
  elseif ContainerType == CommonConst.D4SeasonItemContainerType.Store then
    for i = 1, ItemModule.StoreCapacity do
      if nil == ItemModule.Store[i] then
        return i
      end
    end
  end
  return -1
end

function D4SeasonItemUtils.GetItemSlot(Avatar, ItemUid)
  local D4Season = Avatar and Avatar.D4Season
  local ItemModule = D4Season and D4Season.D4SeasonItemModule
  if not ItemModule then
    return
  end
  for i = 1, CommonConst.D4SeasonEquipSlotIndex.Max do
    if ItemModule.Equip[i] == ItemUid then
      return CommonConst.D4SeasonItemContainerType.Equip, i
    end
  end
  for i = 1, ItemModule.BagCapacity do
    if ItemModule.Bag[i] == ItemUid then
      return CommonConst.D4SeasonItemContainerType.Bag, i
    end
  end
  for i = 1, ItemModule.StoreCapacity do
    if ItemModule.Store[i] == ItemUid then
      return CommonConst.D4SeasonItemContainerType.Store, i
    end
  end
end

function D4SeasonItemUtils.CheckAddItemList(Avatar, ItemList, IfBagFull2Store)
  local ItemModule = Avatar and Avatar.D4Season and Avatar.D4Season.D4SeasonItemModule
  if not ItemModule or type(ItemList) ~= "table" then
    return false
  end
  local ExistItemIds = {}
  for SlotIndex = 1, ItemModule.BagCapacity do
    local ItemUid = ItemModule.Bag[SlotIndex]
    local Item = ItemUid and ItemModule.OwnItemList[ItemUid]
    if Item then
      ExistItemIds[Item.ItemId] = true
    end
  end
  for SlotIndex = 1, ItemModule.StoreCapacity do
    local ItemUid = ItemModule.Store[SlotIndex]
    local Item = ItemUid and ItemModule.OwnItemList[ItemUid]
    if Item then
      ExistItemIds[Item.ItemId] = true
    end
  end
  local NeedSlotCount = 0
  for ItemId, ItemCount in pairs(ItemList) do
    if type(ItemId) ~= "number" or type(ItemCount) ~= "number" or ItemCount <= 0 then
      return false
    end
    if not ExistItemIds[ItemId] then
      NeedSlotCount = NeedSlotCount + 1
    end
  end
  local BagFreeSlotCount = 0
  for SlotIndex = 1, ItemModule.BagCapacity do
    if ItemModule.Bag[SlotIndex] == nil then
      BagFreeSlotCount = BagFreeSlotCount + 1
    end
  end
  if NeedSlotCount <= BagFreeSlotCount then
    return true
  end
  if not IfBagFull2Store then
    return false
  end
  local StoreFreeSlotCount = 0
  for SlotIndex = 1, ItemModule.StoreCapacity do
    if ItemModule.Store[SlotIndex] == nil then
      StoreFreeSlotCount = StoreFreeSlotCount + 1
    end
  end
  return NeedSlotCount <= BagFreeSlotCount + StoreFreeSlotCount
end

function D4SeasonItemUtils.GetD4SeasonEquipTierId(EquipBaseScore)
  for _, PowerTier in pairs(DataMgr.D4SeasonEquipPowerTier or {}) do
    if EquipBaseScore >= PowerTier.MinPower and EquipBaseScore <= PowerTier.MaxPower then
      return PowerTier.TierId
    end
  end
  return -1
end

function D4SeasonItemUtils.GetD4SeasonEquipBreakdownConfig(RarityId, EquipBaseScore)
  local TierId = D4SeasonItemUtils.GetD4SeasonEquipTierId(EquipBaseScore)
  if nil == TierId or TierId < 0 then
    return nil, TierId
  end
  local RarityConfig = DataMgr.D4SeasonEquipBreakdown and DataMgr.D4SeasonEquipBreakdown[RarityId]
  if type(RarityConfig) ~= "table" then
    return nil, TierId
  end
  return RarityConfig[TierId], TierId
end

return D4SeasonItemUtils
