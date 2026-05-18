local T = {}
T.RT_1 = {
  100101,
  100102,
  100103
}
T.RT_2 = {
  100101,
  "TargetPoint_Balcony_Connect1",
  1
}
T.RT_3 = {
  T.RT_2
}
T.RT_4 = {
  RegionTarget = T.RT_3
}
T.RT_5 = {101101, 101103}
T.RT_6 = {
  101107,
  "TargetPoint_Tavern",
  1
}
T.RT_7 = {
  210101,
  "TargetPoint_HomeBase",
  1
}
T.RT_8 = {
  101105,
  "TargetPoint_OutSiderHome",
  1
}
T.RT_9 = {
  101106,
  "TargetPoint_Sanatorium",
  1
}
T.RT_10 = {
  101701,
  "TargetPoint_Sewer",
  1,
  312
}
T.RT_11 = {
  101702,
  "TargetPoint_SewPoorEnter",
  1
}
T.RT_12 = {
  101301,
  "TargetPoint_Kuangkeng",
  1
}
T.RT_13 = {
  101901,
  "TargetPoint_Theater",
  1
}
T.RT_14 = {
  101110,
  "Cp2LeaveSickPoint",
  1
}
T.RT_15 = {
  101111,
  "LC_EnterFlow",
  1
}
T.RT_16 = {
  101108,
  "TargetPoint_Traff2SecEnter",
  1
}
T.RT_17 = {
  101108,
  "TargetPoint_Traff2SecLeave",
  1,
  321
}
T.RT_18 = {
  T.RT_6,
  T.RT_7,
  T.RT_8,
  T.RT_9,
  T.RT_10,
  T.RT_11,
  T.RT_12,
  T.RT_13,
  T.RT_14,
  T.RT_15,
  T.RT_16,
  T.RT_17
}
T.RT_19 = {
  RegionTarget = T.RT_18
}
T.RT_20 = {
  101301,
  101303,
  101304,
  101305
}
T.RT_21 = {
  101103,
  "TargetPoint_Enter_2_TrafficWay",
  1
}
T.RT_22 = {
  T.RT_21
}
T.RT_23 = {
  RegionTarget = T.RT_22
}
T.RT_24 = {
  101701,
  101702,
  101703
}
T.RT_25 = {
  101101,
  "TargetPoint_Sew1_2_IcelakeCity",
  1
}
T.RT_26 = {
  101101,
  "TargetPoint_Sew2_2_IcelakeCity",
  1
}
T.RT_27 = {
  T.RT_25,
  T.RT_26
}
T.RT_28 = {
  RegionTarget = T.RT_27
}
T.RT_29 = {102101, 102102}
T.RT_30 = {
  104102,
  104103,
  104104,
  104105,
  104106,
  104107,
  104108,
  104109,
  104110
}
T.RT_31 = {
  104901,
  "TargetPoint_EnterQiuOffice",
  1
}
T.RT_32 = {
  T.RT_31
}
T.RT_33 = {
  RegionTarget = T.RT_32
}
T.RT_34 = {
  104501,
  104502,
  104503,
  104504,
  104505,
  104506
}
T.RT_35 = {
  105201,
  "TargetPoint_FromWesToReb",
  1
}
T.RT_36 = {
  105301,
  "TargetPoint_FromTopToTXL",
  1
}
T.RT_37 = {
  105501,
  "TargetPoint_FromInnToYLX",
  1
}
T.RT_38 = {
  105101,
  "TargetPoint_FromTopToZLG1F",
  1
}
T.RT_39 = {
  105101,
  "TargetPoint_FromTopToZLG2F",
  1
}
T.RT_40 = {
  T.RT_35,
  T.RT_36,
  T.RT_37,
  T.RT_38,
  T.RT_39
}
T.RT_41 = {
  RegionTarget = T.RT_40
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionGraph", {
  [100101] = {
    RegionStart = T.RT_1,
    SubRegionStart = 100101,
    SubRegionTarget = {
      RegionTarget = {
        {
          100102,
          "TargetPoint_Village_Connect",
          1
        },
        {
          100103,
          "TargetPoint_Village_Connect",
          1
        }
      }
    }
  },
  [100102] = {
    RegionStart = T.RT_1,
    SubRegionStart = 100102,
    SubRegionTarget = T.RT_4
  },
  [100103] = {
    RegionStart = T.RT_1,
    SubRegionStart = 100103,
    SubRegionTarget = T.RT_4
  },
  [100104] = {SubRegionStart = 100104},
  [101101] = {
    RegionStart = T.RT_5,
    SubRegionStart = 101101,
    SubRegionTarget = T.RT_19
  },
  [101103] = {
    RegionStart = T.RT_5,
    SubRegionStart = 101103,
    SubRegionTarget = T.RT_19
  },
  [101105] = {
    SubRegionStart = 101105,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "TargetPoint_LeaveOutsidersHome",
          1
        }
      }
    }
  },
  [101106] = {
    SubRegionStart = 101106,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "TargetPoint_LeaveSanatorium",
          1
        }
      }
    }
  },
  [101107] = {
    SubRegionStart = 101107,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "TargetPoint_LeaveTavern",
          1
        }
      }
    }
  },
  [101108] = {
    SubRegionStart = 101108,
    SubRegionTarget = {
      RegionTarget = {
        {
          101103,
          "TargetPoint_SecLeave",
          1
        },
        {
          101103,
          "TargetPoint_SecrEnter",
          1
        }
      }
    }
  },
  [101110] = {
    SubRegionStart = 101110,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "SickTelePoint",
          1
        }
      }
    }
  },
  [101111] = {
    SubRegionStart = 101111,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "LC_LeaveFlow",
          1
        }
      }
    }
  },
  [101301] = {
    RegionStart = T.RT_20,
    SubRegionStart = 101301,
    SubRegionTarget = T.RT_23
  },
  [101303] = {
    RegionStart = T.RT_20,
    SubRegionStart = 101303,
    SubRegionTarget = T.RT_23
  },
  [101304] = {
    RegionStart = T.RT_20,
    SubRegionStart = 101304,
    SubRegionTarget = T.RT_23
  },
  [101305] = {
    RegionStart = T.RT_20,
    SubRegionStart = 101305,
    SubRegionTarget = T.RT_23
  },
  [101701] = {
    RegionStart = T.RT_24,
    SubRegionStart = 101701,
    SubRegionTarget = T.RT_28
  },
  [101702] = {
    RegionStart = T.RT_24,
    SubRegionStart = 101702,
    SubRegionTarget = T.RT_28
  },
  [101703] = {
    RegionStart = T.RT_24,
    SubRegionStart = 101703,
    SubRegionTarget = T.RT_28
  },
  [101901] = {
    SubRegionStart = 101901,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "LeavePoint_Theater",
          1
        }
      }
    }
  },
  [102101] = {
    RegionStart = T.RT_29,
    SubRegionStart = 102101
  },
  [102102] = {
    RegionStart = T.RT_29,
    SubRegionStart = 102102
  },
  [104102] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104102,
    SubRegionTarget = T.RT_33
  },
  [104103] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104103,
    SubRegionTarget = T.RT_33
  },
  [104104] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104104,
    SubRegionTarget = T.RT_33
  },
  [104105] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104105,
    SubRegionTarget = T.RT_33
  },
  [104106] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104106,
    SubRegionTarget = T.RT_33
  },
  [104107] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104107,
    SubRegionTarget = T.RT_33
  },
  [104108] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104108,
    SubRegionTarget = T.RT_33
  },
  [104109] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104109,
    SubRegionTarget = T.RT_33
  },
  [104110] = {
    RegionStart = T.RT_30,
    SubRegionStart = 104110,
    SubRegionTarget = T.RT_33
  },
  [104501] = {
    RegionStart = T.RT_34,
    SubRegionStart = 104501,
    SubRegionTarget = T.RT_41
  },
  [104502] = {
    RegionStart = T.RT_34,
    SubRegionStart = 104502,
    SubRegionTarget = T.RT_41
  },
  [104503] = {
    RegionStart = T.RT_34,
    SubRegionStart = 104503,
    SubRegionTarget = T.RT_41
  },
  [104504] = {
    RegionStart = T.RT_34,
    SubRegionStart = 104504,
    SubRegionTarget = T.RT_41
  },
  [104505] = {
    RegionStart = T.RT_34,
    SubRegionStart = 104505,
    SubRegionTarget = T.RT_41
  },
  [104506] = {
    RegionStart = T.RT_34,
    SubRegionStart = 104506,
    SubRegionTarget = T.RT_41
  },
  [104901] = {
    SubRegionStart = 104901,
    SubRegionTarget = {
      RegionTarget = {
        {
          104109,
          "TargetPoint_LeaveQiuOffice",
          1
        }
      }
    }
  },
  [105101] = {
    SubRegionStart = 105101,
    SubRegionTarget = {
      RegionTarget = {
        {
          104506,
          "TargetPoint_FromZLGToTop1F",
          1
        },
        {
          104506,
          "TargetPoint_FromZLGToTop2F",
          1
        }
      }
    }
  },
  [105201] = {
    RegionStart = {105201},
    SubRegionStart = 105201,
    SubRegionTarget = {
      RegionTarget = {
        {
          104502,
          "TargetPoint_FromRebToWes",
          1
        }
      }
    }
  },
  [105301] = {
    RegionStart = {105301},
    SubRegionStart = 105301,
    SubRegionTarget = {
      RegionTarget = {
        {
          104506,
          "TargetPoint_FromTRLMToTop",
          1
        }
      }
    }
  },
  [105501] = {
    RegionStart = {105501},
    SubRegionStart = 105501,
    SubRegionTarget = {
      RegionTarget = {
        {
          104505,
          "TargetPoint_FromYLXToSub",
          1
        }
      }
    }
  },
  [106001] = {
    RegionStart = {106001},
    SubRegionStart = 106001,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "TargetPoint_FromCZtoBH",
          1
        },
        {
          106301,
          "TargetPoint_FromCZtoYLQ",
          1
        },
        {
          106301,
          "TargetPoint_FromCZtoZZZ",
          1
        },
        {
          106301,
          "TargetPoint_FromCZtoZZZEnd",
          1
        },
        {
          106001,
          "TargetPoint_FromCZtoYWS",
          1
        },
        {
          106001,
          "TargetPoint_FromYWStoCZ",
          1
        }
      }
    }
  },
  [106101] = {SubRegionStart = 106101},
  [106201] = {SubRegionStart = 106201},
  [106301] = {
    RegionStart = {106301},
    SubRegionStart = 106301,
    SubRegionTarget = {
      RegionTarget = {
        {
          106001,
          "TargetPoint_FromYLQtoCZ",
          1
        },
        {
          106001,
          "TargetPoint_FromJGQtoCZ",
          1
        },
        {
          106001,
          "TargetPoint_FromZZZtoCZ",
          1
        },
        {
          106001,
          "TargetPoint_FromZZZStoCZ",
          1
        }
      }
    }
  },
  [210101] = {
    SubRegionStart = 210101,
    SubRegionTarget = {
      RegionTarget = {
        {
          101101,
          "TargetPoint_LeaveHomeBase",
          1
        }
      }
    }
  }
})
