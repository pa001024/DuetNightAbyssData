local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ClueReward", {
  [1] = {
    ClueTargetNum = 6,
    RewardID = 11000001,
    SortID = 1
  },
  [2] = {
    ClueTargetNum = 12,
    RewardID = 11000002,
    SortID = 2
  },
  [3] = {
    ClueTargetNum = 18,
    RewardID = 11000003,
    SortID = 3
  },
  [4] = {
    ClueTargetNum = 24,
    RewardID = 11000004,
    SortID = 4
  },
  [5] = {
    ClueTargetNum = 30,
    RewardID = 11000005,
    SortID = 5
  },
  [6] = {
    ClueTargetNum = 37,
    RewardID = 11000006,
    SortID = 6
  }
})
