local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PhotoEvent", {
  [103017] = {
    [1] = {
      EventId = 103017,
      PhotoTaskId = 1,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/Activity_CoopOnline_BG_2.Activity_CoopOnline_BG_2'",
      QuestChain = 400101,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 151
    },
    [2] = {
      EventId = 103017,
      PhotoTaskId = 2,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/Activity_SevenDay_Saiqi_2.Activity_SevenDay_Saiqi_2'",
      QuestChain = 400102,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 152
    },
    [3] = {
      EventId = 103017,
      PhotoTaskId = 3,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/Activity_SevenDay_Zhiliu_2.Activity_SevenDay_Zhiliu_2'",
      QuestChain = 400103,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 153
    },
    [4] = {
      EventId = 103017,
      PhotoTaskId = 4,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/Gacha_Pool_SaiqiPifu01_Atlas_2.Gacha_Pool_SaiqiPifu01_Atlas_2'",
      QuestChain = 400104,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 154
    },
    [5] = {
      EventId = 103017,
      PhotoTaskId = 5,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/GachaPool_Baiheng_2.GachaPool_Baiheng_2'",
      QuestChain = 400105,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 155
    },
    [6] = {
      EventId = 103017,
      PhotoTaskId = 6,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/GachaPool_Baonu_2.GachaPool_Baonu_2'",
      QuestChain = 400106,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 156
    },
    [7] = {
      EventId = 103017,
      FinishCondition = 160,
      PhotoTaskId = 7,
      PhotoView = "Texture2D'/Game/UI/Texture/Static/Image/Max2048/Spine/GachaPool_Dafunie_2.GachaPool_Dafunie_2'",
      QuestChain = 400107,
      Reward = 7936,
      RewardView = 7936,
      StartCondition = 157
    }
  }
})
