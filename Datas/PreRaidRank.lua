local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PreRaidRank", {
  [1] = {
    IsOnline = {
      true,
      true,
      false,
      false,
      false
    },
    PreRaidRank = 1,
    RankName = {
      "SSS",
      "SS",
      "S",
      "A",
      "B"
    },
    RankPercent = {
      5,
      20,
      45,
      70,
      100
    },
    RankReward = {
      300316,
      300317,
      300318,
      300319,
      300320
    }
  }
})
