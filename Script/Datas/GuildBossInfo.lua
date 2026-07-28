local T = {}
T.RT_1 = {
  1,
  2,
  3
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildBossInfo", {
  [8502701] = {
    BossCreatorID = 2010104,
    BossTotalHP = 120000000000,
    Desc = "Mon_DesDetail_8502001",
    DungeonID = 29001,
    GuildBossBaseRate = 9232.46,
    GuildBossMainBPPath = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG02.WBP_AreaCoop_LoadingBG02'",
    GuildWarBuff = {
      1,
      2,
      8502
    },
    ID = 8502701,
    LevelChooseImgBPPath = "/Game/UI/Texture/Dynamic/Image/Guild/Boss/T_Guild_BossImage_2.T_Guild_BossImage_2",
    Name = "UI_HardBoss_Name_3",
    RandomTest = T.RT_1,
    TabImgBPPath = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_VideoImg_SaiQi.T_Permanent_HardBoss_VideoImg_SaiQi",
    TimeLimit = 90,
    TitleBPPath = "/Game/UI/WBP/Guild/Widget/Boss/BossTitle/WBP_Guild_BossTitle_Saiqi.WBP_Guild_BossTitle_Saiqi"
  },
  [8505701] = {
    BossCreatorID = 2010106,
    BossTotalHP = 120000000000,
    Desc = "Mon_DesDetail_8505001",
    DungeonID = 29002,
    GuildBossBaseRate = 9232.46,
    GuildBossMainBPPath = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG04.WBP_AreaCoop_LoadingBG04'",
    GuildWarBuff = {
      1,
      2,
      8505
    },
    ID = 8505701,
    LevelChooseImgBPPath = "/Game/UI/Texture/Dynamic/Image/Guild/Boss/T_Guild_BossImage_4.T_Guild_BossImage_4",
    Name = "UI_HardBoss_Name_4",
    RandomTest = T.RT_1,
    TabImgBPPath = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_VideoImg_Haier.T_Permanent_HardBoss_VideoImg_Haier",
    TimeLimit = 90,
    TitleBPPath = "/Game/UI/WBP/Guild/Widget/Boss/BossTitle/WBP_Guild_BossTitle_Haier.WBP_Guild_BossTitle_Haier"
  },
  [8509701] = {
    BossCreatorID = 2010109,
    BossTotalHP = 120000000000,
    Desc = "Mon_DesDetail_8509001",
    DungeonID = 29003,
    GuildBossBaseRate = 9232.46,
    GuildWarBuff = {
      1,
      2,
      8509
    },
    ID = 8509701,
    LevelChooseImgBPPath = "/Game/UI/Texture/Dynamic/Image/Guild/Boss/T_Guild_BossImage_1.T_Guild_BossImage_1",
    Name = "Mon_Name_8509001",
    RandomTest = T.RT_1,
    TabImgBPPath = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_VideoImg_Bailong.T_Permanent_HardBoss_VideoImg_Bailong",
    TimeLimit = 90,
    TitleBPPath = "/Game/UI/WBP/Guild/Widget/Boss/BossTitle/WBP_Guild_BossTitle_Bailong.WBP_Guild_BossTitle_Bailong"
  },
  [8512701] = {
    BossCreatorID = 2010112,
    BossTotalHP = 120000000000,
    Desc = "Mon_DesDetail_8512001",
    DungeonID = 29004,
    GuildBossBaseRate = 9232.46,
    GuildBossMainBPPath = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG05.WBP_AreaCoop_LoadingBG05'",
    GuildWarBuff = {
      1,
      2,
      8512
    },
    ID = 8512701,
    LevelChooseImgBPPath = "/Game/UI/Texture/Dynamic/Image/Guild/Boss/T_Guild_BossImage_5.T_Guild_BossImage_5",
    Name = "UI_HardBoss_Name_5",
    RandomTest = T.RT_1,
    TabImgBPPath = "/Game/UI/Texture/Dynamic/Image/Permanent/T_Permanent_HardBoss_VideoImg_Linen.T_Permanent_HardBoss_VideoImg_Linen",
    TimeLimit = 90,
    TitleBPPath = "/Game/UI/WBP/Guild/Widget/Boss/BossTitle/WBP_Guild_BossTitle_Linen.WBP_Guild_BossTitle_Linen"
  }
})
