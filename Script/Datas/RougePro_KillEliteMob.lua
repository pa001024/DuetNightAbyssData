local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_KillEliteMob", {
  [1601] = {
    EliteId = {6002015},
    EventScore = 70,
    ID = 1601,
    LevelAddExtra = 0,
    RewardDropBoxId = 1601
  },
  [1602] = {
    EliteId = {6002016},
    EventScore = 140,
    ID = 1602,
    LevelAddExtra = 5,
    RewardDropBoxId = 1602
  },
  [1603] = {
    EliteId = {6002017},
    EventScore = 210,
    ID = 1603,
    LevelAddExtra = 10,
    RewardDropBoxId = 1603
  },
  [1604] = {
    EliteId = {6002018},
    EventScore = 280,
    ID = 1604,
    LevelAddExtra = 15,
    RewardDropBoxId = 1604
  },
  [1605] = {
    EliteId = {6002019},
    EventScore = 350,
    ID = 1605,
    LevelAddExtra = 20,
    RewardDropBoxId = 1605
  }
})
