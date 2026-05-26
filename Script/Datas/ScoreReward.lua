local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ScoreReward", {
  [1] = {
    RewardId = 370001,
    ScoreTarget = 500,
    SortId = 1
  },
  [2] = {
    RewardId = 370002,
    ScoreTarget = 1000,
    SortId = 2
  },
  [3] = {
    CarouselContent = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mail/T_Head_Art_0027.T_Head_Art_0027'",
    CarouselTitle = "UI_PlayerHead_Name_30152",
    IsHeadshot = true,
    RewardId = 370003,
    RewardView = 370003,
    ScoreTarget = 2000,
    SortId = 3
  },
  [4] = {
    RewardId = 370004,
    ScoreTarget = 5000,
    SortId = 4
  },
  [5] = {
    RewardId = 370005,
    ScoreTarget = 10000,
    SortId = 5
  },
  [6] = {
    CarouselContent = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head_Frame/T_Head_Frame35.T_Head_Frame35'",
    CarouselTitle = "UI_HeadFrame_Name_10040",
    IsHeadshot = true,
    RewardId = 370006,
    RewardView = 370006,
    ScoreTarget = 20000,
    SortId = 6
  },
  [7] = {
    RewardId = 370007,
    ScoreTarget = 30000,
    SortId = 7
  },
  [8] = {
    RewardId = 370008,
    ScoreTarget = 40000,
    SortId = 8
  },
  [9] = {
    CarouselContent = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mail/T_Head_Art_0028.T_Head_Art_0028'",
    CarouselTitle = "UI_PlayerHead_Name_40002",
    IsHeadshot = true,
    RewardId = 370009,
    RewardView = 370009,
    ScoreTarget = 50000,
    SortId = 9
  },
  [10] = {
    RewardId = 370010,
    ScoreTarget = 60000,
    SortId = 10
  },
  [11] = {
    RewardId = 370011,
    ScoreTarget = 70000,
    SortId = 11
  },
  [12] = {
    CarouselContent = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/HeadFrame/T_Head_Frame35.T_Head_Frame35'",
    CarouselTitle = "UI_HeadFrame_Name_10041",
    IsHeadshot = true,
    RewardId = 370012,
    RewardView = 370012,
    ScoreTarget = 80000,
    SortId = 12
  }
})
