local T = {}
T.RT_1 = {2010502}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_SabotagePro", {
  [1501] = {
    EventScore = 70,
    ID = 1501,
    LevelAddExtra = 0,
    RewardDropBoxId = 1501,
    SpawnMonsterId = {2010501}
  },
  [1502] = {
    EventScore = 140,
    ID = 1502,
    LevelAddExtra = 5,
    RewardDropBoxId = 1502,
    SpawnMonsterId = T.RT_1
  },
  [1503] = {
    EventScore = 210,
    ID = 1503,
    LevelAddExtra = 10,
    RewardDropBoxId = 1503,
    SpawnMonsterId = T.RT_1
  },
  [1504] = {
    EventScore = 280,
    ID = 1504,
    LevelAddExtra = 15,
    RewardDropBoxId = 1504,
    SpawnMonsterId = T.RT_1
  },
  [1505] = {
    EventScore = 350,
    ID = 1505,
    LevelAddExtra = 20,
    RewardDropBoxId = 1505,
    SpawnMonsterId = T.RT_1
  }
})
