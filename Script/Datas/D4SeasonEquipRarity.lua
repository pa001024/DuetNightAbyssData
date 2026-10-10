local T = {}
T.RT_1 = {4}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipRarity", {
  [1] = {
    MinAffixCount = {0},
    RarityId = 1,
    UniqueAffixCount = 0
  },
  [2] = {
    MinAffixCount = {1},
    RarityId = 2,
    UniqueAffixCount = 0
  },
  [3] = {
    MinAffixCount = {2},
    RarityId = 3,
    UniqueAffixCount = 0
  },
  [4] = {
    MinAffixCount = {3},
    RarityId = 4,
    UniqueAffixCount = 0
  },
  [5] = {
    MinAffixCount = T.RT_1,
    RarityId = 5,
    UniqueAffixCount = 0
  },
  [10] = {
    MinAffixCount = T.RT_1,
    RarityId = 10,
    UniqueAffixCount = 1
  }
})
