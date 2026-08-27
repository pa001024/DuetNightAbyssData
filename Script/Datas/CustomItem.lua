local T = {}
T.RT_1 = {"Text_Gacha"}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomItem", {
  [1001] = {
    AccessKey = {
      "Text_Achievement"
    },
    FunctionDes = "CustomItem_Des_1001",
    ItemId = 1001,
    Name = "CustomItem_Name_1001",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_City/Mesh/SM_Bar_Cha01.SM_Bar_Cha01'",
    Rarity = 1
  },
  [1002] = {
    AccessKey = T.RT_1,
    FunctionDes = "CustomItem_Des_1002",
    ItemId = 1002,
    Name = "CustomItem_Name_1002",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Carnival/Mesh/SM_Carn_Bal02.SM_Carn_Bal02'",
    Rarity = 2
  },
  [1003] = {
    AccessKey = T.RT_1,
    FunctionDes = "CustomItem_Des_1003",
    ItemId = 1003,
    Name = "CustomItem_Name_1003",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Carnival/Mesh/SM_Carn_Cry01.SM_Carn_Cry01'",
    Rarity = 3
  },
  [1004] = {
    AccessKey = {
      "Text_Headicon"
    },
    FunctionDes = "CustomItem_Des_1004",
    ItemId = 1004,
    Name = "CustomItem_Name_1004",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_Carnival/Mesh/SM_Carn_Toy01.SM_Carn_Toy01'",
    Rarity = 4
  },
  [1005] = {
    AccessKey = {
      "Text_Raid_DungeonReward"
    },
    FunctionDes = "CustomItem_Des_1005",
    ItemId = 1005,
    Name = "CustomItem_Name_1005",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_City/Mesh/SM_Cit_Sign11.SM_Cit_Sign11'",
    Rarity = 5
  },
  [1006] = {
    AccessKey = {
      "Text_Raid_Reward"
    },
    FunctionDes = "CustomItem_Des_1006",
    ItemId = 1006,
    Name = "CustomItem_Name_1006",
    Path = "StaticMesh'/Game/Asset/Scene/EN002_Haiboliya/Binghucheng/BH_City/Mesh/SM_Cit_Sign12.SM_Cit_Sign12'",
    Rarity = 6
  }
})
