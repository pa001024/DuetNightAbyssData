local T = {}
T.RT_1 = {140}
T.RT_2 = {140, 150}
T.RT_3 = {130}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("LimitEventRewardCollection", {
  [101012] = {
    EventId = 101012,
    RewardId = 20000,
    ShowVersion = T.RT_1
  },
  [101013] = {
    EventId = 101013,
    RewardId = 20000,
    ShowVersion = T.RT_1
  },
  [101015] = {
    EventId = 101015,
    RewardId = 101015,
    ShowVersion = T.RT_2
  },
  [102002] = {
    EventId = 102002,
    RewardId = 102002,
    ShowVersion = T.RT_1
  },
  [103014] = {
    EventId = 103014,
    RewardId = 10301401,
    ShowVersion = T.RT_3
  },
  [103018] = {
    EventId = 103018,
    RewardId = 1030106,
    ShowVersion = T.RT_3
  },
  [103019] = {
    EventId = 103019,
    RewardId = 1030112,
    ShowVersion = T.RT_3
  },
  [103020] = {
    EventId = 103020,
    RewardId = 10302001,
    ShowVersion = T.RT_3
  },
  [103023] = {
    EventId = 103023,
    RewardId = 1030112,
    ShowVersion = T.RT_1
  },
  [103024] = {
    EventId = 103024,
    RewardId = 10302400,
    ShowVersion = T.RT_1
  },
  [109003] = {
    EventId = 109003,
    RewardId = 109003,
    ShowVersion = T.RT_2
  },
  [111004] = {
    EventId = 111004,
    RewardId = 1030083,
    ShowVersion = T.RT_1
  },
  [112003] = {
    EventId = 112003,
    RewardId = 112003,
    ShowVersion = T.RT_1
  },
  [121001] = {
    EventId = 121001,
    ShowVersion = T.RT_1
  },
  [1030025] = {
    EventId = 1030025,
    RewardId = 1030025,
    ShowVersion = T.RT_3
  },
  [1030026] = {
    EventId = 1030026,
    RewardId = 1030026,
    ShowVersion = T.RT_3
  },
  [1030029] = {
    EventId = 1030029,
    RewardId = 1030029,
    ShowVersion = T.RT_1
  },
  [1030030] = {
    EventId = 1030030,
    RewardId = 1030030,
    ShowVersion = T.RT_1
  },
  [10300602] = {
    EventId = 10300602,
    RewardId = 1030071,
    ShowVersion = T.RT_1
  },
  [10301101] = {
    EventId = 10301101,
    RewardId = 1030100,
    ShowVersion = T.RT_1
  },
  [10302001] = {
    EventId = 10302001,
    RewardId = 10302002,
    ShowVersion = T.RT_1
  },
  [10302101] = {
    EventId = 10302101,
    RewardId = 10302101,
    ShowVersion = T.RT_1
  },
  [103009002] = {
    EventId = 103009002,
    ShowVersion = T.RT_3
  },
  [103009006] = {
    EventId = 103009006,
    ShowVersion = T.RT_1
  },
  [103009007] = {
    EventId = 103009007,
    ShowVersion = T.RT_1
  },
  [105101020] = {
    EventId = 105101020,
    RewardId = 20000,
    ShowVersion = T.RT_1
  },
  [105101021] = {
    EventId = 105101021,
    RewardId = 20000,
    ShowVersion = T.RT_1
  },
  [105102022] = {
    EventId = 105102022,
    RewardId = 20000,
    ShowVersion = T.RT_1
  },
  [105102023] = {
    EventId = 105102023,
    RewardId = 20000,
    ShowVersion = T.RT_1
  }
})
