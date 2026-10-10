local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HardBossEventDungeonSelect", {
  [1] = {
    DungeonId = {28001, 28002},
    GuidanceTitle = 100001,
    HardBossDes = "UI_HardBoss_Des_1",
    HardBossDungeonId = 1,
    HardBossName = "UI_HardBoss_Name_1",
    HardBossRewardView = 28001,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG01.WBP_AreaCoop_LoadingBG01'",
    MonsterIcon = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_Xibi_S.T_Permanent_HardBoss_Xibi_S",
    TitleBp = "WidgetBlueprint'/Game/UI/WBP/Play/Widget/HardBoss/PlayHardBossTitle/WBP_Play_HardBoss_Title_Xibi.WBP_Play_HardBoss_Title_Xibi'"
  },
  [2] = {
    DungeonId = {28003, 28004},
    GuidanceTitle = 100001,
    HardBossDes = "UI_HardBoss_Des_3",
    HardBossDungeonId = 2,
    HardBossName = "UI_HardBoss_Name_3",
    HardBossRewardView = 28003,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG02.WBP_AreaCoop_LoadingBG02'",
    MonsterIcon = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_Saiqi_S.T_Permanent_HardBoss_Saiqi_S",
    TitleBp = "WidgetBlueprint'/Game/UI/WBP/Play/Widget/HardBoss/PlayHardBossTitle/WBP_Play_HardBoss_Title_Saiqi.WBP_Play_HardBoss_Title_Saiqi'"
  },
  [3] = {
    DungeonId = {28005, 28006},
    GuidanceTitle = 100001,
    HardBossDes = "UI_HardBoss_Des_4",
    HardBossDungeonId = 3,
    HardBossName = "UI_HardBoss_Name_4",
    HardBossRewardView = 28004,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG04.WBP_AreaCoop_LoadingBG04'",
    MonsterIcon = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_Haier_S.T_Permanent_HardBoss_Haier_S",
    TitleBp = "WidgetBlueprint'/Game/UI/WBP/Play/Widget/HardBoss/PlayHardBossTitle/WBP_Play_HardBoss_Title_Haier.WBP_Play_HardBoss_Title_Haier'"
  },
  [4] = {
    DungeonId = {28007, 28008},
    GuidanceTitle = 100001,
    HardBossDes = "Mon_DesDetail_8509001",
    HardBossDungeonId = 4,
    HardBossName = "Mon_Name_8509801",
    HardBossRewardView = 28007,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG09.WBP_AreaCoop_LoadingBG09'",
    MonsterIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_Tuosi_S.T_Permanent_HardBoss_Tuosi_S'",
    TitleBp = "WidgetBlueprint'/Game/UI/WBP/Play/Widget/HardBoss/PlayHardBossTitle/WBP_Play_HardBoss_Title_Tuosi.WBP_Play_HardBoss_Title_Tuosi'"
  },
  [5] = {
    DungeonId = {28009, 28010},
    GuidanceTitle = 100001,
    HardBossDes = "UI_HardBoss_Des_8",
    HardBossDungeonId = 5,
    HardBossName = "UI_HardBoss_Name_8",
    HardBossRewardView = 28009,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG08.WBP_AreaCoop_LoadingBG08'",
    MonsterIcon = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_Aida_S.T_Permanent_HardBoss_Aida_S",
    TitleBp = "WidgetBlueprint'/Game/UI/WBP/Play/Widget/HardBoss/PlayHardBossTitle/WBP_Play_HardBoss_Title_Aida.WBP_Play_HardBoss_Title_Aida'"
  }
})
