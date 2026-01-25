local T = {}
T.RT_1 = {1}
T.RT_2 = {2}
T.RT_3 = {3}
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
    UnlockDate = 1769133600
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
    UnlockDate = 1769133600
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
    UnlockDate = 1769133600
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
    TicketNum = {
      [217] = 3
    },
    UnlockDate = 1769392800
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
    TicketNum = {
      [217] = 4
    },
    UnlockDate = 1769461200
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
    TicketNum = {
      [217] = 5
    },
    UnlockDate = 1769547600
  }
})
