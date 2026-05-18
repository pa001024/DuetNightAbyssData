local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GatherArea", {
  [1] = {
    AreaId = 1,
    AreaLocation = {-2511, -2121},
    AreaRotYaw = 0,
    AreaScale = {60, 60},
    FloorId = 0,
    GatherAreaTeleportId = 1011,
    Shape = 2,
    SubRegion = 101101,
    UnlockConditionId = 100208
  },
  [2] = {
    AreaId = 2,
    AreaLocation = {33046, -4278},
    AreaRotYaw = 0,
    AreaScale = {80, 80},
    FloorId = 0,
    GatherAreaTeleportId = 1102,
    Shape = 2,
    SubRegion = 104110,
    UnlockConditionId = 120100
  },
  [3] = {
    AreaId = 3,
    AreaLocation = {31555, -45164},
    AreaRotYaw = 0,
    AreaScale = {160, 170},
    FloorId = 0,
    GatherAreaTeleportId = 1206,
    Shape = 1,
    SubRegion = 104503,
    UnlockConditionId = 12010602
  },
  [4] = {
    AreaId = 4,
    AreaLocation = {-8500, 0},
    AreaRotYaw = 0,
    AreaScale = {120, 100},
    FloorId = 0,
    GatherAreaTeleportId = 1600,
    Shape = 1,
    SubRegion = 106001,
    UnlockConditionId = 332
  }
})
