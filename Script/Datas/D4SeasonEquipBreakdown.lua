local T = {}
T.RT_1 = {
  [1] = 9001,
  [2] = 9001
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipBreakdown", {
  [1] = {
    ItemCount = {
      [1] = 5,
      [2] = 5
    },
    ItemId = T.RT_1,
    RarityId = 1
  },
  [2] = {
    ItemCount = {
      [1] = 12,
      [2] = 12
    },
    ItemId = T.RT_1,
    RarityId = 2
  },
  [3] = {
    ItemCount = {
      [1] = 30,
      [2] = 30
    },
    ItemId = T.RT_1,
    RarityId = 3
  }
})
