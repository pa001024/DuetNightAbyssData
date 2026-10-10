local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 1
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipCraft", {
  [1] = {
    CostItemCount = T.RT_1,
    CostItemId = {
      [1] = 9101,
      [2] = 9101
    },
    CostPriceCount = 1,
    CostPriceId = 9101,
    CraftId = 1,
    MaxCount = 10
  },
  [2] = {
    CostItemCount = T.RT_1,
    CostItemId = {
      [1] = 9102,
      [2] = 9102
    },
    CostPriceCount = 1,
    CostPriceId = 9102,
    CraftId = 2
  }
})
