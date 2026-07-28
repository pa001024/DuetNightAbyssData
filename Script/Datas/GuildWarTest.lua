local T = {}
T.RT_1 = {Hit = 2000}
T.RT_2 = {Extra = "Trigger"}
T.RT_3 = {Hit = 2500}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildWarTest", {
  [101] = {
    CalulationRule = {Hit = 1000},
    ContributionRate = 2000000,
    DamageCondition = {DamageTag = "Skill"},
    GuildWarTestID = 101,
    TestDes = "GuildBoss_TestDes_101",
    TestKeyWord = "GuildBoss_TestKey_Skill",
    TestType = 1
  },
  [102] = {
    CalulationRule = T.RT_1,
    ContributionRate = 2000000,
    DamageCondition = {DamageTag = "Weapon"},
    GuildWarTestID = 102,
    TestDes = "GuildBoss_TestDes_102",
    TestKeyWord = "GuildBoss_TestKey_Weapon",
    TestType = 1
  },
  [201] = {
    CalulationRule = T.RT_1,
    ContributionRate = 2000000,
    DamageCondition = {Extra = "Crit"},
    GuildWarTestID = 201,
    TestDes = "GuildBoss_TestDes_201",
    TestKeyWord = "GuildBoss_TestKey_Crit",
    TestType = 2
  },
  [202] = {
    CalulationRule = {Hit = 10000},
    ContributionRate = 2000000,
    DamageCondition = T.RT_2,
    GuildWarTestID = 202,
    TestDes = "GuildBoss_TestDes_202",
    TestKeyWord = "GuildBoss_TestKey_Trig",
    TestType = 2
  },
  [203] = {
    CalulationRule = {Hit = 8000},
    ContributionRate = 2000000,
    DamageCondition = T.RT_2,
    GuildWarTestID = 203,
    TestDes = "GuildBoss_TestDes_203",
    TestKeyWord = "GuildBoss_TestKey_Bonus",
    TestType = 2
  },
  [204] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = T.RT_2,
    GuildWarTestID = 204,
    TestDes = "GuildBoss_TestDes_204",
    TestKeyWord = "GuildBoss_TestKey_Dot",
    TestType = 2
  },
  [301] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = {DamageType = "Water"},
    GuildWarTestID = 301,
    TestDes = "GuildBoss_TestDes_301",
    TestKeyWord = "GuildBoss_TestKey_Water",
    TestType = 3
  },
  [302] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = {DamageType = "Fire"},
    GuildWarTestID = 302,
    TestDes = "GuildBoss_TestDes_302",
    TestKeyWord = "GuildBoss_TestKey_Fire",
    TestType = 3
  },
  [303] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = {DamageType = "Wind"},
    GuildWarTestID = 303,
    TestDes = "GuildBoss_TestDes_303",
    TestKeyWord = "GuildBoss_TestKey_Wind",
    TestType = 3
  },
  [304] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = {DamageType = "Thunder"},
    GuildWarTestID = 304,
    TestDes = "GuildBoss_TestDes_304",
    TestKeyWord = "GuildBoss_TestKey_Thunder",
    TestType = 3
  },
  [305] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = {DamageType = "Light"},
    GuildWarTestID = 305,
    TestDes = "GuildBoss_TestDes_305",
    TestKeyWord = "GuildBoss_TestKey_Light",
    TestType = 3
  },
  [306] = {
    CalulationRule = T.RT_3,
    ContributionRate = 2000000,
    DamageCondition = {DamageType = "Dark"},
    GuildWarTestID = 306,
    TestDes = "GuildBoss_TestDes_306",
    TestKeyWord = "GuildBoss_TestKey_Dark",
    TestType = 3
  }
})
