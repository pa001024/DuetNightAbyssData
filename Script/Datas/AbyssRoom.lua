local T = {}
T.RT_1 = {201000}
T.RT_2 = {60055}
T.RT_3 = {
  2010101,
  2010191,
  2010107
}
T.RT_4 = {60901}
T.RT_5 = {70055}
T.RT_6 = {
  2010201,
  2010291,
  2010208
}
T.RT_7 = {70902}
T.RT_8 = {
  2010101,
  2010191,
  2010108
}
T.RT_9 = {80055}
T.RT_10 = {
  2010201,
  2010291,
  2010210
}
T.RT_11 = {80901}
T.RT_12 = {60073}
T.RT_13 = {
  2010101,
  2010191,
  2010111
}
T.RT_14 = {90055}
T.RT_15 = {
  2010201,
  2010294,
  2010209
}
T.RT_16 = {90901}
T.RT_17 = {
  2010101,
  2010194,
  2010103
}
T.RT_18 = {70901}
T.RT_19 = {90073}
T.RT_20 = {
  2010201,
  2010292,
  2010205
}
T.RT_21 = {80073}
T.RT_22 = {
  2010101,
  2010194,
  2010109
}
T.RT_23 = {70173}
T.RT_24 = {
  2010201,
  2010291,
  2010204
}
T.RT_25 = {
  2010101,
  2010191,
  2010104
}
T.RT_26 = {70173, 7002018}
T.RT_27 = {
  2010201,
  2010291,
  2010206
}
T.RT_28 = {90073, 9001019}
T.RT_29 = {60173}
T.RT_30 = {
  2010201,
  2010294,
  2010203
}
T.RT_31 = {
  2010201,
  2010291,
  2010203
}
T.RT_32 = {80201}
T.RT_33 = {80200}
T.RT_34 = {60201}
T.RT_35 = {60200}
T.RT_36 = {90201}
T.RT_37 = {90200}
T.RT_38 = {70201}
T.RT_39 = {70200}
T.RT_40 = {
  2010101,
  2010191,
  2010106
}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AbyssRoom", {
  [110111] = {
    ClearCondition = 55,
    RoomId = 110111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110112] = {
    ClearCondition = 70,
    RoomId = 110112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110113] = {
    ClearCondition = 85,
    RoomId = 110113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110114] = {
    ClearCondition = 100,
    RoomId = 110114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110115] = {
    ClearCondition = 50,
    RoomId = 110115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_3,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_4
  },
  [110121] = {
    ClearCondition = 55,
    RoomId = 110121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110122] = {
    ClearCondition = 70,
    RoomId = 110122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110123] = {
    ClearCondition = 85,
    RoomId = 110123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110124] = {
    ClearCondition = 100,
    RoomId = 110124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110125] = {
    ClearCondition = 50,
    RoomId = 110125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_6,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_7
  },
  [110211] = {
    ClearCondition = 60,
    RoomId = 110211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110212] = {
    ClearCondition = 75,
    RoomId = 110212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110213] = {
    ClearCondition = 90,
    RoomId = 110213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110214] = {
    ClearCondition = 110,
    RoomId = 110214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_2
  },
  [110215] = {
    ClearCondition = 50,
    RoomId = 110215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_8,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_4
  },
  [110221] = {
    ClearCondition = 60,
    RoomId = 110221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_9
  },
  [110222] = {
    ClearCondition = 75,
    RoomId = 110222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_9
  },
  [110223] = {
    ClearCondition = 90,
    RoomId = 110223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_9
  },
  [110224] = {
    ClearCondition = 110,
    RoomId = 110224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_9
  },
  [110225] = {
    ClearCondition = 50,
    RoomId = 110225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_10,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_11
  },
  [110311] = {
    ClearCondition = 70,
    RoomId = 110311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_12
  },
  [110312] = {
    ClearCondition = 85,
    RoomId = 110312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_12
  },
  [110313] = {
    ClearCondition = 100,
    RoomId = 110313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_12
  },
  [110314] = {
    ClearCondition = 120,
    RoomId = 110314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60073, 6001012}
  },
  [110315] = {
    ClearCondition = 50,
    RoomId = 110315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_13,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_11
  },
  [110321] = {
    ClearCondition = 70,
    RoomId = 110321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110322] = {
    ClearCondition = 85,
    RoomId = 110322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110323] = {
    ClearCondition = 100,
    RoomId = 110323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_5
  },
  [110324] = {
    ClearCondition = 120,
    RoomId = 110324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70055, 7001015}
  },
  [110325] = {
    ClearCondition = 50,
    RoomId = 110325,
    RoomType = "Boss",
    StaticCreatorId = {
      2010201,
      2010291,
      2010207
    },
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_7
  },
  [110411] = {
    ClearCondition = 80,
    RoomId = 110411,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_9
  },
  [110412] = {
    ClearCondition = 95,
    RoomId = 110412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_9
  },
  [110413] = {
    ClearCondition = 110,
    RoomId = 110413,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80055, 8003017}
  },
  [110414] = {
    ClearCondition = 130,
    RoomId = 110414,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80055, 8001016}
  },
  [110415] = {
    ClearCondition = 50,
    RoomId = 110415,
    RoomType = "Boss",
    StaticCreatorId = {
      2010101,
      2010191,
      2010110
    },
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_11
  },
  [110421] = {
    ClearCondition = 80,
    RoomId = 110421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [110422] = {
    ClearCondition = 95,
    RoomId = 110422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [110423] = {
    ClearCondition = 110,
    RoomId = 110423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90055, 9007011}
  },
  [110424] = {
    ClearCondition = 130,
    RoomId = 110424,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90055, 9001014}
  },
  [110425] = {
    ClearCondition = 50,
    RoomId = 110425,
    RoomType = "Boss",
    StaticCreatorId = T.RT_15,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 220,
    UnitSpawnId = T.RT_16
  },
  [110511] = {
    ClearCondition = 90,
    RoomId = 110511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = {70155}
  },
  [110512] = {
    ClearCondition = 105,
    RoomId = 110512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70155, 7002014}
  },
  [110513] = {
    ClearCondition = 120,
    RoomId = 110513,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70155, 7001011}
  },
  [110514] = {
    ClearCondition = 140,
    RoomId = 110514,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70155, 7003017}
  },
  [110515] = {
    ClearCondition = 50,
    RoomId = 110515,
    RoomType = "Boss",
    StaticCreatorId = T.RT_17,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_18
  },
  [110521] = {
    ClearCondition = 90,
    RoomId = 110521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_19
  },
  [110522] = {
    ClearCondition = 105,
    RoomId = 110522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9007018}
  },
  [110523] = {
    ClearCondition = 120,
    RoomId = 110523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9002016}
  },
  [110524] = {
    ClearCondition = 140,
    RoomId = 110524,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9001020}
  },
  [110525] = {
    ClearCondition = 50,
    RoomId = 110525,
    RoomType = "Boss",
    StaticCreatorId = T.RT_20,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_4
  },
  [110611] = {
    ClearCondition = 100,
    RoomId = 110611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
  },
  [110612] = {
    ClearCondition = 115,
    RoomId = 110612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8002020}
  },
  [110613] = {
    ClearCondition = 130,
    RoomId = 110613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8001017}
  },
  [110614] = {
    ClearCondition = 150,
    RoomId = 110614,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80073,
      8002020,
      8001017
    }
  },
  [110615] = {
    ClearCondition = 50,
    RoomId = 110615,
    RoomType = "Boss",
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 220,
    UnitSpawnId = T.RT_11
  },
  [110621] = {
    ClearCondition = 100,
    RoomId = 110621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_23
  },
  [110622] = {
    ClearCondition = 115,
    RoomId = 110622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70173, 7002012}
  },
  [110623] = {
    ClearCondition = 130,
    RoomId = 110623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70173, 7001011}
  },
  [110624] = {
    ClearCondition = 150,
    RoomId = 110624,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70173,
      7002012,
      7001011
    }
  },
  [110625] = {
    ClearCondition = 50,
    RoomId = 110625,
    RoomType = "Boss",
    StaticCreatorId = T.RT_24,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_7
  },
  [110711] = {
    ClearCondition = 100,
    RoomId = 110711,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = {60155}
  },
  [110712] = {
    ClearCondition = 120,
    RoomId = 110712,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60155, 6001016}
  },
  [110713] = {
    ClearCondition = 140,
    RoomId = 110713,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60155, 6002015}
  },
  [110714] = {
    ClearCondition = 160,
    RoomId = 110714,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60155,
      6001016,
      6002015
    }
  },
  [110715] = {
    ClearCondition = 50,
    RoomId = 110715,
    RoomType = "Boss",
    StaticCreatorId = T.RT_25,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_4
  },
  [110721] = {
    ClearCondition = 100,
    RoomId = 110721,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_23
  },
  [110722] = {
    ClearCondition = 120,
    RoomId = 110722,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_26
  },
  [110723] = {
    ClearCondition = 140,
    RoomId = 110723,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70173, 7003011}
  },
  [110724] = {
    ClearCondition = 160,
    RoomId = 110724,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70173,
      7002018,
      7003011
    }
  },
  [110725] = {
    ClearCondition = 50,
    RoomId = 110725,
    RoomType = "Boss",
    StaticCreatorId = T.RT_27,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 255,
    UnitSpawnId = T.RT_7
  },
  [120111] = {
    ClearCondition = 100,
    RoomId = 120111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_19
  },
  [120112] = {
    ClearCondition = 120,
    RoomId = 120112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_28
  },
  [120113] = {
    ClearCondition = 140,
    RoomId = 120113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9002023}
  },
  [120114] = {
    ClearCondition = 160,
    RoomId = 120114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90073,
      9001019,
      9002023
    }
  },
  [120115] = {
    ClearCondition = 50,
    RoomId = 120115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_6,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_16
  },
  [120121] = {
    ClearCondition = 100,
    RoomId = 120121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_29
  },
  [120122] = {
    ClearCondition = 120,
    RoomId = 120122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60173, 6001014}
  },
  [120123] = {
    ClearCondition = 140,
    RoomId = 120123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60173, 6002015}
  },
  [120124] = {
    ClearCondition = 160,
    RoomId = 120124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60173,
      6001014,
      6002015
    }
  },
  [120125] = {
    ClearCondition = 50,
    RoomId = 120125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_3,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_4
  },
  [120211] = {
    ClearCondition = 100,
    RoomId = 120211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_23
  },
  [120212] = {
    ClearCondition = 120,
    RoomId = 120212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_26
  },
  [120213] = {
    ClearCondition = 140,
    RoomId = 120213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70173, 7001015}
  },
  [120214] = {
    ClearCondition = 160,
    RoomId = 120214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70173,
      7002018,
      7001015
    }
  },
  [120215] = {
    ClearCondition = 50,
    RoomId = 120215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_30,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_18
  },
  [120221] = {
    ClearCondition = 100,
    RoomId = 120221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_19
  },
  [120222] = {
    ClearCondition = 120,
    RoomId = 120222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_28
  },
  [120223] = {
    ClearCondition = 140,
    RoomId = 120223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9002017}
  },
  [120224] = {
    ClearCondition = 160,
    RoomId = 120224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90073,
      9001019,
      9002017
    }
  },
  [120225] = {
    ClearCondition = 50,
    RoomId = 120225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 220,
    UnitSpawnId = T.RT_16
  },
  [120311] = {
    ClearCondition = 100,
    RoomId = 120311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_29
  },
  [120312] = {
    ClearCondition = 120,
    RoomId = 120312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60173, 6001012}
  },
  [120313] = {
    ClearCondition = 140,
    RoomId = 120313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60173, 6002011}
  },
  [120314] = {
    ClearCondition = 160,
    RoomId = 120314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60173,
      6001012,
      6002011
    }
  },
  [120315] = {
    ClearCondition = 50,
    RoomId = 120315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_20,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_4
  },
  [120321] = {
    ClearCondition = 100,
    RoomId = 120321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
  },
  [120322] = {
    ClearCondition = 120,
    RoomId = 120322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8002024}
  },
  [120323] = {
    ClearCondition = 140,
    RoomId = 120323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8001022}
  },
  [120324] = {
    ClearCondition = 160,
    RoomId = 120324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80073,
      8002024,
      8001022
    }
  },
  [120325] = {
    ClearCondition = 50,
    RoomId = 120325,
    RoomType = "Boss",
    StaticCreatorId = T.RT_25,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_11
  },
  [210111] = {
    ClearCondition = 100,
    RoomId = 210111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210112] = {
    ClearCondition = 120,
    RoomId = 210112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210113] = {
    ClearCondition = 140,
    RoomId = 210113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210114] = {
    ClearCondition = 160,
    RoomId = 210114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210115] = {
    ClearCondition = 50,
    RoomId = 210115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_31,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 135,
    UnitSpawnId = T.RT_14
  },
  [210121] = {
    ClearCondition = 100,
    RoomId = 210121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210122] = {
    ClearCondition = 120,
    RoomId = 210122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210123] = {
    ClearCondition = 140,
    RoomId = 210123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210124] = {
    ClearCondition = 160,
    RoomId = 210124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210125] = {
    ClearCondition = 50,
    RoomId = 210125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_31,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 135,
    UnitSpawnId = T.RT_14
  },
  [210211] = {
    ClearCondition = 100,
    RoomId = 210211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210212] = {
    ClearCondition = 120,
    RoomId = 210212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210213] = {
    ClearCondition = 140,
    RoomId = 210213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210214] = {
    ClearCondition = 160,
    RoomId = 210214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210215] = {
    ClearCondition = 50,
    RoomId = 210215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_31,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 135,
    UnitSpawnId = T.RT_14
  },
  [210221] = {
    ClearCondition = 100,
    RoomId = 210221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210222] = {
    ClearCondition = 120,
    RoomId = 210222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210223] = {
    ClearCondition = 140,
    RoomId = 210223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210224] = {
    ClearCondition = 160,
    RoomId = 210224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_14
  },
  [210225] = {
    ClearCondition = 50,
    RoomId = 210225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_31,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 135,
    UnitSpawnId = T.RT_14
  },
  [211111] = {
    ClearCondition = 100,
    RoomId = 211111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_32
  },
  [211112] = {
    ClearCondition = 120,
    RoomId = 211112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8002012}
  },
  [211113] = {
    ClearCondition = 140,
    RoomId = 211113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8001018}
  },
  [211114] = {
    ClearCondition = 160,
    RoomId = 211114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002012,
      8001018
    }
  },
  [211115] = {
    ClearCondition = 50,
    RoomId = 211115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_10,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [211121] = {
    ClearCondition = 100,
    RoomId = 211121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [211122] = {
    ClearCondition = 120,
    RoomId = 211122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6001016}
  },
  [211123] = {
    ClearCondition = 140,
    RoomId = 211123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6002017}
  },
  [211124] = {
    ClearCondition = 160,
    RoomId = 211124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001016,
      6002017
    }
  },
  [211125] = {
    ClearCondition = 50,
    RoomId = 211125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_8,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_35
  },
  [211211] = {
    ClearCondition = 100,
    RoomId = 211211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_36
  },
  [211212] = {
    ClearCondition = 120,
    RoomId = 211212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9001016}
  },
  [211213] = {
    ClearCondition = 140,
    RoomId = 211213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9002011}
  },
  [211214] = {
    ClearCondition = 160,
    RoomId = 211214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001016,
      9002011
    }
  },
  [211215] = {
    ClearCondition = 50,
    RoomId = 211215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_15,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_37
  },
  [211221] = {
    ClearCondition = 100,
    RoomId = 211221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_38
  },
  [211222] = {
    ClearCondition = 120,
    RoomId = 211222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002018}
  },
  [211223] = {
    ClearCondition = 140,
    RoomId = 211223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7001011}
  },
  [211224] = {
    ClearCondition = 160,
    RoomId = 211224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002018,
      7001011
    }
  },
  [211225] = {
    ClearCondition = 50,
    RoomId = 211225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_17,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_39
  },
  [211311] = {
    ClearCondition = 100,
    RoomId = 211311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_38
  },
  [211312] = {
    ClearCondition = 120,
    RoomId = 211312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002014}
  },
  [211313] = {
    ClearCondition = 140,
    RoomId = 211313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7003015}
  },
  [211314] = {
    ClearCondition = 160,
    RoomId = 211314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002014,
      7003015
    }
  },
  [211315] = {
    ClearCondition = 50,
    RoomId = 211315,
    RoomType = "Boss",
    StaticCreatorId = {
      2010201,
      2010293,
      2010212
    },
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_39
  },
  [211321] = {
    ClearCondition = 100,
    RoomId = 211321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_38
  },
  [211322] = {
    ClearCondition = 120,
    RoomId = 211322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002012}
  },
  [211323] = {
    ClearCondition = 140,
    RoomId = 211323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7003016}
  },
  [211324] = {
    ClearCondition = 160,
    RoomId = 211324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002012,
      7003016
    }
  },
  [211325] = {
    ClearCondition = 50,
    RoomId = 211325,
    RoomType = "Boss",
    StaticCreatorId = T.RT_40,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_39
  },
  [211411] = {
    ClearCondition = 100,
    RoomId = 211411,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_32
  },
  [211412] = {
    ClearCondition = 120,
    RoomId = 211412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8002023}
  },
  [211413] = {
    ClearCondition = 140,
    RoomId = 211413,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8003022}
  },
  [211414] = {
    ClearCondition = 160,
    RoomId = 211414,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002023,
      8003022
    }
  },
  [211415] = {
    ClearCondition = 50,
    RoomId = 211415,
    RoomType = "Boss",
    StaticCreatorId = {
      2010201,
      2010291,
      2010211
    },
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [211421] = {
    ClearCondition = 100,
    RoomId = 211421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [211422] = {
    ClearCondition = 120,
    RoomId = 211422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6001014}
  },
  [211423] = {
    ClearCondition = 140,
    RoomId = 211423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6002018}
  },
  [211424] = {
    ClearCondition = 160,
    RoomId = 211424,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001014,
      6002018
    }
  },
  [211425] = {
    ClearCondition = 50,
    RoomId = 211425,
    RoomType = "Boss",
    StaticCreatorId = T.RT_8,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_35
  },
  [211511] = {
    ClearCondition = 100,
    RoomId = 211511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_36
  },
  [211512] = {
    ClearCondition = 120,
    RoomId = 211512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9001024}
  },
  [211513] = {
    ClearCondition = 140,
    RoomId = 211513,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9007019}
  },
  [211514] = {
    ClearCondition = 160,
    RoomId = 211514,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001024,
      9007019
    }
  },
  [211515] = {
    ClearCondition = 50,
    RoomId = 211515,
    RoomType = "Boss",
    StaticCreatorId = T.RT_15,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_37
  },
  [211521] = {
    ClearCondition = 100,
    RoomId = 211521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_38
  },
  [211522] = {
    ClearCondition = 120,
    RoomId = 211522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002011}
  },
  [211523] = {
    ClearCondition = 140,
    RoomId = 211523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7001015}
  },
  [211524] = {
    ClearCondition = 160,
    RoomId = 211524,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002011,
      7001015
    }
  },
  [211525] = {
    ClearCondition = 50,
    RoomId = 211525,
    RoomType = "Boss",
    StaticCreatorId = T.RT_17,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_39
  },
  [211611] = {
    ClearCondition = 100,
    RoomId = 211611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [211612] = {
    ClearCondition = 120,
    RoomId = 211612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6001012}
  },
  [211613] = {
    ClearCondition = 140,
    RoomId = 211613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6002015}
  },
  [211614] = {
    ClearCondition = 160,
    RoomId = 211614,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001012,
      6002015
    }
  },
  [211615] = {
    ClearCondition = 50,
    RoomId = 211615,
    RoomType = "Boss",
    StaticCreatorId = T.RT_24,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_35
  },
  [211621] = {
    ClearCondition = 100,
    RoomId = 211621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_38
  },
  [211622] = {
    ClearCondition = 120,
    RoomId = 211622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002016}
  },
  [211623] = {
    ClearCondition = 140,
    RoomId = 211623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7003017}
  },
  [211624] = {
    ClearCondition = 160,
    RoomId = 211624,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002016,
      7003017
    }
  },
  [211625] = {
    ClearCondition = 50,
    RoomId = 211625,
    RoomType = "Boss",
    StaticCreatorId = T.RT_40,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_39
  },
  [220111] = {
    ClearCondition = 100,
    RoomId = 220111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
  },
  [220112] = {
    ClearCondition = 120,
    RoomId = 220112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8002018}
  },
  [220113] = {
    ClearCondition = 140,
    RoomId = 220113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8003022}
  },
  [220114] = {
    ClearCondition = 160,
    RoomId = 220114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80073,
      8002018,
      8003022
    }
  },
  [220115] = {
    ClearCondition = 50,
    RoomId = 220115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_10,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_11
  },
  [220121] = {
    ClearCondition = 100,
    RoomId = 220121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
  },
  [220122] = {
    ClearCondition = 120,
    RoomId = 220122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8002019}
  },
  [220123] = {
    ClearCondition = 140,
    RoomId = 220123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80073, 8001023}
  },
  [220124] = {
    ClearCondition = 160,
    RoomId = 220124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80073,
      8002019,
      8001023
    }
  },
  [220125] = {
    ClearCondition = 50,
    RoomId = 220125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_13,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_11
  },
  [220211] = {
    ClearCondition = 100,
    RoomId = 220211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = {70073}
  },
  [220212] = {
    ClearCondition = 120,
    RoomId = 220212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70073, 7002014}
  },
  [220213] = {
    ClearCondition = 140,
    RoomId = 220213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70073, 7001016}
  },
  [220214] = {
    ClearCondition = 160,
    RoomId = 220214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70073,
      7002014,
      7001016
    }
  },
  [220215] = {
    ClearCondition = 50,
    RoomId = 220215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_30,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_18
  },
  [220221] = {
    ClearCondition = 100,
    RoomId = 220221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_19
  },
  [220222] = {
    ClearCondition = 120,
    RoomId = 220222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9001017}
  },
  [220223] = {
    ClearCondition = 140,
    RoomId = 220223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9002024}
  },
  [220224] = {
    ClearCondition = 160,
    RoomId = 220224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90073,
      9001017,
      9002024
    }
  },
  [220225] = {
    ClearCondition = 50,
    RoomId = 220225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_25,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_16
  },
  [220311] = {
    ClearCondition = 100,
    RoomId = 220311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_23
  },
  [220312] = {
    ClearCondition = 120,
    RoomId = 220312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70173, 6001012}
  },
  [220313] = {
    ClearCondition = 140,
    RoomId = 220313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70173, 7003015}
  },
  [220314] = {
    ClearCondition = 160,
    RoomId = 220314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70173,
      6001012,
      7003015
    }
  },
  [220315] = {
    ClearCondition = 50,
    RoomId = 220315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_27,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 255,
    UnitSpawnId = T.RT_18
  },
  [220321] = {
    ClearCondition = 100,
    RoomId = 220321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_19
  },
  [220322] = {
    ClearCondition = 120,
    RoomId = 220322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 6001014}
  },
  [220323] = {
    ClearCondition = 140,
    RoomId = 220323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90073, 9007011}
  },
  [220324] = {
    ClearCondition = 160,
    RoomId = 220324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90073,
      6001014,
      9007011
    }
  },
  [220325] = {
    ClearCondition = 50,
    RoomId = 220325,
    RoomType = "Boss",
    StaticCreatorId = {
      2010101,
      2010192,
      2010105
    },
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_16
  }
})
