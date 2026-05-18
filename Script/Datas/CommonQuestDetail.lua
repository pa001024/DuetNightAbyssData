local T = {}
T.RT_1 = {10200201}
T.RT_2 = {10200202}
T.RT_3 = {10200203}
T.RT_4 = {10200204}
T.RT_5 = {10200205}
T.RT_6 = {102001201}
T.RT_7 = {102001202}
T.RT_8 = {102001203}
T.RT_9 = {102001204}
T.RT_10 = {102001205}
T.RT_11 = {102001206}
T.RT_12 = {102001211}
T.RT_13 = {102001212}
T.RT_14 = {102001213}
T.RT_15 = {102001214}
T.RT_16 = {102001216}
T.RT_17 = {1030909}
T.RT_18 = {1030910}
T.RT_19 = {1030915}
T.RT_20 = {1030916}
T.RT_21 = {103003123}
T.RT_22 = {
  [2] = 1000
}
T.RT_23 = {1080201}
T.RT_24 = {
  [3] = 1000
}
T.RT_25 = {103003133}
T.RT_26 = {103003131}
T.RT_27 = {2300101}
T.RT_28 = {103003132}
T.RT_29 = {30101}
T.RT_30 = {1900101}
T.RT_31 = {10301401}
T.RT_32 = {10301402}
T.RT_33 = {10301403}
T.RT_34 = {10301404}
T.RT_35 = {10301405}
T.RT_36 = {10301406}
T.RT_37 = {10301407}
T.RT_38 = {10301411}
T.RT_39 = {10301414}
T.RT_40 = {10301415}
T.RT_41 = {10301416}
T.RT_42 = {
  131059,
  131060,
  131061,
  131062,
  131063,
  131064,
  131065,
  131066,
  131072,
  131074,
  131075,
  131076,
  131077,
  131078,
  131079,
  131080,
  131081,
  131084,
  131085,
  131086,
  131087
}
T.RT_43 = {10301424}
T.RT_44 = {10301425}
T.RT_45 = {10301426}
T.RT_46 = {10301431}
T.RT_47 = {10301432}
T.RT_48 = {10301433}
T.RT_49 = {10301434}
T.RT_50 = {10301435}
T.RT_51 = {300303}
T.RT_52 = {50939}
T.RT_53 = {300304}
T.RT_54 = {300305}
T.RT_55 = {300306}
T.RT_56 = {300307}
T.RT_57 = {300308}
T.RT_58 = {300309}
T.RT_59 = {50940}
T.RT_60 = {300310}
T.RT_61 = {300311}
T.RT_62 = {300312}
T.RT_63 = {300313}
T.RT_64 = {300314}
T.RT_65 = {50941}
T.RT_66 = {50942}
T.RT_67 = {50943}
T.RT_68 = {50944}
T.RT_69 = {50945}
T.RT_70 = {50946}
T.RT_71 = {11200101}
T.RT_72 = {11200102}
T.RT_73 = {11200103}
T.RT_74 = {11200104}
T.RT_75 = {11200105}
T.RT_76 = {11200106}
T.RT_77 = {11200107}
T.RT_78 = {11200108}
T.RT_79 = {11200109}
T.RT_80 = {11200110}
T.RT_81 = {11200111}
T.RT_82 = {11200112}
T.RT_83 = {1000501}
T.RT_84 = {50930}
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
    QuestReward = T.RT_1,
    StarterQuestDes = "Name_120101",
    Target = 1,
    TargetId = {10200101}
  },
  [10200102] = {
    EventId = 102001,
    QuestId = 10200102,
    QuestPhaseId = 1001,
    QuestReward = T.RT_2,
    StarterQuestDes = "Name_120102",
    Target = 1,
    TargetId = {10200102}
  },
  [10200103] = {
    EventId = 102001,
    QuestId = 10200103,
    QuestPhaseId = 1001,
    QuestReward = T.RT_3,
    StarterQuestDes = "Name_120103",
    Target = 1,
    TargetId = {10200103}
  },
  [10200104] = {
    EventId = 102001,
    QuestId = 10200104,
    QuestPhaseId = 1001,
    QuestReward = T.RT_4,
    StarterQuestDes = "Name_120104",
    Target = 1,
    TargetId = {10200104}
  },
  [10200105] = {
    EventId = 102001,
    QuestId = 10200105,
    QuestPhaseId = 1001,
    QuestReward = T.RT_5,
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
  [10200201] = {
    EventId = 102002,
    QuestId = 10200201,
    QuestPhaseId = 1020021,
    QuestReward = {102002001},
    StarterQuestDes = "CheZhanQuest_Des_10200201",
    Target = 1,
    TargetId = T.RT_1
  },
  [10200202] = {
    EventId = 102002,
    QuestId = 10200202,
    QuestPhaseId = 1020021,
    QuestReward = {102002002},
    StarterQuestDes = "CheZhanQuest_Des_10200202",
    Target = 1,
    TargetId = T.RT_2
  },
  [10200203] = {
    EventId = 102002,
    QuestId = 10200203,
    QuestPhaseId = 1020021,
    QuestReward = {102002003},
    StarterQuestDes = "CheZhanQuest_Des_10200203",
    Target = 1,
    TargetId = T.RT_3
  },
  [10200204] = {
    EventId = 102002,
    QuestId = 10200204,
    QuestPhaseId = 1020021,
    QuestReward = {102002004},
    StarterQuestDes = "CheZhanQuest_Des_10200204",
    Target = 1,
    TargetId = T.RT_4
  },
  [10200205] = {
    EventId = 102002,
    QuestId = 10200205,
    QuestPhaseId = 1020021,
    QuestReward = {102002005},
    StarterQuestDes = "CheZhanQuest_Des_10200205",
    Target = 1,
    TargetId = T.RT_5
  },
  [10200211] = {
    EventId = 102002,
    QuestId = 10200211,
    QuestPhaseId = 1020022,
    QuestReward = {102002101},
    StarterQuestDes = "CheZhanQuest_Des_10200211",
    Target = 8,
    TargetId = {
      501333,
      501334,
      501335,
      501336,
      501337
    }
  },
  [10200212] = {
    EventId = 102002,
    QuestId = 10200212,
    QuestPhaseId = 1020022,
    QuestReward = {102002102},
    StarterQuestDes = "CheZhanQuest_Des_10200212",
    Target = 5,
    TargetId = {101007}
  },
  [10200213] = {
    EventId = 102002,
    QuestId = 10200213,
    QuestPhaseId = 1020022,
    QuestReward = {102002103},
    StarterQuestDes = "CheZhanQuest_Des_10200213",
    Target = 4,
    TargetId = {10137}
  },
  [10200214] = {
    EventId = 102002,
    QuestId = 10200214,
    QuestPhaseId = 1020022,
    QuestReward = {102002104},
    StarterQuestDes = "CheZhanQuest_Des_10200214",
    Target = 5,
    TargetId = {505103}
  },
  [10200221] = {
    EventId = 102002,
    QuestId = 10200221,
    QuestPhaseId = 1020023,
    QuestReward = {102002201},
    StarterQuestDes = "CheZhanQuest_Des_10200221",
    Target = 1,
    TargetId = {10200221}
  },
  [10200222] = {
    EventId = 102002,
    QuestId = 10200222,
    QuestPhaseId = 1020023,
    QuestReward = {102002202},
    StarterQuestDes = "CheZhanQuest_Des_10200222",
    Target = 1,
    TargetId = {10200222}
  },
  [10200223] = {
    EventId = 102002,
    QuestId = 10200223,
    QuestPhaseId = 1020023,
    QuestReward = {102002203},
    StarterQuestDes = "CheZhanQuest_Des_10200223",
    Target = 1,
    TargetId = {10200223}
  },
  [10300000] = {
    EventId = 103016,
    QuestId = 10300000,
    QuestPhaseId = 3001,
    QuestReward = {302060},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_0",
    Target = 1,
    TargetId = T.RT_17
  },
  [10300001] = {
    EventId = 103016,
    QuestId = 10300001,
    QuestPhaseId = 3001,
    QuestReward = {302036},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_1",
    Target = 5,
    TargetId = T.RT_17
  },
  [10300002] = {
    EventId = 103016,
    QuestId = 10300002,
    QuestPhaseId = 3001,
    QuestReward = {302037},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_2",
    Target = 10,
    TargetId = T.RT_17
  },
  [10300003] = {
    EventId = 103016,
    QuestId = 10300003,
    QuestPhaseId = 3001,
    QuestReward = {302038},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_3",
    Target = 100,
    TargetId = T.RT_18
  },
  [10300004] = {
    EventId = 103016,
    QuestId = 10300004,
    QuestPhaseId = 3001,
    QuestReward = {302039},
    QuestType = 2,
    StarterQuestDes = "AutoChess_Quest_1_4",
    Target = 200,
    TargetId = T.RT_18
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
    TargetId = T.RT_17
  },
  [10300202] = {
    EventId = 103016,
    QuestId = 10300202,
    QuestPhaseId = 3004,
    QuestReward = {302025},
    StarterQuestDes = "AutoChess_Quest_3_2",
    Target = 50,
    TargetId = T.RT_17
  },
  [10300203] = {
    EventId = 103016,
    QuestId = 10300203,
    QuestPhaseId = 3004,
    QuestReward = {302026},
    StarterQuestDes = "AutoChess_Quest_3_3",
    Target = 500,
    TargetId = T.RT_18
  },
  [10300204] = {
    EventId = 103016,
    QuestId = 10300204,
    QuestPhaseId = 3004,
    QuestReward = {302027},
    StarterQuestDes = "AutoChess_Quest_3_4",
    Target = 1000,
    TargetId = T.RT_18
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
    TargetId = T.RT_19
  },
  [10300213] = {
    EventId = 103016,
    QuestId = 10300213,
    QuestPhaseId = 3004,
    QuestReward = {302031},
    StarterQuestDes = "AutoChess_Quest_3_13",
    Target = 20,
    TargetId = T.RT_19
  },
  [10300214] = {
    EventId = 103016,
    QuestId = 10300214,
    QuestPhaseId = 3004,
    QuestReward = {302032},
    StarterQuestDes = "AutoChess_Quest_3_10",
    Target = 28,
    TargetId = T.RT_19
  },
  [10300215] = {
    EventId = 103016,
    QuestId = 10300215,
    QuestPhaseId = 3004,
    QuestReward = {302033},
    StarterQuestDes = "AutoChess_Quest_3_11",
    Target = 5,
    TargetId = T.RT_20
  },
  [10300216] = {
    EventId = 103016,
    QuestId = 10300216,
    QuestPhaseId = 3004,
    QuestReward = {302034},
    StarterQuestDes = "AutoChess_Quest_3_14",
    Target = 10,
    TargetId = T.RT_20
  },
  [10300217] = {
    EventId = 103016,
    QuestId = 10300217,
    QuestPhaseId = 3004,
    QuestReward = {302035},
    StarterQuestDes = "AutoChess_Quest_3_12",
    Target = 15,
    TargetId = T.RT_20
  },
  [10301401] = {
    EventId = 103014,
    QuestId = 10301401,
    QuestPhaseId = 1301,
    QuestReward = T.RT_31,
    StarterQuestDes = "Event_TargetDes_10301401",
    Target = 1,
    TargetId = T.RT_31
  },
  [10301402] = {
    EventId = 103014,
    QuestId = 10301402,
    QuestPhaseId = 1301,
    QuestReward = T.RT_32,
    StarterQuestDes = "Event_TargetDes_10301402",
    Target = 1,
    TargetId = T.RT_32
  },
  [10301403] = {
    EventId = 103014,
    QuestId = 10301403,
    QuestPhaseId = 1301,
    QuestReward = T.RT_33,
    StarterQuestDes = "Event_TargetDes_10301403",
    Target = 1,
    TargetId = T.RT_33
  },
  [10301404] = {
    EventId = 103014,
    QuestId = 10301404,
    QuestPhaseId = 1301,
    QuestReward = T.RT_34,
    StarterQuestDes = "Event_TargetDes_10301404",
    Target = 1,
    TargetId = T.RT_34
  },
  [10301405] = {
    EventId = 103014,
    QuestId = 10301405,
    QuestPhaseId = 1301,
    QuestReward = T.RT_35,
    StarterQuestDes = "Event_TargetDes_10301405",
    Target = 1,
    TargetId = T.RT_35
  },
  [10301406] = {
    EventId = 103014,
    QuestId = 10301406,
    QuestPhaseId = 1301,
    QuestReward = T.RT_36,
    StarterQuestDes = "Event_TargetDes_10301406",
    Target = 1,
    TargetId = T.RT_36
  },
  [10301407] = {
    EventId = 103014,
    QuestId = 10301407,
    QuestPhaseId = 1301,
    QuestReward = T.RT_37,
    StarterQuestDes = "Event_TargetDes_10301407",
    Target = 1,
    TargetId = T.RT_37
  },
  [10301411] = {
    EventId = 103014,
    QuestId = 10301411,
    QuestPhaseId = 1302,
    QuestReward = T.RT_38,
    StarterQuestDes = "Event_TargetDes_10301411",
    Target = 10000,
    TargetId = T.RT_38
  },
  [10301412] = {
    EventId = 103014,
    QuestId = 10301412,
    QuestPhaseId = 1302,
    QuestReward = {10301412},
    StarterQuestDes = "Event_TargetDes_10301412",
    Target = 50000,
    TargetId = T.RT_38
  },
  [10301413] = {
    EventId = 103014,
    QuestId = 10301413,
    QuestPhaseId = 1302,
    QuestReward = {10301413},
    StarterQuestDes = "Event_TargetDes_10301413",
    Target = 200000,
    TargetId = T.RT_38
  },
  [10301414] = {
    EventId = 103014,
    QuestId = 10301414,
    QuestPhaseId = 1302,
    QuestReward = T.RT_39,
    StarterQuestDes = "Event_TargetDes_10301414",
    Target = 1,
    TargetId = T.RT_39
  },
  [10301415] = {
    EventId = 103014,
    QuestId = 10301415,
    QuestPhaseId = 1302,
    QuestReward = T.RT_40,
    StarterQuestDes = "Event_TargetDes_10301415",
    Target = 1,
    TargetId = T.RT_40
  },
  [10301416] = {
    EventId = 103014,
    QuestId = 10301416,
    QuestPhaseId = 1302,
    QuestReward = T.RT_41,
    StarterQuestDes = "Event_TargetDes_10301416",
    Target = 1,
    TargetId = T.RT_41
  },
  [10301421] = {
    EventId = 103014,
    QuestId = 10301421,
    QuestPhaseId = 1303,
    QuestReward = {10301421},
    StarterQuestDes = "Event_TargetDes_10301421",
    Target = 10,
    TargetId = T.RT_42
  },
  [10301422] = {
    EventId = 103014,
    QuestId = 10301422,
    QuestPhaseId = 1303,
    QuestReward = {10301422},
    StarterQuestDes = "Event_TargetDes_10301422",
    Target = 50,
    TargetId = T.RT_42
  },
  [10301423] = {
    EventId = 103014,
    QuestId = 10301423,
    QuestPhaseId = 1303,
    QuestReward = {10301423},
    StarterQuestDes = "Event_TargetDes_10301423",
    Target = 100,
    TargetId = T.RT_42
  },
  [10301424] = {
    EventId = 103014,
    QuestId = 10301424,
    QuestPhaseId = 1303,
    QuestReward = T.RT_43,
    StarterQuestDes = "Event_TargetDes_10301424",
    Target = 10,
    TargetId = T.RT_43
  },
  [10301425] = {
    EventId = 103014,
    QuestId = 10301425,
    QuestPhaseId = 1303,
    QuestReward = T.RT_44,
    StarterQuestDes = "Event_TargetDes_10301425",
    Target = 10,
    TargetId = T.RT_44
  },
  [10301426] = {
    EventId = 103014,
    QuestId = 10301426,
    QuestPhaseId = 1303,
    QuestReward = T.RT_45,
    StarterQuestDes = "Event_TargetDes_10301426",
    Target = 5,
    TargetId = T.RT_45
  },
  [10301427] = {
    EventId = 103014,
    QuestId = 10301427,
    QuestPhaseId = 1303,
    QuestReward = {10301427},
    StarterQuestDes = "Event_TargetDes_10301427",
    Target = 10,
    TargetId = T.RT_45
  },
  [10301428] = {
    EventId = 103014,
    QuestId = 10301428,
    QuestPhaseId = 1303,
    QuestReward = {10301428},
    StarterQuestDes = "Event_TargetDes_10301428",
    Target = 15,
    TargetId = T.RT_45
  },
  [10301431] = {
    EventId = 103014,
    QuestId = 10301431,
    QuestPhaseId = 1304,
    QuestReward = T.RT_46,
    StarterQuestDes = "Event_TargetDes_10301431",
    Target = 1,
    TargetId = T.RT_46
  },
  [10301432] = {
    EventId = 103014,
    QuestId = 10301432,
    QuestPhaseId = 1304,
    QuestReward = T.RT_47,
    StarterQuestDes = "Event_TargetDes_10301432",
    Target = 1,
    TargetId = T.RT_47
  },
  [10301433] = {
    EventId = 103014,
    QuestId = 10301433,
    QuestPhaseId = 1304,
    QuestReward = T.RT_48,
    StarterQuestDes = "Event_TargetDes_10301433",
    Target = 1,
    TargetId = T.RT_48
  },
  [10301434] = {
    EventId = 103014,
    QuestId = 10301434,
    QuestPhaseId = 1304,
    QuestReward = T.RT_49,
    StarterQuestDes = "Event_TargetDes_10301434",
    Target = 1,
    TargetId = T.RT_49
  },
  [10301435] = {
    EventId = 103014,
    QuestId = 10301435,
    QuestPhaseId = 1304,
    QuestReward = T.RT_50,
    StarterQuestDes = "Event_TargetDes_10301435",
    Target = 1,
    TargetId = T.RT_50
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
    NoRepeatField = "AFdayTransferId",
    QuestId = 10301805,
    QuestPhaseId = 3003,
    QuestReward = {110905},
    StarterQuestDes = "Event_10301801_Title05",
    Target = 5,
    TargetId = {10301805}
  },
  [10301806] = {
    EventId = 103018,
    NoRepeatField = "AFdayTransferId",
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
    QuestReward = T.RT_51,
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_52
  },
  [11100102] = {
    EventId = 111001,
    QuestId = 11100102,
    QuestPhaseId = 2002,
    QuestReward = T.RT_53,
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_52
  },
  [11100103] = {
    EventId = 111001,
    QuestId = 11100103,
    QuestPhaseId = 2002,
    QuestReward = T.RT_54,
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_52
  },
  [11100104] = {
    EventId = 111001,
    QuestId = 11100104,
    QuestPhaseId = 2002,
    QuestReward = T.RT_55,
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_52
  },
  [11100105] = {
    EventId = 111001,
    QuestId = 11100105,
    QuestPhaseId = 2002,
    QuestReward = T.RT_56,
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_52
  },
  [11100106] = {
    EventId = 111001,
    QuestId = 11100106,
    QuestPhaseId = 2002,
    QuestReward = T.RT_57,
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_52
  },
  [11100107] = {
    EventId = 111001,
    QuestId = 11100107,
    QuestPhaseId = 2001,
    QuestReward = T.RT_58,
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_59
  },
  [11100108] = {
    EventId = 111001,
    QuestId = 11100108,
    QuestPhaseId = 2001,
    QuestReward = T.RT_60,
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_59
  },
  [11100109] = {
    EventId = 111001,
    QuestId = 11100109,
    QuestPhaseId = 2001,
    QuestReward = T.RT_61,
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_59
  },
  [11100110] = {
    EventId = 111001,
    QuestId = 11100110,
    QuestPhaseId = 2001,
    QuestReward = T.RT_62,
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_59
  },
  [11100111] = {
    EventId = 111001,
    QuestId = 11100111,
    QuestPhaseId = 2001,
    QuestReward = T.RT_63,
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_59
  },
  [11100112] = {
    EventId = 111001,
    QuestId = 11100112,
    QuestPhaseId = 2001,
    QuestReward = T.RT_64,
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_59
  },
  [11100113] = {
    EventId = 111002,
    QuestId = 11100113,
    QuestPhaseId = 2004,
    QuestReward = T.RT_51,
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_65
  },
  [11100114] = {
    EventId = 111002,
    QuestId = 11100114,
    QuestPhaseId = 2004,
    QuestReward = T.RT_53,
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_65
  },
  [11100115] = {
    EventId = 111002,
    QuestId = 11100115,
    QuestPhaseId = 2004,
    QuestReward = T.RT_54,
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_65
  },
  [11100116] = {
    EventId = 111002,
    QuestId = 11100116,
    QuestPhaseId = 2004,
    QuestReward = T.RT_55,
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_65
  },
  [11100117] = {
    EventId = 111002,
    QuestId = 11100117,
    QuestPhaseId = 2004,
    QuestReward = T.RT_56,
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_65
  },
  [11100118] = {
    EventId = 111002,
    QuestId = 11100118,
    QuestPhaseId = 2004,
    QuestReward = T.RT_57,
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_65
  },
  [11100119] = {
    EventId = 111002,
    QuestId = 11100119,
    QuestPhaseId = 2003,
    QuestReward = T.RT_58,
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_66
  },
  [11100120] = {
    EventId = 111002,
    QuestId = 11100120,
    QuestPhaseId = 2003,
    QuestReward = T.RT_60,
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_66
  },
  [11100121] = {
    EventId = 111002,
    QuestId = 11100121,
    QuestPhaseId = 2003,
    QuestReward = T.RT_61,
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_66
  },
  [11100122] = {
    EventId = 111002,
    QuestId = 11100122,
    QuestPhaseId = 2003,
    QuestReward = T.RT_62,
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_66
  },
  [11100123] = {
    EventId = 111002,
    QuestId = 11100123,
    QuestPhaseId = 2003,
    QuestReward = T.RT_63,
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_66
  },
  [11100124] = {
    EventId = 111002,
    QuestId = 11100124,
    QuestPhaseId = 2003,
    QuestReward = T.RT_64,
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_66
  },
  [11100125] = {
    EventId = 111003,
    QuestId = 11100125,
    QuestPhaseId = 2006,
    QuestReward = T.RT_51,
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_67
  },
  [11100126] = {
    EventId = 111003,
    QuestId = 11100126,
    QuestPhaseId = 2006,
    QuestReward = T.RT_53,
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_67
  },
  [11100127] = {
    EventId = 111003,
    QuestId = 11100127,
    QuestPhaseId = 2006,
    QuestReward = T.RT_54,
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_67
  },
  [11100128] = {
    EventId = 111003,
    QuestId = 11100128,
    QuestPhaseId = 2006,
    QuestReward = T.RT_55,
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_67
  },
  [11100129] = {
    EventId = 111003,
    QuestId = 11100129,
    QuestPhaseId = 2006,
    QuestReward = T.RT_56,
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_67
  },
  [11100130] = {
    EventId = 111003,
    QuestId = 11100130,
    QuestPhaseId = 2006,
    QuestReward = T.RT_57,
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_67
  },
  [11100131] = {
    EventId = 111003,
    QuestId = 11100131,
    QuestPhaseId = 2005,
    QuestReward = T.RT_58,
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_68
  },
  [11100132] = {
    EventId = 111003,
    QuestId = 11100132,
    QuestPhaseId = 2005,
    QuestReward = T.RT_60,
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_68
  },
  [11100133] = {
    EventId = 111003,
    QuestId = 11100133,
    QuestPhaseId = 2005,
    QuestReward = T.RT_61,
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_68
  },
  [11100134] = {
    EventId = 111003,
    QuestId = 11100134,
    QuestPhaseId = 2005,
    QuestReward = T.RT_62,
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_68
  },
  [11100135] = {
    EventId = 111003,
    QuestId = 11100135,
    QuestPhaseId = 2005,
    QuestReward = T.RT_63,
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_68
  },
  [11100136] = {
    EventId = 111003,
    QuestId = 11100136,
    QuestPhaseId = 2005,
    QuestReward = T.RT_64,
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_68
  },
  [11100137] = {
    EventId = 111004,
    QuestId = 11100137,
    QuestPhaseId = 2008,
    QuestReward = T.RT_51,
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_69
  },
  [11100138] = {
    EventId = 111004,
    QuestId = 11100138,
    QuestPhaseId = 2008,
    QuestReward = T.RT_53,
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_69
  },
  [11100139] = {
    EventId = 111004,
    QuestId = 11100139,
    QuestPhaseId = 2008,
    QuestReward = T.RT_54,
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_69
  },
  [11100140] = {
    EventId = 111004,
    QuestId = 11100140,
    QuestPhaseId = 2008,
    QuestReward = T.RT_55,
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_69
  },
  [11100141] = {
    EventId = 111004,
    QuestId = 11100141,
    QuestPhaseId = 2008,
    QuestReward = T.RT_56,
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_69
  },
  [11100142] = {
    EventId = 111004,
    QuestId = 11100142,
    QuestPhaseId = 2008,
    QuestReward = T.RT_57,
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_69
  },
  [11100143] = {
    EventId = 111004,
    QuestId = 11100143,
    QuestPhaseId = 2007,
    QuestReward = T.RT_58,
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_70
  },
  [11100144] = {
    EventId = 111004,
    QuestId = 11100144,
    QuestPhaseId = 2007,
    QuestReward = T.RT_60,
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_70
  },
  [11100145] = {
    EventId = 111004,
    QuestId = 11100145,
    QuestPhaseId = 2007,
    QuestReward = T.RT_61,
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_70
  },
  [11100146] = {
    EventId = 111004,
    QuestId = 11100146,
    QuestPhaseId = 2007,
    QuestReward = T.RT_62,
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_70
  },
  [11100147] = {
    EventId = 111004,
    QuestId = 11100147,
    QuestPhaseId = 2007,
    QuestReward = T.RT_63,
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_70
  },
  [11100148] = {
    EventId = 111004,
    QuestId = 11100148,
    QuestPhaseId = 2007,
    QuestReward = T.RT_64,
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_70
  },
  [11200101] = {
    EventId = 112001,
    QuestId = 11200101,
    QuestPhaseId = 1201,
    QuestReward = T.RT_71,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 10,
    TargetId = T.RT_23
  },
  [11200102] = {
    EventId = 112001,
    QuestId = 11200102,
    QuestPhaseId = 1201,
    QuestReward = T.RT_72,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 20,
    TargetId = T.RT_23
  },
  [11200103] = {
    EventId = 112001,
    QuestId = 11200103,
    QuestPhaseId = 1201,
    QuestReward = T.RT_73,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 30,
    TargetId = T.RT_23
  },
  [11200104] = {
    EventId = 112001,
    QuestId = 11200104,
    QuestPhaseId = 1201,
    QuestReward = T.RT_74,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 60,
    TargetId = T.RT_23
  },
  [11200105] = {
    EventId = 112001,
    QuestId = 11200105,
    QuestPhaseId = 1201,
    QuestReward = T.RT_75,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 70,
    TargetId = T.RT_23
  },
  [11200106] = {
    EventId = 112001,
    QuestId = 11200106,
    QuestPhaseId = 1201,
    QuestReward = T.RT_76,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 80,
    TargetId = T.RT_23
  },
  [11200107] = {
    EventId = 112001,
    QuestId = 11200107,
    QuestPhaseId = 1201,
    QuestReward = T.RT_77,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 90,
    TargetId = T.RT_23
  },
  [11200108] = {
    EventId = 112001,
    QuestId = 11200108,
    QuestPhaseId = 1201,
    QuestReward = T.RT_78,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 120,
    TargetId = T.RT_23
  },
  [11200109] = {
    EventId = 112001,
    QuestId = 11200109,
    QuestPhaseId = 1201,
    QuestReward = T.RT_79,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 130,
    TargetId = T.RT_23
  },
  [11200110] = {
    EventId = 112001,
    QuestId = 11200110,
    QuestPhaseId = 1201,
    QuestReward = T.RT_80,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 140,
    TargetId = T.RT_23
  },
  [11200111] = {
    EventId = 112001,
    QuestId = 11200111,
    QuestPhaseId = 1201,
    QuestReward = T.RT_81,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 150,
    TargetId = T.RT_23
  },
  [11200112] = {
    EventId = 112001,
    QuestId = 11200112,
    QuestPhaseId = 1201,
    QuestReward = T.RT_82,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 180,
    TargetId = T.RT_23
  },
  [11200201] = {
    EventId = 112002,
    QuestId = 11200201,
    QuestPhaseId = 1202,
    QuestReward = T.RT_71,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 10,
    TargetId = T.RT_23
  },
  [11200202] = {
    EventId = 112002,
    QuestId = 11200202,
    QuestPhaseId = 1202,
    QuestReward = T.RT_72,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 20,
    TargetId = T.RT_23
  },
  [11200203] = {
    EventId = 112002,
    QuestId = 11200203,
    QuestPhaseId = 1202,
    QuestReward = T.RT_73,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 30,
    TargetId = T.RT_23
  },
  [11200204] = {
    EventId = 112002,
    QuestId = 11200204,
    QuestPhaseId = 1202,
    QuestReward = T.RT_74,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 60,
    TargetId = T.RT_23
  },
  [11200205] = {
    EventId = 112002,
    QuestId = 11200205,
    QuestPhaseId = 1202,
    QuestReward = T.RT_75,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 70,
    TargetId = T.RT_23
  },
  [11200206] = {
    EventId = 112002,
    QuestId = 11200206,
    QuestPhaseId = 1202,
    QuestReward = T.RT_76,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 80,
    TargetId = T.RT_23
  },
  [11200207] = {
    EventId = 112002,
    QuestId = 11200207,
    QuestPhaseId = 1202,
    QuestReward = T.RT_77,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 90,
    TargetId = T.RT_23
  },
  [11200208] = {
    EventId = 112002,
    QuestId = 11200208,
    QuestPhaseId = 1202,
    QuestReward = T.RT_78,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 120,
    TargetId = T.RT_23
  },
  [11200209] = {
    EventId = 112002,
    QuestId = 11200209,
    QuestPhaseId = 1202,
    QuestReward = T.RT_79,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 130,
    TargetId = T.RT_23
  },
  [11200210] = {
    EventId = 112002,
    QuestId = 11200210,
    QuestPhaseId = 1202,
    QuestReward = T.RT_80,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 140,
    TargetId = T.RT_23
  },
  [11200211] = {
    EventId = 112002,
    QuestId = 11200211,
    QuestPhaseId = 1202,
    QuestReward = T.RT_81,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 150,
    TargetId = T.RT_23
  },
  [11200212] = {
    EventId = 112002,
    QuestId = 11200212,
    QuestPhaseId = 1202,
    QuestReward = T.RT_82,
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 180,
    TargetId = T.RT_23
  },
  [11200301] = {
    EventId = 112003,
    QuestId = 11200301,
    QuestPhaseId = 1203,
    QuestReward = {11200301},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 10,
    TargetId = T.RT_23
  },
  [11200302] = {
    EventId = 112003,
    QuestId = 11200302,
    QuestPhaseId = 1203,
    QuestReward = {11200302},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 20,
    TargetId = T.RT_23
  },
  [11200303] = {
    EventId = 112003,
    QuestId = 11200303,
    QuestPhaseId = 1203,
    QuestReward = {11200303},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 30,
    TargetId = T.RT_23
  },
  [11200304] = {
    EventId = 112003,
    QuestId = 11200304,
    QuestPhaseId = 1203,
    QuestReward = {11200304},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 60,
    TargetId = T.RT_23
  },
  [11200305] = {
    EventId = 112003,
    QuestId = 11200305,
    QuestPhaseId = 1203,
    QuestReward = {11200305},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 70,
    TargetId = T.RT_23
  },
  [11200306] = {
    EventId = 112003,
    QuestId = 11200306,
    QuestPhaseId = 1203,
    QuestReward = {11200306},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 80,
    TargetId = T.RT_23
  },
  [11200307] = {
    EventId = 112003,
    QuestId = 11200307,
    QuestPhaseId = 1203,
    QuestReward = {11200307},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 90,
    TargetId = T.RT_23
  },
  [11200308] = {
    EventId = 112003,
    QuestId = 11200308,
    QuestPhaseId = 1203,
    QuestReward = {11200308},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 120,
    TargetId = T.RT_23
  },
  [11200309] = {
    EventId = 112003,
    QuestId = 11200309,
    QuestPhaseId = 1203,
    QuestReward = {11200309},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 130,
    TargetId = T.RT_23
  },
  [11200310] = {
    EventId = 112003,
    QuestId = 11200310,
    QuestPhaseId = 1203,
    QuestReward = {11200310},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 140,
    TargetId = T.RT_23
  },
  [11200311] = {
    EventId = 112003,
    QuestId = 11200311,
    QuestPhaseId = 1203,
    QuestReward = {11200311},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 150,
    TargetId = T.RT_23
  },
  [11200312] = {
    EventId = 112003,
    QuestId = 11200312,
    QuestPhaseId = 1203,
    QuestReward = {11200312},
    StarterQuestDes = "Event_TargetDes_112001",
    Target = 180,
    TargetId = T.RT_23
  },
  [11400101] = {
    EventId = 114001,
    QuestId = 11400101,
    QuestPhaseId = 1401,
    QuestReward = {11400101},
    StarterQuestDes = "Event_TargetDes_11400101",
    Target = 1,
    TargetId = T.RT_83
  },
  [11400102] = {
    EventId = 114001,
    JumpUIId = 19,
    QuestId = 11400102,
    QuestPhaseId = 1401,
    QuestReward = {11400102},
    StarterQuestDes = "Event_TargetDes_11400102",
    Target = 5,
    TargetId = T.RT_84
  },
  [11400103] = {
    EventId = 114001,
    JumpUIId = 21,
    QuestId = 11400103,
    QuestPhaseId = 1401,
    QuestReward = {11400103},
    StarterQuestDes = "Event_TargetDes_11400103",
    Target = 3,
    TargetId = T.RT_30
  },
  [11400104] = {
    EventId = 114001,
    JumpUIId = 20,
    QuestId = 11400104,
    QuestPhaseId = 1401,
    QuestReward = {11400104},
    StarterQuestDes = "Event_TargetDes_11400104",
    Target = 3,
    TargetId = T.RT_29
  },
  [11400105] = {
    EventId = 114001,
    JumpUIId = 22,
    QuestId = 11400105,
    QuestPhaseId = 1401,
    QuestReward = {11400105},
    StarterQuestDes = "Event_TargetDes_11400105",
    Target = 1,
    TargetId = T.RT_27
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
    TargetId = T.RT_83
  },
  [11400108] = {
    EventId = 114001,
    JumpUIId = 19,
    QuestId = 11400108,
    QuestPhaseId = 1402,
    QuestReward = {11400108},
    StarterQuestDes = "Event_TargetDes_11400108",
    Target = 10,
    TargetId = T.RT_84
  },
  [11400109] = {
    EventId = 114001,
    JumpUIId = 21,
    QuestId = 11400109,
    QuestPhaseId = 1402,
    QuestReward = {11400109},
    StarterQuestDes = "Event_TargetDes_11400109",
    Target = 6,
    TargetId = T.RT_30
  },
  [11400110] = {
    EventId = 114001,
    JumpUIId = 20,
    QuestId = 11400110,
    QuestPhaseId = 1402,
    QuestReward = {11400110},
    StarterQuestDes = "Event_TargetDes_11400110",
    Target = 6,
    TargetId = T.RT_29
  },
  [11400111] = {
    EventId = 114001,
    JumpUIId = 22,
    QuestId = 11400111,
    QuestPhaseId = 1402,
    QuestReward = {11400111},
    StarterQuestDes = "Event_TargetDes_11400111",
    Target = 2,
    TargetId = T.RT_27
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
    TargetId = T.RT_83
  },
  [11400114] = {
    EventId = 114001,
    JumpUIId = 19,
    QuestId = 11400114,
    QuestPhaseId = 1403,
    QuestReward = {11400114},
    StarterQuestDes = "Event_TargetDes_11400114",
    Target = 15,
    TargetId = T.RT_84
  },
  [11400115] = {
    EventId = 114001,
    JumpUIId = 21,
    QuestId = 11400115,
    QuestPhaseId = 1403,
    QuestReward = {11400115},
    StarterQuestDes = "Event_TargetDes_11400115",
    Target = 12,
    TargetId = T.RT_30
  },
  [11400116] = {
    EventId = 114001,
    JumpUIId = 20,
    QuestId = 11400116,
    QuestPhaseId = 1403,
    QuestReward = {11400116},
    StarterQuestDes = "Event_TargetDes_11400116",
    Target = 12,
    TargetId = T.RT_29
  },
  [11400117] = {
    EventId = 114001,
    JumpUIId = 22,
    QuestId = 11400117,
    QuestPhaseId = 1403,
    QuestReward = {11400117},
    StarterQuestDes = "Event_TargetDes_11400117",
    Target = 3,
    TargetId = T.RT_27
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
  },
  [102001201] = {
    EventId = 1020012,
    QuestId = 102001201,
    QuestPhaseId = 1501,
    QuestReward = T.RT_6,
    StarterQuestDes = "Name_120201",
    Target = 1,
    TargetId = T.RT_6
  },
  [102001202] = {
    EventId = 1020012,
    QuestId = 102001202,
    QuestPhaseId = 1501,
    QuestReward = T.RT_7,
    StarterQuestDes = "Name_120202",
    Target = 1,
    TargetId = T.RT_7
  },
  [102001203] = {
    EventId = 1020012,
    QuestId = 102001203,
    QuestPhaseId = 1501,
    QuestReward = T.RT_8,
    StarterQuestDes = "Name_120203",
    Target = 1,
    TargetId = T.RT_8
  },
  [102001204] = {
    EventId = 1020012,
    QuestId = 102001204,
    QuestPhaseId = 1501,
    QuestReward = T.RT_9,
    StarterQuestDes = "Name_120204",
    Target = 1,
    TargetId = T.RT_9
  },
  [102001205] = {
    EventId = 1020012,
    QuestId = 102001205,
    QuestPhaseId = 1501,
    QuestReward = T.RT_10,
    StarterQuestDes = "Name_120205",
    Target = 1,
    TargetId = T.RT_10
  },
  [102001206] = {
    EventId = 1020012,
    QuestId = 102001206,
    QuestPhaseId = 1501,
    QuestReward = T.RT_11,
    StarterQuestDes = "Name_120206",
    Target = 1,
    TargetId = T.RT_11
  },
  [102001207] = {
    EventId = 1020012,
    QuestId = 102001207,
    QuestPhaseId = 1502,
    QuestReward = {102001207},
    StarterQuestDes = "HuaXu_Event_Des_102001207",
    Target = 2,
    TargetId = {505301}
  },
  [102001208] = {
    EventId = 1020012,
    QuestId = 102001208,
    QuestPhaseId = 1502,
    QuestReward = {102001208},
    StarterQuestDes = "HuaXu_Event_Des_102001208",
    Target = 2,
    TargetId = {505302}
  },
  [102001209] = {
    EventId = 1020012,
    QuestId = 102001209,
    QuestPhaseId = 1502,
    QuestReward = {102001209},
    StarterQuestDes = "HuaXu_Event_Des_102001209",
    Target = 2,
    TargetId = {505303}
  },
  [102001210] = {
    EventId = 1020012,
    QuestId = 102001210,
    QuestPhaseId = 1502,
    QuestReward = {102001210},
    StarterQuestDes = "HuaXu_Event_Des_102001210",
    Target = 5,
    TargetId = {505304}
  },
  [102001211] = {
    EventId = 1020012,
    QuestId = 102001211,
    QuestPhaseId = 1503,
    QuestReward = T.RT_12,
    StarterQuestDes = "HuaXu_Event_Des_102001211",
    Target = 1,
    TargetId = T.RT_12
  },
  [102001212] = {
    EventId = 1020012,
    QuestId = 102001212,
    QuestPhaseId = 1503,
    QuestReward = T.RT_13,
    StarterQuestDes = "HuaXu_Event_Des_102001212",
    Target = 1,
    TargetId = T.RT_13
  },
  [102001213] = {
    EventId = 1020012,
    QuestId = 102001213,
    QuestPhaseId = 1503,
    QuestReward = T.RT_14,
    StarterQuestDes = "HuaXu_Event_Des_102001213",
    Target = 1,
    TargetId = T.RT_14
  },
  [102001214] = {
    EventId = 1020012,
    QuestId = 102001214,
    QuestPhaseId = 1503,
    QuestReward = T.RT_15,
    StarterQuestDes = "HuaXu_Event_Des_102001214",
    Target = 1,
    TargetId = T.RT_15
  },
  [102001215] = {
    EventId = 1020012,
    QuestId = 102001215,
    QuestPhaseId = 1504,
    QuestReward = {102001215},
    StarterQuestDes = "HuaXu_Event_Des_102001215",
    Target = 5,
    TargetId = {520007}
  },
  [102001216] = {
    EventId = 1020012,
    QuestId = 102001216,
    QuestPhaseId = 1504,
    QuestReward = T.RT_16,
    StarterQuestDes = "HuaXu_Event_Des_102001216",
    Target = 20,
    TargetId = T.RT_16
  },
  [102001217] = {
    EventId = 1020012,
    QuestId = 102001217,
    QuestPhaseId = 1504,
    QuestReward = {102001217},
    StarterQuestDes = "HuaXu_Event_Des_102001217",
    Target = 5,
    TargetId = {101006}
  },
  [102001218] = {
    EventId = 1020012,
    QuestId = 102001218,
    QuestPhaseId = 1504,
    QuestReward = {102001218},
    StarterQuestDes = "HuaXu_Event_Des_102001218",
    Target = 5,
    TargetId = {10135}
  },
  [103003101] = {
    EventId = 1030031,
    QuestId = 103003101,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = {
      [1] = 1000
    },
    StarterQuestDes = "GuildTask_1",
    Target = 1,
    TargetId = {2220201}
  },
  [103003102] = {
    EventId = 1030031,
    QuestId = 103003102,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = T.RT_22,
    StarterQuestDes = "GuildTask_2",
    Target = 1,
    TargetId = {2220301}
  },
  [103003103] = {
    EventId = 1030031,
    JumpUIId = 70,
    QuestId = 103003103,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = T.RT_22,
    StarterQuestDes = "GuildTask_3",
    Target = 10,
    TargetId = T.RT_23
  },
  [103003104] = {
    EventId = 1030031,
    QuestId = 103003104,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = T.RT_24,
    StarterQuestDes = "GuildTask_4",
    Target = 1,
    TargetId = {2100101}
  },
  [103003105] = {
    EventId = 1030031,
    QuestId = 103003105,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = T.RT_24,
    StarterQuestDes = "GuildTask_5",
    Target = 3,
    TargetId = {1010501}
  },
  [103003106] = {
    EventId = 1030031,
    QuestId = 103003106,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = T.RT_24,
    StarterQuestDes = "GuildTask_6",
    Target = 1,
    TargetId = {10301}
  },
  [103003107] = {
    EventId = 1030031,
    QuestId = 103003107,
    QuestPhaseId = 4001,
    QuestReward = T.RT_21,
    QuestType = 2,
    RandomSlot = {
      [4] = 1000
    },
    StarterQuestDes = "GuildTask_7",
    Target = 1,
    TargetId = {2220501}
  },
  [103003121] = {
    EventId = 1030031,
    QuestId = 103003121,
    QuestPhaseId = 4001,
    QuestReward = T.RT_25,
    QuestType = 3,
    StarterQuestDes = "GuildTask_8",
    Target = 1,
    TargetId = {1000601}
  },
  [103003122] = {
    EventId = 1030031,
    QuestId = 103003122,
    QuestPhaseId = 4001,
    QuestReward = T.RT_26,
    QuestType = 3,
    StarterQuestDes = "GuildTask_9",
    Target = 1,
    TargetId = {2220101}
  },
  [103003123] = {
    EventId = 1030031,
    JumpUIId = 13,
    QuestId = 103003123,
    QuestPhaseId = 4001,
    QuestReward = T.RT_25,
    QuestType = 3,
    StarterQuestDes = "GuildTask_10",
    Target = 1,
    TargetId = {2300201}
  },
  [103003124] = {
    EventId = 1030031,
    JumpUIId = 22,
    QuestId = 103003124,
    QuestPhaseId = 4001,
    QuestReward = T.RT_25,
    QuestType = 3,
    StarterQuestDes = "GuildTask_11",
    Target = 5,
    TargetId = T.RT_27
  },
  [103003125] = {
    EventId = 1030031,
    JumpUIId = 65,
    QuestId = 103003125,
    QuestPhaseId = 4001,
    QuestReward = T.RT_28,
    QuestType = 3,
    StarterQuestDes = "GuildTask_12",
    Target = 1,
    TargetId = {2220401}
  },
  [103003126] = {
    EventId = 1030031,
    JumpUIId = 20,
    QuestId = 103003126,
    QuestPhaseId = 4001,
    QuestReward = T.RT_26,
    QuestType = 3,
    StarterQuestDes = "GuildTask_13",
    Target = 15,
    TargetId = T.RT_29
  },
  [103003127] = {
    EventId = 1030031,
    QuestId = 103003127,
    QuestPhaseId = 4001,
    QuestReward = T.RT_28,
    QuestType = 3,
    StarterQuestDes = "GuildTask_14",
    Target = 20,
    TargetId = T.RT_30
  }
})
