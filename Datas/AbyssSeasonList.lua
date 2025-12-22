local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AbyssSeasonList", {
  [1001] = {
    Abyss = {Infinite = 1013, Rotate = 1012},
    AbyssEndTime = 1764018000,
    AbyssSeasonId = 1001,
    AbyssSeasonName = "Event_STitle_103002",
    AbyssStartTime = 1761512400,
    CharId = 5301,
    EventId = 103002
  },
  [1002] = {
    Abyss = {Infinite = 1015, Rotate = 1014},
    AbyssEndTime = 1766437200,
    AbyssSeasonId = 1002,
    AbyssSeasonName = "Event_STitle_103002",
    AbyssStartTime = 1764018000,
    CharId = 1801,
    EventId = 1030022,
    LastSeason = 1001
  },
  [1003] = {
    Abyss = {Infinite = 1112, Rotate = 1111},
    AbyssEndTime = 1768874400,
    AbyssSeasonId = 1003,
    AbyssSeasonName = "Event_STitle_103002",
    AbyssStartTime = 1766437200,
    CharId = 2401,
    EventId = 1030023,
    LastSeason = 1002
  },
  [1004] = {
    Abyss = {Infinite = 1114, Rotate = 1113},
    AbyssEndTime = 1770688800,
    AbyssSeasonId = 1004,
    AbyssSeasonName = "Event_STitle_103002",
    AbyssStartTime = 1768874400,
    CharId = 1503,
    EventId = 1030024,
    LastSeason = 1003
  }
})
