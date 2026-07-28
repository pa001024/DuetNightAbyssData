local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PopupPack", {
  [1] = {
    Desc = "Pack_Desc_PopupPack1",
    DisplayPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ01.T_Gacha_GiftPop_JJ01'",
    Duration = 120,
    MaxTrigger = 3,
    Name = "Pack_Name_PopupPack1",
    PopupPackId = 1,
    ShopItemId = 990001,
    TabId = 7
  },
  [2] = {
    Desc = "Pack_Desc_PopupPack2",
    DisplayPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ03.T_Gacha_GiftPop_JJ03'",
    Duration = 120,
    MaxTrigger = 3,
    Name = "Pack_Name_PopupPack2",
    PopupPackId = 2,
    ShopItemId = 990002,
    TabId = 7
  },
  [3] = {
    Desc = "Pack_Desc_PopupPack3",
    DisplayPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ04.T_Gacha_GiftPop_JJ04'",
    Duration = 120,
    MaxTrigger = 3,
    Name = "Pack_Name_PopupPack3",
    PopupPackId = 3,
    ShopItemId = 990003,
    TabId = 7
  },
  [4] = {
    Desc = "Pack_Desc_PopupPack",
    DisplayPath = "/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ01.T_Gacha_GiftPop_JJ01",
    Duration = 2,
    MaxTrigger = 1,
    Name = "Pack_Name_PopupPack",
    PopupPackId = 4,
    ShopItemId = 990004,
    TabId = 1
  },
  [5] = {
    Desc = "Pack_Desc_PopupPack",
    DisplayPath = "/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ01.T_Gacha_GiftPop_JJ01",
    Duration = 2,
    MaxTrigger = 1,
    Name = "Pack_Name_PopupPack",
    PopupPackId = 5,
    ShopItemId = 990005,
    TabId = 2
  },
  [6] = {
    Desc = "Pack_Desc_PopupPack",
    DisplayPath = "/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ01.T_Gacha_GiftPop_JJ01",
    Duration = 5,
    MaxTrigger = 1,
    Name = "Pack_Name_PopupPack",
    PopupPackId = 6,
    ShopItemId = 990006,
    TabId = 2
  },
  [7] = {
    Desc = "Pack_Desc_PopupPack",
    DisplayPath = "/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ01.T_Gacha_GiftPop_JJ01",
    Duration = 2,
    MaxTrigger = 1,
    Name = "Pack_Name_PopupPack",
    PopupPackId = 7,
    ShopItemId = 990007,
    TabId = 6
  },
  [8] = {
    Desc = "Pack_Desc_PopupPack",
    DisplayPath = "/Game/UI/Texture/Dynamic/Image/Gacha/SingleIcon/T_Gacha_GiftPop_JJ01.T_Gacha_GiftPop_JJ01",
    Duration = 5,
    MaxTrigger = 1,
    Name = "Pack_Name_PopupPack",
    PopupPackId = 8,
    ShopItemId = 990008,
    TabId = 6
  }
})
