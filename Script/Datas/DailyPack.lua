local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 4,
  [5] = 5
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DailyPack", {
  [9001] = {
    BannerCharId = 2401,
    BannerId = 116,
    BuyReward = 12108,
    DailyPackId = 9001,
    GoodsId = "com.hero.dna.Pay_DailyCharaShards_fushu",
    LoginRequire = T.RT_1,
    MainRewardCount = 20,
    MainRewardId = 1001101,
    Name = "DailyPack_Name_1",
    Reward = {
      [1] = 12109,
      [2] = 12109,
      [3] = 12109,
      [4] = 12109,
      [5] = 12109
    },
    RewardMailId = 10037,
    RewardPeriod = 5
  },
  [9002] = {
    BannerCharId = 1503,
    BannerId = 125,
    BuyReward = 12117,
    DailyPackId = 9002,
    GoodsId = "com.hero.dna.Pay_DailyCharaShards_kezhou",
    LoginRequire = T.RT_1,
    MainRewardCount = 20,
    MainRewardId = 1001101,
    Name = "DailyPack_Name_1",
    Reward = {
      [1] = 12118,
      [2] = 12118,
      [3] = 12118,
      [4] = 12118,
      [5] = 12118
    },
    RewardMailId = 10037,
    RewardPeriod = 5
  },
  [9003] = {
    BannerCharId = 4102,
    BannerId = 218,
    BuyReward = 12145,
    DailyPackId = 9003,
    GoodsId = "com.hero.dna.Pay_DailyCharaShards_zhiliu",
    LoginRequire = T.RT_1,
    MainRewardCount = 20,
    MainRewardId = 1001101,
    Name = "DailyPack_Name_1",
    Reward = {
      [1] = 12145,
      [2] = 12145,
      [3] = 12145,
      [4] = 12145,
      [5] = 12145
    },
    RewardMailId = 10037,
    RewardPeriod = 5
  },
  [9004] = {
    BannerCharId = 4201,
    BannerId = 255,
    BuyReward = 12146,
    DailyPackId = 9004,
    GoodsId = "com.hero.dna.Pay_DailyCharaShards_yuming",
    LoginRequire = T.RT_1,
    MainRewardCount = 20,
    MainRewardId = 1001101,
    Name = "DailyPack_Name_1",
    Reward = {
      [1] = 12146,
      [2] = 12146,
      [3] = 12146,
      [4] = 12146,
      [5] = 12146
    },
    RewardMailId = 10037,
    RewardPeriod = 5
  }
})
