local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Background", {
  [1002] = {
    AccessText = "UI_Accessory_Unlock_Event",
    BackgroundId = 1002,
    BigIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_02.T_Menu_02'",
    Des = "UI_Background_Des_1",
    EscWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_02.T_Menu_02'",
    FriendWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_02.T_Menu_02'",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Icon_Menu_02.T_Icon_Menu_02'",
    Name = "UI_Background_Name_2",
    PersonalInfoWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_02.T_Menu_02'"
  },
  [1003] = {
    AccessText = "UI_AppearanceScore_ScoreRewardTitle",
    BackgroundId = 1003,
    BigIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_03.T_Menu_03'",
    Des = "UI_Background_Des_1",
    EscWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_03.T_Menu_03'",
    FriendWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_03.T_Menu_03'",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Icon_Menu_03.T_Icon_Menu_03'",
    Name = "UI_Background_Name_3",
    PersonalInfoWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_03.T_Menu_03'"
  }
})
