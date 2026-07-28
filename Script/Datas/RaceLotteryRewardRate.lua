local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaceLotteryRewardRate", {
  [0] = {RewardRate = 0.2, TargetHitNum = 0},
  [1] = {RewardRate = 1.2, TargetHitNum = 1},
  [2] = {RewardRate = 1.5, TargetHitNum = 2},
  [3] = {RewardRate = 3, TargetHitNum = 3},
  [4] = {RewardRate = 6, TargetHitNum = 4},
  [5] = {RewardRate = 10, TargetHitNum = 5},
  [6] = {RewardRate = 20, TargetHitNum = 6}
})
