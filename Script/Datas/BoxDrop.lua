local T = {}
T.RT_1 = {
  1030200201,
  1030200202,
  1030200203,
  1030200204,
  1030200205,
  1030200206
}
T.RT_2 = {
  [1] = 16
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BoxDrop", {
  [103020] = {
    BoxCoinId = 221,
    BoxMaximum = 21,
    BoxPerDay = 2,
    CoinPerBox = 3,
    EventId = 103020,
    RewardCount = {
      [1] = 25
    },
    RewardId = {
      [1] = 114100,
      [2] = 114101
    }
  },
  [10302001] = {
    BoxCoinId = 223,
    BoxMaximum = 38,
    BoxPerDay = 2,
    CoinPerBox = 3,
    EventId = 10302001,
    RewardCount = {
      [1] = 30
    },
    RewardId = {
      [1] = 114103,
      [2] = 114104
    }
  },
  [10302002] = {
    BoxCoinId = 224,
    BoxMaximum = 24,
    BoxPerDay = 2,
    CoinPerBox = 3,
    EventId = 10302002,
    QuestId = T.RT_1,
    RewardCount = T.RT_2,
    RewardId = {
      [1] = 114107,
      [2] = 114104
    }
  },
  [10302003] = {
    BoxCoinId = 223,
    BoxMaximum = 36,
    BoxPerDay = 2,
    CoinPerBox = 3,
    EventId = 10302003,
    RewardCount = T.RT_2,
    RewardId = {
      [1] = 114109,
      [2] = 114108
    }
  },
  [10302004] = {
    BoxCoinId = 224,
    BoxMaximum = 22,
    BoxPerDay = 2,
    CoinPerBox = 3,
    EventId = 10302004,
    QuestId = T.RT_1,
    RewardCount = T.RT_2,
    RewardId = {
      [1] = 114110,
      [2] = 114108
    }
  }
})
