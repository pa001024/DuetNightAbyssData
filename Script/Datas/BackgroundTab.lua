local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BackgroundTab", {
  [1] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_NameCard_Menu.T_Tab_NameCard_Menu'",
    TabId = 1,
    TabName = "UI_Background_SysMenu"
  },
  [2] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_NameCard_PersonalInfo.T_Tab_NameCard_PersonalInfo'",
    TabId = 2,
    TabName = "UI_Background_Profile"
  },
  [3] = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_NameCard_Friend.T_Tab_NameCard_Friend'",
    TabId = 3,
    TabName = "UI_Background_SocialList"
  }
})
