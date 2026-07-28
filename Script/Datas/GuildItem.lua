local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildItem", {
  [1001] = {
    Cost = 10,
    Desc = "RESOURCE_DESC_40001",
    FirstCategory = "DUNGEON_NAME_6",
    HeightConfig = {
      0,
      20,
      5
    },
    ItemID = 1001,
    LevelLimit = 1,
    Name = "DUNGEON_NAME_6",
    PerformanceCost = 10,
    ScaleConfig = {
      1,
      2,
      0.1
    },
    SecondCategory = "DUNGEON_NAME_6"
  }
})
