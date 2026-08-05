local T = {}
T.RT_1 = {301}
T.RT_2 = {302, 307}
T.RT_3 = {303}
T.RT_4 = {304, 307}
T.RT_5 = {305}
T.RT_6 = {306, 308}
T.RT_7 = {
  [1] = T.RT_1,
  [2] = T.RT_2,
  [3] = T.RT_3,
  [4] = T.RT_4,
  [5] = T.RT_5,
  [6] = T.RT_6
}
T.RT_8 = {0.9, 0.1}
T.RT_9 = {100302}
T.RT_10 = {100304}
T.RT_11 = {100306, 91134}
T.RT_12 = {
  [1] = T.RT_9,
  [2] = T.RT_10,
  [3] = T.RT_11
}
T.RT_13 = {0.6, 0.2}
T.RT_14 = {0, 0}
T.RT_15 = {313}
T.RT_16 = {614001, 314}
T.RT_17 = {311}
T.RT_18 = {615007, 312}
T.RT_19 = {615008, 312}
T.RT_20 = {615009, 312}
T.RT_21 = {615010, 312}
T.RT_22 = {615011, 312}
T.RT_23 = {615012, 312}
T.RT_24 = {90161, 312}
T.RT_25 = {90162, 312}
T.RT_26 = {90163, 314}
T.RT_27 = {90164, 314}
T.RT_28 = {90165, 314}
T.RT_29 = {90166, 314}
T.RT_30 = {90167, 312}
T.RT_31 = {90168, 312}
T.RT_32 = {90169, 314}
T.RT_33 = {90170, 314}
T.RT_34 = {90180, 312}
T.RT_35 = {90181, 312}
T.RT_36 = {90182, 312}
T.RT_37 = {90183, 312}
T.RT_38 = {90184, 312}
T.RT_39 = {90185, 312}
T.RT_40 = {90186, 312}
T.RT_41 = {90187, 312}
T.RT_42 = {90188, 312}
T.RT_43 = {0.9, 0.2}
T.RT_44 = {9170101, 9170102}
T.RT_45 = {
  [1] = T.RT_44
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Defence", {
  [20002] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = {0.5, 0.1},
    DungeonId = 20002,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30101] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30101,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30102] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30102,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30103] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30103,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30104] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30104,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30105] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30105,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30106] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30106,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [30107] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30107,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_12,
    MonsterTotalBaseNum = 15
  },
  [30108] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 30108,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_12,
    MonsterTotalBaseNum = 15
  },
  [60101] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 4,
    ButcherMonsterSpawnProbability = T.RT_13,
    DungeonId = 60101,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [60102] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 60102,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15,
    WavesPerStage = 2
  },
  [62101] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 4,
    ButcherMonsterSpawnProbability = T.RT_13,
    DungeonId = 62101,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [62102] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 62102,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15,
    WavesPerStage = 2
  },
  [64101] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 4,
    ButcherMonsterSpawnProbability = T.RT_13,
    DungeonId = 64101,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [64102] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 64102,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15,
    WavesPerStage = 2
  },
  [90102] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90102,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [90104] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 4,
    ButcherMonsterSpawnProbability = T.RT_13,
    DungeonId = 90104,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [90106] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 90106,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [90108] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 90108,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = {100301},
      [2] = {100302, 100307},
      [3] = {100303},
      [4] = {100304, 100307},
      [5] = {100305},
      [6] = {100306, 100308}
    },
    MonsterTotalBaseNum = 15
  },
  [90110] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 90110,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [90112] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 90112,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [90114] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 90114,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_7,
    MonsterTotalBaseNum = 15
  },
  [90161] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90161,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_24,
      [3] = T.RT_17,
      [4] = T.RT_24,
      [5] = T.RT_17,
      [6] = T.RT_24
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90162] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90162,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_25,
      [3] = T.RT_17,
      [4] = T.RT_25,
      [5] = T.RT_17,
      [6] = T.RT_25
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90163] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90163,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_26,
      [3] = T.RT_15,
      [4] = T.RT_26,
      [5] = T.RT_15,
      [6] = T.RT_26
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90164] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90164,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_27,
      [3] = T.RT_15,
      [4] = T.RT_27,
      [5] = T.RT_15,
      [6] = T.RT_27
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90165] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90165,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_28,
      [3] = T.RT_15,
      [4] = T.RT_28,
      [5] = T.RT_15,
      [6] = T.RT_28
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90166] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90166,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_29,
      [3] = T.RT_15,
      [4] = T.RT_29,
      [5] = T.RT_15,
      [6] = T.RT_29
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90167] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90167,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_30,
      [3] = T.RT_17,
      [4] = T.RT_30,
      [5] = T.RT_17,
      [6] = T.RT_30
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90168] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90168,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_31,
      [3] = T.RT_17,
      [4] = T.RT_31,
      [5] = T.RT_17,
      [6] = T.RT_31
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90169] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90169,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_32,
      [3] = T.RT_15,
      [4] = T.RT_32,
      [5] = T.RT_15,
      [6] = T.RT_32
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90170] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90170,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_33,
      [3] = T.RT_15,
      [4] = T.RT_33,
      [5] = T.RT_15,
      [6] = T.RT_33
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90180] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90180,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_34,
      [3] = T.RT_17,
      [4] = T.RT_34,
      [5] = T.RT_17,
      [6] = T.RT_34
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90181] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90181,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_35,
      [3] = T.RT_17,
      [4] = T.RT_35,
      [5] = T.RT_17,
      [6] = T.RT_35
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90182] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90182,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_36,
      [3] = T.RT_17,
      [4] = T.RT_36,
      [5] = T.RT_17,
      [6] = T.RT_36
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90183] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90183,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_37,
      [3] = T.RT_17,
      [4] = T.RT_37,
      [5] = T.RT_17,
      [6] = T.RT_37
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90184] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90184,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_38,
      [3] = T.RT_17,
      [4] = T.RT_38,
      [5] = T.RT_17,
      [6] = T.RT_38
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90185] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90185,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_39,
      [3] = T.RT_17,
      [4] = T.RT_39,
      [5] = T.RT_17,
      [6] = T.RT_39
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90186] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90186,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_40,
      [3] = T.RT_17,
      [4] = T.RT_40,
      [5] = T.RT_17,
      [6] = T.RT_40
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90187] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90187,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_41,
      [3] = T.RT_17,
      [4] = T.RT_41,
      [5] = T.RT_17,
      [6] = T.RT_41
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [90188] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 90188,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_42,
      [3] = T.RT_17,
      [4] = T.RT_42,
      [5] = T.RT_17,
      [6] = T.RT_42
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [91134] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91134,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_12,
    MonsterTotalBaseNum = 15
  },
  [91135] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91135,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 91135}
    },
    MonsterTotalBaseNum = 15
  },
  [91146] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91146,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 91146}
    },
    MonsterTotalBaseNum = 15
  },
  [91147] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91147,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 91147}
    },
    MonsterTotalBaseNum = 15
  },
  [91150] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91150,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 91150}
    },
    MonsterTotalBaseNum = 15
  },
  [91183] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91183,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        91183,
        911831
      },
      [2] = {
        100310,
        91183,
        911831
      },
      [3] = {100311, 911830}
    },
    MonsterTotalBaseNum = 80
  },
  [91184] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91184,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        91184,
        911841
      },
      [2] = {
        100310,
        91184,
        911841
      },
      [3] = {100311, 911840}
    },
    MonsterTotalBaseNum = 80
  },
  [91187] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91187,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 91187}
    },
    MonsterTotalBaseNum = 15
  },
  [91208] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91208,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        91208,
        912081
      },
      [2] = {
        100310,
        91208,
        912081
      },
      [3] = {100311, 912080}
    },
    MonsterTotalBaseNum = 80
  },
  [91209] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91209,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        91209,
        912091
      },
      [2] = {
        100310,
        91209,
        912091
      },
      [3] = {100311, 912090}
    },
    MonsterTotalBaseNum = 80
  },
  [91212] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91212,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        91212,
        912121
      },
      [2] = {
        100310,
        91212,
        912121
      },
      [3] = {100311, 912120}
    },
    MonsterTotalBaseNum = 80
  },
  [91213] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 91213,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        91213,
        912131
      },
      [2] = {
        100310,
        91213,
        912131
      },
      [3] = {100311, 912130}
    },
    MonsterTotalBaseNum = 80
  },
  [91701] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_43,
    DungeonId = 91701,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_45,
    MonsterTotalBaseNum = 120,
    WavesPerStage = 1
  },
  [91702] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_43,
    DungeonId = 91702,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_45,
    MonsterTotalBaseNum = 120,
    WavesPerStage = 1
  },
  [91703] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_43,
    DungeonId = 91703,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_45,
    MonsterTotalBaseNum = 120,
    WavesPerStage = 1
  },
  [91704] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_43,
    DungeonId = 91704,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_45,
    MonsterTotalBaseNum = 120,
    WavesPerStage = 1
  },
  [91705] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_43,
    DungeonId = 91705,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_45,
    MonsterTotalBaseNum = 120,
    WavesPerStage = 1
  },
  [91706] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_43,
    DungeonId = 91706,
    EnsureGuideTime = -1,
    MonsterSpawnId = T.RT_45,
    MonsterTotalBaseNum = 120,
    WavesPerStage = 1
  },
  [614001] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 614001,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_15,
      [2] = T.RT_16,
      [3] = T.RT_15,
      [4] = T.RT_16,
      [5] = T.RT_15,
      [6] = T.RT_16
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [614007] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 614007,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 614007}
    },
    MonsterTotalBaseNum = 15
  },
  [614008] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 614008,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 614008}
    },
    MonsterTotalBaseNum = 15
  },
  [614107] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 614107,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        614107,
        6141071
      },
      [2] = {
        100310,
        614107,
        6141071
      },
      [3] = {100311, 6141070}
    },
    MonsterTotalBaseNum = 80
  },
  [614108] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 614108,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        614108,
        6141081
      },
      [2] = {
        100310,
        614108,
        6141081
      },
      [3] = {100311, 6141080}
    },
    MonsterTotalBaseNum = 80
  },
  [615005] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 615005,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 615005}
    },
    MonsterTotalBaseNum = 15
  },
  [615006] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 615006,
    EnsureGuideTime = -1,
    MonsterSpawnId = {
      [1] = T.RT_9,
      [2] = T.RT_10,
      [3] = {100306, 615006}
    },
    MonsterTotalBaseNum = 15
  },
  [615007] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 615007,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_18,
      [3] = T.RT_17,
      [4] = T.RT_18,
      [5] = T.RT_17,
      [6] = T.RT_18
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [615008] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 615008,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_19,
      [3] = T.RT_17,
      [4] = T.RT_19,
      [5] = T.RT_17,
      [6] = T.RT_19
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [615009] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 615009,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_20,
      [3] = T.RT_17,
      [4] = T.RT_20,
      [5] = T.RT_17,
      [6] = T.RT_20
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [615010] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 615010,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_21,
      [3] = T.RT_17,
      [4] = T.RT_21,
      [5] = T.RT_17,
      [6] = T.RT_21
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [615011] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 615011,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_22,
      [3] = T.RT_17,
      [4] = T.RT_22,
      [5] = T.RT_17,
      [6] = T.RT_22
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [615012] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_14,
    DungeonId = 615012,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_17,
      [2] = T.RT_23,
      [3] = T.RT_17,
      [4] = T.RT_23,
      [5] = T.RT_17,
      [6] = T.RT_23
    },
    MonsterTotalBaseNum = 50,
    WavesPerStage = 2
  },
  [615105] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 615105,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        615105,
        6151051
      },
      [2] = {
        100310,
        615105,
        6151051
      },
      [3] = {100311, 6151050}
    },
    MonsterTotalBaseNum = 80
  },
  [615106] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 2,
    ButcherMonsterSpawnProbability = T.RT_8,
    DungeonId = 615106,
    EnsureGuideTime = 60,
    MonsterSpawnId = {
      [1] = {
        100309,
        615106,
        6151061
      },
      [2] = {
        100310,
        615106,
        6151061
      },
      [3] = {100311, 6151060}
    },
    MonsterTotalBaseNum = 80
  }
})
