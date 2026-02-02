local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureType", {
  [1] = {TreasureRarity = 1},
  [2] = {TreasureRarity = 2},
  [3] = {TreasureRarity = 3},
  [4] = {TreasureRarity = 4}
})
