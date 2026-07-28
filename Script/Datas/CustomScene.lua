local T = {}
T.RT_1 = {
  -187.2656,
  33.0156,
  102.7656
}
T.RT_2 = {
  0,
  -5,
  -3.5
}
T.RT_3 = {-500, 500}
T.RT_4 = {-150, 150}
T.RT_5 = {-30, 250}
T.RT_6 = {-80, 80}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomScene", {
  [101] = {
    CameraInitialPosition = T.RT_1,
    CameraInitialRotation = T.RT_2,
    CameraLocationX = T.RT_3,
    CameraLocationY = T.RT_4,
    CameraLocationZ = T.RT_5,
    CameraRotationPitch = T.RT_6,
    CameraRotationYaw = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/PersonalInfo/T_PersonalInfo_SkyBox_Blue.T_PersonalInfo_SkyBox_Blue'",
    Name = "个人主页默认场景",
    SceneColorIndex = 0,
    SceneId = 101,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  },
  [102] = {
    CameraInitialPosition = T.RT_1,
    CameraInitialRotation = T.RT_2,
    CameraLocationX = T.RT_3,
    CameraLocationY = T.RT_4,
    CameraLocationZ = T.RT_5,
    CameraRotationPitch = T.RT_6,
    CameraRotationYaw = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Static/Image/PersonalInfo/T_PersonalInfo_SkyBox_Green.T_PersonalInfo_SkyBox_Green'",
    Name = "个人主页默认场景",
    SceneColorIndex = 2,
    SceneId = 102,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  }
})
