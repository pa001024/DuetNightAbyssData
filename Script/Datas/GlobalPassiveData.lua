local T = {}
T.RT_1 = {Buff = 2012112}
T.RT_2 = {Buff = 2013122}
T.RT_3 = {Buff = 2013222}
T.RT_4 = {Count = "#1"}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GlobalPassiveData", {
  [1] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/BP_AbyssPassive_Test.BP_AbyssPassive_Test",
    Camp = "Monster",
    ID = 1,
    Vars = {GrowVar = "#1", TestVar = 30}
  },
  [11112] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_PersonalRemoveBuff.BP_AbyssGP_PersonalRemoveBuff",
    Camp = "Player",
    ID = 11112,
    Vars = {Buff = 2011111}
  },
  [11113] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HealAddBuff.BP_AbyssGP_HealAddBuff",
    Camp = "Player",
    ID = 11113,
    Vars = {Buff = 2011113, LastTime = 10}
  },
  [11121] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HpCostAddBuff.BP_AbyssGP_HpCostAddBuff",
    Camp = "Player",
    ID = 11121,
    Vars = {
      Buff = 2011121,
      HpCost = 0.04,
      LastTime = 12
    }
  },
  [11122] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 11122,
    Vars = {Buff = 2011122}
  },
  [11211] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HpAboveBuff.BP_AbyssGP_HpAboveBuff",
    Camp = "Player",
    ID = 11211,
    Vars = {Buff = 2011211, HpRate = 0.8}
  },
  [11212] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 11212,
    Vars = {Buff = 2011212}
  },
  [11221] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_MeleeAddBuff.BP_AbyssGP_MeleeAddBuff",
    Camp = "Player",
    ID = 11221,
    Vars = {Buff = 2011221, LastTime = 10}
  },
  [11222] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 11222,
    Vars = {Buff = 2011222}
  },
  [12111] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
    Camp = "Player",
    ID = 12111,
    Vars = {Buff = 2012111, LastTime = 18}
  },
  [12112] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 12112,
    Vars = T.RT_1
  },
  [12121] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
    Camp = "Player",
    ID = 12121,
    Vars = {Buff = 2012121, LastTime = 15}
  },
  [12211] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillExtraEffect.BP_AbyssGP_SkillExtraEffect",
    Camp = "Player",
    ID = 12211,
    Vars = {SkillEffect = 12211}
  },
  [12221] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 12221,
    Vars = {
      Buff = 2012221,
      HitCount = 5,
      LastTime = 15
    }
  },
  [13111] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
    Camp = "Player",
    ID = 13111,
    Vars = {Buff = 2013111, LastTime = 12}
  },
  [13112] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 13112,
    Vars = {Buff = 2013112}
  },
  [13121] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_BuffInAir.BP_AbyssGP_BuffInAir",
    Camp = "Player",
    ID = 13121,
    Vars = {Buff = 2013121, LastTime = 1}
  },
  [13122] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 13122,
    Vars = T.RT_2
  },
  [13211] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SpAddBuff.BP_AbyssGP_SpAddBuff",
    Camp = "Player",
    ID = 13211,
    Vars = {
      Buff = 2013211,
      LastTime = 24,
      SpCost = 300
    }
  },
  [13212] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 13212,
    Vars = {Buff = 2013212}
  },
  [13221] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 13221,
    Vars = {
      Buff = 2013221,
      HitCount = 3,
      LastTime = 20
    }
  },
  [13222] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 13222,
    Vars = T.RT_3
  },
  [14111] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 14111,
    Vars = {
      Buff = 2014111,
      HitCount = 1,
      IsCrit = true,
      LastTime = 12
    }
  },
  [14121] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
    Camp = "Player",
    ID = 14121,
    Vars = {Buff = 2014121, LastTime = 18}
  },
  [14122] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 14122,
    Vars = {Buff = 2014122}
  },
  [14211] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SpAddBuff.BP_AbyssGP_SpAddBuff",
    Camp = "Player",
    ID = 14211,
    Vars = {
      Buff = 2014211,
      LastTime = 18,
      SpCost = 20
    }
  },
  [14212] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 14212,
    Vars = {Buff = 2014212}
  },
  [14221] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillAddBuff.BP_AbyssGP_SkillAddBuff",
    Camp = "Player",
    ID = 14221,
    Vars = {Buff = 2014221, LastTime = 18}
  },
  [15111] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_PersonalAddBuff.BP_AbyssGP_PersonalAddBuff",
    Camp = "Player",
    ID = 15111,
    Vars = {Buff = 2015111, LastTime = 10}
  },
  [15121] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 15121,
    Vars = {
      Buff = 2015121,
      HitCount = 5,
      LastTime = 10
    }
  },
  [15211] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 15211,
    Vars = {
      Buff = 2015211,
      HitCount = 10,
      LastTime = 10
    }
  },
  [15221] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SummonBuff.BP_AbyssGP_SummonBuff",
    Camp = "Player",
    ID = 15221,
    Vars = {Buff = 2015221, LastTime = 10}
  },
  [20002] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitRemoveBuffNew.BP_AbyssGP_HitRemoveBuffNew",
    Camp = "Monster",
    ID = 20002,
    Vars = {Condition = "Crit", ExtraLayer = 1}
  },
  [20003] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitRemoveBuffNew.BP_AbyssGP_HitRemoveBuffNew",
    Camp = "Monster",
    ID = 20003,
    Vars = {
      Condition = "Tag",
      DamageTag = "Ranged",
      ExtraLayer = 1
    }
  },
  [20004] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitRemoveBuffNew.BP_AbyssGP_HitRemoveBuffNew",
    Camp = "Monster",
    ID = 20004,
    Vars = {
      Condition = "Tag",
      DamageTag = "Weapon",
      ExtraLayer = 1
    }
  },
  [20005] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitRemoveBuffNew.BP_AbyssGP_HitRemoveBuffNew",
    Camp = "Monster",
    ID = 20005,
    Vars = {
      Condition = "Tag",
      DamageTag = "Melee",
      ExtraLayer = 3
    }
  },
  [20006] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitRemoveBuffNew.BP_AbyssGP_HitRemoveBuffNew",
    Camp = "Monster",
    ID = 20006,
    Vars = {
      Condition = "Tag",
      DamageTag = "Dot",
      ExtraLayer = 4
    }
  },
  [20007] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitRemoveBuffNew.BP_AbyssGP_HitRemoveBuffNew",
    Camp = "Monster",
    ID = 20007,
    Vars = {
      Condition = "Tag",
      DamageTag = "Skill",
      ExtraLayer = 4
    }
  },
  [20011] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 20011,
    Vars = T.RT_2
  },
  [20012] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 20012,
    Vars = T.RT_3
  },
  [20021] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 20021,
    Vars = T.RT_1
  },
  [20030] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 20030,
    Vars = {
      Buff = 2010011,
      HitCount = 5,
      LastTime = 10
    }
  },
  [20100] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_BossLockHp.BP_AbyssGP_BossLockHp",
    Camp = "Monster",
    GameplayTag = "Mon.Boss",
    ID = 20100,
    Vars = {
      LastTime = 30,
      LockHpBuff = 2010001,
      LockHpRate = 0.5
    }
  },
  [20101] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_Weakness.BP_AbyssGP_Weakness",
    Camp = "Monster",
    ID = 20101
  },
  [20102] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_EsAddDamage.BP_AbyssGP_EsAddDamage",
    Camp = "Monster",
    ID = 20102,
    Vars = {DamageRate = 0.2}
  },
  [20201] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20201,
    Vars = {Buff = 2010201}
  },
  [20202] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20202,
    Vars = {Buff = 2010202, Condition = "Crit"}
  },
  [20203] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20203,
    Vars = {
      Buff = 2010203,
      Condition = "Tag",
      DamageTag = "Ranged"
    }
  },
  [20204] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20204,
    Vars = {
      Buff = 2010204,
      Condition = "Tag",
      DamageTag = "Weapon"
    }
  },
  [20205] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20205,
    Vars = {
      Buff = 2010205,
      Condition = "Tag",
      DamageTag = "Melee"
    }
  },
  [20206] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20206,
    Vars = {
      Buff = 2010206,
      Condition = "Tag",
      DamageTag = "Dot"
    }
  },
  [20207] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HittedRemoveBuff.BP_AbyssGP_HittedRemoveBuff",
    Camp = "Monster",
    ID = 20207,
    Vars = {
      Buff = 2010207,
      Condition = "Tag",
      DamageTag = "Skill"
    }
  },
  [20301] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_HitCountBuff.BP_AbyssGP_HitCountBuff",
    Camp = "Player",
    ID = 20301,
    Vars = {
      Buff = 2010301,
      HitCount = 5,
      LastTime = 15
    }
  },
  [20302] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Player",
    ID = 20302,
    Vars = {Buff = 2010302}
  },
  [20303] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_CritUpByBuff.BP_AbyssGP_CritUpByBuff",
    Camp = "Player",
    ID = 20303,
    Vars = {CritRate = 0.2}
  },
  [20304] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SpAddBuff.BP_AbyssGP_SpAddBuff",
    ID = 20304,
    Vars = {
      Buff = 2010304,
      LastTime = 15,
      SpCost = 15
    }
  },
  [20401] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_AddBuff.BP_AbyssGP_AddBuff",
    Camp = "Monster",
    GameplayTag = "Mon.Elite",
    ID = 20401,
    Vars = {Buff = 2010101}
  },
  [20511] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_DmgExchange.BP_AbyssGP_DmgExchange",
    Camp = "Player",
    ID = 20511,
    Vars = {
      DownRate = -0.5,
      DownTag = "Dot",
      UpRate = 0.5,
      UpTag = "Weapon"
    }
  },
  [20512] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Abyss/BP_AbyssGP_SkillTrigger.BP_AbyssGP_SkillTrigger",
    Camp = "Player",
    ID = 20512,
    Vars = {Buff = 2010512, TriggerProb = 1}
  },
  [22001] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_1.BP_EventGP_Wys_1",
    Camp = "Player",
    ID = 22001,
    Vars = {LastTime = 5}
  },
  [22002] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_2.BP_EventGP_Wys_2",
    Camp = "Player",
    ID = 22002,
    Vars = {DamagePerLayer = 0.06}
  },
  [22003] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_3.BP_EventGP_Wys_3",
    Camp = "Player",
    ID = 22003,
    Vars = {LastTime = 15}
  },
  [22004] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_Wys_4.BP_EventGP_Wys_4",
    Camp = "Player",
    ID = 22004,
    Vars = {DamagePerLayer = 0.15, MaxLayer = 12}
  },
  [23001] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Player",
    ID = 23001,
    Vars = {Buff = 4030001, LastTime = -1}
  },
  [23002] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Player",
    ID = 23002,
    Vars = {Buff = 4030002, LastTime = -1}
  },
  [23003] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Player",
    ID = 23003,
    Vars = {Buff = 4030003, LastTime = -1}
  },
  [23004] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Monster",
    ID = 23004,
    Vars = {Buff = 4030004, LastTime = -1}
  },
  [23005] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Player",
    ID = 23005,
    Vars = {Buff = 4030005, LastTime = -1}
  },
  [23006] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Monster",
    ID = 23006,
    Vars = {Buff = 4030006, LastTime = -1}
  },
  [23007] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_AddBuff.BP_EventGP_AddBuff",
    Camp = "Monster",
    ID = 23007,
    Vars = {Buff = 4030007, LastTime = -1}
  },
  [23101] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_01.BP_EventGP_WV_01",
    Camp = "Player",
    ID = 23101
  },
  [23102] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_02.BP_EventGP_WV_02",
    Camp = "Player",
    ID = 23102
  },
  [23103] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_03.BP_EventGP_WV_03",
    Camp = "Player",
    ID = 23103
  },
  [23104] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_04.BP_EventGP_WV_04",
    Camp = "Player",
    ID = 23104
  },
  [23105] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_05.BP_EventGP_WV_05",
    Camp = "Player",
    ID = 23105
  },
  [23106] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_06.BP_EventGP_WV_06",
    Camp = "Player",
    ID = 23106
  },
  [23107] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_07.BP_EventGP_WV_07",
    Camp = "Player",
    ID = 23107
  },
  [23108] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_08.BP_EventGP_WV_08",
    Camp = "Player",
    ID = 23108
  },
  [23109] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_09.BP_EventGP_WV_09",
    Camp = "Player",
    ID = 23109
  },
  [23110] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_10.BP_EventGP_WV_10",
    Camp = "Player",
    ID = 23110
  },
  [23111] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_11.BP_EventGP_WV_11",
    Camp = "Player",
    ID = 23111
  },
  [23112] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_12.BP_EventGP_WV_12",
    Camp = "Player",
    ID = 23112
  },
  [23113] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_13.BP_EventGP_WV_13",
    Camp = "Player",
    ID = 23113
  },
  [23114] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_14.BP_EventGP_WV_14",
    Camp = "Player",
    ID = 23114
  },
  [23115] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Event/BP_EventGP_WV_15.BP_EventGP_WV_15",
    Camp = "Player",
    ID = 23115
  },
  [30100] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_Common.BP_RaidGP_Common",
    Camp = "Monster",
    ID = 30100,
    Vars = {EliteRate = 0.27, NormalRate = 0.033}
  },
  [30101] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_010.BP_RaidGP_010",
    Camp = "Player",
    ID = 30101,
    Vars = {
      Divider = 0.3,
      Element = "Wind",
      MaxSkillInten = 4,
      Penetration = 0.05
    }
  },
  [30102] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_012.BP_RaidGP_012",
    Camp = "Player",
    ID = 30102,
    Vars = {
      Divider = 0.3,
      MaxSkillInten = 4.6,
      Penetration = 0.035
    }
  },
  [30103] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_013.BP_RaidGP_013",
    Camp = "Player",
    ID = 30103,
    Vars = {
      Divider1 = 0.1,
      Divider2 = 0.2,
      MaxRange = 0.6,
      MaxSustain = 1,
      Penetration1 = 0.07,
      Penetration2 = 0.1
    }
  },
  [30104] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_014.BP_RaidGP_014",
    Camp = "Player",
    ID = 30104,
    Vars = {
      Divider = 0.12,
      MaxStrong = 0.6,
      Penetration = 0.1
    }
  },
  [30105] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/Raid/BP_RaidGP_010.BP_RaidGP_010",
    Camp = "Player",
    ID = 30105,
    Vars = {
      Divider = 0.4,
      Element = "Water",
      MaxSkillInten = 5,
      Penetration = 0.05
    }
  },
  [30101001] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30101001.BP_Rou_Contract_30101001",
    Camp = "Player",
    ID = 30101001,
    Vars = {HealRate = "#1"}
  },
  [30101002] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30101002.BP_Rou_Contract_30101002",
    Camp = "Player",
    ID = 30101002
  },
  [30102001] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102001.BP_Rou_Contract_30102001",
    Camp = "Monster",
    ID = 30102001
  },
  [30102002] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102002.BP_Rou_Contract_30102002",
    Camp = "Monster",
    ID = 30102002
  },
  [30102003] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102003.BP_Rou_Contract_30102003",
    Camp = "Monster",
    ID = 30102003,
    Vars = {DamagedRate = "#1"}
  },
  [30102004] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30102004.BP_Rou_Contract_30102004",
    Camp = "Monster",
    ID = 30102004
  },
  [30103001] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30103001.BP_Rou_Contract_30103001",
    Camp = "Player",
    ID = 30103001,
    Vars = T.RT_4
  },
  [30103002] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30103002.BP_Rou_Contract_30103002",
    Camp = "Player",
    ID = 30103002,
    Vars = T.RT_4
  },
  [30103003] = {
    BPPath = "/Game/BluePrints/Combat/PassiveEffect/DesignerBP/RougeLike/Contract/BP_Rou_Contract_30103003.BP_Rou_Contract_30103003",
    Camp = "Player",
    ID = 30103003,
    Vars = T.RT_4
  }
})
