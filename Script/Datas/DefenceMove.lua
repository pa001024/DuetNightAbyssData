local T = {}
T.RT_1 = {0, 0}
T.RT_2 = {317}
T.RT_3 = {318}
T.RT_4 = {315}
T.RT_5 = {316}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DefenceMove", {
  [90171] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90171,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        90171,
        901710,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90172] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90172,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        90172,
        901720,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90173] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90173,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        90173,
        901730,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90174] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90174,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        90174,
        901740,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90175] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90175,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        90175,
        901750,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90176] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90176,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        90176,
        901760,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90177] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90177,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        90177,
        901770,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [90178] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 90178,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        90178,
        901780,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91201] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91201,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        91201,
        912010,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91202] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91202,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        91202,
        912020,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91251] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91251,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91251,
        912510,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91252] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91252,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91252,
        912520,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91253] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91253,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91253,
        912530,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91254] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91254,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91254,
        912540,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91255] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91255,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91255,
        912550,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91256] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91256,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91256,
        912560,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91257] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91257,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91257,
        912570,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91258] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91258,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91258,
        912580,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [91259] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 91259,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_4,
      [2] = {
        91259,
        912590,
        316
      },
      [3] = T.RT_4,
      [4] = T.RT_5,
      [5] = T.RT_4,
      [6] = T.RT_5
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  },
  [614101] = {
    ButcherMonsterId = 8501002,
    ButcherMonsterSpawnMinWave = 10,
    ButcherMonsterSpawnProbability = T.RT_1,
    DungeonId = 614101,
    EnsureGuideTime = 180,
    MonsterSpawnId = {
      [1] = T.RT_2,
      [2] = {
        614101,
        6141010,
        318
      },
      [3] = T.RT_2,
      [4] = T.RT_3,
      [5] = T.RT_2,
      [6] = T.RT_3
    },
    MonsterTotalBaseNum = 100,
    WavesPerStage = 2
  }
})
