local T = {}
T.RT_1 = {
  10,
  20,
  30,
  40,
  50,
  60,
  70
}
T.RT_2 = {
  1,
  2,
  3
}
T.RT_3 = {
  30,
  40,
  50,
  60,
  70,
  80
}
T.RT_4 = {40}
T.RT_5 = {
  4,
  5,
  6
}
T.RT_6 = {
  30,
  50,
  70,
  90,
  100
}
T.RT_7 = {
  7,
  8,
  9
}
T.RT_8 = {
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18
}
T.RT_9 = {
  10,
  20,
  30,
  40,
  50,
  60,
  70,
  80
}
T.RT_10 = {
  40,
  50,
  60,
  70,
  80
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TeamSecondType", {
  [1] = {
    DisplayOrder = 1,
    DungeonLevel = T.RT_1,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_02.LevelSelect_02'",
    Name = "UI_teamHallModeA_1",
    SecondType = 1,
    Tags = T.RT_2
  },
  [2] = {
    DisplayOrder = 2,
    DungeonLevel = T.RT_1,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_09.LevelSelect_09'",
    Name = "UI_teamHallModeA_2",
    SecondType = 2,
    Tags = T.RT_2
  },
  [3] = {
    DisplayOrder = 3,
    DungeonLevel = T.RT_9,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_11.LevelSelect_11'",
    Name = "UI_teamHallModeA_3",
    SecondType = 3,
    Tags = T.RT_2
  },
  [4] = {
    DisplayOrder = 4,
    DungeonLevel = T.RT_1,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_03.LevelSelect_03'",
    Name = "UI_teamHallModeA_4",
    SecondType = 4,
    Tags = T.RT_2
  },
  [5] = {
    DisplayOrder = 5,
    DungeonLevel = T.RT_9,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_07.LevelSelect_07'",
    Name = "UI_teamHallModeA_5",
    SecondType = 5,
    Tags = T.RT_2
  },
  [6] = {
    DisplayOrder = 6,
    DungeonLevel = {
      40,
      60,
      80,
      100
    },
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_13.LevelSelect_13'",
    Name = "UI_teamHallModeA_6",
    SecondType = 6,
    Tags = T.RT_2
  },
  [7] = {
    DisplayOrder = 7,
    DungeonLevel = T.RT_3,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_12.LevelSelect_12'",
    Name = "UI_teamHallModeA_7",
    SecondType = 7,
    Tags = T.RT_2
  },
  [8] = {
    DisplayOrder = 8,
    DungeonLevel = T.RT_10,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_06.LevelSelect_06'",
    Name = "UI_teamHallModeA_8",
    SecondType = 8,
    Tags = T.RT_2
  },
  [9] = {
    DisplayOrder = 9,
    DungeonLevel = T.RT_10,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_04.LevelSelect_04'",
    Name = "UI_teamHallModeA_9",
    SecondType = 9,
    Tags = T.RT_2
  },
  [10] = {
    DisplayOrder = 10,
    DungeonLevel = T.RT_3,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_08.LevelSelect_08'",
    Name = "UI_teamHallModeA_10",
    SecondType = 10,
    Tags = T.RT_2
  },
  [11] = {
    DisplayOrder = 11,
    DungeonLevel = T.RT_4,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/T_Play_Walnut03.T_Play_Walnut03'",
    Name = "UI_teamHallModeB_1",
    SecondType = 11,
    Tags = T.RT_5
  },
  [12] = {
    DisplayOrder = 12,
    DungeonLevel = T.RT_4,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/T_Play_Walnut01.T_Play_Walnut01'",
    Name = "UI_teamHallModeB_2",
    SecondType = 12,
    Tags = T.RT_5
  },
  [13] = {
    DisplayOrder = 13,
    DungeonLevel = T.RT_4,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/T_Play_Walnut02.T_Play_Walnut02'",
    Name = "UI_teamHallModeB_3",
    SecondType = 13,
    Tags = T.RT_5
  },
  [14] = {
    DisplayOrder = 14,
    DungeonLevel = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/T_Play_Weekly_BG.T_Play_Weekly_BG'",
    Name = "UI_teamHallModeC_1",
    SecondType = 14,
    Tags = T.RT_7
  },
  [15] = {
    DisplayOrder = 15,
    DungeonLevel = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/T_Play_Weekly02_BG.T_Play_Weekly02_BG'",
    Name = "UI_teamHallModeC_2",
    SecondType = 15,
    Tags = T.RT_7
  },
  [16] = {
    DisplayOrder = 16,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_15.LevelSelect_15'",
    Name = "UI_teamHallModeD_1",
    SecondType = 16,
    Tags = T.RT_8
  },
  [17] = {
    DisplayOrder = 17,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/LevelSelect_16.LevelSelect_16'",
    Name = "UI_teamHallModeD_2",
    SecondType = 17,
    Tags = T.RT_8
  }
})
