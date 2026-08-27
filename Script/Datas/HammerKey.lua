local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HammerKey", {
  [101] = {
    Combo = {
      [1] = "D",
      [2] = "W",
      [3] = "D,W"
    },
    KeyComboID = 101
  },
  [102] = {
    Combo = {
      [1] = "A,W",
      [2] = "W,D",
      [3] = "A,D"
    },
    KeyComboID = 102
  },
  [801] = {
    Combo = {
      [1] = "W",
      [2] = "A",
      [3] = "A,W"
    },
    KeyComboID = 801
  },
  [802] = {
    Combo = {
      [1] = "A",
      [2] = "D",
      [3] = "W",
      [4] = "D,W",
      [5] = "A,W"
    },
    KeyComboID = 802
  },
  [803] = {
    Combo = {
      [1] = "D",
      [2] = "A,W",
      [3] = "W,D",
      [4] = "A,W",
      [5] = "A,W"
    },
    KeyComboID = 803
  },
  [804] = {
    Combo = {
      [1] = "W",
      [2] = "W",
      [3] = "D,W",
      [4] = "A,W",
      [5] = "D,W"
    },
    KeyComboID = 804
  }
})
