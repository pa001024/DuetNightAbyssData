local T = {}
T.RT_1 = {4}
T.RT_2 = {
  30601,
  30602,
  30603,
  30604,
  30605,
  30606
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ModGuideBookTask", {
  [1] = {
    DisplayId = "01",
    JumpTaskTypeParam = T.RT_1,
    QuestPhaseId = 1,
    Target = 1,
    TargetId = {30404},
    TaskDes = "UI_ModGuideBook_Task_Des_01",
    TaskId = 1,
    TaskName = "UI_ModGuideBook_Task_Title_Equip_01",
    TaskReward = {7301},
    TaskType = "Jump"
  },
  [2] = {
    DisplayId = "02",
    JumpTaskTypeParam = T.RT_1,
    QuestPhaseId = 1,
    Target = 1,
    TargetId = T.RT_2,
    TaskDes = "UI_ModGuideBook_Task_Des_02",
    TaskId = 2,
    TaskName = "UI_ModGuideBook_Task_Title_LevelUp_01",
    TaskReward = {7302},
    TaskType = "Jump"
  },
  [3] = {
    CollectTaskTypeParam = {21005, 21006},
    DisplayId = "03",
    NoRepeatField = "ModId",
    QuestPhaseId = 1,
    Target = 2,
    TargetId = {30201},
    TaskDes = "UI_ModGuideBook_Task_Des_03",
    TaskId = 3,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_01",
    TaskReward = {7303},
    TaskType = "Collect"
  },
  [4] = {
    CollectTaskTypeParam = {22007, 22008},
    DisplayId = "04",
    NoRepeatField = "ModId",
    QuestPhaseId = 1,
    Target = 2,
    TargetId = {30202},
    TaskDes = "UI_ModGuideBook_Task_Des_04",
    TaskId = 4,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_02",
    TaskReward = {7304},
    TaskType = "Collect"
  },
  [5] = {
    CollectTaskTypeParam = {23007, 23008},
    DisplayId = "05",
    NoRepeatField = "ModId",
    QuestPhaseId = 1,
    Target = 2,
    TargetId = {30203},
    TaskDes = "UI_ModGuideBook_Task_Des_05",
    TaskId = 5,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_03",
    TaskReward = {7305},
    TaskType = "Collect"
  },
  [6] = {
    DisplayId = "06",
    JumpTaskTypeParam = T.RT_1,
    QuestPhaseId = 2,
    Target = 1,
    TargetId = {30405},
    TaskDes = "UI_ModGuideBook_Task_Des_06",
    TaskId = 6,
    TaskName = "UI_ModGuideBook_Task_Title_Equip_02",
    TaskReward = {7306},
    TaskType = "Jump"
  },
  [7] = {
    DisplayId = "07",
    JumpTaskTypeParam = T.RT_1,
    QuestPhaseId = 2,
    Target = 4,
    TargetId = T.RT_2,
    TaskDes = "UI_ModGuideBook_Task_Des_07",
    TaskId = 7,
    TaskName = "UI_ModGuideBook_Task_Title_LevelUp_02",
    TaskReward = {7307},
    TaskType = "Jump"
  },
  [8] = {
    CollectTaskTypeParam = {31215, 31216},
    DisplayId = "08",
    NoRepeatField = "ModId",
    QuestPhaseId = 2,
    Target = 2,
    TargetId = {30204},
    TaskDes = "UI_ModGuideBook_Task_Des_08",
    TaskId = 8,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_04",
    TaskReward = {7308},
    TaskType = "Collect"
  },
  [9] = {
    CollectTaskTypeParam = {31217, 31218},
    DisplayId = "09",
    NoRepeatField = "ModId",
    QuestPhaseId = 2,
    Target = 2,
    TargetId = {30210},
    TaskDes = "UI_ModGuideBook_Task_Des_09",
    TaskId = 9,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_05",
    TaskReward = {7314},
    TaskType = "Collect"
  },
  [10] = {
    CollectTaskTypeParam = {32004, 32005},
    DisplayId = "10",
    NoRepeatField = "ModId",
    QuestPhaseId = 2,
    Target = 2,
    TargetId = {30205},
    TaskDes = "UI_ModGuideBook_Task_Des_11",
    TaskId = 10,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_07",
    TaskReward = {7309},
    TaskType = "Collect"
  },
  [11] = {
    CollectTaskTypeParam = {33004, 33005},
    DisplayId = "11",
    NoRepeatField = "ModId",
    QuestPhaseId = 3,
    Target = 2,
    TargetId = {30206},
    TaskDes = "UI_ModGuideBook_Task_Des_10",
    TaskId = 11,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_06",
    TaskReward = {7310},
    TaskType = "Collect"
  },
  [12] = {
    CollectTaskTypeParam = {
      31301,
      31201,
      31202,
      31203,
      31204
    },
    DisplayId = "12",
    NoRepeatField = "ModId",
    QuestPhaseId = 3,
    Target = 5,
    TargetId = {30207},
    TaskDes = "UI_ModGuideBook_Task_Des_12",
    TaskId = 12,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_08",
    TaskReward = {7311},
    TaskType = "Collect"
  },
  [13] = {
    CollectTaskTypeParam = {32301, 32302},
    DisplayId = "13",
    NoRepeatField = "ModId",
    QuestPhaseId = 3,
    Target = 2,
    TargetId = {30208},
    TaskDes = "UI_ModGuideBook_Task_Des_13",
    TaskId = 13,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_09",
    TaskReward = {7312},
    TaskType = "Collect"
  },
  [14] = {
    CollectTaskTypeParam = {33311, 33331},
    DisplayId = "14",
    NoRepeatField = "ModId",
    QuestPhaseId = 3,
    Target = 2,
    TargetId = {30209},
    TaskDes = "UI_ModGuideBook_Task_Des_14",
    TaskId = 14,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_10",
    TaskReward = {7313},
    TaskType = "Collect"
  },
  [15] = {
    CollectTaskTypeParam = {
      41952,
      41325,
      41452,
      41751,
      41752,
      41753,
      41754
    },
    DisplayId = "15",
    NoRepeatField = "ModId",
    QuestPhaseId = 4,
    Target = 7,
    TargetId = {30211},
    TaskDes = "UI_ModGuideBook_Task_Des_15",
    TaskId = 15,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_11",
    TaskReward = {7315},
    TaskType = "Collect"
  },
  [16] = {
    CollectTaskTypeParam = {
      41922,
      41332,
      41424,
      41721,
      41722,
      41723,
      41724
    },
    DisplayId = "16",
    NoRepeatField = "ModId",
    QuestPhaseId = 4,
    Target = 7,
    TargetId = {30212},
    TaskDes = "UI_ModGuideBook_Task_Des_16",
    TaskId = 16,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_12",
    TaskReward = {7316},
    TaskType = "Collect"
  },
  [17] = {
    CollectTaskTypeParam = {
      41931,
      41333,
      41431,
      41731,
      41732,
      41733,
      41734
    },
    DisplayId = "17",
    NoRepeatField = "ModId",
    QuestPhaseId = 4,
    Target = 7,
    TargetId = {30213},
    TaskDes = "UI_ModGuideBook_Task_Des_17",
    TaskId = 17,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_13",
    TaskReward = {7317},
    TaskType = "Collect"
  },
  [18] = {
    CollectTaskTypeParam = {
      41941,
      41334,
      41441,
      41741,
      41742,
      41743,
      41744
    },
    DisplayId = "18",
    NoRepeatField = "ModId",
    QuestPhaseId = 4,
    Target = 7,
    TargetId = {30214},
    TaskDes = "UI_ModGuideBook_Task_Des_18",
    TaskId = 18,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_14",
    TaskReward = {7318},
    TaskType = "Collect"
  },
  [19] = {
    CollectTaskTypeParam = {
      41962,
      41326,
      41461,
      41761,
      41762,
      41763,
      41764
    },
    DisplayId = "19",
    NoRepeatField = "ModId",
    QuestPhaseId = 4,
    Target = 7,
    TargetId = {30215},
    TaskDes = "UI_ModGuideBook_Task_Des_19",
    TaskId = 19,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_15",
    TaskReward = {7319},
    TaskType = "Collect"
  },
  [20] = {
    CollectTaskTypeParam = {
      41911,
      41331,
      41411,
      41711,
      41712,
      41713,
      41714
    },
    DisplayId = "20",
    NoRepeatField = "ModId",
    QuestPhaseId = 4,
    Target = 7,
    TargetId = {30216},
    TaskDes = "UI_ModGuideBook_Task_Des_20",
    TaskId = 20,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_16",
    TaskReward = {7320},
    TaskType = "Collect"
  },
  [21] = {
    CollectTaskTypeParam = {
      42001,
      42002,
      42003,
      42006
    },
    DisplayId = "21",
    NoRepeatField = "ModId",
    QuestPhaseId = 5,
    Target = 4,
    TargetId = {30217},
    TaskDes = "UI_ModGuideBook_Task_Des_21",
    TaskId = 21,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_17",
    TaskReward = {7321},
    TaskType = "Collect"
  },
  [22] = {
    CollectTaskTypeParam = {
      42203,
      42311,
      42312,
      42321,
      42322
    },
    DisplayId = "22",
    NoRepeatField = "ModId",
    QuestPhaseId = 5,
    Target = 5,
    TargetId = {30218},
    TaskDes = "UI_ModGuideBook_Task_Des_22",
    TaskId = 22,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_18",
    TaskReward = {7322},
    TaskType = "Collect"
  },
  [23] = {
    CollectTaskTypeParam = {
      42401,
      42403,
      42411,
      42412
    },
    DisplayId = "23",
    NoRepeatField = "ModId",
    QuestPhaseId = 5,
    Target = 4,
    TargetId = {30219},
    TaskDes = "UI_ModGuideBook_Task_Des_23",
    TaskId = 23,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_19",
    TaskReward = {7323},
    TaskType = "Collect"
  },
  [24] = {
    CollectTaskTypeParam = {
      43001,
      43002,
      43003,
      43006
    },
    DisplayId = "24",
    NoRepeatField = "ModId",
    QuestPhaseId = 5,
    Target = 4,
    TargetId = {30220},
    TaskDes = "UI_ModGuideBook_Task_Des_24",
    TaskId = 24,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_20",
    TaskReward = {7324},
    TaskType = "Collect"
  },
  [25] = {
    CollectTaskTypeParam = {
      43401,
      43402,
      43403,
      43404,
      43405
    },
    DisplayId = "25",
    NoRepeatField = "ModId",
    QuestPhaseId = 5,
    Target = 5,
    TargetId = {30221},
    TaskDes = "UI_ModGuideBook_Task_Des_25",
    TaskId = 25,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_21",
    TaskReward = {7325},
    TaskType = "Collect"
  },
  [26] = {
    CollectTaskTypeParam = {
      43601,
      43602,
      43603,
      43604
    },
    DisplayId = "26",
    NoRepeatField = "ModId",
    QuestPhaseId = 5,
    Target = 4,
    TargetId = {30222},
    TaskDes = "UI_ModGuideBook_Task_Des_26",
    TaskId = 26,
    TaskName = "UI_ModGuideBook_Task_Title_Collect_22",
    TaskReward = {7326},
    TaskType = "Collect"
  }
})
