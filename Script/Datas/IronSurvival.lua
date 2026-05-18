local T = {}
T.RT_1 = {
  [1] = 120,
  [2] = 160
}
T.RT_2 = {916021, 916101}
T.RT_3 = {916012, 916102}
T.RT_4 = {916023, 916103}
T.RT_5 = {916014, 916104}
T.RT_6 = {916025, 916105}
T.RT_7 = {916016, 916106}
T.RT_8 = {
  [1] = T.RT_2,
  [2] = T.RT_3,
  [3] = T.RT_4,
  [4] = T.RT_5,
  [5] = T.RT_6,
  [6] = T.RT_7
}
T.RT_9 = {
  [1] = 50,
  [2] = 50,
  [3] = 50
}
T.RT_10 = {
  916031,
  916032,
  916033,
  916034
}
T.RT_11 = {
  916035,
  916036,
  916037,
  916038,
  916039,
  916040,
  916041,
  916042
}
T.RT_12 = {
  916043,
  916044,
  916045,
  916046,
  916047,
  916048,
  916049,
  916050,
  916051,
  916052,
  916053,
  916054,
  916055,
  916056,
  916057,
  916058,
  916059,
  916060
}
T.RT_13 = {
  [1] = T.RT_10,
  [2] = T.RT_11,
  [3] = T.RT_12
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("IronSurvival", {
  [91601] = {
    DungeonId = 91601,
    LevelThreshold = T.RT_1,
    MonsterSpawnId = T.RT_8,
    StrongKillCount = T.RT_9,
    StrongLoopSpawnId = T.RT_13
  },
  [91602] = {
    DungeonId = 91602,
    LevelThreshold = T.RT_1,
    MonsterSpawnId = T.RT_8,
    StrongKillCount = T.RT_9,
    StrongLoopSpawnId = T.RT_13
  },
  [91603] = {
    DungeonId = 91603,
    LevelThreshold = T.RT_1,
    MonsterSpawnId = T.RT_8,
    StrongKillCount = T.RT_9,
    StrongLoopSpawnId = T.RT_13
  },
  [91604] = {
    DungeonId = 91604,
    LevelThreshold = T.RT_1,
    MonsterSpawnId = T.RT_8,
    StrongKillCount = T.RT_9,
    StrongLoopSpawnId = T.RT_13
  },
  [91605] = {
    DungeonId = 91605,
    LevelThreshold = T.RT_1,
    MonsterSpawnId = T.RT_8,
    StrongKillCount = T.RT_9,
    StrongLoopSpawnId = T.RT_13
  },
  [91606] = {
    DungeonId = 91606,
    LevelThreshold = T.RT_1,
    MonsterSpawnId = T.RT_8,
    StrongKillCount = T.RT_9,
    StrongLoopSpawnId = T.RT_13
  }
})
