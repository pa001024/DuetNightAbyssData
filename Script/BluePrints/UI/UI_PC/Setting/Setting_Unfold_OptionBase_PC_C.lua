require("UnLua")
local EMCache = require("EMCache.EMCache")
local SettingUtils = require("Utils.SettingUtils")
local S = Class("BluePrints.UI.BP_EMUserWidget_C")

function S:Construct()
  self.Button_Area.OnClicked:Add(self, self.OnClickSubOptionList)
  self.Button_Area.OnHovered:Add(self, self.OnBtnAreaHover)
  self.Button_Area.OnUnhovered:Add(self, self.OnBtnAreaUnHoverBase)
  self.Bg_Set.Button_Base.OnClicked:Add(self, self.OnMainBtnClicked)
  self.Bg_Set.Button_Base.OnHovered:Add(self, self.OnMainBtnHovered)
end

function S:Destruct()
  if self.bHavaChangeViewport ~= nil then
    EventManager:RemoveEvent(EventID.GameViewportSizeChanged, self)
    EventManager:RemoveEvent(EventID.RefreshVoiceName, self)
  end
end

function S:Init(Parent, CacheName, CacheInfo)
  rawset(self, "OptionContent", Parent)
  rawset(self, "Parent", Parent.Content and Parent.Content.ParentWidget.Parent or Parent)
  rawset(self, "CacheName", CacheName)
  rawset(self, "CacheInfo", CacheInfo)
  rawset(self, "IsListOpen", false)
  rawset(self, "HasBeenForbidden", false)
  rawset(self, "UnFoldTextList", CacheInfo.UnFoldText)
  rawset(self, "DefaultValue", CacheInfo.DefaultValue)
  rawset(self, "SubListOffset", 15)
  rawset(self, "NowOptionId", 1)
  rawset(self, "OldOptionId", 1)
  self.EMCacheName = self.CacheInfo.EMCacheName
  self.EMCacheKey = self.CacheInfo.EMCacheKey
  self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    if self.CacheInfo.UnFoldTextM then
      self.UnFoldTextList = self.CacheInfo.UnFoldTextM
    end
    if self.CacheInfo.DefaultValueM then
      self.DefaultValue = self.CacheInfo.DefaultValueM
    end
  end
  self:UpdateDefaultValue()
  self:InitOptionEMCache()
  self:SetHoverVisibility()
  local CurrText = GText(self.UnFoldTextList[self.NowOptionId])
  self.Text_Current:SetText(CurrText)
end

function S:UpdateDefaultValue()
  if not self.EMCacheName then
    return
  end
  if self["Update" .. self.EMCacheName .. "DefaultValue"] then
    self["Update" .. self.EMCacheName .. "DefaultValue"](self)
  end
end

function S:SetHoverVisibility()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Bg_Set:PlayAnimation(self.Bg_Set.Normal)
    self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function S:OnMouseEnter(MyGeometry, MouseEvent)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  self.Parent:AddHoverContent(self)
end

function S:OnMouseLeave(MyGeometry, MouseEvent)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  self.Parent:RemoveHoverContent(self)
end

function S:OnBtnAreaHover()
  self.Bg_Set:StopAnimation(self.Bg_Set.UnHover)
  self.Bg_Set:PlayAnimation(self.Bg_Set.Hover)
end

function S:OnBtnAreaUnHover()
end

function S:OnBtnAreaUnHoverBase()
  self.Bg_Set:StopAnimation(self.Bg_Set.Hover)
  self.Bg_Set:PlayAnimation(self.Bg_Set.UnHover)
end

function S:OnBtnDragClicked()
  self.Parent:OnClickAllLeftMouseButton()
end

function S:InitOptionEMCache()
  if self["Set" .. self.CacheName .. "OldOptionId"] then
    self.IsOverallPerformanceCustom = GWorld.GameInstance:GetOverallScalabilityLevel() == CommonConst.OverallPerformanceCustom
    self["Set" .. self.CacheName .. "OldOptionId"](self)
  else
    self.OldOptionId = tonumber(self.DefaultValue)
  end
  self.NowOptionId = self.OldOptionId
  if self.EMCacheName == "GameUserSettings" or self.EMCacheName == "ConsoleVariable" or self.EMCacheName == "AntiAliasing" or self.EMCacheName == "ContentPerformance" or self.CacheName == "MobileResolution" then
    self["Save" .. self.CacheName .. "OptionSetting"](self)
  end
end

function S:SetOldOptionId(List, NowSet, IsTable)
  for Id, Value in pairs(List) do
    if IsTable then
      if Value[1] == NowSet[1] and Value[2] == NowSet[2] then
        return Id
      end
    elseif Value == NowSet then
      return Id
    end
  end
  return tonumber(self.DefaultValue)
end

function S:OnClickSubOptionList()
  if self:IsAnimationPlaying(self.Openlist) then
    return
  end
  UIUtils.PlayCommonBtnSe(self)
  if self.IsListOpen then
    self.IsListOpen = false
    self.Parent:SetSettingUnfoldListPC(false)
    self:PlayAnimationReverse(self.Openlist)
    if UIUtils.IsGamepadInput() then
      self.Bg_Set:SetFocus()
    end
  else
    self.Parent:ClearSettingListUnfoldState()
    self.IsListOpen = true
    self:InitUnfoldOptionList()
    self.Parent:SetSettingUnfoldListPC(true)
    if UIUtils.IsGamepadInput() then
      self.Parent:BindUnfoldListClosedCallback(function()
        self:OnClickLeftMouseButton()
        self.Bg_Set:SetFocus()
      end)
    end
    self:StopAnimation(self.Openlist)
    self:PlayAnimation(self.Openlist)
    local SelfGeometry = self.Button_Area:GetCachedGeometry()
    local ParentGeometry = self.Parent.Panel_Option:GetCachedGeometry()
    local SelfAbsoluteLocation = USlateBlueprintLibrary.LocalToAbsolute(SelfGeometry, FVector2D(0, 0))
    local ParentAbsoluteLocation = USlateBlueprintLibrary.LocalToAbsolute(ParentGeometry, FVector2D(0, 0))
    local SelfAbsoluteSize = USlateBlueprintLibrary.GetAbsoluteSize(SelfGeometry)
    local ParentAbsoluteSize = USlateBlueprintLibrary.GetAbsoluteSize(ParentGeometry)
    local SelfAbsolutePosition, IsUpper
    if SelfAbsoluteLocation.Y - ParentAbsoluteLocation.Y > ParentAbsoluteSize.Y / 2 then
      IsUpper = true
      SelfAbsolutePosition = FVector2D(SelfAbsoluteLocation.X + SelfAbsoluteSize.X / 2, SelfAbsoluteLocation.Y - self.SubListOffset)
    else
      IsUpper = false
      SelfAbsolutePosition = FVector2D(SelfAbsoluteLocation.X + SelfAbsoluteSize.X / 2, SelfAbsoluteLocation.Y + SelfAbsoluteSize.Y + self.SubListOffset)
    end
    local EndAbsolutePosition = USlateBlueprintLibrary.AbsoluteToLocal(ParentGeometry, SelfAbsolutePosition)
    self.Parent:UpdateUnfoldListPosition(EndAbsolutePosition, IsUpper)
  end
end

function S:InitUnfoldOptionList()
  local UnFoldTextListTemp = self.UnFoldTextList
  if not UnFoldTextListTemp then
    return
  end
  local MainPanel = self.Parent
  MainPanel.WBP_Set_UnfoldList.SubOption_List:ClearListItems()
  for key, value in pairs(UnFoldTextListTemp) do
    if self:CheckUnFoldItemIsValid(key) then
      local OptionContent = NewObject(UIUtils.GetCommonItemContentClass())
      OptionContent.Id = key
      OptionContent.Text = GText(value)
      OptionContent.IsDownloadText = self.CacheName == "SystemVoice" and not self:GetVoiceResByIndex(key) and GText("UI_Option_Language_Unload")
      OptionContent.SelectedOptionId = self.NowOptionId
      OptionContent.ParentWidget = self
      OptionContent.ClickCallBack = "OnClickChangeSubOption"
      MainPanel.WBP_Set_UnfoldList.SubOption_List:AddItem(OptionContent)
    end
  end
end

function S:CheckUnFoldItemIsValid(Index)
  if self.CacheName == "UpscalingMethod" then
    if UIUtils.IsMobileInput() then
      if string.find(self.UnFoldTextList[Index], "MFSR") then
        return USRMBlueprintLibrary.IsSRTypeAvailable(ESuperResolutionType.MobileFSR)
      elseif string.find(self.UnFoldTextList[Index], "GSR") then
        return USRMBlueprintLibrary.IsSRTypeAvailable(ESuperResolutionType.GSR)
      end
    elseif UIUtils.IsPCInput() then
      if string.find(self.UnFoldTextList[Index], "DLSS") then
        return USRMBlueprintLibrary.IsSRTypeAvailable(ESuperResolutionType.DLSS)
      elseif string.find(self.UnFoldTextList[Index], "FSR") then
        return USRMBlueprintLibrary.IsSRTypeAvailable(ESuperResolutionType.FSR)
      elseif string.find(self.UnFoldTextList[Index], "XeSS") then
        return USRMBlueprintLibrary.IsSRTypeAvailable(ESuperResolutionType.XeSS)
      end
    end
  end
  return true
end

function S:RefreshOptionOnClick(SelectOptionId)
  local IsNeedSave = false
  if self.NowOptionId ~= SelectOptionId then
    self.Parent:ChangeUnfoldListSelection(SelectOptionId)
    IsNeedSave = true
  end
  local bNeedSetText = true
  if self.CacheName == "AntiAliasing" and URuntimeCommonFunctionLibrary.IsDLSSSupported() then
    local NowDLSS = 1
    if UDLSSLibrary then
      NowDLSS = UDLSSLibrary.GetDLSSMode()
    end
    if 0 ~= NowDLSS then
      bNeedSetText = false
    end
  end
  if bNeedSetText then
    self.NowOptionId = SelectOptionId
    self.Text_Current:SetText(GText(self.UnFoldTextList[self.NowOptionId]))
  end
  self:OnClickSubOptionList()
  if IsNeedSave then
    self:SaveOptionSetting()
  end
end

function S:OnClickChangeSubOption(SelectOptionId)
  local Res = self:CheckOnClickChangeSubOption(SelectOptionId)
  if not Res then
    return
  end
  self:RefreshOptionOnClick(SelectOptionId)
end

function S:CheckOnClickChangeSubOption(SelectOptionId)
  if self["Check" .. self.CacheName .. "OptionSetting"] then
    return self["Check" .. self.CacheName .. "OptionSetting"](self, SelectOptionId)
  end
  return true
end

function S:ClearOpenListState()
  if self.IsListOpen then
    self.IsListOpen = false
    self:PlayAnimationReverse(self.Openlist)
  end
end

function S:OnClickLeftMouseButton()
  if self.IsListOpen then
    self.IsListOpen = false
    self:PlayAnimationReverse(self.Openlist)
    self.Parent:SetSettingUnfoldListPC(false)
    if UIUtils.IsGamepadInput() then
      self.Bg_Set:SetFocus()
    end
  end
end

function S:CheckSettingIsChange()
  return self.OldOptionId ~= self.NowOptionId
end

function S:RefreshNowOptionId()
  self.NowOptionId = tonumber(self.DefaultValue)
end

function S:RestoreDefaultOptionSet()
  self:RefreshNowOptionId()
  self.Text_Current:SetText(GText(self.UnFoldTextList[self.NowOptionId]))
  if self.IsListOpen then
    self.IsListOpen = false
    self.Parent:SetSettingUnfoldListPC(false)
  end
  if self["RestoreDefault" .. self.CacheName] then
    self["RestoreDefault" .. self.CacheName](self)
  else
    self.OldOptionId = tonumber(self.DefaultValue)
  end
  self.OldOptionId = self.NowOptionId
end

function S:SaveOptionSetting()
  if self["Save" .. self.CacheName .. "OptionSetting"] then
    if self.EMCacheName == "GameUserSettings" or self.EMCacheName == "ConsoleVariable" or self.EMCacheName == "AntiAliasing" or self.EMCacheName == "ContentPerformance" or self.CacheName == "MobileResolution" then
      GWorld.GameInstance.SetOverallScalabilityLevelSimple(CommonConst.OverallPerformanceCustom)
      if self.Parent.OverallPreset then
        self.Parent.OverallPreset:RefreshOverallPreset()
      end
    end
    self["Save" .. self.CacheName .. "OptionSetting"](self)
  else
    self.OldOptionId = tonumber(self.DefaultValue)
  end
  self.OldOptionId = self.NowOptionId
end

function S:SaveMiniOptionSetting()
  if self["Save" .. self.CacheName .. "MiniOptionSetting"] then
    if self.EMCacheName == "GameUserSettings" or self.EMCacheName == "ConsoleVariable" or self.EMCacheName == "AntiAliasing" or self.EMCacheName == "ContentPerformance" then
      GWorld.GameInstance.SetOverallScalabilityLevelSimple(CommonConst.OverallPerformanceCustom)
      if self.Parent.OverallPreset then
        self.Parent.OverallPreset:RefreshOverallPreset()
      end
    end
    self["Save" .. self.CacheName .. "MiniOptionSetting"](self)
  end
end

function S:SetSystemLanguageOldOptionId()
  self.SystemLanguageList = {
    [1] = "CN",
    [2] = "EN",
    [3] = "JP",
    [4] = "KR",
    [5] = "TC",
    [6] = "DE",
    [7] = "FR",
    [8] = "ES"
  }
  local NowSystemLanguage = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SystemLanguageList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.SystemLanguageList, NowSystemLanguage)
end

function S:RestoreDefaultSystemLanguage()
  self:SaveSystemLanguageOptionSetting()
end

function S:SaveSystemLanguageOptionSetting()
  self.OptionCache = self.SystemLanguageList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  if self:CheckSettingIsChange() then
    local Params = {}
    
    function Params.RightCallbackFunction()
      self:OnClickConfirmReconnect()
    end
    
    UIManager(self):ShowCommonPopupUI(100075, Params, self.Parent)
  end
end

function S:OnClickConfirmReconnect()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  GameInstance:InitGameSystemLanguage()
  GWorld.NetworkMgr:OnDisconnectAndLoginAgain()
end

function S:InitGameSystemLanguage()
  local ESCMenu = UIManager(self):GetUI("CommonSetup")
  if ESCMenu then
    ESCMenu:InitSetupList()
  end
  local BattleMain = UIManager(self):GetUI("BattleMain")
  if BattleMain then
    BattleMain:InitBtnList()
  end
  self.Parent:InitCommonTab(self.Parent.NewTabId, true)
end

function S:SetCameraBackOldOptionId()
  self.CameraBackList = {
    [1] = "Forbidden",
    [2] = "SkillOnly",
    [3] = "Enable"
  }
  local NowCameraBack = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.CameraBackList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.CameraBackList, NowCameraBack)
end

function S:RestoreDefaultCameraBack()
  self:SaveCameraBackOptionSetting()
end

function S:SaveCameraBackOptionSetting()
  self.OptionCache = self.CameraBackList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:EnableAutoResetCameraPitch(self.OptionCache)
end

function S:SetInterfaceModeOldOptionId()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  self.InterfaceModeList = {
    [1] = EWindowMode.WindowedFullscreen,
    [2] = EWindowMode.Windowed,
    [3] = EWindowMode.Windowed,
    [4] = EWindowMode.Windowed,
    [5] = EWindowMode.Windowed
  }
  local NowInterfaceMode = GameUserSettings:GetFullscreenMode()
  self.OldOptionId = self:SetOldOptionId(self.InterfaceModeList, NowInterfaceMode)
  if self.OldOptionId >= 2 then
    local ScreenScaleList = {
      [12] = 2,
      [16] = 3,
      [21] = 4,
      [23] = 5
    }
    local Resolution = GameUserSettings:GetScreenResolution()
    local Index = Resolution.X * CommonConst.ScreenScale / Resolution.Y
    Index = math.floor(Index + 0.5)
    if nil == ScreenScaleList[Index] then
      Index = CommonConst.DefaultScreenScale
    end
    self.OldOptionId = ScreenScaleList[Index]
  end
end

function S:RestoreDefaultInterfaceMode()
  self:SaveInterfaceModeOptionSetting()
end

function S:SaveInterfaceModeOptionSetting()
  self.OptionCache = self.InterfaceModeList[self.NowOptionId]
  local SceneManager = GWorld.GameInstance:GetSceneManager()
  if nil == SceneManager then
    return
  end
  if self.bHavaChangeViewport ~= true then
    self.bHavaChangeViewport = true
  end
  if self.OptionCache == EWindowMode.Windowed then
  else
    SceneManager:ResizeWindow(self.OptionCache)
  end
end

function S:SetOverallPresetOldOptionId()
  self.OverallPresetList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4,
    [6] = -1
  }
  local NowOverallPreset = GWorld.GameInstance:GetOverallScalabilityLevel()
  self.Parent.OverallPreset = self
  self.OldOptionId = self:SetOldOptionId(self.OverallPresetList, NowOverallPreset)
end

function S:RestoreDefaultOverallPreset()
  self:SaveOverallPresetOptionSetting(true)
end

function S:SaveOverallPresetOptionSetting(IsRestore)
  self.OptionCache = self.OverallPresetList[self.NowOptionId]
  if self.OptionCache == CommonConst.OverallPerformanceCustom then
    SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  else
    SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
    GWorld.GameInstance.SetOverallScalabilityLevel(self.OptionCache)
    SettingUtils.InitAntiAliasingCache(self.OptionCache)
    SettingUtils.InitMobileResolution(self.OptionCache)
    SettingUtils.InitRealtimeSunlight(self.OptionCache)
    if not IsRestore then
      self.Parent:OnTabSelected(self.Parent.CurrentWidget, true)
    end
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if RegionSyncSubsys then
      RegionSyncSubsys:RefreshActivePlayerNum()
    end
  end
end

function S:RefreshOverallPreset()
  local NowOverallPreset = GWorld.GameInstance:GetOverallScalabilityLevel()
  self.NowOptionId = self:SetOldOptionId(self.OverallPresetList, NowOverallPreset)
  local CurrText = GText(self.UnFoldTextList[self.NowOptionId])
  if nil == CurrText then
    CurrText = self.UnFoldTextList[self.NowOptionId]
  end
  self.Text_Current:SetText(CurrText)
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, NowOverallPreset)
end

function S:SetContentPerformanceOldOptionId()
  self.ContentPerformanceList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  local CacheIndex = EMCache:Get(self.CacheName)
  if self.IsOverallPerformanceCustom and nil ~= CacheIndex then
    self.OldOptionId = CacheIndex
  else
    local NowContentPerformance = GWorld.GameInstance:GetGameplayScalabilityLevel()
    self.OldOptionId = self:SetOldOptionId(self.ContentPerformanceList, NowContentPerformance)
  end
end

function S:RestoreDefaultContentPerformance()
  self:SaveContentPerformanceOptionSetting()
end

function S:SaveContentPerformanceOptionSetting()
  self.OptionCache = self.ContentPerformanceList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  SettingUtils.SaveEMCache(self.CacheName, nil, self.NowOptionId)
  GWorld.GameInstance.SetGameplayScalabilityLevel(self.OptionCache)
end

function S:SetDLSSOldOptionId()
  self.DLSSScaleList = {
    [1] = 0,
    [2] = 1,
    [3] = 4,
    [4] = 5,
    [5] = 6,
    [6] = 2
  }
  local NowDLSS = 1
  if UDLSSLibrary then
    NowDLSS = UDLSSLibrary.GetDLSSMode()
  end
  if 7 == NowDLSS then
    NowDLSS = 6
  end
  local NowOptionId = NowDLSS
  self.OldOptionId = self:SetOldOptionId(self.DLSSScaleList, NowOptionId)
end

function S:RestoreDefaultDLSS()
  self:SaveDLSSOptionSetting()
end

function S:SaveDLSSOptionSetting()
  self.OptionCache = self.DLSSScaleList[self.NowOptionId]
  EMCache:Set("DLSS", self.OptionCache)
  if UDLSSLibrary then
    local OptionCache = self.OptionCache
    if 3 == OptionCache then
      OptionCache = 1
    end
    UDLSSLibrary.SetDLSSMode(OptionCache)
  end
end

function S:SetDLSSOptionOldOptionId()
  self.DLSSFGList = {
    [1] = 0,
    [2] = 251,
    [3] = 17,
    [4] = 23,
    [5] = 31
  }
  local NowDLSSFG = 1
  if UStreamlineLibraryDLSSG then
    NowDLSSFG = UStreamlineLibraryDLSSG.GetDLSSGMode()
  end
  local NowOptionId = NowDLSSFG
  self.OldOptionId = self:SetOldOptionId(self.DLSSFGList, NowOptionId)
end

function S:RestoreDefaultDLSSOption()
  self:SaveDLSSOptionOptionSetting()
end

function S:SaveDLSSOptionOptionSetting()
  local MiniOptionCache = self.DLSSFGList[self.NowOptionId]
  EMCache:Set("DLSSFG", MiniOptionCache)
  if UStreamlineLibraryDLSSG then
    UStreamlineLibraryDLSSG.SetDLSSGMode(MiniOptionCache)
  end
end

function S:SetTeammateEffectsOldOptionId()
  self.TeammateEffectsList = {
    [1] = 0,
    [2] = 1,
    [3] = 2
  }
  local NowTeammateEffect = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.TeammateEffectsList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.TeammateEffectsList, NowTeammateEffect)
end

function S:RestoreDefaultTeammateEffects()
  self:SaveTeammateEffectsOptionSetting()
end

function S:SaveTeammateEffectsOptionSetting()
  self.OptionCache = self.TeammateEffectsList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  UEMGameInstance.SetFriendFXQuality(self.OptionCache)
end

function S:UpdateTeammateEffectsDefaultValue()
  local NowContentPerformance = GWorld.GameInstance:GetGameplayScalabilityLevel()
  if NowContentPerformance <= 1 then
    self.DefaultValue = "1"
  end
end

function S:SetEffectQualityOldOptionId()
  self.EffectQualityList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local NowEffectQuality = GameUserSettings:GetVisualEffectQuality()
  self.OldOptionId = self:SetOldOptionId(self.EffectQualityList, NowEffectQuality)
end

function S:RestoreDefaultEffectQuality()
  self:SaveEffectQualityOptionSetting()
end

function S:SaveEffectQualityOptionSetting()
  self.OptionCache = self.EffectQualityList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "VisualEffectQuality", self.OptionCache)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  GameUserSettings:SetVisualEffectQuality(self.OptionCache)
  GameUserSettings:ApplySettings(true)
end

function S:SetAntiAliasingOldOptionId()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and self.CacheInfo.UnFoldTextM then
    self.AntiAliasingList = {
      [1] = 4,
      [2] = 2
    }
  else
    self.AntiAliasingList = {
      [1] = 0,
      [2] = 2,
      [3] = 4
    }
  end
  local NowAntiAliasing = URuntimeCommonFunctionLibrary.GetAntiAliasingMethodType()
  self.OldOptionId = self:SetOldOptionId(self.AntiAliasingList, NowAntiAliasing)
  EventManager:RemoveEvent(EventID.OnSwitchUpscalingMethod, self)
  EventManager:AddEvent(EventID.OnSwitchUpscalingMethod, self, self.UpdateOptionOnSwitchUpscalingMethod)
end

function S:UpdateOptionOnSwitchUpscalingMethod(OptionId)
  if 1 == OptionId then
    return
  elseif 2 == self.NowOptionId then
    return
  end
  self.RefreshByEvent = true
  self:RefreshOptionOnClick(2)
  self.RefreshByEvent = false
end

function S:RestoreDefaultAntiAliasing()
  self:SaveAntiAliasingOptionSetting()
end

function S:SaveAntiAliasingOptionSetting()
  self.OptionCache = self.AntiAliasingList[self.NowOptionId]
  UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.DefaultFeature.AntiAliasing " .. self.OptionCache)
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  if not self.RefreshByEvent then
    EventManager:FireEvent(EventID.OnSwitchAntiAliasing, self.OptionCache)
  end
end

function S:SetMaterialQualityOldOptionId()
  self.MaterialQualityList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local NowMaterialQuality = GameUserSettings:GetShadingQuality()
  self.OldOptionId = self:SetOldOptionId(self.MaterialQualityList, NowMaterialQuality)
end

function S:RestoreDefaultMaterialQuality()
  self:SaveMaterialQualityOptionSetting()
end

function S:SaveMaterialQualityOptionSetting()
  self.OptionCache = self.MaterialQualityList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "ShadingQuality", self.OptionCache)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  GameUserSettings:SetShadingQuality(self.OptionCache)
  GameUserSettings:ApplySettings(true)
end

function S:SetShadowQualityOldOptionId()
  self.ShadowQualityList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local NowShadowQuality = GameUserSettings:GetShadowQuality()
  self.OldOptionId = self:SetOldOptionId(self.ShadowQualityList, NowShadowQuality)
end

function S:RestoreDefaultShadowQuality()
  self:SaveShadowQualityOptionSetting()
end

function S:SaveShadowQualityOptionSetting()
  self.OptionCache = self.ShadowQualityList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "ShadowQuality", self.OptionCache)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  GameUserSettings:SetShadowQuality(self.OptionCache)
  GameUserSettings:ApplySettings(true)
end

function S:SetDetailDistanceOldOptionId()
  self.DetailDistanceList = {
    [1] = 0,
    [2] = 1,
    [3] = 2
  }
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local NowDetailDistance = GameUserSettings:GetViewDistanceQuality()
  self.OldOptionId = self:SetOldOptionId(self.DetailDistanceList, NowDetailDistance)
end

function S:RestoreDefaultDetailDistance()
  self:SaveDetailDistanceOptionSetting()
end

function S:SaveDetailDistanceOptionSetting()
  self.OptionCache = self.DetailDistanceList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "ViewDistanceQuality", self.OptionCache)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  GameUserSettings:SetViewDistanceQuality(self.OptionCache)
  GameUserSettings:ApplySettings(true)
end

function S:SetHUDSizeOldOptionId()
  self.HUDSizeList = {}
  for _, ValStr in ipairs(self.UnFoldTextList) do
    table.insert(self.HUDSizeList, tonumber(table.pack(string.gsub(ValStr, "%%", ""))[1]) * 0.01)
  end
  local NowHUDSize = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.HUDSizeList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.HUDSizeList, NowHUDSize)
end

function S:RestoreDefaultHUDSize()
  self:SaveHUDSizeOptionSetting()
end

function S:SaveHUDSizeOptionSetting()
  self.OptionCache = self.HUDSizeList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  UE.UUIFunctionLibrary.SetGameDPI(self.OptionCache)
end

function S:SetMaterialFilterOldOptionId()
  self.MaterialFilterList = {
    [1] = 1,
    [2] = 2,
    [3] = 4,
    [4] = 8,
    [5] = 16
  }
  local NowMaterialFilter = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.MaxAnisotropy")
  self.OldOptionId = self:SetOldOptionId(self.MaterialFilterList, NowMaterialFilter)
end

function S:RestoreDefaultMaterialFilter()
  self:SaveMaterialFilterOptionSetting()
end

function S:SaveMaterialFilterOptionSetting()
  self.OptionCache = self.MaterialFilterList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "r.MaxAnisotropy", self.OptionCache)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.MaxAnisotropy", self.OptionCache)
end

function S:SetModelDetailsOldOptionId()
  self.ModelDetailsList = {
    [1] = 1,
    [2] = 1,
    [3] = 0
  }
  local NowModelDetails = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.SkeletalMeshLODBias")
  self.OldOptionId = self:SetOldOptionId(self.ModelDetailsList, NowModelDetails)
end

function S:RestoreDefaultModelDetails()
  self:SaveModelDetailsOptionSetting()
end

function S:SaveModelDetailsOptionSetting()
  self.OptionCache = self.ModelDetailsList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "r.SkeletalMeshLODBias", self.OptionCache)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.SkeletalMeshLODBias", self.OptionCache)
end

function S:SetLocalAtomizationOldOptionId()
  self.LocalAtomizationList = {
    [1] = {
      [1] = 0,
      [2] = 1,
      [3] = 1,
      [4] = 1
    },
    [2] = {
      [2] = 32,
      [3] = 16,
      [4] = 16
    },
    [3] = {
      [2] = 16,
      [3] = 32,
      [4] = 64
    }
  }
  local NowLocalAtomization = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.VolumetricFog")
  if NowLocalAtomization == self.LocalAtomizationList[1][1] then
    self.OldOptionId = 1
  else
    NowLocalAtomization = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.VolumetricFog.GridSizeZ")
    self.OldOptionId = self:SetOldOptionId(self.LocalAtomizationList[3], NowLocalAtomization)
  end
end

function S:RestoreDefaultLocalAtomization()
  self:SaveLocalAtomizationOptionSetting()
end

function S:SaveLocalAtomizationOptionSetting()
  self.OptionCache = self.LocalAtomizationList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "r.VolumetricFog", self.LocalAtomizationList[1][self.NowOptionId])
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.VolumetricFog", self.LocalAtomizationList[1][self.NowOptionId])
  if 1 ~= self.NowOptionId then
    SettingUtils.SaveEMCache(self.EMCacheName, "r.VolumetricFog.GridPixelSize", self.LocalAtomizationList[2][self.NowOptionId])
    SettingUtils.SaveEMCache(self.EMCacheName, "r.VolumetricFog.GridSizeZ", self.LocalAtomizationList[3][self.NowOptionId])
    GWorld.GameInstance:SetGameScalabilityLevelByName("r.VolumetricFog.GridPixelSize", self.LocalAtomizationList[2][self.NowOptionId])
    GWorld.GameInstance:SetGameScalabilityLevelByName("r.VolumetricFog.GridSizeZ", self.LocalAtomizationList[3][self.NowOptionId])
  end
end

function S:SetDepthQualityOldOptionId()
  self.DepthQualityList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  local NowDepthQuality = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.DepthOfFieldQuality")
  self.OldOptionId = self:SetOldOptionId(self.DepthQualityList, NowDepthQuality)
end

function S:RestoreDefaultDepthQuality()
  self:SaveDepthQualityOptionSetting()
end

function S:SaveDepthQualityOptionSetting()
  self.OptionCache = self.DepthQualityList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "r.DepthOfFieldQuality", self.OptionCache)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.DepthOfFieldQuality", self.OptionCache)
end

function S:SetRefractiveQualityOldOptionId()
  self.RefractiveQualityList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3
  }
  local NowRefractiveQuality = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.RefractionQuality")
  self.OldOptionId = self:SetOldOptionId(self.RefractiveQualityList, NowRefractiveQuality)
end

function S:RestoreDefaultRefractiveQuality()
  self:SaveRefractiveQualityOptionSetting()
end

function S:SaveRefractiveQualityOptionSetting()
  self.OptionCache = self.RefractiveQualityList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, "r.RefractionQuality", self.OptionCache)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.RefractionQuality", self.OptionCache)
end

function S:SetScreenQualityOldOptionId()
  self.ScreenQualityList = {
    [1] = 1,
    [2] = 2,
    [3] = 4
  }
  local NowScreenQuality = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.ScreenQualityList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.ScreenQualityList, NowScreenQuality)
end

function S:RestoreDefaultScreenQuality()
  self:SaveScreenQualityOptionSetting()
end

function S:SaveScreenQualityOptionSetting()
  self.OptionCache = self.ScreenQualityList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
end

function S:SetScreenFilterOldOptionId()
  self.ScreenFilterList = {
    [1] = 1,
    [2] = 2,
    [3] = 0
  }
  local NowScreenFilter = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.ScreenFilterList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.ScreenFilterList, NowScreenFilter)
end

function S:RestoreDefaultScreenFilter()
  self:SaveScreenFilterOptionSetting()
end

function S:SaveScreenFilterOptionSetting()
  self.OptionCache = self.ScreenFilterList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self, UE4.AEnvironmentManager:StaticClass())
  EnvironmentManager = EnvironmentManager or self:GetWorld():SpawnActor(LoadClass("/Game/Asset/Scene/common/EnvirSystem/EnvirCreat.EnvirCreat_C"))
  EnvironmentManager:SetPosLUT(self.OptionCache)
end

function S:SetGamepadPresetOldOptionId()
  self.OldOptionId = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, tonumber(self.DefaultValue))
end

function S:RestoreDefaultGamepadPreset()
end

function S:SaveGamepadPresetOptionSetting()
  local RealOptionId = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, tonumber(self.DefaultValue))
  self.Parent.HasBeenChanged = RealOptionId ~= self.NowOptionId and "GamepadPresetSave" or false
  self.Parent:UpdateKeyboardBottonKey()
  self.Parent:RefreshAllGamePadOperator(self.NowOptionId)
end

function S:SaveGamepadPresetOptionSettingInLocal()
  self:SaveGamepadPreset()
end

function S:RestoreDefaultGamepadPresetInLocal()
  self.NowOptionId = 1
  self:SaveGamepadPreset()
end

function S:SaveGamepadPreset()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, tonumber(self.NowOptionId))
  if IsValid(Player) then
    Player:SwitchGamepadSet(tonumber(self.NowOptionId))
  end
  self.Text_Current:SetText(GText(self.UnFoldTextList[self.NowOptionId]))
  self.Parent:RefreshAllGamePadOperator(tonumber(self.NowOptionId))
end

function S:GetGamepadPresetOptionContentText()
  return GText("UI_OPTION_Gamepad_Preset" .. self.NowOptionId)
end

function S:RestoreOldGamepadPresetInLocal()
  self.NowOptionId = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, tonumber(self.DefaultValue))
  self:SaveGamepadPreset()
end

function S:SetFpsOldOptionId()
  self.FpsList = {
    [1] = 30,
    [2] = 45,
    [3] = 60,
    [4] = 90,
    [5] = 120,
    [6] = CommonConst.MaxFPS
  }
  local NowFps = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.FpsList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.FpsList, NowFps)
end

function S:RestoreDefaultFps()
  self:SaveFpsOptionSetting()
end

function S:SaveFpsOptionSetting()
  self.OptionCache = self.FpsList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  local FramePace = self.OptionCache
  if 45 == self.OptionCache then
    FramePace = 60
  end
  if self.OptionCache == CommonConst.MaxFPS then
    GWorld.GameInstance:SetUnfixedFrameRate()
  else
    GameUserSettings:SetFrameRateLimit(self.OptionCache)
    GameUserSettings:ApplySettings(true)
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.SetFramePace " .. FramePace, nil)
  end
  DebugPrint("---jzn---SaveFpsOptionSetting----", self.OptionCache)
end

function S:Handle_KeyDownOnGamePad(InKeyName)
  return false
end

function S:Handle_KeyUpOnGamePad(InKeyName)
end

function S:Gamepad_SetHovered(bIsHovered)
end

function S:OnMainBtnClicked()
  if UIUtils.IsGamepadInput() then
    self:OnClickSubOptionList()
  end
end

function S:OnMainBtnHovered()
  self.BottomKeyInfos = {
    {
      UIConst.GamePadImgKey.FaceButtonBottom,
      GText("UI_Tips_Ensure")
    },
    {
      UIConst.GamePadImgKey.FaceButtonRight,
      GText("UI_BACK")
    }
  }
  self.Parent:UpdateBottomKey(self.BottomKeyInfos)
end

function S:OnSubBtnHovered()
  self.BottomKeyInfos = {
    {
      UIConst.GamePadImgKey.FaceButtonBottom,
      GText("UI_Tips_Ensure")
    },
    {
      UIConst.GamePadImgKey.FaceButtonRight,
      GText("UI_BACK")
    }
  }
  self.Parent:UpdateBottomKey(self.BottomKeyInfos)
end

function S:GetBottomKeyInfos()
  return self.BottomKeyInfos or {}
end

function S:GetFirstWidgetToNavigate()
  return self.Bg_Set
end

function S:GetLastWidgetToNavigate()
  return self.Bg_Set
end

function S:SetSystemVoiceOldOptionId()
  self:RefreshVoiceTextInfo()
  local CacheName = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.VoiceTextMap[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.VoiceTextMap, CacheName)
  EventManager:RemoveEvent(EventID.RefreshVoiceName, self)
  EventManager:AddEvent(EventID.RefreshVoiceName, self, self.SaveSystemVoiceCallBack)
end

function S:RefreshVoiceTextInfo()
  self.VoiceTextMap = {}
  local CacheName = TArray("")
  for Index, Text in ipairs(self.UnFoldTextList) do
    local EndVoiceName = string.split(Text, "_")
    self.VoiceTextMap[Index] = EndVoiceName[#EndVoiceName]
    CacheName:Add(self.VoiceTextMap[Index])
  end
  local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
  self.VoiceDownloadedRes = HotUpdateSubsystem:IsVoicesDownloaded(CacheName):ToTable()
end

function S:SetVoiceResByIndex(Index, Res)
  if not self.VoiceTextMap then
    return
  end
  if not self.VoiceTextMap[Index] then
    return
  end
  self.VoiceDownloadedRes[self.VoiceTextMap[Index]] = Res
end

function S:GetVoiceResByIndex(Index)
  if not Index then
    return
  end
  if not self.VoiceTextMap then
    return
  end
  if not self.VoiceTextMap[Index] then
    return
  end
  return self.VoiceDownloadedRes[self.VoiceTextMap[Index]]
end

function S:RestoreDefaultSystemVoice()
  self:SaveSystemVoiceOptionSetting()
end

function S:CheckSystemVoiceOptionSetting(SelectOptionId)
  self.CheckSelectOptionId = SelectOptionId
  if self:GetVoiceResByIndex(SelectOptionId) then
    return true
  else
    self:ShowVoiceResourcePopup(self.CheckSelectOptionId)
    return false
  end
end

function S:SaveSystemVoiceOptionSetting()
  self.OptionCache = self.VoiceTextMap[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  self.Text_Current:SetText(GText(self.UnFoldTextList[self.NowOptionId]))
  CommonConst.SystemVoice = self.OptionCache
  AudioManager(self):SetVoiceLanguage(CommonConst.SystemVoice)
end

function S:SaveSystemVoiceCallBack()
  self:RefreshVoiceTextInfo()
  if self.CheckSelectOptionId then
    if self:GetVoiceResByIndex(self.CheckSelectOptionId) then
      self:RefreshOptionOnClick(self.CheckSelectOptionId)
    elseif self:GetVoiceResByIndex(self.NowOptionId) then
      self:RefreshOptionOnClick(self.NowOptionId)
    else
      self:RefreshOptionOnClick(1)
    end
    self.CheckSelectOptionId = nil
  elseif not self:GetVoiceResByIndex(self.NowOptionId) then
    self:RestoreDefaultOptionSet()
  end
end

function S:ShowVoiceResourcePopup(InSelectOptionId)
  local SelectOptionId = InSelectOptionId
  local UsedLanguageIndex
  if not self.VoiceTextMap then
    self.VoiceTextMap = {}
    for Index, Text in ipairs(self.UnFoldTextList) do
      local EndVoiceName = string.split(Text, "_")
      self.VoiceTextMap[Index] = EndVoiceName[#EndVoiceName]
    end
  end
  for k, v in pairs(self.VoiceTextMap) do
    if v == CommonConst.SystemVoice then
      UsedLanguageIndex = k
      if not SelectOptionId then
        SelectOptionId = k
      end
      break
    end
  end
  local PopUPUI
  
  local function ClickFunction(_, PakckageData)
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
      return
    end
    if not PakckageData then
      return
    end
    local Data = PakckageData.Content_1
    if not Data then
      return
    end
    PopUPUI.DontCloseWhenRightBtnClicked = false
    local OptionalPatchAssetState = Data.OptionalPatchAssetState
    if OptionalPatchAssetState == EOptionalPatchAssetState.Downloading then
      PopUPUI.DontCloseWhenRightBtnClicked = true
      local bPaused = HotUpdateSubsystem:IsPatchOptionSignPaused(Data.OptionalPatchAssetSign)
      if bPaused then
        HotUpdateSubsystem:TryStartUpdate(Data.OptionalPatchAssetSign, {
          Data.OptionalPatchAssetSign
        }, true)
      else
        if not HotUpdateSubsystem:PauseDownloadOptionalPatchAssets(Data.OptionalPatchAssetSign, Data.OptionalPatchAssetSign) then
          UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_OPTION_Language_Pause_Unable"))
        end
        PopUPUI.Contents[1]:RefreshDownloadedVoiceState(false)
      end
    elseif OptionalPatchAssetState == EOptionalPatchAssetState.Downloaded then
      self:ShowUninstallPopup(Data.OptionalPatchAssetSign, Data.CurrentIndex, PopUPUI)
    elseif Data.BytesSoFar > 0 then
      HotUpdateSubsystem:TryStartUpdate(Data.OptionalPatchAssetSign, {
        Data.OptionalPatchAssetSign
      }, true)
    else
      self:ShowDownloadPopup(Data.OptionalPatchAssetSign, Data.OptionalPatchAssetSign, Data.CurrentIndex, Data.TotalBytes)
    end
  end
  
  local Params = {
    OptionText = self.UnFoldTextList,
    Options = self.VoiceTextMap,
    CurrentLanguageIndex = SelectOptionId or 1,
    CurrentUseLanguageIndex = UsedLanguageIndex or 1,
    RightCallbackFunction = ClickFunction,
    ForbiddenRightCallbackFunction = ClickFunction,
    OnCloseCallbackFunction = function()
      self:SaveSystemVoiceCallBack()
    end
  }
  PopUPUI = UIManager(self):ShowCommonPopupUI(100254, Params)
end

function S:ShowDownloadPopup(DownloadTag, PatchSign, InCurrentIndex, TotalBytes)
  local TotalMB = TotalBytes / 1024 / 1024
  if TotalMB < 1 then
    TotalMB = 1
  end
  TotalMB = math.ceil(TotalMB)
  local Params = {
    ShortText = string.format(GText("UI_OPTION_Language_Download_Confirm"), GText(self.UnFoldTextList[InCurrentIndex]), TotalMB),
    DontPlayOutAnimation = true,
    RightCallbackFunction = function()
      local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
      if not HotUpdateSubsystem then
        return
      end
      HotUpdateSubsystem:TryStartUpdate(DownloadTag, {PatchSign}, true)
      self:ShowVoiceResourcePopup(InCurrentIndex)
    end,
    LeftCallbackFunction = function()
      self:ShowVoiceResourcePopup(InCurrentIndex)
    end,
    CloseBtnCallbackFunction = function()
      self:ShowVoiceResourcePopup(InCurrentIndex)
    end
  }
  UIManager(self):ShowCommonPopupUI(100255, Params)
end

function S:ShowUninstallPopup(PatchSign, InCurrentIndex, PopUI)
  local CurrentSelectOptionId = self.CheckSelectOptionId or 1
  for k, v in pairs(self.VoiceTextMap) do
    if v == CommonConst.SystemVoice then
      CurrentSelectOptionId = k
      break
    end
  end
  if CurrentSelectOptionId == InCurrentIndex then
    PopUI.DontCloseWhenRightBtnClicked = true
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_OPTION_Language_Unload_Using"))
    return
  end
  local Params = {
    ShortText = string.format(GText("UI_OPTION_Language_Unload_Confirm"), GText(self.UnFoldTextList[InCurrentIndex])),
    DontPlayOutAnimation = true,
    RightCallbackFunction = function()
      local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UHotUpdateSubsystem)
      if not HotUpdateSubsystem then
        return
      end
      if not HotUpdateSubsystem:UninstallOptionalPatchAssets(PatchSign) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_OPTION_Language_Unload_Fail"))
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_OPTION_Language_Unload_Success"))
      end
      self:ShowVoiceResourcePopup(InCurrentIndex)
    end,
    LeftCallbackFunction = function()
      self:ShowVoiceResourcePopup(InCurrentIndex)
    end,
    CloseBtnCallbackFunction = function()
      self:ShowVoiceResourcePopup(InCurrentIndex)
    end
  }
  UIManager(self):ShowCommonPopupUI(100256, Params)
end

function S:SetMobileResolutionOldOptionId()
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "Android" == PlatformName then
    self.MobileResolutionList = {
      [1] = {
        80,
        65,
        648
      },
      [2] = {
        85,
        65,
        684
      },
      [3] = {
        90,
        70,
        720
      },
      [4] = {
        95,
        75,
        764
      },
      [5] = {
        115,
        80,
        900
      }
    }
  elseif "IOS" == PlatformName then
    self.MobileResolutionList = {
      [1] = {
        55,
        55,
        0
      },
      [2] = {
        60,
        60,
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
      },
      [5] = {
        85,
        85,
        0
      }
    }
  else
    DebugPrint(ErrorTag, "----jzn---移动端分辨率 当前平台不是Anroid或IOS----", PlatformName)
  end
  self.OldOptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
end

function S:RestoreDefaultMobileResolution()
  self:SaveMobileResolutionOptionSetting()
end

function S:SaveMobileResolutionOptionSetting()
  self.OptionCache = self.MobileResolutionList[self.NowOptionId]
  if not self.OptionCache then
    return
  end
  GWorld.GameInstance.SetScreenPercentageLevel(self.OptionCache[1], self.OptionCache[2], self.OptionCache[3])
  SettingUtils.SaveEMCache(self.CacheName, self.EMCacheKey, self.NowOptionId)
end

function S:SetRayTracingOldOptionId()
  if SettingUtils.IsOpenRayTracing() then
    self.OldOptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.OldOptionId = 0
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function S:RestoreDefaultRayTracing()
  self:SaveRayTracingOptionSetting()
end

function S:SaveRayTracingOptionSetting()
  if not SettingUtils.IsOpenRayTracing() then
    return
  end
  local LastOptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
  local IsOpen = self.NowOptionId > 1 and true or false
  local RayTracingShadowsEnabled = UE4.URuntimeCommonFunctionLibrary.GetRayTracingShadowsEnabled()
  UE4.URuntimeCommonFunctionLibrary.SetRayTracingShadowsEnabled(IsOpen)
  if IsOpen ~= RayTracingShadowsEnabled and IsOpen and 1 == LastOptionId then
    self:ShowRebootPop()
  end
  SettingUtils.SaveEMCache(self.CacheName, self.EMCacheKey, self.NowOptionId)
end

function S:ShowRebootPop()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local Params = {
    RightCallbackObj = self,
    RightCallbackFunction = self.RayReboot
  }
  UIManager:ShowCommonPopupUI(100271, Params)
end

function S:RayReboot()
  AHotUpdateGameMode.CreateRestartFile()
end

function S:SetUpscalingMethodOldOptionId()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.OptionId2SuperResolutionType = {
      ESuperResolutionType.MinValue,
      ESuperResolutionType.MobileFSR,
      ESuperResolutionType.GSR
    }
  else
    self.OptionId2SuperResolutionType = {
      ESuperResolutionType.MinValue,
      ESuperResolutionType.DLSS,
      ESuperResolutionType.FSR,
      ESuperResolutionType.XeSS
    }
  end
  local OptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
  local ScreenPercentage = UE4.UKismetSystemLibrary.GetConsoleVariableFloatValue("r.ScreenPercentage")
  if 100 ~= ScreenPercentage and CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    OptionId = 1
  end
  local UpscalingMethod = self:GetUpscalingMethodByOptionId(OptionId)
  self.UpscalingMethod, self.OldOptionId = self:GetCanSetOptionId(UpscalingMethod, OptionId)
  EventManager:RemoveEvent(EventID.OnSwitchAntiAliasing, self)
  EventManager:AddEvent(EventID.OnSwitchAntiAliasing, self, self.UpdateOptionOnSwitchAntiAliasing)
  EventManager:RemoveEvent(EventID.OnSwitchRendering, self)
  EventManager:AddEvent(EventID.OnSwitchRendering, self, self.UpdateOptionOnOnSwitchRendering)
  local NowAntiAliasing = URuntimeCommonFunctionLibrary.GetAntiAliasingMethodType()
  if 2 ~= NowAntiAliasing then
    self.OptionContent:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.OptionContent:SetVisibility(UE4.ESlateVisibility.Visible)
  end
end

function S:UpdateOptionOnSwitchAntiAliasing(AntiAliasingType)
  if 2 == AntiAliasingType then
    local OptionContentVis = self.OptionContent:GetVisibility()
    if OptionContentVis == UE4.ESlateVisibility.Collapsed then
      self.RefreshByEvent = true
      self:RestoreDefaultOptionSet()
      self.RefreshByEvent = false
      self.OptionContent:SetVisibility(UE4.ESlateVisibility.Visible)
    end
    return
  elseif 1 == self.NowOptionId then
    self.OptionContent:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.OptionContent:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function S:UpdateOptionOnOnSwitchRendering(RenderingOptionId)
  if 2 ~= RenderingOptionId and 1 ~= self.NowOptionId then
    self.RefreshByEvent = true
    self:RestoreDefaultOptionSet()
    self.RefreshByEvent = false
  end
end

function S:RestoreDefaultUpscalingMethod()
  local NowAntiAliasing = URuntimeCommonFunctionLibrary.GetAntiAliasingMethodType()
  if 2 == NowAntiAliasing and 1 ~= self.NowOptionId then
    self:RefreshOptionOnClick(1)
  else
    self:SaveUpscalingMethodOptionSetting()
  end
end

function S:SaveUpscalingMethodOptionSetting()
  local UpscalingMethod = self:GetUpscalingMethodByOptionId(self.NowOptionId)
  self.UpscalingMethod, self.NowOptionId = self:GetCanSetOptionId(UpscalingMethod, self.NowOptionId)
  SettingUtils.SaveEMCache(self.CacheName, self.EMCacheKey, self.NowOptionId)
  SettingUtils.SaveEMCache("UpscalingMethodValue", nil, UpscalingMethod)
  if not self.RefreshByEvent then
    EventManager:FireEvent(EventID.OnSwitchUpscalingMethod, self.NowOptionId)
  end
end

function S:GetUpscalingMethodByOptionId(OptionId)
  return self.OptionId2SuperResolutionType[OptionId]
end

function S:GetCanSetOptionId(CurUpscalingMethod, CurOption)
  local UpscalingMethod = CurUpscalingMethod
  local OptionId = CurOption
  if not USRMBlueprintLibrary.IsSRTypeAvailable(UpscalingMethod) then
    OptionId = 1
    for i = 2, #self.OptionId2SuperResolutionType do
      local Type = self.OptionId2SuperResolutionType[i]
      if USRMBlueprintLibrary.IsSRTypeAvailable(Type) then
        UpscalingMethod = Type
        OptionId = i
      end
    end
  end
  return UpscalingMethod, OptionId
end

function S:SetShowPlayerNameOldOptionId()
  self.ShowPlayerNameOptionList = {
    [1] = EMainPlayerNameWidgetOption.ENotShow,
    [2] = EMainPlayerNameWidgetOption.EOnlyInRegionOnline,
    [3] = EMainPlayerNameWidgetOption.EAlwaysShow
  }
  local NowShowPlayerNameOption = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.ShowPlayerNameOptionList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.ShowPlayerNameOptionList, NowShowPlayerNameOption)
end

function S:RestoreDefaultShowPlayerName()
  self:SaveShowPlayerNameOptionSetting()
end

function S:SaveShowPlayerNameOptionSetting()
  self.OptionCache = self.ShowPlayerNameOptionList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player and self.OptionCache then
    Player:ChangeNameWidgetOption(self.OptionCache)
  end
end

function S:SetWaterQualityOldOptionId()
  self.OldOptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
end

function S:RestoreDefaultWaterQuality()
  self:SaveWaterQualityOptionSetting()
end

function S:SaveWaterQualityOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowOptionId)
  URuntimeCommonFunctionLibrary.SetWaterQuality(math.tointeger(self.NowOptionId - 1))
end

function S:SetPlantEnhanceOldOptionId()
  self.PlantEnhanceOptionList = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4
  }
  local PlantEnhanceOption = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.PlantEnhanceOptionList[tonumber(self.DefaultValue)])
  self.OldOptionId = self:SetOldOptionId(self.PlantEnhanceOptionList, PlantEnhanceOption)
end

function S:RestoreDefaultPlantEnhance()
  self:SavePlantEnhanceOptionSetting()
end

function S:SavePlantEnhanceOptionSetting()
  self.OptionCache = self.PlantEnhanceOptionList[self.NowOptionId]
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.OptionCache)
  local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
  if WorldCompositionSubSystem then
    WorldCompositionSubSystem:SetFoliageLevel(self.OptionCache)
  end
end

function S:SetRenderingOldOptionId()
  self.RenderingOptionList = {
    90,
    100,
    110,
    120
  }
  local SRTypeAndQualityMode = USRMBlueprintLibrary.GetActiveSRTypeAndQualityMode()
  if 0 == SRTypeAndQualityMode.SRType then
    self.OldOptionId = SettingUtils.GetEMCache(self.CacheName, self.EMCacheKey, tonumber(self.DefaultValue))
  else
    self.OldOptionId = 2
  end
  EventManager:RemoveEvent(EventID.OnSwitchUpscalingMethod, self)
  EventManager:AddEvent(EventID.OnSwitchUpscalingMethod, self, self.UpdateRenderingOptionSetting)
end

function S:RestoreDefaultRendering()
  local SRTypeAndQualityMode = USRMBlueprintLibrary.GetActiveSRTypeAndQualityMode()
  if 0 ~= SRTypeAndQualityMode.SRType and 2 ~= self.NowOptionId then
    self:RefreshOptionOnClick(2)
  else
    self:SaveRenderingOptionSetting()
  end
end

function S:SaveRenderingOptionSetting()
  local RenderingValue = self.RenderingOptionList[self.NowOptionId]
  if not RenderingValue then
    return
  end
  UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.ScreenPercentage " .. RenderingValue)
  SettingUtils.SaveEMCache(self.CacheName, self.EMCacheKey, self.NowOptionId)
  if not self.RefreshByEvent then
    EventManager:FireEvent(EventID.OnSwitchRendering, self.NowOptionId)
  end
end

function S:UpdateRenderingOptionSetting(OptionId)
  if 1 ~= OptionId and 2 ~= self.NowOptionId then
    self.RefreshByEvent = true
    self:RefreshOptionOnClick(2)
    self.RefreshByEvent = false
  end
end

return S
