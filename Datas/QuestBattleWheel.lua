local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestBattleWheel", {
  [1] = {
    QuestBattleWheelID = 1,
    ResourceId1 = 1,
    ResourceId2 = 1,
    ResourceId3 = 1,
    ResourceId4 = 1,
    ResourceId5 = 1,
    ResourceId6 = 1,
    ResourceId7 = 1,
    ResourceId8 = 1
  },
  [10001] = {QuestBattleWheelID = 10001, ResourceId1 = 42002}
})
