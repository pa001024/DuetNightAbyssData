local T = {}
T.RT_1 = {
  [1] = 15002,
  [2] = 15031,
  [3] = 15037,
  [4] = 202,
  [5] = 15026,
  [6] = 15027
}
T.RT_2 = {
  [1] = 30,
  [2] = 90,
  [3] = 15,
  [4] = 2,
  [5] = 50,
  [6] = 50
}
T.RT_3 = {10299001}
T.RT_4 = {
  [1] = 15002,
  [2] = 15031,
  [3] = 15037,
  [4] = 20027,
  [5] = 15026,
  [6] = 15027
}
T.RT_5 = {
  [1] = 30,
  [2] = 90,
  [3] = 15,
  [4] = 4,
  [5] = 50,
  [6] = 50
}
T.RT_6 = {
  [1] = 15006,
  [2] = 15035,
  [3] = 15037,
  [4] = 202,
  [5] = 15030,
  [6] = 15027
}
T.RT_7 = {10399001}
T.RT_8 = {
  [1] = 15006,
  [2] = 15035,
  [3] = 15037,
  [4] = 20027,
  [5] = 15030,
  [6] = 15027
}
T.RT_9 = {
  [1] = 15003,
  [2] = 15036,
  [3] = 15037,
  [4] = 202,
  [5] = 15028,
  [6] = 15029
}
T.RT_10 = {20599001}
T.RT_11 = {
  [1] = 15003,
  [2] = 15036,
  [3] = 15037,
  [4] = 20028,
  [5] = 15028,
  [6] = 15029
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HyperWeaponSkillTree", {
  [10299001] = {
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10299].Vars.AddWeaponSP01$",
      [2] = "$#PassiveEffect[10299].Vars.AddWeaponSP02$",
      [3] = "$#SkillEffects[1029903].TaskEffects[1].Rate*100$%",
      [4] = "$#TargetFilter[#SkillEffects[1029903].TargetFilter].LuaFilterParaments.Radius/100$"
    },
    SkillDescription = "SKILL_10299_01_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Machinegun_Zaie.T_Rouge_Talent_Machinegun_Zaie'",
    SkillIndex = 1,
    WeaponCardLevel = 0,
    WeaponId = 10299,
    WeaponSkillId = 10299001,
    WeaponSkillName = "SKILL_10299_01_Name"
  },
  [10299002] = {
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10299].Vars.AddWeaponSP03$"
    },
    SkillDescription = "SKILL_10299_02_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Machinegun_Zaie.T_Rouge_Talent_Machinegun_Zaie'",
    SkillIndex = 1,
    UnlockCondition = T.RT_3,
    WeaponCardLevel = 1,
    WeaponId = 10299,
    WeaponSkillId = 10299002,
    WeaponSkillName = "SKILL_10299_02_Name"
  },
  [10299003] = {
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10299].Vars.AddWeaponSP04$"
    },
    SkillDescription = "SKILL_10299_03_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Machinegun_Zaie.T_Rouge_Talent_Machinegun_Zaie'",
    SkillIndex = 2,
    UnlockCondition = T.RT_3,
    WeaponCardLevel = 1,
    WeaponId = 10299,
    WeaponSkillId = 10299003,
    WeaponSkillName = "SKILL_10299_03_Name"
  },
  [10299004] = {
    ResourceId = T.RT_4,
    ResourceNum = T.RT_5,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_SkillIntensityUP.T_Rouge_Talent_SkillIntensityUP'",
    SkillIndex = 1,
    UnlockCondition = {10299002},
    WeaponCardLevel = 2,
    WeaponId = 10299,
    WeaponSkillId = 10299004,
    WeaponSkillName = "SKILL_10299_04_Name"
  },
  [10299005] = {
    ResourceId = T.RT_4,
    ResourceNum = T.RT_5,
    SkillDescParameter = {
      [1] = "$#BattleWeapon[10299].AddAttrs[2].Rate*100$%"
    },
    SkillDescription = "SKILL_10299_07_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_ATK.T_Rouge_Talent_ATK'",
    SkillIndex = 2,
    UnlockCondition = {10299003},
    WeaponCardLevel = 2,
    WeaponId = 10299,
    WeaponSkillId = 10299005,
    WeaponSkillName = "SKILL_10299_05_Name"
  },
  [10299006] = {
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2,
    SecondaryResourceBuffID = 1029901,
    SkillDescParameter = {
      [1] = "$#Buff[1029902].AddAttrs[1].Rate*100$%",
      [2] = "$#PassiveEffect[10299].Vars.BuffTime$",
      [3] = "$#Buff[1029901].MaxLayer$"
    },
    SkillDescription = "SKILL_10299_04_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Machinegun_Zaie.T_Rouge_Talent_Machinegun_Zaie'",
    SkillIndex = 1,
    UnlockCondition = {10299004},
    WeaponCardLevel = 3,
    WeaponId = 10299,
    WeaponSkillId = 10299006,
    WeaponSkillName = "SKILL_10299_06_Name",
    bShowSecondaryResource = true
  },
  [10299007] = {
    ResourceId = T.RT_1,
    ResourceNum = T.RT_2,
    SecondaryResourceBuffID = 1029901,
    SkillDescParameter = {
      [1] = "$#Buff[1029902].AddAttrs[1].Rate*100$%",
      [2] = "$#PassiveEffect[10299].Vars.BuffTime01$",
      [3] = "$#Buff[1029901].MaxLayer$",
      [4] = "$#PassiveEffect[10299].Vars.BuffTime$"
    },
    SkillDescription = "SKILL_10299_05_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Machinegun_Zaie.T_Rouge_Talent_Machinegun_Zaie'",
    SkillIndex = 2,
    UnlockCondition = {10299005},
    WeaponCardLevel = 3,
    WeaponId = 10299,
    WeaponSkillId = 10299007,
    WeaponSkillName = "SKILL_10299_07_Name",
    bShowSecondaryResource = true
  },
  [10299008] = {
    ResourceId = T.RT_4,
    ResourceNum = T.RT_5,
    SecondaryResourceBuffID = 1029901,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_SkillRangeUP.T_Rouge_Talent_SkillRangeUP'",
    SkillIndex = 1,
    UnlockCondition = {10299006},
    WeaponCardLevel = 4,
    WeaponId = 10299,
    WeaponSkillId = 10299008,
    WeaponSkillName = "SKILL_10299_08_Name",
    bShowSecondaryResource = true
  },
  [10299009] = {
    ResourceId = T.RT_4,
    ResourceNum = T.RT_5,
    SecondaryResourceBuffID = 1029901,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Morale.T_Rouge_Talent_Morale'",
    SkillIndex = 2,
    UnlockCondition = {10299007},
    WeaponCardLevel = 4,
    WeaponId = 10299,
    WeaponSkillId = 10299009,
    WeaponSkillName = "SKILL_10299_09_Name",
    bShowSecondaryResource = true
  },
  [10299010] = {
    SecondaryResourceBuffID = 1029903,
    SkillDescParameter = {
      [1] = "$#Buff[1029903].AddAttrs[1].Value*100$%",
      [2] = "$#Buff[1029905].AddAttrs[1].Value*100$%",
      [3] = "$(#SkillEffects[1029904].TaskEffects[1].Rate-#SkillEffects[1029903].TaskEffects[1].Rate)*100$%",
      [4] = "$#Buff[1029903].MaxLayer$"
    },
    SkillDescription = "SKILL_10299_06_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Machinegun_Zaie.T_Rouge_Talent_Machinegun_Zaie'",
    SkillIndex = 1,
    UnlockCondition = {10299008, 10299009},
    WeaponCardLevel = 5,
    WeaponId = 10299,
    WeaponSkillId = 10299010,
    WeaponSkillName = "SKILL_10299_10_Name",
    bShowSecondaryResource = true
  },
  [10399001] = {
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10399].Vars.AddWeaponSP01$",
      [2] = "$#Buff[1039901].AddAttrs[1].Value*100$%",
      [3] = "$#PassiveEffect[10399].Vars.BuffTime$"
    },
    SkillDescription = "SKILL_10399_01_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Claymore_Zaie.T_Rouge_Talent_Claymore_Zaie'",
    SkillIndex = 1,
    WeaponCardLevel = 0,
    WeaponId = 10399,
    WeaponSkillId = 10399001,
    WeaponSkillName = "SKILL_10399_01_Name",
    bShowSecondaryResource = true
  },
  [10399002] = {
    ResourceId = T.RT_6,
    ResourceNum = T.RT_2,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10399].Vars.AddWeaponSP04$",
      [2] = "$#PassiveEffect[10399].Vars.AddWeaponSP02$"
    },
    SkillDescription = "SKILL_10399_02_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Claymore_Zaie.T_Rouge_Talent_Claymore_Zaie'",
    SkillIndex = 1,
    UnlockCondition = T.RT_7,
    WeaponCardLevel = 1,
    WeaponId = 10399,
    WeaponSkillId = 10399002,
    WeaponSkillName = "SKILL_10399_02_Name",
    bShowSecondaryResource = true
  },
  [10399003] = {
    ResourceId = T.RT_6,
    ResourceNum = T.RT_2,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10399].Vars.AddWeaponSP03$"
    },
    SkillDescription = "SKILL_10399_03_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Claymore_Zaie.T_Rouge_Talent_Claymore_Zaie'",
    SkillIndex = 2,
    UnlockCondition = T.RT_7,
    WeaponCardLevel = 1,
    WeaponId = 10399,
    WeaponSkillId = 10399003,
    WeaponSkillName = "SKILL_10399_03_Name",
    bShowSecondaryResource = true
  },
  [10399004] = {
    ResourceId = T.RT_8,
    ResourceNum = T.RT_5,
    SecondaryResourceBuffID = 1039901,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_SkillIntensityUP.T_Rouge_Talent_SkillIntensityUP'",
    SkillIndex = 1,
    UnlockCondition = {10399002},
    WeaponCardLevel = 2,
    WeaponId = 10399,
    WeaponSkillId = 10399004,
    WeaponSkillName = "SKILL_10399_04_Name",
    bShowSecondaryResource = true
  },
  [10399005] = {
    ResourceId = T.RT_8,
    ResourceNum = T.RT_5,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#BattleWeapon[10399].AddAttrs[2].Rate*100$%"
    },
    SkillDescription = "SKILL_10399_09_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_ATK.T_Rouge_Talent_ATK'",
    SkillIndex = 2,
    UnlockCondition = {10399003},
    WeaponCardLevel = 2,
    WeaponId = 10399,
    WeaponSkillId = 10399005,
    WeaponSkillName = "SKILL_10399_05_Name",
    bShowSecondaryResource = true
  },
  [10399006] = {
    ResourceId = T.RT_6,
    ResourceNum = T.RT_2,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10399].Vars.DamageRate3_1*100$%"
    },
    SkillDescription = "SKILL_10399_04_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Claymore_Zaie.T_Rouge_Talent_Claymore_Zaie'",
    SkillIndex = 1,
    UnlockCondition = {10399004},
    WeaponCardLevel = 3,
    WeaponId = 10399,
    WeaponSkillId = 10399006,
    WeaponSkillName = "SKILL_10399_06_Name",
    bShowSecondaryResource = true
  },
  [10399007] = {
    ResourceId = T.RT_6,
    ResourceNum = T.RT_2,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10399].Vars.DamageRate3_2*100$%"
    },
    SkillDescription = "SKILL_10399_05_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Claymore_Zaie.T_Rouge_Talent_Claymore_Zaie'",
    SkillIndex = 2,
    UnlockCondition = {10399005},
    WeaponCardLevel = 3,
    WeaponId = 10399,
    WeaponSkillId = 10399007,
    WeaponSkillName = "SKILL_10399_07_Name",
    bShowSecondaryResource = true
  },
  [10399008] = {
    ResourceId = T.RT_8,
    ResourceNum = T.RT_5,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#Buff[1039902].AddAttrs[1].Value*100$%"
    },
    SkillDescription = "SKILL_10399_06_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_BonusDamage.T_Rouge_Talent_BonusDamage'",
    SkillIndex = 1,
    UnlockCondition = {10399006},
    WeaponCardLevel = 4,
    WeaponId = 10399,
    WeaponSkillId = 10399008,
    WeaponSkillName = "SKILL_10399_08_Name",
    bShowSecondaryResource = true
  },
  [10399009] = {
    ResourceId = T.RT_8,
    ResourceNum = T.RT_5,
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#Buff[1039908].AddAttrs[1].Value*100$%"
    },
    SkillDescription = "SKILL_10399_07_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_AttrPenetration.T_Rouge_Talent_AttrPenetration'",
    SkillIndex = 2,
    UnlockCondition = {10399007},
    WeaponCardLevel = 4,
    WeaponId = 10399,
    WeaponSkillId = 10399009,
    WeaponSkillName = "SKILL_10399_09_Name",
    bShowSecondaryResource = true
  },
  [10399010] = {
    SecondaryResourceBuffID = 1039901,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[10399].Vars.BaseAttrRate*100$%"
    },
    SkillDescription = "SKILL_10399_08_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Claymore_Zaie.T_Rouge_Talent_Claymore_Zaie'",
    SkillIndex = 1,
    UnlockCondition = {10399008, 10399009},
    WeaponCardLevel = 5,
    WeaponId = 10399,
    WeaponSkillId = 10399010,
    WeaponSkillName = "SKILL_10399_10_Name",
    bShowSecondaryResource = true
  },
  [20599001] = {
    SkillDescParameter = {
      [1] = "$#PassiveEffect[20599].Vars.AddWeaponSP01$",
      [2] = "$#SkillEffects[2059905].TaskEffects[1].Rate*100$%",
      [3] = "$#TargetFilter[#SkillEffects[2059905].TargetFilter].LuaFilterParaments.Radius/100$"
    },
    SkillDescription = "SKILL_20599_01_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Polearm_Zaie.T_Rouge_Talent_Polearm_Zaie'",
    SkillIndex = 1,
    WeaponCardLevel = 0,
    WeaponId = 20599,
    WeaponSkillId = 20599001,
    WeaponSkillName = "SKILL_20599_01_Name"
  },
  [20599002] = {
    ResourceId = T.RT_9,
    ResourceNum = T.RT_2,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[20599].Vars.Rate*100$%",
      [2] = "$#PassiveEffect[20599].Vars.AddWeaponSP04$"
    },
    SkillDescription = "SKILL_20599_02_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Polearm_Zaie.T_Rouge_Talent_Polearm_Zaie'",
    SkillIndex = 1,
    UnlockCondition = T.RT_10,
    WeaponCardLevel = 1,
    WeaponId = 20599,
    WeaponSkillId = 20599002,
    WeaponSkillName = "SKILL_20599_02_Name"
  },
  [20599003] = {
    ResourceId = T.RT_9,
    ResourceNum = T.RT_2,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[20599].Vars.AddWeaponSP02$",
      [2] = "$#PassiveEffect[20599].Vars.AddWeaponSP03$"
    },
    SkillDescription = "SKILL_20599_03_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Polearm_Zaie.T_Rouge_Talent_Polearm_Zaie'",
    SkillIndex = 2,
    UnlockCondition = T.RT_10,
    WeaponCardLevel = 1,
    WeaponId = 20599,
    WeaponSkillId = 20599003,
    WeaponSkillName = "SKILL_20599_03_Name"
  },
  [20599004] = {
    ResourceId = T.RT_11,
    ResourceNum = T.RT_5,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_SkillIntensityUP.T_Rouge_Talent_SkillIntensityUP'",
    SkillIndex = 1,
    UnlockCondition = {20599002},
    WeaponCardLevel = 2,
    WeaponId = 20599,
    WeaponSkillId = 20599004,
    WeaponSkillName = "SKILL_20599_04_Name"
  },
  [20599005] = {
    ResourceId = T.RT_11,
    ResourceNum = T.RT_5,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_AttrPenetration.T_Rouge_Talent_AttrPenetration'",
    SkillIndex = 2,
    UnlockCondition = {20599003},
    WeaponCardLevel = 2,
    WeaponId = 20599,
    WeaponSkillId = 20599005,
    WeaponSkillName = "SKILL_20599_05_Name"
  },
  [20599006] = {
    ResourceId = T.RT_9,
    ResourceNum = T.RT_2,
    SkillDescParameter = {
      [1] = "$#PassiveEffect[20599].Vars.MaxComboCountUse$",
      [2] = "$#PassiveEffect[20599].Vars.BuffTime$",
      [3] = "$#Buff[2059901].AddAttrs[1].Value*100$%",
      [4] = "$(#SkillEffects[2059906].TaskEffects[1].Rate-#SkillEffects[2059905].TaskEffects[1].Rate)*100$%"
    },
    SkillDescription = "SKILL_20599_04_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Polearm_Zaie.T_Rouge_Talent_Polearm_Zaie'",
    SkillIndex = 1,
    UnlockCondition = {20599004},
    WeaponCardLevel = 3,
    WeaponId = 20599,
    WeaponSkillId = 20599006,
    WeaponSkillName = "SKILL_20599_06_Name"
  },
  [20599007] = {
    ResourceId = T.RT_9,
    ResourceNum = T.RT_2,
    SkillDescParameter = {
      [1] = "$#TargetFilter[#SkillEffects[2059907].TargetFilter].LuaFilterParaments.Radius/100$"
    },
    SkillDescription = "SKILL_20599_05_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Polearm_Zaie.T_Rouge_Talent_Polearm_Zaie'",
    SkillIndex = 2,
    UnlockCondition = {20599005},
    WeaponCardLevel = 3,
    WeaponId = 20599,
    WeaponSkillId = 20599007,
    WeaponSkillName = "SKILL_20599_07_Name"
  },
  [20599008] = {
    ResourceId = T.RT_11,
    ResourceNum = T.RT_5,
    SkillDescParameter = {
      [1] = "$#Buff[2059903].AddAttrs[1].Value*100$%"
    },
    SkillDescription = "SKILL_20599_07_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_BonusDamage.T_Rouge_Talent_BonusDamage'",
    SkillIndex = 1,
    UnlockCondition = {20599006},
    WeaponCardLevel = 4,
    WeaponId = 20599,
    WeaponSkillId = 20599008,
    WeaponSkillName = "SKILL_20599_08_Name"
  },
  [20599009] = {
    ResourceId = T.RT_11,
    ResourceNum = T.RT_5,
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Morale.T_Rouge_Talent_Morale'",
    SkillIndex = 2,
    UnlockCondition = {20599007},
    WeaponCardLevel = 4,
    WeaponId = 20599,
    WeaponSkillId = 20599009,
    WeaponSkillName = "SKILL_20599_09_Name"
  },
  [20599010] = {
    SkillDescParameter = {
      [1] = "$#Buff[2059902].AddAttrs[1].Value*100$%",
      [2] = "$#PassiveEffect[20599].Vars.ComboCount_20599Add$",
      [3] = "$#PassiveEffect[20599].Vars.MaxComboCount_20599$"
    },
    SkillDescription = "SKILL_20599_06_DESC",
    SkillIcon = "Texture2D'/Game/UI/Texture/Dynamic/Image/RougeLike/T_Rouge_Talent_Polearm_Zaie.T_Rouge_Talent_Polearm_Zaie'",
    SkillIndex = 1,
    UnlockCondition = {20599008, 20599009},
    WeaponCardLevel = 5,
    WeaponId = 20599,
    WeaponSkillId = 20599010,
    WeaponSkillName = "SKILL_20599_10_Name",
    bShowSecondaryResource = true
  }
})
