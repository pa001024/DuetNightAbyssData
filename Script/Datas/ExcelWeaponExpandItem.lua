local T = {}
T.RT_1 = {
  [1] = 500000,
  [2] = 6,
  [3] = 2
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExcelWeaponExpandItem", {
  Bow = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15023
    },
    ItemNum = T.RT_1,
    WeaponTag = "Bow"
  },
  Cannon = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15021
    },
    ItemNum = T.RT_1,
    WeaponTag = "Cannon"
  },
  Claymore = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15018
    },
    ItemNum = T.RT_1,
    WeaponTag = "Claymore"
  },
  Crossbow = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15016
    },
    ItemNum = T.RT_1,
    WeaponTag = "Crossbow"
  },
  Dualblade = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15024
    },
    ItemNum = T.RT_1,
    WeaponTag = "Dualblade"
  },
  Katana = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15020
    },
    ItemNum = T.RT_1,
    WeaponTag = "Katana"
  },
  Machinegun = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15015
    },
    ItemNum = T.RT_1,
    WeaponTag = "Machinegun"
  },
  Pistol = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15025
    },
    ItemNum = T.RT_1,
    WeaponTag = "Pistol"
  },
  Polearm = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15014
    },
    ItemNum = T.RT_1,
    WeaponTag = "Polearm"
  },
  Shotgun = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15022
    },
    ItemNum = T.RT_1,
    WeaponTag = "Shotgun"
  },
  Sword = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15017
    },
    ItemNum = T.RT_1,
    WeaponTag = "Sword"
  },
  Swordwhip = {
    ItemId = {
      [1] = 101,
      [2] = 202,
      [3] = 15019
    },
    ItemNum = T.RT_1,
    WeaponTag = "Swordwhip"
  }
})
