local T = {}
T.RT_1 = {
  1,
  2,
  3,
  4,
  5,
  6
}
T.RT_2 = {605}
T.RT_3 = {
  1504,
  4201,
  1601,
  160101,
  1201,
  120101
}
T.RT_4 = {150402, 420101}
T.RT_5 = {
  10103002,
  20501002,
  20407002,
  10202002,
  10203001,
  20502002
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TreasureHuntStoryDungeon", {
  [10301411] = {
    DungeonDes = "StoryDungeon01_Des",
    DungeonId = 41801,
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Gangkou.T_SoloTreasure_Gangkou'",
    DungeonName = "StoryDungeon01_Title",
    EventDugeonId = 10301411,
    Fee = 0,
    FeeResource = 6000004,
    IsBanPhantom = false,
    LevelBackPack = T.RT_1,
    LimitCharacter = {
      1504,
      2301,
      1601,
      160101,
      1201,
      120101
    },
    TrialCharacter = {150402, 230101},
    TrialPet = T.RT_2,
    TrialWeapon = {
      10103002,
      20501002,
      20407002,
      10202002,
      10102001,
      20602001
    },
    UnlockCondition = 10301422
  },
  [10301412] = {
    DungeonDes = "StoryDungeon02_Des",
    DungeonId = 41803,
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Gangkou.T_SoloTreasure_Gangkou'",
    DungeonName = "StoryDungeon02_Title",
    EventDugeonId = 10301412,
    Fee = 1000,
    FeeResource = 6000004,
    IsBanPhantom = false,
    LevelBackPack = T.RT_1,
    LimitCharacter = T.RT_3,
    TrialCharacter = T.RT_4,
    TrialPet = T.RT_2,
    TrialWeapon = T.RT_5,
    UnlockCondition = 10301423
  },
  [10301413] = {
    DungeonDes = "StoryDungeon03_Des",
    DungeonId = 41805,
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Wuhui.T_SoloTreasure_Wuhui'",
    DungeonName = "StoryDungeon03_Title",
    EventDugeonId = 10301413,
    Fee = 2000,
    FeeResource = 6000004,
    IsBanPhantom = false,
    LevelBackPack = T.RT_1,
    LimitCharacter = T.RT_3,
    TrialCharacter = T.RT_4,
    TrialPet = T.RT_2,
    TrialWeapon = T.RT_5,
    UnlockCondition = 10301424
  },
  [10301414] = {
    DungeonDes = "StoryDungeon04_Des",
    DungeonId = 41807,
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Wuhui.T_SoloTreasure_Wuhui'",
    DungeonName = "StoryDungeon04_Title",
    EventDugeonId = 10301414,
    Fee = 3000,
    FeeResource = 6000004,
    IsBanPhantom = false,
    LevelBackPack = T.RT_1,
    LimitCharacter = T.RT_3,
    TrialCharacter = T.RT_4,
    TrialPet = T.RT_2,
    TrialWeapon = T.RT_5,
    UnlockCondition = 10301425
  },
  [10301415] = {
    DungeonDes = "StoryDungeon05_Des",
    DungeonId = 41809,
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Dongjiao.T_SoloTreasure_Dongjiao'",
    DungeonName = "StoryDungeon05_Title",
    EventDugeonId = 10301415,
    Fee = 5000,
    FeeResource = 6000004,
    IsBanPhantom = false,
    LevelBackPack = T.RT_1,
    LimitCharacter = {
      4201,
      2301,
      1601,
      160101,
      1201,
      120101
    },
    TrialCharacter = {420101, 230101},
    TrialPet = {-1},
    TrialWeapon = {
      10103002,
      20501002,
      10203001,
      20502002,
      10102001,
      20602001
    },
    UnlockCondition = 10301426
  }
})
