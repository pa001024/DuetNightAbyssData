local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaidRankReward", {
  [1] = {
    RaidSeason = 1007,
    RangeReward = 10000000,
    RankId = 1,
    RankPercent = 1,
    RankRange = {1, 100}
  },
  [2] = {
    RaidSeason = 1007,
    RangeReward = 10000001,
    RankId = 2,
    RankPercent = 1,
    RankRange = {101, 500}
  },
  [3] = {
    RaidSeason = 1007,
    RangeReward = 10000002,
    RankId = 3,
    RankPercent = 1,
    RankRange = {501, 1000}
  }
})
