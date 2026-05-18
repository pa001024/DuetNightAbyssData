local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildColor", {
  [1] = {
    ColorID = 1,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_1.T_Guild_LogoColor_1'"
  },
  [2] = {
    ColorID = 2,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_2.T_Guild_LogoColor_2'"
  },
  [3] = {
    ColorID = 3,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_3.T_Guild_LogoColor_3'"
  },
  [4] = {
    ColorID = 4,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_4.T_Guild_LogoColor_4'"
  },
  [5] = {
    ColorID = 5,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_5.T_Guild_LogoColor_5'"
  },
  [6] = {
    ColorID = 6,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_6.T_Guild_LogoColor_6'"
  },
  [7] = {
    ColorID = 7,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_7.T_Guild_LogoColor_7'"
  },
  [8] = {
    ColorID = 8,
    ColorIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoColor_8.T_Guild_LogoColor_8'"
  }
})
