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
  },
  [1004] = {
    AccessText = "UI_LimitedPrizePool_Background16",
    BackgroundId = 1004,
    BigIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_HeitaoSaiqi.T_Menu_HeitaoSaiqi'",
    Des = "UI_Background_Des_1",
    EscWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_HeitaoSaiqi.T_Menu_HeitaoSaiqi'",
    FriendWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_HeitaoSaiqi.T_Menu_HeitaoSaiqi'",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_HeitaoSaiqi.T_Head_HeitaoSaiqi'",
    Name = "UI_Background_Name_4",
    PersonalInfoWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_HeitaoSaiqi.T_Menu_HeitaoSaiqi'"
  },
  [1005] = {
    AccessText = "UI_LimitedPrizePool_Background17_1",
    BackgroundId = 1005,
    BigIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_BaonuSonglu.T_Menu_BaonuSonglu'",
    Des = "UI_Background_Des_1",
    EscWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_BaonuSonglu.T_Menu_BaonuSonglu'",
    FriendWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_BaonuSonglu.T_Menu_BaonuSonglu'",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_BaonuSonglu.T_Head_BaonuSonglu'",
    Name = "UI_Background_Name_5",
    PersonalInfoWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_BaonuSonglu.T_Menu_BaonuSonglu'"
  },
  [1006] = {
    AccessText = "UI_LimitedPrizePool_Background17_2",
    BackgroundId = 1006,
    BigIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_LiseFeina.T_Menu_LiseFeina'",
    Des = "UI_Background_Des_1",
    EscWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_LiseFeina.T_Menu_LiseFeina'",
    FriendWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_LiseFeina.T_Menu_LiseFeina'",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_LiseFeina.T_Head_LiseFeina'",
    Name = "UI_Background_Name_6",
    PersonalInfoWidget = "Texture2D'/Game/UI/Texture/Dynamic/Image/Menu/T_Menu_LiseFeina.T_Menu_LiseFeina'"
  }
})
