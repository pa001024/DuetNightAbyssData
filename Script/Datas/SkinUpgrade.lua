local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SkinUpgrade", {
  [150401] = {
    [2] = {
      SkinID = 150401,
      Step = 2,
      UnlockAmount = 54,
      UnlockCurrency = 1010
    },
    [3] = {
      SkinID = 150401,
      Step = 3,
      UnlockAmount = 72,
      UnlockCurrency = 1010
    }
  }
})
