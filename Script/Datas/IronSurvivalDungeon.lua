local T = {}
T.RT_1 = {
  [100] = 303104,
  [120] = 303108,
  [140] = 303112,
  [160] = 303116,
  [180] = 303120,
  [200] = 303124
}
T.RT_2 = {1001}
T.RT_3 = {1, 2}
T.RT_4 = {
  [100] = 303204,
  [120] = 303208,
  [140] = 303212,
  [160] = 303216,
  [180] = 303220,
  [200] = 303224
}
T.RT_5 = {
  [100] = 303404,
  [120] = 303408,
  [140] = 303412,
  [160] = 303416,
  [180] = 303420,
  [200] = 303424
}
T.RT_6 = {
  [100] = 303304,
  [120] = 303308,
  [140] = 303312,
  [160] = 303316,
  [180] = 303320,
  [200] = 303324
}
T.RT_7 = {
  [100] = 303604,
  [120] = 303608,
  [140] = 303612,
  [160] = 303616,
  [180] = 303620,
  [200] = 303624
}
T.RT_8 = {
  [100] = 303504,
  [120] = 303508,
  [140] = 303512,
  [160] = 303516,
  [180] = 303520,
  [200] = 303524
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("IronSurvivalDungeon", {
  [91601] = {
    DungeonId = 91601,
    IronRoundsReward = T.RT_1,
    IronRoundsRewardView = T.RT_1,
    IronTicketId = T.RT_2,
    MonsterLevelDrop = T.RT_3
  },
  [91602] = {
    DungeonId = 91602,
    IronRoundsReward = T.RT_4,
    IronRoundsRewardView = T.RT_4,
    IronTicketId = T.RT_2,
    MonsterLevelDrop = T.RT_3
  },
  [91603] = {
    DungeonId = 91603,
    IronRoundsReward = T.RT_5,
    IronRoundsRewardView = T.RT_5,
    IronTicketId = T.RT_2,
    MonsterLevelDrop = T.RT_3
  },
  [91604] = {
    DungeonId = 91604,
    IronRoundsReward = T.RT_6,
    IronRoundsRewardView = T.RT_6,
    IronTicketId = T.RT_2,
    MonsterLevelDrop = T.RT_3
  },
  [91605] = {
    DungeonId = 91605,
    IronRoundsReward = T.RT_7,
    IronRoundsRewardView = T.RT_7,
    IronTicketId = T.RT_2,
    MonsterLevelDrop = T.RT_3
  },
  [91606] = {
    DungeonId = 91606,
    IronRoundsReward = T.RT_8,
    IronRoundsRewardView = T.RT_8,
    IronTicketId = T.RT_2,
    MonsterLevelDrop = T.RT_3
  }
})
