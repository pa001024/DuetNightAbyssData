local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionOnlineState", {
  [1] = {NumRange = 5, StateId = 1},
  [2] = {NumRange = 10, StateId = 2},
  [3] = {NumRange = 20, StateId = 3}
})
