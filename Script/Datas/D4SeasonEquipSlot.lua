local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipSlot", {
  [1] = {
    BaseAffixId = 1,
    EquipSlot = 1,
    MaxInlayCount = 2
  },
  [2] = {
    BaseAffixId = 1,
    EquipSlot = 2,
    MaxInlayCount = 2
  }
})
