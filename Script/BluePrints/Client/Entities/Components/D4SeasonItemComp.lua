local Component = {}

function Component:D4SeasonBagPrint()
  local D4Season = self.D4Season
  local ItemModule = D4Season and D4Season.D4SeasonItemModule
  if not ItemModule then
    DebugPrint("D4SeasonBagPrint: D4SeasonItemModule is nil")
    return
  end
  
  local function DumpContainer(Container)
    local Result = {}
    for SlotIndex, ItemUid in pairs(Container or {}) do
      local Item = (not ItemModule.OwnEquipList or not ItemModule.OwnEquipList[ItemUid]) and ItemModule.OwnItemList and ItemModule.OwnItemList[ItemUid]
      Result[SlotIndex] = {
        ItemUid = ItemUid,
        ItemInfo = Item and Item.binary_dump and Item:binary_dump(Item) or nil
      }
    end
    return Result
  end
  
  local PrintData = {
    BagCapacity = ItemModule.BagCapacity,
    StoreCapacity = ItemModule.StoreCapacity,
    EquipSlots = DumpContainer(ItemModule.Equip),
    BagSlots = DumpContainer(ItemModule.Bag),
    StoreSlots = DumpContainer(ItemModule.Store)
  }
  PrintTable(PrintData, 20, "D4SeasonBagPrint", true)
end

function Component:D4SeasonEquipBagFirst()
  local ItemModule = self.D4Season and self.D4Season.D4SeasonItemModule
  if not ItemModule then
    return
  end
  for SlotIndex = 1, ItemModule.BagCapacity do
    local ItemUid = ItemModule.Bag[SlotIndex]
    local Equip = ItemUid and ItemModule.OwnEquipList and ItemModule.OwnEquipList[ItemUid]
    local EquipRule = Equip and CommonConst.D4SeasonEquipRule[Equip.EquipSlotType]
    if EquipRule and EquipRule[1] then
      self:D4SeasonEquipItem(nil, ItemUid, EquipRule[1])
      return ItemUid
    end
  end
end

function Component:D4SeasonTestUnEquip()
  local ItemModule = self.D4Season and self.D4Season.D4SeasonItemModule
  if not ItemModule then
    return
  end
  for SlotIndex = 1, CommonConst.D4SeasonEquipSlotIndex.Max do
    local ItemUid = ItemModule.Equip[SlotIndex]
    if ItemUid then
      self:D4SeasonUnEquipItem(nil, ItemUid)
      return ItemUid
    end
  end
end

function Component:D4SeasonEquipItem(Callback, ItemUid, EquipSlotId)
  self:CallServer("D4SeasonEquipItem", Callback, ItemUid, EquipSlotId)
end

function Component:D4SeasonUnEquipItem(Callback, ItemUid)
  self:CallServer("D4SeasonUnEquipItem", Callback, ItemUid)
end

function Component:D4SeasonEquipSetFavorite(Callback, ItemUid, IsFavorite)
  self:CallServer("D4SeasonEquipSetFavorite", Callback, ItemUid, IsFavorite)
end

function Component:D4SeasonEquipMasterwork(Callback, ItemUid)
  self:CallServer("D4SeasonEquipMasterwork", Callback, ItemUid)
end

function Component:D4SeasonEquipFinalMasterwork(Callback, ItemUid, AffixSlot)
  self:CallServer("D4SeasonEquipFinalMasterwork", Callback, ItemUid, AffixSlot)
end

function Component:D4SeasonEquipTemper(Callback, ItemUid, AffixSlot, AffixId)
  self:CallServer("D4SeasonEquipTemper", Callback, ItemUid, AffixSlot, AffixId)
end

function Component:D4SeasonEquipEnchant(Callback, ItemUid, AffixSlot, CandidateAffixId)
  self:CallServer("D4SeasonEquipEnchant", Callback, ItemUid, AffixSlot, CandidateAffixId)
end

function Component:D4SeasonEquipSocket(Callback, ItemUid, SocketIndex, SocketItemUid)
  self:CallServer("D4SeasonEquipSocket", Callback, ItemUid, SocketIndex, SocketItemUid)
end

function Component:D4SeasonEquipUnEquipAllSockets(Callback, ItemUid)
  self:CallServer("D4SeasonEquipUnEquipAllSockets", Callback, ItemUid)
end

function Component:D4SeasonEquipSell(Callback, ItemUidList)
  self:CallServer("D4SeasonEquipSell", Callback, ItemUidList)
end

function Component:D4SeasonEquipBreakdown(Callback, ItemUidList)
  self:CallServer("D4SeasonEquipBreakdown", Callback, ItemUidList)
end

return Component
