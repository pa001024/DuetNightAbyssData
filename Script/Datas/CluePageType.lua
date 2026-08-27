local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CluePageType", {
  Ex02_Character = {
    ClueTabType = "Ex02_Character",
    ClueTabTypeName = "UI_Investigation_TabTypeCharacter",
    Priority = 30
  },
  Ex02_Core = {
    ClueTabType = "Ex02_Core",
    ClueTabTypeName = "UI_Investigation_TabTypeCore",
    Priority = 55
  },
  Ex02_Region = {
    ClueTabType = "Ex02_Region",
    ClueTabTypeName = "UI_Investigation_TabTypeRegion",
    Priority = 45
  }
})
