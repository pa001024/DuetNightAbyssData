local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipConstant", {
  [1] = {
    AncientAffixRate = 1,
    BaseAffixRate = 1,
    BaseAffixReduce = 1,
    RandomAffixReduce = 1,
    SeasonId = 1
  },
  [2] = {
    AncientAffixRate = 1,
    BaseAffixRate = 1,
    BaseAffixReduce = 1,
    RandomAffixReduce = 1,
    SeasonId = 2
  },
  [3] = {
    AncientAffixRate = 1,
    BaseAffixRate = 1,
    BaseAffixReduce = 1,
    RandomAffixReduce = 1,
    SeasonId = 3
  }
})
