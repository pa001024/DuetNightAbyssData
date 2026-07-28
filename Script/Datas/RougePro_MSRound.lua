local T = {}
T.RT_1 = {916021, 916101}
T.RT_2 = {916012, 916102}
T.RT_3 = {916023, 916103}
T.RT_4 = {916014, 916104}
T.RT_5 = {916025, 916105}
T.RT_6 = {916016, 916106}
T.RT_7 = {
  [1] = T.RT_1,
  [2] = T.RT_2,
  [3] = T.RT_3,
  [4] = T.RT_4,
  [5] = T.RT_5,
  [6] = T.RT_6
}
T.RT_8 = {
  916031,
  916032,
  916033,
  916034
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_MSRound", {
  [1] = {
    ID = 1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 50,
    RoundLevelFix = 5,
    StrongKillCount = 30,
    StrongLoopSpawnId = T.RT_8
  },
  [2] = {
    ID = 2,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 30,
    RoundLevelFix = 2,
    StrongKillCount = 40,
    StrongLoopSpawnId = T.RT_8
  }
})
