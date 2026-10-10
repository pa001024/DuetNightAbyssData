local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonMain", {
  [1] = {
    D4SeasonId = 1,
    EndTime = LocalTimeProxy(8047051200),
    StartTime = LocalTimeProxy(1704081600)
  }
})
