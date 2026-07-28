local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TreasureArchiveReward", {
  [5] = {RewardId = 103027005, RewardProgress = 5},
  [10] = {RewardId = 103027010, RewardProgress = 10},
  [15] = {RewardId = 103027015, RewardProgress = 15},
  [20] = {RewardId = 103027020, RewardProgress = 20},
  [25] = {RewardId = 103027025, RewardProgress = 25},
  [30] = {RewardId = 103027030, RewardProgress = 30},
  [35] = {RewardId = 103027035, RewardProgress = 35},
  [40] = {RewardId = 103027040, RewardProgress = 40},
  [45] = {RewardId = 103027045, RewardProgress = 45},
  [50] = {RewardId = 103027050, RewardProgress = 50},
  [55] = {RewardId = 103027055, RewardProgress = 55},
  [60] = {RewardId = 103027060, RewardProgress = 60},
  [65] = {RewardId = 103027065, RewardProgress = 65},
  [70] = {RewardId = 103027070, RewardProgress = 70}
})
