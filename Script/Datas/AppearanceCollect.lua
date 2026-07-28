local T = {}
T.RT_1 = {
  [1] = 371001,
  [2] = 371002,
  [3] = 371002
}
T.RT_2 = {
  [1] = 1,
  [2] = 5,
  [3] = 10
}
T.RT_3 = {
  [1] = 371001,
  [2] = 371003,
  [3] = 371003,
  [4] = 371003,
  [5] = 371003,
  [6] = 371003
}
T.RT_4 = {
  [1] = 1,
  [2] = 10,
  [3] = 20,
  [4] = 30,
  [5] = 40,
  [6] = 50
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
    QuantityReward = {
      [1] = 371001,
      [2] = 371003,
      [3] = 371003,
      [4] = 371003,
      [5] = 371003,
      [6] = 371003,
      [7] = 371003,
      [8] = 371003,
      [9] = 371003
    },
    QuantityTarget = {
      [1] = 1,
      [2] = 50,
      [3] = 100,
      [4] = 150,
      [5] = 200,
      [6] = 250,
      [7] = 300,
      [8] = 350,
      [9] = 400
    },
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
    QuantityReward = T.RT_3,
    QuantityTarget = T.RT_4,
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
    QuantityReward = T.RT_3,
    QuantityTarget = T.RT_4,
    SubTabId = {401, 402},
    Type = "WeaponAccessory"
  },
  [5] = {
    Entrance = 5,
    EntranceName = "UI_Mount",
    QuantityReward = T.RT_1,
    QuantityTarget = T.RT_2,
    SubTabId = {501},
    Type = "Mount"
  },
  [6] = {
    Entrance = 6,
    EntranceName = "UI_GestureItem",
    QuantityReward = T.RT_3,
    QuantityTarget = T.RT_4,
    SubTabId = {601},
    Type = "Resource"
  },
  [7] = {
    Entrance = 7,
    EntranceName = "UI_SHOP_SUBTAB_NAME_WEAPON",
    ExcludeCollect = true,
    SubTabId = {701},
    Type = "Weapon"
  }
})
