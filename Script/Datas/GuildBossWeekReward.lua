local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildBossWeekReward", {
  [20] = {
    GuildConstructionPoint = 800,
    Stage = 20,
    StageReward = 103004101
  },
  [40] = {
    GuildConstructionPoint = 1000,
    Stage = 40,
    StageReward = 103004102
  },
  [60] = {
    GuildConstructionPoint = 1200,
    Stage = 60,
    StageReward = 103004103
  },
  [80] = {
    GuildConstructionPoint = 1400,
    Stage = 80,
    StageReward = 103004104
  },
  [100] = {
    GuildConstructionPoint = 1600,
    Stage = 100,
    StageReward = 103004105
  }
})
