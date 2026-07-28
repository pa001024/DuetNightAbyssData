local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionOnline", {
  [101] = {
    ManuaSwitchPlayerNum = 100,
    Priority = 1,
    SubRegionId = 101
  },
  [101101] = {
    DefaultChannelNum = 3,
    HideCNPCOnline = true,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 100208,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_101101",
    RegionChannelSwitchCD = 5,
    SubRegionId = 101101
  },
  [101901] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OfflineCondition = 8012,
    OnlineCondition = 8011,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_101901",
    RegionChannelSwitchCD = 5,
    SubRegionId = 101901
  },
  [104104] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MaxX = 100000,
    MaxY = 100000,
    MaxZ = 10000,
    MinX = -110000,
    MinY = -110000,
    MinZ = -1000,
    MultiPlayerNum = 100,
    NumX = 21,
    NumY = 21,
    NumZ = 5,
    OnlineCondition = 120100,
    Priority = 1,
    RegionChannelName = "UI_REGION_NAME_1041",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104104,
    bOpenAOI = true
  },
  [104106] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 120100,
    Priority = 2,
    RegionChannelName = "UI_SUBREGION_NAME_104106",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104106
  },
  [104108] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 120100,
    Priority = 2,
    RegionChannelName = "UI_SUBREGION_NAME_104108",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104108
  },
  [104109] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 120100,
    Priority = 2,
    RegionChannelName = "UI_SUBREGION_NAME_104109",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104109
  },
  [104110] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 120100,
    Priority = 2,
    RegionChannelName = "UI_SUBREGION_NAME_104110",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104110
  },
  [104501] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_104501",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104501
  },
  [104502] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_104502",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104502
  },
  [104503] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_104503",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104503
  },
  [104504] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_104504",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104504
  },
  [104505] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_104505",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104505
  },
  [104901] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 120100,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_104901",
    RegionChannelSwitchCD = 5,
    SubRegionId = 104901
  },
  [105201] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_105201",
    RegionChannelSwitchCD = 5,
    SubRegionId = 105201
  },
  [105501] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 12010602,
    Priority = 1,
    RegionChannelName = "UI_SUBREGION_NAME_105501",
    RegionChannelSwitchCD = 5,
    SubRegionId = 105501
  },
  [106001] = {
    DefaultChannelNum = 2,
    ManuaSwitchPlayerNum = 300,
    MultiPlayerNum = 200,
    OnlineCondition = 332,
    Priority = 1,
    RegionChannelName = "UI_REGION_NAME_1060",
    RegionChannelSwitchCD = 5,
    SubRegionId = 106001
  },
  [300101] = {
    ManuaSwitchPlayerNum = 50,
    MultiPlayerNum = 50,
    OnlineCondition = 100208,
    Priority = 1,
    RegionChannelName = "UI_REGION_NAME_3001",
    RegionChannelSwitchCD = 5,
    SubRegionId = 300101
  },
  [999701] = {
    ManuaSwitchPlayerNum = 150,
    MaxX = 28400,
    MaxY = 28400,
    MaxZ = 2000,
    MinX = -28400,
    MinY = -28400,
    MinZ = 100,
    MultiPlayerNum = 100,
    NumX = 5,
    NumY = 5,
    NumZ = 1,
    OnlineCondition = 100103,
    Priority = 1,
    RegionChannelSwitchCD = 5,
    SubRegionId = 999701,
    bOpenAOI = true,
    bOpenAOIDebug = true
  },
  [999702] = {
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 100103,
    Priority = 2,
    RegionChannelSwitchCD = 5,
    SubRegionId = 999702
  },
  [999703] = {
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 100103,
    Priority = 3,
    RegionChannelSwitchCD = 5,
    SubRegionId = 999703
  },
  [999704] = {
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 100103,
    Priority = 4,
    RegionChannelSwitchCD = 5,
    SubRegionId = 999704
  },
  [999705] = {
    ManuaSwitchPlayerNum = 150,
    MultiPlayerNum = 100,
    OnlineCondition = 100103,
    Priority = 5,
    RegionChannelSwitchCD = 5,
    SubRegionId = 999705
  }
})
