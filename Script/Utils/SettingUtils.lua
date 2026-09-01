local SettingUtils = {}
local EMCache = require("EMCache.EMCache")
local FIRST_OPEN_LAYOUT_PLAN_03_KEY = "FirstOpenLayoutPlan03"
local bPerformanceInitDone = false

local function IsPerformanceInitReady()
  if not GWorld or not GWorld.GameInstance then
    return false
  end
  local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UPerformanceSubSystem:StaticClass())
  return nil ~= SubSystem
end

function SettingUtils.InitPerformanceSetting()
  if bPerformanceInitDone then
    return
  end
  if not IsPerformanceInitReady() then
    return
  end
  local bOverallApplied = SettingUtils.InitGameOverallPerformance()
  SettingUtils.InitGameMaxFPS()
  if bOverallApplied then
    bPerformanceInitDone = true
  end
end

function SettingUtils.InitGameOverallPerformance()
  local OptionName = "OverallPreset"
  local GameOverallPerformanceCache = EMCache:Get(OptionName)
  local NowGameOverallPerformance = GWorld.GameInstance:GetOverallScalabilityLevel()
  DebugPrint("-----jzn---InitGameOverallPerformance-----", GameOverallPerformanceCache, NowGameOverallPerformance)
  local bOverallApplied = false
  if nil ~= GameOverallPerformanceCache then
    GWorld.GameInstance:SetScalabilityLevel(GameOverallPerformanceCache)
    EventManager:FireEvent(EventID.OnOverallPresetChanged, GameOverallPerformanceCache)
    if GameOverallPerformanceCache == CommonConst.OverallPerformanceCustom then
      local BaseTier = SettingUtils.GetCustomBaseTier()
      if nil ~= BaseTier then
        bOverallApplied = SettingUtils.SetPlatformPerformanceLevel(BaseTier)
        GWorld.GameInstance:SetScalabilityLevel(CommonConst.OverallPerformanceCustom)
      else
        bOverallApplied = true
      end
      SettingUtils.InitContentPerformanceCache()
      SettingUtils.InitGameUserSettingsCache()
      SettingUtils.InitConsoleVariableCache()
      SettingUtils.InitDLSSCache()
      SettingUtils.InitFoliageEnhancedCache()
      SettingUtils.InitWaterQualityCache()
    else
      bOverallApplied = SettingUtils.SetPlatformPerformanceLevel(GameOverallPerformanceCache, true)
    end
  elseif nil ~= NowGameOverallPerformance and -1 ~= NowGameOverallPerformance then
    bOverallApplied = SettingUtils.SetPlatformPerformanceLevel(NowGameOverallPerformance, true)
    if bOverallApplied then
      EMCache:Set(OptionName, NowGameOverallPerformance)
      EventManager:FireEvent(EventID.OnOverallPresetChanged, NowGameOverallPerformance)
    end
  else
    bOverallApplied = true
  end
  SettingUtils.InitAntiAliasingCache(GameOverallPerformanceCache or NowGameOverallPerformance)
  SettingUtils.InitMobileResolution(GameOverallPerformanceCache or NowGameOverallPerformance)
  SettingUtils.InitRealtimeSunlight(GameOverallPerformanceCache or NowGameOverallPerformance)
  return bOverallApplied
end

SettingUtils.ScalabilityToPerformanceKey = {
  [0] = "VeryLow",
  [1] = "Low",
  [2] = "Medium",
  [3] = "High",
  [4] = "VeryHigh"
}

function SettingUtils.SetPlatformPerformanceLevel(ScalabilityLevel, bSyncOverrideCache)
  if nil == ScalabilityLevel or ScalabilityLevel < 0 then
    return false
  end
  local DevicePlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)
  local LevelKey = SettingUtils.ScalabilityToPerformanceKey[ScalabilityLevel]
  if not LevelKey then
    return false
  end
  local PlatformData = DataMgr.PlatformPerformance[DevicePlatformName]
  if not PlatformData then
    return false
  end
  local PerformanceLevelId = PlatformData[LevelKey]
  if nil == PerformanceLevelId then
    return false
  end
  local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UPerformanceSubSystem:StaticClass())
  if SubSystem then
    SubSystem:SetPerformanceLevel(PerformanceLevelId)
    if SubSystem:GetPerformanceLevel() ~= PerformanceLevelId then
      return false
    end
    GWorld.GameInstance:SetScalabilityLevel(ScalabilityLevel)
    if bSyncOverrideCache then
      SettingUtils.SyncTierDrivenOverrideCache(PerformanceLevelId)
    end
    return true
  else
    return false
  end
end

function SettingUtils.SyncTierDrivenOverrideCache(PerformanceLevelId)
  local LevelData = DataMgr.PerformanceLevel and DataMgr.PerformanceLevel[PerformanceLevelId]
  if not LevelData then
    return
  end
  if LevelData.WaterQuality ~= nil then
    SettingUtils.SaveEMCache("WaterQuality", nil, LevelData.WaterQuality + 1)
  end
  if nil ~= LevelData.FoliageEnhanced then
    SettingUtils.SaveEMCache("FoliageQuality", nil, LevelData.FoliageEnhanced)
  end
  if nil ~= LevelData.RealtimeSunlight then
    SettingUtils.SaveEMCache("RealtimeSunlight", nil, 0 == LevelData.RealtimeSunlight)
  end
  if nil ~= LevelData.DLSS and LevelData.DLSS > 0 and CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) ~= "Mobile" and URuntimeCommonFunctionLibrary.IsDLSSSupported() then
    SettingUtils.SaveEMCache("UpscalingMethod", nil, 2)
    SettingUtils.SaveEMCache("UpscalingMethodValue", nil, ESuperResolutionType.DLSS)
    local QualityModeOptionIdMap = {
      [1] = 4,
      [2] = 3,
      [3] = 2
    }
    local QualityModeValueMap = {
      [1] = 6,
      [2] = 5,
      [3] = 4
    }
    SettingUtils.SaveEMCache("QualityMode", nil, QualityModeOptionIdMap[LevelData.DLSS])
    SettingUtils.SaveEMCache("QualityModeValue", nil, QualityModeValueMap[LevelData.DLSS])
  end
  local DeviceType = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  if "Mobile" == DeviceType then
    local GameInstance = GWorld.GameInstance
    if GameInstance then
      local ScalabilityLevel = GameInstance:GetOverallScalabilityLevel()
      if ScalabilityLevel >= 0 and ScalabilityLevel < 5 then
        local MobileResolutionOptionId = ScalabilityLevel + 1
        SettingUtils.SaveEMCache("MobileResolution", nil, MobileResolutionOptionId)
      end
    end
  end
end

function SettingUtils.RecordCustomBaseTier()
  local NowLevel = GWorld.GameInstance:GetOverallScalabilityLevel()
  if NowLevel ~= CommonConst.OverallPerformanceCustom and nil ~= NowLevel and NowLevel >= 0 then
    EMCache:Set("CustomBaseTier", NowLevel)
  end
end

function SettingUtils.EnterCustomTier()
  SettingUtils.RecordCustomBaseTier()
  SettingUtils.SaveEMCache("OverallPreset", nil, CommonConst.OverallPerformanceCustom)
  GWorld.GameInstance.SetOverallScalabilityLevelSimple(CommonConst.OverallPerformanceCustom)
end

function SettingUtils.GetCustomBaseTier()
  local BaseTier = EMCache:Get("CustomBaseTier")
  if nil ~= BaseTier and BaseTier >= 0 then
    return BaseTier
  end
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  if GameUserSettings then
    local InferredLevel = GameUserSettings:GetOverallScalabilityLevel()
    if nil ~= InferredLevel and InferredLevel >= 0 then
      return InferredLevel
    end
  end
  return nil
end

function SettingUtils.InitAntiAliasingCache(GameOverallPerformance)
  local OptionName = "AntiAliasing"
  local NowAntiAliasing = URuntimeCommonFunctionLibrary.GetAntiAliasingMethodType()
  local AntiAliasingCache = EMCache:Get(OptionName) or NowAntiAliasing
  local AntiAliasingList
  if nil == GameOverallPerformance then
    GameOverallPerformance = -1
  end
  if CommonUtils.GetRuntimePlatform() == "Mobile" then
    if AntiAliasingCache ~= CommonConst.AntiAliasingClose then
      AntiAliasingCache = 2
    end
    AntiAliasingList = {
      [-1] = AntiAliasingCache,
      [0] = 2,
      [1] = 2,
      [2] = 2,
      [3] = 2,
      [4] = 2
    }
  else
    AntiAliasingList = {
      [-1] = AntiAliasingCache,
      [0] = 2,
      [1] = 2,
      [2] = 4,
      [3] = 4,
      [4] = 4
    }
  end
  local InitAntiAliasing = AntiAliasingList[GameOverallPerformance]
  if URuntimeCommonFunctionLibrary.IsDLSSSupported() and UDLSSLibrary and 0 ~= UDLSSLibrary.GetDLSSMode() then
    InitAntiAliasing = 2
  end
  local CachedSRType = EMCache:Get("UpscalingMethodValue")
  if nil ~= CachedSRType and 0 ~= CachedSRType then
    InitAntiAliasing = 2
  end
  URuntimeCommonFunctionLibrary.SetAntiAliasingMethodType(InitAntiAliasing)
end

function SettingUtils.InitContentPerformanceCache()
  local OptionName = "ContentPerformance"
  local ContentPerformanceCache = EMCache:Get(OptionName)
  local NowContentPerformance = GWorld.GameInstance.GetGameplayScalabilityLevel()
  if nil ~= ContentPerformanceCache and ContentPerformanceCache ~= NowContentPerformance then
    GWorld.GameInstance.SetGameplayScalabilityLevel(ContentPerformanceCache)
  end
end

function SettingUtils.InitGameUserSettingsCache()
  local OptionName = "GameUserSettings"
  local CacheData = EMCache:Get(OptionName)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  if CacheData then
    for CacheName, CacheValue in pairs(CacheData) do
      if "VSyncEnabled" == CacheName then
        local NowValue = GameUserSettings:IsVSyncEnabled()
        if CacheValue ~= NowValue then
          GameUserSettings:SetVSyncEnabled(CacheValue)
        end
      else
        local NowValue = GameUserSettings["Get" .. CacheName](GameUserSettings)
        if CacheValue ~= NowValue then
          GameUserSettings["Set" .. CacheName](GameUserSettings, CacheValue)
        end
      end
    end
    GameUserSettings:ApplySettings(true)
  end
end

function SettingUtils.InitConsoleVariableCache()
  local OptionName = "ConsoleVariable"
  local CacheData = EMCache:Get(OptionName)
  if CacheData then
    for CacheName, CacheValue in pairs(CacheData) do
      local NowValue = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue(CacheName)
      if CacheValue ~= NowValue then
        GWorld.GameInstance:SetGameScalabilityLevelByName(CacheName, CacheValue)
      end
    end
  end
end

function SettingUtils.InitDLSSCache()
  if not UDLSSLibrary or not URuntimeCommonFunctionLibrary.IsDLSSSupported() then
    return
  end
  local OptionName = "DLSS"
  local DLSSCache = EMCache:Get(OptionName)
  if nil ~= DLSSCache then
    local CacheValue = DLSSCache
    if 3 == CacheValue then
      CacheValue = 1
    end
    local NowDLSS = UDLSSLibrary.GetDLSSMode()
    if CacheValue ~= NowDLSS then
      UDLSSLibrary.SetDLSSMode(CacheValue)
    end
  end
end

function SettingUtils.InitFoliageEnhancedCache()
  local OptionName = "FoliageQuality"
  local FoliageQualityCache = EMCache:Get(OptionName)
  if nil ~= FoliageQualityCache then
    local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UE4.UWorldCompositionSubSystem)
    if WorldCompositionSubSystem then
      WorldCompositionSubSystem:SetFoliageLevel(FoliageQualityCache)
    end
  end
end

function SettingUtils.InitWaterQualityCache()
  local IsMobilePlatform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == "Mobile"
  if UUCloudGameInstanceSubsystem and UUCloudGameInstanceSubsystem.IsCloudGame() then
    IsMobilePlatform = false
  end
  if IsMobilePlatform then
    return
  end
  local WaterQualityCache = EMCache:Get("WaterQuality")
  if nil ~= WaterQualityCache then
    local ApplyValue = math.tointeger(WaterQualityCache - 1)
    URuntimeCommonFunctionLibrary.SetWaterQuality(ApplyValue)
  end
end

function SettingUtils.InitGameMaxFPS()
  local OptionName = "Fps"
  local GameCache = EMCache:Get(OptionName)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  if GameCache then
    if GameCache == CommonConst.MaxFPS then
      GWorld.GameInstance:SetUnfixedFrameRate()
    else
      local FramePace = GameCache
      if 45 == GameCache then
        FramePace = 60
      end
      UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.SetFramePace " .. FramePace, nil)
      GameUserSettings:SetFrameRateLimit(GameCache)
      GameUserSettings:ApplySettings(true)
    end
  else
    local DefaultFps
    if CommonUtils.GetRuntimePlatform() == "Mobile" then
      DefaultFps = 30
      local NowGameOverallPerformance = GWorld.GameInstance:GetOverallScalabilityLevel()
      if NowGameOverallPerformance >= CommonConst.OverallPerformanceHigh then
        DefaultFps = 60
      end
    else
      DefaultFps = 60
    end
    if DefaultFps == CommonConst.MaxFPS then
      GWorld.GameInstance:SetUnfixedFrameRate()
    else
      UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.SetFramePace " .. DefaultFps, nil)
      GameUserSettings:SetFrameRateLimit(DefaultFps)
      GameUserSettings:ApplySettings(true)
    end
  end
end

function SettingUtils.InitMobileResolution(GameOverallPerformance)
  local MobileResolutionList
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)
  if "Android" == PlatformName or "OpenHarmony" == PlatformName then
    MobileResolutionList = {
      [1] = {
        80,
        65,
        576
      },
      [2] = {
        85,
        65,
        648
      },
      [3] = {
        90,
        70,
        684
      },
      [4] = {
        95,
        75,
        720
      },
      [5] = {
        115,
        80,
        800
      }
    }
  elseif "IOS" == PlatformName then
    MobileResolutionList = {
      [1] = {
        48,
        48,
        0
      },
      [2] = {
        52,
        52,
        0
      },
      [3] = {
        55,
        55,
        0
      },
      [4] = {
        65,
        65,
        0
      },
      [5] = {
        70,
        70,
        0
      }
    }
  else
    return
  end
  local CacheName = "MobileResolution"
  local OptionIndex = EMCache:Get(CacheName)
  if nil ~= OptionIndex then
    local MobileResolution = MobileResolutionList[OptionIndex]
    if MobileResolution then
      GWorld.GameInstance.SetScreenPercentageLevel(MobileResolution[1], MobileResolution[2], MobileResolution[3])
    end
  end
end

function SettingUtils.GetEMCache(CacheName, CacheKey, DefaultValue)
  local CacheData = EMCache:Get(CacheName)
  if type(CacheData) ~= "table" and type(CacheData) ~= type(DefaultValue) then
    SettingUtils.SaveEMCache(CacheName, CacheKey, DefaultValue)
    return DefaultValue
  end
  if nil == CacheData then
    SettingUtils.SaveEMCache(CacheName, CacheKey, DefaultValue)
    return DefaultValue
  elseif CacheKey then
    if CacheData[CacheKey] then
      return CacheData[CacheKey]
    end
    SettingUtils.SaveEMCache(CacheName, CacheKey, DefaultValue)
    return DefaultValue
  else
    return CacheData
  end
  return DefaultValue
end

function SettingUtils.GetEMCacheForBL(OptionId)
  local OptionInfo = DataMgr.Option[OptionId]
  if not OptionInfo then
    return
  end
  local DefaultValue
  if UIUtils.IsMobileInput() and OptionInfo.DefaultValueM then
    DefaultValue = OptionInfo.DefaultValueM
  else
    DefaultValue = OptionInfo.DefaultValue
  end
  if OptionInfo.ControlType == "Switch" then
    DefaultValue = "True" == DefaultValue
  elseif OptionInfo.ControlType == "Scroll" or OptionInfo.ControlType == "UnFold" then
    DefaultValue = tonumber(DefaultValue)
  else
    return
  end
  local Value = SettingUtils.GetEMCache(OptionInfo.EMCacheName, OptionInfo.EMCacheKey, DefaultValue)
  return Value
end

function SettingUtils.SaveEMCache(CacheName, CacheKey, CacheValue)
  local CacheData = EMCache:Get(CacheName)
  if CacheKey then
    if CacheData then
      CacheData[CacheKey] = CacheValue
    else
      CacheData = {}
      CacheData[CacheKey] = CacheValue
    end
  else
    CacheData = CacheValue
  end
  EMCache:Set(CacheName, CacheData)
end

function SettingUtils.GetUpValueByValueType(UpOptionValue)
  if true == UpOptionValue or false == UpOptionValue then
    return UpOptionValue and 2 or 1
  end
  return tonumber(UpOptionValue)
end

function SettingUtils.IsOpenRayTracing()
  return UE4.URuntimeCommonFunctionLibrary.GetRayTracingConfigEnabled()
end

function SettingUtils.ResetMobileResolution()
  local OptionName = "OverallPreset"
  local GameOverallPerformanceCache = EMCache:Get(OptionName)
  if -1 == GameOverallPerformanceCache then
    local NowGameOverallPerformance = GWorld.GameInstance:GetOverallScalabilityLevel()
    SettingUtils.InitMobileResolution(GameOverallPerformanceCache or NowGameOverallPerformance)
  else
    if rawget(SettingUtils, "DefaultMobileResolution") == nil then
      local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)
      if "Android" == PlatformName or "OpenHarmony" == PlatformName then
        rawset(SettingUtils, "DefaultMobileResolution", {
          [0] = {
            80,
            65,
            576
          },
          [1] = {
            85,
            65,
            648
          },
          [2] = {
            90,
            70,
            684
          },
          [3] = {
            95,
            75,
            720
          },
          [4] = {
            115,
            80,
            800
          }
        })
      elseif "IOS" == PlatformName then
        rawset(SettingUtils, "DefaultMobileResolution", {
          [0] = {
            48,
            48,
            0
          },
          [1] = {
            52,
            52,
            0
          },
          [2] = {
            55,
            55,
            0
          },
          [3] = {
            65,
            65,
            0
          },
          [4] = {
            70,
            70,
            0
          }
        })
      else
        return
      end
    end
    local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
    if GameUserSettings then
      local AntiAliasingQuality = GameUserSettings:GetAntiAliasingQuality()
      local DefaultResolution = SettingUtils.DefaultMobileResolution[AntiAliasingQuality] or SettingUtils.DefaultMobileResolution[4]
      GWorld.GameInstance.SetScreenPercentageLevel(DefaultResolution[1], DefaultResolution[2], DefaultResolution[3])
    end
  end
end

function SettingUtils.IsShowRedDotForLayoutPlan()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local IsFirstShow = EMCache:Get(FIRST_OPEN_LAYOUT_PLAN_03_KEY, true)
  local Index = Avatar:GetCurrentMobileHudPlanIndex()
  local LayoutEntryIndex = Avatar.GetLayoutEntryIndexByPlanIndex and Avatar:GetLayoutEntryIndexByPlanIndex(Index) or Index
  if (1 == LayoutEntryIndex or 2 == LayoutEntryIndex) and not IsFirstShow and UIUtils.IsMobileInput() then
    return true
  end
  return false
end

function SettingUtils.InitRealtimeSunlight(GameOverallPerformance)
  if nil == GameOverallPerformance then
    GameOverallPerformance = -1
  end
  local CacheName = "RealtimeSunlight"
  local GameCache = EMCache:Get(CacheName)
  if nil == GameCache then
    local OptionInfo = DataMgr.Option[CacheName]
    if OptionInfo.DefaultValue == "True" then
      GameCache = true
    else
      GameCache = false
    end
  end
  EMCache:Set(CacheName, GameCache)
  if GameCache then
    GWorld.GameInstance:SetGameScalabilityLevelByName("EM.FixedSunlightDirection", 0)
  else
    GWorld.GameInstance:SetGameScalabilityLevelByName("EM.FixedSunlightDirection", 1)
  end
end

return SettingUtils
