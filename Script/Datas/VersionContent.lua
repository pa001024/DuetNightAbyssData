local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("VersionContent", {
  [130] = {
    EndTime = LocalTimeProxy(1780344000),
    RewardViewId = 100000130,
    StartTime = LocalTimeProxy(1772676000),
    Version = 130,
    VersionName = "EventVersionName_130"
  },
  [140] = {
    EndTime = LocalTimeProxy(1785182400),
    RewardViewId = 100000140,
    StartTime = LocalTimeProxy(1780344001),
    Version = 140,
    VersionName = "EventVersionName_140"
  }
})
