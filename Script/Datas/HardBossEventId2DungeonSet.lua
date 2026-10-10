local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HardBossEventId2DungeonSet", {
  [103036] = {
    [28001] = true,
    [28002] = true,
    [28003] = true,
    [28004] = true,
    [28005] = true,
    [28006] = true,
    [28007] = true,
    [28008] = true,
    [28009] = true,
    [28010] = true
  }
})
