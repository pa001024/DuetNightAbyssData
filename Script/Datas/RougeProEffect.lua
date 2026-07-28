local T = {}
T.RT_1 = {
  [1] = 0.8
}
T.RT_2 = {
  [1] = 300
}
T.RT_3 = {
  [1] = 0.5
}
T.RT_4 = {
  [1] = 1003
}
T.RT_5 = {
  [1] = 2
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProEffect", {
  [1] = {
    BuffType = 1,
    Id = 1,
    Name = "RandomChoice"
  },
  [2] = {
    BuffType = 1,
    Id = 2,
    Name = "RecoverTimeAdd",
    Param = T.RT_5
  },
  [3] = {
    BuffType = 1,
    Id = 3,
    Name = "ShopDiscount",
    Param = T.RT_1
  },
  [4] = {
    BuffType = 1,
    Id = 4,
    Name = "GetToken",
    Param = T.RT_2
  },
  [5] = {
    BuffType = 1,
    Id = 5,
    Name = "GetTreasure",
    Param = {
      [1] = 4
    }
  },
  [6] = {
    BuffType = 1,
    Id = 6,
    Name = "ChoiceNumber",
    Param = T.RT_5
  },
  [7] = {
    BuffType = 1,
    Id = 7,
    Name = "BlockEffect",
    Param = {
      [1] = {6}
    }
  },
  [8] = {
    BuffType = 1,
    Id = 8,
    Name = "ShopDiscount",
    Param = T.RT_3
  },
  [9] = {
    BuffType = 1,
    Id = 9,
    Name = "BlockEffect",
    Param = {
      [1] = {8}
    }
  },
  [10] = {
    BuffType = 1,
    Id = 10,
    Name = "ShopDiscount",
    Param = T.RT_1
  },
  [11] = {
    BuffType = 1,
    Id = 11,
    Name = "GetToken",
    Param = T.RT_2
  },
  [12] = {
    BuffType = 1,
    Id = 12,
    Name = "ShopDiscount",
    Param = T.RT_3
  },
  [13] = {
    BuffType = 1,
    Id = 13,
    Name = "BlockEffect",
    Param = {
      [1] = {10}
    }
  },
  [14] = {
    BuffType = 1,
    Id = 14,
    Name = "ShopDiscount",
    Param = T.RT_1
  },
  [15] = {
    BuffType = 1,
    Id = 15,
    Name = "ActiveStaticPoint",
    Param = {
      OwnerView = "true",
      Point = 1703,
      Tag = "Hunter"
    }
  },
  [16] = {
    BuffType = 1,
    Id = 16,
    Name = "ActiveMonsterSP",
    Param = {
      MonsterSpId = 8,
      OwnerView = "true",
      Tag = "Hunter"
    }
  },
  [17] = {
    BuffType = 1,
    Id = 17,
    Name = "GetTokenByTime",
    Param = {
      [1] = 5,
      [2] = 3
    }
  },
  [18] = {
    BuffType = 1,
    Id = 18,
    Name = "CreateCowEvent",
    Param = {
      MonsterSpId = 111,
      PointRandomList = {
        1,
        2,
        3,
        4
      }
    }
  },
  [19] = {
    BuffType = 1,
    Id = 19,
    Name = "GetModEveryOne",
    Param = T.RT_4
  },
  [20] = {
    BuffType = 1,
    Id = 20,
    Name = "AddBuff",
    Param = T.RT_4
  },
  [999] = {Id = 999}
})
