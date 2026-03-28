local T = {}
T.RT_1 = {
  1,
  2,
  3,
  4,
  5,
  6
}
T.RT_2 = {
  150402,
  230101,
  420101
}
T.RT_3 = {
  10103002,
  20501002,
  20407002,
  10202002,
  10102001,
  20602001,
  10203001,
  20502002
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TreasureHuntRepeatDungeon", {
  [10301401] = {
    DungeonDes = "RepeatDungeon01_Des",
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Gangkou.T_SoloTreasure_Gangkou'",
    DungeonName = "RepeatDungeon01_Title",
    EasyDungeonId = 41802,
    EasyModeFee = 0,
    EventDugeonId = 10301401,
    FeeResource = 6000004,
    HardDungeonId = 41804,
    HardModeFee = 1000,
    IsBanEasyPhantom = false,
    IsBanHardPhantom = true,
    LevelBackPack = T.RT_1,
    TrialCharacter = T.RT_2,
    TrialWeapon = T.RT_3,
    UnlockCondition = 10301401
  },
  [10301402] = {
    DungeonDes = "RepeatDungeon02_Des",
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Wuhui.T_SoloTreasure_Wuhui'",
    DungeonName = "RepeatDungeon02_Title",
    EasyDungeonId = 41806,
    EasyModeFee = 500,
    EventDugeonId = 10301402,
    FeeResource = 6000004,
    HardDungeonId = 41808,
    HardModeFee = 2000,
    IsBanEasyPhantom = false,
    IsBanHardPhantom = true,
    LevelBackPack = T.RT_1,
    TrialCharacter = T.RT_2,
    TrialWeapon = T.RT_3,
    UnlockCondition = 10301402
  },
  [10301403] = {
    DungeonDes = "RepeatDungeon03_Des",
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Dongjiao.T_SoloTreasure_Dongjiao'",
    DungeonName = "RepeatDungeon03_Title",
    EventDugeonId = 10301403,
    FeeResource = 6000004,
    HardDungeonId = 41810,
    HardModeFee = 4000,
    IsBanHardPhantom = true,
    LevelBackPack = T.RT_1,
    TrialCharacter = T.RT_2,
    TrialWeapon = T.RT_3,
    UnlockCondition = 10301403
  },
  [10301404] = {
    DungeonDes = "RepeatDungeon04_Des",
    DungeonImage = "Texture2D'/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_Dongjiao.T_SoloTreasure_Dongjiao'",
    DungeonName = "RepeatDungeon04_Title",
    EasyDungeonId = 41811,
    EasyMaxConvertResource = 1000000,
    EasyModeFee = 1,
    EasyScoreToResource = {
      [2] = 101
    },
    EventDugeonId = 10301404,
    FeeResource = 6000005,
    HardDungeonId = 41812,
    HardMaxConvertResource = 3000000,
    HardModeFee = 3,
    HardScoreToResource = {
      [0] = 101
    },
    IsBanEasyPhantom = false,
    IsBanHardPhantom = true,
    LevelBackPack = T.RT_1,
    TrialCharacter = T.RT_2,
    TrialWeapon = T.RT_3,
    UnlockCondition = 10301404
  }
})
