local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Clue", {
  [100001] = {
    ClueContent = {
      10000101,
      10000102,
      10000103
    },
    ClueID = 100001,
    ClueName = "UI_ClueName_100001",
    CluePic1 = "路径A",
    CluePic2 = "路径B",
    ClueType = 1
  },
  [100002] = {
    ClueContent = {10000201},
    ClueID = 100002,
    ClueName = "UI_ClueName_100002",
    CluePic1 = "路径A",
    CluePic2 = "路径B",
    ClueType = 2
  },
  [100003] = {
    ClueContent = {10000301},
    ClueID = 100003,
    ClueName = "UI_ClueName_100003",
    CluePic1 = "路径A",
    CluePic2 = "路径B",
    ClueType = 3
  }
})
