local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonDropBonus", {
  [1] = {
    DropBonusId = 1,
    DropBonusParam = {"10001", "10002"},
    DropBonusType = "ResourceId"
  }
})
