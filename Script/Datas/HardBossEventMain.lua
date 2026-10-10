local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HardBossEventMain", {
  [103036] = {
    EventId = 103036,
    HardBossId = {
      1,
      2,
      3,
      4,
      5
    },
    PeriodRewardTime = 20,
    PeriodRewardType = "Week"
  }
})
