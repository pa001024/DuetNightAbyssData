local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionMap", {
  [1] = {
    AFKSupportScene = "BG01",
    MainRegionMap = true,
    RegionId = 9997,
    RegionMapId = 1
  },
  [100] = {
    AFKSupportScene = "BG06",
    MainRegionMap = true,
    RegionId = 1001,
    RegionMapId = 100
  },
  [200] = {
    AFKSupportScene = "BG06",
    MainRegionMap = true,
    RegionId = 1011,
    RegionMapId = 200,
    RegionMapUnlockCondition = 26
  },
  [201] = {
    AFKSupportScene = "BG06",
    RegionId = 1017,
    RegionMapId = 201,
    RegionMapUnlockCondition = 312
  },
  [202] = {
    AFKSupportScene = "BG06",
    RegionId = 1013,
    RegionMapId = 202,
    RegionMapUnlockCondition = 314
  },
  [203] = {
    AFKSupportScene = "BG06",
    RegionId = 2101,
    RegionMapId = 203,
    RegionMapUnlockCondition = 27
  },
  [204] = {
    AFKSupportScene = "BG06",
    RegionId = 1019,
    RegionMapId = 204,
    RegionMapUnlockCondition = 317
  },
  [205] = {
    AFKSupportScene = "BG07",
    RegionId = 1060,
    RegionMapId = 205,
    RegionMapUnlockCondition = 10040102
  },
  [206] = {
    AFKSupportScene = "BG07",
    RegionId = 1063,
    RegionMapId = 206,
    RegionMapUnlockCondition = 10040102
  },
  [300] = {
    AFKSupportScene = "BG06",
    RegionId = 1021,
    RegionMapId = 300,
    RegionMapUnlockCondition = 11010103,
    UISubRegionType = "EX"
  },
  [400] = {
    AFKSupportScene = "BG04",
    MainRegionMap = true,
    RegionId = 1041,
    RegionMapId = 400,
    RegionMapUnlockCondition = 325
  },
  [401] = {
    AFKSupportScene = "BG04",
    RegionId = 1057,
    RegionMapId = 401,
    RegionMapUnlockCondition = 324
  },
  [500] = {
    AFKSupportScene = "BG04",
    MainRegionMap = true,
    RegionId = 1045,
    RegionMapId = 500,
    RegionMapUnlockCondition = 12020101
  },
  [501] = {
    AFKSupportScene = "BG04",
    RegionId = 1052,
    RegionMapId = 501,
    RegionMapUnlockCondition = 326
  },
  [502] = {
    AFKSupportScene = "BG04",
    RegionId = 1053,
    RegionMapId = 502,
    RegionMapUnlockCondition = 328
  },
  [503] = {
    AFKSupportScene = "BG04",
    RegionId = 1055,
    RegionMapId = 503,
    RegionMapUnlockCondition = 329
  },
  [600] = {
    AFKSupportScene = "BG05",
    MainRegionMap = true,
    RegionId = 1070,
    RegionMapId = 600,
    RegionMapUnlockCondition = 10040502,
    UISubRegionType = "EX"
  },
  [601] = {
    AFKSupportScene = "BG05",
    RegionId = 1071,
    RegionMapId = 601,
    RegionMapUnlockCondition = 11020102,
    UISubRegionType = "EX"
  },
  [602] = {
    AFKSupportScene = "BG05",
    RegionId = 1072,
    RegionMapId = 602,
    RegionMapUnlockCondition = 11020104,
    UISubRegionType = "EX"
  },
  [700] = {RegionId = 1081, RegionMapId = 700},
  [701] = {
    MainRegionMap = true,
    RegionId = 1082,
    RegionMapId = 701
  },
  [702] = {RegionId = 1083, RegionMapId = 702}
})
