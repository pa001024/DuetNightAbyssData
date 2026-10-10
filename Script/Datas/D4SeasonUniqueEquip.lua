local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonUniqueEquip", {
  [3001] = {
    EquipId = 3001,
    EquipSlot = 1,
    UniqueAffixId = 1
  },
  [3002] = {
    EquipId = 3002,
    EquipSlot = 2,
    UniqueAffixId = 1
  },
  [3003] = {
    EquipId = 3003,
    EquipSlot = 3,
    UniqueAffixId = 1
  }
})
