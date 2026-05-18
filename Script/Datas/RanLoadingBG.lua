local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RanLoadingBG", {
  [14001] = {
    CurrentVersion = 140,
    LoadingId = 14001,
    Weight = 3000
  },
  [14002] = {
    CurrentVersion = 140,
    LoadingId = 14002,
    Weight = 3000
  },
  [14003] = {
    CurrentVersion = 140,
    LoadingId = 14003,
    Weight = 1000
  },
  [14004] = {
    CurrentVersion = 140,
    LoadingId = 14004,
    Weight = 1000
  },
  [14005] = {
    CurrentVersion = 140,
    LoadingId = 14005,
    Weight = 1000
  },
  [14006] = {
    CurrentVersion = 140,
    LoadingId = 14006,
    Weight = 1000
  },
  [14007] = {
    CurrentVersion = 140,
    LoadingId = 14007,
    Weight = 1000
  }
})
