local T = {}
T.RT_1 = {Name = "IQ1002", Value = 1}
T.RT_2 = {
  [1] = T.RT_1
}
T.RT_3 = {Name = "IQ10040401", Value = 1}
T.RT_4 = {Name = "IQ10040424", Value = 1}
T.RT_5 = {Name = "IQ10040424", Value = 0}
T.RT_6 = {Name = "IQ10040506", Value = 1}
T.RT_7 = {
  [1] = T.RT_6,
  [2] = T.RT_5
}
T.RT_8 = {Name = "IQ10040506", Value = 0}
T.RT_9 = {
  [1] = T.RT_4,
  [2] = T.RT_8
}
T.RT_10 = {Name = "AltStart", Value = 1}
T.RT_11 = {
  [1] = T.RT_10
}
T.RT_12 = {
  Name = "FengxiangBoss",
  Value = 1
}
T.RT_13 = {
  Name = "ZhiliuA12020414",
  Value = 1
}
T.RT_14 = {
  [1] = T.RT_13
}
T.RT_15 = {
  Name = "ZhiliuA12020414",
  Value = 0
}
T.RT_16 = {
  [1] = T.RT_15
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestSetVariable", {
  [10020101] = {
    Start = {
      Info = T.RT_2,
      QuestId = 10020101,
      QuestStartorSuccess = "Start"
    },
    Success = {
      Info = T.RT_2,
      QuestId = 10020101,
      QuestStartorSuccess = "Success"
    }
  },
  [10030101] = {
    Start = {
      Info = {
        [1] = {Name = "IQ1003", Value = 1}
      },
      QuestId = 10030101,
      QuestStartorSuccess = "Start"
    }
  },
  [10030301] = {
    Start = {
      Info = {
        [1] = {Name = "IQ100303", Value = 1}
      },
      QuestId = 10030301,
      QuestStartorSuccess = "Start"
    }
  },
  [10030395] = {
    Success = {
      Info = {
        [1] = {Name = "IQ1002", Value = 0}
      },
      QuestId = 10030395,
      QuestStartorSuccess = "Success"
    }
  },
  [10030401] = {
    Start = {
      Info = {
        [1] = {Name = "IQ100304", Value = 0}
      },
      QuestId = 10030401,
      QuestStartorSuccess = "Start"
    }
  },
  [10030498] = {
    Start = {
      Info = {
        [1] = {Name = "IQ10030498", Value = 1}
      },
      QuestId = 10030498,
      QuestStartorSuccess = "Start"
    }
  },
  [10030499] = {
    Start = {
      Info = {
        [1] = {Name = "IQ100304", Value = 1},
        [2] = {Name = "IQ10030498", Value = 0}
      },
      QuestId = 10030499,
      QuestStartorSuccess = "Start"
    }
  },
  [10030510] = {
    Start = {
      Info = {
        [1] = {Name = "IQ100306", Value = 1}
      },
      QuestId = 10030510,
      QuestStartorSuccess = "Start"
    }
  },
  [10030512] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10030601", Value = 1},
        [2] = {Name = "IQ100306", Value = 0}
      },
      QuestId = 10030512,
      QuestStartorSuccess = "Success"
    }
  },
  [10030601] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10030601", Value = 0}
      },
      QuestId = 10030601,
      QuestStartorSuccess = "Success"
    }
  },
  [10040116] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10030702", Value = 1}
      },
      QuestId = 10040116,
      QuestStartorSuccess = "Success"
    }
  },
  [10040204] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040204", Value = 1}
      },
      QuestId = 10040204,
      QuestStartorSuccess = "Success"
    }
  },
  [10040205] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040205", Value = 1}
      },
      QuestId = 10040205,
      QuestStartorSuccess = "Success"
    }
  },
  [10040206] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040205", Value = 0}
      },
      QuestId = 10040206,
      QuestStartorSuccess = "Success"
    }
  },
  [10040207] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040207", Value = 1}
      },
      QuestId = 10040207,
      QuestStartorSuccess = "Success"
    }
  },
  [10040208] = {
    Start = {
      Info = {
        [1] = {Name = "IQ10040208", Value = 1}
      },
      QuestId = 10040208,
      QuestStartorSuccess = "Start"
    }
  },
  [10040209] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040208", Value = 0}
      },
      QuestId = 10040209,
      QuestStartorSuccess = "Success"
    }
  },
  [10040308] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040207", Value = 0}
      },
      QuestId = 10040308,
      QuestStartorSuccess = "Success"
    }
  },
  [10040310] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040204", Value = 0}
      },
      QuestId = 10040310,
      QuestStartorSuccess = "Success"
    }
  },
  [10040312] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040312", Value = 1}
      },
      QuestId = 10040312,
      QuestStartorSuccess = "Success"
    }
  },
  [10040401] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10030702", Value = 0}
      },
      QuestId = 10040401,
      QuestStartorSuccess = "Success"
    }
  },
  [10040402] = {
    Start = {
      Info = {
        [1] = T.RT_3,
        [2] = {Name = "IQ10040402", Value = 1},
        [3] = T.RT_4
      },
      QuestId = 10040402,
      QuestStartorSuccess = "Start"
    }
  },
  [10040403] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040403", Value = 1},
        [2] = {Name = "IQ10040401", Value = 0},
        [3] = {Name = "IQ10040402", Value = 0}
      },
      QuestId = 10040403,
      QuestStartorSuccess = "Success"
    }
  },
  [10040406] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040406", Value = 1},
        [2] = {Name = "IQ10040403", Value = 0},
        [3] = T.RT_5,
        [4] = T.RT_3
      },
      QuestId = 10040406,
      QuestStartorSuccess = "Success"
    }
  },
  [10040424] = {
    Success = {
      Info = {
        [1] = T.RT_4,
        [2] = {Name = "IQ10040406", Value = 0}
      },
      QuestId = 10040424,
      QuestStartorSuccess = "Success"
    }
  },
  [10040504] = {
    Success = {
      Info = T.RT_7,
      QuestId = 10040504,
      QuestStartorSuccess = "Success"
    }
  },
  [10040506] = {
    Success = {
      Info = T.RT_7,
      QuestId = 10040506,
      QuestStartorSuccess = "Success"
    }
  },
  [10040510] = {
    Success = {
      Info = {
        [1] = {Name = "IQ10040510", Value = 1}
      },
      QuestId = 10040510,
      QuestStartorSuccess = "Success"
    }
  },
  [10040512] = {
    Success = {
      Info = T.RT_9,
      QuestId = 10040512,
      QuestStartorSuccess = "Success"
    }
  },
  [10040514] = {
    Success = {
      Info = T.RT_9,
      QuestId = 10040514,
      QuestStartorSuccess = "Success"
    }
  },
  [11010104] = {
    Success = {
      Info = {
        [1] = {
          Name = "LinshiNPC110101",
          Value = 1
        }
      },
      QuestId = 11010104,
      QuestStartorSuccess = "Success"
    }
  },
  [11010306] = {
    Success = {
      Info = {
        [1] = {Name = "IQ110103", Value = 1}
      },
      QuestId = 11010306,
      QuestStartorSuccess = "Success"
    }
  },
  [11010308] = {
    Success = {
      Info = {
        [1] = {
          Name = "LinshiNPC110101",
          Value = 0
        }
      },
      QuestId = 11010308,
      QuestStartorSuccess = "Success"
    }
  },
  [11010501] = {
    Start = {
      Info = {
        [1] = {
          Name = "XimengNPC110105",
          Value = 1
        }
      },
      QuestId = 11010501,
      QuestStartorSuccess = "Start"
    }
  },
  [11010512] = {
    Start = {
      Info = {
        [1] = {
          Name = "NengYuanNPC110105",
          Value = 0
        }
      },
      QuestId = 11010512,
      QuestStartorSuccess = "Start"
    }
  },
  [11010515] = {
    Start = {
      Info = {
        [1] = {
          Name = "ShenWenNPC110105",
          Value = 1
        }
      },
      QuestId = 11010515,
      QuestStartorSuccess = "Start"
    }
  },
  [11010516] = {
    Success = {
      Info = {
        [1] = {
          Name = "ShenWenNPC110105",
          Value = 0
        }
      },
      QuestId = 11010516,
      QuestStartorSuccess = "Success"
    }
  },
  [11010526] = {
    Success = {
      Info = {
        [1] = {
          Name = "NengYuanNPC110105",
          Value = 1
        }
      },
      QuestId = 11010526,
      QuestStartorSuccess = "Success"
    }
  },
  [11010704] = {
    Success = {
      Info = {
        [1] = {Name = "IQ110107", Value = 1}
      },
      QuestId = 11010704,
      QuestStartorSuccess = "Success"
    }
  },
  [11010706] = {
    Success = {
      Info = {
        [1] = {Name = "NPC110108", Value = 1}
      },
      QuestId = 11010706,
      QuestStartorSuccess = "Success"
    }
  },
  [11010804] = {
    Success = {
      Info = {
        [1] = {Name = "NPC110108", Value = 0}
      },
      QuestId = 11010804,
      QuestStartorSuccess = "Success"
    }
  },
  [11010816] = {
    Success = {
      Info = {
        [1] = {
          Name = "XimengNPC110105",
          Value = 0
        }
      },
      QuestId = 11010816,
      QuestStartorSuccess = "Success"
    }
  },
  [12010307] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010307", Value = 1}
      },
      QuestId = 12010307,
      QuestStartorSuccess = "Start"
    }
  },
  [12010313] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010313", Value = 1}
      },
      QuestId = 12010313,
      QuestStartorSuccess = "Start"
    }
  },
  [12010315] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010313", Value = 0}
      },
      QuestId = 12010315,
      QuestStartorSuccess = "Start"
    }
  },
  [12010322] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010307", Value = 0}
      },
      QuestId = 12010322,
      QuestStartorSuccess = "Start"
    }
  },
  [12010502] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010502", Value = 1}
      },
      QuestId = 12010502,
      QuestStartorSuccess = "Start"
    }
  },
  [12010513] = {
    Start = {
      Info = {
        [1] = {
          Name = "IQ12010513_fu",
          Value = 1
        }
      },
      QuestId = 12010513,
      QuestStartorSuccess = "Start"
    }
  },
  [12010516] = {
    Start = {
      Info = {
        [1] = {
          Name = "IQ12010513_fu",
          Value = 0
        }
      },
      QuestId = 12010516,
      QuestStartorSuccess = "Start"
    }
  },
  [12010519] = {
    Success = {
      Info = {
        [1] = {Name = "IQ12010502", Value = 0}
      },
      QuestId = 12010519,
      QuestStartorSuccess = "Success"
    }
  },
  [12010602] = {
    Success = {
      Info = T.RT_11,
      QuestId = 12010602,
      QuestStartorSuccess = "Success"
    }
  },
  [12010603] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010513", Value = 1}
      },
      QuestId = 12010603,
      QuestStartorSuccess = "Start"
    }
  },
  [12010604] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12010513", Value = 0}
      },
      QuestId = 12010604,
      QuestStartorSuccess = "Start"
    }
  },
  [12010606] = {
    Start = {
      Info = {
        [1] = {Name = "AltStart", Value = 0}
      },
      QuestId = 12010606,
      QuestStartorSuccess = "Start"
    },
    Success = {
      Info = T.RT_11,
      QuestId = 12010606,
      QuestStartorSuccess = "Success"
    }
  },
  [12020101] = {
    Start = {
      Info = {
        [1] = {
          Name = "Wuyousheng_First_12020122",
          Value = 1
        },
        [2] = {Name = "IQ120315", Value = 0},
        [3] = T.RT_12
      },
      QuestId = 12020101,
      QuestStartorSuccess = "Start"
    }
  },
  [12020112] = {
    Success = {
      Info = {
        [1] = {
          Name = "Wuyousheng_First_12020122",
          Value = 0
        }
      },
      QuestId = 12020112,
      QuestStartorSuccess = "Success"
    }
  },
  [12020205] = {
    Start = {
      Info = {
        [1] = {
          Name = "Qianxing12020208",
          Value = 1
        }
      },
      QuestId = 12020205,
      QuestStartorSuccess = "Start"
    }
  },
  [12020210] = {
    Start = {
      Info = {
        [1] = {
          Name = "Qianxing12020208",
          Value = 0
        },
        [2] = {
          Name = "Int12020208",
          Value = 1
        }
      },
      QuestId = 12020210,
      QuestStartorSuccess = "Start"
    }
  },
  [12020211] = {
    Start = {
      Info = {
        [1] = {
          Name = "Wuyousheng_Escape_12020212",
          Value = 1
        }
      },
      QuestId = 12020211,
      QuestStartorSuccess = "Start"
    }
  },
  [12020212] = {
    Success = {
      Info = {
        [1] = {
          Name = "Wuyousheng_Escape_12020212",
          Value = 0
        }
      },
      QuestId = 12020212,
      QuestStartorSuccess = "Success"
    }
  },
  [12020401] = {
    Start = {
      Info = {
        [1] = {Name = "IQ12020401", Value = 1}
      },
      QuestId = 12020401,
      QuestStartorSuccess = "Start"
    }
  },
  [12020411] = {
    Success = {
      Info = {
        [1] = {Name = "IQ12020401", Value = 0}
      },
      QuestId = 12020411,
      QuestStartorSuccess = "Success"
    }
  },
  [12020414] = {
    Start = {
      Info = T.RT_14,
      QuestId = 12020414,
      QuestStartorSuccess = "Start"
    },
    Success = {
      Info = T.RT_16,
      QuestId = 12020414,
      QuestStartorSuccess = "Success"
    }
  },
  [12020513] = {
    Start = {
      Info = {
        [1] = {
          Name = "Special_Zhiliu_12020515",
          Value = 1
        }
      },
      QuestId = 12020513,
      QuestStartorSuccess = "Start"
    }
  },
  [12020516] = {
    Start = {
      Info = {
        [1] = {
          Name = "Special_Zhiliu_12020515",
          Value = 0
        }
      },
      QuestId = 12020516,
      QuestStartorSuccess = "Start"
    }
  },
  [12020517] = {
    Success = {
      Info = {
        [1] = {Name = "IQ12020517", Value = 1}
      },
      QuestId = 12020517,
      QuestStartorSuccess = "Success"
    }
  },
  [12020612] = {
    Start = {
      Info = T.RT_14,
      QuestId = 12020612,
      QuestStartorSuccess = "Start"
    },
    Success = {
      Info = T.RT_16,
      QuestId = 12020612,
      QuestStartorSuccess = "Success"
    }
  },
  [12020623] = {
    Success = {
      Info = {
        [1] = {Name = "IQ12020517", Value = 0}
      },
      QuestId = 12020623,
      QuestStartorSuccess = "Success"
    }
  },
  [12030101] = {
    Start = {
      Info = {
        [1] = {
          Name = "FengxiangBaoming",
          Value = 1
        },
        [2] = T.RT_12
      },
      QuestId = 12030101,
      QuestStartorSuccess = "Start"
    }
  },
  [12030202] = {
    Success = {
      Info = {
        [1] = {
          Name = "FengxiangXiaochi",
          Value = 1
        }
      },
      QuestId = 12030202,
      QuestStartorSuccess = "Success"
    }
  },
  [12030703] = {
    Success = {
      Info = {
        [1] = {
          Name = "FengxiangBoss",
          Value = 0
        }
      },
      QuestId = 12030703,
      QuestStartorSuccess = "Success"
    }
  },
  [12030706] = {
    Start = {
      Info = {
        [1] = {
          Name = "IQ12030706_jlc",
          Value = 1
        }
      },
      QuestId = 12030706,
      QuestStartorSuccess = "Start"
    },
    Success = {
      Info = {
        [1] = {Name = "IQ12030706", Value = 1}
      },
      QuestId = 12030706,
      QuestStartorSuccess = "Success"
    }
  },
  [12030707] = {
    Success = {
      Info = {
        [1] = {
          Name = "IQ12030706_jlc",
          Value = 0
        }
      },
      QuestId = 12030707,
      QuestStartorSuccess = "Success"
    }
  },
  [12030801] = {
    Success = {
      Info = {
        [1] = {
          Name = "FengxiangXiaochi",
          Value = 0
        },
        [2] = {
          Name = "FengxiangBaoming",
          Value = 0
        },
        [3] = {Name = "IQ12030706", Value = 0}
      },
      QuestId = 12030801,
      QuestStartorSuccess = "Success"
    }
  },
  [20030303] = {
    Success = {
      Info = {
        [1] = {
          Name = "DaFengBaoXiang200303",
          Value = 1
        }
      },
      QuestId = 20030303,
      QuestStartorSuccess = "Success"
    }
  },
  [20030304] = {
    Success = {
      Info = {
        [1] = {
          Name = "DaFengBaoXiang200303",
          Value = 0
        }
      },
      QuestId = 20030304,
      QuestStartorSuccess = "Success"
    }
  },
  [20031505] = {
    Success = {
      Info = {
        [1] = {Name = "IQ120315", Value = 1}
      },
      QuestId = 20031505,
      QuestStartorSuccess = "Success"
    }
  }
})
