local T = {}
T.RT_1 = {
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00010",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00011",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00012",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00013",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00018",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00019",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00020",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00021",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00025",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00026",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00027",
  "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00028"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ArtLevelControl", {
  [1] = {
    Id = 1,
    InTime = 0.5,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_IcelakeCIty_IQ1003_Task.Chapter01_IcelakeCIty_IQ1003_Task",
      [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_IQ1003_Task_NavMesh.Chapter01_IcelakeCity_IQ1003_Task_NavMesh"
    },
    OutTime = 0.5,
    RegionId = 1011,
    UnLoadLevelList = {
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00029",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00030",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00031",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00040",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00041",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00042",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00043",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00053",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00054",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00055",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00056",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00004",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00005",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00006",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00007",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00008",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00009",
      "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00010"
    },
    VarName = "IQ1003"
  },
  [2] = {
    Id = 2,
    InTime = 0.5,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_TrafficWay_IQ1002_Task.Chapter01_TrafficWay_IQ1002_Task",
      [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_TrafficWay_IQ1002_Task_NavMesh.Chapter01_TrafficWay_IQ1002_Task_NavMesh"
    },
    OutTime = 0.5,
    RegionId = 1011,
    UnLoadLevelList = T.RT_1,
    VarName = "IQ1002"
  },
  [3] = {
    Id = 3,
    InTime = 0.5,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha01_IQ110103_Task.Haiboliya_Longsha01_IQ110103_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha01_IQ110103_Task_Navmesh.Haiboliya_Longsha01_IQ110103_Task_Navmesh"
    },
    OutTime = 0.5,
    RegionId = 1021,
    UnLoadLevelList = {
      "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha01_NavMesh.Haiboliya_Longsha01_NavMesh"
    },
    VarName = "IQ110103"
  },
  [4] = {
    Id = 4,
    InTime = 0.5,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_IQ110107_Task.Haiboliya_Longsha02_IQ110107_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha02_IQ110107_Task_Navmesh.Haiboliya_Longsha02_IQ110107_Task_Navmesh"
    },
    OutTime = 0.5,
    RegionId = 1021,
    UnLoadLevelList = {
      "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha02_NavMesh.Haiboliya_Longsha02_NavMesh"
    },
    VarName = "IQ110107"
  },
  [5] = {
    Id = 5,
    InTime = 0.5,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_TrafficWay_IQ100303_Task.Chapter01_TrafficWay_IQ100303_Task",
      [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_TrafficWay_IQ100303_Task_NavMesh.Chapter01_TrafficWay_IQ100303_Task_NavMesh"
    },
    OutTime = 0.5,
    RegionId = 1011,
    UnLoadLevelList = T.RT_1,
    VarName = "IQ100303"
  },
  [6] = {
    Id = 6,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_NPC110108_Task.Haiboliya_Longsha02_NPC110108_Task"
    },
    OutTime = 0,
    RegionId = 1021,
    VarName = "NPC110108"
  },
  [7] = {
    Id = 7,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_LinshiNPC110101_Task.Haiboliya_Longsha02_LinshiNPC110101_Task"
    },
    OutTime = 0,
    RegionId = 1021,
    VarName = "LinshiNPC110101"
  },
  [8] = {
    Id = 8,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_NengYuanNPC110105_Task.Haiboliya_Longsha02_NengYuanNPC110105_Task"
    },
    OutTime = 0,
    RegionId = 1021,
    VarName = "NengYuanNPC110105"
  },
  [9] = {
    Id = 9,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_ShenWenNPC110105_Task.Haiboliya_Longsha02_ShenWenNPC110105_Task"
    },
    OutTime = 0,
    RegionId = 1021,
    VarName = "ShenWenNPC110105"
  },
  [10] = {
    Id = 10,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_XimengNPC110105_Task.Haiboliya_Longsha02_XimengNPC110105_Task"
    },
    OutTime = 0,
    RegionId = 1021,
    VarName = "XimengNPC110105"
  },
  [11] = {
    Id = 11,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/Task_Data/BH_Thea_IQ100306_Task.BH_Thea_IQ100306_Task",
      [2] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/NavMesh_Data/BH_Thea_IQ100306_Task_Navmesh.BH_Thea_IQ100306_Task_Navmesh"
    },
    OutTime = 0,
    RegionId = 1019,
    UnLoadLevelList = {
      "/Game/Maps/Levels/Chapter01/BH_Thea_Main/NavMesh_Data/BH_Thea_Navmesh.BH_Thea_Navmesh"
    },
    VarName = "IQ100306"
  },
  [12] = {
    Id = 12,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Sew_Main/Task_Data/Chapter01_Sew03_IQ100304_Task.Chapter01_Sew03_IQ100304_Task"
    },
    OutTime = 0,
    RegionId = 1017,
    VarName = "IQ100304"
  },
  [13] = {
    Id = 13,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Fil_DaFengBaoXiang200303_Task.Huaxu_Yanjindu_Fil_DaFengBaoXiang200303_Task"
    },
    OutTime = 0,
    RegionId = 1041,
    VarName = "DaFengBaoXiang200303"
  },
  [14] = {
    Id = 14,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/Task_Data/BH_Thea_IQ10030601_Task.BH_Thea_IQ10030601_Task"
    },
    OutTime = 0,
    RegionId = 1019,
    VarName = "IQ10030601"
  },
  [17] = {
    Id = 17,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/Task_Data/BH_Thea_Online_Task.BH_Thea_Online_Task"
    },
    OutTime = 0,
    RegionId = 1019,
    VarName = "BH_Thea_Online"
  },
  [18] = {
    Id = 18,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_TrafficWay_IQ10030498_Task.Chapter01_TrafficWay_IQ10030498_Task"
    },
    OutTime = 0,
    RegionId = 1011,
    VarName = "IQ10030498"
  },
  [19] = {
    Id = 19,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Alt/Task_Data/Huaxu_Yanjindu_Alt_AltStart_Task.Huaxu_Yanjindu_Alt_AltStart_Task"
    },
    OutTime = 0,
    RegionId = 1057,
    VarName = "AltStart"
  },
  [20] = {
    Id = 20,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Design_Data/Huaxu_Haojing_IQ12020122_DesignTask.Huaxu_Haojing_IQ12020122_DesignTask"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "Wuyousheng_First_12020122"
  },
  [21] = {
    Id = 21,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Design_Data/Huaxu_Haojing_IQ12020212_DesignTask.Huaxu_Haojing_IQ12020212_DesignTask"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "Wuyousheng_Escape_12020212"
  },
  [22] = {
    Id = 22,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_TRLM/Design_Data/Huaxu_Haojing_TRLM_IQ12020515_DesignTask.Huaxu_Haojing_TRLM_IQ12020515_DesignTask"
    },
    OutTime = 0,
    RegionId = 1053,
    VarName = "Special_Zhiliu_12020515"
  },
  [23] = {
    Id = 23,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjingdu_Shi_12010307_Task.Huaxu_Yanjingdu_Shi_12010307_Task"
    },
    OutTime = 0,
    RegionId = 1041,
    VarName = "IQ12010307"
  },
  [24] = {
    Id = 24,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Npc01_Task.Huaxu_Yanjindu_Npc01_Task"
    },
    OutTime = 0,
    RegionId = 1041,
    VarName = "IQ12010313"
  },
  [25] = {
    Id = 25,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Batt_12010502_Task.Huaxu_Yanjindu_Batt_12010502_Task"
    },
    OutTime = 0,
    RegionId = 1041,
    VarName = "IQ12010502"
  },
  [26] = {
    Id = 26,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Alt/Task_Data/Huaxu_Yanjindu_Alt_12010513_Task.Huaxu_Yanjindu_Alt_12010513_Task"
    },
    OutTime = 0,
    RegionId = 1057,
    VarName = "IQ12010513"
  },
  [27] = {
    Id = 27,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Batt_12010513_fu_Task.Huaxu_Yanjindu_Batt_12010513_fu_Task"
    },
    OutTime = 0,
    RegionId = 1041,
    VarName = "IQ12010513_fu"
  },
  [28] = {
    Id = 28,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_IQ120315_Task.Huaxu_Yanjindu_IQ120315_Task"
    },
    OutTime = 0,
    RegionId = 1041,
    VarName = "IQ120315"
  },
  [29] = {
    Id = 29,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ1203_Task01.Huaxu_Haojing_IQ1203_Task01"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "FengxiangBaoming"
  },
  [30] = {
    Id = 30,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ1203_Task02.Huaxu_Haojing_IQ1203_Task02"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "FengxiangXiaochi"
  },
  [31] = {
    Id = 31,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ1203_Task03.Huaxu_Haojing_IQ1203_Task03"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "FengxiangBoss"
  },
  [32] = {
    Id = 32,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ120307_Task.Huaxu_Haojing_IQ120307_Task"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "IQ12030706"
  },
  [33] = {
    Id = 33,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ12030706_Task.Huaxu_Haojing_IQ12030706_Task"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "IQ12030706_jlc"
  },
  [34] = {
    Id = 34,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ12020517_Task.Huaxu_Haojing_IQ12020517_Task"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "IQ12020517"
  },
  [35] = {
    Id = 35,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Reb/Task_Data/Huaxu_Haojing_IQ12020401_Task.Huaxu_Haojing_IQ12020401_Task"
    },
    OutTime = 0,
    RegionId = 1052,
    VarName = "IQ12020401"
  },
  [36] = {
    Id = 36,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040401_Task.Haiboliya_Chezhan_YW_IQ10040401_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Navmesh_Data/Haiboliya_Chezhan_YW_IQ10040401_Task_Navmesh.Haiboliya_Chezhan_YW_IQ10040401_Task_Navmesh"
    },
    OutTime = 0,
    RegionId = 1061,
    VarName = "IQ10040401"
  },
  [37] = {
    Id = 37,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040402_Task.Haiboliya_Chezhan_YW_IQ10040402_Task"
    },
    OutTime = 0,
    RegionId = 1061,
    VarName = "IQ10040402"
  },
  [38] = {
    Id = 38,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040403_Task.Haiboliya_Chezhan_YW_IQ10040403_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Navmesh_Data/Haiboliya_Chezhan_YW_IQ10040403_Task_Navmesh.Haiboliya_Chezhan_YW_IQ10040403_Task_Navmesh"
    },
    OutTime = 0,
    RegionId = 1061,
    VarName = "IQ10040403"
  },
  [39] = {
    Id = 39,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040406_Task.Haiboliya_Chezhan_YW_IQ10040406_Task"
    },
    OutTime = 0,
    RegionId = 1061,
    VarName = "IQ10040406"
  },
  [40] = {
    Id = 40,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ100424_Task.Haiboliya_Chezhan_YW_IQ100424_Task"
    },
    OutTime = 0,
    RegionId = 1061,
    VarName = "IQ10040424"
  },
  [41] = {
    Id = 41,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040506_Task.Haiboliya_Chezhan_YW_IQ10040506_Task"
    },
    OutTime = 0,
    RegionId = 1061,
    VarName = "IQ10040506"
  },
  [42] = {
    Id = 42,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Int/Design_Data/Huaxu_Haojing_Int_IQ12020208_DesignTask.Huaxu_Haojing_Int_IQ12020208_DesignTask"
    },
    OutTime = 0,
    RegionId = 1051,
    VarName = "Qianxing12020208"
  },
  [43] = {
    Id = 43,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Int/Task_Data/Huaxu_Haojing_Int_IQ12020208_Task.Huaxu_Haojing_Int_IQ12020208_Task"
    },
    OutTime = 0,
    RegionId = 1051,
    VarName = "Int12020208"
  },
  [44] = {
    Id = 44,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ120202_Task04.Huaxu_Haojing_IQ120202_Task04"
    },
    OutTime = 0,
    RegionId = 1045,
    VarName = "ZhiliuA12020414"
  },
  [45] = {
    Id = 45,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_Online_Task.Haiboliya_Chezhan_Online_Task"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "Haiboliya_Chezhan_Online"
  },
  [46] = {
    Id = 46,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ100402_Task.Haiboliya_Chezhan_YT_IQ100402_Task"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10040207"
  },
  [47] = {
    Id = 47,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ120206_Task.Haiboliya_Chezhan_YT_IQ120206_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ120206_Task_Navmesh.Haiboliya_Chezhan_YT_IQ120206_Task_Navmesh"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10030702"
  },
  [48] = {
    Id = 48,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ100403_Task.Haiboliya_Chezhan_YT_IQ100403_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ100403_Task_NavMesh.Haiboliya_Chezhan_YT_IQ100403_Task_NavMesh"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10040312"
  },
  [49] = {
    Id = 49,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040510_Task.Haiboliya_Chezhan_YT_IQ10040510_Task",
      [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ10040510_Task_NavMesh.Haiboliya_Chezhan_YT_IQ10040510_Task_NavMesh"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10040510"
  },
  [50] = {
    Id = 50,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040205_Task.Haiboliya_Chezhan_YT_IQ10040205_Task"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10040205"
  },
  [51] = {
    Id = 51,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040204_Task.Haiboliya_Chezhan_YT_IQ10040204_Task"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10040204"
  },
  [52] = {
    Id = 52,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040208_Task.Haiboliya_Chezhan_YT_IQ10040208_Task"
    },
    OutTime = 0,
    RegionId = 1060,
    VarName = "IQ10040208"
  },
  [53] = {
    Id = 53,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_CZDX/Task_Data/Haiboliya_Chezhan_CZDX_IQ200404_Task.Haiboliya_Chezhan_CZDX_IQ200404_Task"
    },
    OutTime = 0,
    RegionId = 1063,
    VarName = "IQ200404"
  },
  [54] = {
    Id = 54,
    InTime = 0,
    LoadLevel = {
      [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_CZDX/Task_Data/Haiboliya_Chezhan_CZDX_IQ200405_Task.Haiboliya_Chezhan_CZDX_IQ200405_Task"
    },
    OutTime = 0,
    RegionId = 1063,
    VarName = "IQ200405"
  }
})
