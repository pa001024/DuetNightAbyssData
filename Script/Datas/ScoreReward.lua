local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ScoreReward", {
  [1] = {
    RewardId = 51701,
    ScoreTarget = 10,
    SortId = 1
  },
  [2] = {
    RewardId = 51702,
    ScoreTarget = 50,
    SortId = 2
  },
  [3] = {
    RewardId = 51703,
    ScoreTarget = 100,
    SortId = 3
  },
  [4] = {
    RewardId = 51704,
    ScoreTarget = 200,
    SortId = 4
  },
  [5] = {
    CarouselTitle = "textmap1",
    RewardId = 51705,
    RewardView = 1016,
    ScoreTarget = 300,
    SortId = 5
  },
  [6] = {
    RewardId = 51701,
    ScoreTarget = 400,
    SortId = 6
  },
  [7] = {
    RewardId = 51702,
    ScoreTarget = 500,
    SortId = 7
  },
  [8] = {
    RewardId = 51703,
    ScoreTarget = 1000,
    SortId = 8
  },
  [9] = {
    RewardId = 51704,
    ScoreTarget = 8000,
    SortId = 9
  },
  [10] = {
    CarouselTitle = "textmap2",
    IsHeadshot = true,
    RewardId = 51705,
    RewardView = 1017,
    ScoreTarget = 9999,
    SortId = 10
  }
})
