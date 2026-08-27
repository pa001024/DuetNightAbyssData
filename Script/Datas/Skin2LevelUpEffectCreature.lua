local T = {}
T.RT_1 = {
  [1] = 2,
  [2] = 3
}
T.RT_2 = {
  [1] = 3
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Skin2LevelUpEffectCreature", {
  [110201] = {
    [110298] = {
      EffectCreatureId = 110298,
      IsAttach = true,
      Level = T.RT_2,
      SkinID = 110201
    },
    [110299] = {
      EffectCreatureId = 110299,
      IsAttach = true,
      Level = {
        [1] = 2
      },
      SkinID = 110201
    }
  },
  [150401] = {
    [150441] = {
      EffectCreatureId = 150441,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 150401
    },
    [150443] = {
      EffectCreatureId = 150443,
      IsAlways = true,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 150401
    }
  },
  [210101] = {
    [210143] = {
      EffectCreatureId = 210143,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 210101
    }
  },
  [210201] = {
    [210221] = {
      EffectCreatureId = 210221,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 210201
    },
    [210222] = {
      EffectCreatureId = 210222,
      IsAttach = true,
      Level = T.RT_2,
      SkinID = 210201
    },
    [210223] = {
      EffectCreatureId = 210223,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 210201
    }
  },
  [310401] = {
    [310441] = {
      EffectCreatureId = 310441,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 310401
    },
    [310442] = {
      EffectCreatureId = 310442,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 310401
    },
    [310443] = {
      EffectCreatureId = 310443,
      IsAttach = true,
      Level = T.RT_2,
      SkinID = 310401
    },
    [310444] = {
      EffectCreatureId = 310444,
      IsAttach = true,
      Level = T.RT_2,
      SkinID = 310401
    },
    [310445] = {
      EffectCreatureId = 310445,
      IsAttach = true,
      Level = T.RT_1,
      SkinID = 310401
    }
  }
})
