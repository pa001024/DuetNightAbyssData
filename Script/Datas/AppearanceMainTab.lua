local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceMainTab", {
  [1] = {
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Role",
    TabId = 1,
    Text = "UI_Armory_Char"
  },
  [2] = {
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_CloseIn_Weapons",
    TabId = 2,
    Text = "UI_Armory_Meleeweapon"
  },
  [3] = {
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_RangedWeapon",
    TabId = 3,
    Text = "UI_Armory_Longrange"
  },
  [4] = {
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Mounts",
    TabId = 4,
    Text = "UI_Mount"
  },
  [5] = {
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Gesture",
    TabId = 5,
    Text = "UI_Gesture"
  }
})
