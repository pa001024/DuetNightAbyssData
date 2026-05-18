local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestId2QuestSubmitId", {
  [10040404] = {
    [1] = 10040404
  },
  [20023801] = {
    [1] = 20023801
  },
  [20023901] = {
    [1] = 20023901
  },
  [20024001] = {
    [1] = 20024001
  }
})
