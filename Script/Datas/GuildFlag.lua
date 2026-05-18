local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildFlag", {
  [1001] = {
    FlagID = 1001,
    FlagIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoBG_1_S.T_Guild_LogoBG_1_S'",
    FlagPathL = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_BGtype_1.T_Guild_BGtype_1'",
    FlagPathS = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_BGtype_S_1.T_Guild_BGtype_S_1'"
  },
  [1002] = {
    FlagID = 1002,
    FlagIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoBG_2_S.T_Guild_LogoBG_2_S'",
    FlagPathL = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_BGtype_2.T_Guild_BGtype_2'",
    FlagPathS = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_BGtype_S_2.T_Guild_BGtype_S_2'"
  },
  [1003] = {
    FlagID = 1003,
    FlagIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoBG_3_S.T_Guild_LogoBG_3_S'",
    FlagPathL = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_BGtype_3.T_Guild_BGtype_3'",
    FlagPathS = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_BGtype_S_3.T_Guild_BGtype_S_3'"
  }
})
