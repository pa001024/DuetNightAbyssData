local T = {}
T.RT_1 = {
  [1] = 100,
  [2] = 100
}
T.RT_2 = {
  [1] = 8,
  [2] = 8
}
T.RT_3 = {
  [1] = 1,
  [2] = 1
}
T.RT_4 = {102103}
T.RT_5 = {
  [1] = 40,
  [2] = 40
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonEquipAffix", {
  [101] = {
    AffixBuffId = 7001,
    AffixId = 101,
    AffixPoolId = 1,
    MaxValue = {
      [1] = 199,
      [2] = 199
    },
    MinValue = T.RT_1,
    TotalValueLevel = T.RT_1
  },
  [102] = {
    AffixBuffId = 7002,
    AffixId = 102,
    AffixPoolId = 2,
    MaxValue = {
      [1] = 399,
      [2] = 399
    },
    MinValue = {
      [1] = 200,
      [2] = 200
    },
    RexclusionAffixId = T.RT_4,
    TotalValueLevel = {
      [1] = 2000,
      [2] = 2000
    }
  },
  [103] = {
    AffixBuffId = 7003,
    AffixId = 103,
    AffixPoolId = 2,
    MaxValue = {
      [1] = 849,
      [2] = 849
    },
    MinValue = {
      [1] = 400,
      [2] = 400
    },
    RexclusionAffixId = T.RT_4,
    TotalValueLevel = {
      [1] = 900,
      [2] = 900
    }
  },
  [201] = {
    AffixBuffId = 7004,
    AffixId = 201,
    MaxValue = T.RT_1,
    MinValue = T.RT_1
  },
  [301] = {
    AffixBuffId = 7005,
    AffixId = 301,
    MaxValue = T.RT_5,
    MinValue = T.RT_5,
    TotalValueLevel = T.RT_3
  },
  [1011] = {
    AffixBuffId = 7001,
    AffixId = 1011,
    AffixPoolId = 1,
    MaxValue = T.RT_2,
    MinValue = T.RT_3,
    TotalValueLevel = T.RT_2
  }
})
