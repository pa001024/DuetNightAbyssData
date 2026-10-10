local T = {}
T.RT_1 = {2200101, 2200102}
T.RT_2 = {
  2560001,
  2010194,
  2560008,
  1120008,
  1120009
}
T.RT_3 = {2200201, 2200202}
T.RT_4 = {
  2570002,
  2010194,
  2570008,
  1710055,
  1710061
}
T.RT_5 = {2200301, 2200302}
T.RT_6 = {
  2560003,
  2010194,
  2560008,
  1120008,
  1120009
}
T.RT_7 = {22002}
T.RT_8 = {2200401, 2200402}
T.RT_9 = {
  2570009,
  2010194,
  2570008,
  1710055,
  1710061
}
T.RT_10 = {22001}
T.RT_11 = {2200501, 2200502}
T.RT_12 = {
  2560004,
  2010194,
  2560008,
  1120008,
  1120009
}
T.RT_13 = {22003}
T.RT_14 = {2200601, 2200602}
T.RT_15 = {
  2570005,
  2010194,
  2570008,
  1710055,
  1710061
}
T.RT_16 = {22004}
T.RT_17 = {2200701, 2200702}
T.RT_18 = {
  2560007,
  2010191,
  2560008,
  1120008,
  1120009
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MonsterRushDungeon", {
  [22001] = {
    LevelId = 22001,
    MonsterList = T.RT_1,
    StaticCreatorList = T.RT_2,
    TargetNum = 300
  },
  [22002] = {
    LevelId = 22002,
    MonsterList = T.RT_3,
    StaticCreatorList = T.RT_4,
    TargetNum = 300
  },
  [22003] = {
    LevelId = 22003,
    MonsterList = T.RT_5,
    StaticCreatorList = T.RT_6,
    TargetNum = 300
  },
  [22004] = {
    GlobalPassiveList = T.RT_7,
    LevelId = 22004,
    MonsterList = T.RT_8,
    StaticCreatorList = T.RT_9,
    TargetNum = 300
  },
  [22005] = {
    GlobalPassiveList = T.RT_10,
    LevelId = 22005,
    MonsterList = T.RT_11,
    StaticCreatorList = T.RT_12,
    TargetNum = 300
  },
  [22006] = {
    GlobalPassiveList = T.RT_13,
    LevelId = 22006,
    MonsterList = T.RT_14,
    StaticCreatorList = T.RT_15,
    TargetNum = 300
  },
  [22007] = {
    GlobalPassiveList = T.RT_16,
    LevelId = 22007,
    MonsterList = T.RT_17,
    StaticCreatorList = T.RT_18,
    TargetNum = 300
  },
  [22008] = {
    LevelId = 22008,
    MonsterList = T.RT_1,
    StaticCreatorList = T.RT_2,
    TargetNum = 300
  },
  [22009] = {
    LevelId = 22009,
    MonsterList = T.RT_3,
    StaticCreatorList = T.RT_4,
    TargetNum = 300
  },
  [22010] = {
    LevelId = 22010,
    MonsterList = T.RT_5,
    StaticCreatorList = T.RT_6,
    TargetNum = 300
  },
  [22011] = {
    GlobalPassiveList = T.RT_7,
    LevelId = 22011,
    MonsterList = T.RT_8,
    StaticCreatorList = T.RT_9,
    TargetNum = 300
  },
  [22012] = {
    GlobalPassiveList = T.RT_10,
    LevelId = 22012,
    MonsterList = T.RT_11,
    StaticCreatorList = T.RT_12,
    TargetNum = 300
  },
  [22013] = {
    GlobalPassiveList = T.RT_13,
    LevelId = 22013,
    MonsterList = T.RT_14,
    StaticCreatorList = T.RT_15,
    TargetNum = 300
  },
  [22014] = {
    GlobalPassiveList = T.RT_16,
    LevelId = 22014,
    MonsterList = T.RT_17,
    StaticCreatorList = T.RT_18,
    TargetNum = 300
  }
})
