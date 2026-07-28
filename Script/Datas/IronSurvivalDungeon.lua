local T = {}
T.RT_1 = {235}
T.RT_2 = {
  [100] = 303104,
  [120] = 303108,
  [140] = 303112,
  [160] = 303116,
  [180] = 303120,
  [200] = 303124
}
T.RT_3 = {1001}
T.RT_4 = {1, 2}
T.RT_5 = {
  [100] = 303204,
  [120] = 303208,
  [140] = 303212,
  [160] = 303216,
  [180] = 303220,
  [200] = 303224
}
T.RT_6 = {
  [100] = 303404,
  [120] = 303408,
  [140] = 303412,
  [160] = 303416,
  [180] = 303420,
  [200] = 303424
}
T.RT_7 = {
  [100] = 303304,
  [120] = 303308,
  [140] = 303312,
  [160] = 303316,
  [180] = 303320,
  [200] = 303324
}
T.RT_8 = {
  [100] = 303604,
  [120] = 303608,
  [140] = 303612,
  [160] = 303616,
  [180] = 303620,
  [200] = 303624
}
T.RT_9 = {
  [100] = 303504,
  [120] = 303508,
  [140] = 303512,
  [160] = 303516,
  [180] = 303520,
  [200] = 303524
}
T.RT_10 = {
  [100] = 313104,
  [120] = 313108,
  [140] = 313112,
  [160] = 313116,
  [180] = 313120,
  [200] = 313124
}
T.RT_11 = {1002}
T.RT_12 = {13}
T.RT_13 = {
  [100] = 313204,
  [120] = 313208,
  [140] = 313212,
  [160] = 313216,
  [180] = 313220,
  [200] = 313224
}
T.RT_14 = {
  [100] = 313404,
  [120] = 313408,
  [140] = 313412,
  [160] = 313416,
  [180] = 313420,
  [200] = 313424
}
T.RT_15 = {
  [100] = 313304,
  [120] = 313308,
  [140] = 313312,
  [160] = 313316,
  [180] = 313320,
  [200] = 313324
}
T.RT_16 = {
  [100] = 313604,
  [120] = 313608,
  [140] = 313612,
  [160] = 313616,
  [180] = 313620,
  [200] = 313624
}
T.RT_17 = {
  [100] = 313504,
  [120] = 313508,
  [140] = 313512,
  [160] = 313516,
  [180] = 313520,
  [200] = 313524
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("IronSurvivalDungeon", {
  [91601] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91601,
    IronRoundsReward = T.RT_2,
    IronRoundsRewardView = T.RT_2,
    IronTicketId = T.RT_3,
    MonsterLevelDrop = T.RT_4
  },
  [91602] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91602,
    IronRoundsReward = T.RT_5,
    IronRoundsRewardView = T.RT_5,
    IronTicketId = T.RT_3,
    MonsterLevelDrop = T.RT_4
  },
  [91603] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91603,
    IronRoundsReward = T.RT_6,
    IronRoundsRewardView = T.RT_6,
    IronTicketId = T.RT_3,
    MonsterLevelDrop = T.RT_4
  },
  [91604] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91604,
    IronRoundsReward = T.RT_7,
    IronRoundsRewardView = T.RT_7,
    IronTicketId = T.RT_3,
    MonsterLevelDrop = T.RT_4
  },
  [91605] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91605,
    IronRoundsReward = T.RT_8,
    IronRoundsRewardView = T.RT_8,
    IronTicketId = T.RT_3,
    MonsterLevelDrop = T.RT_4
  },
  [91606] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91606,
    IronRoundsReward = T.RT_9,
    IronRoundsRewardView = T.RT_9,
    IronTicketId = T.RT_3,
    MonsterLevelDrop = T.RT_4
  },
  [91701] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91701,
    IronRoundsReward = T.RT_10,
    IronRoundsRewardView = T.RT_10,
    IronTicketId = T.RT_11,
    MonsterLevelDrop = T.RT_12
  },
  [91702] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91702,
    IronRoundsReward = T.RT_13,
    IronRoundsRewardView = T.RT_13,
    IronTicketId = T.RT_11,
    MonsterLevelDrop = T.RT_12
  },
  [91703] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91703,
    IronRoundsReward = T.RT_14,
    IronRoundsRewardView = T.RT_14,
    IronTicketId = T.RT_11,
    MonsterLevelDrop = T.RT_12
  },
  [91704] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91704,
    IronRoundsReward = T.RT_15,
    IronRoundsRewardView = T.RT_15,
    IronTicketId = T.RT_11,
    MonsterLevelDrop = T.RT_12
  },
  [91705] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91705,
    IronRoundsReward = T.RT_16,
    IronRoundsRewardView = T.RT_16,
    IronTicketId = T.RT_11,
    MonsterLevelDrop = T.RT_12
  },
  [91706] = {
    AvaliableTicketLevel = T.RT_1,
    DungeonId = 91706,
    IronRoundsReward = T.RT_17,
    IronRoundsRewardView = T.RT_17,
    IronTicketId = T.RT_11,
    MonsterLevelDrop = T.RT_12
  }
})
