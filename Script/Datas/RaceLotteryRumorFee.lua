local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaceLotteryRumorFee", {
  [1] = {RumorInquireFee = 500, RumorInquireTime = 1},
  [2] = {RumorInquireFee = 1000, RumorInquireTime = 2},
  [3] = {RumorInquireFee = 1500, RumorInquireTime = 3},
  [4] = {RumorInquireFee = 2000, RumorInquireTime = 4},
  [5] = {RumorInquireFee = 3000, RumorInquireTime = 5},
  [6] = {RumorInquireFee = 5000, RumorInquireTime = 6},
  [7] = {RumorInquireFee = 10000, RumorInquireTime = 7},
  [8] = {RumorInquireFee = 20000, RumorInquireTime = 8},
  [9] = {RumorInquireFee = 40000, RumorInquireTime = 9},
  [10] = {RumorInquireFee = 80000, RumorInquireTime = 10}
})
