local T = {}
T.RT_1 = {
  [1] = 8502701,
  [2] = 8512701,
  [3] = 8505701
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildBossRefresh", {
  [1] = {
    BossID = T.RT_1,
    ID = 1,
    StartTime = LocalTimeProxy(1785704400)
  },
  [2] = {
    BossID = {
      [1] = 8512701,
      [2] = 8502701,
      [3] = 8505701
    },
    ID = 2,
    StartTime = LocalTimeProxy(1789333200)
  },
  [3] = {
    BossID = T.RT_1,
    ID = 3,
    StartTime = LocalTimeProxy(1792962000)
  }
})
