local T = {}
T.RT_1 = {2, 2}
T.RT_2 = {4, 4}
T.RT_3 = {
  T.RT_1,
  T.RT_1,
  T.RT_2
}
T.RT_4 = {1, 3}
T.RT_5 = {3, 3}
T.RT_6 = {5, 4}
T.RT_7 = {
  T.RT_4,
  T.RT_5,
  T.RT_4,
  T.RT_6
}
T.RT_8 = {5, 6}
T.RT_9 = {
  T.RT_4,
  T.RT_5,
  T.RT_4,
  T.RT_8
}
T.RT_10 = {5, 3}
T.RT_11 = {5, 5}
T.RT_12 = {
  T.RT_4,
  T.RT_5,
  T.RT_4,
  T.RT_10,
  T.RT_11
}
T.RT_13 = {5, 12}
T.RT_14 = {
  T.RT_13
}
T.RT_15 = {5, 14}
T.RT_16 = {
  T.RT_15
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExtractionTreasureBag", {
  [1] = {
    BagID = 1,
    Desc = "24",
    Name = "SoloTreasure_Backpack01",
    Price = 0,
    Shape = T.RT_3,
    ShapeType = 1
  },
  [2] = {
    BagID = 2,
    Desc = "35",
    EventUnlockCondition = 10301417,
    Name = "SoloTreasure_Backpack02",
    Price = 800,
    Shape = T.RT_7,
    ShapeType = 0,
    ShopItemId = 10007121
  },
  [3] = {
    BagID = 3,
    Desc = "45",
    EventUnlockCondition = 10301418,
    Name = "SoloTreasure_Backpack03",
    Price = 4000,
    Shape = T.RT_9,
    ShapeType = 0,
    ShopItemId = 10007122
  },
  [4] = {
    BagID = 4,
    Desc = "55",
    EventUnlockCondition = 10301419,
    Name = "SoloTreasure_Backpack04",
    Price = 10000,
    Shape = T.RT_12,
    ShapeType = 2,
    ShopItemId = 10007123
  },
  [5] = {
    BagID = 5,
    Desc = "60",
    EventUnlockCondition = 10301420,
    Name = "SoloTreasure_Backpack05",
    Price = 30000,
    Shape = T.RT_14,
    ShapeType = 3,
    ShopItemId = 10007124
  },
  [6] = {
    BagID = 6,
    Desc = "70",
    EventUnlockCondition = 10301421,
    Name = "SoloTreasure_Backpack06",
    Price = 150000,
    Shape = T.RT_16,
    ShapeType = 3,
    ShopItemId = 10007125
  },
  [11] = {
    BagID = 11,
    Desc = "24",
    EventorPermanent = 1,
    Name = "SoloTreasure_Backpack01",
    Price = 0,
    Shape = T.RT_3,
    ShapeType = 1
  },
  [12] = {
    BagID = 12,
    Desc = "35",
    EventUnlockCondition = 10302717,
    EventorPermanent = 1,
    Name = "SoloTreasure_Backpack02",
    Price = 800,
    Shape = T.RT_7,
    ShapeType = 0,
    ShopItemId = 10012121
  },
  [13] = {
    BagID = 13,
    Desc = "45",
    EventUnlockCondition = 10302718,
    EventorPermanent = 1,
    Name = "SoloTreasure_Backpack03",
    Price = 4000,
    Shape = T.RT_9,
    ShapeType = 0,
    ShopItemId = 10012122
  },
  [14] = {
    BagID = 14,
    Desc = "55",
    EventUnlockCondition = 10302719,
    EventorPermanent = 1,
    Name = "SoloTreasure_Backpack04",
    Price = 10000,
    Shape = T.RT_12,
    ShapeType = 2,
    ShopItemId = 10012123
  },
  [15] = {
    BagID = 15,
    Desc = "60",
    EventUnlockCondition = 10302720,
    EventorPermanent = 1,
    Name = "SoloTreasure_Backpack05",
    Price = 30000,
    Shape = T.RT_14,
    ShapeType = 3,
    ShopItemId = 10012124
  },
  [16] = {
    BagID = 16,
    Desc = "70",
    EventUnlockCondition = 10302721,
    EventorPermanent = 1,
    Name = "SoloTreasure_Backpack06",
    Price = 150000,
    Shape = T.RT_16,
    ShapeType = 3,
    ShopItemId = 10012125
  }
})
