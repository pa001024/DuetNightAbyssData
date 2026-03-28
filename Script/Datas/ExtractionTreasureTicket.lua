local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureTicket", {
  [92001] = {
    MechanismID = 92001,
    MechanismName = "扭蛋机1",
    RenewalPoint = {
      2000,
      2000,
      2000,
      2000,
      2000,
      4000,
      4000,
      4000,
      4000,
      4000,
      8000,
      8000,
      8000,
      8000,
      8000,
      16000,
      16000,
      16000,
      16000,
      20000
    },
    UnlockPoint = 1000
  }
})
