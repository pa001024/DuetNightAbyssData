local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ClueContent", {
  [10000101] = {
    ClueContentID = 10000101,
    DialogueId1 = 11100201,
    DialogueId2 = 11100301,
    FinalState = 2,
    TextMapId = "UI_ClueContent_10000101"
  },
  [10000102] = {
    ClueContentID = 10000102,
    FinalState = 1,
    MechState1 = {152480411, 495004},
    TextMapId = "UI_ClueContent_10000102"
  },
  [10000103] = {
    ClueContentID = 10000103,
    FinalState = 1,
    ResourceId1 = 2000017,
    TextMapId = "UI_ClueContent_10000103"
  }
})
