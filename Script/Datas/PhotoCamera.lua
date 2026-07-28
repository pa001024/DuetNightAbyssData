local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PhotoCamera", {
  [1] = {
    FocalLength = 15,
    IsLockHiddenRole = true,
    IsLockPause = true,
    IsSetParams = true,
    IsStartHiddenRole = true,
    IsStartPause = true,
    LookAtTarget = "BP_PhotoTarget_400122",
    PhotoCameraId = 1,
    StartPos = "(X=-3214.376953,Y=11569.043945,Z=-1987.442505)"
  }
})
