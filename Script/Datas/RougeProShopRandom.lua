local T = {}
T.RT_1 = {4, 5}
T.RT_2 = {
  1,
  2,
  3
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougeProShopRandom", {
  [1] = {
    Rarity = {1, 2},
    ShopRandom = 1,
    Treasure = {3, 4}
  },
  [2] = {
    Rarity = T.RT_2,
    ShopRandom = 2,
    Treasure = T.RT_1
  },
  [3] = {
    Rarity = T.RT_2,
    ShopRandom = 3,
    Treasure = {5, 7}
  },
  [101] = {
    Rarity = {2},
    ShopRandom = 101,
    Treasure = T.RT_1
  },
  [102] = {
    Rarity = {2, 3},
    ShopRandom = 102,
    Treasure = {5, 6}
  },
  [103] = {
    Rarity = {3},
    ShopRandom = 103,
    Treasure = T.RT_1
  }
})
