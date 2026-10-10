local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HardBossEventDungeon", {
  [28001] = {
    DungeonBuff = 1001,
    DungeonId = 28001,
    HardBossType = "Reward"
  },
  [28002] = {
    DungeonBuff = 1001,
    DungeonId = 28002,
    HardBossType = "Challenge"
  },
  [28003] = {
    DungeonBuff = 1002,
    DungeonId = 28003,
    HardBossType = "Reward"
  },
  [28004] = {
    DungeonBuff = 1002,
    DungeonId = 28004,
    HardBossType = "Challenge"
  },
  [28005] = {
    DungeonBuff = 1001,
    DungeonId = 28005,
    HardBossType = "Reward"
  },
  [28006] = {
    DungeonBuff = 1001,
    DungeonId = 28006,
    HardBossType = "Challenge"
  },
  [28007] = {
    DungeonBuff = 1002,
    DungeonId = 28007,
    HardBossType = "Reward"
  },
  [28008] = {
    DungeonBuff = 1002,
    DungeonId = 28008,
    HardBossType = "Challenge"
  },
  [28009] = {
    DungeonBuff = 1002,
    DungeonId = 28009,
    HardBossType = "Reward"
  },
  [28010] = {
    DungeonBuff = 1002,
    DungeonId = 28010,
    HardBossType = "Challenge"
  }
})
