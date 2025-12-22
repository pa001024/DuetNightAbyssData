local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("EventId2RaidSeason", {
  [111001] = {
    EventEndTime = 1770584400,
    EventId = 111001,
    EventStartTime = 1769133600,
    RaidSeasonId = 1001
  }
})
