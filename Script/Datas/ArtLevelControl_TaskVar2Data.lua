local T = {}
T.RT_1 = {
  [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040506_Task.Haiboliya_Chezhan_YW_IQ10040506_Task"
}
T.RT_2 = {
  [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ100424_Task.Haiboliya_Chezhan_YW_IQ100424_Task"
}
T.RT_3 = {
  [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040401_Task.Haiboliya_Chezhan_YW_IQ10040401_Task",
  [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Navmesh_Data/Haiboliya_Chezhan_YW_IQ10040401_Task_Navmesh.Haiboliya_Chezhan_YW_IQ10040401_Task_Navmesh"
}
T.RT_4 = {
  [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040204_Task.Haiboliya_Chezhan_YT_IQ10040204_Task"
}
T.RT_5 = {
  [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040208_Task.Haiboliya_Chezhan_YT_IQ10040208_Task"
}
T.RT_6 = {
  [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00010",
  [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00011",
  [3] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00012",
  [4] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00013",
  [5] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00018",
  [6] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00019",
  [7] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00020",
  [8] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00021",
  [9] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00025",
  [10] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00026",
  [11] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00027",
  [12] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00028"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ArtLevelControl_TaskVar2Data", {
  AltStart = {
    [1057] = {
      Id = 19,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Alt/Task_Data/Huaxu_Yanjindu_Alt_AltStart_Task.Huaxu_Yanjindu_Alt_AltStart_Task"
      },
      OutTime = 0,
      RegionId = 1057,
      VarName = "AltStart"
    }
  },
  BH_Thea_Online = {
    [1019] = {
      Id = 17,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/Task_Data/BH_Thea_Online_Task.BH_Thea_Online_Task"
      },
      OutTime = 0,
      RegionId = 1019,
      VarName = "BH_Thea_Online"
    }
  },
  CZIQ10040401 = {
    [1060] = {
      Id = 50,
      InTime = 0,
      OutTime = 0,
      RegionId = 1060,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ120206_Task.Haiboliya_Chezhan_YT_IQ120206_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ120206_Task_Navmesh.Haiboliya_Chezhan_YT_IQ120206_Task_Navmesh",
        [3] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ100403_Task_NavMesh.Haiboliya_Chezhan_YT_IQ100403_Task_NavMesh",
        [4] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ100403_Task.Haiboliya_Chezhan_YT_IQ100403_Task"
      },
      VarName = "CZIQ10040401"
    }
  },
  DaFengBaoXiang200303 = {
    [1041] = {
      Id = 13,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Fil_DaFengBaoXiang200303_Task.Huaxu_Yanjindu_Fil_DaFengBaoXiang200303_Task"
      },
      OutTime = 0,
      RegionId = 1041,
      VarName = "DaFengBaoXiang200303"
    }
  },
  FengxiangBaoming = {
    [1045] = {
      Id = 29,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ1203_Task01.Huaxu_Haojing_IQ1203_Task01"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "FengxiangBaoming"
    }
  },
  FengxiangBoss = {
    [1045] = {
      Id = 31,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ1203_Task03.Huaxu_Haojing_IQ1203_Task03"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "FengxiangBoss"
    }
  },
  FengxiangXiaochi = {
    [1045] = {
      Id = 30,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ1203_Task02.Huaxu_Haojing_IQ1203_Task02"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "FengxiangXiaochi"
    }
  },
  Haiboliya_Chezhan_Online = {
    [1060] = {
      Id = 47,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_Online_Task.Haiboliya_Chezhan_Online_Task"
      },
      OutTime = 0,
      RegionId = 1060,
      VarName = "Haiboliya_Chezhan_Online"
    }
  },
  IQ1002 = {
    [1011] = {
      Id = 2,
      InTime = 0.5,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_TrafficWay_IQ1002_Task.Chapter01_TrafficWay_IQ1002_Task",
        [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_TrafficWay_IQ1002_Task_NavMesh.Chapter01_TrafficWay_IQ1002_Task_NavMesh"
      },
      OutTime = 0.5,
      RegionId = 1011,
      UnLoadLevel = T.RT_6,
      VarName = "IQ1002"
    }
  },
  IQ1003 = {
    [1011] = {
      Id = 1,
      InTime = 0.5,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_IcelakeCIty_IQ1003_Task.Chapter01_IcelakeCIty_IQ1003_Task",
        [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_IQ1003_Task_NavMesh.Chapter01_IcelakeCity_IQ1003_Task_NavMesh"
      },
      OutTime = 0.5,
      RegionId = 1011,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00029",
        [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00030",
        [3] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00031",
        [4] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00040",
        [5] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00041",
        [6] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00042",
        [7] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00043",
        [8] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00053",
        [9] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00054",
        [10] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00055",
        [11] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_Icelake_NavMesh_00056",
        [12] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00004",
        [13] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00005",
        [14] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00006",
        [15] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00007",
        [16] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00008",
        [17] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00009",
        [18] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_IcelakeCity_NavMesh_00010"
      },
      VarName = "IQ1003"
    }
  },
  IQ100303 = {
    [1011] = {
      Id = 5,
      InTime = 0.5,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_TrafficWay_IQ100303_Task.Chapter01_TrafficWay_IQ100303_Task",
        [2] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Navmesh_Data/Chapter01_TrafficWay_IQ100303_Task_NavMesh.Chapter01_TrafficWay_IQ100303_Task_NavMesh"
      },
      OutTime = 0.5,
      RegionId = 1011,
      UnLoadLevel = T.RT_6,
      VarName = "IQ100303"
    }
  },
  IQ100304 = {
    [1017] = {
      Id = 12,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Sew_Main/Task_Data/Chapter01_Sew03_IQ100304_Task.Chapter01_Sew03_IQ100304_Task"
      },
      OutTime = 0,
      RegionId = 1017,
      VarName = "IQ100304"
    }
  },
  IQ10030498 = {
    [1011] = {
      Id = 18,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/Chapter01_Main/Task_Data/Chapter01_TrafficWay_IQ10030498_Task.Chapter01_TrafficWay_IQ10030498_Task"
      },
      OutTime = 0,
      RegionId = 1011,
      VarName = "IQ10030498"
    }
  },
  IQ100306 = {
    [1019] = {
      Id = 11,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/Task_Data/BH_Thea_IQ100306_Task.BH_Thea_IQ100306_Task",
        [2] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/NavMesh_Data/BH_Thea_IQ100306_Task_Navmesh.BH_Thea_IQ100306_Task_Navmesh"
      },
      OutTime = 0,
      RegionId = 1019,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/NavMesh_Data/BH_Thea_Navmesh.BH_Thea_Navmesh"
      },
      VarName = "IQ100306"
    }
  },
  IQ10030601 = {
    [1019] = {
      Id = 14,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Chapter01/BH_Thea_Main/Task_Data/BH_Thea_IQ10030601_Task.BH_Thea_IQ10030601_Task"
      },
      OutTime = 0,
      RegionId = 1019,
      VarName = "IQ10030601"
    }
  },
  IQ10030702 = {
    [1060] = {
      Id = 49,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ120206_Task.Haiboliya_Chezhan_YT_IQ120206_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ120206_Task_Navmesh.Haiboliya_Chezhan_YT_IQ120206_Task_Navmesh"
      },
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10030702"
    }
  },
  IQ10040204 = {
    [1060] = {
      Id = 54,
      InTime = 0,
      LoadLevel = T.RT_4,
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10040204"
    }
  },
  IQ10040205 = {
    [1060] = {
      Id = 53,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040205_Task.Haiboliya_Chezhan_YT_IQ10040205_Task"
      },
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10040205"
    }
  },
  IQ10040207 = {
    [1060] = {
      Id = 48,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ100402_Task.Haiboliya_Chezhan_YT_IQ100402_Task"
      },
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10040207"
    }
  },
  IQ10040208 = {
    [1060] = {
      Id = 56,
      InTime = 0,
      LoadLevel = T.RT_5,
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10040208"
    }
  },
  IQ10040209 = {
    [1060] = {
      Id = 57,
      InTime = 0,
      OutTime = 0,
      RegionId = 1060,
      UnLoadLevel = T.RT_5,
      VarName = "IQ10040209"
    }
  },
  IQ10040310 = {
    [1060] = {
      Id = 55,
      InTime = 0,
      OutTime = 0,
      RegionId = 1060,
      UnLoadLevel = T.RT_4,
      VarName = "IQ10040310"
    }
  },
  IQ10040312 = {
    [1060] = {
      Id = 51,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ100403_Task.Haiboliya_Chezhan_YT_IQ100403_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ100403_Task_NavMesh.Haiboliya_Chezhan_YT_IQ100403_Task_NavMesh"
      },
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10040312"
    }
  },
  IQ10040401 = {
    [1061] = {
      Id = 36,
      InTime = 0,
      LoadLevel = T.RT_3,
      OutTime = 0,
      RegionId = 1061,
      VarName = "IQ10040401"
    }
  },
  IQ10040402 = {
    [1061] = {
      Id = 37,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ100424_Task.Haiboliya_Chezhan_YW_IQ100424_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040402_Task.Haiboliya_Chezhan_YW_IQ10040402_Task"
      },
      OutTime = 0,
      RegionId = 1061,
      VarName = "IQ10040402"
    }
  },
  IQ10040403 = {
    [1061] = {
      Id = 38,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040403_Task.Haiboliya_Chezhan_YW_IQ10040403_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Navmesh_Data/Haiboliya_Chezhan_YW_IQ10040403_Task_Navmesh.Haiboliya_Chezhan_YW_IQ10040403_Task_Navmesh"
      },
      OutTime = 0,
      RegionId = 1061,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040402_Task.Haiboliya_Chezhan_YW_IQ10040402_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040401_Task.Haiboliya_Chezhan_YW_IQ10040401_Task",
        [3] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Navmesh_Data/Haiboliya_Chezhan_YW_IQ10040401_Task_Navmesh.Haiboliya_Chezhan_YW_IQ10040401_Task_Navmesh"
      },
      VarName = "IQ10040403"
    }
  },
  IQ10040406 = {
    [1061] = {
      Id = 39,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040406_Task.Haiboliya_Chezhan_YW_IQ10040406_Task"
      },
      OutTime = 0,
      RegionId = 1061,
      UnLoadLevel = T.RT_2,
      VarName = "IQ10040406"
    }
  },
  IQ10040407 = {
    [1061] = {
      Id = 43,
      InTime = 0,
      LoadLevel = T.RT_2,
      OutTime = 0,
      RegionId = 1061,
      VarName = "IQ10040407"
    }
  },
  IQ10040424 = {
    [1061] = {
      Id = 40,
      InTime = 0,
      LoadLevel = T.RT_3,
      OutTime = 0,
      RegionId = 1061,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040406_Task.Haiboliya_Chezhan_YW_IQ10040406_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Navmesh_Data/Haiboliya_Chezhan_YW_IQ10040403_Task_Navmesh.Haiboliya_Chezhan_YW_IQ10040403_Task_Navmesh",
        [3] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_YW/Task_Data/Haiboliya_Chezhan_YW_IQ10040403_Task.Haiboliya_Chezhan_YW_IQ10040403_Task"
      },
      VarName = "IQ10040424"
    }
  },
  IQ10040506 = {
    [1061] = {
      Id = 41,
      InTime = 0,
      LoadLevel = T.RT_1,
      OutTime = 0,
      RegionId = 1061,
      UnLoadLevel = T.RT_2,
      VarName = "IQ10040506"
    }
  },
  IQ10040510 = {
    [1060] = {
      Id = 52,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Task_Data/Haiboliya_Chezhan_YT_IQ10040510_Task.Haiboliya_Chezhan_YT_IQ10040510_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Chezhan_Main/Navmesh_Data/Haiboliya_Chezhan_YT_IQ10040510_Task_NavMesh.Haiboliya_Chezhan_YT_IQ10040510_Task_NavMesh"
      },
      OutTime = 0,
      RegionId = 1060,
      VarName = "IQ10040510"
    }
  },
  IQ10040514 = {
    [1061] = {
      Id = 42,
      InTime = 0,
      LoadLevel = T.RT_2,
      OutTime = 0,
      RegionId = 1061,
      UnLoadLevel = T.RT_1,
      VarName = "IQ10040514"
    }
  },
  IQ110103 = {
    [1021] = {
      Id = 3,
      InTime = 0.5,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha01_IQ110103_Task.Haiboliya_Longsha01_IQ110103_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha01_IQ110103_Task_Navmesh.Haiboliya_Longsha01_IQ110103_Task_Navmesh"
      },
      OutTime = 0.5,
      RegionId = 1021,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha01_NavMesh.Haiboliya_Longsha01_NavMesh"
      },
      VarName = "IQ110103"
    }
  },
  IQ110107 = {
    [1021] = {
      Id = 4,
      InTime = 0.5,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_IQ110107_Task.Haiboliya_Longsha02_IQ110107_Task",
        [2] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha02_IQ110107_Task_Navmesh.Haiboliya_Longsha02_IQ110107_Task_Navmesh"
      },
      OutTime = 0.5,
      RegionId = 1021,
      UnLoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Navmesh_Data/Haiboliya_Longsha02_NavMesh.Haiboliya_Longsha02_NavMesh"
      },
      VarName = "IQ110107"
    }
  },
  IQ12010307 = {
    [1041] = {
      Id = 23,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjingdu_Shi_12010307_Task.Huaxu_Yanjingdu_Shi_12010307_Task"
      },
      OutTime = 0,
      RegionId = 1041,
      VarName = "IQ12010307"
    }
  },
  IQ12010313 = {
    [1041] = {
      Id = 24,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Npc01_Task.Huaxu_Yanjindu_Npc01_Task"
      },
      OutTime = 0,
      RegionId = 1041,
      VarName = "IQ12010313"
    }
  },
  IQ12010502 = {
    [1041] = {
      Id = 25,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Batt_12010502_Task.Huaxu_Yanjindu_Batt_12010502_Task"
      },
      OutTime = 0,
      RegionId = 1041,
      VarName = "IQ12010502"
    }
  },
  IQ12010513 = {
    [1057] = {
      Id = 26,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Alt/Task_Data/Huaxu_Yanjindu_Alt_12010513_Task.Huaxu_Yanjindu_Alt_12010513_Task"
      },
      OutTime = 0,
      RegionId = 1057,
      VarName = "IQ12010513"
    }
  },
  IQ12010513_fu = {
    [1041] = {
      Id = 27,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_Batt_12010513_fu_Task.Huaxu_Yanjindu_Batt_12010513_fu_Task"
      },
      OutTime = 0,
      RegionId = 1041,
      VarName = "IQ12010513_fu"
    }
  },
  IQ12020401 = {
    [1052] = {
      Id = 35,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Reb/Task_Data/Huaxu_Haojing_IQ12020401_Task.Huaxu_Haojing_IQ12020401_Task"
      },
      OutTime = 0,
      RegionId = 1052,
      VarName = "IQ12020401"
    }
  },
  IQ12020517 = {
    [1045] = {
      Id = 34,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ12020517_Task.Huaxu_Haojing_IQ12020517_Task"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "IQ12020517"
    }
  },
  IQ12030706 = {
    [1045] = {
      Id = 32,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ120307_Task.Huaxu_Haojing_IQ120307_Task"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "IQ12030706"
    }
  },
  IQ12030706_jlc = {
    [1045] = {
      Id = 33,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ12030706_Task.Huaxu_Haojing_IQ12030706_Task"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "IQ12030706_jlc"
    }
  },
  IQ120315 = {
    [1041] = {
      Id = 28,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Yanjindu_Main/Task_Data/Huaxu_Yanjindu_IQ120315_Task.Huaxu_Yanjindu_IQ120315_Task"
      },
      OutTime = 0,
      RegionId = 1041,
      VarName = "IQ120315"
    }
  },
  Int12020208 = {
    [1051] = {
      Id = 45,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Int/Task_Data/Huaxu_Haojing_Int_IQ12020208_Task.Huaxu_Haojing_Int_IQ12020208_Task"
      },
      OutTime = 0,
      RegionId = 1051,
      VarName = "Int12020208"
    }
  },
  LinshiNPC110101 = {
    [1021] = {
      Id = 7,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_LinshiNPC110101_Task.Haiboliya_Longsha02_LinshiNPC110101_Task"
      },
      OutTime = 0,
      RegionId = 1021,
      VarName = "LinshiNPC110101"
    }
  },
  NPC110108 = {
    [1021] = {
      Id = 6,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_NPC110108_Task.Haiboliya_Longsha02_NPC110108_Task"
      },
      OutTime = 0,
      RegionId = 1021,
      VarName = "NPC110108"
    }
  },
  NengYuanNPC110105 = {
    [1021] = {
      Id = 8,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_NengYuanNPC110105_Task.Haiboliya_Longsha02_NengYuanNPC110105_Task"
      },
      OutTime = 0,
      RegionId = 1021,
      VarName = "NengYuanNPC110105"
    }
  },
  Qianxing12020208 = {
    [1051] = {
      Id = 44,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Int/Design_Data/Huaxu_Haojing_Int_IQ12020208_DesignTask.Huaxu_Haojing_Int_IQ12020208_DesignTask"
      },
      OutTime = 0,
      RegionId = 1051,
      VarName = "Qianxing12020208"
    }
  },
  ShenWenNPC110105 = {
    [1021] = {
      Id = 9,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_ShenWenNPC110105_Task.Haiboliya_Longsha02_ShenWenNPC110105_Task"
      },
      OutTime = 0,
      RegionId = 1021,
      VarName = "ShenWenNPC110105"
    }
  },
  Special_Zhiliu_12020515 = {
    [1053] = {
      Id = 22,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_TRLM/Design_Data/Huaxu_Haojing_TRLM_IQ12020515_DesignTask.Huaxu_Haojing_TRLM_IQ12020515_DesignTask"
      },
      OutTime = 0,
      RegionId = 1053,
      VarName = "Special_Zhiliu_12020515"
    }
  },
  Wuyousheng_Escape_12020212 = {
    [1045] = {
      Id = 21,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Design_Data/Huaxu_Haojing_IQ12020212_DesignTask.Huaxu_Haojing_IQ12020212_DesignTask"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "Wuyousheng_Escape_12020212"
    }
  },
  Wuyousheng_First_12020122 = {
    [1045] = {
      Id = 20,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Design_Data/Huaxu_Haojing_IQ12020122_DesignTask.Huaxu_Haojing_IQ12020122_DesignTask"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "Wuyousheng_First_12020122"
    }
  },
  XimengNPC110105 = {
    [1021] = {
      Id = 10,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Haiboliya/Haiboliya_Longsha_Main/Task_Data/Haiboliya_Longsha02_XimengNPC110105_Task.Haiboliya_Longsha02_XimengNPC110105_Task"
      },
      OutTime = 0,
      RegionId = 1021,
      VarName = "XimengNPC110105"
    }
  },
  ZhiliuA12020414 = {
    [1045] = {
      Id = 46,
      InTime = 0,
      LoadLevel = {
        [1] = "/Game/Maps/Levels/Huaxu/Huaxu_Haojing_Main/Task_Data/Huaxu_Haojing_IQ120202_Task04.Huaxu_Haojing_IQ120202_Task04"
      },
      OutTime = 0,
      RegionId = 1045,
      VarName = "ZhiliuA12020414"
    }
  }
})
