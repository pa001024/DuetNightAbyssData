local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProSeason", {
  [-1] = {
    ClassChooseTime = 60,
    ClassLockTime = 5,
    DifficultyId = {1},
    MRTCost = 50,
    MRTLimitTimes = 1,
    OuterShopTokenId = 215,
    SeasonEndTime = LocalTimeProxy(8204817600),
    SeasonId = -1,
    SeasonStartTime = LocalTimeProxy(1641009600),
    TokenId = 203,
    TokenTransform = 12.5
  },
  [1] = {
    ClassChooseTime = 60,
    ClassLockTime = 5,
    DifficultyId = {
      101,
      102,
      103,
      104,
      105,
      106
    },
    MRTCost = 20,
    MRTLimitTimes = 1,
    OuterShopTokenId = 215,
    SeasonEndTime = LocalTimeProxy(8204817600),
    SeasonId = 1,
    SeasonStartTime = LocalTimeProxy(1641009600),
    TokenId = 203,
    TokenTransform = 12.5
  }
})
