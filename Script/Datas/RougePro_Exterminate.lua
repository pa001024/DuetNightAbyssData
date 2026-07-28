local T = {}
T.RT_1 = {2010201}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_Exterminate", {
  [1201] = {
    CompleteNeedKillNum = 100,
    EventScore = 70,
    ID = 1201,
    LevelAddExtra = 0,
    RewardDropBoxId = 1201,
    SpawnMonsterId = T.RT_1
  },
  [1202] = {
    CompleteNeedKillNum = 100,
    EventScore = 140,
    ID = 1202,
    LevelAddExtra = 5,
    RewardDropBoxId = 1202,
    SpawnMonsterId = T.RT_1
  },
  [1203] = {
    CompleteNeedKillNum = 100,
    EventScore = 210,
    ID = 1203,
    LevelAddExtra = 10,
    RewardDropBoxId = 1203,
    SpawnMonsterId = T.RT_1
  },
  [1204] = {
    CompleteNeedKillNum = 100,
    EventScore = 280,
    ID = 1204,
    LevelAddExtra = 15,
    RewardDropBoxId = 1204,
    SpawnMonsterId = T.RT_1
  },
  [1205] = {
    CompleteNeedKillNum = 100,
    EventScore = 350,
    ID = 1205,
    LevelAddExtra = 20,
    RewardDropBoxId = 1205,
    SpawnMonsterId = T.RT_1
  }
})
