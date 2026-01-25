local T = {}
T.RT_1 = {
  [1] = 7601,
  [2] = 7602,
  [3] = 7603,
  [4] = 7604,
  [5] = 7605
}
T.RT_2 = {
  [1] = 20,
  [2] = 40,
  [3] = 60,
  [4] = 80,
  [5] = 100
}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SkinGachaCumulative", {
  [9002] = {
    GachaId = 9002,
    RewardId = T.RT_1,
    RewardTarget = T.RT_2
  },
  [9003] = {
    GachaId = 9003,
    RewardId = T.RT_1,
    RewardTarget = T.RT_2
  }
})
