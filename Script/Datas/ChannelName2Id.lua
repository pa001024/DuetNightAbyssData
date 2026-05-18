local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ChannelName2Id", {
  bilibili = {
    [1] = 46,
    [2] = 269
  },
  cloud = {
    [1] = 314,
    [2] = 301,
    [3] = 300
  },
  harmony = {
    [1] = 270
  },
  hero = {
    [1] = 160,
    [2] = 315,
    [3] = 305,
    [4] = 171,
    [5] = 18,
    [6] = 237,
    [7] = 272,
    [8] = 56,
    [9] = 181,
    [10] = 295,
    [11] = 268,
    [12] = 240,
    [13] = 197
  },
  honor = {
    [1] = 255
  },
  huawei = {
    [1] = 11
  },
  lenovo = {
    [1] = 297
  },
  oppo = {
    [1] = 303
  },
  vivo = {
    [1] = 2
  },
  wegame = {
    [1] = 286
  },
  xiaomi = {
    [1] = 23
  }
})
