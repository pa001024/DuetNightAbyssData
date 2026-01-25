require("UnLua")
local S = Class("BluePrints.UI.BP_EMUserWidget_C")
local EMCache = require("EMCache.EMCache")
local SettingUtils = require("Utils.SettingUtils")

function S:Construct()
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
end

function S:Init(Parent, CacheName, CacheInfo)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  rawset(self, "Parent", Parent.Content and Parent.Content.ParentWidget.Parent or Parent)
  rawset(self, "CacheName", CacheName)
  rawset(self, "CacheInfo", CacheInfo)
  rawset(self, "SlideMinValue", CacheInfo.ScrollNum[1])
  rawset(self, "SlideMaxValue", CacheInfo.ScrollNum[2])
  rawset(self, "ScrollMappingScale", CacheInfo.ScrollMappingScale)
  rawset(self, "SlideDefaultValue", tonumber(self.CacheInfo.DefaultValue))
  rawset(self, "DefaultValue", CacheInfo.DefaultValue)
  rawset(self, "NowValue", 1)
  rawset(self, "OldValue", 1)
  rawset(self, "LastValue", 1)
  self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
  self.SlideMinValue = self.CacheInfo.ScrollNum[1]
  self.SlideMaxValue = self.CacheInfo.ScrollNum[2]
  self.ScrollMappingScale = self.CacheInfo.ScrollMappingScale
  self.SlideDefaultValue = tonumber(self.CacheInfo.DefaultValue)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and self.CacheInfo.DefaultValueM then
    self.SlideDefaultValue = tonumber(self.CacheInfo.DefaultValueM)
  end
  self:SetHoverVisibility()
  self:SetOldValue()
  self.NowValue = self.OldValue
  self.LastValue = self.NowValue
  self:InitSliderConfig()
  self:UpdateSlide(self.NowValue)
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
  self:UpdateUIStyleInPlatform(false)
end

function S:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self:UpdateUIStyleInPlatform(false)
end

function S:UpdateUIStyleInPlatform(IsGamepad)
  local CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self.Com_Slider:UpdateUIStyleInPlatform(IsGamepad, CurGamepadName)
end

function S:InitSliderConfig(...)
  local Config = {
    InitValue = self.NowValue,
    MinValue = self.SlideMinValue,
    MaxValue = self.SlideMaxValue,
    ClickInterval = 1,
    MinusBtnCallback = self.OnBtnMinusClicked,
    AddBtnCallback = self.OnBtnAddClicked,
    SliderChangeCallback = self.UpdateSlide,
    OwnerPanel = self,
    bDisableAutoHandleInputDeviceChange = true,
    bForbidPressAccelerate = true
  }
  self.Com_Slider:Init(Config)
end

function S:Handle_KeyDownOnGamePad(InKeyName)
  local IsHandled = self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
  return IsHandled
end

function S:Handle_KeyUpOnGamePad(InKeyName)
  local IsHandled = self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
  return IsHandled
end

function S:Gamepad_SetHovered(bIsHovered)
  self:UpdateUIStyleInPlatform(bIsHovered)
  if not bIsHovered then
    self.Com_Slider:TriggerKeyUpEvent()
  end
end

function S:GetBottomKeyInfos()
  return {
    {
      UIConst.GamePadImgKey.FaceButtonRight,
      GText("UI_BACK")
    }
  }
end

function S:GetFirstWidgetToNavigate()
  return self
end

function S:GetLastWidgetToNavigate()
  return self
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
  self:OnBtnAreaHover()
end

function S:OnMouseLeave(MyGeometry, MouseEvent)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  self.Parent:RemoveHoverContent(self)
  self:OnBtnAreaUnHover()
end

function S:OnBtnAreaHover()
  self.Bg_Set:StopAnimation(self.Bg_Set.UnHover)
  self.Bg_Set:PlayAnimation(self.Bg_Set.Hover)
end

function S:OnBtnAreaUnHover()
  self.Bg_Set:StopAnimation(self.Bg_Set.Hover)
  self.Bg_Set:PlayAnimation(self.Bg_Set.UnHover)
end

function S:UpdateSlide(NewNum)
  self.Parent:ClearSettingListUnfoldState()
  self.Parent:SetSettingUnfoldListPC(false)
  self.LastValue = self.NowValue
  local SlideValue = math.floor(math.max(self.SlideMinValue, math.min(NewNum, self.SlideMaxValue)))
  self.NowValue = SlideValue
  self.Text_Num:SetText(SlideValue / self.ScrollMappingScale)
  self:SaveOptionSetting()
end

function S:OnBtnDragClicked()
  self.Parent:OnClickAllLeftMouseButton()
end

function S:OnBtnMinusClicked()
  self:UpdateSlide(self.NowValue - 1.0)
end

function S:OnBtnAddClicked()
  self:UpdateSlide(self.NowValue + 1.0)
end

function S:SetOldValue()
  if self.CacheName == nil then
    self.OldValue = math.floor(self.SlideDefaultValue)
    return
  end
  self.EMCacheName = self.CacheInfo.EMCacheName
  self.EMCacheKey = self.CacheInfo.EMCacheKey
  if self["Set" .. self.CacheName .. "OldValue"] then
    self["Set" .. self.CacheName .. "OldValue"](self)
  elseif self.EMCacheName then
    self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, math.floor(self.SlideDefaultValue))
  end
end

function S:RestoreDefaultOptionSet()
  self.OldValue = math.floor(self.SlideDefaultValue)
  self.NowValue = self.OldValue
  self:InitSliderConfig()
  self:UpdateSlide(self.NowValue)
  self:SaveOptionSetting()
end

function S:SaveOptionSetting()
  if self.CacheName == nil then
    return
  end
  self.OldValue = self.NowValue
  if self["Save" .. self.CacheName .. "OptionSetting"] then
    self["Save" .. self.CacheName .. "OptionSetting"](self)
  end
end

function S:SetTotalVolumeOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveTotalVolumeOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SetMusicVolumeOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SetMusicVolumeSetting()
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SaveMusicVolumeOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SetVoiceVolumeOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SetVoiceVolumeSetting()
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SaveVoiceVolumeOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SetSoundVolumeOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SetSoundVolumeSetting()
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SaveSoundVolumeOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  AudioManager(self):SetBusVolume(self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
end

function S:SetHorizontalSensitivityOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveHorizontalSensitivityOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
end

function S:SetHorizontalSensitivityOnShootingOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveHorizontalSensitivityOnShootingOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
end

function S:SetVerticalSensitivityOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveVerticalSensitivityOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
end

function S:SetVerticalSensitivityOnShootingOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveVerticalSensitivityOnShootingOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity(true)
end

function S:UpdateSensitivity()
  local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
  Player:UpdateCameraSensitivityFromCache()
  Player:SetPlayerCameraSensitivityByType("Normal")
end

function S:SetSpringArmRateOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveSpringArmRateOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(Player) then
    Player:SetDefaultSpringArmRate(self.NowValue / self.ScrollMappingScale)
  end
end

function S:SetGamePadHorizontalSensitivityOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveGamePadHorizontalSensitivityOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
end

function S:SetGamePadVerticalSensitivityOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveGamePadVerticalSensitivityOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
  local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
end

function S:SetGamePadHorizontalSensitivityOnShootingOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveGamePadHorizontalSensitivityOnShootingOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
  local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
end

function S:SetGamePadVerticalSensitivityOnShootingOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveGamePadVerticalSensitivityOnShootingOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  self:UpdateSensitivity()
end

function S:SetDamageTextAmountOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveDamageTextAmountOptionSetting()
  local JumpWordManager = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UJumpWordManager)
  if JumpWordManager then
    JumpWordManager:SetMaxJumpWordCountRatio(self.NowValue / self.ScrollMappingScale)
    SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  end
end

function S:SetDamageTextScaleOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
end

function S:SaveDamageTextScaleOptionSetting()
  local JumpWordManager = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UJumpWordManager)
  if JumpWordManager then
    JumpWordManager:SetJumpWordSize(self.NowValue / self.ScrollMappingScale)
    SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
  end
end

return S
