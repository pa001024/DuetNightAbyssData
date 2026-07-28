local PersonInfoCommon = {}
PersonInfoCommon.UIName = "PersonInfoPageMain"
PersonInfoCommon.EnablePreviewReflection = false
PersonInfoCommon.EnableSelectionDebugDraw = false
PersonInfoCommon.CameraInputConfig = {
  CameraDragYawSpeed = 0.5,
  CameraDragPitchSpeed = 0.5,
  CameraScrollDistanceScale = 20,
  CameraRoamKeyMoveSpeed = 240,
  MobileJoystickRoamSpeed = 40,
  EditGamepadRotateScale = 12,
  EditGamepadZoomScale = 2,
  GamepadInputDeadZone = 0.2
}
PersonInfoCommon.DataPageCameraOffset = {
  Horizontal = -40,
  Duration = 0.2,
  TickInterval = 0.016
}
PersonInfoCommon.OpenPageCameraDelay = 0.2
return PersonInfoCommon
