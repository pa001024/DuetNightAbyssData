local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SabotagePlus", {
  [91801] = {
    DungeonId = 91801,
    TargetDestroyNum = 4,
    TargetKillNum = 100,
    TimeLimit = 180
  }
})
