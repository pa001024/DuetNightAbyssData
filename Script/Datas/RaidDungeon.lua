local T = {}
T.RT_1 = {1}
T.RT_2 = {2}
T.RT_3 = {3}
T.RT_4 = {
  [217] = 3
}
T.RT_5 = {
  [217] = 4
}
T.RT_6 = {
  [217] = 5
}
T.RT_7 = {12}
T.RT_8 = {13}
T.RT_9 = {14}
T.RT_10 = {15}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaidDungeon", {
  [21001] = {
    BaseRaidPoint = 1000,
    DifficultyLevel = 1,
    DungeonId = 21001,
    FomulaId = 1,
    MinCompleteDamage = 47200000,
    RaidBuffID = T.RT_1,
    RaidDungeonType = 1,
    RaidSeason = 1001,
    UnlockDate = LocalTimeProxy(1769133600)
  },
  [21002] = {
    BaseRaidPoint = 10000,
    DifficultyLevel = 2,
    DungeonId = 21002,
    FomulaId = 1,
    MinCompleteDamage = 206600000,
    RaidBuffID = T.RT_2,
    RaidDungeonType = 1,
    RaidSeason = 1001,
    UnlockDate = LocalTimeProxy(1769133600)
  },
  [21003] = {
    BaseRaidPoint = 135000,
    DifficultyLevel = 3,
    DungeonId = 21003,
    FomulaId = 1,
    MinCompleteDamage = 6149100000,
    RaidBuffID = T.RT_3,
    RaidDungeonType = 1,
    RaidSeason = 1001,
    UnlockDate = LocalTimeProxy(1769133600)
  },
  [21011] = {
    BaseRaidPoint = 3500,
    DifficultyLevel = 1,
    DungeonId = 21011,
    FomulaId = 2,
    MinCompleteDamage = 88400000,
    RaidBuffID = T.RT_1,
    RaidDungeonType = 2,
    RaidSeason = 1001,
    TicketNum = T.RT_4,
    UnlockDate = LocalTimeProxy(1769392800)
  },
  [21012] = {
    BaseRaidPoint = 40000,
    DifficultyLevel = 2,
    DungeonId = 21012,
    FomulaId = 2,
    MinCompleteDamage = 859700000,
    RaidBuffID = T.RT_2,
    RaidDungeonType = 2,
    RaidSeason = 1001,
    TicketNum = T.RT_5,
    UnlockDate = LocalTimeProxy(1769461200)
  },
  [21013] = {
    BaseRaidPoint = 400000,
    DifficultyLevel = 3,
    DungeonId = 21013,
    FomulaId = 2,
    MinCompleteDamage = 10001800000,
    RaidBuffID = T.RT_3,
    RaidDungeonType = 2,
    RaidSeason = 1001,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1769547600)
  },
  [21201] = {
    BaseRaidPoint = 1000,
    DifficultyLevel = 1,
    DungeonId = 21201,
    FomulaId = 1,
    MinCompleteDamage = 47200000,
    RaidBuffID = T.RT_7,
    RaidDungeonType = 1,
    RaidSeason = 1002,
    UnlockDate = LocalTimeProxy(1774317600)
  },
  [21202] = {
    BaseRaidPoint = 10000,
    DifficultyLevel = 2,
    DungeonId = 21202,
    FomulaId = 1,
    MinCompleteDamage = 206600000,
    RaidBuffID = T.RT_7,
    RaidDungeonType = 1,
    RaidSeason = 1002,
    UnlockDate = LocalTimeProxy(1774317600)
  },
  [21203] = {
    BaseRaidPoint = 135000,
    DifficultyLevel = 3,
    DungeonId = 21203,
    FomulaId = 1,
    MinCompleteDamage = 6149100000,
    RaidBuffID = T.RT_7,
    RaidDungeonType = 1,
    RaidSeason = 1002,
    UnlockDate = LocalTimeProxy(1774317600)
  },
  [21211] = {
    BaseRaidPoint = 3500,
    DifficultyLevel = 1,
    DungeonId = 21211,
    FomulaId = 2,
    MinCompleteDamage = 88400000,
    RaidBuffID = T.RT_7,
    RaidDungeonType = 2,
    RaidSeason = 1002,
    TicketNum = T.RT_4,
    UnlockDate = LocalTimeProxy(1774576800)
  },
  [21212] = {
    BaseRaidPoint = 40000,
    DifficultyLevel = 2,
    DungeonId = 21212,
    FomulaId = 2,
    MinCompleteDamage = 859700000,
    RaidBuffID = T.RT_7,
    RaidDungeonType = 2,
    RaidSeason = 1002,
    TicketNum = T.RT_5,
    UnlockDate = LocalTimeProxy(1774645200)
  },
  [21213] = {
    BaseRaidPoint = 400000,
    DifficultyLevel = 3,
    DungeonId = 21213,
    FomulaId = 2,
    MinCompleteDamage = 10001800000,
    RaidBuffID = T.RT_7,
    RaidDungeonType = 2,
    RaidSeason = 1002,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1774731600)
  },
  [21301] = {
    BaseRaidPoint = 1000,
    DifficultyLevel = 1,
    DungeonId = 21301,
    FomulaId = 1,
    MinCompleteDamage = 70800000,
    RaidBuffID = T.RT_8,
    RaidDungeonType = 1,
    RaidSeason = 1003,
    UnlockDate = LocalTimeProxy(1779156000)
  },
  [21302] = {
    BaseRaidPoint = 10000,
    DifficultyLevel = 2,
    DungeonId = 21302,
    FomulaId = 1,
    MinCompleteDamage = 309900000,
    RaidBuffID = T.RT_8,
    RaidDungeonType = 1,
    RaidSeason = 1003,
    UnlockDate = LocalTimeProxy(1779156000)
  },
  [21303] = {
    BaseRaidPoint = 135000,
    DifficultyLevel = 3,
    DungeonId = 21303,
    FomulaId = 1,
    MinCompleteDamage = 9223700000,
    RaidBuffID = T.RT_8,
    RaidDungeonType = 1,
    RaidSeason = 1003,
    UnlockDate = LocalTimeProxy(1779156000)
  },
  [21311] = {
    BaseRaidPoint = 3500,
    DifficultyLevel = 1,
    DungeonId = 21311,
    FomulaId = 2,
    MinCompleteDamage = 88400000,
    RaidBuffID = T.RT_8,
    RaidDungeonType = 2,
    RaidSeason = 1003,
    TicketNum = T.RT_4,
    UnlockDate = LocalTimeProxy(1779415200)
  },
  [21312] = {
    BaseRaidPoint = 40000,
    DifficultyLevel = 2,
    DungeonId = 21312,
    FomulaId = 2,
    MinCompleteDamage = 859700000,
    RaidBuffID = T.RT_8,
    RaidDungeonType = 2,
    RaidSeason = 1003,
    TicketNum = T.RT_5,
    UnlockDate = LocalTimeProxy(1779483600)
  },
  [21313] = {
    BaseRaidPoint = 400000,
    DifficultyLevel = 3,
    DungeonId = 21313,
    FomulaId = 2,
    MinCompleteDamage = 10001800000,
    RaidBuffID = T.RT_8,
    RaidDungeonType = 2,
    RaidSeason = 1003,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1779570000)
  },
  [21401] = {
    BaseRaidPoint = 1000,
    DifficultyLevel = 1,
    DungeonId = 21401,
    FomulaId = 1,
    MinCompleteDamage = 70800000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 1,
    RaidSeason = 1004,
    UnlockDate = LocalTimeProxy(1783994400)
  },
  [21402] = {
    BaseRaidPoint = 10000,
    DifficultyLevel = 2,
    DungeonId = 21402,
    FomulaId = 1,
    MinCompleteDamage = 309900000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 1,
    RaidSeason = 1004,
    UnlockDate = LocalTimeProxy(1783994400)
  },
  [21403] = {
    BaseRaidPoint = 135000,
    DifficultyLevel = 3,
    DungeonId = 21403,
    FomulaId = 1,
    MinCompleteDamage = 9223700000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 1,
    RaidSeason = 1004,
    UnlockDate = LocalTimeProxy(1783994400)
  },
  [21411] = {
    BaseRaidPoint = 3500,
    DifficultyLevel = 1,
    DungeonId = 21411,
    FomulaId = 2,
    MinCompleteDamage = 88400000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 2,
    RaidSeason = 1004,
    TicketNum = T.RT_4,
    UnlockDate = LocalTimeProxy(1784253600)
  },
  [21412] = {
    BaseRaidPoint = 40000,
    DifficultyLevel = 2,
    DungeonId = 21412,
    FomulaId = 2,
    MinCompleteDamage = 859700000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 2,
    RaidSeason = 1004,
    TicketNum = T.RT_5,
    UnlockDate = LocalTimeProxy(1784253600)
  },
  [21413] = {
    BaseRaidPoint = 400000,
    DifficultyLevel = 3,
    DungeonId = 21413,
    FomulaId = 2,
    MinCompleteDamage = 10001800000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 2,
    RaidSeason = 1004,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1784322000)
  },
  [21414] = {
    BaseRaidPoint = 1500000,
    DifficultyLevel = 4,
    DungeonId = 21414,
    FomulaId = 2,
    MinCompleteDamage = 38222900000,
    RaidBuffID = T.RT_9,
    RaidDungeonType = 2,
    RaidSeason = 1004,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1784408400)
  },
  [21501] = {
    BaseRaidPoint = 1000,
    DifficultyLevel = 1,
    DungeonId = 21501,
    FomulaId = 1,
    MinCompleteDamage = 70800000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 1,
    RaidSeason = 1005,
    UnlockDate = LocalTimeProxy(1787709600)
  },
  [21502] = {
    BaseRaidPoint = 10000,
    DifficultyLevel = 2,
    DungeonId = 21502,
    FomulaId = 1,
    MinCompleteDamage = 309900000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 1,
    RaidSeason = 1005,
    UnlockDate = LocalTimeProxy(1787709600)
  },
  [21503] = {
    BaseRaidPoint = 135000,
    DifficultyLevel = 3,
    DungeonId = 21503,
    FomulaId = 1,
    MinCompleteDamage = 9223700000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 1,
    RaidSeason = 1005,
    UnlockDate = LocalTimeProxy(1787709600)
  },
  [21511] = {
    BaseRaidPoint = 3500,
    DifficultyLevel = 1,
    DungeonId = 21511,
    FomulaId = 2,
    MinCompleteDamage = 88400000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 2,
    RaidSeason = 1005,
    TicketNum = T.RT_4,
    UnlockDate = LocalTimeProxy(1787968800)
  },
  [21512] = {
    BaseRaidPoint = 40000,
    DifficultyLevel = 2,
    DungeonId = 21512,
    FomulaId = 2,
    MinCompleteDamage = 859700000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 2,
    RaidSeason = 1005,
    TicketNum = T.RT_5,
    UnlockDate = LocalTimeProxy(1787968800)
  },
  [21513] = {
    BaseRaidPoint = 400000,
    DifficultyLevel = 3,
    DungeonId = 21513,
    FomulaId = 2,
    MinCompleteDamage = 10001800000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 2,
    RaidSeason = 1005,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1788037200)
  },
  [21514] = {
    BaseRaidPoint = 1500000,
    DifficultyLevel = 4,
    DungeonId = 21514,
    FomulaId = 2,
    MinCompleteDamage = 38222900000,
    RaidBuffID = T.RT_10,
    RaidDungeonType = 2,
    RaidSeason = 1005,
    TicketNum = T.RT_6,
    UnlockDate = LocalTimeProxy(1788123600)
  }
})
