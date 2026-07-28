local T = {}
T.RT_1 = {
  [1] = 37001,
  [2] = 37002,
  [3] = 37003
}
T.RT_2 = {1004}
T.RT_3 = {
  [3] = 37003
}
T.RT_4 = {
  0,
  0,
  1
}
T.RT_5 = {
  [3] = 500
}
T.RT_6 = {
  [1] = 37001
}
T.RT_7 = {
  0.3,
  0,
  0
}
T.RT_8 = {1}
T.RT_9 = {
  [1] = T.RT_8
}
T.RT_10 = {
  [1] = 100
}
T.RT_11 = {
  [1] = 37001,
  [2] = 37002
}
T.RT_12 = {
  0.25,
  0.2,
  0
}
T.RT_13 = {4, 7}
T.RT_14 = {
  [1] = T.RT_8,
  [2] = T.RT_13
}
T.RT_15 = {
  [1] = 100,
  [2] = 200
}
T.RT_16 = {
  0.1,
  0.3,
  0.2
}
T.RT_17 = {1, 7}
T.RT_18 = {2, 10}
T.RT_19 = {
  5,
  12,
  11
}
T.RT_20 = {
  [1] = T.RT_17,
  [2] = T.RT_18,
  [3] = T.RT_19
}
T.RT_21 = {
  [1] = 100,
  [2] = 200,
  [3] = 300
}
T.RT_22 = {
  [2] = 37002,
  [3] = 37003
}
T.RT_23 = {
  0,
  0.3,
  0.5
}
T.RT_24 = {2, 8}
T.RT_25 = {
  5,
  3,
  11
}
T.RT_26 = {
  [2] = T.RT_24,
  [3] = T.RT_25
}
T.RT_27 = {
  [2] = 200,
  [3] = 300
}
T.RT_28 = {9}
T.RT_29 = {
  [3] = T.RT_28
}
T.RT_30 = {
  [3] = 300
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_RewardDropBox", {
  [1] = {
    ID = 1,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = {
      0.3,
      0.3,
      0.3
    },
    RewardBoxTreasureRandom = {
      [1] = T.RT_2,
      [2] = T.RT_2,
      [3] = T.RT_2
    },
    RewardToken = {
      [1] = 100,
      [2] = 100,
      [3] = 100
    }
  },
  [11] = {
    ID = 11,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = {
      [3] = {3, 11}
    },
    RewardToken = T.RT_5
  },
  [12] = {
    ID = 12,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_5
  },
  [21] = {
    ID = 21,
    RewardBoxMechanismID = {
      [1] = 37004
    },
    RewardBoxRate = {
      1,
      0,
      0
    }
  },
  [31] = {
    ID = 31,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [32] = {
    ID = 32,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = {
      [3] = 1500
    }
  },
  [41] = {
    ID = 41,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = {
      0.02,
      0.01,
      0
    },
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [42] = {
    ID = 42,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = {
      0.1,
      0.2,
      0.1
    },
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1101] = {
    ID = 1101,
    RewardBoxMechanismID = T.RT_6,
    RewardBoxRate = T.RT_7,
    RewardBoxTreasureRandom = T.RT_9,
    RewardToken = T.RT_10
  },
  [1102] = {
    ID = 1102,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = T.RT_12,
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [1103] = {
    ID = 1103,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1104] = {
    ID = 1104,
    RewardBoxMechanismID = T.RT_22,
    RewardBoxRate = T.RT_23,
    RewardBoxTreasureRandom = T.RT_26,
    RewardToken = T.RT_27
  },
  [1105] = {
    ID = 1105,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_30
  },
  [1201] = {
    ID = 1201,
    RewardBoxMechanismID = T.RT_6,
    RewardBoxRate = T.RT_7,
    RewardBoxTreasureRandom = T.RT_9,
    RewardToken = T.RT_10
  },
  [1202] = {
    ID = 1202,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = T.RT_12,
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [1203] = {
    ID = 1203,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1204] = {
    ID = 1204,
    RewardBoxMechanismID = T.RT_22,
    RewardBoxRate = T.RT_23,
    RewardBoxTreasureRandom = T.RT_26,
    RewardToken = T.RT_27
  },
  [1205] = {
    ID = 1205,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_30
  },
  [1301] = {
    ID = 1301,
    RewardBoxMechanismID = T.RT_6,
    RewardBoxRate = T.RT_7,
    RewardBoxTreasureRandom = T.RT_9,
    RewardToken = T.RT_10
  },
  [1302] = {
    ID = 1302,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = T.RT_12,
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [1303] = {
    ID = 1303,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1304] = {
    ID = 1304,
    RewardBoxMechanismID = T.RT_22,
    RewardBoxRate = T.RT_23,
    RewardBoxTreasureRandom = T.RT_26,
    RewardToken = T.RT_27
  },
  [1305] = {
    ID = 1305,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_30
  },
  [1401] = {
    ID = 1401,
    RewardBoxMechanismID = T.RT_6,
    RewardBoxRate = T.RT_7,
    RewardBoxTreasureRandom = T.RT_9,
    RewardToken = T.RT_10
  },
  [1402] = {
    ID = 1402,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = T.RT_12,
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [1403] = {
    ID = 1403,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1404] = {
    ID = 1404,
    RewardBoxMechanismID = T.RT_22,
    RewardBoxRate = T.RT_23,
    RewardBoxTreasureRandom = T.RT_26,
    RewardToken = T.RT_27
  },
  [1405] = {
    ID = 1405,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_30
  },
  [1501] = {
    ID = 1501,
    RewardBoxMechanismID = T.RT_6,
    RewardBoxRate = T.RT_7,
    RewardBoxTreasureRandom = T.RT_9,
    RewardToken = T.RT_10
  },
  [1502] = {
    ID = 1502,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = T.RT_12,
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [1503] = {
    ID = 1503,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1504] = {
    ID = 1504,
    RewardBoxMechanismID = T.RT_22,
    RewardBoxRate = T.RT_23,
    RewardBoxTreasureRandom = T.RT_26,
    RewardToken = T.RT_27
  },
  [1505] = {
    ID = 1505,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_30
  },
  [1601] = {
    ID = 1601,
    RewardBoxMechanismID = T.RT_6,
    RewardBoxRate = T.RT_7,
    RewardBoxTreasureRandom = T.RT_9,
    RewardToken = T.RT_10
  },
  [1602] = {
    ID = 1602,
    RewardBoxMechanismID = T.RT_11,
    RewardBoxRate = T.RT_12,
    RewardBoxTreasureRandom = T.RT_14,
    RewardToken = T.RT_15
  },
  [1603] = {
    ID = 1603,
    RewardBoxMechanismID = T.RT_1,
    RewardBoxRate = T.RT_16,
    RewardBoxTreasureRandom = T.RT_20,
    RewardToken = T.RT_21
  },
  [1604] = {
    ID = 1604,
    RewardBoxMechanismID = T.RT_22,
    RewardBoxRate = T.RT_23,
    RewardBoxTreasureRandom = T.RT_26,
    RewardToken = T.RT_27
  },
  [1605] = {
    ID = 1605,
    RewardBoxMechanismID = T.RT_3,
    RewardBoxRate = T.RT_4,
    RewardBoxTreasureRandom = T.RT_29,
    RewardToken = T.RT_30
  }
})
