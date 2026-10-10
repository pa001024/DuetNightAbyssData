local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("D4SeasonQuestBuffType", {
  ATK = {
    BuffDes = "PlayerLevel_Buff_ATK",
    BuffName = "ATK",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Atk.T_ExperienceBuff_Atk",
    SIcon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Atk_Small.T_ExperienceBuff_Atk_Small"
  },
  DEF = {
    BuffDes = "PlayerLevel_Buff_DEF",
    BuffName = "DEF",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Def.T_ExperienceBuff_Def",
    SIcon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Def_Small.T_ExperienceBuff_Def_Small"
  },
  MaxES = {
    BuffDes = "PlayerLevel_Buff_MaxEs",
    BuffName = "MaxES",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Shield.T_ExperienceBuff_Shield",
    SIcon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Shield_Small.T_ExperienceBuff_Shield_Small"
  },
  MaxHp = {
    BuffDes = "PlayerLevel_Buff_MaxHp",
    BuffName = "MaxHp",
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Hp.T_ExperienceBuff_Hp",
    SIcon = "/Game/UI/Texture/Dynamic/Atlas/Experience/T_ExperienceBuff_Hp_Small.T_ExperienceBuff_Hp_Small"
  }
})
