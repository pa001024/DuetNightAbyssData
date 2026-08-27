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
    PBarAcc = 100,
    PBarGrowth = 40,
    PBarTotal = 100,
    PosNext = 20,
    RewardId = 7104,
    ShowSuccessToast = true
  },
  [2] = {
    AutoHack = true,
    ComboLimit = 0.2,
    ID = 2,
    KeyComboID = 102,
    NumCount = true,
    PBarAcc = 100,
    PBarGrowth = 50,
    PBarTotal = 200,
    PosNext = 30,
    RewardId = 7104,
    ShowSuccessToast = false
  },
  [801] = {
    AutoHack = true,
    ComboLimit = 0.2,
    ID = 801,
    KeyComboID = 801,
    NumCount = false,
    PBarAcc = 100,
    PBarGrowth = 50,
    PBarTotal = 200,
    PosNext = 30,
    RewardId = 7104,
    ShowSuccessToast = false
  },
  [802] = {
    AutoHack = true,
    ComboLimit = 0.2,
    ID = 802,
    KeyComboID = 802,
    NumCount = false,
    PBarAcc = 100,
    PBarGrowth = 60,
    PBarTotal = 300,
    PosNext = 40,
    RewardId = 7104,
    ShowSuccessToast = false
  },
  [803] = {
    AutoHack = true,
    ComboLimit = 0.2,
    ID = 803,
    KeyComboID = 803,
    NumCount = false,
    PBarAcc = 100,
    PBarGrowth = 75,
    PBarTotal = 400,
    PosNext = 50,
    RewardId = 7104,
    ShowSuccessToast = false
  },
  [804] = {
    AutoHack = true,
    ComboLimit = 0.2,
    ID = 804,
    KeyComboID = 804,
    NumCount = false,
    PBarAcc = 100,
    PBarGrowth = 100,
    PBarTotal = 500,
    PosNext = 60,
    RewardId = 7104,
    ShowSuccessToast = false
  }
})
