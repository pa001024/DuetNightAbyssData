local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CluePage", {
  Ex02_Character_1201 = {
    ClueList = {120101},
    CluePageId = "Ex02_Character_1201",
    CluePageName = "UI_Investigation_Tab_Ex02_Character_1201",
    ClueTabType = "Ex02_Character",
    UnlockConditionID = 11020104
  },
  Ex02_Character_1202 = {
    ClueList = {
      120204,
      120201,
      120202,
      120203,
      120205,
      120206,
      120207
    },
    CluePageId = "Ex02_Character_1202",
    CluePageName = "UI_Investigation_Tab_Ex02_Character_1202",
    ClueTabType = "Ex02_Character",
    UnlockConditionID = 11020101
  },
  Ex02_Character_1203 = {
    ClueList = {
      120208,
      120209,
      120210,
      120211,
      120212,
      120213,
      120214
    },
    CluePageId = "Ex02_Character_1203",
    CluePageName = "UI_Investigation_Tab_Ex02_Character_1203",
    ClueTabType = "Ex02_Character",
    UnlockConditionID = 11020302
  },
  Ex02_Character_1204 = {
    ClueList = {
      120215,
      120216,
      120217,
      120218,
      120219,
      120220,
      120221
    },
    CluePageId = "Ex02_Character_1204",
    CluePageName = "UI_Investigation_Tab_Ex02_Character_1204",
    ClueTabType = "Ex02_Character",
    UnlockConditionID = 11020302
  },
  Ex02_MainStory_1001 = {
    ClueList = {100101, 100102},
    CluePageId = "Ex02_MainStory_1001",
    CluePageName = "UI_Investigation_Tab_Ex02_MainStory_1001",
    ClueTabType = "Ex02_Core",
    UnlockConditionID = 11020101
  },
  Ex02_MainStory_1002 = {
    ClueList = {100201},
    CluePageId = "Ex02_MainStory_1002",
    CluePageName = "UI_Investigation_Tab_Ex02_MainStory_1002",
    ClueTabType = "Ex02_Core",
    UnlockConditionID = 11020101
  },
  Ex02_MainStory_1003 = {
    ClueList = {
      100301,
      100302,
      100303,
      100304,
      100305
    },
    CluePageId = "Ex02_MainStory_1003",
    CluePageName = "UI_Investigation_Tab_Ex02_MainStory_1003",
    ClueTabType = "Ex02_Core",
    UnlockConditionID = 11020101
  },
  Ex02_Region_1101 = {
    ClueList = {110101},
    CluePageId = "Ex02_Region_1101",
    CluePageName = "UI_Investigation_Tab_Ex02_Region_1101",
    ClueTabType = "Ex02_Region",
    UnlockConditionID = 11020102
  },
  Ex02_Region_1102 = {
    ClueList = {110201},
    CluePageId = "Ex02_Region_1102",
    CluePageName = "UI_Investigation_Tab_Ex02_Region_1102",
    ClueTabType = "Ex02_Region",
    UnlockConditionID = 11020104
  },
  Ex02_Region_1103 = {
    ClueList = {
      110301,
      110302,
      110303,
      110304,
      110305
    },
    CluePageId = "Ex02_Region_1103",
    CluePageName = "UI_Investigation_Tab_Ex02_Region_1103",
    ClueTabType = "Ex02_Region",
    UnlockConditionID = 11020101
  }
})
