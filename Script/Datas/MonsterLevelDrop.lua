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
    RewardId = {
      [1] = 303003,
      [2] = 303003,
      [3] = 303003,
      [4] = 303003,
      [5] = 303003,
      [6] = 303003,
      [7] = 303003,
      [8] = 303003,
      [9] = 303003
    },
    StartTime = LocalTimeProxy(1704081600)
  },
  [2] = {
    BaseProbability = T.RT_1,
    EndTime = LocalTimeProxy(2524622400),
    MonsterLevel = T.RT_2,
    MonsterLevelDropId = 2,
    MonsterLevelDropView = 15002,
    ProbabilityUp = T.RT_3,
    RewardId = {
      [1] = 303002,
      [2] = 303002,
      [3] = 303002,
      [4] = 303002,
      [5] = 303002,
      [6] = 303002,
      [7] = 303002,
      [8] = 303002,
      [9] = 303002
    },
    StartTime = LocalTimeProxy(1704081600)
  }
})
