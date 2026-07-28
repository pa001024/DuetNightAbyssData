local T = {}
T.RT_1 = {0.5, 1.25}
T.RT_2 = {0.3, 1}
T.RT_3 = {-44610, 5350}
T.RT_4 = {0, 0}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Region", {
  [1001] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {
      100101,
      100102,
      100103,
      100104
    },
    RegionDispCondition = 110109,
    RegionId = 1001,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Prologue/Main/prologue",
    RegionMapFile = "/Game/Maps/Levels/Prologue/Prologue_Main_01/Prologue_Main_01",
    RegionMapId = 100,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_Prologue.WBP_Map_Reg_Prologue",
    RegionMapImageCenter = {16600, 13500},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1001",
    RegionRotation = 270,
    RegionType = "Main",
    ResetTime = {MONTH = 1}
  },
  [1011] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {
      101101,
      101103,
      101104,
      101105,
      101106,
      101107,
      101108,
      101110,
      101111
    },
    RegionDispCondition = 110109,
    RegionId = 1011,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Chapter01/Main/Chapter01",
    RegionMapFile = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Chapter01",
    RegionMapId = 200,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_Chapter01.WBP_Map_Reg_Chapter01",
    RegionMapImageCenter = {-18300, 15700},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1011",
    RegionRotation = 180,
    RegionType = "Main",
    ResetTime = {DAY = 1}
  },
  [1013] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {
      101301,
      101303,
      101304,
      101305
    },
    RegionDispCondition = 110109,
    RegionId = 1013,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Chapter01/Main/Chapter01_KuangKeng",
    RegionMapFile = "/Game/Maps/Levels/Chapter01/Chapter01_KuangKeng_Main/Chapter01_KuangKeng",
    RegionMapId = 202,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_Chapter01_KK.WBP_Map_Reg_Chapter01_KK",
    RegionMapImageCenter = {9000, 14600},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1013",
    RegionRotation = 270,
    RegionType = "Main"
  },
  [1014] = {
    IsRandom = {101401, 101402},
    RegionId = 1014,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Chapter01/Main/Chapter01_Saiqi_Wonderland",
    RegionMapFile = "/Game/Maps/Levels/Chapter01/Chapter01_Won/Chapter01_Won_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1014",
    RegionType = "Fantasy"
  },
  [1017] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {
      101701,
      101702,
      101703
    },
    RegionDispCondition = 110109,
    RegionId = 1017,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Chapter01/Main/Chapter01_Sew",
    RegionMapFile = "/Game/Maps/Levels/Chapter01/Chapter01_Sew_Main/Chapter_Sew_Main",
    RegionMapId = 201,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_Chapter01_Sew.WBP_Map_Reg_Chapter01_Sew",
    RegionMapImageCenter = {-20360, -7102},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1017",
    RegionType = "Main",
    ResetTime = {WEEK = 1}
  },
  [1019] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    CloseBlock = true,
    IsRandom = {101901},
    RegionId = 1019,
    RegionMapFile = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/BH_Thea_Main",
    RegionMapId = 204,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_Chapter01_Thea.WBP_Map_Reg_Chapter01_Thea",
    RegionMapImageCenter = {20500, 3300},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1019",
    RegionType = "Main"
  },
  [1021] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {
      102101,
      102102,
      102103,
      102104
    },
    RegionDispCondition = 110109,
    RegionId = 1021,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Ex01/Main/Ex01",
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Haiboliya_Longsha_Main",
    RegionMapId = 300,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_EXChapter01.WBP_Map_Reg_EXChapter01",
    RegionMapImageCenter = {5500, -15000},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1021",
    RegionType = "EX"
  },
  [1032] = {
    IsRandom = {103201},
    RegionId = 1032,
    RegionMapFile = "/Game/Maps/Levels/Chapter01/Chapter01_Alch_Main/Chapter01_Alch_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1032",
    RegionType = "Main"
  },
  [1041] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_Black.WBP_Map_BG_Black'",
    IsRandom = {
      104102,
      104103,
      104104,
      104105,
      104106,
      104107,
      104108,
      104109,
      104110
    },
    RegionDispCondition = 120106,
    RegionId = 1041,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Huaxu_Yanjindu_Main",
    RegionMapId = 400,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Yanjindu.WBP_Map_Reg_East_Yanjindu",
    RegionMapWheelScale = T.RT_2,
    RegionName = "UI_REGION_NAME_1041",
    RegionType = "Main"
  },
  [1042] = {
    IsRandom = {104201},
    RegionId = 1042,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Batt01/Huaxu_Yanjindu_Batt01_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1042",
    RegionType = "Main"
  },
  [1043] = {
    IsRandom = {104301},
    RegionId = 1043,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Nai01/Huaxu_Yanjindu_Nai01_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1043",
    RegionType = "Main"
  },
  [1044] = {
    IsRandom = {104401},
    RegionId = 1044,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Nai02/Huaxu_Yanjindu_Nai02_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1044",
    RegionType = "Main"
  },
  [1045] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_EastSeason02.WBP_Map_BG_EastSeason02'",
    IsRandom = {
      104501,
      104502,
      104503,
      104504,
      104505,
      104506
    },
    RegionDispCondition = 120206,
    RegionId = 1045,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Huaxu_Haojing_Main",
    RegionMapId = 500,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Haojing.WBP_Map_Reg_East_Haojing",
    RegionMapImageCenter = {20670, -49970},
    RegionMapWheelScale = T.RT_2,
    RegionName = "UI_REGION_NAME_1045",
    RegionType = "Main"
  },
  [1046] = {
    IsRandom = {104601},
    RegionId = 1046,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Batt02/Huaxu_Yanjindu_Batt02_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1046",
    RegionType = "Main"
  },
  [1047] = {
    IsRandom = {104701},
    RegionId = 1047,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Batt03/Huaxu_Yanjindu_Batt03_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1047",
    RegionType = "Main"
  },
  [1048] = {
    IsRandom = {104801},
    RegionId = 1048,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_YYG/Huaxu_Haojing_YYG_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1048",
    RegionType = "Main"
  },
  [1049] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_Black.WBP_Map_BG_Black'",
    IsRandom = {104901},
    RegionId = 1049,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Off/Huaxu_Yanjindu_Off_Main",
    RegionMapId = 400,
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1049",
    RegionType = "Main"
  },
  [1050] = {
    IsRandom = {105001},
    RegionId = 1050,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Nai03/Huaxu_Yanjindu_Nai03_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1050",
    RegionType = "Main"
  },
  [1051] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_EastSeason02.WBP_Map_BG_EastSeason02'",
    IsRandom = {105101},
    RegionId = 1051,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Int/Huaxu_Haojing_Int_Main",
    RegionMapId = 500,
    RegionMapWheelScale = T.RT_2,
    RegionName = "UI_REGION_NAME_1051",
    RegionType = "Main"
  },
  [1052] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_EastSeason02.WBP_Map_BG_EastSeason02'",
    IsRandom = {105201},
    RegionId = 1052,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Reb/Huaxu_Haojing_Reb_Main",
    RegionMapId = 501,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Shanwaishan.WBP_Map_Reg_East_Shanwaishan",
    RegionMapImageCenter = {5820, -7930},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1052",
    RegionType = "Main"
  },
  [1053] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_EastSeason02.WBP_Map_BG_EastSeason02'",
    CloseBlock = true,
    IsRandom = {105301},
    RegionId = 1053,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_TRLM/Huaxu_Haojing_TRLM_Main",
    RegionMapId = 502,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Tianrenlingmu.WBP_Map_Reg_East_Tianrenlingmu",
    RegionMapImageCenter = {19500, 23500},
    RegionMapWheelScale = T.RT_2,
    RegionName = "UI_REGION_NAME_1053",
    RegionRotation = 270,
    RegionType = "Main"
  },
  [1054] = {
    IsRandom = {105401},
    RegionId = 1054,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_TXJ/Huaxu_Haojing_TXJ_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1054"
  },
  [1055] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_EastSeason02.WBP_Map_BG_EastSeason02'",
    CloseBlock = true,
    IsRandom = {105501},
    RegionId = 1055,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_YLX/Huaxu_Haojing_YLX_Main",
    RegionMapId = 503,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Youlaixiang.WBP_Map_Reg_East_Youlaixiang",
    RegionMapImageCenter = {16050, 1925},
    RegionMapWheelScale = {1, 2},
    RegionName = "UI_REGION_NAME_1055",
    RegionType = "Main"
  },
  [1056] = {
    IsRandom = {105601, 105602},
    RegionId = 1056,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_ZhiliuHJ/Huaxu_Haojing_ZhiliuHJ_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1056"
  },
  [1057] = {
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_Black.WBP_Map_BG_Black'",
    CloseBlock = true,
    IsRandom = {105701},
    RegionId = 1057,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Alt/Huaxu_Yanjindu_Alt_Main",
    RegionMapId = 401,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Heilongjitan.WBP_Map_Reg_East_Heilongjitan",
    RegionMapImageCenter = {22300, -78018},
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1057",
    RegionType = "Main"
  },
  [1058] = {
    IsRandom = {105801},
    RegionId = 1058,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Stealth/Huaxu_Yanjindu_Stealth_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1058",
    RegionType = "Main"
  },
  [1059] = {
    IsRandom = {105901},
    RegionId = 1059,
    RegionMapFile = "/Game/Maps/Levels/Huaxu/Huaxu_HaoJing_Batt04/Huaxu_Haojing_Batt04_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1059",
    RegionType = "Main"
  },
  [1060] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {106001},
    RegionDispCondition = 100405,
    RegionId = 1060,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Haiboliya_Chezhan_Main",
    RegionMapId = 205,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/Chapter03/WBP_Map_Reg_Chapter03_Station_AG.WBP_Map_Reg_Chapter03_Station_AG",
    RegionMapImageCenter = T.RT_3,
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1060",
    RegionType = "Main"
  },
  [1061] = {
    IsRandom = {106101},
    RegionId = 1061,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Haiboliya_Chezhan_YW_Main",
    RegionMapId = 205,
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1061",
    RegionType = "Main"
  },
  [1062] = {
    IsRandom = {106201},
    RegionId = 1062,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_MT/Haiboliya_Chezhan_MT_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1062",
    RegionType = "Main"
  },
  [1063] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {106301},
    RegionId = 1063,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_CZDX/Haiboliya_Chezhan_CZDX_Main",
    RegionMapId = 206,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/Chapter03/WBP_Map_Reg_Chapter03_Station_UG.WBP_Map_Reg_Chapter03_Station_UG",
    RegionMapImageCenter = T.RT_3,
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_1063",
    RegionType = "Main"
  },
  [1070] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    CloseBlock = true,
    IsRandom = {107001},
    RegionId = 1070,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Lxzs01_Main/Haiboliya_Thc_Lxzs01_Main",
    RegionMapId = 600,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/Chapter03/WBP_Map_Reg_Chapter03_Station_AG.WBP_Map_Reg_Chapter03_Station_AG",
    RegionMapImageCenter = T.RT_4,
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-新村庄",
    RegionType = "Main"
  },
  [1071] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    CloseBlock = true,
    IsRandom = {107101},
    RegionId = 1071,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Lxzs02_Main/Haiboliya_Thc_Lxzs02_Main",
    RegionMapId = 601,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Yanjindu.WBP_Map_Reg_East_Yanjindu",
    RegionMapImageCenter = T.RT_4,
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-旧村庄",
    RegionType = "Main"
  },
  [1072] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    CloseBlock = true,
    IsRandom = {107201},
    RegionId = 1072,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Lxzx_Main/Haiboliya_Thc_Lxzx_Main",
    RegionMapId = 602,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Haojing.WBP_Map_Reg_East_Haojing",
    RegionMapImageCenter = T.RT_4,
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-湖区",
    RegionType = "Main"
  },
  [1073] = {
    IsRandom = {107301},
    RegionId = 1073,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Emyly/Haiboliya_Thc_Emyly_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-旧村庄-噩梦游乐园",
    RegionType = "Main"
  },
  [1074] = {
    IsRandom = {107401},
    RegionId = 1074,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Zchj/Haiboliya_Thc_Zchj_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-湖区-战场幻境",
    RegionType = "Main"
  },
  [1075] = {
    IsRandom = {107501},
    RegionId = 1075,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Zjfj/Haiboliya_Thc_Zjfj_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-新村庄-主角家",
    RegionType = "Main"
  },
  [1076] = {
    IsRandom = {107601},
    RegionId = 1076,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Boss/Haiboliya_Thc_Boss_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-新村庄-Boss战",
    RegionType = "Main"
  },
  [1077] = {
    IsRandom = {107701},
    RegionId = 1077,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Jhs/Haiboliya_Thc_Jhs_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-新村庄-净化室+墓地",
    RegionType = "Main"
  },
  [1078] = {
    IsRandom = {107801},
    RegionId = 1078,
    RegionMapFile = "/Game/Maps/Levels/Haiboliya/Haiboliya_Thc_Ck/Haiboliya_Thc_Ck_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "EX02-新村庄-仓库",
    RegionType = "Main"
  },
  [1081] = {
    IsRandom = {108101},
    RegionId = 1081,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_Sailafei_Main/Ailixian_Sailafei_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "艾利西安-塞拉菲修道院",
    RegionType = "Main"
  },
  [1082] = {
    IsRandom = {108201},
    RegionId = 1082,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_Miandao_Main/Ailixian_Miandao_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "艾利西安-眠岛",
    RegionType = "Main"
  },
  [1083] = {
    IsRandom = {108301},
    RegionId = 1083,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_DreamSailafei_Main/Ailixian_DreamSailafei_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "艾利西安-莉莉蔻梦境",
    RegionType = "Main"
  },
  [1090] = {
    IsRandom = {109001},
    RegionId = 1090,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_Chenmian_Main/Ailixian_Chenmian_Main",
    RegionName = "UI_REGION_NAME_1090",
    RegionType = "Main"
  },
  [1091] = {
    IsRandom = {109101},
    RegionId = 1091,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_Shendianfeixu_Main/Ailixian_Shendianfeixu_Main",
    RegionName = "UI_REGION_NAME_1091",
    RegionType = "Main"
  },
  [1092] = {
    IsRandom = {109201},
    RegionId = 1092,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_Manyue_Main/Ailixian_Manyue_Main",
    RegionName = "UI_REGION_NAME_1092",
    RegionType = "Main"
  },
  [1093] = {
    IsRandom = {109301},
    RegionId = 1093,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_Anzhixin_Main/Ailixian_Anzhixin_Main",
    RegionName = "UI_REGION_NAME_1093",
    RegionType = "Main"
  },
  [1094] = {
    IsRandom = {109401},
    RegionId = 1094,
    RegionMapFile = "/Game/Maps/Levels/Ailixian/Ailixian_LizibeierHJ_Main/Ailixian_LizibeierHJ_Main",
    RegionName = "UI_REGION_NAME_1094",
    RegionType = "Main"
  },
  [2001] = {
    IsRandom = {200101},
    RegionId = 2001,
    RegionMapFile = "/Game/Maps/Levels/Home/Invite_Main/Invite_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_2001",
    RegionType = "Main"
  },
  [2101] = {
    AlertDisable = true,
    BgBlueprintPath = "WidgetBlueprint'/Game/UI/WBP/Map/Widget/MapBG/WBP_Map_BG_White.WBP_Map_BG_White'",
    IsRandom = {210101},
    RegionId = 2101,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Chapter01/Main/Chapter01_HomeBase",
    RegionMapFile = "/Game/Maps/Levels/Home/HomeBase/HomeBase_Main",
    RegionMapId = 200,
    RegionMapWheelScale = T.RT_1,
    RegionName = "UI_REGION_NAME_2101",
    RegionType = "Main"
  },
  [3001] = {
    IsRandom = {300101},
    RegionId = 3001,
    RegionMapFile = "/Game/Maps/Levels/Special/Guild_Main/Guild_Main",
    RegionName = "UI_REGION_NAME_3001"
  },
  [3002] = {
    IsRandom = {300201},
    RegionId = 3002,
    RegionMapFile = "/Game/Maps/Levels/Test/TestGuild_Main/TestGuild_Main",
    RegionName = "测试公会领地"
  },
  [9997] = {
    IsRandom = {999701},
    RegionId = 9997,
    RegionMapFile = "/Game/Maps/Misc_Test/RegionProfTest/RegionProfTest_Main/RegionProfTest_Main",
    RegionMapId = 1,
    RegionMapImage = "/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Reg_Chapter01.WBP_Map_Reg_Chapter01",
    RegionMapImageCenter = {20000, 20000},
    RegionMapWheelScale = T.RT_1,
    RegionName = "区域性能测试",
    RegionType = "Main"
  },
  [9998] = {
    AlertDisable = true,
    IsRandom = {999801},
    RegionId = 9998,
    RegionMapFile = "/Game/Maps/Levels/Test/TestLevel/SpecialQuestTest/TestSpecialQuest",
    RegionMapWheelScale = T.RT_1,
    RegionName = "特殊任务测试区域"
  },
  [9999] = {
    AlertDisable = true,
    IsRandom = {
      999901,
      999902,
      999903
    },
    RegionId = 9999,
    RegionJsonFile = "/Game/Script/Datas/Houdini_data/Test/NewTestRoom/BattleTest/BattleTest01",
    RegionMapFile = "/Game/Maps/Misc_Test/RegionWCTest/RegionTest_Main",
    RegionMapWheelScale = T.RT_1,
    RegionName = "区域测试"
  }
})
