local T = {}
T.RT_1 = {2}
T.RT_2 = {3}
T.RT_3 = {2, 3}
T.RT_4 = {1}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("LevelUpVisualEffects", {
  [110292] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_1,
    SkinID = 110201,
    VisualEffectId = 110292
  },
  [110293] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_1,
    SkinID = 110201,
    VisualEffectId = 110293
  },
  [110296] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 110201,
    VisualEffectId = 110296
  },
  [110297] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 110201,
    VisualEffectId = 110297
  },
  [150491] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150491
  },
  [150492] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150492
  },
  [150493] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150493
  },
  [150495] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150495
  },
  [150496] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150496
  },
  [150497] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150497
  },
  [150498] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150498
  },
  [150499] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 150401,
    VisualEffectId = 150499
  },
  [210190] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_4,
    SkinID = 210101,
    VisualEffectId = 210190
  },
  [210193] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 210101,
    VisualEffectId = 210193
  },
  [210195] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 210101,
    VisualEffectId = 210195
  },
  [210196] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 210101,
    VisualEffectId = 210196
  },
  [210290] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 210201,
    VisualEffectId = 210290
  },
  [210291] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 210201,
    VisualEffectId = 210291
  },
  [210292] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_4,
    SkinID = 210201,
    VisualEffectId = 210292
  },
  [210293] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_4,
    SkinID = 210201,
    VisualEffectId = 210293
  },
  [210294] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_4,
    SkinID = 210201,
    VisualEffectId = 210294
  },
  [210295] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_1,
    SkinID = 210201,
    VisualEffectId = 210295
  },
  [210296] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 210201,
    VisualEffectId = 210296
  },
  [210297] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 210201,
    VisualEffectId = 210297
  },
  [210298] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 210201,
    VisualEffectId = 210298
  },
  [310452] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 310401,
    VisualEffectId = 310452
  },
  [310453] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 310401,
    VisualEffectId = 310453
  },
  [310454] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_3,
    SkinID = 310401,
    VisualEffectId = 310454
  },
  [310455] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 310401,
    VisualEffectId = 310455
  },
  [310456] = {
    IsAlways = true,
    IsAttach = true,
    Level = T.RT_2,
    SkinID = 310401,
    VisualEffectId = 310456
  },
  [310457] = {
    IsAlways = true,
    IsAttach = true,
    Level = {
      1,
      2,
      3
    },
    SkinID = 310401,
    VisualEffectId = 310457
  }
})
