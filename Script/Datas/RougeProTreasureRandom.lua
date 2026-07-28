local T = {}
T.RT_1 = {1}
T.RT_2 = {1, 2}
T.RT_3 = {2, 3}
T.RT_4 = {
  1,
  2,
  3
}
T.RT_5 = {2}
T.RT_6 = {3}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProTreasureRandom", {
  [-1] = {TreasureRandom = -1},
  [1] = {
    RandomType = 1,
    TreasureRandom = 1,
    TreasureRarity = T.RT_1
  },
  [2] = {
    RandomType = 1,
    TreasureRandom = 2,
    TreasureRarity = T.RT_5
  },
  [3] = {
    RandomType = 1,
    TreasureRandom = 3,
    TreasureRarity = T.RT_6
  },
  [4] = {
    RandomType = 1,
    TreasureRandom = 4,
    TreasureRarity = T.RT_2
  },
  [5] = {
    RandomType = 1,
    TreasureRandom = 5,
    TreasureRarity = T.RT_3
  },
  [6] = {
    RandomType = 1,
    TreasureRandom = 6,
    TreasureRarity = T.RT_4
  },
  [7] = {
    RandomType = 2,
    TreasureRandom = 7,
    TreasureRarity = T.RT_1
  },
  [8] = {
    RandomType = 2,
    TreasureRandom = 8,
    TreasureRarity = T.RT_5
  },
  [9] = {
    RandomType = 2,
    TreasureRandom = 9,
    TreasureRarity = T.RT_6
  },
  [10] = {
    RandomType = 2,
    TreasureRandom = 10,
    TreasureRarity = T.RT_2
  },
  [11] = {
    RandomType = 2,
    TreasureRandom = 11,
    TreasureRarity = T.RT_3
  },
  [12] = {
    RandomType = 2,
    TreasureRandom = 12,
    TreasureRarity = T.RT_4
  },
  [1001] = {TreasureRandom = 1001},
  [1002] = {TreasureRandom = 1002},
  [1003] = {TreasureRandom = 1003},
  [1004] = {TreasureRandom = 1004}
})
