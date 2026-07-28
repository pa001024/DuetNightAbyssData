local T = {}
T.RT_1 = {1, 2}
T.RT_2 = {5, 6}
T.RT_3 = {7, 9}
T.RT_4 = {
  [1] = T.RT_1,
  [2] = T.RT_2,
  [3] = T.RT_3
}
T.RT_5 = {
  [1] = 150,
  [2] = 150,
  [3] = 150
}
T.RT_6 = {
  [1] = 300,
  [2] = 300,
  [3] = 300
}
T.RT_7 = {
  [1] = 100,
  [2] = 200,
  [3] = 100
}
T.RT_8 = {
  [2] = 100,
  [3] = 300,
  [4] = 200
}
T.RT_9 = {
  [3] = 100,
  [4] = 400,
  [5] = 300
}
T.RT_10 = {
  [1] = T.RT_7,
  [2] = T.RT_8,
  [3] = T.RT_9
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProSeason", {
  [-1] = {
    AutoNextRoundTime = 10,
    BossRandomRule = T.RT_4,
    BossShowTime = T.RT_5,
    ClassChooseTime = 60,
    ClassLockTime = 5,
    CollectRegionRefreshCD = 60,
    CowEventTime = 150,
    DeadDeductScore = 2,
    DeadDeductScoreDeadTimes = 10,
    DifficultyId = {1},
    MRTCost = 50,
    MRTLimitTimes = 1,
    MaxEventNum = 2,
    OuterShopTokenId = 215,
    RegionUnlockTime = 3000,
    RewardCollectTime = 30,
    RewardMonsterSpawnRule = 51,
    RewardStageTime = 150,
    RoundMainTime = T.RT_6,
    SeasonEndTime = LocalTimeProxy(8204817600),
    SeasonId = -1,
    SeasonStartTime = LocalTimeProxy(1641009600),
    ShopRandom = T.RT_10,
    TokenId = 203,
    TokenTransform = 12.5
  },
  [1] = {
    AutoNextRoundTime = 10,
    BossRandomRule = T.RT_4,
    BossShowTime = T.RT_5,
    ClassChooseTime = 60,
    ClassLockTime = 5,
    CollectRegionRefreshCD = 60,
    CowEventTime = 150,
    DeadDeductScore = 1.3,
    DeadDeductScoreDeadTimes = 5,
    DifficultyId = {
      101,
      102,
      103,
      104,
      105,
      106
    },
    MRTCost = 20,
    MRTLimitTimes = 1,
    MaxEventNum = 2,
    OuterShopTokenId = 215,
    RegionUnlockTime = 3000,
    RewardCollectTime = 30,
    RewardMonsterSpawnRule = 51,
    RewardStageTime = 150,
    RoundMainTime = T.RT_6,
    SeasonEndTime = LocalTimeProxy(8204817600),
    SeasonId = 1,
    SeasonStartTime = LocalTimeProxy(1641009600),
    ShopRandom = T.RT_10,
    TokenId = 203,
    TokenTransform = 12.5
  }
})
