local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionLotteryWeight", {
  [1] = {Quality = 1, Weight = 55},
  [2] = {Quality = 2, Weight = 40},
  [3] = {Quality = 3, Weight = 5}
})
