local T = {}
T.RT_1 = {MaxSummonerCount = 3, SummonerId = 210101}
T.RT_2 = {0, 1}
T.RT_3 = {
  ID = 1,
  Params = T.RT_1,
  ScaleNode = "Main",
  SkillGrade = T.RT_2,
  UIName = "UISkillShuimu"
}
T.RT_4 = {MaxSummonerCount = 5, SummonerId = 210101}
T.RT_5 = {
  2,
  3,
  4,
  5,
  6
}
T.RT_6 = {
  ID = 1,
  Params = T.RT_4,
  ScaleNode = "Main",
  SkillGrade = T.RT_5,
  UIName = "UISkillShuimu"
}
T.RT_7 = {SpecialUI = 0}
T.RT_8 = {
  ID = 10,
  Params = T.RT_7,
  ScaleNode = "Main",
  SkillGrade = T.RT_2,
  UIName = "UISkillXibi"
}
T.RT_9 = {SpecialUI = 1}
T.RT_10 = {
  ID = 10,
  Params = T.RT_9,
  ScaleNode = "Main",
  SkillGrade = T.RT_5,
  UIName = "UISkillXibi"
}
T.RT_11 = {
  0,
  1,
  2,
  3,
  4,
  5,
  6
}
T.RT_12 = {
  ID = 11,
  SkillGrade = T.RT_11,
  TriggerBuffId = 3,
  UIName = "UISkillNvzhu"
}
T.RT_13 = {
  [180131] = 1,
  [180132] = 2,
  [180133] = 3,
  [180134] = 4,
  [180135] = 1,
  [180136] = 2,
  [180137] = 3,
  [180138] = 4
}
T.RT_14 = {
  180131,
  180132,
  180133,
  180134,
  180135,
  180136,
  180137,
  180138
}
T.RT_15 = {
  ID = 12,
  Params = T.RT_13,
  RelatedBuffId = T.RT_14,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillFeina"
}
T.RT_16 = {SummonerId = 420201}
T.RT_17 = {420211}
T.RT_18 = {
  ID = 13,
  Params = T.RT_16,
  RelatedBuffId = T.RT_17,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  TriggerBuffId = 420211,
  UIName = "UISkillLandi"
}
T.RT_19 = {MaxSummonerCount = 2, UnitId = 240101}
T.RT_20 = {
  ID = 14,
  Params = T.RT_19,
  ScaleNode = "Main",
  SkillGrade = T.RT_2,
  UIName = "UISKillFushu"
}
T.RT_21 = {MaxSummonerCount = 3, UnitId = 240101}
T.RT_22 = {
  ID = 14,
  Params = T.RT_21,
  ScaleNode = "Main",
  SkillGrade = T.RT_5,
  UIName = "UISKillFushu"
}
T.RT_23 = {
  ID = 16,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillLise"
}
T.RT_24 = {110302}
T.RT_25 = {
  ID = 17,
  RelatedBuffId = T.RT_24,
  SkillGrade = T.RT_11,
  TriggerBuffDelay = 1.5,
  TriggerBuffId = 110302,
  UIName = "UISkill2Tuosi"
}
T.RT_26 = {FireBuffId = 110331}
T.RT_27 = {110331}
T.RT_28 = {
  ID = 18,
  Params = T.RT_26,
  RelatedBuffId = T.RT_27,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillTuosi"
}
T.RT_29 = {
  PassiveEffectId = 410201,
  ThunderBuffId = 410201,
  WindBuffId = 410202
}
T.RT_30 = {410201, 410202}
T.RT_31 = {
  ID = 19,
  Params = T.RT_29,
  RelatedBuffId = T.RT_30,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillZhiliu"
}
T.RT_32 = {110101}
T.RT_33 = {
  ID = 2,
  RelatedBuffId = T.RT_32,
  SkillGrade = T.RT_11,
  TriggerBuffDelay = 0.8,
  TriggerBuffId = 110101,
  UIName = "UISkillSpade"
}
T.RT_34 = {SummonId = 310202}
T.RT_35 = {
  ID = 20,
  Params = T.RT_34,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillXier"
}
T.RT_36 = {
  MeleeBuffId = 150307,
  MeleeWeakBuffId = 150325,
  RangedBuffId = 150308
}
T.RT_37 = {
  150307,
  150308,
  150325
}
T.RT_38 = {
  1,
  2,
  3,
  4,
  5,
  6
}
T.RT_39 = {
  ID = 21,
  Params = T.RT_36,
  RelatedBuffId = T.RT_37,
  ScaleNode = "Main",
  SkillGrade = T.RT_38,
  UIName = "UISkillKezhou"
}
T.RT_40 = {
  ID = 23,
  SkillGrade = T.RT_11,
  UIName = "UISkillSaqiUltiSkin1"
}
T.RT_41 = {FlashLevel = 1}
T.RT_42 = {240151}
T.RT_43 = {
  ID = 24,
  Params = T.RT_41,
  RelatedBuffId = T.RT_42,
  SkillGrade = T.RT_11,
  TriggerBuffId = 240151,
  UIName = "UIFushuNearDeath"
}
T.RT_44 = {FlashLevel = 2}
T.RT_45 = {240152}
T.RT_46 = {
  ID = 25,
  Params = T.RT_44,
  RelatedBuffId = T.RT_45,
  SkillGrade = T.RT_11,
  TriggerBuffId = 240152,
  UIName = "UIFushuNearDeath"
}
T.RT_47 = {FlashLevel = 3}
T.RT_48 = {240153}
T.RT_49 = {
  ID = 26,
  Params = T.RT_47,
  RelatedBuffId = T.RT_48,
  SkillGrade = T.RT_11,
  TriggerBuffId = 240153,
  UIName = "UIFushuNearDeath"
}
T.RT_50 = {
  ID = 27,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillLise"
}
T.RT_51 = {BuffId = 150101}
T.RT_52 = {
  ID = 28,
  Params = T.RT_51,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillBaonu"
}
T.RT_53 = {CreatureId = 320202}
T.RT_54 = {
  ID = 29,
  Params = T.RT_53,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillKami"
}
T.RT_55 = {530101}
T.RT_56 = {
  ID = 3,
  RelatedBuffId = T.RT_55,
  SkillGrade = T.RT_11,
  TriggerBuffId = 530101,
  UIName = "UISkillSaqiUlti"
}
T.RT_57 = {
  ID = 30,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillSuyi"
}
T.RT_58 = {150401}
T.RT_59 = {
  ID = 31,
  RelatedBuffId = T.RT_58,
  SkillGrade = T.RT_11,
  TriggerBuffId = 150401,
  UIName = "UISkillSuyiUlti"
}
T.RT_60 = {9000201}
T.RT_61 = {
  ID = 32,
  Params = T.RT_47,
  RelatedBuffId = T.RT_60,
  SkillGrade = T.RT_11,
  TriggerBuffId = 9000201,
  UIName = "UIFushuNearDeath"
}
T.RT_62 = {
  ID = 33,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillSuyi01"
}
T.RT_63 = {
  ID = 34,
  SkillGrade = T.RT_11,
  UIName = "UISkillSuyiUlti01"
}
T.RT_64 = {320232}
T.RT_65 = {
  ID = 35,
  RelatedBuffId = T.RT_64,
  SkillGrade = T.RT_11,
  TriggerBuffId = 320232,
  UIName = "UISkillKamiUlti"
}
T.RT_66 = {110221}
T.RT_67 = {
  ID = 36,
  RelatedBuffId = T.RT_66,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillFuluo"
}
T.RT_68 = {
  ID = 37,
  RelatedBuffId = T.RT_66,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillFuluo01"
}
T.RT_69 = {110202}
T.RT_70 = {
  ID = 38,
  RelatedBuffId = T.RT_69,
  SkillGrade = T.RT_11,
  TriggerBuffDelay = 0.6,
  TriggerBuffId = 110202,
  UIName = "UISkillFuluoUlti"
}
T.RT_71 = {
  ID = 39,
  SkillGrade = T.RT_11,
  UIName = "UISkillFuluoUlti01"
}
T.RT_72 = {EnhancedReloadBuffId = 310131, FirepowerSuppressionBuffId = 310132}
T.RT_73 = {
  ID = 4,
  Params = T.RT_72,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillLinen"
}
T.RT_74 = {
  ID = 40,
  Params = T.RT_1,
  ScaleNode = "Main",
  SkillGrade = T.RT_2,
  UIName = "UISkillShuimu01"
}
T.RT_75 = {
  ID = 40,
  Params = T.RT_4,
  ScaleNode = "Main",
  SkillGrade = T.RT_5,
  UIName = "UISkillShuimu01"
}
T.RT_76 = {
  MaxSum01 = 8,
  MaxSum02 = 2,
  MaxSum03 = 1,
  Sum01Id = 210202,
  Sum02Id = 210203,
  Sum03Id = 210204
}
T.RT_77 = {
  ID = 41,
  Params = T.RT_76,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillEve"
}
T.RT_78 = {210202}
T.RT_79 = {
  ID = 42,
  RelatedBuffId = T.RT_78,
  SkillGrade = T.RT_11,
  TriggerBuffId = 210202,
  UIName = "UISkillEveUlti"
}
T.RT_80 = {
  ID = 43,
  SkillGrade = T.RT_11,
  UIName = "UISkillEveUltiSkin1"
}
T.RT_81 = {RideBuff = 510121, SummonerId = 510101}
T.RT_82 = {
  ID = 5,
  Params = T.RT_81,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillSonglu"
}
T.RT_83 = {SummonerId = 420101}
T.RT_84 = {
  ID = 6,
  Params = T.RT_83,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  UIName = "UISkillHeilong"
}
T.RT_85 = {310122}
T.RT_86 = {
  ID = 7,
  RelatedBuffId = T.RT_85,
  ScaleNode = "Main",
  SkillGrade = T.RT_11,
  TriggerBuffId = 310122,
  UIName = "UISkill2Linen"
}
T.RT_87 = {850405}
T.RT_88 = {
  ID = 8,
  RelatedBuffId = T.RT_87,
  SkillGrade = T.RT_11,
  TriggerBuffId = 850405,
  UIName = "UISkillSaqiUlti"
}
T.RT_89 = {310301}
T.RT_90 = {
  ID = 9,
  RelatedBuffId = T.RT_89,
  SkillGrade = T.RT_11,
  TriggerBuffId = 310301,
  UIName = "UISkilYeerUlti"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BattleCharUI", {
  [1] = {
    [0] = T.RT_3,
    [1] = T.RT_3,
    [2] = T.RT_6,
    [3] = T.RT_6,
    [4] = T.RT_6,
    [5] = T.RT_6,
    [6] = T.RT_6
  },
  [2] = {
    [0] = T.RT_33,
    [1] = T.RT_33,
    [2] = T.RT_33,
    [3] = T.RT_33,
    [4] = T.RT_33,
    [5] = T.RT_33,
    [6] = T.RT_33
  },
  [3] = {
    [0] = T.RT_56,
    [1] = T.RT_56,
    [2] = T.RT_56,
    [3] = T.RT_56,
    [4] = T.RT_56,
    [5] = T.RT_56,
    [6] = T.RT_56
  },
  [4] = {
    [0] = T.RT_73,
    [1] = T.RT_73,
    [2] = T.RT_73,
    [3] = T.RT_73,
    [4] = T.RT_73,
    [5] = T.RT_73,
    [6] = T.RT_73
  },
  [5] = {
    [0] = T.RT_82,
    [1] = T.RT_82,
    [2] = T.RT_82,
    [3] = T.RT_82,
    [4] = T.RT_82,
    [5] = T.RT_82,
    [6] = T.RT_82
  },
  [6] = {
    [0] = T.RT_84,
    [1] = T.RT_84,
    [2] = T.RT_84,
    [3] = T.RT_84,
    [4] = T.RT_84,
    [5] = T.RT_84,
    [6] = T.RT_84
  },
  [7] = {
    [0] = T.RT_86,
    [1] = T.RT_86,
    [2] = T.RT_86,
    [3] = T.RT_86,
    [4] = T.RT_86,
    [5] = T.RT_86,
    [6] = T.RT_86
  },
  [8] = {
    [0] = T.RT_88,
    [1] = T.RT_88,
    [2] = T.RT_88,
    [3] = T.RT_88,
    [4] = T.RT_88,
    [5] = T.RT_88,
    [6] = T.RT_88
  },
  [9] = {
    [0] = T.RT_90,
    [1] = T.RT_90,
    [2] = T.RT_90,
    [3] = T.RT_90,
    [4] = T.RT_90,
    [5] = T.RT_90,
    [6] = T.RT_90
  },
  [10] = {
    [0] = T.RT_8,
    [1] = T.RT_8,
    [2] = T.RT_10,
    [3] = T.RT_10,
    [4] = T.RT_10,
    [5] = T.RT_10,
    [6] = T.RT_10
  },
  [11] = {
    [0] = T.RT_12,
    [1] = T.RT_12,
    [2] = T.RT_12,
    [3] = T.RT_12,
    [4] = T.RT_12,
    [5] = T.RT_12,
    [6] = T.RT_12
  },
  [12] = {
    [0] = T.RT_15,
    [1] = T.RT_15,
    [2] = T.RT_15,
    [3] = T.RT_15,
    [4] = T.RT_15,
    [5] = T.RT_15,
    [6] = T.RT_15
  },
  [13] = {
    [0] = T.RT_18,
    [1] = T.RT_18,
    [2] = T.RT_18,
    [3] = T.RT_18,
    [4] = T.RT_18,
    [5] = T.RT_18,
    [6] = T.RT_18
  },
  [14] = {
    [0] = T.RT_20,
    [1] = T.RT_20,
    [2] = T.RT_22,
    [3] = T.RT_22,
    [4] = T.RT_22,
    [5] = T.RT_22,
    [6] = T.RT_22
  },
  [16] = {
    [0] = T.RT_23,
    [1] = T.RT_23,
    [2] = T.RT_23,
    [3] = T.RT_23,
    [4] = T.RT_23,
    [5] = T.RT_23,
    [6] = T.RT_23
  },
  [17] = {
    [0] = T.RT_25,
    [1] = T.RT_25,
    [2] = T.RT_25,
    [3] = T.RT_25,
    [4] = T.RT_25,
    [5] = T.RT_25,
    [6] = T.RT_25
  },
  [18] = {
    [0] = T.RT_28,
    [1] = T.RT_28,
    [2] = T.RT_28,
    [3] = T.RT_28,
    [4] = T.RT_28,
    [5] = T.RT_28,
    [6] = T.RT_28
  },
  [19] = {
    [0] = T.RT_31,
    [1] = T.RT_31,
    [2] = T.RT_31,
    [3] = T.RT_31,
    [4] = T.RT_31,
    [5] = T.RT_31,
    [6] = T.RT_31
  },
  [20] = {
    [0] = T.RT_35,
    [1] = T.RT_35,
    [2] = T.RT_35,
    [3] = T.RT_35,
    [4] = T.RT_35,
    [5] = T.RT_35,
    [6] = T.RT_35
  },
  [21] = {
    [0] = {
      ID = 21,
      Params = {
        MeleeBuffId = 150301,
        MeleeWeakBuffId = 150325,
        RangedBuffId = 150302
      },
      RelatedBuffId = {
        150301,
        150302,
        150325
      },
      ScaleNode = "Main",
      SkillGrade = {0},
      UIName = "UISkillKezhou"
    },
    [1] = T.RT_39,
    [2] = T.RT_39,
    [3] = T.RT_39,
    [4] = T.RT_39,
    [5] = T.RT_39,
    [6] = T.RT_39
  },
  [23] = {
    [0] = T.RT_40,
    [1] = T.RT_40,
    [2] = T.RT_40,
    [3] = T.RT_40,
    [4] = T.RT_40,
    [5] = T.RT_40,
    [6] = T.RT_40
  },
  [24] = {
    [0] = T.RT_43,
    [1] = T.RT_43,
    [2] = T.RT_43,
    [3] = T.RT_43,
    [4] = T.RT_43,
    [5] = T.RT_43,
    [6] = T.RT_43
  },
  [25] = {
    [0] = T.RT_46,
    [1] = T.RT_46,
    [2] = T.RT_46,
    [3] = T.RT_46,
    [4] = T.RT_46,
    [5] = T.RT_46,
    [6] = T.RT_46
  },
  [26] = {
    [0] = T.RT_49,
    [1] = T.RT_49,
    [2] = T.RT_49,
    [3] = T.RT_49,
    [4] = T.RT_49,
    [5] = T.RT_49,
    [6] = T.RT_49
  },
  [27] = {
    [0] = T.RT_50,
    [1] = T.RT_50,
    [2] = T.RT_50,
    [3] = T.RT_50,
    [4] = T.RT_50,
    [5] = T.RT_50,
    [6] = T.RT_50
  },
  [28] = {
    [0] = T.RT_52,
    [1] = T.RT_52,
    [2] = T.RT_52,
    [3] = T.RT_52,
    [4] = T.RT_52,
    [5] = T.RT_52,
    [6] = T.RT_52
  },
  [29] = {
    [0] = T.RT_54,
    [1] = T.RT_54,
    [2] = T.RT_54,
    [3] = T.RT_54,
    [4] = T.RT_54,
    [5] = T.RT_54,
    [6] = T.RT_54
  },
  [30] = {
    [0] = T.RT_57,
    [1] = T.RT_57,
    [2] = T.RT_57,
    [3] = T.RT_57,
    [4] = T.RT_57,
    [5] = T.RT_57,
    [6] = T.RT_57
  },
  [31] = {
    [0] = T.RT_59,
    [1] = T.RT_59,
    [2] = T.RT_59,
    [3] = T.RT_59,
    [4] = T.RT_59,
    [5] = T.RT_59,
    [6] = T.RT_59
  },
  [32] = {
    [0] = T.RT_61,
    [1] = T.RT_61,
    [2] = T.RT_61,
    [3] = T.RT_61,
    [4] = T.RT_61,
    [5] = T.RT_61,
    [6] = T.RT_61
  },
  [33] = {
    [0] = T.RT_62,
    [1] = T.RT_62,
    [2] = T.RT_62,
    [3] = T.RT_62,
    [4] = T.RT_62,
    [5] = T.RT_62,
    [6] = T.RT_62
  },
  [34] = {
    [0] = T.RT_63,
    [1] = T.RT_63,
    [2] = T.RT_63,
    [3] = T.RT_63,
    [4] = T.RT_63,
    [5] = T.RT_63,
    [6] = T.RT_63
  },
  [35] = {
    [0] = T.RT_65,
    [1] = T.RT_65,
    [2] = T.RT_65,
    [3] = T.RT_65,
    [4] = T.RT_65,
    [5] = T.RT_65,
    [6] = T.RT_65
  },
  [36] = {
    [0] = T.RT_67,
    [1] = T.RT_67,
    [2] = T.RT_67,
    [3] = T.RT_67,
    [4] = T.RT_67,
    [5] = T.RT_67,
    [6] = T.RT_67
  },
  [37] = {
    [0] = T.RT_68,
    [1] = T.RT_68,
    [2] = T.RT_68,
    [3] = T.RT_68,
    [4] = T.RT_68,
    [5] = T.RT_68,
    [6] = T.RT_68
  },
  [38] = {
    [0] = T.RT_70,
    [1] = T.RT_70,
    [2] = T.RT_70,
    [3] = T.RT_70,
    [4] = T.RT_70,
    [5] = T.RT_70,
    [6] = T.RT_70
  },
  [39] = {
    [0] = T.RT_71,
    [1] = T.RT_71,
    [2] = T.RT_71,
    [3] = T.RT_71,
    [4] = T.RT_71,
    [5] = T.RT_71,
    [6] = T.RT_71
  },
  [40] = {
    [0] = T.RT_74,
    [1] = T.RT_74,
    [2] = T.RT_75,
    [3] = T.RT_75,
    [4] = T.RT_75,
    [5] = T.RT_75,
    [6] = T.RT_75
  },
  [41] = {
    [0] = T.RT_77,
    [1] = T.RT_77,
    [2] = T.RT_77,
    [3] = T.RT_77,
    [4] = T.RT_77,
    [5] = T.RT_77,
    [6] = T.RT_77
  },
  [42] = {
    [0] = T.RT_79,
    [1] = T.RT_79,
    [2] = T.RT_79,
    [3] = T.RT_79,
    [4] = T.RT_79,
    [5] = T.RT_79,
    [6] = T.RT_79
  },
  [43] = {
    [0] = T.RT_80,
    [1] = T.RT_80,
    [2] = T.RT_80,
    [3] = T.RT_80,
    [4] = T.RT_80,
    [5] = T.RT_80,
    [6] = T.RT_80
  }
})
