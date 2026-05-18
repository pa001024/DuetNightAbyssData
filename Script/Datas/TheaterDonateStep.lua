local T = {}
T.RT_1 = {
  0,
  0.3,
  0.7,
  1
}
T.RT_2 = {
  [1] = 15000000,
  [2] = 15000000,
  [3] = 2000000
}
T.RT_3 = {
  [1] = 20009,
  [2] = 20012,
  [3] = 4030001
}
T.RT_4 = {
  0,
  0,
  0,
  0.1,
  0.4,
  0.7,
  1
}
T.RT_5 = {
  [1] = 15000000,
  [2] = 10000000,
  [3] = 2000000
}
T.RT_6 = {
  [1] = 20002,
  [2] = 20004,
  [3] = 4030001
}
T.RT_7 = {
  0,
  0,
  0,
  0,
  0,
  0,
  0.1,
  0.4,
  0.7,
  1
}
T.RT_8 = {
  [1] = 20005,
  [2] = 20016,
  [3] = 4030001
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TheaterDonateStep", {
  [103011] = {
    [1] = {
      EventId = 103011,
      Expectation = T.RT_1,
      MailId = 10034,
      Num = T.RT_2,
      Resource = T.RT_3,
      RewardViewId = 1030080,
      StepId = 1
    },
    [2] = {
      EventId = 103011,
      Expectation = T.RT_4,
      MailId = 10035,
      Num = T.RT_5,
      Resource = T.RT_6,
      RewardViewId = 1030081,
      StepId = 2
    },
    [3] = {
      EventId = 103011,
      Expectation = T.RT_7,
      MailId = 10036,
      Num = T.RT_5,
      Resource = T.RT_8,
      RewardViewId = 1030082,
      StepId = 3
    }
  },
  [10301101] = {
    [1] = {
      AutoRepair = 0.003,
      EventId = 10301101,
      Expectation = T.RT_1,
      MailId = 10034,
      Num = T.RT_2,
      Resource = T.RT_3,
      RewardViewId = 1030080,
      StepId = 1
    },
    [2] = {
      AutoRepair = 0.003,
      EventId = 10301101,
      Expectation = T.RT_4,
      MailId = 10035,
      Num = T.RT_5,
      Resource = T.RT_6,
      RewardViewId = 1030081,
      StepId = 2
    },
    [3] = {
      AutoRepair = 0.003,
      EventId = 10301101,
      Expectation = T.RT_7,
      MailId = 10036,
      Num = T.RT_5,
      Resource = T.RT_8,
      RewardViewId = 1030082,
      StepId = 3
    }
  }
})
