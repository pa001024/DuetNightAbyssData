local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local D4SeasonItem = Class("D4SeasonItem", CustomTypes.CustomAttr)
D4SeasonItem.__Props__ = {
  ItemUid = prop.prop("ObjId", "client save"),
  ItemId = prop.prop("Int", "client save"),
  Count = prop.prop("Int", "client save")
}

function D4SeasonItem:IsContainerSlotValid(ContainerType, Slot)
  if ContainerType == CommonConst.D4SeasonItemContainerType.Equip then
    return false
  end
  return true
end

FormatProperties(D4SeasonItem)
local D4SeasonItemDict = Class("D4SeasonItemDict", CustomTypes.CustomDict)
D4SeasonItemDict.KeyType = BaseTypes.ObjId
D4SeasonItemDict.ValueType = D4SeasonItem
local D4SeasonEquipAffix = Class("D4SeasonEquipAffix", CustomTypes.CustomAttr)
D4SeasonEquipAffix.__Props__ = {
  AffixId = prop.prop("Int", "client save", -1),
  RollLevel = prop.prop("IntList", "client save", -1),
  IsAncient = prop.prop("Bool", "client save", false)
}
FormatProperties(D4SeasonEquipAffix)
local D4SeasonEquipAffixList = Class("D4SeasonEquipAffixList", CustomTypes.CustomList)
D4SeasonEquipAffixList.ValueType = D4SeasonEquipAffix
local D4SeasonEquip = Class("D4SeasonEquip", CustomTypes.CustomAttr)
D4SeasonEquip.__Props__ = {
  ItemUid = prop.prop("ObjId", "client save"),
  EquipSlotType = prop.prop("Int", "client save", -1),
  RarityId = prop.prop("Int", "client save", -1),
  SeasonId = prop.prop("Int", "client save", -1),
  EquipBaseScore = prop.prop("Int", "client save", -1),
  NameId = prop.prop("Int", "client save", -1),
  IconId = prop.prop("Int", "client save", -1),
  Affixes = prop.prop("D4SeasonEquipAffixList", "client save"),
  BaseAffixId = prop.prop("Int", "client save", -1),
  TemperingAffixId = prop.prop("Int", "client save", -1),
  EnchantAffixId = prop.prop("Int", "client save", -1),
  FinalMasterworkAffixId = prop.prop("Int", "client save", -1),
  UniqueAffixId = prop.prop("Int", "client save", -1),
  Sockets = prop.prop("ObjectIdList", "client save"),
  MasterworkLevel = prop.prop("Int", "client save", -1),
  TemperingCount = prop.prop("Int", "client save", -1),
  EnchantCount = prop.prop("Int", "client save", -1),
  IsFavorite = prop.prop("Bool", "client save", false)
}

function D4SeasonEquip:IsContainerSlotValid(ContainerType, Slot)
  if ContainerType == CommonConst.D4SeasonItemContainerType.Equip then
    return CommonConst.D4SeasonEquipRule[self.EquipSlotType] and CommonUtils.HasValue(CommonConst.D4SeasonEquipRule[self.EquipSlotType], Slot) == true
  end
  return true
end

FormatProperties(D4SeasonEquip)
local D4SeasonEquipDict = Class("D4SeasonEquipDict", CustomTypes.CustomDict)
D4SeasonEquipDict.KeyType = BaseTypes.ObjId
D4SeasonEquipDict.ValueType = D4SeasonEquip
local D4SeasonEquipFilter = Class("D4SeasonEquipFilter", CustomTypes.CustomAttr)
D4SeasonEquipFilter.__Props__ = {}
FormatProperties(D4SeasonEquipFilter)
local D4SeasonItemModule = Class("D4SeasonItemModule", CustomTypes.CustomAttr)
D4SeasonItemModule.__Props__ = {
  OwnItemList = prop.prop("D4SeasonItemDict", "client save"),
  OwnEquipList = prop.prop("D4SeasonEquipDict", "client save"),
  Equip = prop.prop("Int2ObjIdDict", "client save"),
  Bag = prop.prop("Int2ObjIdDict", "client save"),
  Store = prop.prop("Int2ObjIdDict", "client save"),
  EquipFilter = prop.prop("D4SeasonEquipFilter", "client save"),
  BagCapacity = prop.prop("Int", "client save", 30),
  StoreCapacity = prop.prop("Int", "client save", 50)
}
FormatProperties(D4SeasonItemModule)

function D4SeasonItemModule:NewEquip()
  return D4SeasonEquip()
end

function D4SeasonItemModule:NewItem()
  return D4SeasonItem()
end

return {
  D4SeasonItem = D4SeasonItem,
  D4SeasonItemDict = D4SeasonItemDict,
  D4SeasonEquipAffix = D4SeasonEquipAffix,
  D4SeasonEquipAffixList = D4SeasonEquipAffixList,
  D4SeasonEquip = D4SeasonEquip,
  D4SeasonEquipDict = D4SeasonEquipDict,
  D4SeasonEquipFilter = D4SeasonEquipFilter,
  D4SeasonItemModule = D4SeasonItemModule
}
