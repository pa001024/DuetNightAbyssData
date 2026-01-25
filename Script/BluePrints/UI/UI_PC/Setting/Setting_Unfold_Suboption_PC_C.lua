require("UnLua")
local EMCache = require("EMCache.EMCache")
local SettingUtils = require("Utils.SettingUtils")
local M = Class("BluePrints.UI.UI_PC.Setting.Setting_Unfold_OptionBase_PC_C")

function M:InitSubOption(Parent, CacheName, CacheInfo, UpOption)
  rawset(self, "Parent", Parent)
  rawset(self, "CacheName", CacheName)
  rawset(self, "CacheInfo", CacheInfo)
  rawset(self, "IsListOpen", false)
  rawset(self, "HasBeenForbidden", false)
  local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
  rawset(self, "DefaultValue", UpOption and SubOptionDefaultValueTemp[UpOption:GetDefaultValue()] or 1)
  rawset(self, "SubListOffset", 15)
  rawset(self, "NowOptionId", 1)
  rawset(self, "OldOptionId", 1)
  rawset(self, "UpOptionValue", UpOption:GetOptionValue())
  rawset(self, "UpOption", UpOption)
  self.EMCacheName = self.CacheInfo.EMCacheName
  self.EMCacheKey = self.CacheInfo.EMCacheKey
  self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
  self:InitUnFoldTextList()
  self:UpdateDefaultValue()
  self:InitOptionEMCache()
  self:SetHoverVisibility()
  self:RefreshSubOptionState()
end

function M:RefreshSubOptionState()
  if 0 == self.NowOptionId then
    self.Text_Current:SetText("")
    self:PlayAnimation(self.Forbidden)
    self.Button_Area:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.Collapsed)
  elseif self.NeedForceForbidden then
    local CurrText = GText(self.UnFoldTextList[self.NowOptionId])
    self.Text_Current:SetText(CurrText)
    self:PlayAnimation(self.Forbidden)
    self.Button_Area:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self:PlayAnimationReverse(self.Forbidden)
    local CurrText = GText(self.UnFoldTextList[self.NowOptionId])
    self.Text_Current:SetText(CurrText)
    self.Button_Area:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:InitUnFoldTextList()
  if self.CacheInfo.UnFoldText and string.match(self.CacheInfo.UnFoldText[1], "^" .. "Dynamic") then
    self:DynamicCalSubOptionText()
  elseif self.CacheInfo.SubOptionMultiListM and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self:RefreshUnFoldTestList(self.CacheInfo.SubOptionMultiListM)
  elseif self.CacheInfo.SubOptionMultiList then
    self:RefreshUnFoldTestList(self.CacheInfo.SubOptionMultiList)
  else
    self.UnFoldTextList = self.CacheInfo.UnFoldText
  end
end

function M:RefreshUnFoldTestList(SubOptionMultiList)
  local SubOptionTextList = SubOptionMultiList[self.UpOptionValue]
  local TextList = {}
  for i, Index in pairs(SubOptionTextList) do
    table.insert(TextList, self.CacheInfo.UnFoldText[Index])
  end
  self.UnFoldTextList = TextList
end

function M:DynamicCalSubOptionText()
  if not self.CacheInfo.UnFoldText[1] then
    return
  end
  local str = self.CacheInfo.UnFoldText[1]
  local startIndex = string.find(str, "_")
  if not startIndex then
    return
  end
  local result = string.sub(str, startIndex + 1)
  if "Resolution" == result then
    self:RefreshResolutionOption()
  end
end

function M:RefreshResolutionOption()
  local FirstValidResolution
  local ResolutionStrTable = {}
  for key, subTable in pairs(CommonConst.ResolutionTable) do
    ResolutionStrTable[key] = {}
    for _, value in ipairs(subTable) do
      local str = string.format("%dx%d", value[1], value[2])
      table.insert(ResolutionStrTable[key], str)
    end
  end
  local OriginSubOptionText = CommonConst.ResolutionTable[self.UpOptionValue - 1]
  local SubOptionText = {
    GText("UI_OPTION_Resolution_Cusrtom")
  }
  local SceneManager = GWorld.GameInstance:GetSceneManager()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local MonitorResolution = GameUserSettings:GetDesktopResolution()
  DebugPrint("Yklua CurrentWindowSize  by GameUserSettings:GetDesktopResolution():  " .. MonitorResolution.X .. "x" .. MonitorResolution.Y)
  MonitorResolution = SceneManager:GetMonitorResolution()
  DebugPrint("Yklua CurrentWindowSize  by SceneManager:GetMonitorResolution(): " .. MonitorResolution.X .. "x" .. MonitorResolution.Y)
  if nil == OriginSubOptionText then
    OriginSubOptionText = {}
    OriginSubOptionText[1] = {
      MonitorResolution.X,
      MonitorResolution.Y
    }
    SubOptionText = {
      string.format("%dx%d", MonitorResolution.X, MonitorResolution.Y)
    }
    self.NeedForceForbidden = true
  else
    self.NeedForceForbidden = false
    for index, value in ipairs(OriginSubOptionText) do
      if value[1] <= MonitorResolution.X and value[2] <= MonitorResolution.Y then
        if nil == FirstValidResolution then
          FirstValidResolution = value
        end
        table.insert(SubOptionText, GText(ResolutionStrTable[self.UpOptionValue - 1][index]))
      end
    end
  end
  self.UnFoldTextList = SubOptionText
  if 1 == #SubOptionText then
    self.bForceMaxResolution = true
  end
end

function M:RefreshSubOptionList(UpOptionValue)
  self.UpOptionValue = UpOptionValue
  self:InitUnFoldTextList()
  self:RestoreDefaultOptionSet()
  self:RefreshSubOptionState()
end

function M:SetOldOptionId(List, NowSet, IsTable)
  for Id, Value in pairs(List) do
    if IsTable then
      if Value[1] == NowSet[1] and Value[2] == NowSet[2] then
        return Id
      end
    elseif Value == NowSet then
      return Id
    end
  end
  local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
  return SubOptionDefaultValueTemp[SettingUtils.GetUpValueByValueType(self.UpOptionValue)]
end

function M:RefreshNowOptionId()
  local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
  self.NowOptionId = SubOptionDefaultValueTemp[SettingUtils.GetUpValueByValueType(self.UpOptionValue)]
end

function M:GetSubOptionDefaultValue()
  if not self.CacheInfo.MobileSubOptionDefaultValue then
    return self.CacheInfo.SubOptionDefaultValue
  end
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return self.CacheInfo.MobileSubOptionDefaultValue
  else
    return self.CacheInfo.SubOptionDefaultValue
  end
end

function M:SetAntiAliasingQualityOldOptionId()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local NowAntiAliasingQuality = GameUserSettings:GetAntiAliasingQuality()
  self.AntiAliasingQualityList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  if 0 == self.CacheInfo.SubOptionDefaultValue[SettingUtils.GetUpValueByValueType(self.UpOptionValue)] then
    self.OldOptionId = 0
  else
    self.OldOptionId = self:SetOldOptionId(self.AntiAliasingQualityList, NowAntiAliasingQuality)
  end
end

function M:RestoreDefaultAntiAliasingQuality()
  self:SaveAntiAliasingQualityOptionSetting()
end

function M:SaveAntiAliasingQualityOptionSetting()
  local OptionCache = self.AntiAliasingQualityList[self.NowOptionId] or 0
  SettingUtils.SaveEMCache("GameUserSettings", "AntiAliasingQuality", OptionCache)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  GameUserSettings:SetAntiAliasingQuality(OptionCache)
  GameUserSettings:ApplySettings(true)
end

function M:OnViewPortChanged()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local NowInterfaceMode = GameUserSettings:GetFullscreenMode()
  if NowInterfaceMode ~= EWindowMode.Windowed then
    return
  end
  if self.bHavaChangeViewport == true then
    self.bHavaChangeViewport = false
  else
    self.NowOptionId = 1
  end
end

function M:SetInterfaceModeResolutionOldOptionId()
  EventManager:RemoveEvent(EventID.GameViewportSizeChanged, self)
  EventManager:AddEvent(EventID.GameViewportSizeChanged, self, self.OnViewPortChanged)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local Resolution = GameUserSettings:GetScreenResolution()
  local ResolutionStr = Resolution.X .. "x" .. Resolution.Y
  local SelectId
  for ID, value in ipairs(self.UnFoldTextList) do
    if value == ResolutionStr then
      SelectId = ID
    end
  end
  if nil == SelectId then
    SelectId = 1
  end
  self.OldOptionId = SelectId
  self.bHavaChangeViewport = false
end

function M:RestoreDefaultInterfaceModeResolution()
  self:SaveInterfaceModeResolutionOptionSetting()
end

function M:ForceCalMaxResolution()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local Resolution = GameUserSettings:GetDesktopResolution()
  local Ratios = {
    [2] = 12,
    [3] = 16,
    [4] = 21,
    [5] = 23
  }
  local maxWidth, maxHeight = self:AdjustResolutionToAspectRatio(Ratios[self.UpOptionValue], 9, Resolution.X, Resolution.Y)
  return {X = maxWidth, Y = maxHeight}
end

function M:AdjustResolutionToAspectRatio(targetWidthRatio, targetHeightRatio, screenMaxWidth, screenMaxHeight)
  local targetAspectRatio = targetWidthRatio / targetHeightRatio
  local screenAspectRatio = screenMaxWidth / screenMaxHeight
  if targetAspectRatio > screenAspectRatio then
    local newHeight = math.floor(screenMaxWidth / targetAspectRatio)
    newHeight = math.max(newHeight, 1)
    return screenMaxWidth, newHeight
  else
    local newWidth = math.floor(screenMaxHeight * targetAspectRatio)
    newWidth = math.max(newWidth, 1)
    return newWidth, screenMaxHeight
  end
end

function M:SaveInterfaceModeResolutionOptionSetting()
  if self.bHavaChangeViewport ~= true then
    self.bHavaChangeViewport = true
  end
  if self.UpOptionValue <= 1 then
    return
  end
  local index = self.NowOptionId
  if 1 == index and true ~= self.bForceMaxResolution then
    return
  end
  if true == self.bForceMaxResolution then
    self.bForceMaxResolution = false
    local NewResolution = self:ForceCalMaxResolution()
    local SceneManager = GWorld.GameInstance:GetSceneManager()
    SceneManager.RatioCache = FIntPoint(NewResolution.X, NewResolution.Y)
    SceneManager:ResizeWindow(EWindowMode.Windowed, NewResolution.X, NewResolution.Y)
    return
  end
  local MiniOptionCacheText = self.UnFoldTextList[index]
  local num1, num2 = MiniOptionCacheText:match("(%d+)x(%d+)")
  num1 = tonumber(num1)
  num2 = tonumber(num2)
  local SceneManager = GWorld.GameInstance:GetSceneManager()
  if SceneManager then
    SceneManager.RatioCache = FIntPoint(num1, num2)
    SceneManager:ResizeWindow(EWindowMode.Windowed, num1, num2)
  end
end

function M:SetForceFeedbackScaleOldOptionId()
  self.ForceFeedbackScaleList = {
    [1] = 1,
    [2] = 2,
    [3] = 3
  }
  local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
  local NowForceFeedback = SettingUtils.GetEMCache("ForceFeedbackScale", nil, self.ForceFeedbackScaleList[SubOptionDefaultValueTemp[2]])
  self.OldOptionId = self.UpOptionValue and self:SetOldOptionId(self.ForceFeedbackScaleList, NowForceFeedback) or 0
end

function M:RestoreDefaultForceFeedbackScale()
  self.NowOptionId = self.UpOptionValue and self:SetOldOptionId(self.ForceFeedbackScaleList) or 0
  self:SaveForceFeedbackScaleOptionSetting()
end

function M:SaveForceFeedbackScaleOptionSetting()
  local MiniOptionCache = self.ForceFeedbackScaleList[self.NowOptionId]
  if not self.UpOptionValue then
    return
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  PlayerController = PlayerController:Cast(UE4.ASinglePlayerController)
  if IsValid(PlayerController) then
    PlayerController:SwitchForceFeedbackScale(MiniOptionCache)
  end
end

function M:SetQualityModeOldOptionId()
  self:RefreshSuperResolution()
  self.OldOptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
end

function M:RestoreDefaultQualityMode()
  self:SaveQualityModeOptionSetting()
end

function M:SaveQualityModeOptionSetting()
  self:RefreshSuperResolution()
  USRMBlueprintLibrary.SetSRTypeAndQuality(self.UpOption.UpscalingMethod, self.OptionIdToQuality[self.NowOptionId] or 1)
  SettingUtils.SaveEMCache(self.CacheName, self.EMCacheKey, self.NowOptionId)
  SettingUtils.SaveEMCache("QualityModeValue", nil, self.OptionIdToQuality[self.NowOptionId] or 1)
end

function M:RefreshSuperResolution()
  if self.UpOption.UpscalingMethod == ESuperResolutionType.DLSS then
    self.OptionIdToQuality = {
      [1] = 1,
      [2] = 4,
      [3] = 5,
      [4] = 6,
      [5] = 2
    }
  elseif self.UpOption.UpscalingMethod == ESuperResolutionType.FSR then
    self.OptionIdToQuality = {
      [1] = 1,
      [2] = 2,
      [3] = 3,
      [4] = 4,
      [5] = 5
    }
  elseif self.UpOption.UpscalingMethod == ESuperResolutionType.XeSS then
    self.OptionIdToQuality = {
      [1] = 5,
      [2] = 4,
      [3] = 3,
      [4] = 2,
      [5] = 1
    }
  elseif self.UpOption.UpscalingMethod == ESuperResolutionType.MobileFSR then
    self.OptionIdToQuality = {
      [1] = 0,
      [2] = 1,
      [3] = 2,
      [4] = 3
    }
  elseif self.UpOption.UpscalingMethod == ESuperResolutionType.GSR then
    self.OptionIdToQuality = {
      [1] = 0,
      [2] = 1,
      [3] = 2,
      [4] = 3
    }
  else
    self.OptionIdToQuality = {}
  end
end

return M
