local T = {}
T.RT_1 = {
  [3] = 1,
  [6] = 1
}
T.RT_2 = {
  [1] = 0.6,
  [2] = 0.3,
  [3] = 0.07,
  [6] = 0.03
}
T.RT_3 = {1, 4}
T.RT_4 = {6, 4}
T.RT_5 = {2, 3}
T.RT_6 = {
  [4] = 1,
  [6] = 1
}
T.RT_7 = {
  [1] = 0.4,
  [2] = 0.3,
  [3] = 0.25,
  [6] = 0.05
}
T.RT_8 = {2, 4}
T.RT_9 = {
  [4] = 1,
  [5] = 1,
  [6] = 1
}
T.RT_10 = {
  [1] = 0.17,
  [2] = 0.4,
  [3] = 0.3,
  [4] = 0.02,
  [5] = 0.01,
  [6] = 0.1
}
T.RT_11 = {3, 4}
T.RT_12 = {8, 6}
T.RT_13 = {3, 5}
T.RT_14 = {
  [1] = 0.15,
  [2] = 0.2,
  [3] = 0.3,
  [4] = 0.2,
  [5] = 0.05,
  [6] = 0.1
}
T.RT_15 = {
  [3] = 1,
  [4] = 1,
  [6] = 1
}
T.RT_16 = {
  [1] = 0.17,
  [2] = 0.2,
  [3] = 0.3,
  [4] = 0.2,
  [6] = 0.03
}
T.RT_17 = {
  [1] = 0.2,
  [2] = 0.2,
  [3] = 0.3,
  [4] = 0.2,
  [6] = 0.1
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureMechanism", {
  [131059] = {
    ItemLevelLimit = T.RT_1,
    ItemLevelWeight = T.RT_2,
    ItemNumRange = T.RT_3,
    MechanismID = 131059,
    MechanismName = "UI_Extraction_TM_50",
    Shape = T.RT_4
  },
  [131060] = {
    ItemLevelLimit = T.RT_1,
    ItemLevelWeight = T.RT_2,
    ItemNumRange = T.RT_5,
    MechanismID = 131060,
    MechanismName = "UI_Extraction_TM_51",
    Shape = T.RT_4
  },
  [131061] = {
    ItemLevelLimit = T.RT_1,
    ItemLevelWeight = T.RT_2,
    ItemNumRange = T.RT_3,
    MechanismID = 131061,
    MechanismName = "UI_Extraction_TM_52",
    Shape = T.RT_4
  },
  [131062] = {
    ItemLevelLimit = T.RT_6,
    ItemLevelWeight = T.RT_7,
    ItemNumRange = T.RT_5,
    MechanismID = 131062,
    MechanismName = "UI_Extraction_TM_53",
    Shape = T.RT_4
  },
  [131063] = {
    ItemLevelLimit = T.RT_6,
    ItemLevelWeight = T.RT_7,
    ItemNumRange = T.RT_5,
    MechanismID = 131063,
    MechanismName = "UI_Extraction_TM_54",
    Shape = T.RT_4
  },
  [131064] = {
    ItemLevelLimit = T.RT_6,
    ItemLevelWeight = T.RT_7,
    ItemNumRange = T.RT_8,
    MechanismID = 131064,
    MechanismName = "UI_Extraction_TM_55",
    Shape = T.RT_4
  },
  [131065] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_10,
    ItemNumRange = T.RT_11,
    MechanismID = 131065,
    MechanismName = "UI_Extraction_TM_56",
    Shape = T.RT_12
  },
  [131066] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_10,
    ItemNumRange = T.RT_13,
    MechanismID = 131066,
    MechanismName = "UI_Extraction_TM_57",
    Shape = T.RT_12
  },
  [131072] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_14,
    ItemNumRange = T.RT_13,
    MechanismID = 131072,
    MechanismName = "UI_Extraction_TM_56",
    Shape = T.RT_12
  },
  [131074] = {
    ItemLevelLimit = T.RT_1,
    ItemLevelWeight = T.RT_2,
    ItemNumRange = T.RT_3,
    MechanismID = 131074,
    MechanismName = "UI_Extraction_TM_50",
    Shape = T.RT_4
  },
  [131075] = {
    ItemLevelLimit = T.RT_1,
    ItemLevelWeight = T.RT_2,
    ItemNumRange = T.RT_5,
    MechanismID = 131075,
    MechanismName = "UI_Extraction_TM_51",
    Shape = T.RT_4
  },
  [131076] = {
    ItemLevelLimit = T.RT_1,
    ItemLevelWeight = T.RT_2,
    ItemNumRange = T.RT_3,
    MechanismID = 131076,
    MechanismName = "UI_Extraction_TM_52",
    Shape = T.RT_4
  },
  [131077] = {
    ItemLevelLimit = T.RT_15,
    ItemLevelWeight = T.RT_16,
    ItemNumRange = T.RT_5,
    MechanismID = 131077,
    MechanismName = "UI_Extraction_TM_53",
    Shape = T.RT_4
  },
  [131078] = {
    ItemLevelLimit = T.RT_15,
    ItemLevelWeight = T.RT_16,
    ItemNumRange = T.RT_5,
    MechanismID = 131078,
    MechanismName = "UI_Extraction_TM_54",
    Shape = T.RT_4
  },
  [131079] = {
    ItemLevelLimit = T.RT_15,
    ItemLevelWeight = T.RT_16,
    ItemNumRange = T.RT_8,
    MechanismID = 131079,
    MechanismName = "UI_Extraction_TM_55",
    Shape = T.RT_4
  },
  [131080] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_14,
    ItemNumRange = T.RT_11,
    MechanismID = 131080,
    MechanismName = "UI_Extraction_TM_56",
    Shape = T.RT_12
  },
  [131081] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_14,
    ItemNumRange = T.RT_13,
    MechanismID = 131081,
    MechanismName = "UI_Extraction_TM_57",
    Shape = T.RT_12
  },
  [131084] = {
    ItemLevelLimit = T.RT_15,
    ItemLevelWeight = T.RT_17,
    ItemNumRange = T.RT_8,
    MechanismID = 131084,
    MechanismName = "UI_Extraction_TM_50",
    Shape = T.RT_12
  },
  [131085] = {
    ItemLevelLimit = T.RT_15,
    ItemLevelWeight = T.RT_17,
    ItemNumRange = T.RT_5,
    MechanismID = 131085,
    MechanismName = "UI_Extraction_TM_51",
    Shape = T.RT_12
  },
  [131086] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_14,
    ItemNumRange = T.RT_11,
    MechanismID = 131086,
    MechanismName = "UI_Extraction_TM_55",
    Shape = T.RT_12
  },
  [131087] = {
    ItemLevelLimit = T.RT_9,
    ItemLevelWeight = T.RT_14,
    ItemNumRange = {2, 5},
    MechanismID = 131087,
    MechanismName = "UI_Extraction_TM_53",
    Shape = T.RT_12
  }
})
