local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildFlagColor", {
  [1] = {
    FlagColorID = 1,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_1.T_Guild_Color_1'"
  },
  [2] = {
    FlagColorID = 2,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_2.T_Guild_Color_2'"
  },
  [3] = {
    FlagColorID = 3,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_3.T_Guild_Color_3'"
  },
  [4] = {
    FlagColorID = 4,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_4.T_Guild_Color_4'"
  },
  [5] = {
    FlagColorID = 5,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_5.T_Guild_Color_5'"
  },
  [6] = {
    FlagColorID = 6,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_6.T_Guild_Color_6'"
  },
  [7] = {
    FlagColorID = 7,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_7.T_Guild_Color_7'"
  },
  [8] = {
    FlagColorID = 8,
    FlagColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Color_8.T_Guild_Color_8'"
  }
})
