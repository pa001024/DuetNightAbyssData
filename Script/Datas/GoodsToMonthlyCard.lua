local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GoodsToMonthlyCard", {
  ["com.hero.dna.Pay_107"] = {
    [1] = 10013,
    [2] = 10014,
    [3] = 10015,
    [4] = 10016,
    [5] = 10017,
    [6] = 10001,
    [7] = 10002,
    [8] = 10003,
    [9] = 10004,
    [10] = 10005,
    [11] = 10006,
    [12] = 10007,
    [13] = 10008,
    [14] = 10009,
    [15] = 10010,
    [16] = 10011,
    [17] = 10012
  }
})
