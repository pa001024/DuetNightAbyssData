local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MovementParams", {
  AccTime = {ParamValue = 2, SlideParam = "AccTime"},
  ActiveDeattachSpeedPer = {
    ParamValue = 1,
    SlideParam = "ActiveDeattachSpeedPer"
  },
  CanInteractiveAngle = {
    ParamValue = 45,
    SlideParam = "CanInteractiveAngle"
  },
  CanInteractiveDis = {
    ParamValue = 1000,
    SlideParam = "CanInteractiveDis"
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
  PassiveDeattachSpeedPer = {
    ParamValue = 1.5,
    SlideParam = "PassiveDeattachSpeedPer"
  },
  SideJumpAttachTime = {
    ParamValue = 0.45,
    SlideParam = "SideJumpAttachTime"
  },
  Speed = {ParamValue = 1500, SlideParam = "Speed"},
  TurnTime = {ParamValue = 0.4, SlideParam = "TurnTime"}
})
