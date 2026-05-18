local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildMaterial", {
  [1] = {
    MaterialID = 1,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Material_1.T_Guild_Material_1'"
  },
  [2] = {
    MaterialID = 2,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Material_2.T_Guild_Material_2'"
  },
  [3] = {
    MaterialID = 3,
    MaterialIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Guild/T_Guild_Material_3.T_Guild_Material_3'"
  }
})
