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
    Shape = T.RT_1,
    TreasureId = 100101,
    TreasureRarity = 1,
    TreasureType = 1,
    TreasureValue = 50
  },
  [100102] = {
    Shape = T.RT_1,
    TreasureId = 100102,
    TreasureRarity = 1,
    TreasureType = 1,
    TreasureValue = 60
  },
  [100103] = {
    Shape = T.RT_1,
    TreasureId = 100103,
    TreasureRarity = 1,
    TreasureType = 1,
    TreasureValue = 70
  },
  [100104] = {
    Shape = T.RT_1,
    TreasureId = 100104,
    TreasureRarity = 1,
    TreasureType = 2,
    TreasureValue = 80
  },
  [100105] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_2×2.T_SoloTreasure_2×2",
    Shape = T.RT_2,
    TreasureId = 100105,
    TreasureRarity = 1,
    TreasureType = 3,
    TreasureValue = 320
  },
  [100106] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_1×3.T_SoloTreasure_1×3",
    Shape = {1, 3},
    TreasureId = 100106,
    TreasureRarity = 1,
    TreasureType = 3,
    TreasureValue = 180
  },
  [100107] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_3×2.T_SoloTreasure_3×2",
    Shape = T.RT_3,
    TreasureId = 100107,
    TreasureRarity = 1,
    TreasureType = 3,
    TreasureValue = 360
  },
  [100108] = {
    Shape = T.RT_1,
    TreasureId = 100108,
    TreasureRarity = 2,
    TreasureType = 1,
    TreasureValue = 500
  },
  [100109] = {
    Shape = T.RT_1,
    TreasureId = 100109,
    TreasureRarity = 2,
    TreasureType = 1,
    TreasureValue = 600
  },
  [100110] = {
    Shape = T.RT_1,
    TreasureId = 100110,
    TreasureRarity = 2,
    TreasureType = 1,
    TreasureValue = 700
  },
  [100111] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_1×1.T_SoloTreasure_1×1",
    Shape = T.RT_1,
    TreasureId = 100111,
    TreasureRarity = 2,
    TreasureType = 2,
    TreasureValue = 1000
  },
  [100112] = {
    Shape = T.RT_1,
    TreasureId = 100112,
    TreasureRarity = 2,
    TreasureType = 2,
    TreasureValue = 900
  },
  [100113] = {
    Shape = T.RT_2,
    TreasureId = 100113,
    TreasureRarity = 2,
    TreasureType = 3,
    TreasureValue = 2400
  },
  [100114] = {
    Shape = T.RT_4,
    TreasureId = 100114,
    TreasureRarity = 2,
    TreasureType = 3,
    TreasureValue = 1200
  },
  [100115] = {
    Shape = T.RT_1,
    TreasureId = 100115,
    TreasureRarity = 3,
    TreasureType = 1,
    TreasureValue = 2000
  },
  [100116] = {
    Shape = T.RT_1,
    TreasureId = 100116,
    TreasureRarity = 3,
    TreasureType = 1,
    TreasureValue = 2200
  },
  [100117] = {
    Shape = T.RT_1,
    TreasureId = 100117,
    TreasureRarity = 3,
    TreasureType = 1,
    TreasureValue = 2400
  },
  [100118] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_1×2.T_SoloTreasure_1×2",
    Shape = T.RT_4,
    TreasureId = 100118,
    TreasureRarity = 3,
    TreasureType = 3,
    TreasureValue = 4000
  },
  [100119] = {
    Shape = T.RT_3,
    TreasureId = 100119,
    TreasureRarity = 3,
    TreasureType = 4,
    TreasureValue = 18000
  },
  [100120] = {
    Shape = T.RT_5,
    TreasureId = 100120,
    TreasureRarity = 3,
    TreasureType = 3,
    TreasureValue = 24000
  },
  [100121] = {
    Shape = T.RT_1,
    TreasureId = 100121,
    TreasureRarity = 3,
    TreasureType = 2,
    TreasureValue = 3000
  },
  [100122] = {
    Shape = T.RT_1,
    TreasureId = 100122,
    TreasureRarity = 3,
    TreasureType = 2,
    TreasureValue = 3200
  },
  [100123] = {
    Shape = T.RT_2,
    TreasureId = 100123,
    TreasureRarity = 4,
    TreasureType = 2,
    TreasureValue = 60000
  },
  [100124] = {
    Shape = T.RT_2,
    TreasureId = 100124,
    TreasureRarity = 4,
    TreasureType = 3,
    TreasureValue = 48000
  },
  [100125] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_2×3.T_SoloTreasure_2×3",
    Shape = T.RT_3,
    TreasureId = 100125,
    TreasureRarity = 4,
    TreasureType = 3,
    TreasureValue = 78000
  },
  [100126] = {
    Shape = T.RT_6,
    TreasureId = 100126,
    TreasureRarity = 5,
    TreasureType = 2,
    TreasureValue = 450000
  },
  [100127] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_3×3.T_SoloTreasure_3×3",
    Shape = T.RT_6,
    TreasureId = 100127,
    TreasureRarity = 5,
    TreasureType = 4,
    TreasureValue = 405000
  },
  [100128] = {
    Icon = "/Game/UI/Texture/Dynamic/Image/SoloTreasure/T_SoloTreasure_3×4.T_SoloTreasure_3×4",
    Shape = T.RT_5,
    TreasureId = 100128,
    TreasureRarity = 5,
    TreasureType = 4,
    TreasureValue = 720000
  },
  [100129] = {
    Shape = T.RT_5,
    TreasureId = 100129,
    TreasureRarity = 5,
    TreasureType = 4,
    TreasureValue = 840000
  }
})
