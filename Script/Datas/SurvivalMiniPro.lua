local T = {}
T.RT_1 = {602}
T.RT_2 = {618}
T.RT_3 = {200601}
T.RT_4 = {91132}
T.RT_5 = {601}
T.RT_6 = {612}
T.RT_7 = {100601}
T.RT_8 = {300601}
T.RT_9 = {300602}
T.RT_10 = {200602}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SurvivalMiniPro", {
  [30601] = {
    DungeonId = 30601,
    MonsterSpawnId = T.RT_1,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [30602] = {
    DungeonId = 30602,
    MonsterSpawnId = T.RT_1,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [30603] = {
    DungeonId = 30603,
    MonsterSpawnId = T.RT_1,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [30604] = {
    DungeonId = 30604,
    MonsterSpawnId = T.RT_1,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [30605] = {
    DungeonId = 30605,
    MonsterSpawnId = T.RT_1,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [30606] = {
    DungeonId = 30606,
    MonsterSpawnId = T.RT_1,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [30607] = {
    DungeonId = 30607,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 1
  },
  [30608] = {
    DungeonId = 30608,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 1
  },
  [30609] = {
    DungeonId = 30609,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 1
  },
  [60701] = {
    DungeonId = 60701,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [60702] = {
    DungeonId = 60702,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [62701] = {
    DungeonId = 62701,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [62702] = {
    DungeonId = 62702,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [64701] = {
    DungeonId = 64701,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [64702] = {
    DungeonId = 64702,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [90601] = {
    DungeonId = 90601,
    MonsterSpawnId = {100606},
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 999999999
  },
  [90602] = {
    DungeonId = 90602,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [90603] = {
    DungeonId = 90603,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [90604] = {
    DungeonId = 90604,
    MonsterSpawnId = T.RT_10,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [90605] = {
    DungeonId = 90605,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [90606] = {
    DungeonId = 90606,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_6,
    SpMonsterSpawnTime = 40
  },
  [90607] = {
    DungeonId = 90607,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = {613},
    SpMonsterSpawnTime = 40
  },
  [91132] = {
    DungeonId = 91132,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 1
  },
  [91133] = {
    DungeonId = 91133,
    MonsterSpawnId = T.RT_10,
    SpMonsterSpawnId = {91133},
    SpMonsterSpawnTime = 1
  },
  [91144] = {
    DungeonId = 91144,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = {91144},
    SpMonsterSpawnTime = 1
  },
  [91145] = {
    DungeonId = 91145,
    MonsterSpawnId = T.RT_10,
    SpMonsterSpawnId = {91145},
    SpMonsterSpawnTime = 1
  },
  [91148] = {
    DungeonId = 91148,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = {91148},
    SpMonsterSpawnTime = 1
  },
  [91149] = {
    DungeonId = 91149,
    MonsterSpawnId = T.RT_10,
    SpMonsterSpawnId = {91149},
    SpMonsterSpawnTime = 1
  },
  [91181] = {
    DungeonId = 91181,
    MonsterSpawnId = {200601, 911810},
    SpMonsterSpawnId = {91181},
    SpMonsterSpawnTime = 1
  },
  [91182] = {
    DungeonId = 91182,
    MonsterSpawnId = {200602, 911820},
    SpMonsterSpawnId = {91182},
    SpMonsterSpawnTime = 1
  },
  [91206] = {
    DungeonId = 91206,
    MonsterSpawnId = {200601, 912060},
    SpMonsterSpawnId = {91206},
    SpMonsterSpawnTime = 1
  },
  [91207] = {
    DungeonId = 91207,
    MonsterSpawnId = {200602, 912070},
    SpMonsterSpawnId = {91207},
    SpMonsterSpawnTime = 1
  },
  [91210] = {
    DungeonId = 91210,
    MonsterSpawnId = {200601, 912100},
    SpMonsterSpawnId = {91210},
    SpMonsterSpawnTime = 1
  },
  [91211] = {
    DungeonId = 91211,
    MonsterSpawnId = {200602, 912110},
    SpMonsterSpawnId = {91211},
    SpMonsterSpawnTime = 1
  },
  [614005] = {
    DungeonId = 614005,
    MonsterSpawnId = T.RT_8,
    SpMonsterSpawnId = {614005},
    SpMonsterSpawnTime = 1
  },
  [614006] = {
    DungeonId = 614006,
    MonsterSpawnId = T.RT_9,
    SpMonsterSpawnId = {614006},
    SpMonsterSpawnTime = 1
  },
  [614105] = {
    DungeonId = 614105,
    MonsterSpawnId = {300601, 6141050},
    SpMonsterSpawnId = {614105},
    SpMonsterSpawnTime = 1
  },
  [614106] = {
    DungeonId = 614106,
    MonsterSpawnId = {300602, 6141060},
    SpMonsterSpawnId = {614106},
    SpMonsterSpawnTime = 1
  },
  [615003] = {
    DungeonId = 615003,
    MonsterSpawnId = T.RT_8,
    SpMonsterSpawnId = {615003},
    SpMonsterSpawnTime = 1
  },
  [615004] = {
    DungeonId = 615004,
    MonsterSpawnId = T.RT_9,
    SpMonsterSpawnId = {615004},
    SpMonsterSpawnTime = 1
  },
  [615103] = {
    DungeonId = 615103,
    MonsterSpawnId = {300601, 6151030},
    SpMonsterSpawnId = {615103},
    SpMonsterSpawnTime = 1
  },
  [615104] = {
    DungeonId = 615104,
    MonsterSpawnId = {300602, 6151040},
    SpMonsterSpawnId = {615104},
    SpMonsterSpawnTime = 1
  }
})
