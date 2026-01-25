local T = {}
T.RT_1 = {}
T.RT_2 = {
  ShopItemId = 160118,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12116
}
T.RT_3 = {
  ShopItemId = 160317,
  ShopType = "Shop",
  SubTabId = 1606,
  TypeId = 12116
}
T.RT_4 = {
  [1] = T.RT_3,
  [2] = T.RT_2
}
T.RT_5 = {
  ShopItemId = 160111,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12107
}
T.RT_6 = {
  ShopItemId = 160316,
  ShopType = "Shop",
  SubTabId = 1606,
  TypeId = 12107
}
T.RT_7 = {
  [1] = T.RT_6,
  [2] = T.RT_5
}
T.RT_8 = {
  ShopItemId = 160213,
  ShopType = "Shop",
  SubTabId = 1605,
  TypeId = 12056
}
T.RT_9 = {
  ShopItemId = 160212,
  ShopType = "Shop",
  SubTabId = 1605,
  TypeId = 12055
}
T.RT_10 = {
  ShopItemId = 160210,
  ShopType = "Shop",
  SubTabId = 1605,
  TypeId = 12049
}
T.RT_11 = {
  ShopItemId = 160211,
  ShopType = "Shop",
  SubTabId = 1605,
  TypeId = 12050
}
T.RT_12 = {
  [1] = T.RT_11,
  [2] = T.RT_10
}
T.RT_13 = {
  ShopItemId = 160208,
  ShopType = "Shop",
  SubTabId = 1605,
  TypeId = 12047
}
T.RT_14 = {
  ShopItemId = 160209,
  ShopType = "Shop",
  SubTabId = 1605,
  TypeId = 12048
}
T.RT_15 = {
  [1] = T.RT_14,
  [2] = T.RT_13
}
T.RT_16 = {
  ShopItemId = 160125,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12121
}
T.RT_17 = {
  [1] = T.RT_16
}
T.RT_18 = {
  ShopItemId = 160107,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12023
}
T.RT_19 = {
  [1] = T.RT_18
}
T.RT_20 = {
  ShopItemId = 160102,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12102
}
T.RT_21 = {
  ShopItemId = 160103,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12103
}
T.RT_22 = {
  ShopItemId = 160113,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12111
}
T.RT_23 = {
  ShopItemId = 160114,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12112
}
T.RT_24 = {
  ShopItemId = 160108,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12024
}
T.RT_25 = {
  ShopItemId = 160109,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12025
}
T.RT_26 = {
  ShopItemId = 160110,
  ShopType = "Shop",
  SubTabId = 1601,
  TypeId = 12026
}
T.RT_27 = {
  [1] = T.RT_18,
  [2] = T.RT_26,
  [3] = T.RT_25,
  [4] = T.RT_24
}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ShopItem2RewardPack", {
  Char = T.RT_1,
  CharAccessory = {
    [10019] = {
      [1] = T.RT_26
    },
    [10049] = T.RT_17,
    [20001] = T.RT_19,
    [30008] = {
      [1] = T.RT_25
    },
    [30019] = T.RT_17,
    [40007] = {
      [1] = T.RT_24
    },
    [40009] = T.RT_17,
    [80002] = T.RT_17
  },
  Draft = T.RT_1,
  Drop = T.RT_1,
  HeadFrame = T.RT_1,
  HeadSculpture = T.RT_1,
  Mod = T.RT_1,
  Pet = T.RT_1,
  Resource = {
    [101] = {
      [1] = {
        ShopItemId = 160217,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12060
      },
      [2] = {
        ShopItemId = 160216,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12059
      },
      [3] = T.RT_23,
      [4] = T.RT_22,
      [5] = T.RT_21,
      [6] = T.RT_20
    },
    [102] = {
      [1] = {
        ShopItemId = 160207,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12046
      },
      [2] = {
        ShopItemId = 160206,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12045
      }
    },
    [201] = {
      [1] = {
        ShopItemId = 160201,
        ShopType = "Shop",
        SubTabId = 1604,
        TypeId = 12051
      }
    },
    [202] = {
      [1] = {
        ShopItemId = 160202,
        ShopType = "Shop",
        SubTabId = 1604,
        TypeId = 12052
      }
    },
    [207] = {
      [1] = T.RT_9
    },
    [208] = {
      [1] = T.RT_8,
      [2] = T.RT_9
    },
    [209] = {
      [1] = T.RT_8
    },
    [1001] = T.RT_27,
    [1003] = T.RT_27,
    [1004] = {
      [1] = {
        ShopItemId = 160117,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12115
      },
      [2] = {
        ShopItemId = 160116,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12114
      },
      [3] = {
        ShopItemId = 160115,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12113
      },
      [4] = T.RT_23,
      [5] = T.RT_22,
      [6] = {
        ShopItemId = 160112,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12110
      },
      [7] = {
        ShopItemId = 160106,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12106
      },
      [8] = {
        ShopItemId = 160105,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12105
      },
      [9] = {
        ShopItemId = 160104,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12104
      },
      [10] = T.RT_21,
      [11] = T.RT_20,
      [12] = {
        ShopItemId = 160101,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12101
      }
    },
    [20008] = T.RT_15,
    [20013] = {
      [1] = {
        ShopItemId = 160205,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12044
      },
      [2] = {
        ShopItemId = 160204,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12043
      }
    },
    [20023] = T.RT_15,
    [20027] = T.RT_12,
    [20028] = T.RT_12,
    [30102] = {
      [1] = {
        ShopItemId = 160309,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12036
      }
    },
    [30103] = {
      [1] = {
        ShopItemId = 160310,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12037
      }
    },
    [30104] = {
      [1] = {
        ShopItemId = 160311,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12038
      }
    },
    [30105] = {
      [1] = {
        ShopItemId = 160312,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12039
      }
    },
    [30106] = {
      [1] = {
        ShopItemId = 160313,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12040
      }
    },
    [30107] = {
      [1] = {
        ShopItemId = 160314,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12041
      }
    },
    [30109] = {
      [1] = {
        ShopItemId = 160315,
        ShopType = "Shop",
        SubTabId = 1606,
        TypeId = 12042
      }
    },
    [110001] = T.RT_19,
    [110006] = T.RT_17,
    [110014] = {
      [1] = {
        ShopItemId = 160215,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12058
      },
      [2] = {
        ShopItemId = 160214,
        ShopType = "Shop",
        SubTabId = 1605,
        TypeId = 12057
      }
    },
    [1001503] = {
      [1] = {
        ShopItemId = 160124,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12120
      },
      [2] = {
        ShopItemId = 160123,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12120
      },
      [3] = {
        ShopItemId = 160122,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12120
      }
    },
    [1002401] = {
      [1] = {
        ShopItemId = 160121,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12119
      },
      [2] = {
        ShopItemId = 160120,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12119
      },
      [3] = {
        ShopItemId = 160119,
        ShopType = "Shop",
        SubTabId = 1601,
        TypeId = 12119
      }
    }
  },
  Reward = T.RT_1,
  Skin = {
    [16010010] = T.RT_7,
    [16010011] = T.RT_4,
    [16010110] = T.RT_7,
    [16010111] = T.RT_4
  },
  Title = T.RT_1,
  TitleFrame = T.RT_1,
  Walnut = T.RT_1,
  Weapon = T.RT_1,
  WeaponAccessory = T.RT_1,
  WeaponSkin = T.RT_1
})
