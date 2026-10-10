local T = {}
T.RT_1 = {
  [1000] = 300315
}
T.RT_2 = {
  30,
  60,
  90
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaidSeason", {
  [1001] = {
    EventId = 111001,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidPointToRewrad = T.RT_1,
    RaidPointToRewradMaxTime = 750,
    RaidRankCount = 1000,
    RaidSeason = 1001,
    RaidSeasonType = 1,
    RaidTime = 173,
    Shop = "RaidShopSeason01"
  },
  [1002] = {
    EventId = 111002,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidPointToRewrad = T.RT_1,
    RaidPointToRewradMaxTime = 750,
    RaidRankCount = 1000,
    RaidSeason = 1002,
    RaidSeasonType = 1,
    RaidTime = 173,
    Shop = "RaidShopSeason01"
  },
  [1003] = {
    EventId = 111003,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidPointToRewrad = T.RT_1,
    RaidPointToRewradMaxTime = 750,
    RaidRankCount = 1000,
    RaidSeason = 1003,
    RaidSeasonType = 1,
    RaidTime = 168,
    Shop = "RaidShopSeason01"
  },
  [1004] = {
    EventId = 111004,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidPointToRewrad = T.RT_1,
    RaidPointToRewradMaxTime = 750,
    RaidRankCount = 1000,
    RaidSeason = 1004,
    RaidSeasonType = 1,
    RaidTime = 168,
    Shop = "RaidShopSeason01"
  },
  [1005] = {
    EventId = 111005,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidPointToRewrad = T.RT_1,
    RaidPointToRewradMaxTime = 750,
    RaidRankCount = 1000,
    RaidSeason = 1005,
    RaidSeasonType = 1,
    RaidTime = 168,
    Shop = "RaidShopSeason01"
  },
  [1006] = {
    EventId = 111006,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidRankCount = 1000,
    RaidSeason = 1006,
    RaidSeasonType = 1,
    RaidTime = 168,
    Shop = "RaidShopSeason01"
  },
  [1007] = {
    BubbleDisplayMaxFloor = 100,
    EventId = 111007,
    JumpFloor = {
      15,
      10,
      5,
      2
    },
    JumpTime = {
      65,
      50,
      30,
      0
    },
    KeyFloor = T.RT_2,
    PreKeyFloor = T.RT_2,
    PreRaidFloorUnlock = 30,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidFloorUnlock = 30,
    RaidRankCount = 1000,
    RaidSeason = 1007,
    RaidSeasonType = 2,
    RaidTime = 168,
    Shop = "RaidShopSeason01"
  }
})
