local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ImgChannelName2Id", {
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
    [2] = 171,
    [3] = 315,
    [4] = 18,
    [5] = 237,
    [6] = 56,
    [7] = 305,
    [8] = 295,
    [9] = 240
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
