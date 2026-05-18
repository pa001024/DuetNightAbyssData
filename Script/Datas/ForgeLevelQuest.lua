local T = {}
T.RT_1 = {1040800}
T.RT_2 = {1040801}
T.RT_3 = {1040802}
T.RT_4 = {1040803}
T.RT_5 = {1040804}
T.RT_6 = {1040810}
T.RT_7 = {1040812}
T.RT_8 = {1040814}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ForgeLevelQuest", {
  [1040800] = {
    DailyTasktDes = "HyperWeaponQuest_1040800",
    ForgeQuestId = 1040800,
    QuestReward = T.RT_1,
    Target = 1,
    TargetId = T.RT_1
  },
  [1040801] = {
    DailyTasktDes = "HyperWeaponQuest_1040801",
    ForgeQuestId = 1040801,
    QuestReward = T.RT_2,
    Target = 1,
    TargetId = T.RT_2
  },
  [1040802] = {
    DailyTasktDes = "HyperWeaponQuest_1040802",
    ForgeQuestId = 1040802,
    QuestReward = T.RT_3,
    Target = 1,
    TargetId = T.RT_3
  },
  [1040803] = {
    DailyTasktDes = "HyperWeaponQuest_1040803",
    ForgeQuestId = 1040803,
    QuestReward = T.RT_4,
    Target = 1,
    TargetId = T.RT_4
  },
  [1040804] = {
    DailyTasktDes = "HyperWeaponQuest_1040804",
    ForgeQuestId = 1040804,
    QuestReward = T.RT_5,
    Target = 1,
    TargetId = T.RT_5
  },
  [1040810] = {
    DailyTasktDes = "HyperWeaponQuest_1040810",
    ForgeQuestId = 1040810,
    QuestReward = T.RT_6,
    Target = 1,
    TargetId = T.RT_6
  },
  [1040812] = {
    DailyTasktDes = "HyperWeaponQuest_1040812",
    ForgeQuestId = 1040812,
    QuestReward = T.RT_7,
    Target = 1,
    TargetId = T.RT_7
  },
  [1040814] = {
    DailyTasktDes = "HyperWeaponQuest_1040814",
    ForgeQuestId = 1040814,
    QuestReward = T.RT_8,
    Target = 1,
    TargetId = T.RT_8
  }
})
