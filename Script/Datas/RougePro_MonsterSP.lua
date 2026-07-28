local T = {}
T.RT_1 = {109001}
T.RT_2 = {109002}
T.RT_3 = {109003}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_MonsterSP", {
  [1] = {
    CompleteRewardDropBox = 11,
    CompleteScore = 20000,
    CompleteToken = 500,
    ID = 1,
    RewardBoxStaticPoint = 109001,
    StaticPointId = T.RT_1,
    Type = "RougePro_Boss"
  },
  [2] = {
    CompleteRewardDropBox = 11,
    CompleteScore = 20000,
    CompleteToken = 500,
    ID = 2,
    RewardBoxStaticPoint = 109002,
    StaticPointId = T.RT_2,
    Type = "RougePro_Boss"
  },
  [3] = {
    CompleteRewardDropBox = 11,
    CompleteScore = 20000,
    CompleteToken = 500,
    ID = 3,
    RewardBoxStaticPoint = 109003,
    StaticPointId = T.RT_3,
    Type = "RougePro_Boss"
  },
  [4] = {
    CompleteRewardDropBox = 12,
    CompleteScore = 40000,
    CompleteToken = 1000,
    ID = 4,
    RewardBoxStaticPoint = 109001,
    StaticPointId = T.RT_1,
    Type = "RougePro_Boss"
  },
  [5] = {
    CompleteRewardDropBox = 12,
    CompleteScore = 40000,
    CompleteToken = 1000,
    ID = 5,
    RewardBoxStaticPoint = 109002,
    StaticPointId = T.RT_2,
    Type = "RougePro_Boss"
  },
  [6] = {
    CompleteRewardDropBox = 12,
    CompleteScore = 40000,
    CompleteToken = 1000,
    ID = 6,
    RewardBoxStaticPoint = 109003,
    StaticPointId = T.RT_3,
    Type = "RougePro_Boss"
  },
  [7] = {
    CompleteScore = 60000,
    ID = 7,
    RewardBoxStaticPoint = 109001,
    StaticPointId = T.RT_1,
    Type = "RougePro_Boss"
  },
  [8] = {
    CompleteScore = 60000,
    ID = 8,
    RewardBoxStaticPoint = 109002,
    StaticPointId = T.RT_2,
    Type = "RougePro_Boss"
  },
  [9] = {
    CompleteScore = 60000,
    ID = 9,
    RewardBoxStaticPoint = 109003,
    StaticPointId = T.RT_3,
    Type = "RougePro_Boss"
  },
  [51] = {
    CompleteRewardDropBox = 21,
    ID = 51,
    MonsterScore = 5,
    RewardBoxStaticPoint = 109001,
    RoundId = 1,
    RoundScoreFix = 0.1,
    StrongScore = 200,
    Type = "RougePro_Extra"
  },
  [101] = {
    CompleteRewardDropBox = 31,
    CompleteScore = 500,
    ID = 101,
    RewardBoxStaticPoint = 8,
    StaticPointId = {8},
    Type = "RougePro_Class_1"
  },
  [111] = {
    ID = 111,
    MonsterRewardDropBox = 41,
    MonsterScore = 1,
    RoundId = 2,
    RoundScoreFix = 0,
    StrongRewardDropBox = 42,
    StrongScore = 20,
    Type = "RougePro_Class_2"
  }
})
