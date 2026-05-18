local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ForgeLevel", {
  [1] = {
    ForgeLevel = 1,
    ForgeLevelQuestId = {1040800, 1040810},
    ForgeLevelReward = 104081,
    HyperWeaponMaxCardLevel = 1
  },
  [2] = {
    ForgeLevel = 2,
    ForgeLevelQuestId = {1040801},
    ForgeLevelReward = 104082,
    HyperWeaponMaxCardLevel = 2
  },
  [3] = {
    ForgeLevel = 3,
    ForgeLevelQuestId = {1040802, 1040812},
    ForgeLevelReward = 104083,
    HyperWeaponMaxCardLevel = 3
  },
  [4] = {
    ForgeLevel = 4,
    ForgeLevelQuestId = {1040803},
    ForgeLevelReward = 104084,
    HyperWeaponMaxCardLevel = 4
  },
  [5] = {
    ForgeLevel = 5,
    ForgeLevelQuestId = {1040804, 1040814},
    ForgeLevelReward = 104085,
    HyperWeaponMaxCardLevel = 5
  }
})
