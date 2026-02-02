local T = {}
T.RT_1 = {
  [1] = 160133,
  [2] = 160319
}
T.RT_2 = {
  [1] = 160132,
  [2] = 160318
}
T.RT_3 = {
  [1] = 160118,
  [2] = 160317
}
T.RT_4 = {
  [1] = 160111,
  [2] = 160316
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RexclusionGroup2ShopItem", {
  [120224] = {
    [1] = 120224,
    [2] = 160125
  },
  [120311] = {
    [1] = 120311,
    [2] = 160125
  },
  [120412] = {
    [1] = 120412,
    [2] = 160125
  },
  [120509] = {
    [1] = 120509,
    [2] = 160125
  },
  [160111] = T.RT_4,
  [160118] = T.RT_3,
  [160132] = T.RT_2,
  [160133] = T.RT_1,
  [160316] = T.RT_4,
  [160317] = T.RT_3,
  [160318] = T.RT_2,
  [160319] = T.RT_1
})
