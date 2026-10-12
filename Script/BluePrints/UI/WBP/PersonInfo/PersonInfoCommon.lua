local PersonInfoCommon = {}
local PersonalInfoCustomTypes = require("BluePrints.Client.CustomTypes.PersonalInfo")
PersonInfoCommon.UIName = "PersonInfoPageMain"
PersonInfoCommon.EnablePreviewReflection = false
PersonInfoCommon.EnableSelectionDebugDraw = false
PersonInfoCommon.CustomDisplayServerSupport = {
  Item = true,
  Pet = true,
  Sticker = true,
  Filter = true
}
PersonInfoCommon.CustomDisplayDefaults = PersonalInfoCustomTypes.CustomDisplayDefaults
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

function PersonInfoCommon.RoundEditInteger(Value)
  return math.floor((tonumber(Value) or 0) + 0.5)
end

return PersonInfoCommon
