local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HammerID", {
  [1] = {
    AutoHack = false,
    ComboLimit = 0.15,
    ID = 1,
    KeyComboID = 101,
    NumCount = true,
    PBarAcc = 10,
    PBarGrowth = 50,
    PBarTotal = 100,
    PosNext = 30,
    RewardId = 7104,
    ShowStrikeCount = true
  }
})
