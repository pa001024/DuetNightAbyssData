local T = {}
T.RT_1 = {
  [1] = 55150,
  [2] = 55151,
  [3] = 55152,
  [4] = 55153,
  [5] = 55154
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildBossPonitReward", {
  [101] = {
    EachGradePoints = 800000,
    ID = 101,
    Lv = 20,
    Reward = T.RT_1
  },
  [102] = {
    EachGradePoints = 800000,
    ID = 102,
    Lv = 30,
    Reward = T.RT_1
  },
  [103] = {
    EachGradePoints = 800000,
    ID = 103,
    Lv = 40,
    Reward = T.RT_1
  },
  [104] = {
    EachGradePoints = 800000,
    ID = 104,
    Lv = 50,
    Reward = T.RT_1
  },
  [105] = {
    EachGradePoints = 800000,
    ID = 105,
    Lv = 55,
    Reward = T.RT_1
  },
  [106] = {
    EachGradePoints = 800000,
    ID = 106,
    Lv = 60,
    Reward = T.RT_1
  }
})
