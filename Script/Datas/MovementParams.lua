local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MovementParams", {
  AccTime = {ParamValue = 2, SlideParam = "AccTime"},
  Acceleration = {
    ParamValue = 1000,
    SlideParam = "Acceleration"
  },
  AccelerationUnitTime = {
    ParamValue = 1,
    SlideParam = "AccelerationUnitTime"
  },
  ActiveDeattachSpeedPer = {
    ParamValue = 1,
    SlideParam = "ActiveDeattachSpeedPer"
  },
  CameraMaxPitch = {
    ParamValue = 30,
    SlideParam = "CameraMaxPitch"
  },
  CameraMaxYaw = {
    ParamValue = 30,
    SlideParam = "CameraMaxYaw"
  },
  CameraMinPitch = {
    ParamValue = -30,
    SlideParam = "CameraMinPitch"
  },
  CameraMinYaw = {
    ParamValue = -30,
    SlideParam = "CameraMinYaw"
  },
  CanInteractiveAngle = {
    ParamValue = 45,
    SlideParam = "CanInteractiveAngle"
  },
  CanInteractiveDis = {
    ParamValue = 2000,
    SlideParam = "CanInteractiveDis"
  },
  ClickGameInterval = {
    ParamValue = 0.5,
    SlideParam = "ClickGameInterval"
  },
  ClickGameMaxCount = {
    ParamValue = 30,
    SlideParam = "ClickGameMaxCount"
  },
  ClickGameMinCount = {
    ParamValue = 1,
    SlideParam = "ClickGameMinCount"
  },
  Deceleration = {
    ParamValue = -1000,
    SlideParam = "Deceleration"
  },
  FlySpeed = {ParamValue = 3000, SlideParam = "FlySpeed"},
  FlySpeedAccTime = {
    ParamValue = 0.3,
    SlideParam = "FlySpeedAccTime"
  },
  IsLockCamera = {
    ParamValue = 1,
    SlideParam = "IsLockCamera"
  },
  SideJumpAttachTime = {
    ParamValue = 0.45,
    SlideParam = "SideJumpAttachTime"
  },
  Speed = {ParamValue = 1750, SlideParam = "Speed"},
  TurnTime = {ParamValue = 1, SlideParam = "TurnTime"}
})
