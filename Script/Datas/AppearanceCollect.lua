local T = {}
T.RT_1 = {
  [1] = 7000,
  [2] = 7000,
  [3] = 7000
}
T.RT_2 = {
  [1] = 1,
  [2] = 5,
  [3] = 20
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceCollect", {
  [1] = {
    Entrance = 1,
    EntranceName = "UI_Char_Skin",
    QuantityReward = T.RT_1,
    QuantityTarget = T.RT_2,
    SubTabId = {101},
    Type = "Skin"
  },
  [2] = {
    Entrance = 2,
    EntranceName = "UI_Char_Accessory",
    QuantityReward = T.RT_1,
    QuantityTarget = T.RT_2,
    SubTabId = {
      201,
      202,
      203,
      204,
      205,
      206,
      207,
      208,
      209,
      210,
      211,
      212,
      213,
      214
    },
    Type = "CharAccessory"
  },
  [3] = {
    Entrance = 3,
    EntranceName = "UI_Weapon_Skin",
    QuantityReward = T.RT_1,
    QuantityTarget = T.RT_2,
    SubTabId = {
      301,
      302,
      303,
      304,
      305,
      306,
      307,
      308,
      309,
      310,
      311,
      312,
      313
    },
    Type = "WeaponSkin"
  },
  [4] = {
    Entrance = 4,
    EntranceName = "UI_Weapon_Accessory",
    QuantityReward = T.RT_1,
    QuantityTarget = T.RT_2,
    SubTabId = {401, 402},
    Type = "WeaponAccessory"
  },
  [5] = {
    Entrance = 5,
    EntranceName = "UI_Mount",
    QuantityReward = {
      [1] = 7000,
      [2] = 7000
    },
    QuantityTarget = {
      [1] = 1,
      [2] = 5
    },
    SubTabId = {501},
    Type = "Mount"
  },
  [6] = {
    Entrance = 6,
    EntranceName = "UI_GestureItem",
    QuantityReward = T.RT_1,
    QuantityTarget = T.RT_2,
    SubTabId = {601},
    Type = "Resource"
  }
})
