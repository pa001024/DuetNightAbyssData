local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MountCameraData", {
  Default = {
    BackwardLocation = {
      1200,
      0,
      120
    },
    CameraFocal = 38.6,
    CameraName = "Default",
    Ease = 14,
    ForwardLocation = {
      850,
      0,
      120
    },
    Location = {
      1000,
      0,
      120
    },
    Rotation = {
      0,
      0,
      180
    },
    Time = 1.2
  }
})
