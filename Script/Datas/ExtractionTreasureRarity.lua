local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureRarity", {
  [1] = {IdentifyTime = 0.3, TreasureRarity = 1},
  [2] = {IdentifyTime = 0.3, TreasureRarity = 2},
  [3] = {IdentifyTime = 0.6, TreasureRarity = 3},
  [4] = {IdentifyTime = 1, TreasureRarity = 4},
  [5] = {IdentifyTime = 2, TreasureRarity = 5},
  [6] = {IdentifyTime = 3, TreasureRarity = 6}
})
