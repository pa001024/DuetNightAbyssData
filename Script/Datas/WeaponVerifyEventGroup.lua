local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("WeaponVerifyEventGroup", {
  [1001] = {
    AffixGroup = {
      1,
      2,
      3,
      4,
      5
    },
    GroupId = 1001
  },
  [1002] = {
    AffixGroup = {
      6,
      7,
      8,
      9,
      10
    },
    GroupId = 1002
  },
  [1003] = {
    AffixGroup = {
      11,
      12,
      13,
      14,
      15
    },
    GroupId = 1003
  }
})
