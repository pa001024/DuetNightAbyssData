local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Clue", {
  [100101] = {
    ClueContent = {
      10010101,
      10010102,
      10010103
    },
    ClueID = 100101,
    ClueName = "UI_ClueName_100101",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0005.T_StringBoard_Main_0005'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0005.T_StringBoard_Main_0005'",
    ClueType = 1
  },
  [100102] = {
    ClueContent = {
      10010201,
      10010202,
      10010203,
      10010204
    },
    ClueID = 100102,
    ClueName = "UI_ClueName_100102",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0006.T_StringBoard_Main_0006'",
    ClueType = 1
  },
  [100201] = {
    ClueContent = {
      10020101,
      10020102,
      10020103
    },
    ClueID = 100201,
    ClueName = "UI_ClueName_100201",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0007.T_StringBoard_Main_0007'",
    ClueType = 1
  },
  [100301] = {
    ClueContent = {
      10030101,
      10030102,
      10030103,
      10030104,
      10030105
    },
    ClueID = 100301,
    ClueName = "UI_ClueName_100301",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0008.T_StringBoard_Main_0008'",
    ClueType = 1
  },
  [100302] = {
    ClueContent = {10030201, 10030202},
    ClueID = 100302,
    ClueName = "UI_ClueName_100302",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0009.T_StringBoard_Main_0009'",
    ClueType = 1
  },
  [100303] = {
    ClueContent = {
      10030301,
      10030302,
      10030303
    },
    ClueID = 100303,
    ClueName = "UI_ClueName_100303",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0010.T_StringBoard_Main_0010'",
    ClueType = 1
  },
  [100304] = {
    ClueContent = {
      10030401,
      10030402,
      10030403,
      10030404,
      10030405
    },
    ClueID = 100304,
    ClueName = "UI_ClueName_100304",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0011.T_StringBoard_Main_0011'",
    ClueType = 1
  },
  [100305] = {
    ClueContent = {
      10030406,
      10030407,
      10030408,
      10030409,
      10030410
    },
    ClueID = 100305,
    ClueName = "UI_ClueName_100305",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0012.T_StringBoard_Main_0012'",
    ClueType = 1
  },
  [110101] = {
    ClueContent = {11010101, 11010102},
    ClueID = 110101,
    ClueName = "UI_ClueName_110101",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0013.T_StringBoard_Main_0013'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0014.T_StringBoard_Main_0014'",
    ClueType = 2
  },
  [110201] = {
    ClueContent = {11020101, 11020102},
    ClueID = 110201,
    ClueName = "UI_ClueName_110201",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0015.T_StringBoard_Main_0015'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0016.T_StringBoard_Main_0016'",
    ClueType = 2
  },
  [110301] = {
    ClueContent = {
      11030101,
      11030102,
      11030103,
      11030104
    },
    ClueID = 110301,
    ClueName = "UI_ClueName_110301",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0017.T_StringBoard_Main_0017'",
    ClueType = 2
  },
  [110302] = {
    ClueContent = {11030201, 11030202},
    ClueID = 110302,
    ClueName = "UI_ClueName_110302",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0018.T_StringBoard_Main_0018'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0019.T_StringBoard_Main_0019'",
    ClueType = 2
  },
  [110303] = {
    ClueContent = {11030301},
    ClueID = 110303,
    ClueName = "UI_ClueName_110303",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0019.T_StringBoard_Main_0019'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0021.T_StringBoard_Main_0021'",
    ClueType = 2
  },
  [110304] = {
    ClueContent = {
      11030401,
      11030402,
      11030403
    },
    ClueID = 110304,
    ClueName = "UI_ClueName_110304",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0022.T_StringBoard_Main_0022'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0023.T_StringBoard_Main_0023'",
    ClueType = 2
  },
  [110305] = {
    ClueContent = {11030501, 11030502},
    ClueID = 110305,
    ClueName = "UI_ClueName_110305",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0069.T_StringBoard_Main_0069'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0025.T_StringBoard_Main_0025'",
    ClueType = 2
  },
  [120101] = {
    ClueContent = {
      12010101,
      12010102,
      12010103
    },
    ClueID = 120101,
    ClueName = "UI_ClueName_120101",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0026.T_StringBoard_Main_0026'",
    ClueType = 3
  },
  [120201] = {
    ClueContent = {12020101},
    ClueID = 120201,
    ClueName = "UI_ClueName_120201",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0027.T_StringBoard_Main_0027'",
    ClueType = 3
  },
  [120202] = {
    ClueContent = {
      12020201,
      12020202,
      12020203,
      12020204,
      12020205,
      12020206,
      12020207
    },
    ClueID = 120202,
    ClueName = "UI_ClueName_120202",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0028.T_StringBoard_Main_0028'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0029.T_StringBoard_Main_0029'",
    ClueType = 3
  },
  [120203] = {
    ClueContent = {
      12020301,
      12020302,
      12020303,
      12020304,
      12020305
    },
    ClueID = 120203,
    ClueName = "UI_ClueName_120203",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0030.T_StringBoard_Main_0030'",
    ClueType = 3
  },
  [120204] = {
    ClueContent = {
      12020401,
      12020402,
      12020403,
      12020404
    },
    ClueID = 120204,
    ClueName = "UI_ClueName_120204",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0031.T_StringBoard_Main_0031'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0032.T_StringBoard_Main_0032'",
    ClueType = 3
  },
  [120205] = {
    ClueContent = {
      12020501,
      12020502,
      12020503
    },
    ClueID = 120205,
    ClueName = "UI_ClueName_120205",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0033.T_StringBoard_Main_0033'",
    ClueType = 3
  },
  [120206] = {
    ClueContent = {12020601, 12020602},
    ClueID = 120206,
    ClueName = "UI_ClueName_120206",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0034.T_StringBoard_Main_0034'",
    ClueType = 3
  },
  [120207] = {
    ClueContent = {12020701},
    ClueID = 120207,
    ClueName = "UI_ClueName_120207",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0035.T_StringBoard_Main_0035'",
    ClueType = 3
  },
  [120208] = {
    ClueContent = {12020801},
    ClueID = 120208,
    ClueName = "UI_ClueName_120208",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0036.T_StringBoard_Main_0036'",
    ClueType = 3
  },
  [120209] = {
    ClueContent = {
      12020901,
      12020902,
      12020903
    },
    ClueID = 120209,
    ClueName = "UI_ClueName_120209",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0037.T_StringBoard_Main_0037'",
    ClueType = 3
  },
  [120210] = {
    ClueContent = {12021001},
    ClueID = 120210,
    ClueName = "UI_ClueName_120210",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0038.T_StringBoard_Main_0038'",
    ClueType = 3
  },
  [120211] = {
    ClueContent = {12021101},
    ClueID = 120211,
    ClueName = "UI_ClueName_120211",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0039.T_StringBoard_Main_0039'",
    ClueType = 3
  },
  [120212] = {
    ClueContent = {
      12021201,
      12021202,
      12021203
    },
    ClueID = 120212,
    ClueName = "UI_ClueName_120212",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0040.T_StringBoard_Main_0040'",
    ClueType = 3
  },
  [120213] = {
    ClueContent = {12021301, 12021302},
    ClueID = 120213,
    ClueName = "UI_ClueName_120213",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0041.T_StringBoard_Main_0041'",
    ClueType = 3
  },
  [120214] = {
    ClueContent = {12021401, 12021402},
    ClueID = 120214,
    ClueName = "UI_ClueName_120214",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0042.T_StringBoard_Main_0042'",
    ClueType = 3
  },
  [120215] = {
    ClueContent = {12021501, 12021502},
    ClueID = 120215,
    ClueName = "UI_ClueName_120215",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0043.T_StringBoard_Main_0043'",
    ClueType = 3
  },
  [120216] = {
    ClueContent = {12021601, 12021602},
    ClueID = 120216,
    ClueName = "UI_ClueName_120216",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0044.T_StringBoard_Main_0044'",
    ClueType = 3
  },
  [120217] = {
    ClueContent = {12021701, 12021702},
    ClueID = 120217,
    ClueName = "UI_ClueName_120217",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0045.T_StringBoard_Main_0045'",
    ClueType = 3
  },
  [120218] = {
    ClueContent = {12021801, 12021802},
    ClueID = 120218,
    ClueName = "UI_ClueName_120218",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0046.T_StringBoard_Main_0046'",
    ClueType = 3
  },
  [120219] = {
    ClueContent = {12021901},
    ClueID = 120219,
    ClueName = "UI_ClueName_120219",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0047.T_StringBoard_Main_0047'",
    ClueType = 3
  },
  [120220] = {
    ClueContent = {12022001, 12022002},
    ClueID = 120220,
    ClueName = "UI_ClueName_120220",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0048.T_StringBoard_Main_0048'",
    ClueType = 3
  },
  [120221] = {
    ClueContent = {12022101},
    ClueID = 120221,
    ClueName = "UI_ClueName_120221",
    CluePic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0004.T_StringBoard_Main_0004'",
    CluePic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0049.T_StringBoard_Main_0049'",
    ClueType = 3
  }
})
