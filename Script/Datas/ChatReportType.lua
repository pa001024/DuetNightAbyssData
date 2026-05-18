local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ChatReportType", {
  [1] = {
    Id = "Tab1_Harass",
    Index = 1,
    TabId = 1,
    Text = "UI_COMMONPOP_TEXT_100090_3",
    TypeId = 0
  },
  [2] = {
    Id = "Tab1_RealLifeThreat",
    Index = 2,
    TabId = 1,
    Text = "UI_COMMONPOP_TEXT_100090_4",
    TypeId = 0
  },
  [3] = {
    Id = "Tab1_CheatAD",
    Index = 3,
    TabId = 1,
    Text = "UI_COMMONPOP_TEXT_100090_5",
    TypeId = 0
  },
  [4] = {
    Id = "Tab1_OffensiveLanguage",
    Index = 4,
    TabId = 1,
    Text = "UI_COMMONPOP_TEXT_100090_6",
    TypeId = 0
  },
  [5] = {
    Id = "Tab1_Others",
    Index = 5,
    TabId = 1,
    Text = "UI_COMMONPOP_TEXT_100090_7",
    TypeId = 0
  },
  [6] = {
    Id = "Tab2_Harass",
    Index = 6,
    TabId = 2,
    Text = "UI_COMMONPOP_TEXT_100090_3",
    TypeId = 0
  },
  [7] = {
    Id = "Tab2_RealLifeThreat",
    Index = 7,
    TabId = 2,
    Text = "UI_COMMONPOP_TEXT_100090_4",
    TypeId = 0
  },
  [8] = {
    Id = "Tab2_CheatAD",
    Index = 8,
    TabId = 2,
    Text = "UI_COMMONPOP_TEXT_100090_5",
    TypeId = 0
  },
  [9] = {
    Id = "Tab2_OffensiveLanguage",
    Index = 9,
    TabId = 2,
    Text = "UI_COMMONPOP_TEXT_100090_6",
    TypeId = 0
  },
  [10] = {
    Id = "Tab2_Others",
    Index = 10,
    TabId = 2,
    Text = "UI_COMMONPOP_TEXT_100090_7",
    TypeId = 0
  },
  [11] = {
    Id = "Tab3_IntentionalDisruption",
    Index = 11,
    TabId = 3,
    Text = "UI_COMMONPOP_TEXT_100090_9",
    TypeId = 0
  },
  [12] = {
    Id = "Tab3_IllegalPhoto",
    Index = 12,
    TabId = 3,
    Text = "UI_COMMONPOP_TEXT_100090_12",
    TypeId = 1
  },
  [13] = {
    Id = "Tab3_Cheat",
    Index = 13,
    TabId = 3,
    Text = "UI_COMMONPOP_TEXT_100090_10",
    TypeId = 0
  },
  [14] = {
    Id = "Tab3_NegativeAttitude",
    Index = 14,
    TabId = 3,
    Text = "UI_COMMONPOP_TEXT_100090_13",
    TypeId = 2
  },
  [15] = {
    Id = "Tab3_Others",
    Index = 15,
    TabId = 3,
    Text = "UI_COMMONPOP_TEXT_100090_7",
    TypeId = 0
  },
  [16] = {
    Id = "Tab4_Harass",
    Index = 16,
    TabId = 0,
    Text = "UI_COMMONPOP_TEXT_100090_14",
    TypeId = 3
  },
  [17] = {
    Id = "Tab4_RealLifeThreat",
    Index = 17,
    TabId = 0,
    Text = "UI_COMMONPOP_TEXT_100090_15",
    TypeId = 3
  },
  [18] = {
    Id = "Tab4_OffensiveLanguage",
    Index = 18,
    TabId = 0,
    Text = "UI_COMMONPOP_TEXT_100090_16",
    TypeId = 3
  },
  [19] = {
    Id = "Tab4_CheatAD",
    Index = 19,
    TabId = 0,
    Text = "UI_COMMONPOP_TEXT_100090_17",
    TypeId = 3
  },
  [20] = {
    Id = "Tab4_Others",
    Index = 20,
    TabId = 0,
    Text = "UI_COMMONPOP_TEXT_100090_7",
    TypeId = 3
  }
})
