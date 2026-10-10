local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipInlay", {
  [5001] = {
    BuffId = 7001,
    InlayId = 5001,
    InlayType = 0
  },
  [5002] = {InlayId = 5002, InlayType = 1},
  [5101] = {BuffId = 7201, InlayId = 5101}
})
