local T = {}
T.RT_1 = {}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceCollectType2Entrance", {
  CharAccessory = {
    CollectType = "CharAccessory",
    EntranceId = 2,
    FieldName = "AccessoryType",
    SubTypes = {
      Back = 2,
      FX_Body = 2,
      FX_Dead = 2,
      FX_Footprint = 2,
      FX_HelixLeap = 2,
      FX_PlungingATK = 2,
      FX_Teleport = 2,
      Face = 2,
      Hat = 2,
      Head = 2,
      MVP = 2,
      Tail = 2,
      Waist = 2
    }
  },
  Hair = {
    CollectType = "CharAccessory",
    EntranceId = 2,
    SubTypes = T.RT_1
  },
  Mount = {
    CollectType = "Mount",
    EntranceId = 5,
    SubTypes = T.RT_1
  },
  Resource = {
    CollectType = "Resource",
    EntranceId = 6,
    FieldName = "ResourceSType",
    SubTypes = {GestureItem = 6}
  },
  Skin = {
    CollectType = "Skin",
    EntranceId = 1,
    SubTypes = T.RT_1
  },
  WeaponAccessory = {
    CollectType = "WeaponAccessory",
    EntranceId = 4,
    FieldName = "StanceFXType",
    SubTypes = {
      Accessory = 4,
      HeavyAttack = 4,
      RunAttack = 4
    }
  },
  WeaponSkin = {
    CollectType = "WeaponSkin",
    EntranceId = 3,
    FieldName = "ApplicationType",
    SubTypes = {
      ["101"] = 3,
      ["102"] = 3,
      ["103"] = 3,
      ["104"] = 3,
      ["105"] = 3,
      ["106"] = 3,
      ["201"] = 3,
      ["202"] = 3,
      ["203"] = 3,
      ["204"] = 3,
      ["205"] = 3,
      ["206"] = 3,
      ["207"] = 3
    }
  }
})
