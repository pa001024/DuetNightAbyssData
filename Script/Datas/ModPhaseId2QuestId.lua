local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ModPhaseId2QuestId", {
  [1] = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5
  },
  [2] = {
    [1] = 6,
    [2] = 7,
    [3] = 8,
    [4] = 9,
    [5] = 10
  },
  [3] = {
    [1] = 11,
    [2] = 12,
    [3] = 13,
    [4] = 14
  },
  [4] = {
    [1] = 15,
    [2] = 16,
    [3] = 17,
    [4] = 18,
    [5] = 19,
    [6] = 20
  },
  [5] = {
    [1] = 21,
    [2] = 22,
    [3] = 23,
    [4] = 24,
    [5] = 25,
    [6] = 26
  }
})
