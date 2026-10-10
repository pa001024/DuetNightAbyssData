local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipIcon", {
  [1001] = {EquipSlot = 1, IconId = 1001},
  [1002] = {EquipSlot = 2, IconId = 1002}
})
