local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProContract", {
  [101] = {
    Desc = "RLContract_Desc_101",
    DescValues = {
      [1] = "$math.ceil(#GlobalPassiveData[30101001].Vars.HealRate*100)$%"
    },
    GlobalPassiveId = 30101001,
    HeatValue = 1,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Char_HealDown.T_Rou_Contract_Char_HealDown",
    Id = 101,
    MaxLevel = 20,
    Name = "RLContract_Name_101",
    StartHeat = 1
  },
  [102] = {
    Desc = "RLContract_Desc_102",
    DescValues = {
      [1] = "$math.ceil(-#Buff[30101002].AddAttrs[1].Rate*100)$%"
    },
    GlobalPassiveId = 30101002,
    HeatValue = 2,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Char_SpDown.T_Rou_Contract_Char_SpDown",
    Id = 102,
    MaxLevel = 5,
    Name = "RLContract_Name_102",
    StartHeat = 2
  },
  [103] = {
    Desc = "RLContract_Desc_103",
    DescValues = {
      [1] = "$math.ceil(#Buff[30102001].AddAttrs[1].Rate*100)$%"
    },
    GlobalPassiveId = 30102001,
    HeatValue = 2,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Mon_HpUp.T_Rou_Contract_Mon_HpUp",
    Id = 103,
    MaxLevel = 5,
    Name = "RLContract_Name_103",
    StartHeat = 3
  },
  [104] = {
    Desc = "RLContract_Desc_104",
    DescValues = {
      [1] = "$math.ceil(#Buff[30102002].AddAttrs[1].Rate*100)$%"
    },
    GlobalPassiveId = 30102002,
    HeatValue = 2,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Mon__AtkUp.T_Rou_Contract_Mon__AtkUp",
    Id = 104,
    MaxLevel = 5,
    Name = "RLContract_Name_104",
    StartHeat = 4
  },
  [105] = {
    Desc = "RLContract_Desc_105",
    DescValues = {
      [1] = "$math.ceil(#GlobalPassiveData[30102003].Vars.DamagedRate*100)$%"
    },
    GlobalPassiveId = 30102003,
    HeatValue = 2,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Mon_HpUp.T_Rou_Contract_Mon_HpUp",
    Id = 105,
    MaxLevel = 5,
    Name = "RLContract_Name_105",
    StartHeat = 5
  },
  [106] = {
    Desc = "RLContract_Desc_110",
    HeatValue = 10,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Mechanics_CostUp.T_Rou_Contract_Mechanics_CostUp",
    Id = 106,
    MaxLevel = 1,
    Name = "RLContract_Name_110",
    StartHeat = 6
  },
  [107] = {
    Desc = "RLContract_Desc_111",
    HeatValue = 5,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Mechanics_LessChoice.T_Rou_Contract_Mechanics_LessChoice",
    Id = 107,
    MaxLevel = 1,
    Name = "RLContract_Name_111",
    StartHeat = 7
  },
  [108] = {
    Desc = "RLContract_Desc_112",
    HeatValue = 15,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rou_Contract_Mechanics_RandomChoice.T_Rou_Contract_Mechanics_RandomChoice",
    Id = 108,
    MaxLevel = 1,
    Name = "RLContract_Name_112",
    StartHeat = 8
  }
})
