local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("WeaponVerifyEventBuff", {
  [1001] = {
    BuffId = 1001,
    Desc = "WeaponVerify_GlobalBuff01"
  },
  [1002] = {
    BuffId = 1002,
    Desc = "WeaponVerify_GlobalBuff02"
  },
  [1003] = {
    BuffId = 1003,
    Desc = "WeaponVerify_GlobalBuff03"
  },
  [2001] = {
    BuffId = 2001,
    Desc = "WeaponVerify_LevelBuff01"
  },
  [2002] = {
    BuffId = 2002,
    Desc = "WeaponVerify_LevelBuff02"
  },
  [2003] = {
    BuffId = 2003,
    Desc = "WeaponVerify_LevelBuff03"
  },
  [2004] = {
    BuffId = 2004,
    Desc = "WeaponVerify_LevelBuff04"
  },
  [2005] = {
    BuffId = 2005,
    Desc = "WeaponVerify_LevelBuff05"
  },
  [2006] = {
    BuffId = 2006,
    Desc = "WeaponVerify_LevelBuff06"
  }
})
