local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipPowerTier", {
  [1] = {
    EquipLevelThreshold = 10,
    MaxPower = 199,
    MinPower = 100,
    SPAffixGet = false,
    TierId = 1
  },
  [2] = {
    EquipLevelThreshold = 20,
    MaxPower = 849,
    MinPower = 200,
    SPAffixGet = false,
    TierId = 2
  },
  [3] = {
    EquipLevelThreshold = 30,
    MaxPower = 850,
    MinPower = 850,
    SPAffixGet = false,
    TierId = 3
  },
  [4] = {
    EquipLevelThreshold = 40,
    MaxPower = 900,
    MinPower = 900,
    SPAffixGet = true,
    TierId = 4
  }
})
