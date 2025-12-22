local T = {}
T.RT_1 = {
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 4,
  [5] = 5
}
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
  }
})
