local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProDifficulty", {
  [1] = {
    CompleteScore = 0,
    EndPointsRate = 1,
    ID = 1,
    RecommendLevel = 0,
    RoomLevel = {10},
    UnlockLevel = 0
  },
  [101] = {
    CompleteScore = 3000,
    EndPointsRate = 1,
    ID = 101,
    RecommendLevel = 30,
    RoomLevel = {30},
    UnlockLevel = 15
  },
  [102] = {
    CompleteScore = 4500,
    EndPointsRate = 1,
    ID = 102,
    RecommendLevel = 40,
    RoomLevel = {40},
    UnlockLevel = 25
  },
  [103] = {
    CompleteScore = 6500,
    EndPointsRate = 1,
    ID = 103,
    RecommendLevel = 50,
    RoomLevel = {50},
    UnlockLevel = 35
  },
  [104] = {
    CompleteScore = 9500,
    EndPointsRate = 1,
    ID = 104,
    RecommendLevel = 60,
    RoomLevel = {60},
    UnlockLevel = 45
  },
  [105] = {
    CompleteScore = 14000,
    EndPointsRate = 1,
    ID = 105,
    RecommendLevel = 70,
    RoomLevel = {70},
    UnlockLevel = 55
  },
  [106] = {
    CompleteScore = 22000,
    EndPointsRate = 1,
    ID = 106,
    RecommendLevel = 80,
    RoomLevel = {80},
    UnlockLevel = 60
  }
})
