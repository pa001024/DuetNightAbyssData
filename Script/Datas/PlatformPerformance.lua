local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PlatformPerformance", {
  Android = {
    High = 1004,
    ID = "Android",
    Low = 1002,
    Medium = 1003,
    VeryHigh = 1005,
    VeryLow = 1001
  },
  IOS = {
    High = 1004,
    ID = "IOS",
    Low = 1002,
    Medium = 1003,
    VeryHigh = 1005,
    VeryLow = 1001
  },
  OpenHarmony = {
    High = 1004,
    ID = "OpenHarmony",
    Low = 1002,
    Medium = 1003,
    VeryHigh = 1005,
    VeryLow = 1001
  },
  Windows = {
    High = 1014,
    ID = "Windows",
    Low = 1012,
    Medium = 1013,
    VeryHigh = 1015,
    VeryLow = 1011
  }
})
