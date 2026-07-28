local T = {}
T.RT_1 = {
  [1] = 10,
  [2] = 20,
  [3] = 40,
  [4] = 60,
  [5] = 80,
  [6] = 100,
  [7] = 120,
  [8] = 160,
  [9] = 200
}
T.RT_2 = {
  [1] = 80,
  [2] = 100,
  [3] = 120,
  [4] = 140,
  [5] = 160,
  [6] = 170,
  [7] = 180,
  [8] = 190,
  [9] = 200
}
T.RT_3 = {
  [1] = 0,
  [2] = 1,
  [3] = 1,
  [4] = 1,
  [5] = 2,
  [6] = 2,
  [7] = 4,
  [8] = 4,
  [9] = 0
}
T.RT_4 = {
  [1] = 303003,
  [2] = 303003,
  [3] = 303003,
  [4] = 303003,
  [5] = 303003,
  [6] = 303003,
  [7] = 303003,
  [8] = 303003,
  [9] = 303003
}
T.RT_5 = {
  [1] = 25,
  [2] = 50,
  [3] = 100,
  [4] = 150,
  [5] = 200,
  [6] = 250,
  [7] = 300,
  [8] = 400,
  [9] = 500
}
T.RT_6 = {
  [1] = 0,
  [2] = 1,
  [3] = 2,
  [4] = 2,
  [5] = 5,
  [6] = 5,
  [7] = 10,
  [8] = 10,
  [9] = 0
}
T.RT_7 = {
  [1] = 303002,
  [2] = 303002,
  [3] = 303002,
  [4] = 303002,
  [5] = 303002,
  [6] = 303002,
  [7] = 303002,
  [8] = 303002,
  [9] = 303002
}
T.RT_8 = {
  [1] = 313000,
  [2] = 313000,
  [3] = 313000,
  [4] = 313000,
  [5] = 313000,
  [6] = 313000,
  [7] = 313000,
  [8] = 313000,
  [9] = 313000
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MonsterLevelDrop", {
  [1] = {
    BaseProbability = T.RT_1,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 1,
    MonsterLevelDropView = 15003,
    ProbabilityUp = T.RT_3,
    RewardId = T.RT_4,
    StartTime = LocalTimeProxy(1704081600)
  },
  [2] = {
    BaseProbability = T.RT_1,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 2,
    MonsterLevelDropView = 15002,
    ProbabilityUp = T.RT_3,
    RewardId = T.RT_7,
    StartTime = LocalTimeProxy(1704081600)
  },
  [3] = {
    BaseProbability = T.RT_1,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 3,
    MonsterLevelDropView = 15006,
    ProbabilityUp = T.RT_3,
    RewardId = T.RT_8,
    StartTime = LocalTimeProxy(1787018400)
  },
  [11] = {
    BaseProbability = T.RT_5,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 11,
    MonsterLevelDropView = 15003,
    ProbabilityUp = T.RT_6,
    RewardId = T.RT_4,
    StartTime = LocalTimeProxy(1704081600)
  },
  [12] = {
    BaseProbability = T.RT_5,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 12,
    MonsterLevelDropView = 15002,
    ProbabilityUp = T.RT_6,
    RewardId = T.RT_7,
    StartTime = LocalTimeProxy(1704081600)
  },
  [13] = {
    BaseProbability = T.RT_5,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 13,
    MonsterLevelDropView = 15006,
    ProbabilityUp = T.RT_6,
    RewardId = T.RT_8,
    StartTime = LocalTimeProxy(1787018400)
  }
})
