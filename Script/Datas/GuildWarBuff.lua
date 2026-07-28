local T = {}
T.RT_1 = {3021003}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildWarBuff", {
  [1] = {
    BuffDes = "GuildBoss_BuffDes_1",
    BuffID = {3021001},
    BuffParameter = {
      [1] = "$#Buff[3021001].AddAttrs[1].Value$"
    },
    GuildWarBuffID = 1,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_Mon_Survive01.T_Abyss_Buff_Mon_Survive01"
  },
  [2] = {
    BuffDes = "GuildBoss_BuffDes_2",
    BuffID = {3021002},
    GuildWarBuffID = 2,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_Mon_Boss.T_Abyss_Buff_Mon_Boss"
  },
  [8502] = {
    BuffDes = "GuildBoss_BuffDes_8502",
    BuffID = T.RT_1,
    GuildWarBuffID = 8502,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_Mon_Survive02.T_Abyss_Buff_Mon_Survive02"
  },
  [8505] = {
    BuffDes = "GuildBoss_BuffDes_8505",
    BuffID = T.RT_1,
    GuildWarBuffID = 8505,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_Mon_Survive02.T_Abyss_Buff_Mon_Survive02"
  },
  [8509] = {
    BuffDes = "GuildBoss_BuffDes_8509",
    BuffID = T.RT_1,
    GuildWarBuffID = 8509,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_Mon_Survive02.T_Abyss_Buff_Mon_Survive02"
  },
  [8512] = {
    BuffDes = "GuildBoss_BuffDes_8512",
    BuffID = T.RT_1,
    GuildWarBuffID = 8512,
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_Mon_Survive02.T_Abyss_Buff_Mon_Survive02"
  }
})
