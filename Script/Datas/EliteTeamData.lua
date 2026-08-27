local T = {}
T.RT_1 = {0, 0}
T.RT_2 = {
  OffsetXY = T.RT_1
}
T.RT_3 = {
  [1] = T.RT_2
}
T.RT_4 = {
  HalfHeight = 90,
  MaxLength = 200,
  MaxWidth = 100,
  Radius = 45,
  StepHeight = 50,
  WalkableFloorAngle = 60
}
T.RT_5 = {260, 0}
T.RT_6 = {
  OffsetXY = T.RT_5
}
T.RT_7 = {
  [1] = T.RT_6
}
T.RT_8 = {200, -300}
T.RT_9 = {
  OffsetXY = T.RT_8
}
T.RT_10 = {500, 0}
T.RT_11 = {
  OffsetXY = T.RT_10
}
T.RT_12 = {300, 0}
T.RT_13 = {
  OffsetXY = T.RT_12
}
T.RT_14 = {200, 0}
T.RT_15 = {
  OffsetXY = T.RT_14
}
T.RT_16 = {
  [1] = T.RT_15
}
T.RT_17 = {
  0,
  0,
  0
}
T.RT_18 = {
  OffsetXY = T.RT_17
}
T.RT_19 = {
  Interval = 30,
  PreFormationType = "Circle",
  Radius = 200,
  Random = 1
}
T.RT_20 = {0, 300}
T.RT_21 = {
  OffsetXY = T.RT_20
}
T.RT_22 = {0, -300}
T.RT_23 = {
  OffsetXY = T.RT_22
}
T.RT_24 = {
  [1] = T.RT_18
}
T.RT_25 = {0, -500}
T.RT_26 = {
  OffsetXY = T.RT_25
}
T.RT_27 = {0, 500}
T.RT_28 = {
  OffsetXY = T.RT_27
}
T.RT_29 = {-500, 0}
T.RT_30 = {
  OffsetXY = T.RT_29
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("EliteTeamData", {
  [1] = {
    EliteArgs = {
      1500,
      500,
      7,
      1
    },
    EliteId = 1,
    Offsets = {
      [1] = {
        OffsetXY = {200, 300}
      },
      [2] = {
        OffsetXY = {-200, 300}
      },
      [3] = {
        OffsetXY = {400, 150}
      },
      [4] = {
        OffsetXY = {-400, 150}
      },
      [5] = {
        OffsetXY = {600, 450}
      },
      [6] = {
        OffsetXY = {-600, 450}
      },
      [7] = {
        OffsetXY = {0, 400}
      }
    },
    TeamType = 1
  },
  [2] = {
    EliteId = 2,
    Offsets = T.RT_3
  },
  [10101] = {
    EliteId = 10101,
    Offsets = {
      [1] = {
        OffsetXY = {150, 150}
      }
    }
  },
  [210101] = {
    EliteId = 210101,
    LocationCheckParam = T.RT_4,
    Offsets = T.RT_7
  },
  [210201] = {
    EliteId = 210201,
    LocationCheckParam = T.RT_4,
    OffsetInherentState = 1,
    Offsets = {
      [1] = {
        OffsetXY = {350, 0}
      },
      [2] = T.RT_9,
      [3] = {
        OffsetXY = {50, 250}
      },
      [4] = {
        OffsetXY = {250, -150}
      },
      [5] = {
        OffsetXY = {200, 150}
      },
      [6] = {
        OffsetXY = {150, -250}
      },
      [7] = {
        OffsetXY = {200, 250}
      },
      [8] = {
        OffsetXY = {400, 0}
      }
    }
  },
  [210202] = {
    EliteId = 210202,
    LocationCheckParam = T.RT_4,
    OffsetInherentState = 1,
    Offsets = {
      [1] = {
        OffsetXY = {350, 300}
      },
      [2] = {
        OffsetXY = {350, -300}
      }
    }
  },
  [210203] = {
    EliteId = 210203,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = T.RT_11
    }
  },
  [210204] = {
    EliteId = 210204,
    LocationCheckParam = T.RT_4,
    Offsets = T.RT_7
  },
  [220101] = {
    EliteId = 220101,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = T.RT_13
    }
  },
  [220102] = {
    EliteId = 220102,
    Offsets = {
      [1] = {
        OffsetXY = {680, 400}
      },
      [2] = {
        OffsetXY = {0, 800}
      },
      [3] = {
        OffsetXY = {-680, 400}
      },
      [4] = {
        OffsetXY = {-680, -400}
      },
      [5] = {
        OffsetXY = {0, -800}
      },
      [6] = {
        OffsetXY = {680, -400}
      }
    }
  },
  [220103] = {
    EliteId = 220103,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = {
        OffsetXY = {-300, 0}
      }
    }
  },
  [230101] = {
    EliteId = 230101,
    Offsets = T.RT_3
  },
  [230102] = {
    EliteId = 230102,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = T.RT_9,
      [2] = {
        OffsetXY = {550, 50}
      },
      [3] = {
        OffsetXY = {700, -300}
      },
      [4] = {
        OffsetXY = {1000, 50}
      }
    }
  },
  [230103] = {
    EliteId = 230103,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = {
        OffsetXY = {300, -50}
      },
      [2] = {
        OffsetXY = {400, 300}
      },
      [3] = {
        OffsetXY = {800, -100}
      },
      [4] = {
        OffsetXY = {1150, 300}
      }
    }
  },
  [230104] = {
    EliteId = 230104,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = {
        OffsetXY = {150, 350}
      },
      [2] = {
        OffsetXY = {450, -400}
      },
      [3] = {
        OffsetXY = {800, 350}
      },
      [4] = {
        OffsetXY = {1050, -300}
      }
    }
  },
  [240101] = {
    EliteId = 240101,
    LocationCheckParam = T.RT_4,
    Offsets = T.RT_7
  },
  [410101] = {
    EliteId = 410101,
    Offsets = {
      [1] = {
        OffsetXY = {-50, 0}
      }
    }
  },
  [410201] = {
    EliteId = 410201,
    Offsets = {
      [1] = {
        OffsetXY = {
          0,
          11,
          -23
        }
      }
    }
  },
  [430101] = {
    EliteId = 430101,
    Offsets = T.RT_16
  },
  [510101] = {
    EliteId = 510101,
    Offsets = {
      [1] = {
        OffsetXY = {0, 95}
      }
    }
  },
  [510102] = {EliteId = 510102},
  [540201] = {
    EliteId = 540201,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = {
        OffsetXY = {560, 0}
      }
    }
  },
  [600501] = {
    EliteId = 600501,
    SummonPresetShape = T.RT_19
  },
  [600502] = {
    EliteId = 600502,
    SummonPresetShape = T.RT_19
  },
  [601301] = {
    EliteId = 601301,
    Offsets = {
      [1] = T.RT_13,
      [2] = T.RT_21,
      [3] = T.RT_23
    }
  },
  [700201] = {
    EliteId = 700201,
    Offsets = {
      [1] = {
        OffsetXY = {-200, 200}
      }
    }
  },
  [700202] = {
    EliteId = 700202,
    Offsets = T.RT_16
  },
  [700801] = {
    EliteId = 700801,
    Offsets = {
      [1] = {
        OffsetXY = {
          100,
          50,
          400
        }
      }
    }
  },
  [800201] = {
    EliteId = 800201,
    Offsets = {
      [1] = T.RT_21,
      [2] = T.RT_23
    }
  },
  [800202] = {
    EliteId = 800202,
    Offsets = {
      [1] = T.RT_21,
      [2] = T.RT_23,
      [3] = {
        OffsetXY = {0, 600}
      },
      [4] = {
        OffsetXY = {0, -600}
      }
    }
  },
  [850061] = {
    EliteId = 850061,
    Offsets = T.RT_24
  },
  [850081] = {
    EliteId = 850081,
    Offsets = T.RT_24
  },
  [850401] = {
    EliteId = 850401,
    Offsets = {
      [1] = T.RT_26
    }
  },
  [850402] = {
    EliteId = 850402,
    Offsets = {
      [1] = T.RT_28
    }
  },
  [850403] = {
    EliteId = 850403,
    Offsets = {
      [1] = {
        OffsetXY = {0, -1000}
      }
    }
  },
  [850404] = {
    EliteId = 850404,
    Offsets = {
      [1] = {
        OffsetXY = {0, 1000}
      }
    }
  },
  [850501] = {
    EliteId = 850501,
    Offsets = {
      [1] = {
        OffsetXY = {0, 650}
      },
      [2] = {
        OffsetXY = {0, -650}
      }
    }
  },
  [850502] = {
    EliteId = 850502,
    Offsets = {
      [1] = {
        OffsetXY = {450, 600}
      },
      [2] = {
        OffsetXY = {450, -600}
      },
      [3] = {
        OffsetXY = {-450, 600}
      },
      [4] = {
        OffsetXY = {-450, -600}
      }
    }
  },
  [850901] = {
    EliteId = 850901,
    Offsets = T.RT_24
  },
  [851001] = {
    EliteId = 851001,
    Offsets = {
      [1] = {
        OffsetXY = {400, 500}
      },
      [2] = {
        OffsetXY = {400, -500}
      }
    }
  },
  [851002] = {
    EliteId = 851002,
    Offsets = {
      [1] = T.RT_28,
      [2] = T.RT_26,
      [3] = T.RT_11,
      [4] = T.RT_30
    }
  },
  [851801] = {
    EliteId = 851801,
    Offsets = {
      [1] = {
        OffsetXY = {100, 600}
      },
      [2] = {
        OffsetXY = {100, -600}
      },
      [3] = {
        OffsetXY = {700, 0}
      },
      [4] = T.RT_30,
      [5] = {
        OffsetXY = {524, 424}
      },
      [6] = {
        OffsetXY = {524, -424}
      },
      [7] = {
        OffsetXY = {-324, 424}
      },
      [8] = {
        OffsetXY = {-324, -424}
      }
    }
  },
  [852101] = {
    EliteId = 852101,
    Offsets = {
      [1] = {
        OffsetXY = {520, 170}
      },
      [2] = {
        OffsetXY = {230, 150}
      },
      [3] = {
        OffsetXY = {230, -200}
      },
      [4] = {
        OffsetXY = {490, -160}
      },
      [5] = {
        OffsetXY = {40, 40}
      }
    }
  },
  [852301] = {
    EliteId = 852301,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = {
        OffsetXY = {380, 0}
      },
      [2] = {
        OffsetXY = {-200, 346}
      },
      [3] = {
        OffsetXY = {-200, -346}
      }
    }
  },
  [900301] = {
    EliteId = 900301,
    Offsets = T.RT_16
  },
  [900601] = {
    EliteId = 900601,
    LocationCheckParam = T.RT_4,
    Offsets = {
      [1] = {
        OffsetXY = {20, 0}
      }
    }
  },
  [900602] = {
    EliteId = 900602,
    LocationCheckParam = T.RT_4,
    SummonPresetShape = {
      Interval = 72,
      PreFormationType = "Circle",
      Radius = 500,
      Random = 0
    }
  },
  [6000005] = {
    EliteId = 6000005,
    SummonPresetShape = {
      Interval = 120,
      PreFormationType = "Circle",
      Radius = 700,
      Random = 0
    }
  },
  [6000009] = {
    EliteId = 6000009,
    Offsets = {
      [1] = T.RT_18,
      [2] = {
        OffsetXY = {
          1500,
          0,
          0
        }
      },
      [3] = {
        OffsetXY = {
          -750,
          1500,
          0
        }
      },
      [4] = {
        OffsetXY = {
          -750,
          -1500,
          0
        }
      }
    }
  },
  [6000012] = {
    EliteId = 6000012,
    SummonPresetShape = {
      Interval = 60,
      PreFormationType = "Circle",
      Radius = 1200,
      Random = 0
    }
  },
  [6000014] = {
    EliteId = 6000014,
    Offsets = {
      [1] = {
        OffsetXY = {
          0,
          500,
          0
        }
      },
      [2] = {
        OffsetXY = {
          0,
          -500,
          0
        }
      }
    }
  },
  [10104900] = {
    EliteId = 10104900,
    SummonPresetShape = {
      Interval = 30,
      PreFormationType = "Circle",
      Radius = 150,
      Random = 1
    }
  }
})
