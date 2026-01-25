local M = {
  "BluePrints.Common.DelayFrameComponent"
}

function M:UpdatePreviewActor(ItemData, WeaponCameraOffset)
  self.Avatar = GWorld:GetAvatar()
  if not self.Avatar then
    return
  end
  self.UIName = self:GetUIConfigName()
  self.WeaponCameraOffset = WeaponCameraOffset or FVector(0, 0, 0)
  self:BlockAllUIInput(true)
  self:AddDelayFrameFunc(function()
    self:BlockAllUIInput(false)
  end, 31)
  self.Params = self:GenerateActorParams(ItemData)
  if not self.Params then
    return
  end
  self.Params.Target = self:CreatePreviewTargetData(self.Params)
  if not self.ActorController then
    self:InitializePreviewActor(ItemData)
  else
    self:HideAllPreviewActor()
    self:StopActorSound()
    self:UpdateExistingPreviewActor(ItemData)
  end
end

function M:GenerateActorParams(ItemData)
  local itemType = ItemData.ItemType
  if "Char" == itemType then
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
  elseif "GeneralSkin" == itemType then
    return self:_GenerateSkinSeriesParams(ItemData, self.Avatar)
  elseif "WeaponSkin" == itemType then
    return self:_GenerateWeaponSkinParams(ItemData)
  elseif "CharAccessory" == itemType then
    return self:_GenerateCharAccessoryParams(ItemData, self.Avatar)
  elseif "WeaponAccessory" == itemType then
    return self:_GenerateWeaponAccessoryParams(ItemData, self.Avatar)
  elseif "Resource" == itemType then
    return self:_GenerateCharGestureParams(ItemData, self.Avatar)
  end
  return nil
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
  local Gender2RoleIds = Const.DefaultAttributeMaster
  local PlayerCharId = Gender2RoleIds[Avatar.Sex]
  local Params
  for SkinId, Info in pairs(SkinInfo) do
    if Info.SkinSeries == ItemData.SkinSeries and Info.CharId == CharId then
      Params = {Type = "Char", SkinId = SkinId}
      break
    elseif Info.SkinSeries == ItemData.SkinSeries and Info.CharId == PlayerCharId then
      Params = {Type = "Char", SkinId = SkinId}
    end
  end
  if not Params then
    return nil
  end
  ItemData.ItemType = "Skin"
  ItemData.TypeId = Params.SkinId
  return Params
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
  if "Char" == itemType then
    self:SetupInitialCharPreview(ItemData)
  elseif "Weapon" == itemType then
    self:SetupInitialWeaponPreview(ItemData)
  elseif "Skin" == itemType then
    self:SetupInitialSkinPreview(ItemData)
  elseif "WeaponSkin" == itemType then
    self:SetupInitialWeaponSkinPreview(ItemData)
  elseif "Resource" == itemType then
    self:SetupInitialResourcePreview(ItemData)
  elseif "CharAccessory" == itemType or "WeaponAccessory" == itemType then
    self:ApplyAccessoryPreview(itemType)
  end
end

function M:UpdateExistingPreviewActor(ItemData)
  self:CleanupPreviousPreviewEffects()
  local itemType = ItemData.ItemType
  if "Char" == itemType then
    self:UpdateToCharPreview(ItemData)
  elseif "Weapon" == itemType then
    self:UpdateToWeaponPreview(ItemData)
  elseif "Skin" == itemType then
    self:UpdateToSkinPreview(ItemData)
  elseif "WeaponSkin" == itemType then
    self:UpdateToWeaponSkinPreview(ItemData)
  elseif "CharAccessory" == itemType then
    self:UpdateToCharAccessoryPreview(ItemData)
  elseif "WeaponAccessory" == itemType then
    self:UpdateToWeaponAccessoryPreview(ItemData)
  elseif "Resource" == itemType then
    self:UpdateToResourcePreview(ItemData)
  end
end

function M:CleanupPreviousPreviewEffects()
  self.ActorController:StopPlayerFX()
  self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
  self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Body)
  if self.ActorController.ArmoryPlayer then
    self.ActorController.ArmoryPlayer:RemoveAllEffectCreature()
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
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
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

function M:SetupInitialWeaponSkinPreview(ItemData)
  self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
  local Tag = self.Params.Target:HasTag("Melee") and "Melee" or "Ranged"
  self.ActorController:SetMontageAndCamera("Weapon", Tag)
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
end

function M:SetupInitialResourcePreview(ItemData)
  local ResourceData = DataMgr.Resource[ItemData.TypeId]
  if ResourceData then
    if ResourceData.ResourceSType == "GestureItem" then
      self:ClearCharAccessory()
      self.ActorController:ChangeWeaponModel(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
      self.ActorController:ChangeWeaponModel(self.Avatar.Weapons[self.Avatar.RangedWeapon])
      self.EffectCreatureHideTags = {}
      if self.ActorController.ArmoryPlayer.EffectCreatureHideTags then
        for k, v in pairs(self.ActorController.ArmoryPlayer.EffectCreatureHideTags) do
          self.EffectCreatureHideTags[k] = v
          self.ActorController.ArmoryPlayer:HideAllEffectCreature(k, false)
        end
      end
      self.ActorController:SetArmoryMontageTag(self.ActorController.ArmoryPlayer, "Armory")
      self.ActorController:SetArmoryCameraTag(ResourceData.CameraName or "Char", "", "")
      self.ActorController.ArmoryPlayer:InvokeResourceBPFunction(ItemData.TypeId)
    elseif ResourceData.ResourceSType == "MountItem" then
    end
  end
end

function M:ApplyAccessoryPreview(itemType)
  self.ActorController.bPlaySameMontage = true
  self:UpdateAccessoryCamera(self.Params.AccessoryId, self.Params.AccessoryType)
  if "CharAccessory" == itemType then
    self.ActorController:StopPlayerMontage()
    self:ClearCharAccessory()
    if UIConst.FXAccessoryTypes[self.Params.AccessoryType] then
      self.ActorController:ShowPlayerFXAccessory(self.Params.AccessoryId, self.Params.AccessoryType)
      if UIConst.HidePlayerAccessoryTypes[self.Params.AccessoryType] then
        self.ActorController:HidePlayerActor(self.UIName, true)
      end
    else
      self.ActorController:ChangeCharAccessory(self.Params.AccessoryId, self.Params.AccessoryType)
    end
  else
    self.ActorController:ChangeWeaponAccessory(self.Params.AccessoryId)
    self.ActorController.ArmoryHelper.EnableCameraScrolling = false
  end
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
  local WeaponData = self:CreatePreviewTargetData({
    Type = "Weapon",
    SkinId = ItemData.TypeId
  })
  self.ActorController.bStandaloneWeapon = true
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController:ChangeSingleWeapon(WeaponData)
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
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

function M:UpdateToWeaponSkinPreview(ItemData)
  self.ActorController:HidePlayerActor(self.UIName, true)
  self:HidePlayerWeapon(true)
  local WeaponData = self:CreatePreviewTargetData({
    Type = "Weapon",
    SkinId = ItemData.TypeId
  })
  self.ActorController.bStandaloneWeapon = true
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController:ChangeSingleWeapon(WeaponData)
  self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
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
  self.ActorController:ChangeWeaponAccessory(WeaponAccessoryData.WeaponAccessoryId)
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
end

function M:UpdateToResourcePreview(ItemData)
  self:SetupDefaultCharacterModel()
  self.ActorController:SetArmoryMontageTag(self.ActorController.ArmoryPlayer, "Armory")
  self.ActorController.ArmoryPlayer:InvokeResourceBPFunction(ItemData.TypeId)
  local GestureData = DataMgr.Resource[ItemData.TypeId]
  self.ActorController:SetArmoryCameraTag(GestureData.CameraName or "Char", "", "")
end

function M:ClearCharAccessory()
  self.ActorController:StopPlayerFX()
  self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
  self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Body)
  if self.ActorController.ArmoryPlayer then
    self.ActorController.ArmoryPlayer:RemoveAllEffectCreature()
  end
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
    self:HidePlayerWeapon(false)
    local WeaponData = self:CreatePreviewTargetData({Type = "Weapon", SkinId = rewardId})
    self.ActorController:ChangeWeaponModel(WeaponData)
    self.ActorController:ChangePlayerWeaponSkin(rewardId)
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
  local AppearanceInfo = {
    CharId = CharId,
    SkinId = CharSkinId,
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
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
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
  self.ActorController:ChangeCharModel(Data, true, true)
  self:UpdateAccessoryCamera(AccessoryData.AccessoryId, AccessoryData.AccessoryType)
  self.ActorController:StopPlayerMontage()
  self.ActorController:ChangeCharAccessory(AccessoryData.AccessoryId, AccessoryData.AccessoryType)
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
  self.ActorController:ChangeWeaponAccessory(WeaponAccessoryData.WeaponAccessoryId)
  self.ActorController.ArmoryHelper.EnableCameraScrolling = false
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
  self.ActorController:ChangeWeaponAccessory(AccessoryId)
end

function M:ReplayGesture(ResourceTypeId)
  if not self.ActorController or not self.ActorController.ArmoryPlayer then
    return
  end
  local ResourceData = DataMgr.Resource[ResourceTypeId]
  if ResourceData and ResourceData.ResourceSType == "GestureItem" then
    self.ActorController.ArmoryPlayer:InvokeResourceBPFunction(ResourceTypeId)
  end
end

function M:HidePlayerWeapon(IsHidden)
  if not self.ActorController:GetPlayerWeaponActor() then
    return
  end
  self.ActorController:GetPlayerWeaponActor():SetActorHideTag(self.UIName, IsHidden)
end

function M:HideSingleWeapon(IsHidden)
  if not UIManager(self).ShowWeapon then
    return
  end
  UIManager(self).ShowWeapon:SetActorHideTag(self.UIName, IsHidden)
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
    self.ActorController.ArmoryPlayer:RemoveAllEffectCreature()
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
      self.CurrentCameraState = "Preview"
    end
  end
end

function M:DestroyPreviewActor()
  if self.ActorController then
    self.ActorController:DestroyMount()
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
end

function M:ClosePreview()
  if self.ActorController then
    if self.EffectCreatureHideTags then
      for k, v in pairs(self.EffectCreatureHideTags) do
        self.ActorController.ArmoryPlayer:HideAllEffectCreature(k, v)
      end
    end
    self.ActorController:OnClosed()
  end
end

return M
