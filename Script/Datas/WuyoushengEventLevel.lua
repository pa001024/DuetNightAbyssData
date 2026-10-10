local T = {}
T.RT_1 = {
  -1,
  240,
  180
}
T.RT_2 = {603}
T.RT_3 = {
  91000012,
  91000013,
  91000014
}
T.RT_4 = {
  90000011,
  90000012,
  90000013
}
T.RT_5 = {91000011}
T.RT_6 = {603, 604}
T.RT_7 = {91000022}
T.RT_8 = {
  90000021,
  90000022,
  90000023
}
T.RT_9 = {
  91000021,
  91000023,
  91000024
}
T.RT_10 = {
  601,
  603,
  604
}
T.RT_11 = {91000032}
T.RT_12 = {
  90000041,
  90000042,
  90000043
}
T.RT_13 = {
  91000031,
  91000033,
  91000034
}
T.RT_14 = {
  601,
  602,
  603,
  604
}
T.RT_15 = {
  91000052,
  91000053,
  91000054
}
T.RT_16 = {
  90000061,
  90000062,
  90000063
}
T.RT_17 = {91000051}
T.RT_18 = {91000042}
T.RT_19 = {
  90000051,
  90000052,
  90000053
}
T.RT_20 = {
  91000041,
  91000043,
  91000044
}
T.RT_21 = {
  91000062,
  91000063,
  91000064
}
T.RT_22 = {
  90000071,
  90000072,
  90000073
}
T.RT_23 = {91000061}
T.RT_24 = {91000072}
T.RT_25 = {
  90000081,
  90000082,
  90000083
}
T.RT_26 = {
  91000071,
  91000073,
  91000074
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("WuyoushengEventLevel", {
  [22001] = {
    DungeonId = 22001,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes01",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "j",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName01",
    LevelPet = T.RT_2,
    LevelTriaRangedlWeapon = T.RT_3,
    LevelTrialChar = T.RT_4,
    LevelTrialMeleeWeapon = T.RT_5,
    UnlockDate = LocalTimeProxy(1772157600)
  },
  [22002] = {
    DungeonId = 22002,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes02",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "y",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName02",
    LevelPet = T.RT_6,
    LevelTriaRangedlWeapon = T.RT_7,
    LevelTrialChar = T.RT_8,
    LevelTrialMeleeWeapon = T.RT_9,
    PerviousDungeon = 22001,
    UnlockDate = LocalTimeProxy(1772244000)
  },
  [22003] = {
    DungeonId = 22003,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes03",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "b",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName03",
    LevelPet = T.RT_10,
    LevelTriaRangedlWeapon = T.RT_11,
    LevelTrialChar = T.RT_12,
    LevelTrialMeleeWeapon = T.RT_13,
    PerviousDungeon = 22002,
    UnlockDate = LocalTimeProxy(1772330400)
  },
  [22004] = {
    DungeonId = 22004,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_2",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes04",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "d",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName04",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_15,
    LevelTrialChar = T.RT_16,
    LevelTrialMeleeWeapon = T.RT_17,
    PerviousDungeon = 22003,
    UnlockDate = LocalTimeProxy(1772416800)
  },
  [22005] = {
    DungeonId = 22005,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_1",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes05",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "w",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName05",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_18,
    LevelTrialChar = T.RT_19,
    LevelTrialMeleeWeapon = T.RT_20,
    PerviousDungeon = 22004,
    UnlockDate = LocalTimeProxy(1772503200)
  },
  [22006] = {
    DungeonId = 22006,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_3",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes06",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "j",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName06",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_21,
    LevelTrialChar = T.RT_22,
    LevelTrialMeleeWeapon = T.RT_23,
    PerviousDungeon = 22005,
    UnlockDate = LocalTimeProxy(1772589600)
  },
  [22007] = {
    DungeonId = 22007,
    EventId = 110001,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_4",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes07",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "g",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName07",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_24,
    LevelTrialChar = T.RT_25,
    LevelTrialMeleeWeapon = T.RT_26,
    PerviousDungeon = 22006,
    UnlockDate = LocalTimeProxy(1772676000)
  },
  [22008] = {
    DungeonId = 22008,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes01",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "j",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName01",
    LevelPet = T.RT_2,
    LevelTriaRangedlWeapon = T.RT_3,
    LevelTrialChar = T.RT_4,
    LevelTrialMeleeWeapon = T.RT_5,
    UnlockDate = LocalTimeProxy(1795053600)
  },
  [22009] = {
    DungeonId = 22009,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes02",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "y",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName02",
    LevelPet = T.RT_6,
    LevelTriaRangedlWeapon = T.RT_7,
    LevelTrialChar = T.RT_8,
    LevelTrialMeleeWeapon = T.RT_9,
    PerviousDungeon = 22008,
    UnlockDate = LocalTimeProxy(1795140000)
  },
  [22010] = {
    DungeonId = 22010,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_0",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes03",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "b",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName03",
    LevelPet = T.RT_10,
    LevelTriaRangedlWeapon = T.RT_11,
    LevelTrialChar = T.RT_12,
    LevelTrialMeleeWeapon = T.RT_13,
    PerviousDungeon = 22009,
    UnlockDate = LocalTimeProxy(1795226400)
  },
  [22011] = {
    DungeonId = 22011,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_2",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes04",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "d",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName04",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_15,
    LevelTrialChar = T.RT_16,
    LevelTrialMeleeWeapon = T.RT_17,
    PerviousDungeon = 22010,
    UnlockDate = LocalTimeProxy(1795312800)
  },
  [22012] = {
    DungeonId = 22012,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_1",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes05",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "w",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName05",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_18,
    LevelTrialChar = T.RT_19,
    LevelTrialMeleeWeapon = T.RT_20,
    PerviousDungeon = 22011,
    UnlockDate = LocalTimeProxy(1795399200)
  },
  [22013] = {
    DungeonId = 22013,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_3",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes06",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "j",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName06",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_21,
    LevelTrialChar = T.RT_22,
    LevelTrialMeleeWeapon = T.RT_23,
    PerviousDungeon = 22012,
    UnlockDate = LocalTimeProxy(1795485600)
  },
  [22014] = {
    DungeonId = 22014,
    EventId = 103037,
    LevelBuffDes = "UI_WuyoushengEvent_LevelBuff_4",
    LevelDes = "MonsterRushEvent_Wuyou_DungeonDes07",
    LevelGoalRequiredTime1 = T.RT_1,
    LevelIconLetter = "g",
    LevelName = "MonsterRushEvent_Wuyou_DungeonName07",
    LevelPet = T.RT_14,
    LevelTriaRangedlWeapon = T.RT_24,
    LevelTrialChar = T.RT_25,
    LevelTrialMeleeWeapon = T.RT_26,
    PerviousDungeon = 22013,
    UnlockDate = LocalTimeProxy(1795572000)
  }
})
