local T = {}
T.RT_1 = {
  0,
  0,
  90
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomItem", {
  [1001] = {
    FunctionDes = "CustomItem_Des_Normal",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_Item_0002.T_PersonalInfo_Item_0002'",
    IsDefaultUnlock = true,
    ItemId = 1001,
    Name = "CustomItem_Name_1001",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_City/Mesh/SM_Bar_Pail01B.SM_Bar_Pail01B'",
    Rarity = 1,
    Scale = 1.3
  },
  [1002] = {
    DefaultRotation = T.RT_1,
    FunctionDes = "CustomItem_Des_Normal",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_Item_0006.T_PersonalInfo_Item_0006'",
    IsDefaultUnlock = true,
    ItemId = 1002,
    Name = "CustomItem_Name_1002",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Home/Mesh/SM_Home_Cha01.SM_Home_Cha01'",
    Rarity = 3
  },
  [1003] = {
    DefaultRotation = T.RT_1,
    FunctionDes = "CustomItem_Des_Normal",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_Item_0003.T_PersonalInfo_Item_0003'",
    IsDefaultUnlock = true,
    ItemId = 1003,
    Name = "CustomItem_Name_1003",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Carnival/Mesh/SM_Carn_Sig03.SM_Carn_Sig03'",
    Rarity = 4,
    Scale = 0.7
  },
  [1004] = {
    DefaultRotation = T.RT_1,
    FunctionDes = "CustomItem_Des_Normal",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_Item_0004.T_PersonalInfo_Item_0004'",
    IsDefaultUnlock = true,
    ItemId = 1004,
    Name = "CustomItem_Name_1004",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Carnival/Mesh/SM_Carn_Sig02.SM_Carn_Sig02'",
    Rarity = 4
  },
  [1005] = {
    DefaultLocation = {
      0,
      0,
      100
    },
    FunctionDes = "CustomItem_Des_Normal",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_Item_0005.T_PersonalInfo_Item_0005'",
    IsDefaultUnlock = true,
    ItemId = 1005,
    Name = "CustomItem_Name_1005",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Carnival/Mesh/SM_Carn_Bal03.SM_Carn_Bal03'",
    Rarity = 2,
    Scale = 0.5
  },
  [1006] = {
    DefaultRotation = T.RT_1,
    FunctionDes = "CustomItem_Des_Normal",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_Item_0001.T_PersonalInfo_Item_0001'",
    IsDefaultUnlock = true,
    ItemId = 1006,
    Name = "CustomItem_Name_1006",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_City/Mesh/SM_Bar_Boa01.SM_Bar_Boa01'",
    Rarity = 2,
    Scale = 0.8
  }
})
