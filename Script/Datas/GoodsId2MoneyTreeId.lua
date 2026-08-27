local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GoodsId2MoneyTreeId", {
  ["com.hero.dna.Pay_MoneyTree_All_Test"] = 103029,
  ["com.hero.dna.Pay_MoneyTree_Single_Test"] = 103029
})
