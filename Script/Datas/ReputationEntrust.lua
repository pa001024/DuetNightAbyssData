local T = {}
T.RT_1 = {
  [1] = 6,
  [2] = 10
}
T.RT_2 = {
  [1] = "Resource",
  [2] = "Resource"
}
T.RT_3 = {
  [1] = 10,
  [2] = 10
}
T.RT_4 = {
  [1] = 100,
  [2] = 400
}
T.RT_5 = {
  [1] = 20001,
  [2] = 20012
}
T.RT_6 = {
  [1] = 20003,
  [2] = 20005
}
T.RT_7 = {
  [1] = 20004,
  [2] = 20011
}
T.RT_8 = {
  [1] = 400,
  [2] = 50
}
T.RT_9 = {
  [1] = 20009,
  [2] = 20014
}
T.RT_10 = {
  [1] = 600,
  [2] = 50
}
T.RT_11 = {
  [1] = 20002,
  [2] = 20019
}
T.RT_12 = {
  [1] = 20012,
  [2] = 20017
}
T.RT_13 = {
  [1] = 10,
  [2] = 50
}
T.RT_14 = {
  [1] = 20006,
  [2] = 20017
}
T.RT_15 = {
  [1] = 20022,
  [2] = 20020
}
T.RT_16 = {
  [1] = 20007,
  [2] = 20018
}
T.RT_17 = {
  [1] = 150,
  [2] = 10
}
T.RT_18 = {
  [1] = 100,
  [2] = 10
}
T.RT_19 = {
  [1] = 20015,
  [2] = 4010019
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ReputationEntrust", {
  [10001] = {
    Count = T.RT_1,
    EntrustContent = "RegionReputation_EntrustContent_new_01",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 4010011,
      [2] = 4010010
    },
    Key = 10001,
    NPCName = "UI_CHAR_NAME_0001",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10002] = {
    Count = T.RT_1,
    EntrustContent = "RegionReputation_EntrustContent_new_02",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head01.T_Fame_Head01",
    Id = {
      [1] = 4010011,
      [2] = 4010005
    },
    Key = 10002,
    NPCName = "UI_CHAR_NAME_0002",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10003] = {
    Count = T.RT_1,
    EntrustContent = "RegionReputation_EntrustContent_new_03",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head03.T_Fame_Head03",
    Id = {
      [1] = 4010011,
      [2] = 4020003
    },
    Key = 10003,
    NPCName = "UI_CHAR_NAME_0003",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10004] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_new_04",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 4010010,
      [2] = 4010008
    },
    Key = 10004,
    NPCName = "UI_CHAR_NAME_0004",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10005] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_new_05",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 4010010,
      [2] = 4010004
    },
    Key = 10005,
    NPCName = "UI_CHAR_NAME_0005",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10006] = {
    Count = T.RT_4,
    EntrustContent = "RegionReputation_EntrustContent_new_06",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_5,
    Key = 10006,
    NPCName = "UI_CHAR_NAME_0006",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10007] = {
    Count = T.RT_4,
    EntrustContent = "RegionReputation_EntrustContent_new_07",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_6,
    Key = 10007,
    NPCName = "UI_CHAR_NAME_0007",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10008] = {
    Count = T.RT_4,
    EntrustContent = "RegionReputation_EntrustContent_new_08",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_7,
    Key = 10008,
    NPCName = "UI_CHAR_NAME_0008",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10009] = {
    Count = T.RT_8,
    EntrustContent = "RegionReputation_EntrustContent_new_09",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head03.T_Fame_Head03",
    Id = T.RT_9,
    Key = 10009,
    NPCName = "UI_CHAR_NAME_0009",
    Rarity = 2,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 20
  },
  [10010] = {
    Count = T.RT_10,
    EntrustContent = "RegionReputation_EntrustContent_new_10",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head03.T_Fame_Head03",
    Id = T.RT_11,
    Key = 10010,
    NPCName = "UI_CHAR_NAME_0010",
    Rarity = 3,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 10
  },
  [10011] = {
    Count = T.RT_10,
    EntrustContent = "RegionReputation_EntrustContent_new_11",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_12,
    Key = 10011,
    NPCName = "UI_CHAR_NAME_0011",
    Rarity = 3,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 10
  },
  [10012] = {
    Count = T.RT_13,
    EntrustContent = "RegionReputation_EntrustContent_new_12",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head04.T_Fame_Head04",
    Id = T.RT_14,
    Key = 10012,
    NPCName = "UI_CHAR_NAME_0012",
    Rarity = 3,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 10
  },
  [10013] = {
    Count = T.RT_13,
    EntrustContent = "RegionReputation_EntrustContent_new_13",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head03.T_Fame_Head03",
    Id = T.RT_15,
    Key = 10013,
    NPCName = "UI_CHAR_NAME_0013",
    Rarity = 3,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 10
  },
  [10014] = {
    Count = T.RT_13,
    EntrustContent = "RegionReputation_EntrustContent_new_14",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head01.T_Fame_Head01",
    Id = T.RT_16,
    Key = 10014,
    NPCName = "UI_CHAR_NAME_0014",
    Rarity = 3,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 10
  },
  [10015] = {
    Count = T.RT_17,
    EntrustContent = "RegionReputation_EntrustContent_new_15",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Kami",
    Id = {
      [1] = 20004,
      [2] = 4010011
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 10015,
    NPCName = "UI_CHAR_NAME_0015",
    Rarity = 4,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 5
  },
  [10016] = {
    Count = T.RT_17,
    EntrustContent = "RegionReputation_EntrustContent_new_16",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Maer.T_Head_Maer",
    Id = {
      [1] = 20015,
      [2] = 4010010
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 10016,
    NPCName = "UI_CHAR_NAME_0016",
    Rarity = 4,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 5
  },
  [10017] = {
    Count = T.RT_17,
    EntrustContent = "RegionReputation_EntrustContent_new_17",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Feina.T_Head_Feina",
    Id = {
      [1] = 20016,
      [2] = 4010004
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 10017,
    NPCName = "UI_CHAR_NAME_0017",
    Rarity = 4,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 5
  },
  [10018] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_new_18",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Feina.T_Head_Feina",
    Id = {
      [1] = 20007,
      [2] = 4010005
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 10018,
    NPCName = "UI_CHAR_NAME_0018",
    Rarity = 4,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 5
  },
  [10019] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_new_19",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Kami",
    Id = {
      [1] = 20025,
      [2] = 4020003
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 10019,
    NPCName = "UI_CHAR_NAME_0019",
    Rarity = 4,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 5
  },
  [10020] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_new_19",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Kami",
    Id = {
      [1] = 20026,
      [2] = 4010008
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 10020,
    NPCName = "UI_CHAR_NAME_0019",
    Rarity = 4,
    ReputationID = 1001,
    Resource = 2015,
    Type = T.RT_2,
    Weight = 5
  },
  [11001] = {
    Count = T.RT_1,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_01",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 4010018,
      [2] = 4010019
    },
    Key = 11001,
    NPCName = "UI_CHAR_HUAXV_NAME_0001",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11002] = {
    Count = T.RT_1,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_02",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head01.T_Fame_Head01",
    Id = {
      [1] = 4010018,
      [2] = 4010015
    },
    Key = 11002,
    NPCName = "UI_CHAR_HUAXV_NAME_0002",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11003] = {
    Count = T.RT_1,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_03",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 4010018,
      [2] = 4020006
    },
    Key = 11003,
    NPCName = "UI_CHAR_HUAXV_NAME_0003",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11004] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_04",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 4010019,
      [2] = 4010016
    },
    Key = 11004,
    NPCName = "UI_CHAR_HUAXV_NAME_0004",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11005] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_05",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Cat",
    Id = {
      [1] = 4010019,
      [2] = 4010017
    },
    Key = 11005,
    NPCName = "UI_CHAR_HUAXV_NAME_0005",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11006] = {
    Count = T.RT_4,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_06",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head01.T_Fame_Head01",
    Id = T.RT_5,
    Key = 11006,
    NPCName = "UI_CHAR_HUAXV_NAME_0006",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11007] = {
    Count = T.RT_4,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_07",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_6,
    Key = 11007,
    NPCName = "UI_CHAR_HUAXV_NAME_0007",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11008] = {
    Count = T.RT_4,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_08",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_7,
    Key = 11008,
    NPCName = "UI_CHAR_HUAXV_NAME_0008",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11009] = {
    Count = T.RT_8,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_09",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_9,
    Key = 11009,
    NPCName = "UI_CHAR_HUAXV_NAME_0009",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11010] = {
    Count = T.RT_8,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_10",
    EntrustTitle = "RegionReputation_EntrustTitle_new01",
    ExpCount = 20,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head03.T_Fame_Head03",
    Id = T.RT_11,
    Key = 11010,
    NPCName = "UI_CHAR_HUAXV_NAME_0010",
    Rarity = 2,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 20
  },
  [11011] = {
    Count = {
      [1] = 450,
      [2] = 50
    },
    EntrustContent = "RegionReputation_EntrustContent_huaxv_11",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head03.T_Fame_Head03",
    Id = T.RT_12,
    Key = 11011,
    NPCName = "UI_CHAR_HUAXV_NAME_0011",
    Rarity = 3,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 10
  },
  [11012] = {
    Count = T.RT_13,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_12",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_14,
    Key = 11012,
    NPCName = "UI_CHAR_HUAXV_NAME_0012",
    Rarity = 3,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 10
  },
  [11013] = {
    Count = T.RT_13,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_13",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_15,
    Key = 11013,
    NPCName = "UI_CHAR_HUAXV_NAME_0013",
    Rarity = 3,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 10
  },
  [11014] = {
    Count = T.RT_13,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_14",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = T.RT_16,
    Key = 11014,
    NPCName = "UI_CHAR_HUAXV_NAME_0014",
    Rarity = 3,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 10
  },
  [11015] = {
    Count = T.RT_18,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_15",
    EntrustTitle = "RegionReputation_EntrustTitle_new02",
    ExpCount = 30,
    Icon = "/Game/UI/Texture/Dynamic/Image/Fame/T_Fame_Head02.T_Fame_Head02",
    Id = {
      [1] = 20004,
      [2] = 4010018
    },
    Key = 11015,
    NPCName = "UI_CHAR_HUAXV_NAME_0015",
    Rarity = 3,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 10
  },
  [11016] = {
    Count = T.RT_17,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_16",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Zhiliu.T_Head_Zhiliu",
    Id = T.RT_19,
    ItemId = 110070,
    ItemType = "Resource",
    Key = 11016,
    NPCName = "UI_CHAR_HUAXV_NAME_0016",
    Rarity = 4,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 5
  },
  [11017] = {
    Count = T.RT_17,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_17",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Qiu.T_Head_Qiu",
    Id = {
      [1] = 20016,
      [2] = 4010017
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 11017,
    NPCName = "UI_CHAR_HUAXV_NAME_0017",
    Rarity = 4,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 5
  },
  [11018] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_18",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Yuming.T_Head_Yuming",
    Id = {
      [1] = 20007,
      [2] = 4010015
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 11018,
    NPCName = "UI_CHAR_HUAXV_NAME_0018",
    Rarity = 4,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 5
  },
  [11019] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_19",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Kezhou.T_Head_Kezhou",
    Id = {
      [1] = 20025,
      [2] = 4020006
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 11019,
    NPCName = "UI_CHAR_HUAXV_NAME_0019",
    Rarity = 4,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 5
  },
  [11020] = {
    Count = T.RT_3,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_20",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Zhiliu.T_Head_Zhiliu",
    Id = {
      [1] = 20026,
      [2] = 4010016
    },
    ItemId = 110070,
    ItemType = "Resource",
    Key = 11020,
    NPCName = "UI_CHAR_HUAXV_NAME_0020",
    Rarity = 4,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 5
  },
  [11021] = {
    Count = T.RT_18,
    EntrustContent = "RegionReputation_EntrustContent_huaxv_21",
    EntrustTitle = "RegionReputation_EntrustTitle_new03",
    ExpCount = 40,
    Icon = "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Suyi",
    Id = T.RT_19,
    ItemId = 110070,
    ItemType = "Resource",
    Key = 11021,
    NPCName = "UI_CHAR_HUAXV_NAME_0021",
    Rarity = 4,
    ReputationID = 1002,
    Resource = 2016,
    Type = T.RT_2,
    Weight = 5
  }
})
