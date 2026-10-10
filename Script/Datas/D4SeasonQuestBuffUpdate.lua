local T = {}
T.RT_1 = {
  [1] = 101
}
T.RT_2 = {
  [1] = 100
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonQuestBuffUpdate", {
  [10302701] = {
    D4SeasonBuffLevel = 1,
    D4SeasonBuffType = "MaxES",
    D4SeasonBuffUpdateId = 10302701,
    D4SeasonDropBonusId = 1,
    D4SeasonDropBonusRate = 3000,
    D4SeasonId = 103027,
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2
  },
  [10302702] = {
    D4SeasonBuffLevel = 2,
    D4SeasonBuffType = "MaxES",
    D4SeasonBuffUpdateId = 10302702,
    D4SeasonDropBonusId = 1,
    D4SeasonDropBonusRate = 5000,
    D4SeasonId = 103027,
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2
  },
  [10302703] = {
    D4SeasonBuffLevel = 3,
    D4SeasonBuffType = "MaxES",
    D4SeasonBuffUpdateId = 10302703,
    D4SeasonDropBonusId = 1,
    D4SeasonDropBonusRate = 10000,
    D4SeasonId = 103027,
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2
  },
  [10302704] = {
    D4SeasonBuffLevel = 4,
    D4SeasonBuffType = "MaxES",
    D4SeasonBuffUpdateId = 10302704,
    D4SeasonDropBonusId = 1,
    D4SeasonDropBonusRate = 15000,
    D4SeasonId = 103027,
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2
  }
})
