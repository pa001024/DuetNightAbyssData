local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceSingleScore", {
  [1] = {
    Id = 41042,
    Score = 1,
    SingleScoreId = 1,
    Type = "Resource"
  },
  [2] = {
    Id = 1601,
    Score = 0,
    SingleScoreId = 2,
    Type = "Skin"
  },
  [3] = {
    Id = 160101,
    Score = 0,
    SingleScoreId = 3,
    Type = "Skin"
  }
})
