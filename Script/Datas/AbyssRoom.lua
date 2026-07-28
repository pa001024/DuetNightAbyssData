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
  2010101,
  2010191,
  2010108
}
T.RT_7 = {70902}
T.RT_8 = {80055}
T.RT_9 = {
  2010101,
  2010191,
  2010110
}
T.RT_10 = {80901}
T.RT_11 = {60073}
T.RT_12 = {
  2010101,
  2010191,
  2010111
}
T.RT_13 = {90055}
T.RT_14 = {
  2010101,
  2010194,
  2010109
}
T.RT_15 = {90901}
T.RT_16 = {
  2010101,
  2010194,
  2010103
}
T.RT_17 = {70901}
T.RT_18 = {90073}
T.RT_19 = {
  2010101,
  2010192,
  2010105
}
T.RT_20 = {80073}
T.RT_21 = {70173}
T.RT_22 = {
  2010101,
  2010191,
  2010104
}
T.RT_23 = {70173, 7002018}
T.RT_24 = {
  2010101,
  2010191,
  2010106
}
T.RT_25 = {90073, 9001019}
T.RT_26 = {60173}
T.RT_27 = {80201}
T.RT_28 = {80201, 8002012}
T.RT_29 = {80201, 8001018}
T.RT_30 = {80200}
T.RT_31 = {60201}
T.RT_32 = {60201, 6001016}
T.RT_33 = {60200}
T.RT_34 = {90201}
T.RT_35 = {90201, 9001016}
T.RT_36 = {90200}
T.RT_37 = {70201}
T.RT_38 = {70201, 7001011}
T.RT_39 = {70200}
T.RT_40 = {70201, 7002014}
T.RT_41 = {70201, 7003015}
T.RT_42 = {70201, 7002012}
T.RT_43 = {70201, 7003016}
T.RT_44 = {80201, 8002023}
T.RT_45 = {60201, 6001014}
T.RT_46 = {60201, 6002018}
T.RT_47 = {90201, 9001024}
T.RT_48 = {70201, 7002011}
T.RT_49 = {70201, 7001015}
T.RT_50 = {60201, 6001012}
T.RT_51 = {60201, 6002015}
T.RT_52 = {70201, 7002016}
T.RT_53 = {70201, 7003017}
T.RT_54 = {80201, 8002018}
T.RT_55 = {80201, 8001015}
T.RT_56 = {2010110}
T.RT_57 = {2010107}
T.RT_58 = {70201, 7002023}
T.RT_59 = {2010103}
T.RT_60 = {90201, 9002024}
T.RT_61 = {2010115}
T.RT_62 = {70201, 7002019}
T.RT_63 = {2010114}
T.RT_64 = {80201, 8001019}
T.RT_65 = {2010113}
T.RT_66 = {2010108}
T.RT_67 = {60201, 6012021}
T.RT_68 = {70201, 7003022}
T.RT_69 = {2010116}
T.RT_70 = {80201, 8002017}
T.RT_71 = {70201, 7002020}
T.RT_72 = {60203}
T.RT_73 = {2010118}
T.RT_74 = {60202}
T.RT_75 = {2010117}
T.RT_76 = {2010111}
T.RT_77 = {80201, 8001011}
T.RT_78 = {60203, 10005014}
T.RT_79 = {60203, 6016022}
T.RT_80 = {80201, 8002021}
T.RT_81 = {60203, 6016019}
T.RT_82 = {90201, 9001014}
T.RT_83 = {90201, 9002017}
T.RT_84 = {
  90201,
  9001014,
  9002017
}
T.RT_85 = {90201, 9001020}
T.RT_86 = {60203, 6016018}
T.RT_87 = {70201, 7003024}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
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
    StaticCreatorId = T.RT_6,
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
    UnitSpawnId = T.RT_8
  },
  [110222] = {
    ClearCondition = 75,
    RoomId = 110222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_8
  },
  [110223] = {
    ClearCondition = 90,
    RoomId = 110223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_8
  },
  [110224] = {
    ClearCondition = 110,
    RoomId = 110224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_8
  },
  [110225] = {
    ClearCondition = 50,
    RoomId = 110225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_9,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_10
  },
  [110311] = {
    ClearCondition = 70,
    RoomId = 110311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_11
  },
  [110312] = {
    ClearCondition = 85,
    RoomId = 110312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_11
  },
  [110313] = {
    ClearCondition = 100,
    RoomId = 110313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_11
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
    StaticCreatorId = T.RT_12,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_10
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
    StaticCreatorId = T.RT_3,
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
    UnitSpawnId = T.RT_8
  },
  [110412] = {
    ClearCondition = 95,
    RoomId = 110412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_8
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
    StaticCreatorId = T.RT_9,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_10
  },
  [110421] = {
    ClearCondition = 80,
    RoomId = 110421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_13
  },
  [110422] = {
    ClearCondition = 95,
    RoomId = 110422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_13
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
    StaticCreatorId = T.RT_14,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_15
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
    StaticCreatorId = T.RT_16,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_17
  },
  [110521] = {
    ClearCondition = 90,
    RoomId = 110521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_18
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
    StaticCreatorId = T.RT_19,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_4
  },
  [110611] = {
    ClearCondition = 100,
    RoomId = 110611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_20
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
    StaticCreatorId = T.RT_14,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_10
  },
  [110621] = {
    ClearCondition = 100,
    RoomId = 110621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
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
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
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
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_4
  },
  [110721] = {
    ClearCondition = 100,
    RoomId = 110721,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
  },
  [110722] = {
    ClearCondition = 120,
    RoomId = 110722,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_23
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
    StaticCreatorId = T.RT_24,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_7
  },
  [120111] = {
    ClearCondition = 100,
    RoomId = 120111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_18
  },
  [120112] = {
    ClearCondition = 120,
    RoomId = 120112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_25
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
    UnitSpawnId = T.RT_15
  },
  [120121] = {
    ClearCondition = 100,
    RoomId = 120121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_26
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
    UnitSpawnId = T.RT_21
  },
  [120212] = {
    ClearCondition = 120,
    RoomId = 120212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_23
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
    StaticCreatorId = T.RT_16,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_17
  },
  [120221] = {
    ClearCondition = 100,
    RoomId = 120221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_18
  },
  [120222] = {
    ClearCondition = 120,
    RoomId = 120222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_25
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
    StaticCreatorId = T.RT_14,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 220,
    UnitSpawnId = T.RT_15
  },
  [120311] = {
    ClearCondition = 100,
    RoomId = 120311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_26
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
    StaticCreatorId = T.RT_19,
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
    UnitSpawnId = T.RT_20
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
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_10
  },
  [211111] = {
    ClearCondition = 100,
    RoomId = 211111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [211112] = {
    ClearCondition = 120,
    RoomId = 211112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_28
  },
  [211113] = {
    ClearCondition = 140,
    RoomId = 211113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_29
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
    StaticCreatorId = T.RT_9,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [211121] = {
    ClearCondition = 100,
    RoomId = 211121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [211122] = {
    ClearCondition = 120,
    RoomId = 211122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_32
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
    StaticCreatorId = T.RT_6,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [211211] = {
    ClearCondition = 100,
    RoomId = 211211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [211212] = {
    ClearCondition = 120,
    RoomId = 211212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_35
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
    StaticCreatorId = T.RT_14,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [211221] = {
    ClearCondition = 100,
    RoomId = 211221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
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
    UnitSpawnId = T.RT_38
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
    StaticCreatorId = T.RT_16,
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
    UnitSpawnId = T.RT_37
  },
  [211312] = {
    ClearCondition = 120,
    RoomId = 211312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_40
  },
  [211313] = {
    ClearCondition = 140,
    RoomId = 211313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_41
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
      2010101,
      2010193,
      2010112
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
    UnitSpawnId = T.RT_37
  },
  [211322] = {
    ClearCondition = 120,
    RoomId = 211322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_42
  },
  [211323] = {
    ClearCondition = 140,
    RoomId = 211323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_43
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
    StaticCreatorId = T.RT_24,
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
    UnitSpawnId = T.RT_27
  },
  [211412] = {
    ClearCondition = 120,
    RoomId = 211412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_44
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
    StaticCreatorId = T.RT_12,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [211421] = {
    ClearCondition = 100,
    RoomId = 211421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [211422] = {
    ClearCondition = 120,
    RoomId = 211422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_45
  },
  [211423] = {
    ClearCondition = 140,
    RoomId = 211423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_46
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
    StaticCreatorId = T.RT_6,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [211511] = {
    ClearCondition = 100,
    RoomId = 211511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [211512] = {
    ClearCondition = 120,
    RoomId = 211512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_47
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
    StaticCreatorId = T.RT_14,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [211521] = {
    ClearCondition = 100,
    RoomId = 211521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [211522] = {
    ClearCondition = 120,
    RoomId = 211522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_48
  },
  [211523] = {
    ClearCondition = 140,
    RoomId = 211523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_49
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
    StaticCreatorId = T.RT_16,
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
    UnitSpawnId = T.RT_31
  },
  [211612] = {
    ClearCondition = 120,
    RoomId = 211612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_50
  },
  [211613] = {
    ClearCondition = 140,
    RoomId = 211613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_51
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
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_33
  },
  [211621] = {
    ClearCondition = 100,
    RoomId = 211621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [211622] = {
    ClearCondition = 120,
    RoomId = 211622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_52
  },
  [211623] = {
    ClearCondition = 140,
    RoomId = 211623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_53
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
    StaticCreatorId = T.RT_24,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_39
  },
  [212111] = {
    ClearCondition = 100,
    RoomId = 212111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [212112] = {
    ClearCondition = 120,
    RoomId = 212112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_54
  },
  [212113] = {
    ClearCondition = 140,
    RoomId = 212113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_55
  },
  [212114] = {
    ClearCondition = 160,
    RoomId = 212114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002018,
      8001015
    }
  },
  [212115] = {
    ClearCondition = 50,
    RoomId = 212115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [212121] = {
    ClearCondition = 100,
    RoomId = 212121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [212122] = {
    ClearCondition = 120,
    RoomId = 212122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_32
  },
  [212123] = {
    ClearCondition = 140,
    RoomId = 212123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_46
  },
  [212124] = {
    ClearCondition = 160,
    RoomId = 212124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001016,
      6002018
    }
  },
  [212125] = {
    ClearCondition = 50,
    RoomId = 212125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_57,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [212211] = {
    ClearCondition = 100,
    RoomId = 212211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [212212] = {
    ClearCondition = 120,
    RoomId = 212212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_58
  },
  [212213] = {
    ClearCondition = 140,
    RoomId = 212213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_38
  },
  [212214] = {
    ClearCondition = 160,
    RoomId = 212214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002023,
      7001011
    }
  },
  [212215] = {
    ClearCondition = 50,
    RoomId = 212215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_59,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [212221] = {
    ClearCondition = 100,
    RoomId = 212221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [212222] = {
    ClearCondition = 120,
    RoomId = 212222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9001021}
  },
  [212223] = {
    ClearCondition = 140,
    RoomId = 212223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_60
  },
  [212224] = {
    ClearCondition = 160,
    RoomId = 212224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001021,
      9002024
    }
  },
  [212225] = {
    ClearCondition = 50,
    RoomId = 212225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_61,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [212311] = {
    ClearCondition = 100,
    RoomId = 212311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [212312] = {
    ClearCondition = 120,
    RoomId = 212312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_62
  },
  [212313] = {
    ClearCondition = 140,
    RoomId = 212313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_53
  },
  [212314] = {
    ClearCondition = 160,
    RoomId = 212314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002019,
      7003017
    }
  },
  [212315] = {
    ClearCondition = 50,
    RoomId = 212315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_63,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [212321] = {
    ClearCondition = 100,
    RoomId = 212321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [212322] = {
    ClearCondition = 120,
    RoomId = 212322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_28
  },
  [212323] = {
    ClearCondition = 140,
    RoomId = 212323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_64
  },
  [212324] = {
    ClearCondition = 160,
    RoomId = 212324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002012,
      8001019
    }
  },
  [212325] = {
    ClearCondition = 50,
    RoomId = 212325,
    RoomType = "Boss",
    StaticCreatorId = T.RT_65,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [212411] = {
    ClearCondition = 100,
    RoomId = 212411,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [212412] = {
    ClearCondition = 120,
    RoomId = 212412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_50
  },
  [212413] = {
    ClearCondition = 140,
    RoomId = 212413,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6012023}
  },
  [212414] = {
    ClearCondition = 160,
    RoomId = 212414,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001012,
      6012023
    }
  },
  [212415] = {
    ClearCondition = 50,
    RoomId = 212415,
    RoomType = "Boss",
    StaticCreatorId = T.RT_66,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [212421] = {
    ClearCondition = 100,
    RoomId = 212421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [212422] = {
    ClearCondition = 120,
    RoomId = 212422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_45
  },
  [212423] = {
    ClearCondition = 140,
    RoomId = 212423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_67
  },
  [212424] = {
    ClearCondition = 160,
    RoomId = 212424,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001014,
      6012021
    }
  },
  [212425] = {
    ClearCondition = 50,
    RoomId = 212425,
    RoomType = "Boss",
    StaticCreatorId = T.RT_57,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [212511] = {
    ClearCondition = 100,
    RoomId = 212511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [212512] = {
    ClearCondition = 120,
    RoomId = 212512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_47
  },
  [212513] = {
    ClearCondition = 140,
    RoomId = 212513,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9007018}
  },
  [212514] = {
    ClearCondition = 160,
    RoomId = 212514,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001024,
      9007018
    }
  },
  [212515] = {
    ClearCondition = 50,
    RoomId = 212515,
    RoomType = "Boss",
    StaticCreatorId = T.RT_61,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [212521] = {
    ClearCondition = 100,
    RoomId = 212521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [212522] = {
    ClearCondition = 120,
    RoomId = 212522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_62
  },
  [212523] = {
    ClearCondition = 140,
    RoomId = 212523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7001018}
  },
  [212524] = {
    ClearCondition = 160,
    RoomId = 212524,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002019,
      7001018
    }
  },
  [212525] = {
    ClearCondition = 50,
    RoomId = 212525,
    RoomType = "Boss",
    StaticCreatorId = T.RT_59,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [212611] = {
    ClearCondition = 100,
    RoomId = 212611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [212612] = {
    ClearCondition = 120,
    RoomId = 212612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_40
  },
  [212613] = {
    ClearCondition = 140,
    RoomId = 212613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_68
  },
  [212614] = {
    ClearCondition = 160,
    RoomId = 212614,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002014,
      7003022
    }
  },
  [212615] = {
    ClearCondition = 50,
    RoomId = 212615,
    RoomType = "Boss",
    StaticCreatorId = T.RT_63,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [212621] = {
    ClearCondition = 100,
    RoomId = 212621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [212622] = {
    ClearCondition = 120,
    RoomId = 212622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_52
  },
  [212623] = {
    ClearCondition = 140,
    RoomId = 212623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_41
  },
  [212624] = {
    ClearCondition = 160,
    RoomId = 212624,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002016,
      7003015
    }
  },
  [212625] = {
    ClearCondition = 50,
    RoomId = 212625,
    RoomType = "Boss",
    StaticCreatorId = T.RT_69,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [213111] = {
    ClearCondition = 100,
    RoomId = 213111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [213112] = {
    ClearCondition = 120,
    RoomId = 213112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_70
  },
  [213113] = {
    ClearCondition = 140,
    RoomId = 213113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_29
  },
  [213114] = {
    ClearCondition = 160,
    RoomId = 213114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002017,
      8001018
    }
  },
  [213115] = {
    ClearCondition = 50,
    RoomId = 213115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [213121] = {
    ClearCondition = 100,
    RoomId = 213121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [213122] = {
    ClearCondition = 120,
    RoomId = 213122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_45
  },
  [213123] = {
    ClearCondition = 140,
    RoomId = 213123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6012019}
  },
  [213124] = {
    ClearCondition = 160,
    RoomId = 213124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001014,
      6012019
    }
  },
  [213125] = {
    ClearCondition = 50,
    RoomId = 213125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_66,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [213211] = {
    ClearCondition = 100,
    RoomId = 213211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [213212] = {
    ClearCondition = 120,
    RoomId = 213212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_71
  },
  [213213] = {
    ClearCondition = 140,
    RoomId = 213213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_68
  },
  [213214] = {
    ClearCondition = 160,
    RoomId = 213214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002020,
      7003022
    }
  },
  [213215] = {
    ClearCondition = 50,
    RoomId = 213215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_59,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [213221] = {
    ClearCondition = 100,
    RoomId = 213221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [213222] = {
    ClearCondition = 120,
    RoomId = 213222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6017021}
  },
  [213223] = {
    ClearCondition = 140,
    RoomId = 213223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6016023}
  },
  [213224] = {
    ClearCondition = 160,
    RoomId = 213224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      6017021,
      6016023
    }
  },
  [213225] = {
    ClearCondition = 50,
    RoomId = 213225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_73,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [213311] = {
    ClearCondition = 100,
    RoomId = 213311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [213312] = {
    ClearCondition = 120,
    RoomId = 213312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6017019}
  },
  [213313] = {
    ClearCondition = 140,
    RoomId = 213313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6016015}
  },
  [213314] = {
    ClearCondition = 160,
    RoomId = 213314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      6017019,
      6016015
    }
  },
  [213315] = {
    ClearCondition = 50,
    RoomId = 213315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_75,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [213321] = {
    ClearCondition = 100,
    RoomId = 213321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [213322] = {
    ClearCondition = 120,
    RoomId = 213322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9001012}
  },
  [213323] = {
    ClearCondition = 140,
    RoomId = 213323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9002016}
  },
  [213324] = {
    ClearCondition = 160,
    RoomId = 213324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001012,
      9002016
    }
  },
  [213325] = {
    ClearCondition = 50,
    RoomId = 213325,
    RoomType = "Boss",
    StaticCreatorId = T.RT_65,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [213411] = {
    ClearCondition = 100,
    RoomId = 213411,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [213412] = {
    ClearCondition = 120,
    RoomId = 213412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8002014}
  },
  [213413] = {
    ClearCondition = 140,
    RoomId = 213413,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8003018}
  },
  [213414] = {
    ClearCondition = 160,
    RoomId = 213414,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002014,
      8003018
    }
  },
  [213415] = {
    ClearCondition = 50,
    RoomId = 213415,
    RoomType = "Boss",
    StaticCreatorId = T.RT_76,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [213421] = {
    ClearCondition = 100,
    RoomId = 213421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [213422] = {
    ClearCondition = 120,
    RoomId = 213422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_28
  },
  [213423] = {
    ClearCondition = 140,
    RoomId = 213423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_77
  },
  [213424] = {
    ClearCondition = 160,
    RoomId = 213424,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002012,
      8001011
    }
  },
  [213425] = {
    ClearCondition = 50,
    RoomId = 213425,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [213511] = {
    ClearCondition = 100,
    RoomId = 213511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [213512] = {
    ClearCondition = 120,
    RoomId = 213512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_35
  },
  [213513] = {
    ClearCondition = 140,
    RoomId = 213513,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_60
  },
  [213514] = {
    ClearCondition = 160,
    RoomId = 213514,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001016,
      9002024
    }
  },
  [213515] = {
    ClearCondition = 50,
    RoomId = 213515,
    RoomType = "Boss",
    StaticCreatorId = T.RT_73,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [213521] = {
    ClearCondition = 100,
    RoomId = 213521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [213522] = {
    ClearCondition = 120,
    RoomId = 213522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_78
  },
  [213523] = {
    ClearCondition = 140,
    RoomId = 213523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_79
  },
  [213524] = {
    ClearCondition = 160,
    RoomId = 213524,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      10005014,
      6016022
    }
  },
  [213525] = {
    ClearCondition = 50,
    RoomId = 213525,
    RoomType = "Boss",
    StaticCreatorId = T.RT_75,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [213611] = {
    ClearCondition = 100,
    RoomId = 213611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [213612] = {
    ClearCondition = 120,
    RoomId = 213612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002021}
  },
  [213613] = {
    ClearCondition = 140,
    RoomId = 213613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7003011}
  },
  [213614] = {
    ClearCondition = 160,
    RoomId = 213614,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002021,
      7003011
    }
  },
  [213615] = {
    ClearCondition = 50,
    RoomId = 213615,
    RoomType = "Boss",
    StaticCreatorId = T.RT_69,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [213621] = {
    ClearCondition = 100,
    RoomId = 213621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [213622] = {
    ClearCondition = 120,
    RoomId = 213622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_52
  },
  [213623] = {
    ClearCondition = 140,
    RoomId = 213623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7001019}
  },
  [213624] = {
    ClearCondition = 160,
    RoomId = 213624,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002016,
      7001019
    }
  },
  [213625] = {
    ClearCondition = 50,
    RoomId = 213625,
    RoomType = "Boss",
    StaticCreatorId = T.RT_63,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [214111] = {
    ClearCondition = 100,
    RoomId = 214111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [214112] = {
    ClearCondition = 120,
    RoomId = 214112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_80
  },
  [214113] = {
    ClearCondition = 140,
    RoomId = 214113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_77
  },
  [214114] = {
    ClearCondition = 160,
    RoomId = 214114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002021,
      8001011
    }
  },
  [214115] = {
    ClearCondition = 50,
    RoomId = 214115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [214121] = {
    ClearCondition = 100,
    RoomId = 214121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [214122] = {
    ClearCondition = 120,
    RoomId = 214122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60201, 6011023}
  },
  [214123] = {
    ClearCondition = 140,
    RoomId = 214123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_51
  },
  [214124] = {
    ClearCondition = 160,
    RoomId = 214124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6011023,
      6002015
    }
  },
  [214125] = {
    ClearCondition = 50,
    RoomId = 214125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_66,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [214211] = {
    ClearCondition = 100,
    RoomId = 214211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [214212] = {
    ClearCondition = 120,
    RoomId = 214212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6017012}
  },
  [214213] = {
    ClearCondition = 140,
    RoomId = 214213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_81
  },
  [214214] = {
    ClearCondition = 160,
    RoomId = 214214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      6017012,
      6016019
    }
  },
  [214215] = {
    ClearCondition = 50,
    RoomId = 214215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_73,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [214221] = {
    ClearCondition = 100,
    RoomId = 214221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [214222] = {
    ClearCondition = 120,
    RoomId = 214222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_82
  },
  [214223] = {
    ClearCondition = 140,
    RoomId = 214223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_83
  },
  [214224] = {
    ClearCondition = 160,
    RoomId = 214224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_84
  },
  [214225] = {
    ClearCondition = 50,
    RoomId = 214225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_61,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [214311] = {
    ClearCondition = 100,
    RoomId = 214311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [214312] = {
    ClearCondition = 120,
    RoomId = 214312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_85
  },
  [214313] = {
    ClearCondition = 140,
    RoomId = 214313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {90201, 9002018}
  },
  [214314] = {
    ClearCondition = 160,
    RoomId = 214314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001020,
      9002018
    }
  },
  [214315] = {
    ClearCondition = 50,
    RoomId = 214315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_65,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [214321] = {
    ClearCondition = 100,
    RoomId = 214321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [214322] = {
    ClearCondition = 120,
    RoomId = 214322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {70201, 7002024}
  },
  [214323] = {
    ClearCondition = 140,
    RoomId = 214323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_43
  },
  [214324] = {
    ClearCondition = 160,
    RoomId = 214324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002024,
      7003016
    }
  },
  [214325] = {
    ClearCondition = 50,
    RoomId = 214325,
    RoomType = "Boss",
    StaticCreatorId = T.RT_59,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [214411] = {
    ClearCondition = 100,
    RoomId = 214411,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [214412] = {
    ClearCondition = 120,
    RoomId = 214412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_70
  },
  [214413] = {
    ClearCondition = 140,
    RoomId = 214413,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8003021}
  },
  [214414] = {
    ClearCondition = 160,
    RoomId = 214414,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002017,
      8003021
    }
  },
  [214415] = {
    ClearCondition = 50,
    RoomId = 214415,
    RoomType = "Boss",
    StaticCreatorId = T.RT_76,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [214421] = {
    ClearCondition = 100,
    RoomId = 214421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [214422] = {
    ClearCondition = 120,
    RoomId = 214422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_44
  },
  [214423] = {
    ClearCondition = 140,
    RoomId = 214423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_64
  },
  [214424] = {
    ClearCondition = 160,
    RoomId = 214424,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002023,
      8001019
    }
  },
  [214425] = {
    ClearCondition = 50,
    RoomId = 214425,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [214511] = {
    ClearCondition = 100,
    RoomId = 214511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [214512] = {
    ClearCondition = 120,
    RoomId = 214512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 10005011}
  },
  [214513] = {
    ClearCondition = 140,
    RoomId = 214513,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_79
  },
  [214514] = {
    ClearCondition = 160,
    RoomId = 214514,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      10005011,
      6016022
    }
  },
  [214515] = {
    ClearCondition = 50,
    RoomId = 214515,
    RoomType = "Boss",
    StaticCreatorId = T.RT_75,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [214521] = {
    ClearCondition = 100,
    RoomId = 214521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [214522] = {
    ClearCondition = 120,
    RoomId = 214522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6017016}
  },
  [214523] = {
    ClearCondition = 140,
    RoomId = 214523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_86
  },
  [214524] = {
    ClearCondition = 160,
    RoomId = 214524,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      6017016,
      6016018
    }
  },
  [214525] = {
    ClearCondition = 50,
    RoomId = 214525,
    RoomType = "Boss",
    StaticCreatorId = T.RT_73,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [214611] = {
    ClearCondition = 100,
    RoomId = 214611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [214612] = {
    ClearCondition = 120,
    RoomId = 214612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_40
  },
  [214613] = {
    ClearCondition = 140,
    RoomId = 214613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_49
  },
  [214614] = {
    ClearCondition = 160,
    RoomId = 214614,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002014,
      7001015
    }
  },
  [214615] = {
    ClearCondition = 50,
    RoomId = 214615,
    RoomType = "Boss",
    StaticCreatorId = T.RT_63,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [214621] = {
    ClearCondition = 100,
    RoomId = 214621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [214622] = {
    ClearCondition = 120,
    RoomId = 214622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_42
  },
  [214623] = {
    ClearCondition = 140,
    RoomId = 214623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_87
  },
  [214624] = {
    ClearCondition = 160,
    RoomId = 214624,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002012,
      7003024
    }
  },
  [214625] = {
    ClearCondition = 50,
    RoomId = 214625,
    RoomType = "Boss",
    StaticCreatorId = T.RT_69,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [215111] = {
    ClearCondition = 100,
    RoomId = 215111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_31
  },
  [215112] = {
    ClearCondition = 120,
    RoomId = 215112,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_50
  },
  [215113] = {
    ClearCondition = 140,
    RoomId = 215113,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_67
  },
  [215114] = {
    ClearCondition = 160,
    RoomId = 215114,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60201,
      6001012,
      6012021
    }
  },
  [215115] = {
    ClearCondition = 50,
    RoomId = 215115,
    RoomType = "Boss",
    StaticCreatorId = T.RT_57,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_33
  },
  [215121] = {
    ClearCondition = 100,
    RoomId = 215121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [215122] = {
    ClearCondition = 120,
    RoomId = 215122,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_54
  },
  [215123] = {
    ClearCondition = 140,
    RoomId = 215123,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_77
  },
  [215124] = {
    ClearCondition = 160,
    RoomId = 215124,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002018,
      8001011
    }
  },
  [215125] = {
    ClearCondition = 50,
    RoomId = 215125,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [215211] = {
    ClearCondition = 100,
    RoomId = 215211,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [215212] = {
    ClearCondition = 120,
    RoomId = 215212,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_82
  },
  [215213] = {
    ClearCondition = 140,
    RoomId = 215213,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_83
  },
  [215214] = {
    ClearCondition = 160,
    RoomId = 215214,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_84
  },
  [215215] = {
    ClearCondition = 50,
    RoomId = 215215,
    RoomType = "Boss",
    StaticCreatorId = T.RT_61,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [215221] = {
    ClearCondition = 100,
    RoomId = 215221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [215222] = {
    ClearCondition = 120,
    RoomId = 215222,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 10005016}
  },
  [215223] = {
    ClearCondition = 140,
    RoomId = 215223,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_79
  },
  [215224] = {
    ClearCondition = 160,
    RoomId = 215224,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      10005016,
      6016022
    }
  },
  [215225] = {
    ClearCondition = 50,
    RoomId = 215225,
    RoomType = "Boss",
    StaticCreatorId = T.RT_75,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [215311] = {
    ClearCondition = 100,
    RoomId = 215311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [215312] = {
    ClearCondition = 120,
    RoomId = 215312,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_71
  },
  [215313] = {
    ClearCondition = 140,
    RoomId = 215313,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_87
  },
  [215314] = {
    ClearCondition = 160,
    RoomId = 215314,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002020,
      7003024
    }
  },
  [215315] = {
    ClearCondition = 50,
    RoomId = 215315,
    RoomType = "Boss",
    StaticCreatorId = T.RT_69,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [215321] = {
    ClearCondition = 100,
    RoomId = 215321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [215322] = {
    ClearCondition = 120,
    RoomId = 215322,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_58
  },
  [215323] = {
    ClearCondition = 140,
    RoomId = 215323,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_49
  },
  [215324] = {
    ClearCondition = 160,
    RoomId = 215324,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002023,
      7001015
    }
  },
  [215325] = {
    ClearCondition = 50,
    RoomId = 215325,
    RoomType = "Boss",
    StaticCreatorId = T.RT_63,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [215411] = {
    ClearCondition = 100,
    RoomId = 215411,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [215412] = {
    ClearCondition = 120,
    RoomId = 215412,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_80
  },
  [215413] = {
    ClearCondition = 140,
    RoomId = 215413,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_55
  },
  [215414] = {
    ClearCondition = 160,
    RoomId = 215414,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002021,
      8001015
    }
  },
  [215415] = {
    ClearCondition = 50,
    RoomId = 215415,
    RoomType = "Boss",
    StaticCreatorId = T.RT_56,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [215421] = {
    ClearCondition = 100,
    RoomId = 215421,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_27
  },
  [215422] = {
    ClearCondition = 120,
    RoomId = 215422,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_28
  },
  [215423] = {
    ClearCondition = 140,
    RoomId = 215423,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {80201, 8003023}
  },
  [215424] = {
    ClearCondition = 160,
    RoomId = 215424,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      80201,
      8002012,
      8003023
    }
  },
  [215425] = {
    ClearCondition = 50,
    RoomId = 215425,
    RoomType = "Boss",
    StaticCreatorId = T.RT_76,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_30
  },
  [215511] = {
    ClearCondition = 100,
    RoomId = 215511,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [215512] = {
    ClearCondition = 120,
    RoomId = 215512,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {60203, 6017017}
  },
  [215513] = {
    ClearCondition = 140,
    RoomId = 215513,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_81
  },
  [215514] = {
    ClearCondition = 160,
    RoomId = 215514,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      6017017,
      6016019
    }
  },
  [215515] = {
    ClearCondition = 50,
    RoomId = 215515,
    RoomType = "Boss",
    StaticCreatorId = T.RT_73,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [215521] = {
    ClearCondition = 100,
    RoomId = 215521,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_72
  },
  [215522] = {
    ClearCondition = 120,
    RoomId = 215522,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_78
  },
  [215523] = {
    ClearCondition = 140,
    RoomId = 215523,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_86
  },
  [215524] = {
    ClearCondition = 160,
    RoomId = 215524,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      60203,
      10005014,
      6016018
    }
  },
  [215525] = {
    ClearCondition = 50,
    RoomId = 215525,
    RoomType = "Boss",
    StaticCreatorId = T.RT_75,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_74
  },
  [215611] = {
    ClearCondition = 100,
    RoomId = 215611,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_37
  },
  [215612] = {
    ClearCondition = 120,
    RoomId = 215612,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_48
  },
  [215613] = {
    ClearCondition = 140,
    RoomId = 215613,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_68
  },
  [215614] = {
    ClearCondition = 160,
    RoomId = 215614,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      70201,
      7002011,
      7003022
    }
  },
  [215615] = {
    ClearCondition = 50,
    RoomId = 215615,
    RoomType = "Boss",
    StaticCreatorId = T.RT_69,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_39
  },
  [215621] = {
    ClearCondition = 100,
    RoomId = 215621,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_34
  },
  [215622] = {
    ClearCondition = 120,
    RoomId = 215622,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_85
  },
  [215623] = {
    ClearCondition = 140,
    RoomId = 215623,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = T.RT_60
  },
  [215624] = {
    ClearCondition = 160,
    RoomId = 215624,
    RoomType = "Default",
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Default.BP_EMGameMode_Abyss_Default",
    TimeLimit = 90,
    UnitSpawnId = {
      90201,
      9001020,
      9002024
    }
  },
  [215625] = {
    ClearCondition = 50,
    RoomId = 215625,
    RoomType = "Boss",
    StaticCreatorId = T.RT_65,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossNew.BP_EMGameMode_Abyss_BossNew",
    TimeLimit = 180,
    UnitSpawnId = T.RT_36
  },
  [220111] = {
    ClearCondition = 100,
    RoomId = 220111,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_20
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
    StaticCreatorId = T.RT_9,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_10
  },
  [220121] = {
    ClearCondition = 100,
    RoomId = 220121,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_20
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
    StaticCreatorId = T.RT_12,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_10
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
    StaticCreatorId = T.RT_16,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 180,
    UnitSpawnId = T.RT_17
  },
  [220221] = {
    ClearCondition = 100,
    RoomId = 220221,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_18
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
    StaticCreatorId = T.RT_22,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 205,
    UnitSpawnId = T.RT_15
  },
  [220311] = {
    ClearCondition = 100,
    RoomId = 220311,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_21
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
    StaticCreatorId = T.RT_24,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 255,
    UnitSpawnId = T.RT_17
  },
  [220321] = {
    ClearCondition = 100,
    RoomId = 220321,
    RoomType = "Default",
    StaticCreatorId = T.RT_1,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_Start.BP_EMGameMode_Abyss_Start",
    TimeLimit = 90,
    UnitSpawnId = T.RT_18
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
    StaticCreatorId = T.RT_19,
    SubGamemode = "/Game/AssetDesign/GameMode/Abyss/BP_EMGameMode_Abyss_BossBase.BP_EMGameMode_Abyss_BossBase",
    TimeLimit = 225,
    UnitSpawnId = T.RT_15
  }
})
