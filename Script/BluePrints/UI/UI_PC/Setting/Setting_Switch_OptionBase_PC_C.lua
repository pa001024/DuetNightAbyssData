require("UnLua")
local SettingUtils = require("Utils.SettingUtils")
local S = Class("BluePrints.UI.BP_EMUserWidget_C")

function S:Construct()
  self.Button_Area.OnClicked:Add(self, self.OnBtnAreaClicked)
  self.Button_Area.OnHovered:Add(self, self.OnBtnAreaHover)
  self.Button_Area.OnUnhovered:Add(self, self.OnBtnAreaUnHover)
  self.Bg_Set.Button_Base.OnClicked:Add(self, self.OnMainBtnClicked)
  self.Bg_Set.Button_Base.OnHovered:Add(self, self.OnMainBtnHovered)
end

function S:Init(Parent, CacheName, CacheInfo, Content)
  rawset(self, "Parent", Parent.Content.ParentWidget and Parent.Content.ParentWidget.Parent or Parent.Content.ParentWidget or Parent)
  rawset(self, "CacheName", CacheName)
  rawset(self, "CacheInfo", CacheInfo)
  rawset(self, "DefaultValue", CacheInfo.DefaultValue)
  rawset(self, "HasBeenForbidden", false)
  rawset(self, "SubListOffset", 15)
  rawset(self, "NowValue", true)
  rawset(self, "OldValue", true)
  rawset(self, "CurOptionContent", Content)
  self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and self.CacheInfo.DefaultValueM then
    self.DefaultValue = self.CacheInfo.DefaultValueM
  end
  self:SetOldValue()
  self:SetHoverVisibility()
  self:PlaySwitchAnimation(self.OldValue)
  self.Text_Close:SetText(GText(self.CacheInfo.SwitchText[1]))
  self.Text_Open:SetText(GText(self.CacheInfo.SwitchText[2]))
  if self.CacheName == "SecondaryPassword" then
    ReddotManager.AddListenerEx("Setting_SecPassword", self, self.OnSecPasswordReddotChange)
  end
  if self.CacheName == "BulletJumpCamAdjust" then
    ReddotManager.AddListenerEx("Setting_Control_Setting_SaveBulletJumpCamAdjustBtn", self, self.RedDotChange)
  end
  if self.CacheName == "AutoBulletJumpCam" then
    ReddotManager.AddListenerEx("Setting_Control_Setting_SaveAutoBulletJumpCamBtn", self, self.RedDotChange)
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
  self.Bg_Set:StopAnimation(self.Bg_Set.Hover)
  self.Bg_Set:PlayAnimation(self.Bg_Set.UnHover)
end

function S:OnBtnDragClicked()
  self.Parent:OnClickAllLeftMouseButton()
end

function S:PlaySwitchAnimation(IsOpen)
  if IsOpen then
    self:PlayAnimation(self.Open)
  else
    self:PlayAnimation(self.Close)
  end
end

function S:SetOldValue()
  self.EMCacheName = self.CacheInfo.EMCacheName
  self.EMCacheKey = self.CacheInfo.EMCacheKey
  if self.DefaultValue == "True" then
    self.DefaultValue = true
  else
    self.DefaultValue = false
  end
  if self["Set" .. self.CacheName .. "OldValue"] then
    self["Set" .. self.CacheName .. "OldValue"](self)
  else
    self.OldValue = self.DefaultValue
  end
  self.NowValue = self.OldValue
  if self.EMCacheName == "GameUserSettings" or self.EMCacheName == "ConsoleVariable" then
    self["Save" .. self.CacheName .. "OptionSetting"](self)
  end
end

function S:GetOldValue(List, NowSet)
  if List[1] == NowSet then
    return false
  elseif List[2] == NowSet then
    return true
  else
    return self.DefaultValue
  end
end

function S:GetNowValue(List)
  if self.NowValue then
    return List[2]
  else
    return List[1]
  end
end

function S:OnBtnAreaClicked()
  self:SetSwitcher(not self.NowValue)
end

function S:SetSwitcher(bValue)
  if bValue == self.NowValue then
    return
  end
  self.Parent:ClearSettingListUnfoldState()
  self.Parent:SetSettingUnfoldListPC(false)
  UIUtils.PlayCommonBtnSe(self)
  if bValue then
    self:StopAnimation(self.Close)
    self:PlayAnimation(self.Open)
  else
    self:StopAnimation(self.Open)
    self:PlayAnimation(self.Close)
  end
  self.NowValue = bValue
  self:SaveOptionSetting()
end

function S:InitMiniSubOptionList()
  self.Parent.WBP_Set_UnfoldList.SubOption_List:ClearListItems()
  for key, value in pairs(self.MiniOptionTextList) do
    local OptionContent = NewObject(UIUtils.GetCommonItemContentClass())
    OptionContent.Id = key
    OptionContent.Text = GText(value)
    OptionContent.ParentWidget = self
    OptionContent.SelectedOptionId = self.NowMiniOptionId
    OptionContent.ClickCallBack = "OnClickChangeMiniOption"
    self.Parent.WBP_Set_UnfoldList.SubOption_List:AddItem(OptionContent)
  end
end

function S:OnClickChangeMiniOption(SelectOptionId)
  if not self.HaveMiniOption then
    return
  end
  if self.NowMiniOptionId ~= SelectOptionId then
    self.Parent:ChangeUnfoldListSelection(SelectOptionId)
  end
  self.NowMiniOptionId = SelectOptionId
end

function S:RestoreDefaultOptionValue()
  self.OldValue = self.DefaultValue
  self.NowValue = self.OldValue
end

function S:RestoreDefaultOptionSet()
  local PreNowValue = self.NowValue
  self:RestoreDefaultOptionValue()
  if self["RestoreDefault" .. self.CacheName .. "OptionSet"] then
    self["RestoreDefault" .. self.CacheName .. "OptionSet"](self)
  end
  if PreNowValue ~= self.NowValue then
    self:PlaySwitchAnimation(self.NowValue)
  end
end

function S:SaveOptionSetting()
  if self["Save" .. self.CacheName .. "OptionSetting"] then
    self["Save" .. self.CacheName .. "OptionSetting"](self)
    if self.EMCacheName == "GameUserSettings" or self.EMCacheName == "ConsoleVariable" then
      GWorld.GameInstance.SetOverallScalabilityLevelSimple(CommonConst.OverallPerformanceCustom)
      if self.Parent.OverallPreset then
        self.Parent.OverallPreset:RefreshOverallPreset()
      end
    end
    self.OldValue = self.NowValue
  else
    self.OldValue = self.DefaultValue
  end
end

function S:SaveMiniOptionSetting()
  if self["Save" .. self.CacheName .. "MiniOptionSetting"] then
    self["Save" .. self.CacheName .. "MiniOptionSetting"](self)
  end
end

function S:ClearOpenListState()
  if self.IsListOpen then
    self.IsListOpen = false
    self:PlayAnimationReverse(self.Openlist)
  end
end

function S:SetAimAssistOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultAimAssistOptionSet()
  self:SaveAimAssistOptionSetting()
end

function S:SaveAimAssistOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:UpdateOpenHelperAim(self.NowValue)
end

function S:SetUpdateOpenLockAimOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultUpdateOpenLockAimOptionSet()
  self:SaveUpdateOpenLockAimOptionSetting()
end

function S:SaveUpdateOpenLockAimOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:UpdateOpenLockAim(self.NowValue)
end

function S:SetFallAttackDirectionOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultFallAttackDirectionOptionSet()
  self:SaveFallAttackDirectionOptionSetting()
end

function S:SaveFallAttackDirectionOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:UpdateEnableFallAtkDir(self.NowValue)
  self.OldValue = self.NowValue
end

function S:SetMuteBackstageOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultMuteBackstageOptionSet()
  self:SaveMuteBackstageOptionSetting()
end

function S:SaveMuteBackstageOptionSetting()
  if self.NowValue then
    AudioManager(self):BindLogicToWindowActivatedDeactivated()
  else
    AudioManager(self):UnBindLogicToWindowActivatedDeactivated()
  end
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetCameraYawFollowOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultCameraYawFollowOptionSet()
  self:SaveCameraYawFollowOptionSetting()
end

function S:SaveCameraYawFollowOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:SwitchCameraYawFollow(self.NowValue)
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetShowMonsterNameOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultShowMonsterNameOptionSet()
  self:SaveShowMonsterNameOptionSetting()
end

function S:SaveShowMonsterNameOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  UE4.UMainBar.SetIsShowMonsterName(self.NowValue)
end

function S:SetDynamicReflectionOldValue()
  self.DynamicReflectionList = {
    [1] = 0,
    [2] = 3
  }
  local NowDynamicReflection = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.SSR.Quality")
  self.OldValue = self:GetOldValue(self.DynamicReflectionList, NowDynamicReflection)
end

function S:RestoreDefaultDynamicReflectionOptionSet()
  self:SaveDynamicReflectionOptionSetting()
end

function S:SaveDynamicReflectionOptionSetting()
  local NowDynamicReflection = self:GetNowValue(self.DynamicReflectionList)
  SettingUtils.SaveEMCache(self.EMCacheName, "r.SSR.Quality", NowDynamicReflection)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.SSR.Quality", NowDynamicReflection)
end

function S:SetProjectionEdgeStainingOldValue()
  self.ProjectionEdgeStainingList = {
    [1] = 0,
    [2] = 1
  }
  local NowProjectionEdgeStaining = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.PostProcessing.ShadowRim")
  self.OldValue = self:GetOldValue(self.ProjectionEdgeStainingList, NowProjectionEdgeStaining)
end

function S:RestoreDefaultProjectionEdgeStainingOptionSet()
  self:SaveProjectionEdgeStainingOptionSetting()
end

function S:SaveProjectionEdgeStainingOptionSetting()
  local NowProjectionEdgeStaining = self:GetNowValue(self.ProjectionEdgeStainingList)
  SettingUtils.SaveEMCache(self.EMCacheName, "r.PostProcessing.ShadowRim", NowProjectionEdgeStaining)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.PostProcessing.ShadowRim", NowProjectionEdgeStaining)
end

function S:SetVerticalSyncOldValue()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  self.OldValue = GameUserSettings:IsVSyncEnabled()
end

function S:RestoreDefaultVerticalSyncOptionSet()
  self:SaveVerticalSyncOptionSetting()
end

function S:SaveVerticalSyncOptionSetting()
  local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
  GameUserSettings:SetVSyncEnabled(self.NowValue)
  GameUserSettings:ApplySettings(true)
end

function S:SetAmbientOcclusionOldValue()
  self.AmbientOcclusionList = {
    [1] = 0,
    [2] = 2
  }
  local NowAmbientOcclusion = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.AmbientOcclusionLevels")
  self.OldValue = self:GetOldValue(self.AmbientOcclusionList, NowAmbientOcclusion)
end

function S:RestoreDefaultAmbientOcclusionOptionSet()
  self:SaveAmbientOcclusionOptionSetting()
end

function S:SaveAmbientOcclusionOptionSetting()
  local NowAmbientOcclusion = self:GetNowValue(self.AmbientOcclusionList)
  SettingUtils.SaveEMCache(self.EMCacheName, "r.AmbientOcclusionLevels", NowAmbientOcclusion)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.AmbientOcclusionLevels", NowAmbientOcclusion)
end

function S:SetPostEffectOldValue()
  self.PostEffectList = {
    [1] = {
      [1] = 2,
      [2] = 5
    },
    [2] = {
      [1] = 0,
      [2] = 2
    }
  }
  local NowPostEffect = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.BloomQuality")
  self.OldValue = self:GetOldValue(self.PostEffectList[1], NowPostEffect)
end

function S:RestoreDefaultPostEffectOptionSet()
  self:SavePostEffectOptionSetting()
end

function S:SavePostEffectOptionSetting()
  local NowBloomQuality = self:GetNowValue(self.PostEffectList[1])
  local NowLensFlareQuality = self:GetNowValue(self.PostEffectList[2])
  SettingUtils.SaveEMCache(self.EMCacheName, "r.BloomQuality", NowBloomQuality)
  SettingUtils.SaveEMCache(self.EMCacheName, "r.LensFlareQuality", NowLensFlareQuality)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.BloomQuality", NowBloomQuality)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.LensFlareQuality", NowLensFlareQuality)
end

function S:SetForceFeedbackOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultForceFeedbackOptionSet()
  self:SaveForceFeedbackOptionSetting()
end

function S:SaveForceFeedbackOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(Player, 0)
  PlayerController:SwitchForceFeedback(self.NowValue)
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetSkillFaceToOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultSkillFaceToOptionSet()
  self:SaveSkillFaceToOptionSetting()
end

function S:SaveSkillFaceToOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:SetLockOrientpreference(self.NowValue)
  self.OldValue = self.NowValue
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetEnableMobileRotationOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultEnableMobileRotationOptionSet()
  self:SaveEnableMobileRotationOptionSetting()
end

function S:SaveEnableMobileRotationOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:SwitchEnableMobileRotation(self.NowValue)
  self.OldValue = self.NowValue
end

function S:SetBulletJumpCamResetOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultBulletJumpCamResetOptionSet()
  self:SaveBulletJumpCamResetOptionSetting()
end

function S:SaveBulletJumpCamResetOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  self.OldValue = self.NowValue
end

function S:SetBulletJumpCamAdjustOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultBulletJumpCamAdjustOptionSet()
  self:SaveBulletJumpCamAdjustOptionSetting()
end

function S:SaveBulletJumpCamAdjustOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  EventManager:FireEvent(EventID.OnSwitchBulletJumpCancel)
  self.OldValue = self.NowValue
  ReddotManager.DecreaseLeafNodeCount("Setting_Control_Setting_SaveBulletJumpCamAdjustBtn", 1)
end

function S:SetAutoBulletJumpCamOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultAutoBulletJumpCamOptionSet()
  self:SaveAutoBulletJumpCamOptionSetting()
end

function S:SaveAutoBulletJumpCamOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  self.OldValue = self.NowValue
  ReddotManager.DecreaseLeafNodeCount("Setting_Control_Setting_SaveAutoBulletJumpCamBtn", 1)
end

function S:SetFSROldValue()
  self.OldValue = URuntimeCommonFunctionLibrary.GetFSREnabled()
end

function S:RestoreDefaultFSROptionSet()
  self:SaveFSROptionSetting()
end

function S:SaveFSROptionSetting()
  URuntimeCommonFunctionLibrary.SetFSREnabled(self.NowValue)
  self.OldValue = self.NowValue
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetImmersionModelOldValue()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.OldValue = self.DefaultValue
  if not IsValid(Player) then
    return
  end
  self.OldValue = Player.IsImmersionModel
end

function S:RestoreDefaultImmersionModelOptionSet()
  self:SaveImmersionModelOptionSetting()
end

function S:SaveImmersionModelOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  if self.NowValue == false then
    if Player.IsImmersionModel ~= self.NowValue then
      local MenuWorld = UIManager(self):GetUIObj("MenuWorld")
      if MenuWorld then
        MenuWorld.bRecoverImmersionMode = true
      else
        Player:ImmersionModel()
      end
    end
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
  else
    local MenuWorld = UIManager(self):GetUIObj("MenuWorld")
    if MenuWorld then
      MenuWorld.bRecoverImmersionMode = false
      EventManager:RemoveEvent(EventID.UnLoadUI, self)
      EventManager:AddEvent(EventID.UnLoadUI, self, function(self, UIName)
        if "MenuWorld" == UIName then
          if Player.IsImmersionModel ~= self.NowValue then
            Player:ImmersionModel()
          end
          EventManager:RemoveEvent(EventID.UnLoadUI, self)
        end
      end)
    else
      local MenuLevel = UIManager(self):GetUIObj("MenuLevel")
      if MenuLevel then
        EventManager:RemoveEvent(EventID.UnLoadUI, self)
        EventManager:AddEvent(EventID.UnLoadUI, self, function(self, UIName)
          if "MenuLevel" == UIName then
            if Player.IsImmersionModel ~= self.NowValue then
              Player:ImmersionModel()
            end
            EventManager:RemoveEvent(EventID.UnLoadUI, self)
          end
        end)
      end
    end
  end
  self.OldValue = self.NowValue
  SettingUtils.SaveEMCache("ImmersionModel", self.EMCacheKey, self.NowValue)
end

function S:Handle_KeyDownOnGamePad(InKeyName)
  if InKeyName == UIConst.GamePadKey.LeftStickRight then
    self:SetSwitcher(true)
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftStickLeft then
    self:SetSwitcher(false)
    return true
  end
  return false
end

function S:Handle_KeyUpOnGamePad(InKeyName)
end

function S:Gamepad_SetHovered(bIsHovered)
end

function S:OnMainBtnClicked()
  if UIUtils.IsGamepadInput() and not self.HasBeenForbidden then
    self:OnBtnAreaClicked()
  end
end

function S:OnMainBtnHovered()
  self.BottomKeyInfos = {
    {
      UIConst.GamePadImgKey.FaceButtonBottom,
      GText("UI_Controller_Switch")
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

function S:GetFirstWidgetToNavigate()
  return self.Bg_Set
end

function S:GetLastWidgetToNavigate()
  return self.Bg_Set
end

function S:GetBottomKeyInfos()
  return self.BottomKeyInfos or {
    {
      UIConst.GamePadImgKey.FaceButtonBottom,
      GText("UI_Controller_Switch")
    }
  }
end

function S:SetShowBuffEnemyOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultShowBuffEnemyOptionSet()
  self:SaveShowBuffEnemyOptionSetting()
end

function S:SaveShowBuffEnemyOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  self:UpdateAllBillboardsByConfig()
end

function S:SetShowBuffFriendOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultShowBuffFriendOptionSet()
  self:SaveShowBuffFriendOptionSetting()
end

function S:SaveShowBuffFriendOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  self:UpdateAllBillboardsByConfig()
end

function S:UpdateAllBillboardsByConfig()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  for Index, Character in pairs(GameState.MonsterMap) do
    if Character and Character.BillboardComponent then
      Character.BillboardComponent:SetBuffPanelVisibilityByConfig()
    end
  end
  for Index, Mechanism in pairs(GameState.MechanismMap) do
    if Mechanism and Mechanism.BillboardComponent then
      Mechanism.BillboardComponent:SetBuffPanelVisibilityByConfig()
    end
  end
end

function S:SetLongPressLockShootingOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultLongPressLockShootingOptionSet()
  self:SaveShowBuffFriendOptionSetting()
end

function S:SaveLongPressLockShootingOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetEnhancedLogOldValue()
  local EnhanceLogSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEnhanceLogSubsystem:StaticClass())
  if EnhanceLogSubsystem then
    self.OldValue = EnhanceLogSubsystem:GetEnableEnhanceLog()
  else
    self.OldValue = false
  end
end

function S:RestoreEnhancedLogOptionSet()
  self:SaveLogUpdateOptionSetting()
end

function S:SaveEnhancedLogOptionSetting()
  local EnhanceLogSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEnhanceLogSubsystem:StaticClass())
  if self.OldValue then
    if EnhanceLogSubsystem and EnhanceLogSubsystem:GetEnableEnhanceLog() then
      EnhanceLogSubsystem:SetEnableEnhanceLog(self.NowValue)
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Opition_Log_Closed"))
    end
  else
    local Params = {}
    
    function Params.RightCallbackFunction()
      if EnhanceLogSubsystem then
        EnhanceLogSubsystem:SetEnableEnhanceLog(self.NowValue)
      end
    end
    
    function Params.LeftCallbackFunction()
      self:SetSwitcher(not self.NowValue)
    end
    
    UIManager(self):ShowCommonPopupUI(100280, Params, self.Parent)
  end
end

function S:SetVolumetricLightOldValue()
  self.VolumetricLightList = {
    [1] = 0,
    [2] = 1
  }
  local NowVolumetricLight = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("r.LightShaftQuality")
  self.OldValue = self:GetOldValue(self.VolumetricLightList, NowVolumetricLight)
end

function S:RestoreDefaultVolumetricLightOptionSet()
  self:SaveVolumetricLightOptionSetting()
end

function S:SaveVolumetricLightOptionSetting()
  local NowVolumetricLight = self:GetNowValue(self.VolumetricLightList)
  SettingUtils.SaveEMCache(self.EMCacheName, "r.LightShaftQuality", NowVolumetricLight)
  GWorld.GameInstance:SetGameScalabilityLevelByName("r.LightShaftQuality", NowVolumetricLight)
end

function S:SetLocalWindDetailOldValue()
  self.LocalWindDetailList = {
    [1] = 0,
    [2] = 1
  }
  local NowLocalWindDetail = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("foliage.WindEnable")
  self.OldValue = self:GetOldValue(self.LocalWindDetailList, NowLocalWindDetail)
end

function S:RestoreDefaultLocalWindDetailOptionSet()
  self:SaveLocalWindDetailOptionSetting()
end

function S:SaveLocalWindDetailOptionSetting()
  local NowLocalWindDetail = self:GetNowValue(self.LocalWindDetailList)
  SettingUtils.SaveEMCache(self.EMCacheName, "foliage.WindEnable", NowLocalWindDetail)
  GWorld.GameInstance:SetGameScalabilityLevelByName("foliage.WindEnable", NowLocalWindDetail)
end

function S:SetAutoJoinOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultAutoJoinOptionSet()
  self:SaveAutoJoinOptionSetting()
end

function S:SaveAutoJoinOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:UpdateRegionOnlineState(self.NowValue)
end

function S:SetHidePlayerOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
  local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
  if RegionSyncSubsys then
    RegionSyncSubsys:SetOnlyShowTeammate(self.OldValue)
  end
end

function S:RestoreDefaultHidePlayerOptionSet()
  self:SaveHideNotTeammatePlayerOptionSetting()
end

function S:SaveHidePlayerOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
  if RegionSyncSubsys then
    RegionSyncSubsys:SetOnlyShowTeammate(self.NowValue)
  end
end

function S:SetHideBackWeaponsOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultHideBackWeaponsOptionSet()
  self:SaveHideBackWeaponsOptionSetting()
end

function S:SaveHideBackWeaponsOptionSetting()
  if not AWeaponBase or not AWeaponBase.SetWeaponBackTimerEnabled then
    return
  end
  AWeaponBase.SetWeaponBackTimerEnabled(self, self.NowValue)
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetSkipMVPOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultSkipMVPOptionSet()
  self:SaveSkipMVPOptionSetting()
end

function S:SaveSkipMVPOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  self.OldValue = self.NowValue
end

function S:SetLeftShootShowOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultLeftShootShowOptionSet()
  self:SaveLeftShootShowOptionSetting()
end

function S:SaveLeftShootShowOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  EventManager:FireEvent(EventID.OnSwitchLeftShoot)
  self.OldValue = self.NowValue
end

function S:SetLeftBulletJumpShowOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultLeftBulletJumpShowOptionSet()
  self:SaveLeftShootShowOptionSetting()
end

function S:SaveLeftBulletJumpShowOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  EventManager:FireEvent(EventID.OnSwitchLeftBulletJump)
  self.OldValue = self.NowValue
end

function S:SetRealtimeSunlightOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultRealtimeSunlightOptionSet()
  self:SaveRealtimeSunlightOptionSetting()
end

function S:SaveRealtimeSunlightOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  if self.NowValue then
    URuntimeCommonFunctionLibrary.SetConsoleVariableIntValue("EM.FixedSunlightDirection", 0, 2)
  else
    URuntimeCommonFunctionLibrary.SetConsoleVariableIntValue("EM.FixedSunlightDirection", 1, 2)
  end
end

function S:SetAntiAliasingMobileOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultAntiAliasingMobileOptionSet()
  self:SaveAntiAliasingMobileOptionSetting()
end

function S:SaveAntiAliasingMobileOptionSetting()
  if self.OldValue then
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.DefaultFeature.AntiAliasing 2")
    SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
    EventManager:FireEvent(EventID.OnSwitchAntiAliasing, 4)
  else
    local Params = {}
    
    function Params.RightCallbackFunction()
      UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.DefaultFeature.AntiAliasing 2")
      SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
      EventManager:FireEvent(EventID.OnSwitchAntiAliasing, 2)
    end
    
    function Params.LeftCallbackFunction()
      self:SetSwitcher(not self.NowValue)
    end
    
    UIManager(self):ShowCommonPopupUI(100283, Params, self.Parent)
  end
end

function S:SetMoveLockOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultMoveLockOptionSet()
  self:SaveMoveLockOptionSetting()
end

function S:SaveMoveLockOptionSetting()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  Player:UpdateVirtualJoystickEnableMoveLock(self.NowValue)
  self.OldValue = self.NowValue
end

function S:SetVoiceGuideOldValue()
  if not self.EMCacheName then
    return
  end
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultVoiceGuideOptionSet()
  self:SaveVoiceGuideOptionSetting()
end

function S:SaveVoiceGuideOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  AudioManager(self):SetTalkVoiceTurnOff(not self.NowValue)
end

function S:SetAutoApproveOldValue()
  if not self.EMCacheName then
    return
  end
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreDefaultAutoApproveOptionSet()
  self:SaveAutoApproveOptionSetting()
end

function S:SaveAutoApproveOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
end

function S:SetAutoBackgroundOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.CacheName, nil, self.DefaultValue)
end

function S:RestoreDefaultAutoBackgroundOptionSet()
  self:SaveAutoBackgroundOptionSetting()
end

function S:SaveAutoBackgroundOptionSetting()
  SettingUtils.SaveEMCache(self.CacheName, nil, self.NowValue)
end

function S:RevertSwitch(Switcher, OldValue)
  if Switcher then
    Switcher.bIsRestoringState = true
    Switcher:SetSwitcher(OldValue)
    Switcher.bIsRestoringState = false
  end
end

function S:RefreshSubOptionsState()
  if not self.CacheInfo.SubOptionList then
    return
  end
  local bPreLoginEnabled = SecondaryPasswordController:CheckPreLoginValidateOnce()
  local Count = self.VB_Suboption:GetChildrenCount() - 1
  for i = 0, Count do
    local Child = self.VB_Suboption:GetChildAt(i)
    self:RevertSwitch(Child, bPreLoginEnabled)
  end
end

function S:OnSecPasswordReddotChange(Count)
  if Count > 0 then
    self.CurOptionContent.SelfWidget.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.CurOptionContent.SelfWidget.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function S:RedDotChange(Count)
  if Count > 0 then
    self.CurOptionContent.SelfWidget.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.CurOptionContent.SelfWidget.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function S:SetSecondaryPasswordOldValue()
  local EnableSecondaryPassword = SecondaryPasswordController:CheckSecondaryPasswordEnabled()
  self.OldValue = EnableSecondaryPassword
  
  function self.RestoreDefaultOptionSet()
  end
end

function S:RestoreDefaultSecondaryPasswordOptionSet()
  local EnableSecondaryPassword = SecondaryPasswordController:CheckSecondaryPasswordEnabled()
  self.NowValue = EnableSecondaryPassword
end

function S:RestoreSecondaryPasswordOptionSet()
  self:SaveSecondaryPasswordOptionSetting()
end

function S:SaveSecondaryPasswordOptionSetting()
  if self.bIsRestoringState then
    return
  end
  local GachaKey = "SecPasswordNew"
  local SecPasswordNewCache = EMCache:Set(GachaKey, true, true)
  ReddotManager.ClearLeafNodeCount("Setting_SecPassword")
  SecondaryPasswordController:RequestChangePasswordStatus(self.NowValue, {
    OnSuccess = function()
      self:RefreshSubOptionsState()
    end,
    OnCancel = function()
      self:RevertSwitch(self, not self.NowValue)
      self:RefreshSubOptionsState()
    end
  })
end

function S:SetPasswordVerifyPerLoginOldValue()
  local EnableSecondaryPasswordVerifyPerLogin = SecondaryPasswordController:CheckPreLoginValidateOnce()
  self.OldValue = EnableSecondaryPasswordVerifyPerLogin
end

function S:RestorePasswordVerifyPerLoginOptionSet()
  self:SavePasswordVerifyPerLoginOptionSetting()
end

function S:SavePasswordVerifyPerLoginOptionSetting()
  if self.bIsRestoringState then
    return
  end
  SecondaryPasswordController:RequestChangeValidateOnceStatus(self.NowValue, {
    OnSuccess = nil,
    OnCancel = function()
      self:RevertSwitch(self, not self.NowValue)
    end
  })
end

function S:SetAutoFashionOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreAutoFashionOptionSet()
  self:SaveAutoFashionOptionSetting()
end

function S:SaveAutoFashionOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  GWorld.GameInstance.IsAutoFashionSwitch = self.NowValue
end

function S:SetShootCameraDistanceOldValue()
  self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.DefaultValue)
end

function S:RestoreShootCameraDistanceOptionSet()
  self:SaveAutoFashionOptionSetting()
end

function S:SaveShootCameraDistanceOptionSetting()
  SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue)
  EventManager:FireEvent(EventID.OnShootCameraDistanceOptionChanged, self.NowValue)
end

return S
