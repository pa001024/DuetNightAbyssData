local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomFilter", {
  [1001] = {
    FilterId = 1001,
    ForbidIntensityAdjust = true,
    PPEnumID = 1
  },
  [1002] = {
    FilterId = 1002,
    ForbidIntensityAdjust = true,
    PPEnumID = 2
  },
  [1003] = {
    FilterId = 1003,
    ForbidIntensityAdjust = true,
    PPEnumID = 3
  },
  [1004] = {
    FilterId = 1004,
    ForbidIntensityAdjust = true,
    PPEnumID = 4
  },
  [1005] = {
    FilterId = 1005,
    ForbidIntensityAdjust = true,
    PPEnumID = 5
  },
  [1006] = {
    FilterId = 1006,
    ForbidIntensityAdjust = true,
    PPEnumID = 6
  },
  [1007] = {
    FilterId = 1007,
    ForbidIntensityAdjust = true,
    PPEnumID = 7
  },
  [1008] = {
    FilterId = 1008,
    ForbidIntensityAdjust = true,
    PPEnumID = 8
  },
  [1009] = {
    FilterId = 1009,
    ForbidIntensityAdjust = true,
    PPEnumID = 9
  },
  [1010] = {
    FilterId = 1010,
    ForbidIntensityAdjust = true,
    PPEnumID = 10
  },
  [1011] = {
    FilterId = 1011,
    ForbidIntensityAdjust = true,
    PPEnumID = 11
  },
  [1012] = {
    FilterId = 1012,
    ForbidIntensityAdjust = true,
    PPEnumID = 12
  },
  [1013] = {FilterId = 1013, PPEnumID = 13},
  [1014] = {FilterId = 1014, PPEnumID = 14},
  [1015] = {FilterId = 1015, PPEnumID = 15},
  [1016] = {FilterId = 1016, PPEnumID = 16},
  [1017] = {FilterId = 1017, PPEnumID = 17},
  [1018] = {FilterId = 1018, PPEnumID = 18},
  [1019] = {FilterId = 1019, PPEnumID = 19},
  [1020] = {FilterId = 1020, PPEnumID = 20}
})
