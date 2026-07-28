local T = {}
T.RT_1 = {140}
T.RT_2 = {140150}
T.RT_3 = {150}
T.RT_4 = {130}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("LimitEventRewardCollection", {
  [101012] = {
    EventId = 101012,
    RewardId = 101012,
    ShowVersion = T.RT_1
  },
  [101013] = {
    EventId = 101013,
    RewardId = 101012,
    ShowVersion = T.RT_1
  },
  [101015] = {
    EventId = 101015,
    RewardId = 101015,
    ShowVersion = T.RT_2
  },
  [101016] = {
    EventId = 101016,
    RewardId = 101015,
    ShowVersion = {150160}
  },
  [101017] = {
    EventId = 101017,
    RewardId = 101012,
    ShowVersion = T.RT_3
  },
  [102002] = {
    EventId = 102002,
    RewardId = 102002,
    ShowVersion = T.RT_1
  },
  [102003] = {
    EventId = 102003,
    RewardId = 102003,
    ShowVersion = T.RT_3
  },
  [103014] = {
    EventId = 103014,
    RewardId = 10301401,
    ShowVersion = T.RT_4
  },
  [103018] = {
    EventId = 103018,
    RewardId = 1030106,
    ShowVersion = T.RT_4
  },
  [103019] = {
    EventId = 103019,
    RewardId = 1030112,
    ShowVersion = T.RT_4
  },
  [103020] = {
    EventId = 103020,
    RewardId = 10302001,
    ShowVersion = T.RT_4
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
  [103025] = {
    EventId = 103025,
    RewardId = 103025,
    ShowVersion = T.RT_3
  },
  [103026] = {
    EventId = 103026,
    RewardId = 103026,
    ShowVersion = T.RT_3
  },
  [103027] = {
    EventId = 103027,
    RewardId = 103027,
    ShowVersion = T.RT_3
  },
  [109003] = {
    EventId = 109003,
    RewardId = 109003,
    ShowVersion = T.RT_2
  },
  [109004] = {
    EventId = 109004,
    RewardId = 109003,
    ShowVersion = T.RT_3
  },
  [111004] = {
    EventId = 111004,
    RewardId = 1030083,
    ShowVersion = T.RT_1
  },
  [111005] = {
    EventId = 111005,
    RewardId = 1030083,
    ShowVersion = T.RT_3
  },
  [112003] = {
    EventId = 112003,
    RewardId = 112003,
    ShowVersion = T.RT_1
  },
  [112004] = {
    EventId = 112004,
    RewardId = 112004,
    ShowVersion = T.RT_3
  },
  [121001] = {
    EventId = 121001,
    ShowVersion = T.RT_1
  },
  [121002] = {
    EventId = 121002,
    ShowVersion = T.RT_3
  },
  [1030025] = {
    EventId = 1030025,
    RewardId = 1030025,
    ShowVersion = T.RT_4
  },
  [1030026] = {
    EventId = 1030026,
    RewardId = 1030026,
    ShowVersion = T.RT_4
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
  [1030032] = {
    EventId = 1030032,
    RewardId = 1030032,
    ShowVersion = T.RT_3
  },
  [1030033] = {
    EventId = 1030033,
    RewardId = 1030033,
    ShowVersion = T.RT_3
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
  [10301601] = {
    EventId = 10301601,
    RewardId = 10301601,
    ShowVersion = T.RT_3
  },
  [10302001] = {
    EventId = 10302001,
    RewardId = 10302002,
    ShowVersion = T.RT_1
  },
  [10302002] = {
    EventId = 10302002,
    RewardId = 10302003,
    ShowVersion = T.RT_3
  },
  [10302101] = {
    EventId = 10302101,
    RewardId = 10302101,
    ShowVersion = T.RT_1
  },
  [10302102] = {
    EventId = 10302102,
    RewardId = 10302102,
    ShowVersion = T.RT_3
  },
  [103009002] = {
    EventId = 103009002,
    ShowVersion = T.RT_4
  },
  [103009006] = {
    EventId = 103009006,
    ShowVersion = T.RT_1
  },
  [103009007] = {
    EventId = 103009007,
    ShowVersion = T.RT_1
  },
  [103009008] = {
    EventId = 103009008,
    ShowVersion = T.RT_3
  },
  [103009009] = {
    EventId = 103009009,
    ShowVersion = T.RT_3
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
  [105101022] = {
    EventId = 105101022,
    RewardId = 20000,
    ShowVersion = T.RT_3
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
  },
  [105102024] = {
    EventId = 105102024,
    RewardId = 20000,
    ShowVersion = T.RT_3
  }
})
