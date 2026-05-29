local M = {
  "BluePrints.Common.DelayFrameComponent"
}

function M:Construct()
  self.GeneralSkinRandomCache = {}
end

function M:UpdatePreviewActor(ItemData, WeaponCameraOffset)
  self.Avatar = GWorld:GetAvatar()
  if not self.Avatar then
    return
  end
  self.UIName = self:GetUIConfigName()
  self.WeaponCameraOffset = WeaponCameraOffset or FVector(0, 0, 0)
  self.IsRiderMount = true
  self.EnableDrag = true
  self.EnableMouseWheel = true
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:AddDelayFrameFunc(function()
    self:BlockAllUIInput(false)
  end, 31)
  local Index = 0
  if ItemData.ItemType == "Resource" then
    local ResEntry = DataMgr.Resource[ItemData.TypeId]
    if ResEntry and ResEntry.SkyBoxIndex ~= nil then
      Index = ResEntry.SkyBoxIndex
    end
  end
  if ItemData.ItemType == "Resource" then
    local ResourceData = DataMgr.Resource[ItemData.TypeId]
    if not ResourceData then
      return
    end
    if ResourceData.ResourceSType ~= "GestureItem" and ResourceData.ResourceSType ~= "MountItem" then
      return
    end
    ItemData.ResourceSType = ResourceData.ResourceSType
  end
  self.Params = self:GenerateActorParams(ItemData)
  if not self.Params then
    return
  end
  if not self.ActorController then
    self.Params.Target = self:CreatePreviewTargetData(self.Params)
    self:InitializePreviewActor(ItemData)
    self:NotifySkyBox(Index)
  else
    self:HideAllPreviewActor()
    self:StopActorSound()
    self:UpdateExistingPreviewActor(ItemData)
    self:NotifySkyBox(Index)
  end
end

function M:GenerateActorParams(ItemData)
  local itemType = ItemData.ItemType
  if "Background" == itemType then
    return self:_GenerateBackgroundParams(ItemData, self.Avatar)
  elseif "Char" == itemType then
    return {
      Type = "Char",
      SkinId = ItemData.TypeId
    }
  elseif "Weapon" == itemType then
    return {
      Type = "Weapon",
      SkinId = ItemData.TypeId
    }
  elseif "Skin" == itemType then
    return self:_GenerateSkinParams(ItemData)
  elseif "Hair" == itemType then
    return {
      Type = "Char",
      HairId = ItemData.TypeId
    }
  elseif "GeneralSkin" == itemType then
    return self:_GenerateSkinSeriesParams(ItemData, self.Avatar)
  elseif "WeaponSkin" == itemType then
    return self:_GenerateWeaponSkinParams(ItemData)
  elseif "CharAccessory" == itemType then
    return self:_GenerateCharAccessoryParams(ItemData, self.Avatar)
  elseif "WeaponAccessory" == itemType then
    return self:_GenerateWeaponAccessoryParams(ItemData, self.Avatar)
  elseif "Resource" == itemType then
    if ItemData.ResourceSType == "GestureItem" then
      return self:_GenerateCharGestureParams(ItemData, self.Avatar)
    end
  elseif "Mount" == itemType then
    return self:_GenerateCharMountsParams(ItemData, self.Avatar)
  end
  return nil
end

function M:_GenerateBackgroundParams(ItemData, Avatar)
  local Char = Avatar.Chars[Avatar.CurrentChar]
  ItemData.TypeId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
  return {
    Type = "Char",
    SkinId = ItemData.TypeId
  }
end

function M:_GenerateSkinParams(ItemData)
  local SkinData = DataMgr.Skin[ItemData.TypeId]
  if not SkinData then
    return nil
  end
  return {
    Type = "Char",
    SkinId = SkinData.SkinId
  }
end

function M:_GenerateSkinSeriesParams(ItemData, Avatar)
  local CharId = Avatar.Chars[Avatar.CurrentChar].CharId
  local SkinInfo = DataMgr.Skin
  local CandidateSkinIds = {}
  local SkinSeries = ItemData.SkinSeries
  if not SkinSeries then
    return nil
  end
  for SkinId, Info in pairs(SkinInfo) do
    if Info.SkinSeries == SkinSeries and Info.CharId == CharId then
      ItemData.ItemType = "Skin"
      ItemData.TypeId = SkinId
      return {Type = "Char", SkinId = SkinId}
    elseif Info.SkinSeries == SkinSeries then
      table.insert(CandidateSkinIds, SkinId)
    end
  end
  if 0 == #CandidateSkinIds then
    return nil
  end
  self.GeneralSkinRandomCache = self.GeneralSkinRandomCache or {}
  local RandomSkinId = self.GeneralSkinRandomCache[SkinSeries]
  if not RandomSkinId then
    RandomSkinId = CandidateSkinIds[math.random(1, #CandidateSkinIds)]
    self.GeneralSkinRandomCache[SkinSeries] = RandomSkinId
  end
  ItemData.ItemType = "Skin"
  ItemData.TypeId = RandomSkinId
  return {Type = "Char", SkinId = RandomSkinId}
end

function M:_GenerateWeaponSkinParams(ItemData)
  local WeaponSkinData = DataMgr.WeaponSkin[ItemData.TypeId]
  if not WeaponSkinData then
    return nil
  end
  return {
    Type = "Weapon",
    SkinId = WeaponSkinData.SkinID
  }
end

function M:_GenerateCharAccessoryParams(ItemData, Avatar)
  local AccessoryData = DataMgr.CharAccessory[ItemData.TypeId]
  if not AccessoryData then
    return nil
  end
  local Char = Avatar.Chars[Avatar.CurrentChar]
  return {
    Type = "Char",
    SkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId,
    AccessoryId = AccessoryData.AccessoryId,
    AccessoryType = AccessoryData.AccessoryType
  }
end

function M:_GenerateWeaponAccessoryParams(ItemData, Avatar)
  local WeaponAccessoryData = DataMgr.WeaponAccessory[ItemData.TypeId]
  if not WeaponAccessoryData then
    return nil
  end
  local Params = {
    Type = "Weapon",
    AccessoryId = WeaponAccessoryData.WeaponAccessoryId,
    AccessoryType = WeaponAccessoryData.AccessoryType,
    SkinId = nil
  }
  local weaponToCheck
  if self.Tab_Change and 2 == self.Tab_Change.TabIdx then
    weaponToCheck = Avatar.Weapons[Avatar.RangedWeapon]
  else
    weaponToCheck = Avatar.Weapons[Avatar.MeleeWeapon]
  end
  if weaponToCheck then
    local currentSkinId = weaponToCheck:GetCurrentSkin().SkinId
    if currentSkinId ~= weaponToCheck.WeaponId then
      Params.SkinId = currentSkinId
    end
  end
  return Params
end

function M:_GenerateCharGestureParams(ItemData, Avatar)
  local Char = Avatar.Chars[Avatar.CurrentChar]
  local Params = {
    Type = "Char",
    SkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
  }
  local Res = DataMgr.Resource[ItemData.TypeId]
  Params.SkyBoxIndex = Res and Res.SkyBoxIndex or 0
  return Params
end

function M:_GenerateCharMountsParams(ItemData, Avatar)
  local Params = {Type = "Char"}
  return Params
end

function M:InitializePreviewActor(ItemData)
  self.ActorController = self:CreatePreviewActor(self.Params)
  local itemType = ItemData.ItemType
  if "Weapon" == itemType or "WeaponSkin" == itemType or "WeaponAccessory" == itemType then
    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  end
  self.ActorController:OnOpened()
  self.ActorController.bPlayRoleChangedSound = false
  if self.ActorController then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local ArmoryPlayer = self.ActorController:GetPlayerActor()
    if PlayerController and ArmoryPlayer and ArmoryPlayer.AudioListener then
      PlayerController:SetAudioListenerOverride(ArmoryPlayer.AudioListener, Const.ZeroVector, Const.ZeroRotator)
    end
  end
  if "Background" == itemType then
    self:SetupInitialBackgroundPreview()
  elseif "Char" == itemType then
    self:SetupInitialCharPreview(ItemData)
  elseif "Weapon" == itemType then
    self:SetupInitialWeaponPreview(ItemData)
  elseif "Skin" == itemType then
    self:SetupInitialSkinPreview(ItemData)
  elseif "Hair" == itemType then
    self:SetupInitialHairPreview(ItemData)
  elseif "WeaponSkin" == itemType then
    self:SetupInitialWeaponSkinPreview(ItemData)
  elseif "Resource" == itemType then
    if ItemData.ResourceSType == "GestureItem" then
      self:SetupInitialGesturePreview(ItemData)
    end
  elseif "Mount" == itemType then
    self:SetupInitialMountsPreview(ItemData)
  elseif "CharAccessory" == itemType or "WeaponAccessory" == itemType then
    self:ApplyAccessoryPreview(itemType)
  end
end

function M:UpdateExistingPreviewActor(ItemData)
  self:CleanupPreviousPreviewEffects()
  local itemType = ItemData.ItemType
  if "Background" == itemType then
    self:UpdateToBackgroundPreview(ItemData)
  elseif "Char" == itemType then
    self:UpdateToCharPreview(ItemData)
  elseif "Weapon" == itemType then
    self:UpdateToWeaponPreview(ItemData)
  elseif "Skin" == itemType then
    self:UpdateToSkinPreview(ItemData)
  elseif "Hair" == itemType then
    self:UpdateToHairPreview(ItemData)
  elseif "WeaponSkin" == itemType then
    self:UpdateToWeaponSkinPreview(ItemData)
  elseif "CharAccessory" == itemType then
    self:UpdateToCharAccessoryPreview(ItemData)
  elseif "WeaponAccessory" == itemType then
    self:UpdateToWeaponAccessoryPreview(ItemData)
  elseif "Resource" == itemType then
    if ItemData.ResourceSType == "GestureItem" then
      self:UpdateToGesturePreview(ItemData)
    end
  elseif "Mount" == itemType then
    self:UpdateToMountsPreview(ItemData)
  end
end

function M:CleanupPreviousPreviewEffects()
  if not self.Params or self.Params.AccessoryType ~= CommonConst.CharAccessoryTypes.MVP then
    self.ActorController:TryDestroySequenceActorController()
  end
  if self.ActorController.bEnableReflectionBeforeGesture ~= nil then
    self.ActorController.bEnableReflection = self.ActorController.bEnableReflectionBeforeGesture
  end
  self.ActorController:HidePlayerActorInternal(self.ActorController:GetReflectionActor(self.ActorController:GetPlayerActor()), "ReflectionHideByGesture", false)
  self.ActorController:StopPlayerFX()
  self.ActorController:DestroyCreature(CommonConst.CharAccessoryTypes.FX_Dead)
  self.ActorController:DestroyCreature(CommonConst.CharAccessoryTypes.FX_Body)
  self.ActorController:RemovePlayerGestureEffectCreature()
  self.ActorController:HidePlayerActor("ActorController_HidePlayerBeforeMount", false)
  self.ActorController:HidePlayerOnMount(false)
  self.ActorController:DestroyMount()
  self.ActorController:ViewTarget()
  local Player = self.ActorController:GetPlayerActor()
  if Player then
    Player:SetActorScale3D(Const.OneVector)
  end
end

function M:SetupDefaultCharacterModel()
  self.ActorController:HidePlayerActor(self.UIName, false)
  self:HidePlayerWeapon(true)
  self:HideSingleWeapon(true)
  local Char = self.Avatar.Chars[self.Avatar.CurrentChar]
  local CharSkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
  local Params = {Type = "Char", SkinId = CharSkinId}
  local Data = self:CreatePreviewTargetData(Params)
  self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
  self.ActorController.ExCameraOffset = FVector(0, 0, 0)
  self.ActorController:ChangeCharModel(Data, true, true)
  local AppearanceInfo = {
    CharId = Char.CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
  self.ActorController:HidePlayerMeleeWeapon()
end

function M:SetupInitialBackgroundPreview()
  self.ActorController:SetMontageAndCamera("Char", nil, nil)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self.ActorController:EnableCameraScrolling(false)
end

function M:SetupInitialCharPreview(ItemData)
  local CharId = DataMgr.Skin[ItemData.TypeId].CharId
  local CharSkinId = ItemData.TypeId
  local AppearanceInfo = {
    CharId = CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:SetupInitialWeaponPreview(ItemData)
  local Tag = self.Params.Target:HasTag("Melee") and "Melee" or "Ranged"
  self.ActorController:SetMontageAndCamera("Weapon", Tag)
  self.ActorController:EnableCameraScrolling(false)
end

function M:SetupInitialSkinPreview(ItemData)
  local CharId = DataMgr.Skin[ItemData.TypeId].CharId
  local CharSkinId = ItemData.TypeId
  local AppearanceInfo = {
    CharId = CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:SetupInitialHairPreview(ItemData)
  local CharId = DataMgr.Hair[ItemData.TypeId].CharId
  local CharHairId = ItemData.TypeId
  local AppearanceInfo = {
    CharId = CharId,
    HairId = CharHairId,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self:UpdateAccessoryCamera(CharHairId, "Hair")
end

function M:SetupInitialWeaponSkinPreview(ItemData)
  self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
  local Tag = self.Params.Target:HasTag("Melee") and "Melee" or "Ranged"
  self.ActorController:SetMontageAndCamera("Weapon", Tag)
  self.ActorController:EnableCameraScrolling(false)
end

function M:SetupInitialGesturePreview(ItemData)
  local ResourceData = DataMgr.Resource[ItemData.TypeId]
  if ResourceData then
    self:ClearCharAccessory()
    if ItemData.TypeId == 41034 or ItemData.TypeId == 41035 then
      local Player = self.ActorController:GetPlayerActor()
      self.ActorController:HidePlayerActorInternal(self.ActorController:GetReflectionActor(Player), "ReflectionHideByGesture", true)
      self.ActorController.bEnableReflectionBeforeGesture = self.ActorController.bEnableReflection
      self.ActorController.bEnableReflection = false
    end
    self.ActorController:ChangeWeaponModel(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
    self.ActorController:ChangeWeaponModel(self.Avatar.Weapons[self.Avatar.RangedWeapon])
    self.ActorController:ClearPlayerGestureHideTags()
    self.ActorController:SetArmoryMontageTag("Armory")
    self.ActorController:SetArmoryCameraTag(ResourceData.CameraName or "Char", "", "")
    self.ActorController:PlayResourceMotion(ItemData.TypeId)
  end
end

function M:SetupInitialMountsPreview(ItemData)
  self:ClearCharAccessory()
  local MountData = DataMgr.Mount[ItemData.TypeId]
  self.ActorController:SetArmoryCameraTag(MountData.CameraName or CommonConst.ArmoryType.Char, "", "")
  self.ActorController:HidePlayerOnMount(false)
  self.ActorController:CreateMount(ItemData.TypeId)
end

function M:ApplyAccessoryPreview(itemType)
  self.ActorController.bPlaySameMontage = true
  self:UpdateAccessoryCamera(self.Params.AccessoryId, self.Params.AccessoryType)
  if "CharAccessory" == itemType then
    self.ActorController:StopPlayerMontage()
    self:ClearCharAccessory()
    if self.Params.AccessoryType == CommonConst.CharAccessoryTypes.MVP then
      self.ActorController:ResetActorRotation()
      self.ActorController:TryCreateSequenceActorController()
      self.EnableDrag = false
      self.EnableMouseWheel = false
    end
    if UIConst.FXAccessoryTypes[self.Params.AccessoryType] then
      self.ActorController:ShowPlayerFXAccessory(self.Params.AccessoryId, self.Params.AccessoryType)
      if UIConst.HidePlayerAccessoryTypes[self.Params.AccessoryType] then
        self.ActorController:HidePlayerActor(self.UIName, true)
      end
    else
      self.ActorController:ChangeCharAccessory(self.Params.AccessoryId, self.Params.AccessoryType, self.Params.CustomParams)
    end
  else
    self.ActorController:ChangeWeaponAccessory(self.Params.AccessoryId, CommonConst.WeaponAccessoryTypes.Accessory)
    self.ActorController:EnableCameraScrolling(false)
  end
end

function M:UpdateToBackgroundPreview(ItemData)
  self:HidePlayerWeapon(true)
  self:HideSingleWeapon(true)
  local CharSkinId = ItemData.TypeId
  self.Params.Target = self:CreatePreviewTargetData({Type = "Char", SkinId = CharSkinId})
  self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
  self.ActorController.ExCameraOffset = FVector(0, 0, 0)
  self.ActorController:ChangeCharModel(self.Params.Target, true, true)
  self.ActorController:SetMontageAndCamera("Char", nil, nil)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToCharPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, false)
  self:HidePlayerWeapon(true)
  self:HideSingleWeapon(true)
  local CharId = DataMgr.Skin[ItemData.TypeId].CharId
  local CharSkinId = ItemData.TypeId
  local AppearanceInfo = {
    CharId = CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  self.Params.Target = self:CreatePreviewTargetData({Type = "Char", SkinId = CharSkinId})
  self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
  self.ActorController.ExCameraOffset = FVector(0, 0, 0)
  self.ActorController:ChangeCharModel(self.Params.Target, true, true)
  self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController.DelayFrame = 30
  self.ActorController.bPlaySameMontage = true
  self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:UpdateToWeaponPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self:HidePlayerWeapon(true)
  self.Params.Target = self:CreatePreviewTargetData({
    Type = "Weapon",
    SkinId = ItemData.TypeId
  })
  self.ActorController.bStandaloneWeapon = true
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController:ChangeSingleWeapon(self.Params.Target)
  local AppearanceInfo = {
    SkinId = ItemData.TypeId
  }
  self.ActorController:ChangeWeaponAppearance(AppearanceInfo)
  self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToSkinPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, false)
  self:HidePlayerWeapon(true)
  self:HideSingleWeapon(true)
  local CharId = DataMgr.Skin[ItemData.TypeId].CharId
  local CharSkinId = ItemData.TypeId
  local AppearanceInfo = {
    CharId = CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  if ItemData.SkinLevel then
    AppearanceInfo.SkinLevel = ItemData.SkinLevel
  end
  self.Params.Target = self:CreatePreviewTargetData({Type = "Char", SkinId = CharSkinId})
  self.ActorController.bStandaloneWeapon = false
  self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
  self.ActorController.ExCameraOffset = FVector(0, 0, 0)
  self.ActorController:ChangeCharModel(self.Params.Target, true, true)
  self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController.DelayFrame = 30
  self.ActorController.bPlaySameMontage = true
  self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:UpdateToHairPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, false)
  self:HidePlayerWeapon(true)
  self:HideSingleWeapon(true)
  self:ClearCharAccessory()
  local CharId = DataMgr.Hair[ItemData.TypeId].CharId
  local CharHairId = ItemData.TypeId
  local AppearanceInfo = {
    CharId = CharId,
    HairId = CharHairId,
    AccessorySuit = {}
  }
  self.Params.Target = self:CreatePreviewTargetData({Type = "Char", HairId = CharHairId})
  self.ActorController.bStandaloneWeapon = false
  self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
  self.ActorController.ExCameraOffset = FVector(0, 0, 0)
  self.ActorController:ChangeCharModel(self.Params.Target, true, true)
  self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController.bPlaySameMontage = true
  self:UpdateAccessoryCamera(CharHairId, "Hair")
end

function M:UpdateToWeaponSkinPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self:HidePlayerWeapon(true)
  self.Params.Target = self:CreatePreviewTargetData({
    Type = "Weapon",
    SkinId = ItemData.TypeId
  })
  self.ActorController.bStandaloneWeapon = true
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController:ChangeSingleWeapon(self.Params.Target)
  local AppearanceInfo = {
    SkinId = ItemData.TypeId
  }
  self.ActorController:ChangeWeaponAppearance(AppearanceInfo)
  self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToCharAccessoryPreview(ItemData)
  self:SetupDefaultCharacterModel()
  self:ApplyAccessoryPreview("CharAccessory")
end

function M:UpdateToWeaponAccessoryPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self:HidePlayerWeapon(true)
  self:HideSingleWeapon(false)
  local WeaponAccessoryData = DataMgr.WeaponAccessory[ItemData.TypeId]
  if not WeaponAccessoryData then
    return
  end
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  if self.Tab_Change and 2 == self.Tab_Change.TabIdx then
    self.Tab_Change:BtnSwitchToLeft()
    self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
  else
    self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.MeleeWeapon], "WeaponAccessory" == self.LastItemType)
  end
  self.ActorController:ChangeWeaponAccessory(WeaponAccessoryData.WeaponAccessoryId, CommonConst.WeaponAccessoryTypes.Accessory)
  self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToGesturePreview(ItemData)
  self:SetupDefaultCharacterModel()
  if ItemData.TypeId == 41034 or ItemData.TypeId == 41035 then
    local Player = self.ActorController:GetPlayerActor()
    self.ActorController:HidePlayerActorInternal(self.ActorController:GetReflectionActor(Player), "ReflectionHideByGesture", true)
    self.ActorController.bEnableReflectionBeforeGesture = self.ActorController.bEnableReflection
    self.ActorController.bEnableReflection = false
  end
  self.ActorController:SetArmoryMontageTag("Armory")
  self.ActorController:PlayResourceMotion(ItemData.TypeId)
  local GestureData = DataMgr.Resource[ItemData.TypeId]
  if GestureData then
    self.ActorController:SetArmoryCameraTag(GestureData.CameraName or "Char", "", "")
  end
end

function M:UpdateToMountsPreview(ItemData)
  self.ActorController:DestroyMount()
  self.ActorController:HidePlayerOnMount(false)
  self.IsRiderMount = true
  self:SetupDefaultCharacterModel()
  local MountData = DataMgr.Mount[ItemData.TypeId]
  self.ActorController:SetArmoryCameraTag(MountData.CameraName or CommonConst.ArmoryType.Char, "", "")
  self.ActorController:CreateMount(ItemData.TypeId)
  self.ActorController.ArmoryHelper:SetViewActor(self.ActorController.ArmoryPlayer)
end

function M:ClearCharAccessory()
  self.ActorController:StopPlayerFX()
  self.ActorController:DestroyCreature(CommonConst.CharAccessoryTypes.FX_Dead)
  self.ActorController:DestroyCreature(CommonConst.CharAccessoryTypes.FX_Body)
  self.ActorController:RemovePlayerGestureEffectCreature()
  local Char = self.Avatar.Chars[self.Avatar.CurrentChar]
  local CharSkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
  local AppearanceInfo = {
    CharId = Char.CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
end

function M:ApplySuitPreview(ItemData)
  local Rewards = DataMgr.Reward[ItemData.SuitRewardId[1]]
  if not Rewards then
    return
  end
  self.ActorController:HidePlayerActor(self.UIName, false)
  self:HideSingleWeapon(true)
  self.ActorController:DestroyAllPlayerWeapons()
  local AppearanceInfo = {
    CharId = -1,
    SkinId = -1,
    AccessorySuit = {}
  }
  local currentItemType = ItemData.ItemType
  if "Skin" == currentItemType then
    AppearanceInfo.CharId = DataMgr.Skin[ItemData.TypeId].CharId
    AppearanceInfo.SkinId = ItemData.TypeId
  end
  if "WeaponSkin" == currentItemType or "WeaponAccessory" == currentItemType then
    self:HideSingleWeapon(true)
    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
  end
  if "Skin" ~= currentItemType then
    self.ActorController.DelayFrame = 30
  end
  for i = 1, #Rewards.Id do
    if "Skin" ~= currentItemType or "Skin" ~= Rewards.Type[i] then
      self:ApplySingleRewardItem(Rewards.Type[i], Rewards.Id[i], AppearanceInfo)
    end
  end
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
end

function M:ApplySingleRewardItem(rewardType, rewardId, AppearanceInfo)
  if "Skin" == rewardType then
    local CharData = self:CreatePreviewTargetData({Type = "Char", SkinId = rewardId})
    self.ActorController:ChangeCharModel(CharData, true, true)
    AppearanceInfo.CharId = DataMgr.Skin[rewardId].CharId
    AppearanceInfo.SkinId = rewardId
    self:HideZoomKey(false)
  elseif "WeaponSkin" == rewardType then
    local WeaponData = self:CreatePreviewTargetData({Type = "Weapon", SkinId = rewardId})
    self.ActorController:ChangeWeaponModel(WeaponData)
    self.ActorController:ChangePlayerWeaponSkin(rewardId)
    self:HidePlayerWeapon(false)
    local Tag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
    self.ActorController.DelayFrame = 30
    self.ActorController.bPlaySameMontage = true
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  elseif "CharAccessory" == rewardType then
    local AccessoryType = DataMgr.CharAccessory[rewardId].AccessoryType
    AppearanceInfo.AccessorySuit[CommonConst.NewCharAccessoryTypes[AccessoryType]] = rewardId
    self:HideZoomKey(false)
  elseif "WeaponAccessory" == rewardType then
    self:HidePlayerWeapon(false)
    self.ActorController:ChangePlayerWeaponAccessory(rewardId)
  end
end

function M:RevertToSingleItemPreview(ItemData)
  self:SetupDefaultCharacterModel()
  local itemType = ItemData.ItemType
  if "Skin" == itemType then
    self:RevertToSkinPreview(ItemData)
  elseif "WeaponSkin" == itemType then
    self:RevertToWeaponSkinPreview(ItemData)
  elseif "CharAccessory" == itemType then
    self:RevertToCharAccessoryPreview(ItemData)
  elseif "WeaponAccessory" == itemType then
    self:RevertToWeaponAccessoryPreview(ItemData)
  end
end

function M:RevertToSkinPreview(ItemData)
  local CharId = DataMgr.Skin[ItemData.TypeId].CharId
  local CharSkinId = ItemData.TypeId
  local SkinLevel = ItemData.SkinLevel
  local AppearanceInfo = {
    CharId = CharId,
    SkinId = CharSkinId,
    SkinLevel = SkinLevel,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
  self.ActorController.DelayFrame = 30
  self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, nil)
  self.ActorController.bStandaloneWeapon = true
  self:HideZoomKey(false)
end

function M:RevertToWeaponSkinPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self:HidePlayerWeapon(true)
  local WeaponData = self:CreatePreviewTargetData({
    Type = "Weapon",
    SkinId = ItemData.TypeId
  })
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 0, 0))
  self.ActorController:ChangeSingleWeapon(WeaponData)
  self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
  self.ActorController:EnableCameraScrolling(false)
  self.ActorController.bStandaloneWeapon = true
  self:HideZoomKey(true)
end

function M:RevertToCharAccessoryPreview(ItemData)
  local AccessoryData = DataMgr.CharAccessory[ItemData.TypeId]
  local Char = self.Avatar.Chars[self.Avatar.CurrentChar]
  local Params = {
    Type = "Char",
    SkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
  }
  local Data = self:CreatePreviewTargetData(Params)
  local CustomParams = Char:DumpAccessoryCustomParams(Char.AppearanceSuits) or {}
  self.ActorController:ChangeCharModel(Data, true, true)
  self:UpdateAccessoryCamera(AccessoryData.AccessoryId, AccessoryData.AccessoryType)
  self.ActorController:StopPlayerMontage()
  self.ActorController:ChangeCharAccessory(AccessoryData.AccessoryId, AccessoryData.AccessoryType, CustomParams[AccessoryData.AccessoryId])
  self:HideZoomKey(false)
end

function M:RevertToWeaponAccessoryPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, true)
  local WeaponAccessoryData = DataMgr.WeaponAccessory[ItemData.TypeId]
  if not WeaponAccessoryData then
    return
  end
  self.ActorController:ResetActorRotation()
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  if 2 == self.Tab_Change.TabIdx then
    self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.RangedWeapon])
  else
    self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
  end
  self.ActorController:ChangeWeaponAccessory(WeaponAccessoryData.WeaponAccessoryId, CommonConst.WeaponAccessoryTypes.Accessory)
  self.ActorController:EnableCameraScrolling(false)
  self:HideZoomKey(true)
end

function M:SwitchWeaponAccessoryPreview(TabIdx)
  if not self.ActorController or not self.Avatar then
    return
  end
  local WeaponToDisplay
  if 1 == TabIdx then
    WeaponToDisplay = self.Avatar.Weapons[self.Avatar.MeleeWeapon]
  elseif 2 == TabIdx then
    WeaponToDisplay = self.Avatar.Weapons[self.Avatar.RangedWeapon]
  else
    return
  end
  if not WeaponToDisplay then
    return
  end
  local AccessoryId = self.Params and self.Params.AccessoryId
  if not AccessoryId then
    return
  end
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController:ChangeSingleWeapon(WeaponToDisplay)
  self.ActorController:ChangeWeaponAccessory(AccessoryId, CommonConst.WeaponAccessoryTypes.Accessory)
end

function M:ReplayGesture(ResourceTypeId)
  if not self.ActorController or not self.ActorController.ArmoryPlayer then
    return
  end
  local ResourceData = DataMgr.Resource[ResourceTypeId]
  if ResourceData and ResourceData.ResourceSType == "GestureItem" then
    self.ActorController:PlayResourceMotion(ResourceTypeId)
  end
end

function M:RiderMount()
  self.IsRiderMount = not self.IsRiderMount
  if self.IsRiderMount then
    self.ActorController:HidePlayerOnMount(false)
  else
    self.ActorController:HidePlayerOnMount(true)
  end
end

function M:NotifySkyBox(Index)
  if not self.ActorController then
    return
  end
  self.ActorController:ChangeSkyBoxColor(Index)
end

function M:HidePlayerWeapon(IsHidden)
  if not self.ActorController:GetPlayerWeaponActor() then
    return
  end
  self.ActorController:GetPlayerWeaponActor():SetActorHideTag(self.UIName, IsHidden)
end

function M:HideSingleWeapon(IsHidden)
  local UIManager = UIManager(self)
  if not UIManager then
    return
  end
  if not UIManager.ShowWeapon then
    return
  end
  UIManager.ShowWeapon:SetActorHideTag(self.UIName, IsHidden)
  if not UIManager.ShowWeaponReflection then
    return
  end
  UIManager.ShowWeaponReflection:SetActorHideTag(self.UIName, IsHidden)
end

function M:HideAllPreviewActor()
  if self.ActorController then
    self.ActorController:HidePlayerActor(self.UIName, true)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(true)
  end
end

function M:StopActorSound()
  if self.ActorController and self.ActorController.ArmoryPlayer then
    self.ActorController:StopPlayerMontage()
    self.ActorController:StopPlayerFX()
    self.ActorController:RemovePlayerGestureEffectCreature()
  end
end

function M:SetCameraToDefault()
  if self.CurrentCameraState == "Default" then
    return
  end
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local PreviewController = self.ActorController
  if Controller and Player and PreviewController then
    self:CloseMVPSequence()
    Controller:SetViewTargetWithBlend(Player)
    self.CurrentCameraState = "Default"
  end
end

function M:SetCameraToPreviewActor()
  if self.CurrentCameraState == "Preview" then
    return
  end
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local PreviewController = self.ActorController
  if Controller and PreviewController then
    local PreviewTargetActor = PreviewController:GetViewTarget()
    if PreviewTargetActor then
      Controller:SetViewTargetWithBlend(PreviewTargetActor)
    end
  end
  self.CurrentCameraState = "Preview"
end

function M:ResetWeaponCamera()
  if self.ActorController then
    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    self.ActorController:SetSingleWeaponCamera(self.Params.Target, true)
    self.ActorController:EnableCameraScrolling(false)
  end
end

function M:CloseMVPSequence()
  if self.ActorController then
    self.ActorController:TryDestroySequenceActorController()
  end
end

function M:DestroyPreviewActor()
  if self.ActorController then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerController and Player and Player.AudioListener then
      PlayerController:SetAudioListenerOverride(Player.AudioListener, Const.ZeroVector, Const.ZeroRotator)
    end
    self.ActorController:DestroyMount()
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
  self.GeneralSkinRandomCache = nil
end

function M:ClosePreview()
  if self.ActorController then
    self.ActorController:RevertPlayerGestureEffectCreature()
  end
end

return M
