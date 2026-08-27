local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("FirstBonusNum", {
  [110101] = {
    BonusNum = 0,
    FirstBonusNum = 60,
    ItemId = 110101,
    ResetCheck = true
  },
  [110102] = {
    BonusNum = 40,
    FirstBonusNum = 300,
    ItemId = 110102,
    ResetCheck = true
  },
  [110103] = {
    BonusNum = 150,
    FirstBonusNum = 980,
    ItemId = 110103,
    ResetCheck = true
  },
  [110104] = {
    BonusNum = 320,
    FirstBonusNum = 1980,
    ItemId = 110104,
    ResetCheck = true
  },
  [110105] = {
    BonusNum = 720,
    FirstBonusNum = 3280,
    ItemId = 110105,
    ResetCheck = true
  },
  [110106] = {
    BonusNum = 1680,
    FirstBonusNum = 6480,
    ItemId = 110106,
    ResetCheck = true
  },
  [110107] = {
    BonusNum = 3340,
    FirstBonusNum = 3340,
    ItemId = 110107
  },
  [110108] = {
    BonusNum = 8550,
    FirstBonusNum = 8550,
    ItemId = 110108
  }
})
