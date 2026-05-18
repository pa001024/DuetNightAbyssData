local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 1
}
T.RT_2 = {
  [1] = 3000020,
  [2] = 3000021
}
T.RT_3 = {
  [1] = 1
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestTurnInItem", {
  [10040108] = {
    ItemCounts = T.RT_1,
    ItemIds = T.RT_2,
    QuestTurnInItemId = 10040108,
    SpecialQuestId = 10040106,
    bShowQuest = true
  },
  [10040112] = {
    ItemCounts = T.RT_3,
    ItemIds = {
      [1] = 3000021
    },
    QuestTurnInItemId = 10040112,
    SpecialQuestId = 10040106,
    bShowQuest = true
  },
  [10040201] = {
    ItemCounts = T.RT_1,
    ItemIds = T.RT_2,
    QuestId = 10040201,
    QuestTurnInItemId = 10040201,
    bShowQuest = true
  },
  [10040205] = {
    ItemCounts = T.RT_1,
    ItemIds = T.RT_2,
    QuestTurnInItemId = 10040205,
    SpecialQuestId = 10040203,
    bShowQuest = true
  },
  [10040231] = {
    ItemCounts = T.RT_3,
    ItemIds = {
      [1] = 3000022
    },
    QuestTurnInItemId = 10040231,
    SpecialQuestId = 10040206
  },
  [10040305] = {
    ItemCounts = {
      [1] = 1,
      [2] = 1,
      [3] = 1
    },
    ItemIds = {
      [1] = 3000023,
      [2] = 3000024,
      [3] = 3000025
    },
    QuestTurnInItemId = 10040305,
    SpecialQuestId = 10040305
  },
  [10040404] = {
    ItemCounts = T.RT_3,
    ItemIds = {
      [1] = 3000018
    },
    QuestId = 10040404,
    QuestTurnInItemId = 10040404
  },
  [20023801] = {
    ItemCounts = {
      [1] = 30,
      [2] = 30,
      [3] = 30,
      [4] = 30,
      [5] = 30
    },
    ItemIds = {
      [1] = 15026,
      [2] = 15027,
      [3] = 15028,
      [4] = 15029,
      [5] = 15030
    },
    QuestId = 20023801,
    QuestTurnInItemId = 20023801
  },
  [20023901] = {
    ItemCounts = {
      [1] = 1,
      [2] = 1,
      [3] = 1,
      [4] = 1,
      [5] = 1,
      [6] = 1
    },
    ItemIds = {
      [1] = 15031,
      [2] = 15032,
      [3] = 15033,
      [4] = 15034,
      [5] = 15035,
      [6] = 15036
    },
    QuestId = 20023901,
    QuestTurnInItemId = 20023901
  },
  [20024001] = {
    ItemCounts = T.RT_3,
    ItemIds = {
      [1] = 15037
    },
    QuestId = 20024001,
    QuestTurnInItemId = 20024001
  }
})
