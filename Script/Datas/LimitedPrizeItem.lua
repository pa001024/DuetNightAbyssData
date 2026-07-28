local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 1,
  [3] = 1,
  [4] = 1,
  [5] = 1,
  [6] = 1,
  [7] = 3,
  [8] = 6
}
T.RT_2 = {410101, 180101}
T.RT_3 = {21007, 21006}
T.RT_4 = {40035, 40034}
T.RT_5 = {10098, 10099}
T.RT_6 = {10032, 10033}
T.RT_7 = {30125, 30124}
T.RT_8 = {30112}
T.RT_9 = {208}
T.RT_10 = {
  [1] = T.RT_2,
  [2] = T.RT_3,
  [3] = T.RT_4,
  [4] = T.RT_5,
  [5] = T.RT_6,
  [6] = T.RT_7,
  [7] = T.RT_8,
  [8] = T.RT_9
}
T.RT_11 = {
  [1] = 8,
  [2] = 92,
  [3] = 100,
  [4] = 200,
  [5] = 1300,
  [6] = 1300,
  [7] = 3500,
  [8] = 3500
}
T.RT_12 = {
  [1] = 2,
  [2] = 4,
  [3] = 4,
  [4] = 4,
  [5] = 7,
  [6] = 8,
  [7] = 6,
  [8] = 6
}
T.RT_13 = {150201, 310101}
T.RT_14 = {21011, 21012}
T.RT_15 = {13037, 13039}
T.RT_16 = {20082, 20084}
T.RT_17 = {10037, 10038}
T.RT_18 = {20008, 20009}
T.RT_19 = {
  [1] = T.RT_13,
  [2] = T.RT_14,
  [3] = T.RT_15,
  [4] = T.RT_16,
  [5] = T.RT_17,
  [6] = T.RT_18,
  [7] = T.RT_8,
  [8] = T.RT_9
}
T.RT_20 = {320201, 310201}
T.RT_21 = {70061, 70006}
T.RT_22 = {40083, 40080}
T.RT_23 = {20095, 20094}
T.RT_24 = {10045, 10044}
T.RT_25 = {20012, 20011}
T.RT_26 = {
  [1] = T.RT_20,
  [2] = T.RT_21,
  [3] = T.RT_22,
  [4] = T.RT_23,
  [5] = T.RT_24,
  [6] = T.RT_25,
  [7] = T.RT_8,
  [8] = T.RT_9
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("LimitedPrizeItem", {
  [1001] = {
    CostRuleId = 1001,
    Count = T.RT_1,
    Id = T.RT_10,
    LimitedPrizePoolId = 1001,
    Probability = T.RT_11,
    Type = T.RT_12
  },
  [1002] = {
    CostRuleId = 1002,
    Count = T.RT_1,
    Id = T.RT_10,
    LimitedPrizePoolId = 1002,
    Probability = T.RT_11,
    Type = T.RT_12
  },
  [1003] = {
    CostRuleId = 1001,
    Count = T.RT_1,
    Id = T.RT_19,
    LimitedPrizePoolId = 1003,
    Probability = T.RT_11,
    Type = T.RT_12
  },
  [1004] = {
    CostRuleId = 1002,
    Count = T.RT_1,
    Id = T.RT_19,
    LimitedPrizePoolId = 1004,
    Probability = T.RT_11,
    Type = T.RT_12
  },
  [1005] = {
    CostRuleId = 1001,
    Count = T.RT_1,
    Id = T.RT_26,
    LimitedPrizePoolId = 1005,
    Probability = T.RT_11,
    Type = T.RT_12
  },
  [1006] = {
    CostRuleId = 1002,
    Count = T.RT_1,
    Id = T.RT_26,
    LimitedPrizePoolId = 1006,
    Probability = T.RT_11,
    Type = T.RT_12
  }
})
