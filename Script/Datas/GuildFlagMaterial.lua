local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildFlagMaterial", {
  [1] = {
    FlagMaterialID = 1,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoPatternCircle_1.T_Guild_LogoPatternCircle_1'"
  },
  [2] = {
    FlagMaterialID = 2,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoPatternCircle_2.T_Guild_LogoPatternCircle_2'"
  },
  [3] = {
    FlagMaterialID = 3,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoPatternCircle_3.T_Guild_LogoPatternCircle_3'"
  },
  [4] = {
    FlagMaterialID = 4,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_LogoPatternCircle_4.T_Guild_LogoPatternCircle_4'"
  }
})
