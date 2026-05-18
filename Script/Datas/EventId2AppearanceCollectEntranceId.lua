local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("EventId2AppearanceCollectEntranceId", {
  [103024] = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5
  },
  [999999] = {
    [1] = 6,
    [2] = 7,
    [3] = 8,
    [4] = 9,
    [5] = 10,
    [6] = 11,
    [7] = 12,
    [8] = 13,
    [9] = 14,
    [10] = 15
  }
})
