local T = {}
T.RT_1 = {602}
T.RT_2 = {618}
T.RT_3 = {601}
T.RT_4 = {612}
T.RT_5 = {100601}
T.RT_6 = {200602}
T.RT_7 = {200601}
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
  [60701] = {
    DungeonId = 60701,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [60702] = {
    DungeonId = 60702,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [62701] = {
    DungeonId = 62701,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [62702] = {
    DungeonId = 62702,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [64701] = {
    DungeonId = 64701,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [64702] = {
    DungeonId = 64702,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [90601] = {
    DungeonId = 90601,
    MonsterSpawnId = {100606},
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 999999999
  },
  [90602] = {
    DungeonId = 90602,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [90603] = {
    DungeonId = 90603,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [90604] = {
    DungeonId = 90604,
    MonsterSpawnId = T.RT_6,
    SpMonsterSpawnId = T.RT_2,
    SpMonsterSpawnTime = 40
  },
  [90605] = {
    DungeonId = 90605,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [90606] = {
    DungeonId = 90606,
    MonsterSpawnId = T.RT_3,
    SpMonsterSpawnId = T.RT_4,
    SpMonsterSpawnTime = 40
  },
  [90607] = {
    DungeonId = 90607,
    MonsterSpawnId = T.RT_5,
    SpMonsterSpawnId = {613},
    SpMonsterSpawnTime = 40
  },
  [91144] = {
    DungeonId = 91144,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = {91144},
    SpMonsterSpawnTime = 1
  },
  [91145] = {
    DungeonId = 91145,
    MonsterSpawnId = T.RT_6,
    SpMonsterSpawnId = {91145},
    SpMonsterSpawnTime = 1
  },
  [91181] = {
    DungeonId = 91181,
    MonsterSpawnId = T.RT_7,
    SpMonsterSpawnId = {91181},
    SpMonsterSpawnTime = 1
  },
  [91182] = {
    DungeonId = 91182,
    MonsterSpawnId = T.RT_6,
    SpMonsterSpawnId = {91182},
    SpMonsterSpawnTime = 1
  }
})
