local T = {}
T.RT_1 = {"10"}
T.RT_2 = {"3"}
T.RT_3 = {"1"}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BattleCamera", {
  CameraFadeAngleEnd = {
    ParamentName = "CameraFadeAngleEnd",
    ParamentValue = T.RT_1
  },
  CameraFadeAngleStart = {
    ParamentName = "CameraFadeAngleStart",
    ParamentValue = {"30"}
  },
  CameraInputResumeDelay = {
    ParamentName = "CameraInputResumeDelay",
    ParamentValue = {"0.4"}
  },
  CameraPitchLimitMax = {
    ParamentName = "CameraPitchLimitMax",
    ParamentValue = {"89.9"}
  },
  CameraPitchLimitMin = {
    ParamentName = "CameraPitchLimitMin",
    ParamentValue = {"-89.9"}
  },
  EnterCollisionSpeed = {
    ParamentName = "EnterCollisionSpeed",
    ParamentValue = T.RT_1
  },
  FrontBackDeadZone = {
    ParamentName = "FrontBackDeadZone",
    ParamentValue = {"0.9"}
  },
  LeaveCollisionSpeed = {
    ParamentName = "LeaveCollisionSpeed",
    ParamentValue = {"2"}
  },
  ResetPitchMaxSpeed = {
    ParamentName = "ResetPitchMaxSpeed",
    ParamentValue = T.RT_2
  },
  ResetSocketOffsetMaxSpeed = {
    ParamentName = "ResetSocketOffsetMaxSpeed",
    ParamentValue = {"4"}
  },
  ResetSpringArmMaxSpeed = {
    ParamentName = "ResetSpringArmMaxSpeed",
    ParamentValue = T.RT_2
  },
  StrafeInputDeadZone = {
    ParamentName = "StrafeInputDeadZone",
    ParamentValue = {"0.05"}
  },
  StrafeInputHoldTime = {
    ParamentName = "StrafeInputHoldTime",
    ParamentValue = {"0.3"}
  },
  StrafeRecoverInterpSpeed = {
    ParamentName = "StrafeRecoverInterpSpeed",
    ParamentValue = {"0.175"}
  },
  StrafeRecoverYawThreshold = {
    ParamentName = "StrafeRecoverYawThreshold",
    ParamentValue = {"5"}
  },
  StrafeSideOffsetYaw = {
    ParamentName = "StrafeSideOffsetYaw",
    ParamentValue = {"60"}
  },
  TagAndTimeForResetPitch = {
    ParamentName = "TagAndTimeForResetPitch",
    ParamentValue = {"Idle:3"}
  },
  TagAndTimeForResetSpringArm = {
    ParamentName = "TagAndTimeForResetSpringArm",
    ParamentValue = {"Idle:1.5", "Falling:1"}
  },
  TimeToResetPitchMaxSpeed = {
    ParamentName = "TimeToResetPitchMaxSpeed",
    ParamentValue = T.RT_3
  },
  TimeToResetSocketOffsetMaxSpeed = {
    ParamentName = "TimeToResetSocketOffsetMaxSpeed",
    ParamentValue = T.RT_3
  },
  TimeToResetSpringArmMaxSpeed = {
    ParamentName = "TimeToResetSpringArmMaxSpeed",
    ParamentValue = T.RT_3
  }
})
