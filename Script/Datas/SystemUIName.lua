local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SystemUIName", {
  [102001] = {
    EventId = 102001,
    Title = "Event_Title_102001",
    UIName = "ActivityEastTask"
  },
  [102002] = {
    EventId = 102002,
    Title = "Event_Title_102002",
    UIName = "ActivityChezhanTask"
  },
  [1020012] = {
    EventId = 1020012,
    Title = "Event_Title_102001",
    UIName = "ActivityEastTask02"
  }
})
