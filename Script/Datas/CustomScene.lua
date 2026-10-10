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
T.RT_4 = {-350, 350}
T.RT_5 = {-30, 500}
T.RT_6 = {-180, 180}
T.RT_7 = {-80, 80}
T.RT_8 = {
  0,
  0,
  0,
  0.5
}
T.RT_9 = {0, 1}
T.RT_10 = {10, 500}
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
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_SkyBox_Blue.T_PersonalInfo_SkyBox_Blue'",
    IsDefaultUnlock = true,
    LightDirectionX = T.RT_7,
    LightDirectionY = T.RT_7,
    LightDirectionZ = T.RT_7,
    LightInitialParms = T.RT_8,
    LightIntensity = T.RT_9,
    Name = "BackGround_Name_101",
    SceneColorIndex = 0,
    SceneDesc = "BackGround_Des_Normal",
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
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_SkyBox_Green.T_PersonalInfo_SkyBox_Green'",
    IsDefaultUnlock = true,
    LightDirectionX = T.RT_7,
    LightDirectionY = T.RT_7,
    LightDirectionZ = T.RT_7,
    LightInitialParms = T.RT_8,
    LightIntensity = T.RT_9,
    Name = "BackGround_Name_102",
    SceneColorIndex = 2,
    SceneDesc = "BackGround_Des_Normal",
    SceneId = 102,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  },
  [104] = {
    CameraInitialPosition = T.RT_1,
    CameraInitialRotation = T.RT_2,
    CameraLocationX = T.RT_3,
    CameraLocationY = T.RT_4,
    CameraLocationZ = T.RT_10,
    CameraRotationPitch = T.RT_6,
    CameraRotationYaw = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_SkyBox_Black.T_PersonalInfo_SkyBox_Black'",
    IsDefaultUnlock = true,
    LightDirectionX = T.RT_7,
    LightDirectionY = T.RT_7,
    LightDirectionZ = T.RT_7,
    LightInitialParms = T.RT_8,
    LightIntensity = T.RT_9,
    Name = "BackGround_Name_103",
    SceneColorIndex = 7,
    SceneDesc = "BackGround_Des_Normal",
    SceneId = 104,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  },
  [105] = {
    CameraInitialPosition = T.RT_1,
    CameraInitialRotation = T.RT_2,
    CameraLocationX = T.RT_3,
    CameraLocationY = T.RT_4,
    CameraLocationZ = T.RT_10,
    CameraRotationPitch = T.RT_6,
    CameraRotationYaw = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_SkyBox_Pink.T_PersonalInfo_SkyBox_Pink'",
    IsDefaultUnlock = true,
    LightDirectionX = T.RT_7,
    LightDirectionY = T.RT_7,
    LightDirectionZ = T.RT_7,
    LightInitialParms = T.RT_8,
    LightIntensity = T.RT_9,
    Name = "BackGround_Name_104",
    SceneColorIndex = 8,
    SceneDesc = "BackGround_Des_Normal",
    SceneId = 105,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  },
  [106] = {
    CameraInitialPosition = T.RT_1,
    CameraInitialRotation = T.RT_2,
    CameraLocationX = T.RT_3,
    CameraLocationY = T.RT_4,
    CameraLocationZ = T.RT_10,
    CameraRotationPitch = T.RT_6,
    CameraRotationYaw = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_SkyBox_Green_02.T_PersonalInfo_SkyBox_Green_02'",
    IsDefaultUnlock = true,
    LightDirectionX = T.RT_7,
    LightDirectionY = T.RT_7,
    LightDirectionZ = T.RT_7,
    LightInitialParms = T.RT_8,
    LightIntensity = T.RT_9,
    Name = "BackGround_Name_105",
    SceneColorIndex = 9,
    SceneDesc = "BackGround_Des_Normal",
    SceneId = 106,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  },
  [107] = {
    CameraInitialPosition = T.RT_1,
    CameraInitialRotation = T.RT_2,
    CameraLocationX = T.RT_3,
    CameraLocationY = T.RT_4,
    CameraLocationZ = T.RT_10,
    CameraRotationPitch = T.RT_6,
    CameraRotationYaw = T.RT_6,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/PersonalInfo/T_PersonalInfo_SkyBox_Grey.T_PersonalInfo_SkyBox_Grey'",
    IsDefaultUnlock = true,
    LightDirectionX = T.RT_7,
    LightDirectionY = T.RT_7,
    LightDirectionZ = T.RT_7,
    LightInitialParms = T.RT_8,
    LightIntensity = T.RT_9,
    Name = "BackGround_Name_106",
    SceneColorIndex = 10,
    SceneDesc = "BackGround_Des_Normal",
    SceneId = 107,
    ScenePath = "/Game/UI/LevelMap/UI_Background_Art.UI_Background_Art"
  }
})
