local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HammerKey", {
  [101] = {
    Combo = {
      [1] = "A",
      [2] = "W",
      [3] = "W,D"
    },
    KeyComboID = 101
  }
})
