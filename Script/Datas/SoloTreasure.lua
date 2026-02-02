local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SoloTreasure", {
  [91801] = {
    Difficulty = "easy",
    DungeonId = 91801,
    GameTotalTime = 30,
    TimerHandleName = "GoldRushPor",
    WarningTime = 10
  }
})
