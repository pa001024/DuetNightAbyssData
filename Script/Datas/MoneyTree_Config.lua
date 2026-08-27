local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MoneyTree_Config", {
  [103029] = {
    ActivityDescKey = "Event_Des_103029",
    ActivityNameKey = "Event_Title_103029",
    ActivityRuleKey = "Event_Rule_103029",
    AllDoubleGoodsId = "com.hero.dna.Pay_MoneyTree_All_Test",
    DailyFreeCount = 1,
    EventId = 103029,
    Id = 103029,
    SingleDoubleGoodsId = "com.hero.dna.Pay_MoneyTree_Single_Test",
    TotalDays = 21
  }
})
