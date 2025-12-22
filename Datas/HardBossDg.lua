local T = {}
T.RT_1 = {
  [1] = 8500501,
  [2] = 8500502,
  [3] = 8500502,
  [4] = 8500503
}
T.RT_2 = {
  [1] = 8503501,
  [2] = 8503502,
  [3] = 8503502,
  [4] = 8503503
}
T.RT_3 = {
  [1] = 8502501,
  [2] = 8502502,
  [3] = 8502502,
  [4] = 8502503
}
T.RT_4 = {
  [1] = 8505501,
  [2] = 8505502,
  [3] = 8505502,
  [4] = 8505503
}
T.RT_5 = {
  [1] = 8512501,
  [2] = 8512502,
  [3] = 8512502,
  [4] = 8512503
}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HardBossDg", {
  [50101] = {
    AirWallStaticId = 1610010620,
    BossStaticId = 1310010602,
    BossUnitId = T.RT_1,
    DifficultyId = 1001,
    DungeonId = 50101,
    HardBossId = 1
  },
  [50102] = {
    AirWallStaticId = 1610010620,
    BossStaticId = 1310010602,
    BossUnitId = T.RT_1,
    DifficultyId = 1002,
    DungeonId = 50102,
    HardBossId = 1
  },
  [50103] = {
    AirWallStaticId = 1610010620,
    BossStaticId = 1310010602,
    BossUnitId = T.RT_1,
    DifficultyId = 1003,
    DungeonId = 50103,
    HardBossId = 1
  },
  [50104] = {
    AirWallStaticId = 1610010620,
    BossStaticId = 1310010602,
    BossUnitId = T.RT_1,
    DifficultyId = 1004,
    DungeonId = 50104,
    HardBossId = 1
  },
  [50105] = {
    AirWallStaticId = 1610010620,
    BossStaticId = 1310010602,
    BossUnitId = T.RT_1,
    DifficultyId = 1005,
    DungeonId = 50105,
    HardBossId = 1
  },
  [50106] = {
    AirWallStaticId = 1610010620,
    BossStaticId = 1310010602,
    BossUnitId = T.RT_1,
    DifficultyId = 1006,
    DungeonId = 50106,
    HardBossId = 1
  },
  [50201] = {
    AirWallStaticId = 1440064,
    BossStaticId = 1440052,
    BossUnitId = T.RT_2,
    DifficultyId = 1011,
    DungeonId = 50201,
    HardBossId = 2
  },
  [50202] = {
    AirWallStaticId = 1440064,
    BossStaticId = 1440052,
    BossUnitId = T.RT_2,
    DifficultyId = 1012,
    DungeonId = 50202,
    HardBossId = 2
  },
  [50203] = {
    AirWallStaticId = 1440064,
    BossStaticId = 1440052,
    BossUnitId = T.RT_2,
    DifficultyId = 1013,
    DungeonId = 50203,
    HardBossId = 2
  },
  [50204] = {
    AirWallStaticId = 1440064,
    BossStaticId = 1440052,
    BossUnitId = T.RT_2,
    DifficultyId = 1014,
    DungeonId = 50204,
    HardBossId = 2
  },
  [50205] = {
    AirWallStaticId = 1440064,
    BossStaticId = 1440052,
    BossUnitId = T.RT_2,
    DifficultyId = 1015,
    DungeonId = 50205,
    HardBossId = 2
  },
  [50206] = {
    AirWallStaticId = 1440064,
    BossStaticId = 1440052,
    BossUnitId = T.RT_2,
    DifficultyId = 1016,
    DungeonId = 50206,
    HardBossId = 2
  },
  [50301] = {
    AirWallStaticId = 1240025,
    BossStaticId = 1240027,
    BossUnitId = T.RT_3,
    DifficultyId = 1021,
    DungeonId = 50301,
    HardBossId = 3
  },
  [50302] = {
    AirWallStaticId = 1240025,
    BossStaticId = 1240027,
    BossUnitId = T.RT_3,
    DifficultyId = 1022,
    DungeonId = 50302,
    HardBossId = 3
  },
  [50303] = {
    AirWallStaticId = 1240025,
    BossStaticId = 1240027,
    BossUnitId = T.RT_3,
    DifficultyId = 1023,
    DungeonId = 50303,
    HardBossId = 3
  },
  [50304] = {
    AirWallStaticId = 1240025,
    BossStaticId = 1240027,
    BossUnitId = T.RT_3,
    DifficultyId = 1024,
    DungeonId = 50304,
    HardBossId = 3
  },
  [50305] = {
    AirWallStaticId = 1240025,
    BossStaticId = 1240027,
    BossUnitId = T.RT_3,
    DifficultyId = 1025,
    DungeonId = 50305,
    HardBossId = 3
  },
  [50306] = {
    AirWallStaticId = 1240025,
    BossStaticId = 1240027,
    BossUnitId = T.RT_3,
    DifficultyId = 1026,
    DungeonId = 50306,
    HardBossId = 3
  },
  [50401] = {
    AirWallStaticId = 1660120,
    BossStaticId = 1660121,
    BossUnitId = T.RT_4,
    DifficultyId = 1031,
    DungeonId = 50401,
    HardBossId = 4
  },
  [50402] = {
    AirWallStaticId = 1660120,
    BossStaticId = 1660121,
    BossUnitId = T.RT_4,
    DifficultyId = 1032,
    DungeonId = 50402,
    HardBossId = 4
  },
  [50403] = {
    AirWallStaticId = 1660120,
    BossStaticId = 1660121,
    BossUnitId = T.RT_4,
    DifficultyId = 1033,
    DungeonId = 50403,
    HardBossId = 4
  },
  [50404] = {
    AirWallStaticId = 1660120,
    BossStaticId = 1660121,
    BossUnitId = T.RT_4,
    DifficultyId = 1034,
    DungeonId = 50404,
    HardBossId = 4
  },
  [50405] = {
    AirWallStaticId = 1660120,
    BossStaticId = 1660121,
    BossUnitId = T.RT_4,
    DifficultyId = 1035,
    DungeonId = 50405,
    HardBossId = 4
  },
  [50406] = {
    AirWallStaticId = 1660120,
    BossStaticId = 1660121,
    BossUnitId = T.RT_4,
    DifficultyId = 1036,
    DungeonId = 50406,
    HardBossId = 4
  },
  [50501] = {
    AirWallStaticId = 1969947,
    BossStaticId = 1969946,
    BossUnitId = T.RT_5,
    DifficultyId = 1041,
    DungeonId = 50501,
    HardBossId = 5
  },
  [50502] = {
    AirWallStaticId = 1969947,
    BossStaticId = 1969946,
    BossUnitId = T.RT_5,
    DifficultyId = 1042,
    DungeonId = 50502,
    HardBossId = 5
  },
  [50503] = {
    AirWallStaticId = 1969947,
    BossStaticId = 1969946,
    BossUnitId = T.RT_5,
    DifficultyId = 1043,
    DungeonId = 50503,
    HardBossId = 5
  },
  [50504] = {
    AirWallStaticId = 1969947,
    BossStaticId = 1969946,
    BossUnitId = T.RT_5,
    DifficultyId = 1044,
    DungeonId = 50504,
    HardBossId = 5
  },
  [50505] = {
    AirWallStaticId = 1969947,
    BossStaticId = 1969946,
    BossUnitId = T.RT_5,
    DifficultyId = 1045,
    DungeonId = 50505,
    HardBossId = 5
  },
  [50506] = {
    AirWallStaticId = 1969947,
    BossStaticId = 1969946,
    BossUnitId = T.RT_5,
    DifficultyId = 1046,
    DungeonId = 50506,
    HardBossId = 5
  }
})
