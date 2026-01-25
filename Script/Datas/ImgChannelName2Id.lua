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
  hero = {
    [1] = 240,
    [2] = 18,
    [3] = 305,
    [4] = 171,
    [5] = 160,
    [6] = 56,
    [7] = 237,
    [8] = 295
  },
  lenovo = {
    [1] = 297
  },
  oppo = {
    [1] = 303
  },
  wegame = {
    [1] = 286
  }
})
