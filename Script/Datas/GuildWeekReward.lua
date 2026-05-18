local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildWeekReward", {
  [200] = {
    [1] = {
      ActivenessReward = 103003101,
      RequiredActiveness = 200,
      RequiredPlayerLv = 1
    }
  },
  [400] = {
    [1] = {
      ActivenessReward = 103003102,
      RequiredActiveness = 400,
      RequiredPlayerLv = 1
    }
  },
  [700] = {
    [1] = {
      ActivenessReward = 103003103,
      RequiredActiveness = 700,
      RequiredPlayerLv = 1
    }
  },
  [1100] = {
    [1] = {
      ActivenessReward = 103003104,
      RequiredActiveness = 1100,
      RequiredPlayerLv = 1
    }
  },
  [1500] = {
    [1] = {
      ActivenessReward = 103003105,
      RequiredActiveness = 1500,
      RequiredPlayerLv = 1
    }
  }
})
