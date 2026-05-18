local T = {}
T.RT_1 = {
  [1] = 4
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TargetId2TheaterTask", {
  [10301] = {
    [1] = 6
  },
  [50122] = T.RT_1,
  [50123] = T.RT_1,
  [50124] = T.RT_1,
  [50125] = T.RT_1,
  [50126] = T.RT_1,
  [50127] = T.RT_1,
  [50128] = T.RT_1,
  [50129] = T.RT_1,
  [50130] = T.RT_1,
  [50131] = T.RT_1,
  [50132] = T.RT_1,
  [50133] = T.RT_1,
  [50135] = T.RT_1,
  [50136] = T.RT_1,
  [50137] = T.RT_1,
  [50138] = T.RT_1,
  [50139] = T.RT_1,
  [1010501] = {
    [1] = 9
  },
  [1080201] = {
    [1] = 1
  },
  [1400101] = {
    [1] = 2
  },
  [1900101] = {
    [1] = 7
  },
  [2100101] = {
    [1] = 5
  },
  [10102901] = {
    [1] = 8
  },
  [10102902] = {
    [1] = 10
  },
  [10102903] = {
    [1] = 11
  },
  [10102904] = {
    [1] = 12
  },
  [10102905] = {
    [1] = 3
  },
  [10102906] = {
    [1] = 13
  }
})
