local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionOnline", {
  [101] = {Priority = 1, SubRegionId = 101},
  [101101] = {
    HideCNPCOnline = true,
    OnlineCondition = 100208,
    Priority = 1,
    SubRegionId = 101101
  },
  [101901] = {
    OfflineCondition = 8012,
    OnlineCondition = 8011,
    Priority = 1,
    SubRegionId = 101901
  },
  [104104] = {
    MaxX = 100000,
    MaxY = 100000,
    MaxZ = 10000,
    MinX = -110000,
    MinY = -110000,
    MinZ = -1000,
    NumX = 21,
    NumY = 21,
    NumZ = 5,
    OnlineCondition = 120100,
    Priority = 1,
    SubRegionId = 104104,
    bOpenAOI = true
  },
  [104106] = {
    OnlineCondition = 120100,
    Priority = 2,
    SubRegionId = 104106
  },
  [104108] = {
    MultiPlayerNum = 60,
    OnlineCondition = 120100,
    Priority = 2,
    SubRegionId = 104108
  },
  [104109] = {
    OnlineCondition = 120100,
    Priority = 2,
    SubRegionId = 104109
  },
  [104110] = {
    MultiPlayerNum = 60,
    OnlineCondition = 120100,
    Priority = 2,
    SubRegionId = 104110
  },
  [104901] = {
    OnlineCondition = 120100,
    Priority = 1,
    SubRegionId = 104901
  },
  [999701] = {
    MaxX = 28400,
    MaxY = 28400,
    MaxZ = 2000,
    MinX = -28400,
    MinY = -28400,
    MinZ = 100,
    NumX = 5,
    NumY = 5,
    NumZ = 1,
    OnlineCondition = 100103,
    Priority = 1,
    SubRegionId = 999701,
    bOpenAOI = true,
    bOpenAOIDebug = true
  },
  [999702] = {
    OnlineCondition = 100103,
    Priority = 2,
    SubRegionId = 999702
  },
  [999703] = {
    OnlineCondition = 100103,
    Priority = 3,
    SubRegionId = 999703
  },
  [999704] = {
    OnlineCondition = 100103,
    Priority = 4,
    SubRegionId = 999704
  },
  [999705] = {
    OnlineCondition = 100103,
    Priority = 5,
    SubRegionId = 999705
  }
})
