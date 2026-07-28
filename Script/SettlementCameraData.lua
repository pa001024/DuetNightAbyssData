local T = {
  Loc = {
    RT_1 = {
      X = 155.0,
      Y = 4.0,
      Z = 123.0
    },
    RT_2 = {
      X = 0.0,
      Y = 0.0,
      Z = 0.0
    }
  },
  Rot = {
    RT_1 = {
      Roll = -1.0E-5,
      Pitch = -10.0,
      Yaw = -179.999985
    }
  }
}
T.Camera = {
  RT_1 = {
    Aperture = 20.0,
    FocalLength = 20.0,
    Location = T.Loc.RT_1,
    Rotation = T.Rot.RT_1
  },
  RT_2 = {
    Aperture = 20.0,
    FocalLength = 20.0,
    Location = T.Loc.RT_2,
    Rotation = T.Rot.RT_1
  }
}
local ReadOnly = {
  Common_Girl_Cam = T.Camera.RT_1,
  Common_Girl_1504_150401_Cam = T.Camera.RT_2,
  Common_Loli_Cam = T.Camera.RT_2,
  Common_Man_Cam = T.Camera.RT_2,
  Common_Boy_Cam = T.Camera.RT_2,
  Common_Woman_Cam = T.Camera.RT_2
}
return ReadOnly
