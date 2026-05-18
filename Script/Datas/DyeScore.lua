local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DyeScore", {
  [1] = {
    MaxScore = 100,
    ResourceId = {
      30101,
      30102,
      30103,
      30104,
      30105,
      30106,
      30107,
      30108,
      30109,
      30110,
      30111,
      30112,
      30113,
      30114,
      30115,
      30116,
      30117,
      30118,
      30119
    },
    ScoreId = 1,
    ScorePerUse = 10
  }
})
