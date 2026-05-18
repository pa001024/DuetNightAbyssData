local T = {}
T.RT_1 = {1, 1}
T.RT_2 = {2, 2}
T.RT_3 = {2, 3}
T.RT_4 = {1, 2}
T.RT_5 = {3, 4}
T.RT_6 = {3, 3}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasure", {
  [100101] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_22.T_Activity_SoloTreasure_22",
    Name = "UI_ExtreactionTreasure_Name_1",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_22.T_Activity_SoloTreasure256_22",
    Shape = T.RT_1,
    TreasureId = 100101,
    TreasureRarity = 1,
    TreasureType = 1,
    TreasureValue = 50
  },
  [100104] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_12.T_Activity_SoloTreasure_12",
    Name = "UI_ExtreactionTreasure_Name_4",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_12.T_Activity_SoloTreasure256_12",
    Shape = T.RT_1,
    TreasureId = 100104,
    TreasureRarity = 1,
    TreasureType = 2,
    TreasureValue = 80
  },
  [100105] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_14.T_Activity_SoloTreasure_14",
    Name = "UI_ExtreactionTreasure_Name_5",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_14.T_Activity_SoloTreasure256_14",
    Shape = T.RT_2,
    TreasureId = 100105,
    TreasureRarity = 1,
    TreasureType = 3,
    TreasureValue = 320
  },
  [100106] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_07.T_Activity_SoloTreasure_07",
    Name = "UI_ExtreactionTreasure_Name_6",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_07.T_Activity_SoloTreasure256_07",
    Shape = {1, 3},
    TreasureId = 100106,
    TreasureRarity = 1,
    TreasureType = 3,
    TreasureValue = 180
  },
  [100107] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_10.T_Activity_SoloTreasure_10",
    Name = "UI_ExtreactionTreasure_Name_7",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_10.T_Activity_SoloTreasure256_10",
    Shape = T.RT_3,
    TreasureId = 100107,
    TreasureRarity = 1,
    TreasureType = 3,
    TreasureValue = 360
  },
  [100108] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_03.T_Activity_SoloTreasure_03",
    Name = "UI_ExtreactionTreasure_Name_8",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_03.T_Activity_SoloTreasure256_03",
    Shape = T.RT_1,
    TreasureId = 100108,
    TreasureRarity = 2,
    TreasureType = 1,
    TreasureValue = 250
  },
  [100111] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_18.T_Activity_SoloTreasure_18",
    Name = "UI_ExtreactionTreasure_Name_11",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_18.T_Activity_SoloTreasure256_18",
    Shape = T.RT_1,
    TreasureId = 100111,
    TreasureRarity = 2,
    TreasureType = 2,
    TreasureValue = 500
  },
  [100112] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_20.T_Activity_SoloTreasure_20",
    Name = "UI_ExtreactionTreasure_Name_12",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_20.T_Activity_SoloTreasure256_20",
    Shape = T.RT_1,
    TreasureId = 100112,
    TreasureRarity = 2,
    TreasureType = 2,
    TreasureValue = 450
  },
  [100113] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_16.T_Activity_SoloTreasure_16",
    Name = "UI_ExtreactionTreasure_Name_13",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_16.T_Activity_SoloTreasure256_16",
    Shape = T.RT_2,
    TreasureId = 100113,
    TreasureRarity = 2,
    TreasureType = 3,
    TreasureValue = 1200
  },
  [100114] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_17.T_Activity_SoloTreasure_17",
    Name = "UI_ExtreactionTreasure_Name_14",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_17.T_Activity_SoloTreasure256_17",
    Shape = T.RT_4,
    TreasureId = 100114,
    TreasureRarity = 2,
    TreasureType = 3,
    TreasureValue = 600
  },
  [100115] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_05.T_Activity_SoloTreasure_05",
    Name = "UI_ExtreactionTreasure_Name_15",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_05.T_Activity_SoloTreasure256_05",
    Shape = T.RT_1,
    TreasureId = 100115,
    TreasureRarity = 3,
    TreasureType = 1,
    TreasureValue = 1000
  },
  [100118] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_04.T_Activity_SoloTreasure_04",
    Name = "UI_ExtreactionTreasure_Name_18",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_04.T_Activity_SoloTreasure256_04",
    Shape = T.RT_4,
    TreasureId = 100118,
    TreasureRarity = 3,
    TreasureType = 3,
    TreasureValue = 2000
  },
  [100119] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_08.T_Activity_SoloTreasure_08",
    Name = "UI_ExtreactionTreasure_Name_19",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_08.T_Activity_SoloTreasure256_08",
    Shape = T.RT_3,
    TreasureId = 100119,
    TreasureRarity = 3,
    TreasureType = 4,
    TreasureValue = 9000
  },
  [100120] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_21.T_Activity_SoloTreasure_21",
    Name = "UI_ExtreactionTreasure_Name_20",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_21.T_Activity_SoloTreasure256_21",
    Shape = T.RT_5,
    TreasureId = 100120,
    TreasureRarity = 3,
    TreasureType = 3,
    TreasureValue = 12000
  },
  [100121] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_19.T_Activity_SoloTreasure_19",
    Name = "UI_ExtreactionTreasure_Name_21",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_19.T_Activity_SoloTreasure256_19",
    Shape = T.RT_1,
    TreasureId = 100121,
    TreasureRarity = 3,
    TreasureType = 2,
    TreasureValue = 1500
  },
  [100122] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_06.T_Activity_SoloTreasure_06",
    Name = "UI_ExtreactionTreasure_Name_22",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_06.T_Activity_SoloTreasure256_06",
    Shape = T.RT_1,
    TreasureId = 100122,
    TreasureRarity = 3,
    TreasureType = 2,
    TreasureValue = 1600
  },
  [100123] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_15.T_Activity_SoloTreasure_15",
    Name = "UI_ExtreactionTreasure_Name_23",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_15.T_Activity_SoloTreasure256_15",
    Shape = T.RT_2,
    TreasureId = 100123,
    TreasureRarity = 4,
    TreasureType = 2,
    TreasureValue = 20000
  },
  [100124] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_11.T_Activity_SoloTreasure_11",
    Name = "UI_ExtreactionTreasure_Name_24",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_11.T_Activity_SoloTreasure256_11",
    Shape = T.RT_2,
    TreasureId = 100124,
    TreasureRarity = 4,
    TreasureType = 3,
    TreasureValue = 16000
  },
  [100125] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_01.T_Activity_SoloTreasure_01",
    Name = "UI_ExtreactionTreasure_Name_25",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_01.T_Activity_SoloTreasure256_01",
    Shape = T.RT_3,
    TreasureId = 100125,
    TreasureRarity = 4,
    TreasureType = 3,
    TreasureValue = 26000
  },
  [100126] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_02.T_Activity_SoloTreasure_02",
    Name = "UI_ExtreactionTreasure_Name_26",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_02.T_Activity_SoloTreasure256_02",
    Shape = T.RT_6,
    TreasureId = 100126,
    TreasureRarity = 5,
    TreasureType = 2,
    TreasureValue = 150000
  },
  [100127] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_23.T_Activity_SoloTreasure_23",
    Name = "UI_ExtreactionTreasure_Name_27",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_23.T_Activity_SoloTreasure256_23",
    Shape = T.RT_6,
    TreasureId = 100127,
    TreasureRarity = 5,
    TreasureType = 4,
    TreasureValue = 135000
  },
  [100128] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_09.T_Activity_SoloTreasure_09",
    Name = "UI_ExtreactionTreasure_Name_28",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_09.T_Activity_SoloTreasure256_09",
    Shape = T.RT_5,
    TreasureId = 100128,
    TreasureRarity = 5,
    TreasureType = 4,
    TreasureValue = 240000
  },
  [100129] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_13.T_Activity_SoloTreasure_13",
    Name = "UI_ExtreactionTreasure_Name_29",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_13.T_Activity_SoloTreasure256_13",
    Shape = T.RT_5,
    TreasureId = 100129,
    TreasureRarity = 5,
    TreasureType = 4,
    TreasureValue = 280000
  },
  [100130] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_27.T_Activity_SoloTreasure_27",
    Name = "UI_ExtreactionTreasure_Name_30",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_27.T_Activity_SoloTreasure256_27",
    Shape = T.RT_1,
    TreasureId = 100130,
    TreasureRarity = 6,
    TreasureType = 5,
    TreasureValue = 100
  },
  [100131] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_28.T_Activity_SoloTreasure_28",
    Name = "UI_ExtreactionTreasure_Name_31",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_28.T_Activity_SoloTreasure256_28",
    Shape = T.RT_1,
    TreasureId = 100131,
    TreasureRarity = 6,
    TreasureType = 5,
    TreasureValue = 100
  },
  [100132] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_29.T_Activity_SoloTreasure_29",
    Name = "UI_ExtreactionTreasure_Name_32",
    SettlementIcon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure256_29.T_Activity_SoloTreasure256_29",
    Shape = T.RT_1,
    TreasureId = 100132,
    TreasureRarity = 6,
    TreasureType = 5,
    TreasureValue = 100
  }
})
