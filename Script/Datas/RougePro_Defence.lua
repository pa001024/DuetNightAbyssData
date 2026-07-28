local T = {}
T.RT_1 = {2010301}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_Defence", {
  [1301] = {
    DefenceRound = 3,
    EventScore = 70,
    ID = 1301,
    LevelAddExtra = 0,
    RewardDropBoxId = 1301,
    SpawnMonsterId = T.RT_1
  },
  [1302] = {
    DefenceRound = 3,
    EventScore = 140,
    ID = 1302,
    LevelAddExtra = 0,
    RewardDropBoxId = 1302,
    SpawnMonsterId = T.RT_1
  },
  [1303] = {
    DefenceRound = 3,
    EventScore = 210,
    ID = 1303,
    LevelAddExtra = 0,
    RewardDropBoxId = 1303,
    SpawnMonsterId = T.RT_1
  },
  [1304] = {
    DefenceRound = 3,
    EventScore = 280,
    ID = 1304,
    LevelAddExtra = 0,
    RewardDropBoxId = 1304,
    SpawnMonsterId = T.RT_1
  },
  [1305] = {
    DefenceRound = 3,
    EventScore = 350,
    ID = 1305,
    LevelAddExtra = 0,
    RewardDropBoxId = 1305,
    SpawnMonsterId = T.RT_1
  }
})
