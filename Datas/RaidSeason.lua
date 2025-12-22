local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaidSeason", {
  [1001] = {
    EventId = 111001,
    PreRaidRank = 1,
    PreRaidTime = 62,
    RaidPointToRewrad = {
      [1000] = 300315
    },
    RaidPointToRewradMaxTime = 750,
    RaidRankCount = 5000,
    RaidSeason = 1001,
    RaidTime = 173,
    Shop = "RaidShopSeason01"
  }
})
