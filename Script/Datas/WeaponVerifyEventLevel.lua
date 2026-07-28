local T = {}
T.RT_1 = {
  1,
  2,
  3,
  4,
  5
}
T.RT_2 = {
  1001,
  1002,
  1003
}
T.RT_3 = {2001}
T.RT_4 = {
  -1,
  90,
  180
}
T.RT_5 = {
  6,
  7,
  8,
  9,
  10
}
T.RT_6 = {2001, 2002}
T.RT_7 = {
  11,
  12,
  13,
  14,
  15
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("WeaponVerifyEventLevel", {
  [40701] = {
    AffixGroup = T.RT_1,
    EventId = 103026,
    EventLevelId = 40701,
    GlobalBuff = T.RT_2,
    GroupId = 1001,
    LevelBuff = T.RT_3,
    LevelDes = "Event_WV_DungeonTarget01",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName01",
    LevelNumber = "WeaponVerify_DungeonNum01",
    LevelType = 1,
    RecomendLevel = 60
  },
  [40702] = {
    AffixGroup = T.RT_1,
    EventId = 103026,
    EventLevelId = 40702,
    GlobalBuff = T.RT_2,
    GroupId = 1001,
    LevelBuff = T.RT_3,
    LevelDes = "Event_WV_DungeonTarget02",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName02",
    LevelNumber = "WeaponVerify_DungeonNum02",
    LevelType = 2,
    RecomendLevel = 60
  },
  [40703] = {
    AffixGroup = T.RT_1,
    EventId = 103026,
    EventLevelId = 40703,
    GlobalBuff = T.RT_2,
    GroupId = 1001,
    LevelBuff = T.RT_3,
    LevelDes = "Event_WV_DungeonTarget01",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName03",
    LevelNumber = "WeaponVerify_DungeonNum03",
    LevelType = 1,
    RecomendLevel = 70
  },
  [40704] = {
    AffixGroup = T.RT_1,
    EventId = 103026,
    EventLevelId = 40704,
    GlobalBuff = T.RT_2,
    GroupId = 1001,
    LevelBuff = T.RT_3,
    LevelDes = "Event_WV_DungeonTarget02",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName04",
    LevelNumber = "WeaponVerify_DungeonNum04",
    LevelType = 2,
    RecomendLevel = 70
  },
  [40711] = {
    AffixGroup = T.RT_5,
    EventId = 103026,
    EventLevelId = 40711,
    GlobalBuff = T.RT_2,
    GroupId = 1002,
    LevelBuff = T.RT_6,
    LevelDes = "Event_WV_DungeonTarget01",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName05",
    LevelNumber = "WeaponVerify_DungeonNum05",
    LevelType = 1,
    RecomendLevel = 80
  },
  [40712] = {
    AffixGroup = T.RT_5,
    EventId = 103026,
    EventLevelId = 40712,
    GlobalBuff = T.RT_2,
    GroupId = 1002,
    LevelBuff = T.RT_6,
    LevelDes = "Event_WV_DungeonTarget02",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName06",
    LevelNumber = "WeaponVerify_DungeonNum06",
    LevelType = 2,
    RecomendLevel = 80
  },
  [40713] = {
    AffixGroup = T.RT_5,
    EventId = 103026,
    EventLevelId = 40713,
    GlobalBuff = T.RT_2,
    GroupId = 1002,
    LevelBuff = T.RT_6,
    LevelDes = "Event_WV_DungeonTarget01",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName07",
    LevelNumber = "WeaponVerify_DungeonNum07",
    LevelType = 1,
    RecomendLevel = 80
  },
  [40714] = {
    AffixGroup = T.RT_5,
    EventId = 103026,
    EventLevelId = 40714,
    GlobalBuff = T.RT_2,
    GroupId = 1002,
    LevelBuff = T.RT_6,
    LevelDes = "Event_WV_DungeonTarget02",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName08",
    LevelNumber = "WeaponVerify_DungeonNum08",
    LevelType = 2,
    RecomendLevel = 80
  },
  [40721] = {
    AffixGroup = T.RT_7,
    EventId = 103026,
    EventLevelId = 40721,
    GlobalBuff = T.RT_2,
    GroupId = 1003,
    LevelBuff = {
      2001,
      2002,
      2003
    },
    LevelDes = "Event_WV_DungeonTarget01",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName09",
    LevelNumber = "WeaponVerify_DungeonNum09",
    LevelType = 1,
    RecomendLevel = 80
  },
  [40722] = {
    AffixGroup = T.RT_7,
    EventId = 103026,
    EventLevelId = 40722,
    GlobalBuff = T.RT_2,
    GroupId = 1003,
    LevelBuff = {
      2001,
      2002,
      2005
    },
    LevelDes = "Event_WV_DungeonTarget02",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName10",
    LevelNumber = "WeaponVerify_DungeonNum10",
    LevelType = 2,
    RecomendLevel = 80
  },
  [40723] = {
    AffixGroup = T.RT_7,
    EventId = 103026,
    EventLevelId = 40723,
    GlobalBuff = T.RT_2,
    GroupId = 1003,
    LevelBuff = {
      2001,
      2002,
      2004
    },
    LevelDes = "Event_WV_DungeonTarget01",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName11",
    LevelNumber = "WeaponVerify_DungeonNum11",
    LevelType = 1,
    RecomendLevel = 80
  },
  [40724] = {
    AffixGroup = T.RT_7,
    EventId = 103026,
    EventLevelId = 40724,
    GlobalBuff = T.RT_2,
    GroupId = 1003,
    LevelBuff = {
      2001,
      2002,
      2006
    },
    LevelDes = "Event_WV_DungeonTarget02",
    LevelGoalRequiredTime = T.RT_4,
    LevelName = "WeaponVerify_DungeonName12",
    LevelNumber = "WeaponVerify_DungeonNum12",
    LevelType = 2,
    RecomendLevel = 80
  }
})
