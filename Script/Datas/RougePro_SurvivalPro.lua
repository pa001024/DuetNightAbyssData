local T = {}
T.RT_1 = {2010101, 2010101}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_SurvivalPro", {
  [1101] = {
    EventScore = 70,
    ExtraFixSurvivalValue = -4,
    ID = 1101,
    LevelAddExtra = 0,
    RewardDropBoxId = 1101,
    SpawnMonsterId = T.RT_1
  },
  [1102] = {
    EventScore = 140,
    ExtraFixSurvivalValue = -4,
    ID = 1102,
    LevelAddExtra = 5,
    RewardDropBoxId = 1102,
    SpawnMonsterId = T.RT_1
  },
  [1103] = {
    EventScore = 210,
    ExtraFixSurvivalValue = -4,
    ID = 1103,
    LevelAddExtra = 10,
    RewardDropBoxId = 1103,
    SpawnMonsterId = T.RT_1
  },
  [1104] = {
    EventScore = 280,
    ExtraFixSurvivalValue = -4,
    ID = 1104,
    LevelAddExtra = 15,
    RewardDropBoxId = 1104,
    SpawnMonsterId = T.RT_1
  },
  [1105] = {
    EventScore = 350,
    ExtraFixSurvivalValue = -4,
    ID = 1105,
    LevelAddExtra = 20,
    RewardDropBoxId = 1105,
    SpawnMonsterId = T.RT_1
  }
})
