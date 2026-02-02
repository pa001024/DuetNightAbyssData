local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AbyssLock2Id", {
  [1012] = {
    [1] = 1013
  },
  [1014] = {
    [1] = 1015
  },
  [1111] = {
    [1] = 1112
  },
  [1113] = {
    [1] = 1114
  },
  [1211] = {
    [1] = 1212
  },
  [1213] = {
    [1] = 1214
  },
  [9991] = {
    [1] = 1111,
    [2] = 1113,
    [3] = 1012,
    [4] = 1014,
    [5] = 1211,
    [6] = 1213
  }
})
