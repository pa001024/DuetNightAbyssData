local T = {}
T.RT_1 = {
  10001062,
  10002001,
  10004062,
  6017001,
  6016001,
  6015001
}
T.RT_2 = {
  23001,
  23002,
  23003,
  23004
}
T.RT_3 = {2210101}
T.RT_4 = {
  11001101,
  49016001,
  49017001,
  49018001
}
T.RT_5 = {
  23001,
  23002,
  23003,
  23004,
  23005
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("WeaponVerify", {
  [40701] = {
    BeginDelay = 3,
    DungeonId = 40701,
    DungeonMonsters = T.RT_1,
    GlobalPassiveId = T.RT_2,
    IsForbidPhantomAndBattleWheel = true,
    MonsterSpawnId = T.RT_3,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 2,
    WinTarget = 300
  },
  [40702] = {
    AirWallCreatorId = T.RT_4,
    BeginDelay = 3,
    BossCreatorId = {851460601},
    DungeonId = 40702,
    DungeonMonsters = {8514606},
    GlobalPassiveId = T.RT_2,
    IsForbidPhantomAndBattleWheel = true,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 1,
    WinTarget = 851460601
  },
  [40703] = {
    BeginDelay = 3,
    DungeonId = 40703,
    DungeonMonsters = T.RT_1,
    GlobalPassiveId = T.RT_2,
    IsForbidPhantomAndBattleWheel = true,
    MonsterSpawnId = T.RT_3,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 2,
    WinTarget = 300
  },
  [40704] = {
    AirWallCreatorId = T.RT_4,
    BeginDelay = 3,
    BossCreatorId = {850260301},
    DungeonId = 40704,
    DungeonMonsters = {8502603},
    GlobalPassiveId = T.RT_2,
    IsForbidPhantomAndBattleWheel = true,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 1,
    WinTarget = 850260301
  },
  [40711] = {
    BeginDelay = 3,
    DungeonId = 40711,
    DungeonMonsters = T.RT_1,
    GlobalPassiveId = T.RT_5,
    IsForbidPhantomAndBattleWheel = true,
    MonsterSpawnId = T.RT_3,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 2,
    WinTarget = 300
  },
  [40712] = {
    AirWallCreatorId = T.RT_4,
    BeginDelay = 3,
    BossCreatorId = {851860201},
    DungeonId = 40712,
    DungeonMonsters = {8518602},
    GlobalPassiveId = T.RT_5,
    IsForbidPhantomAndBattleWheel = true,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 1,
    WinTarget = 851860201
  },
  [40713] = {
    BeginDelay = 3,
    DungeonId = 40713,
    DungeonMonsters = T.RT_1,
    GlobalPassiveId = T.RT_5,
    IsForbidPhantomAndBattleWheel = true,
    MonsterSpawnId = T.RT_3,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 2,
    WinTarget = 300
  },
  [40714] = {
    AirWallCreatorId = T.RT_4,
    BeginDelay = 3,
    BossCreatorId = {851260701},
    DungeonId = 40714,
    DungeonMonsters = {8512607},
    GlobalPassiveId = T.RT_5,
    IsForbidPhantomAndBattleWheel = true,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 1,
    WinTarget = 851260701
  },
  [40721] = {
    BeginDelay = 3,
    DungeonId = 40721,
    DungeonMonsters = T.RT_1,
    GlobalPassiveId = {
      23001,
      23002,
      23003,
      23004,
      23005,
      23006
    },
    IsForbidPhantomAndBattleWheel = true,
    MonsterSpawnId = T.RT_3,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 2,
    WinTarget = 300
  },
  [40722] = {
    AirWallCreatorId = T.RT_4,
    BeginDelay = 3,
    BossCreatorId = {852260601},
    DungeonId = 40722,
    DungeonMonsters = {8522606},
    GlobalPassiveId = T.RT_5,
    IsForbidPhantomAndBattleWheel = true,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 1,
    WinTarget = 852260601
  },
  [40723] = {
    BeginDelay = 3,
    DungeonId = 40723,
    DungeonMonsters = T.RT_1,
    GlobalPassiveId = {
      23001,
      23002,
      23003,
      23004,
      23005,
      23007
    },
    IsForbidPhantomAndBattleWheel = true,
    MonsterSpawnId = T.RT_3,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 2,
    WinTarget = 300
  },
  [40724] = {
    AirWallCreatorId = T.RT_4,
    BeginDelay = 3,
    BossCreatorId = {850060601},
    DungeonId = 40724,
    DungeonMonsters = {8500606},
    GlobalPassiveId = T.RT_5,
    IsForbidPhantomAndBattleWheel = true,
    TotalTime = 300,
    WinDelay = 5,
    WinMode = 1,
    WinTarget = 850060601
  }
})
