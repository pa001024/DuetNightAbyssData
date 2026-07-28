local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceSubTab", {
  [101] = {
    Entrance = 101,
    Name = "UI_Char_Skin",
    ParentIndex = "Skin",
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Clothing.T_Tab_Fashion_Clothing'"
  },
  [201] = {
    Entrance = 201,
    Name = "UI_Hair_Name",
    ParentIndex = "Hair",
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Hair.T_Tab_Fashion_Hair'"
  },
  [202] = {
    Entrance = 202,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_MVP",
    ParentIndex = "CharAccessory",
    SubType = {"MVP"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_MVP.T_Tab_Fashion_MVP'"
  },
  [203] = {
    Entrance = 203,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_Hat",
    ParentIndex = "CharAccessory",
    SubType = {"Hat"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Hat.T_Tab_Fashion_Hat'"
  },
  [204] = {
    Entrance = 204,
    FieldName = "AccessoryType",
    Name = "UI_SHOP_MAINTAB_ACCESSORY_Head",
    ParentIndex = "CharAccessory",
    SubType = {"Head"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Head.T_Tab_Fashion_Head'"
  },
  [205] = {
    Entrance = 205,
    FieldName = "AccessoryType",
    Name = "UI_SHOP_MAINTAB_ACCESSORY_Face",
    ParentIndex = "CharAccessory",
    SubType = {"Face"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Face.T_Tab_Fashion_Face'"
  },
  [206] = {
    Entrance = 206,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_Back",
    ParentIndex = "CharAccessory",
    SubType = {"Back"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Back.T_Tab_Fashion_Back'"
  },
  [207] = {
    Entrance = 207,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_Tail",
    ParentIndex = "CharAccessory",
    SubType = {"Tail"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Tail.T_Tab_Fashion_Tail'"
  },
  [208] = {
    Entrance = 208,
    FieldName = "AccessoryType",
    Name = "UI_SHOP_MAINTAB_ACCESSORY_Waist",
    ParentIndex = "CharAccessory",
    SubType = {"Waist"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Waist.T_Tab_Fashion_Waist'"
  },
  [209] = {
    Entrance = 209,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_FX_Teleport",
    ParentIndex = "CharAccessory",
    SubType = {
      "FX_Teleport"
    },
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_FX_Teleport.T_Tab_Fashion_FX_Teleport'"
  },
  [210] = {
    Entrance = 210,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_FX_Footprint",
    ParentIndex = "CharAccessory",
    SubType = {
      "FX_Footprint"
    },
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_FX_Footprint.T_Tab_Fashion_FX_Footprint'"
  },
  [211] = {
    Entrance = 211,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_FX_Body",
    ParentIndex = "CharAccessory",
    SubType = {"FX_Body"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_FX_Body.T_Tab_Fashion_FX_Body'"
  },
  [212] = {
    Entrance = 212,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_FX_PlungingATK",
    ParentIndex = "CharAccessory",
    SubType = {
      "FX_PlungingATK"
    },
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_FX_PlungingATK.T_Tab_Fashion_FX_PlungingATK'"
  },
  [213] = {
    Entrance = 213,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_FX_HelixLeap",
    ParentIndex = "CharAccessory",
    SubType = {
      "FX_HelixLeap"
    },
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_FX_HelixLeap.T_Tab_Fashion_FX_HelixLeap'"
  },
  [214] = {
    Entrance = 214,
    FieldName = "AccessoryType",
    Name = "UI_SkinPreview_Accessory_FX_Dead",
    ParentIndex = "CharAccessory",
    SubType = {"FX_Dead"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_FX_Dead.T_Tab_Fashion_FX_Dead'"
  },
  [301] = {
    Entrance = 301,
    FieldName = "ApplicationType",
    Name = "WeaponType_Claymore",
    ParentIndex = "WeaponSkin",
    SubType = {"103"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Claymore.T_Armory_WeaponType_Claymore"
  },
  [302] = {
    Entrance = 302,
    FieldName = "ApplicationType",
    Name = "WeaponType_Dualblade",
    ParentIndex = "WeaponSkin",
    SubType = {"104"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Dualblade.T_Armory_WeaponType_Dualblade"
  },
  [303] = {
    Entrance = 303,
    FieldName = "ApplicationType",
    Name = "WeaponType_Katana",
    ParentIndex = "WeaponSkin",
    SubType = {"106"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Katana.T_Armory_WeaponType_Katana"
  },
  [304] = {
    Entrance = 304,
    FieldName = "ApplicationType",
    Name = "WeaponType_Polearm",
    ParentIndex = "WeaponSkin",
    SubType = {"102"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Polearm.T_Armory_WeaponType_Polearm"
  },
  [305] = {
    Entrance = 305,
    FieldName = "ApplicationType",
    Name = "WeaponType_Sword",
    ParentIndex = "WeaponSkin",
    SubType = {"101"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Sword.T_Armory_WeaponType_Sword"
  },
  [306] = {
    Entrance = 306,
    FieldName = "ApplicationType",
    Name = "WeaponType_Swordwhip",
    ParentIndex = "WeaponSkin",
    SubType = {"105"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Swordwhip.T_Armory_WeaponType_Swordwhip"
  },
  [307] = {
    Entrance = 307,
    FieldName = "ApplicationType",
    Name = "WeaponType_Bow02",
    ParentIndex = "WeaponSkin",
    SubType = {"207"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Bow.T_Armory_WeaponType_Bow"
  },
  [308] = {
    Entrance = 308,
    FieldName = "ApplicationType",
    Name = "WeaponType_Bow01",
    ParentIndex = "WeaponSkin",
    SubType = {"206"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Bow.T_Armory_WeaponType_Bow"
  },
  [309] = {
    Entrance = 309,
    FieldName = "ApplicationType",
    Name = "WeaponType_Cannon",
    ParentIndex = "WeaponSkin",
    SubType = {"203"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Cannon.T_Armory_WeaponType_Cannon"
  },
  [310] = {
    Entrance = 310,
    FieldName = "ApplicationType",
    Name = "WeaponType_Crossbow",
    ParentIndex = "WeaponSkin",
    SubType = {"202"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Crossbow.T_Armory_WeaponType_Crossbow"
  },
  [311] = {
    Entrance = 311,
    FieldName = "ApplicationType",
    Name = "WeaponType_Machinegun",
    ParentIndex = "WeaponSkin",
    SubType = {"205"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Machinegun.T_Armory_WeaponType_Machinegun"
  },
  [312] = {
    Entrance = 312,
    FieldName = "ApplicationType",
    Name = "WeaponType_Pistol",
    ParentIndex = "WeaponSkin",
    SubType = {"201"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Pistol.T_Armory_WeaponType_Pistol"
  },
  [313] = {
    Entrance = 313,
    FieldName = "ApplicationType",
    Name = "WeaponType_Shotgun",
    ParentIndex = "WeaponSkin",
    SubType = {"204"},
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_WeaponType_Shotgun.T_Armory_WeaponType_Shotgun"
  },
  [401] = {
    Entrance = 401,
    FieldName = "StanceFXType",
    Name = "UI_SHOP_MAINTAB_ACCESSORY_WEAPON",
    ParentIndex = "WeaponAccessory",
    SubType = {"Accessory"},
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Accessory.T_Tab_Accessory'"
  },
  [402] = {
    Entrance = 402,
    FieldName = "StanceFXType",
    Name = "UI_Accessory_Stance_Name",
    ParentIndex = "WeaponAccessory",
    SubType = {
      "RunAttack",
      "HeavyAttack"
    },
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Fx.T_Tab_Fashion_Fx'"
  },
  [501] = {
    Entrance = 501,
    Name = "UI_Mount",
    ParentIndex = "Mount",
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Mounts.T_Tab_Mounts'"
  },
  [601] = {
    Entrance = 601,
    FieldName = "ResourceSType",
    Name = "UI_GestureItem",
    ParentIndex = "Resource",
    SubType = {
      "GestureItem"
    },
    TabIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Action.T_Tab_Action'"
  },
  [701] = {
    Entrance = 701,
    Name = "UI_SHOP_SUBTAB_NAME_WEAPON",
    ParentIndex = "Weapon",
    TabIcon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_CloseIn_Weapons"
  }
})
