local T = {}
T.RT_1 = {1030909}
T.RT_2 = {1030910}
T.RT_3 = {1030915}
T.RT_4 = {1030916}
T.RT_5 = {300303}
T.RT_6 = {50939}
T.RT_7 = {300304}
T.RT_8 = {300305}
T.RT_9 = {300306}
T.RT_10 = {300307}
T.RT_11 = {300308}
T.RT_12 = {300309}
T.RT_13 = {50940}
T.RT_14 = {300310}
T.RT_15 = {300311}
T.RT_16 = {300312}
T.RT_17 = {300313}
T.RT_18 = {300314}
T.RT_19 = {50941}
T.RT_20 = {50942}
T.RT_21 = {1080201}
T.RT_22 = {1000501}
T.RT_23 = {50930}
T.RT_24 = {1900101}
T.RT_25 = {30101}
T.RT_26 = {2300101}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CommonQuestDetail", {
  [10200101] = {
    EventId = 102001,
    QuestId = 10200101,
    QuestPhaseId = 1001,
    QuestReward = {10200201},
    StarterQuestDes = "Name_120101",
    Target = 1,
    TargetId = {10200101}
  },
  [10200102] = {
    EventId = 102001,
    QuestId = 10200102,
    QuestPhaseId = 1001,
    QuestReward = {10200202},
    StarterQuestDes = "Name_120102",
    Target = 1,
    TargetId = {10200102}
  },
  [10200103] = {
    EventId = 102001,
    QuestId = 10200103,
    QuestPhaseId = 1001,
    QuestReward = {10200203},
    StarterQuestDes = "Name_120103",
    Target = 1,
    TargetId = {10200103}
  },
  [10200104] = {
    EventId = 102001,
    QuestId = 10200104,
    QuestPhaseId = 1001,
    QuestReward = {10200204},
    StarterQuestDes = "Name_120104",
    Target = 1,
    TargetId = {10200104}
  },
  [10200105] = {
    EventId = 102001,
    QuestId = 10200105,
    QuestPhaseId = 1001,
    QuestReward = {10200205},
    StarterQuestDes = "Name_120105",
    Target = 1,
    TargetId = {10200105}
  },
  [10200106] = {
    EventId = 102001,
    QuestId = 10200106,
    QuestPhaseId = 1001,
    QuestReward = {10200206},
    StarterQuestDes = "Name_120106",
    Target = 1,
    TargetId = {10200106}
  },
  [10200107] = {
    EventId = 102001,
    QuestId = 10200107,
    QuestPhaseId = 1002,
    QuestReward = {10200207},
    StarterQuestDes = "HuaXu_Event_Des_10200107",
    Target = 20,
    TargetId = {
      501320,
      501321,
      501322,
      501323,
      501324,
      501325,
      501326,
      501327
    }
  },
  [10200108] = {
    EventId = 102001,
    QuestId = 10200108,
    QuestPhaseId = 1002,
    QuestReward = {10200208},
    StarterQuestDes = "HuaXu_Event_Des_10200108",
    Target = 3,
    TargetId = {505201, 505202}
  },
  [10200109] = {
    EventId = 102001,
    QuestId = 10200109,
    QuestPhaseId = 1002,
    QuestReward = {10200209},
    StarterQuestDes = "HuaXu_Event_Des_10200109",
    Target = 3,
    TargetId = {
      520201,
      520202,
      520203
    }
  },
  [10200110] = {
    EventId = 102001,
    QuestId = 10200110,
    QuestPhaseId = 1002,
    QuestReward = {10200210},
    StarterQuestDes = "HuaXu_Event_Des_10200110",
    Target = 5,
    TargetId = {505203}
  },
  [10200111] = {
    EventId = 102001,
    QuestId = 10200111,
    QuestPhaseId = 1003,
    QuestReward = {10200211},
    StarterQuestDes = "HuaXu_Event_Des_10200111",
    Target = 50,
    TargetId = {2201}
  },
  [10200112] = {
    EventId = 102001,
    QuestId = 10200112,
    QuestPhaseId = 1003,
    QuestReward = {10200212},
    StarterQuestDes = "HuaXu_Event_Des_10200112",
    Target = 50,
    TargetId = {2202}
  },
  [10200113] = {
    EventId = 102001,
    QuestId = 10200113,
    QuestPhaseId = 1003,
    QuestReward = {10200213},
    StarterQuestDes = "HuaXu_Event_Des_10200113",
    Target = 1,
    TargetId = {2203}
  },
  [10200114] = {
    EventId = 102001,
    QuestId = 10200114,
    QuestPhaseId = 1003,
    QuestReward = {10200214},
    StarterQuestDes = "HuaXu_Event_Des_10200114",
    Target = 1,
    TargetId = {2204}
  },
  [10200115] = {
    EventId = 102001,
    QuestId = 10200115,
    QuestPhaseId = 1003,
    QuestReward = {10200215},
    StarterQuestDes = "HuaXu_Event_Des_10200115",
    Target = 1,
    TargetId = {2205}
  },
  [10200116] = {
    EventId = 102001,
    QuestId = 10200116,
    QuestPhaseId = 1004,
    QuestReward = {10200216},
    StarterQuestDes = "HuaXu_Event_Des_10200116",
    Target = 8,
    TargetId = {520006}
  },
  [10200117] = {
    EventId = 102001,
    QuestId = 10200117,
    QuestPhaseId = 1004,
    QuestReward = {10200217},
    StarterQuestDes = "HuaXu_Event_Des_10200117",
    Target = 20,
    TargetId = {10200117}
  },
  [10200118] = {
    EventId = 102001,
    QuestId = 10200118,
    QuestPhaseId = 1004,
    QuestReward = {10200218},
    StarterQuestDes = "HuaXu_Event_Des_10200118",
    Target = 5,
    TargetId = {101004}
  },
  [10200119] = {
    EventId = 102001,
    QuestId = 10200119,
    QuestPhaseId = 1004,
    QuestReward = {10200219},
    StarterQuestDes = "HuaXu_Event_Des_10200119",
    Target = 5,
    TargetId = {10131}
  },
  [10300000] = {
    EventId = 103016,
    QuestId = 10300000,
    QuestPhaseId = 3001,
    QuestReward = {302060},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_0",
    Target = 1,
    TargetId = T.RT_1
  },
  [10300001] = {
    EventId = 103016,
    QuestId = 10300001,
    QuestPhaseId = 3001,
    QuestReward = {302036},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_1",
    Target = 5,
    TargetId = T.RT_1
  },
  [10300002] = {
    EventId = 103016,
    QuestId = 10300002,
    QuestPhaseId = 3001,
    QuestReward = {302037},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_2",
    Target = 10,
    TargetId = T.RT_1
  },
  [10300003] = {
    EventId = 103016,
    QuestId = 10300003,
    QuestPhaseId = 3001,
    QuestReward = {302038},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_3",
    Target = 100,
    TargetId = T.RT_2
  },
  [10300004] = {
    EventId = 103016,
    QuestId = 10300004,
    QuestPhaseId = 3001,
    QuestReward = {302039},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_4",
    Target = 200,
    TargetId = T.RT_2
  },
  [10300101] = {
    EventId = 103016,
    QuestId = 10300101,
    QuestPhaseId = 3002,
    QuestReward = {302001},
    StarterQuestDes = "AutoChess_Quest_2_1",
    Target = 1,
    TargetId = {1030917}
  },
  [10300102] = {
    EventId = 103016,
    QuestId = 10300102,
    QuestPhaseId = 3002,
    QuestReward = {302002},
    StarterQuestDes = "AutoChess_Quest_2_2",
    Target = 1,
    TargetId = {1030918}
  },
  [10300103] = {
    EventId = 103016,
    QuestId = 10300103,
    QuestPhaseId = 3002,
    QuestReward = {302003},
    StarterQuestDes = "AutoChess_Quest_2_3",
    Target = 1,
    TargetId = {1030919}
  },
  [10300104] = {
    EventId = 103016,
    QuestId = 10300104,
    QuestPhaseId = 3002,
    QuestReward = {302004},
    StarterQuestDes = "AutoChess_Quest_2_4",
    Target = 1,
    TargetId = {1030920}
  },
  [10300105] = {
    EventId = 103016,
    QuestId = 10300105,
    QuestPhaseId = 3002,
    QuestReward = {302005},
    StarterQuestDes = "AutoChess_Quest_2_5",
    Target = 1,
    TargetId = {1030921}
  },
  [10300106] = {
    EventId = 103016,
    QuestId = 10300106,
    QuestPhaseId = 3002,
    QuestReward = {302006},
    StarterQuestDes = "AutoChess_Quest_2_6",
    Target = 1,
    TargetId = {1030922}
  },
  [10300107] = {
    EventId = 103016,
    QuestId = 10300107,
    QuestPhaseId = 3002,
    QuestReward = {302007},
    StarterQuestDes = "AutoChess_Quest_2_7",
    Target = 1,
    TargetId = {1030923}
  },
  [10300108] = {
    EventId = 103016,
    QuestId = 10300108,
    QuestPhaseId = 3002,
    QuestReward = {302008},
    StarterQuestDes = "AutoChess_Quest_2_8",
    Target = 1,
    TargetId = {1030924}
  },
  [10300109] = {
    EventId = 103016,
    QuestId = 10300109,
    QuestPhaseId = 3002,
    QuestReward = {302009},
    StarterQuestDes = "AutoChess_Quest_2_9",
    Target = 1,
    TargetId = {1030925}
  },
  [10300110] = {
    EventId = 103016,
    QuestId = 10300110,
    QuestPhaseId = 3002,
    QuestReward = {302010},
    StarterQuestDes = "AutoChess_Quest_2_10",
    Target = 1,
    TargetId = {1030926}
  },
  [10300111] = {
    EventId = 103016,
    QuestId = 10300111,
    QuestPhaseId = 3002,
    QuestReward = {302011},
    StarterQuestDes = "AutoChess_Quest_2_11",
    Target = 1,
    TargetId = {1030927}
  },
  [10300112] = {
    EventId = 103016,
    QuestId = 10300112,
    QuestPhaseId = 3002,
    QuestReward = {302012},
    StarterQuestDes = "AutoChess_Quest_2_12",
    Target = 1,
    TargetId = {1030928}
  },
  [10300113] = {
    EventId = 103016,
    QuestId = 10300113,
    QuestPhaseId = 3002,
    QuestReward = {302013},
    StarterQuestDes = "AutoChess_Quest_2_13",
    Target = 1,
    TargetId = {1030929}
  },
  [10300114] = {
    EventId = 103016,
    QuestId = 10300114,
    QuestPhaseId = 3002,
    QuestReward = {302014},
    StarterQuestDes = "AutoChess_Quest_2_14",
    Target = 1,
    TargetId = {1030930}
  },
  [10300115] = {
    EventId = 103016,
    QuestId = 10300115,
    QuestPhaseId = 3002,
    QuestReward = {302015},
    StarterQuestDes = "AutoChess_Quest_2_15",
    Target = 1,
    TargetId = {1030931}
  },
  [10300116] = {
    EventId = 103016,
    QuestId = 10300116,
    QuestPhaseId = 3002,
    QuestReward = {302061},
    StarterQuestDes = "AutoChess_Quest_2_24",
    Target = 1,
    TargetId = {1030932}
  },
  [10300117] = {
    EventId = 103016,
    QuestId = 10300117,
    QuestPhaseId = 3002,
    QuestReward = {302016},
    StarterQuestDes = "AutoChess_Quest_2_16",
    Target = 1,
    TargetId = {1030901}
  },
  [10300118] = {
    EventId = 103016,
    QuestId = 10300118,
    QuestPhaseId = 3002,
    QuestReward = {302017},
    StarterQuestDes = "AutoChess_Quest_2_17",
    Target = 1,
    TargetId = {1030902}
  },
  [10300119] = {
    EventId = 103016,
    QuestId = 10300119,
    QuestPhaseId = 3002,
    QuestReward = {302018},
    StarterQuestDes = "AutoChess_Quest_2_18",
    Target = 1,
    TargetId = {1030903}
  },
  [10300120] = {
    EventId = 103016,
    QuestId = 10300120,
    QuestPhaseId = 3002,
    QuestReward = {302019},
    StarterQuestDes = "AutoChess_Quest_2_19",
    Target = 1,
    TargetId = {1030904}
  },
  [10300121] = {
    EventId = 103016,
    QuestId = 10300121,
    QuestPhaseId = 3002,
    QuestReward = {302020},
    StarterQuestDes = "AutoChess_Quest_2_20",
    Target = 1,
    TargetId = {1030905}
  },
  [10300122] = {
    EventId = 103016,
    QuestId = 10300122,
    QuestPhaseId = 3002,
    QuestReward = {302021},
    StarterQuestDes = "AutoChess_Quest_2_21",
    Target = 1,
    TargetId = {1030906}
  },
  [10300123] = {
    EventId = 103016,
    QuestId = 10300123,
    QuestPhaseId = 3002,
    QuestReward = {302022},
    StarterQuestDes = "AutoChess_Quest_2_22",
    Target = 1,
    TargetId = {1030907}
  },
  [10300124] = {
    EventId = 103016,
    QuestId = 10300124,
    QuestPhaseId = 3002,
    QuestReward = {302023},
    StarterQuestDes = "AutoChess_Quest_2_23",
    Target = 1,
    TargetId = {1030908}
  },
  [10300201] = {
    EventId = 103016,
    QuestId = 10300201,
    QuestPhaseId = 3004,
    QuestReward = {302024},
    StarterQuestDes = "AutoChess_Quest_3_1",
    Target = 10,
    TargetId = T.RT_1
  },
  [10300202] = {
    EventId = 103016,
    QuestId = 10300202,
    QuestPhaseId = 3004,
    QuestReward = {302025},
    StarterQuestDes = "AutoChess_Quest_3_2",
    Target = 50,
    TargetId = T.RT_1
  },
  [10300203] = {
    EventId = 103016,
    QuestId = 10300203,
    QuestPhaseId = 3004,
    QuestReward = {302026},
    StarterQuestDes = "AutoChess_Quest_3_3",
    Target = 500,
    TargetId = T.RT_2
  },
  [10300204] = {
    EventId = 103016,
    QuestId = 10300204,
    QuestPhaseId = 3004,
    QuestReward = {302027},
    StarterQuestDes = "AutoChess_Quest_3_4",
    Target = 1000,
    TargetId = T.RT_2
  },
  [10300207] = {
    EventId = 103016,
    QuestId = 10300207,
    QuestPhaseId = 3004,
    QuestReward = {302028},
    StarterQuestDes = "AutoChess_Quest_3_7",
    Target = 1,
    TargetId = {1030913}
  },
  [10300208] = {
    EventId = 103016,
    QuestId = 10300208,
    QuestPhaseId = 3004,
    QuestReward = {302029},
    StarterQuestDes = "AutoChess_Quest_3_8",
    Target = 1,
    TargetId = {1030914}
  },
  [10300209] = {
    EventId = 103016,
    QuestId = 10300209,
    QuestPhaseId = 3004,
    QuestReward = {302030},
    StarterQuestDes = "AutoChess_Quest_3_9",
    Target = 10,
    TargetId = T.RT_3
  },
  [10300213] = {
    EventId = 103016,
    QuestId = 10300213,
    QuestPhaseId = 3004,
    QuestReward = {302031},
    StarterQuestDes = "AutoChess_Quest_3_13",
    Target = 20,
    TargetId = T.RT_3
  },
  [10300214] = {
    EventId = 103016,
    QuestId = 10300214,
    QuestPhaseId = 3004,
    QuestReward = {302032},
    StarterQuestDes = "AutoChess_Quest_3_10",
    Target = 28,
    TargetId = T.RT_3
  },
  [10300215] = {
    EventId = 103016,
    QuestId = 10300215,
    QuestPhaseId = 3004,
    QuestReward = {302033},
    StarterQuestDes = "AutoChess_Quest_3_11",
    Target = 5,
    TargetId = T.RT_4
  },
  [10300216] = {
    EventId = 103016,
    QuestId = 10300216,
    QuestPhaseId = 3004,
    QuestReward = {302034},
    StarterQuestDes = "AutoChess_Quest_3_14",
    Target = 10,
    TargetId = T.RT_4
  },
  [10300217] = {
    EventId = 103016,
    QuestId = 10300217,
    QuestPhaseId = 3004,
    QuestReward = {302035},
    StarterQuestDes = "AutoChess_Quest_3_12",
    Target = 15,
    TargetId = T.RT_4
  },
  [10301801] = {
    EventId = 103018,
    QuestId = 10301801,
    QuestPhaseId = 3003,
    QuestReward = {110901},
    StarterQuestDes = "Event_10301801_Title01",
    Target = 10,
    TargetId = {10301801}
  },
  [10301802] = {
    EventId = 103018,
    QuestId = 10301802,
    QuestPhaseId = 3003,
    QuestReward = {110902},
    StarterQuestDes = "Event_10301801_Title02",
    Target = 5,
    TargetId = {10301802}
  },
  [10301803] = {
    EventId = 103018,
    QuestId = 10301803,
    QuestPhaseId = 3003,
    QuestReward = {110903},
    StarterQuestDes = "Event_10301801_Title03",
    Target = 3,
    TargetId = {10301803}
  },
  [10301804] = {
    EventId = 103018,
    QuestId = 10301804,
    QuestPhaseId = 3003,
    QuestReward = {110904},
    StarterQuestDes = "Event_10301801_Title04",
    Target = 5,
    TargetId = {10301804}
  },
  [10301805] = {
    EventId = 103018,
    QuestId = 10301805,
    QuestPhaseId = 3003,
    QuestReward = {110905},
    StarterQuestDes = "Event_10301801_Title05",
    Target = 5,
    TargetId = {10301805}
  },
  [10301806] = {
    EventId = 103018,
    QuestId = 10301806,
    QuestPhaseId = 3003,
    QuestReward = {110906},
    StarterQuestDes = "Event_10301801_Title06",
    Target = 5,
    TargetId = {10301806}
  },
  [11100101] = {
    EventId = 111001,
    QuestId = 11100101,
    QuestPhaseId = 2002,
    QuestReward = T.RT_5,
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_6
  },
  [11100102] = {
    EventId = 111001,
    QuestId = 11100102,
    QuestPhaseId = 2002,
    QuestReward = T.RT_7,
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_6
  },
  [11100103] = {
    EventId = 111001,
    QuestId = 11100103,
    QuestPhaseId = 2002,
    QuestReward = T.RT_8,
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_6
  },
  [11100104] = {
    EventId = 111001,
    QuestId = 11100104,
    QuestPhaseId = 2002,
    QuestReward = T.RT_9,
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_6
  },
  [11100105] = {
    EventId = 111001,
    QuestId = 11100105,
    QuestPhaseId = 2002,
    QuestReward = T.RT_10,
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_6
  },
  [11100106] = {
    EventId = 111001,
    QuestId = 11100106,
    QuestPhaseId = 2002,
    QuestReward = T.RT_11,
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_6
  },
  [11100107] = {
    EventId = 111001,
    QuestId = 11100107,
    QuestPhaseId = 2001,
    QuestReward = T.RT_12,
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_13
  },
  [11100108] = {
    EventId = 111001,
    QuestId = 11100108,
    QuestPhaseId = 2001,
    QuestReward = T.RT_14,
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_13
  },
  [11100109] = {
    EventId = 111001,
    QuestId = 11100109,
    QuestPhaseId = 2001,
    QuestReward = T.RT_15,
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_13
  },
  [11100110] = {
    EventId = 111001,
    QuestId = 11100110,
    QuestPhaseId = 2001,
    QuestReward = T.RT_16,
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_13
  },
  [11100111] = {
    EventId = 111001,
    QuestId = 11100111,
    QuestPhaseId = 2001,
    QuestReward = T.RT_17,
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_13
  },
  [11100112] = {
    EventId = 111001,
    QuestId = 11100112,
    QuestPhaseId = 2001,
    QuestReward = T.RT_18,
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_13
  },
  [11100113] = {
    EventId = 111002,
    QuestId = 11100113,
    QuestPhaseId = 2004,
    QuestReward = T.RT_5,
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_19
  },
  [11100114] = {
    EventId = 111002,
    QuestId = 11100114,
    QuestPhaseId = 2004,
    QuestReward = T.RT_7,
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_19
  },
  [11100115] = {
    EventId = 111002,
    QuestId = 11100115,
    QuestPhaseId = 2004,
    QuestReward = T.RT_8,
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_19
  },
  [11100116] = {
    EventId = 111002,
    QuestId = 11100116,
    QuestPhaseId = 2004,
    QuestReward = T.RT_9,
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_19
  },
  [11100117] = {
    EventId = 111002,
    QuestId = 11100117,
    QuestPhaseId = 2004,
    QuestReward = T.RT_10,
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_19
  },
  [11100118] = {
    EventId = 111002,
    QuestId = 11100118,
    QuestPhaseId = 2004,
    QuestReward = T.RT_11,
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_19
  },
  [11100119] = {
    EventId = 111002,
    QuestId = 11100119,
    QuestPhaseId = 2003,
    QuestReward = T.RT_12,
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_20
  },
  [11100120] = {
    EventId = 111002,
    QuestId = 11100120,
    QuestPhaseId = 2003,
    QuestReward = T.RT_14,
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_20
  },
  [11100121] = {
    EventId = 111002,
    QuestId = 11100121,
    QuestPhaseId = 2003,
    QuestReward = T.RT_15,
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_20
  },
  [11100122] = {
    EventId = 111002,
    QuestId = 11100122,
    QuestPhaseId = 2003,
    QuestReward = T.RT_16,
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_20
  },
  [11100123] = {
    EventId = 111002,
    QuestId = 11100123,
    QuestPhaseId = 2003,
    QuestReward = T.RT_17,
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_20
  },
  [11100124] = {
    EventId = 111002,
    QuestId = 11100124,
    QuestPhaseId = 2003,
    QuestReward = T.RT_18,
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_20
  },
  [11200101] = {
    EventId = 112001,
    QuestId = 11200101,
    QuestPhaseId = 1201,
    QuestReward = {11200101},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 10,
    TargetId = T.RT_21
  },
  [11200102] = {
    EventId = 112001,
    QuestId = 11200102,
    QuestPhaseId = 1201,
    QuestReward = {11200102},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 20,
    TargetId = T.RT_21
  },
  [11200103] = {
    EventId = 112001,
    QuestId = 11200103,
    QuestPhaseId = 1201,
    QuestReward = {11200103},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 30,
    TargetId = T.RT_21
  },
  [11200104] = {
    EventId = 112001,
    QuestId = 11200104,
    QuestPhaseId = 1201,
    QuestReward = {11200104},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 60,
    TargetId = T.RT_21
  },
  [11200105] = {
    EventId = 112001,
    QuestId = 11200105,
    QuestPhaseId = 1201,
    QuestReward = {11200105},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 70,
    TargetId = T.RT_21
  },
  [11200106] = {
    EventId = 112001,
    QuestId = 11200106,
    QuestPhaseId = 1201,
    QuestReward = {11200106},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 80,
    TargetId = T.RT_21
  },
  [11200107] = {
    EventId = 112001,
    QuestId = 11200107,
    QuestPhaseId = 1201,
    QuestReward = {11200107},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 90,
    TargetId = T.RT_21
  },
  [11200108] = {
    EventId = 112001,
    QuestId = 11200108,
    QuestPhaseId = 1201,
    QuestReward = {11200108},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 120,
    TargetId = T.RT_21
  },
  [11200109] = {
    EventId = 112001,
    QuestId = 11200109,
    QuestPhaseId = 1201,
    QuestReward = {11200109},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 130,
    TargetId = T.RT_21
  },
  [11200110] = {
    EventId = 112001,
    QuestId = 11200110,
    QuestPhaseId = 1201,
    QuestReward = {11200110},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 140,
    TargetId = T.RT_21
  },
  [11200111] = {
    EventId = 112001,
    QuestId = 11200111,
    QuestPhaseId = 1201,
    QuestReward = {11200111},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 150,
    TargetId = T.RT_21
  },
  [11200112] = {
    EventId = 112001,
    QuestId = 11200112,
    QuestPhaseId = 1201,
    QuestReward = {11200112},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 180,
    TargetId = T.RT_21
  },
  [11400101] = {
    EventId = 114001,
    QuestId = 11400101,
    QuestPhaseId = 1401,
    QuestReward = {11400101},
    StarterQuestDes = "Event_TargetDes_11400101",
    Target = 1,
    TargetId = T.RT_22
  },
  [11400102] = {
    EventId = 114001,
    JumpUIId = 19,
    QuestId = 11400102,
    QuestPhaseId = 1401,
    QuestReward = {11400102},
    StarterQuestDes = "Event_TargetDes_11400102",
    Target = 5,
    TargetId = T.RT_23
  },
  [11400103] = {
    EventId = 114001,
    JumpUIId = 21,
    QuestId = 11400103,
    QuestPhaseId = 1401,
    QuestReward = {11400103},
    StarterQuestDes = "Event_TargetDes_11400103",
    Target = 3,
    TargetId = T.RT_24
  },
  [11400104] = {
    EventId = 114001,
    JumpUIId = 20,
    QuestId = 11400104,
    QuestPhaseId = 1401,
    QuestReward = {11400104},
    StarterQuestDes = "Event_TargetDes_11400104",
    Target = 3,
    TargetId = T.RT_25
  },
  [11400105] = {
    EventId = 114001,
    JumpUIId = 22,
    QuestId = 11400105,
    QuestPhaseId = 1401,
    QuestReward = {11400105},
    StarterQuestDes = "Event_TargetDes_11400105",
    Target = 1,
    TargetId = T.RT_26
  },
  [11400106] = {
    EventId = 114001,
    JumpUIId = 30,
    QuestId = 11400106,
    QuestPhaseId = 1401,
    QuestReward = {11400106},
    StarterQuestDes = "Event_TargetDes_11400106",
    Target = 1,
    TargetId = {90105}
  },
  [11400107] = {
    EventId = 114001,
    QuestId = 11400107,
    QuestPhaseId = 1402,
    QuestReward = {11400107},
    StarterQuestDes = "Event_TargetDes_11400107",
    Target = 2,
    TargetId = T.RT_22
  },
  [11400108] = {
    EventId = 114001,
    JumpUIId = 19,
    QuestId = 11400108,
    QuestPhaseId = 1402,
    QuestReward = {11400108},
    StarterQuestDes = "Event_TargetDes_11400108",
    Target = 10,
    TargetId = T.RT_23
  },
  [11400109] = {
    EventId = 114001,
    JumpUIId = 21,
    QuestId = 11400109,
    QuestPhaseId = 1402,
    QuestReward = {11400109},
    StarterQuestDes = "Event_TargetDes_11400109",
    Target = 6,
    TargetId = T.RT_24
  },
  [11400110] = {
    EventId = 114001,
    JumpUIId = 20,
    QuestId = 11400110,
    QuestPhaseId = 1402,
    QuestReward = {11400110},
    StarterQuestDes = "Event_TargetDes_11400110",
    Target = 6,
    TargetId = T.RT_25
  },
  [11400111] = {
    EventId = 114001,
    JumpUIId = 22,
    QuestId = 11400111,
    QuestPhaseId = 1402,
    QuestReward = {11400111},
    StarterQuestDes = "Event_TargetDes_11400111",
    Target = 2,
    TargetId = T.RT_26
  },
  [11400112] = {
    EventId = 114001,
    JumpUIId = 13,
    QuestId = 11400112,
    QuestPhaseId = 1402,
    QuestReward = {11400112},
    StarterQuestDes = "Event_TargetDes_11400112",
    Target = 1,
    TargetId = {9000}
  },
  [11400113] = {
    EventId = 114001,
    QuestId = 11400113,
    QuestPhaseId = 1403,
    QuestReward = {11400113},
    StarterQuestDes = "Event_TargetDes_11400113",
    Target = 3,
    TargetId = T.RT_22
  },
  [11400114] = {
    EventId = 114001,
    JumpUIId = 19,
    QuestId = 11400114,
    QuestPhaseId = 1403,
    QuestReward = {11400114},
    StarterQuestDes = "Event_TargetDes_11400114",
    Target = 15,
    TargetId = T.RT_23
  },
  [11400115] = {
    EventId = 114001,
    JumpUIId = 21,
    QuestId = 11400115,
    QuestPhaseId = 1403,
    QuestReward = {11400115},
    StarterQuestDes = "Event_TargetDes_11400115",
    Target = 12,
    TargetId = T.RT_24
  },
  [11400116] = {
    EventId = 114001,
    JumpUIId = 20,
    QuestId = 11400116,
    QuestPhaseId = 1403,
    QuestReward = {11400116},
    StarterQuestDes = "Event_TargetDes_11400116",
    Target = 12,
    TargetId = T.RT_25
  },
  [11400117] = {
    EventId = 114001,
    JumpUIId = 22,
    QuestId = 11400117,
    QuestPhaseId = 1403,
    QuestReward = {11400117},
    StarterQuestDes = "Event_TargetDes_11400117",
    Target = 3,
    TargetId = T.RT_26
  },
  [11400118] = {
    EventId = 114001,
    JumpUIId = 65,
    QuestId = 11400118,
    QuestPhaseId = 1403,
    QuestReward = {11400118},
    StarterQuestDes = "Event_TargetDes_11400118",
    Target = 1,
    TargetId = {50932}
  }
})
