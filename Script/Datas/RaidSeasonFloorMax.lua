local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaidSeasonFloorMax", {
  [1007] = {
    [1] = 180,
    [2] = 180
  }
})
