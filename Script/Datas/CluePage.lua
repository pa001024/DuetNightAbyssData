local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CluePage", {
  Ex02_Branch01 = {
    ClueList = {100003},
    CluePageId = "Ex02_Branch01",
    CluePageName = "UI_Investigation_Tab_Ex02_Branch01",
    ClueTabType = "Ex02_Event",
    UnlockCondtionID = 102001
  },
  Ex02_MainStory = {
    ClueList = {100001, 100002},
    CluePageId = "Ex02_MainStory",
    CluePageName = "UI_Investigation_Tab_Ex02_MainStory",
    ClueTabType = "Ex02_Core",
    UnlockCondtionID = 101001
  },
  Ex02_RegionReport = {
    ClueList = {100004, 100005},
    CluePageId = "Ex02_RegionReport",
    CluePageName = "UI_Investigation_Tab_Ex02_RegionReport",
    ClueTabType = "Ex02_List",
    UnlockCondtionID = 103001
  }
})
