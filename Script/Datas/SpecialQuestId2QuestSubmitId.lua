local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SpecialQuestId2QuestSubmitId", {
  [10040206] = {
    [1] = 10040231
  },
  [10040305] = {
    [1] = 10040305
  },
  [10040404] = {
    [1] = 10040404
  }
})
