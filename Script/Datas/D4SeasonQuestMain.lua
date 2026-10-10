local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonQuestMain", {
  [103027] = {
    D4SeasonID = 103027,
    PhaseCoreQuest = {
      [1001] = 100101,
      [1002] = 100201,
      [1003] = 100301
    },
    RelatedEventId = 103027,
    ShopJumpId = 101
  }
})
