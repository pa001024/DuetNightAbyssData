local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 3,
  [3] = 6,
  [4] = 10,
  [5] = 15,
  [6] = 20,
  [7] = 25,
  [8] = 30
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("LimitedPrizeCostRule", {
  [1001] = {
    CostResCount = T.RT_1,
    CostResourceId = 1009,
    CostRuleId = 1001,
    GetBestPrizeNum = 0
  },
  [1002] = {
    CostResCount = T.RT_1,
    CostResourceId = 1009,
    CostRuleId = 1002,
    GetBestPrizeNum = 0
  }
})
