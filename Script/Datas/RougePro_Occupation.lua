local T = {}
T.RT_1 = {2010402}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_Occupation", {
  [1401] = {
    EventScore = 70,
    ID = 1401,
    LevelAddExtra = 0,
    OccupationSpeed = 10,
    RewardDropBoxId = 1401,
    SpawnMonsterId = {2010401}
  },
  [1402] = {
    EventScore = 140,
    ID = 1402,
    LevelAddExtra = 0,
    OccupationSpeed = 9,
    RewardDropBoxId = 1402,
    SpawnMonsterId = T.RT_1
  },
  [1403] = {
    EventScore = 210,
    ID = 1403,
    LevelAddExtra = 0,
    OccupationSpeed = 8,
    RewardDropBoxId = 1403,
    SpawnMonsterId = T.RT_1
  },
  [1404] = {
    EventScore = 280,
    ID = 1404,
    LevelAddExtra = 0,
    OccupationSpeed = 7,
    RewardDropBoxId = 1404,
    SpawnMonsterId = T.RT_1
  },
  [1405] = {
    EventScore = 350,
    ID = 1405,
    LevelAddExtra = 0,
    OccupationSpeed = 6,
    RewardDropBoxId = 1405,
    SpawnMonsterId = T.RT_1
  }
})
