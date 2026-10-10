local T = {}
T.RT_1 = {7201}
T.RT_2 = {201}
T.RT_3 = {7203}
T.RT_4 = {30101}
T.RT_5 = {
  30610,
  30611,
  30612,
  30613,
  30614
}
T.RT_6 = {2000}
T.RT_7 = {7209}
T.RT_8 = {7207}
T.RT_9 = {10301}
T.RT_10 = {90105}
T.RT_11 = {2000101}
T.RT_12 = {
  40301,
  40302,
  40303,
  40304,
  40305,
  40306
}
T.RT_13 = {7205}
T.RT_14 = {1900101}
T.RT_15 = {7202}
T.RT_16 = {7204}
T.RT_17 = {1080201}
T.RT_18 = {50948}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DailyGoalTask", {
  [10000101] = {
    DailyGoalTaskId = 10000101,
    DailyTasktDes = "DailyTaskDes_10000101",
    ExitCondition = 145,
    IsFixed = true,
    QuestReward = T.RT_1,
    Target = 1,
    TargetId = T.RT_2
  },
  [10000102] = {
    DailyGoalTaskId = 10000102,
    DailyTasktDes = "DailyTaskDes_10000102",
    EntryCondition = 120,
    JumpUIId = 20,
    QuestReward = T.RT_3,
    RandomWeight = 20,
    Target = 3,
    TargetId = T.RT_4
  },
  [10000103] = {
    DailyGoalTaskId = 10000103,
    DailyTasktDes = "DailyTaskDes_10000103",
    ExitCondition = 145,
    JumpUIId = 47,
    QuestReward = T.RT_1,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_5
  },
  [10000105] = {
    DailyGoalTaskId = 10000105,
    DailyTasktDes = "DailyTaskDes_10000105",
    JumpUIId = 19,
    QuestReward = T.RT_3,
    RandomWeight = 0,
    Target = 1,
    TargetId = {50930}
  },
  [10000106] = {
    DailyGoalTaskId = 10000106,
    DailyTasktDes = "DailyTaskDes_10000106",
    EntryCondition = 125,
    ExitCondition = 145,
    IsFixed = true,
    JumpUIId = 19,
    QuestReward = T.RT_1,
    Target = 50,
    TargetId = T.RT_6
  },
  [10000107] = {
    DailyGoalTaskId = 10000107,
    DailyTasktDes = "DailyTaskDes_10000107",
    EntryCondition = 120,
    IsFixed = true,
    JumpUIId = 13,
    QuestReward = T.RT_7,
    Target = 1,
    TargetId = {9000}
  },
  [10000108] = {
    DailyGoalTaskId = 10000108,
    DailyTasktDes = "DailyTaskDes_10000108",
    EntryCondition = 120,
    JumpUIId = 22,
    QuestReward = T.RT_8,
    RandomWeight = 20,
    Target = 1,
    TargetId = {2300101}
  },
  [10000109] = {
    DailyGoalTaskId = 10000109,
    DailyTasktDes = "DailyTaskDes_10000109",
    EntryCondition = 125,
    JumpUIId = 65,
    QuestReward = T.RT_8,
    RandomWeight = 20,
    Target = 1,
    TargetId = {50932}
  },
  [10000110] = {
    DailyGoalTaskId = 10000110,
    DailyTasktDes = "DailyTaskDes_10000110",
    QuestReward = T.RT_3,
    RandomWeight = 20,
    Target = 1,
    TargetId = {10051601}
  },
  [10000111] = {
    DailyGoalTaskId = 10000111,
    DailyTasktDes = "DailyTaskDes_10000111",
    EntryCondition = 115,
    QuestReward = T.RT_3,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_9
  },
  [10000112] = {
    DailyGoalTaskId = 10000112,
    DailyTasktDes = "DailyTaskDes_10000112",
    JumpUIId = 30,
    QuestReward = T.RT_1,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_10
  },
  [10000113] = {
    DailyGoalTaskId = 10000113,
    DailyTasktDes = "DailyTaskDes_10000113",
    EntryCondition = 125,
    QuestReward = T.RT_1,
    RandomWeight = 20,
    Target = 1,
    TargetId = {2100101}
  },
  [10000114] = {
    DailyGoalTaskId = 10000114,
    DailyTasktDes = "DailyTaskDes_10000114",
    ExitCondition = 145,
    JumpUIId = 51,
    QuestReward = T.RT_1,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_11
  },
  [10000115] = {
    DailyGoalTaskId = 10000115,
    DailyTasktDes = "DailyTaskDes_10000115",
    JumpUIId = 49,
    QuestReward = T.RT_1,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_12
  },
  [10000116] = {
    DailyGoalTaskId = 10000116,
    DailyTasktDes = "DailyTaskDes_10000116",
    EntryCondition = 125,
    IsFixed = true,
    QuestReward = T.RT_13,
    Target = 1,
    TargetId = T.RT_14
  },
  [10000117] = {
    DailyGoalTaskId = 10000117,
    DailyTasktDes = "DailyTaskDes_10000117",
    EntryCondition = 125,
    QuestReward = T.RT_15,
    RandomWeight = 0,
    Target = 1,
    TargetId = {50931}
  },
  [10000118] = {
    DailyGoalTaskId = 10000118,
    DailyTasktDes = "DailyTaskDes_10000118",
    IsFixed = true,
    QuestReward = T.RT_7,
    Target = 1,
    TargetId = {1070301, 1070304}
  },
  [10000119] = {
    DailyGoalTaskId = 10000119,
    DailyTasktDes = "DailyTaskDes_10000119",
    IsFixed = true,
    QuestReward = T.RT_16,
    Target = 1,
    TargetId = {1070302, 1070303}
  },
  [10000120] = {
    DailyGoalTaskId = 10000120,
    DailyTasktDes = "DailyTaskDes_10000120",
    QuestReward = T.RT_1,
    RandomWeight = 20,
    Target = 3,
    TargetId = {1010501}
  },
  [10000121] = {
    DailyGoalTaskId = 10000121,
    DailyTasktDes = "DailyTaskDes_10000121",
    ExitCondition = 145,
    IsFixed = true,
    JumpUIId = 70,
    QuestReward = T.RT_1,
    Target = 10,
    TargetId = T.RT_17
  },
  [10000122] = {
    DailyGoalTaskId = 10000122,
    DailyTasktDes = "DailyTaskDes_10000122",
    EntryCondition = 125,
    JumpUIId = 65,
    QuestReward = T.RT_8,
    RandomWeight = 20,
    Target = 1,
    TargetId = {50947}
  },
  [10000123] = {
    DailyGoalTaskId = 10000123,
    DailyTasktDes = "DailyTaskDes_10000105",
    JumpUIId = 19,
    QuestReward = T.RT_3,
    RandomWeight = 60,
    Target = 1,
    TargetId = T.RT_18
  },
  [10000124] = {
    DailyGoalTaskId = 10000124,
    DailyTasktDes = "DailyTaskDes_10000117",
    EntryCondition = 125,
    JumpUIId = 19,
    QuestReward = T.RT_15,
    RandomWeight = 20,
    Target = 1,
    TargetId = {50949}
  },
  [10000125] = {
    DailyGoalTaskId = 10000125,
    DailyTasktDes = "DailyTaskDes_10000101",
    EntryCondition = 145,
    IsFixed = true,
    QuestReward = T.RT_15,
    Target = 1,
    TargetId = T.RT_2
  },
  [10000126] = {
    DailyGoalTaskId = 10000126,
    DailyTasktDes = "DailyTaskDes_10000126",
    EntryCondition = 145,
    JumpUIId = 20,
    QuestReward = T.RT_8,
    RandomWeight = 40,
    Target = 10,
    TargetId = T.RT_4
  },
  [10000127] = {
    DailyGoalTaskId = 10000127,
    DailyTasktDes = "DailyTaskDes_10000103",
    EntryCondition = 145,
    JumpUIId = 47,
    QuestReward = T.RT_15,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_5
  },
  [10000128] = {
    DailyGoalTaskId = 10000128,
    DailyTasktDes = "DailyTaskDes_10000128",
    EntryCondition = 145,
    JumpUIId = 19,
    QuestReward = T.RT_8,
    RandomWeight = 60,
    Target = 3,
    TargetId = T.RT_18
  },
  [10000129] = {
    DailyGoalTaskId = 10000129,
    DailyTasktDes = "DailyTaskDes_10000129",
    EntryCondition = 145,
    IsFixed = true,
    JumpUIId = 19,
    QuestReward = T.RT_3,
    Target = 100,
    TargetId = T.RT_6
  },
  [10000130] = {
    DailyGoalTaskId = 10000130,
    DailyTasktDes = "DailyTaskDes_10000130",
    EntryCondition = 145,
    QuestReward = T.RT_16,
    RandomWeight = 20,
    Target = 3,
    TargetId = T.RT_9
  },
  [10000131] = {
    DailyGoalTaskId = 10000131,
    DailyTasktDes = "DailyTaskDes_10000131",
    EntryCondition = 145,
    JumpUIId = 30,
    QuestReward = T.RT_13,
    RandomWeight = 20,
    Target = 3,
    TargetId = T.RT_10
  },
  [10000132] = {
    DailyGoalTaskId = 10000132,
    DailyTasktDes = "DailyTaskDes_10000114",
    EntryCondition = 145,
    JumpUIId = 51,
    QuestReward = T.RT_13,
    RandomWeight = 20,
    Target = 1,
    TargetId = T.RT_11
  },
  [10000133] = {
    DailyGoalTaskId = 10000133,
    DailyTasktDes = "DailyTaskDes_10000121",
    EntryCondition = 145,
    IsFixed = true,
    JumpUIId = 70,
    QuestReward = T.RT_3,
    Target = 10,
    TargetId = T.RT_17
  },
  [10000134] = {
    DailyGoalTaskId = 10000134,
    DailyTasktDes = "DailyTaskDes_10000134",
    EntryCondition = 145,
    QuestReward = T.RT_8,
    RandomWeight = 60,
    Target = 3,
    TargetId = T.RT_14
  },
  [10000135] = {
    DailyGoalTaskId = 10000135,
    DailyTasktDes = "DailyTaskDes_10000135",
    EntryCondition = 145,
    JumpUIId = 49,
    QuestReward = T.RT_8,
    RandomWeight = 20,
    Target = 3,
    TargetId = T.RT_12
  }
})
