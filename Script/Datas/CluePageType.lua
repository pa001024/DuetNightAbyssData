local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CluePageType", {
  Ex02_Core = {
    ClueTabType = "Ex02_Core",
    ClueTabTypeName = "UI_Investigation_TabTypeCore",
    Priority = 55
  },
  Ex02_Event = {
    ClueTabType = "Ex02_Event",
    ClueTabTypeName = "UI_Investigation_TabTypeEvent",
    Priority = 45
  },
  Ex02_List = {
    ClueTabType = "Ex02_List",
    ClueTabTypeName = "UI_Investigation_TabTypeList",
    Priority = 30
  }
})
