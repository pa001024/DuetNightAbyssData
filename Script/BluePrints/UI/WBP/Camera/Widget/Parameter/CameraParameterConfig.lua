local OptionWidgetPaths = {
  List = "WidgetBlueprint'/Game/UI/WBP/Camera/Widget/Parameter/WBP_Camera_Parameter_SortDown.WBP_Camera_Parameter_SortDown'",
  Switch = "WidgetBlueprint'/Game/UI/WBP/Camera/Widget/Parameter/WBP_Camera_Parameter_SwitchCheckBox.WBP_Camera_Parameter_SwitchCheckBox'",
  FilterList = "WidgetBlueprint'/Game/UI/WBP/Camera/Widget/Parameter/WBP_Camera_Parameter_Filter.WBP_Camera_Parameter_Filter'",
  Slide = "WidgetBlueprint'/Game/UI/WBP/Camera/Widget/Parameter/WBP_Camera_Parameter_Slide.WBP_Camera_Parameter_Slide'"
}
local Config = {
  {
    Title = "UI_CameraSystem_LensParam",
    TabId = "Lens",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Camera/T_Camera_IconCameraParameter.T_Camera_IconCameraParameter'",
    Options = {
      {
        Title = "UI_CameraSystem_LensParam_LensMode",
        OptionId = "CameraMode",
        WidgetType = "List",
        Options = {
          "UI_CameraSystem_CameraModeDefault",
          "UI_CameraSystem_CameraModeSelfie",
          "UI_CameraSystem_CameraModePhotography"
        }
      },
      {
        Title = "UI_CameraSystem_LensParam_LensTilt",
        OptionId = "CameraRoll",
        WidgetType = "Slide",
        Min = -180,
        Max = 180,
        Step = 1,
        Default = 0
      },
      {
        Title = "UI_CameraSystem_LensParam_Grid",
        OptionId = "GuideLine",
        WidgetType = "Switch",
        Default = false,
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_LensParam_DOF",
        OptionId = "DepthOfField",
        WidgetType = "Switch",
        Default = false,
        NeedRedDot = true
      }
    }
  },
  {
    Title = "UI_CameraSystem_ColorParam",
    TabId = "Color",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Camera/T_Camera_IconColorParameter.T_Camera_IconColorParameter'",
    Options = {
      {
        Title = "UI_CameraSystem_ColorParam_Contrast",
        OptionId = "Contrast",
        WidgetType = "Slide",
        Min = 50,
        Max = 200,
        Step = 1,
        Default = 100,
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_ColorParam_Saturation",
        OptionId = "Saturation",
        WidgetType = "Slide",
        Min = 0,
        Max = 200,
        Step = 1,
        Default = 100,
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_ColorParam_ColorTemp",
        OptionId = "Temperature",
        WidgetType = "Slide",
        Min = 2700,
        Max = 9300,
        Step = 1,
        Default = 6500,
        Suffix = "K",
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_ColorParam_Hue",
        OptionId = "WhiteTint",
        WidgetType = "Slide",
        Min = -50,
        Max = 50,
        Step = 1,
        Default = 0,
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_ColorParam_TintR",
        OptionId = "SceneColorTintR",
        WidgetType = "Slide",
        Min = 50,
        Max = 150,
        Step = 1,
        Default = 100,
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_ColorParam_TintG",
        OptionId = "SceneColorTintG",
        WidgetType = "Slide",
        Min = 50,
        Max = 150,
        Step = 1,
        Default = 100,
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_ColorParam_TintB",
        OptionId = "SceneColorTintB",
        WidgetType = "Slide",
        Min = 50,
        Max = 150,
        Step = 1,
        Default = 100,
        NeedRedDot = true
      }
    }
  },
  {
    Title = "UI_CameraSystem_LensParam_Filter",
    TabId = "Filter",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Camera/T_Camera_IconFilterParameter.T_Camera_IconFilterParameter'",
    Options = {
      {
        Title = "UI_CameraSystem_LensParam_FilterIntensity",
        OptionId = "FilterIntensity",
        WidgetType = "Slide",
        Min = 0,
        Max = 100,
        Step = 1,
        Default = 100,
        Suffix = "%",
        NeedRedDot = true
      },
      {
        Title = "UI_CameraSystem_LensParam_FilterName",
        OptionId = "FilterList",
        WidgetType = "FilterList",
        NeedRedDot = true,
        CustomRedDot = true
      }
    }
  }
}
for _, TabConfig in ipairs(Config) do
  for _, OptionConfig in ipairs(TabConfig.Options) do
    OptionConfig.TabId = TabConfig.TabId
  end
end
local M = {}

function M.GetConfig()
  return Config
end

function M.GetOptionWidgetPath(WidgetType)
  return OptionWidgetPaths[WidgetType]
end

return M
