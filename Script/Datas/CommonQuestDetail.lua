local T = {}
T.RT_1 = {50939}
T.RT_2 = {50940}
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
  [11100101] = {
    EventId = 111001,
    QuestId = 11100101,
    QuestPhaseId = 2002,
    QuestReward = {300303},
    StarterQuestDes = "UI_CommonQuest_11100101",
    Target = 1,
    TargetId = T.RT_1
  },
  [11100102] = {
    EventId = 111001,
    QuestId = 11100102,
    QuestPhaseId = 2002,
    QuestReward = {300304},
    StarterQuestDes = "UI_CommonQuest_11100102",
    Target = 3,
    TargetId = T.RT_1
  },
  [11100103] = {
    EventId = 111001,
    QuestId = 11100103,
    QuestPhaseId = 2002,
    QuestReward = {300305},
    StarterQuestDes = "UI_CommonQuest_11100103",
    Target = 5,
    TargetId = T.RT_1
  },
  [11100104] = {
    EventId = 111001,
    QuestId = 11100104,
    QuestPhaseId = 2002,
    QuestReward = {300306},
    StarterQuestDes = "UI_CommonQuest_11100104",
    Target = 10,
    TargetId = T.RT_1
  },
  [11100105] = {
    EventId = 111001,
    QuestId = 11100105,
    QuestPhaseId = 2002,
    QuestReward = {300307},
    StarterQuestDes = "UI_CommonQuest_11100105",
    Target = 15,
    TargetId = T.RT_1
  },
  [11100106] = {
    EventId = 111001,
    QuestId = 11100106,
    QuestPhaseId = 2002,
    QuestReward = {300308},
    StarterQuestDes = "UI_CommonQuest_11100106",
    Target = 20,
    TargetId = T.RT_1
  },
  [11100107] = {
    EventId = 111001,
    QuestId = 11100107,
    QuestPhaseId = 2001,
    QuestReward = {300309},
    StarterQuestDes = "UI_CommonQuest_11100107",
    Target = 1,
    TargetId = T.RT_2
  },
  [11100108] = {
    EventId = 111001,
    QuestId = 11100108,
    QuestPhaseId = 2001,
    QuestReward = {300310},
    StarterQuestDes = "UI_CommonQuest_11100108",
    Target = 3,
    TargetId = T.RT_2
  },
  [11100109] = {
    EventId = 111001,
    QuestId = 11100109,
    QuestPhaseId = 2001,
    QuestReward = {300311},
    StarterQuestDes = "UI_CommonQuest_11100109",
    Target = 5,
    TargetId = T.RT_2
  },
  [11100110] = {
    EventId = 111001,
    QuestId = 11100110,
    QuestPhaseId = 2001,
    QuestReward = {300312},
    StarterQuestDes = "UI_CommonQuest_11100110",
    Target = 10,
    TargetId = T.RT_2
  },
  [11100111] = {
    EventId = 111001,
    QuestId = 11100111,
    QuestPhaseId = 2001,
    QuestReward = {300313},
    StarterQuestDes = "UI_CommonQuest_11100111",
    Target = 15,
    TargetId = T.RT_2
  },
  [11100112] = {
    EventId = 111001,
    QuestId = 11100112,
    QuestPhaseId = 2001,
    QuestReward = {300314},
    StarterQuestDes = "UI_CommonQuest_11100112",
    Target = 20,
    TargetId = T.RT_2
  }
})
