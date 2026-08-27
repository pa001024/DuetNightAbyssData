local T = {}
T.RT_1 = {
  4011,
  4012,
  4013
}
T.RT_2 = {
  [3007] = 1
}
T.RT_3 = {
  4021,
  4022,
  4023
}
T.RT_4 = {
  4031,
  4032,
  4033,
  4039
}
T.RT_5 = {
  4041,
  4042,
  4043,
  4049
}
T.RT_6 = {
  4051,
  4052,
  4053,
  4059
}
T.RT_7 = {
  4061,
  4062,
  4063
}
T.RT_8 = {
  4071,
  4072,
  4073,
  4079
}
T.RT_9 = {
  4081,
  4082,
  4083
}
T.RT_10 = {
  4091,
  4092,
  4093
}
T.RT_11 = {
  4111,
  4112,
  4113
}
T.RT_12 = {
  4121,
  4122,
  4123,
  4128
}
T.RT_13 = {
  4131,
  4132,
  4133
}
T.RT_14 = {
  4141,
  4142,
  4143
}
T.RT_15 = {
  4151,
  4152,
  4153
}
T.RT_16 = {
  4161,
  4162,
  4163
}
T.RT_17 = {4171, 4172}
T.RT_18 = {4211}
T.RT_19 = {4221}
T.RT_20 = {4231}
T.RT_21 = {4241}
T.RT_22 = {4251}
T.RT_23 = {4261}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PetBreak", {
  [601] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 601
    }
  },
  [602] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 602
    }
  },
  [603] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 603
    }
  },
  [604] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 604
    }
  },
  [605] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 605
    }
  },
  [4011] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4011
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4011
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4011
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4011
    }
  },
  [4012] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4012
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4012
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4012
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4012
    }
  },
  [4013] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4013
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4013
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_1,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4013
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4013
    }
  },
  [4021] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4021
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4021
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4021
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4021
    }
  },
  [4022] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4022
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4022
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4022
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4022
    }
  },
  [4023] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4023
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4023
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_3,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4023
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4023
    }
  },
  [4031] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4031
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4031
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4031
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4031
    }
  },
  [4032] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4032
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4032
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4032
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4032
    }
  },
  [4033] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4033
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4033
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4033
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4033
    }
  },
  [4039] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4039
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4039
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_4,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4039
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4039
    }
  },
  [4041] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4041
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4041
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4041
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4041
    }
  },
  [4042] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4042
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4042
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4042
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4042
    }
  },
  [4043] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4043
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4043
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4043
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4043
    }
  },
  [4049] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4049
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4049
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_5,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4049
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4049
    }
  },
  [4051] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4051
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4051
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4051
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4051
    }
  },
  [4052] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4052
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4052
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4052
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4052
    }
  },
  [4053] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4053
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4053
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4053
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4053
    }
  },
  [4059] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4059
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4059
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_6,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4059
    },
    [3] = {
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4059
    }
  },
  [4061] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4061
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4061
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4061
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4061
    }
  },
  [4062] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4062
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4062
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4062
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4062
    }
  },
  [4063] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4063
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4063
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_7,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4063
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4063
    }
  },
  [4071] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4071
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4071
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4071
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4071
    }
  },
  [4072] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4072
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4072
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4072
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4072
    }
  },
  [4073] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4073
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4073
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4073
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4073
    }
  },
  [4079] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4079
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4079
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_8,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4079
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4079
    }
  },
  [4081] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4081
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4081
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4081
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4081
    }
  },
  [4082] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4082
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4082
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4082
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4082
    }
  },
  [4083] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4083
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4083
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_9,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4083
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4083
    }
  },
  [4091] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4091
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4091
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4091
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4091
    }
  },
  [4092] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4092
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4092
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4092
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4092
    }
  },
  [4093] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4093
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4093
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_10,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4093
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4093
    }
  },
  [4111] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4111
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4111
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4111
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4111
    }
  },
  [4112] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4112
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4112
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4112
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4112
    }
  },
  [4113] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4113
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4113
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_11,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4113
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4113
    }
  },
  [4121] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4121
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4121
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4121
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4121
    }
  },
  [4122] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4122
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4122
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4122
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4122
    }
  },
  [4123] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4123
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4123
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4123
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4123
    }
  },
  [4128] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4128
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4128
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_12,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4128
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4128
    }
  },
  [4131] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4131
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4131
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4131
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4131
    }
  },
  [4132] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4132
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4132
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4132
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4132
    }
  },
  [4133] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4133
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4133
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_13,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4133
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4133
    }
  },
  [4141] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4141
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4141
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4141
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4141
    }
  },
  [4142] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4142
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4142
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4142
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4142
    }
  },
  [4143] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4143
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4143
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_14,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4143
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4143
    }
  },
  [4151] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4151
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4151
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4151
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4151
    }
  },
  [4152] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4152
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4152
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4152
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4152
    }
  },
  [4153] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4153
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4153
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_15,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4153
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4153
    }
  },
  [4161] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4161
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4161
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4161
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4161
    }
  },
  [4162] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 0,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4162
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4162
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4162
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakNum = 3,
      PetId = 4162
    }
  },
  [4163] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4163
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4163
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_16,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4163
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4163
    }
  },
  [4171] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_17,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4171
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_17,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4171
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_17,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4171
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4171
    }
  },
  [4172] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_17,
      ConsumeResource = T.RT_2,
      EntryNum = 1,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4172
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_17,
      ConsumeResource = T.RT_2,
      EntryNum = 2,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4172
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_17,
      ConsumeResource = T.RT_2,
      EntryNum = 3,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4172
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4172
    }
  },
  [4211] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_18,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4211
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_18,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4211
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_18,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4211
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4211
    }
  },
  [4221] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_19,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4221
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_19,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4221
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_19,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4221
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4221
    }
  },
  [4231] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_20,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4231
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_20,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4231
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_20,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4231
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4231
    }
  },
  [4241] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_21,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4241
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_21,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4241
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_21,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4241
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4241
    }
  },
  [4251] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_22,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4251
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_22,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4251
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_22,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4251
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4251
    }
  },
  [4261] = {
    [0] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_23,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 20,
      PetBreakNum = 0,
      PetId = 4261
    },
    [1] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_23,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 40,
      PetBreakNum = 1,
      PetId = 4261
    },
    [2] = {
      CollectRewardExp = 50,
      ConsumePetId = T.RT_23,
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakLevel = 60,
      PetBreakNum = 2,
      PetId = 4261
    },
    [3] = {
      ConsumeResource = T.RT_2,
      EntryNum = 4,
      PetBreakNum = 3,
      PetId = 4261
    }
  },
  [4911] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4911
    }
  },
  [4912] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4912
    }
  },
  [4913] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4913
    }
  },
  [4921] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4921
    }
  },
  [4922] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4922
    }
  },
  [4923] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4923
    }
  },
  [4931] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4931
    }
  },
  [4932] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4932
    }
  },
  [4933] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4933
    }
  },
  [4934] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4934
    }
  },
  [4935] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4935
    }
  },
  [4936] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4936
    }
  },
  [4941] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4941
    }
  },
  [4942] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4942
    }
  },
  [4943] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4943
    }
  },
  [4944] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 4944
    }
  },
  [510011] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510011
    }
  },
  [510012] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510012
    }
  },
  [510013] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510013
    }
  },
  [510021] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510021
    }
  },
  [510022] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510022
    }
  },
  [510023] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510023
    }
  },
  [510031] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510031
    }
  },
  [510032] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510032
    }
  },
  [510033] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510033
    }
  },
  [510041] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510041
    }
  },
  [510061] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510061
    }
  },
  [510062] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510062
    }
  },
  [510063] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510063
    }
  },
  [510071] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510071
    }
  },
  [510072] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510072
    }
  },
  [510073] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510073
    }
  },
  [510081] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510081
    }
  },
  [510082] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510082
    }
  },
  [510083] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510083
    }
  },
  [510091] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510091
    }
  },
  [510092] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510092
    }
  },
  [510093] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510093
    }
  },
  [510101] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510101
    }
  },
  [510102] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510102
    }
  },
  [510103] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510103
    }
  },
  [510111] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510111
    }
  },
  [510112] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510112
    }
  },
  [510113] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510113
    }
  },
  [510121] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510121
    }
  },
  [510122] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510122
    }
  },
  [510123] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510123
    }
  },
  [510131] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510131
    }
  },
  [510132] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510132
    }
  },
  [510133] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510133
    }
  },
  [510141] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510141
    }
  },
  [510142] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510142
    }
  },
  [510143] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510143
    }
  },
  [510151] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510151
    }
  },
  [510152] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510152
    }
  },
  [510153] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510153
    }
  },
  [510161] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510161
    }
  },
  [510171] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510171
    }
  },
  [510181] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510181
    }
  },
  [510191] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510191
    }
  },
  [510192] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510192
    }
  },
  [510193] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510193
    }
  },
  [510201] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510201
    }
  },
  [510202] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510202
    }
  },
  [510203] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510203
    }
  },
  [510211] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510211
    }
  },
  [510212] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510212
    }
  },
  [510213] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510213
    }
  },
  [510221] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510221
    }
  },
  [510222] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510222
    }
  },
  [510223] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510223
    }
  },
  [510231] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510231
    }
  },
  [510232] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510232
    }
  },
  [510233] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510233
    }
  },
  [510241] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510241
    }
  },
  [510242] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510242
    }
  },
  [510243] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510243
    }
  },
  [510251] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510251
    }
  },
  [510252] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510252
    }
  },
  [510253] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510253
    }
  },
  [510261] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510261
    }
  },
  [510262] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510262
    }
  },
  [510263] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510263
    }
  },
  [510271] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510271
    }
  },
  [510272] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510272
    }
  },
  [510273] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510273
    }
  },
  [510281] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510281
    }
  },
  [510291] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510291
    }
  },
  [510301] = {
    [0] = {
      EntryNum = 1,
      PetBreakNum = 0,
      PetId = 510301
    }
  }
})
