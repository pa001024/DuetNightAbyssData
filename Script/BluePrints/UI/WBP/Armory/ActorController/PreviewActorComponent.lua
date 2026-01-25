require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local M = {}

function M:CreatePreviewActor(Params)
  if not self.ActorController then
    local Char, Weapon
    if Params.Type == "Char" then
      Char = Params.Target
    else
      Weapon = Params.Target
    end
    self.NeedDestroyActorController = true
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = Char,
      Weapon = Weapon,
      Avatar = self._DummyAvatar,
      bNeedEndCamera = false,
      EPreviewSceneType = Params.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon,
      SkyBoxColor = Params.SkyBoxColor
    })
  end
  return self.ActorController
end

function M:CreatePreviewTargetData(Params)
  local Avatar = GWorld:GetAvatar()
  if Params.Type == "Char" then
    local Char = Avatar.Chars[Avatar.CurrentChar]
    local SkinId = Params.SkinId
    if SkinId then
      local SkinData = DataMgr.Skin[SkinId]
      if SkinData.CharId ~= Char.CharId or Params.SystemType == "BattlePass" then
        local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime, {
          CharIds = {
            SkinData.CharId
          }
        })
        self._DummyAvatar = DummyAvatar
        if self.ActorController then
          self.ActorController:SetAvatar(self._DummyAvatar)
        end
        local _, temp = next(DummyAvatar.Chars)
        Char = temp
        Char:GetAppearance().SkinId = SkinId
        if Params.Accessory then
          local AppearanceSuit = Char:GetAppearance()
          for k, v in pairs(Params.Accessory) do
            AppearanceSuit.Accessory[k] = v
          end
        end
      end
    end
    return Char
  elseif Params.Type == "Weapon" then
    local Weapon
    if Params.SkinId then
      local WeaponId
      local SkinData = DataMgr.WeaponSkin[Params.SkinId]
      local AppType
      if SkinData then
        AppType = SkinData.ApplicationType
      else
        SkinData = DataMgr.Weapon[Params.SkinId]
        if SkinData then
          WeaponId = Params.SkinId
          AppType = SkinData.SkinApplicationType[1]
        end
      end
      if nil == WeaponId then
        for key, value in pairs(DataMgr.Weapon) do
          if UIUtils.CanApplyWeaponSkin(value.WeaponId, AppType) then
            WeaponId = value.WeaponId
            break
          end
        end
      end
      if WeaponId then
        local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime, {
          WeaponIds = {WeaponId}
        })
        self._DummyAvatar = DummyAvatar
        if self.ActorController then
          self.ActorController:SetAvatar(self._DummyAvatar)
        end
        local _, temp = next(DummyAvatar.Weapons)
        Weapon = temp
        Weapon:GetAppearance().SkinId = Params.SkinId
        Weapon:AddSkin(Params.SkinId)
        if Params.Accessory then
          local AppearanceSuit = Weapon:GetAppearance()
          for k, v in pairs(Params.Accessory) do
            AppearanceSuit.Accessory[k] = v
          end
        end
      end
    else
      Weapon = Avatar.Weapons[Avatar.MeleeWeapon]
      Weapon = Weapon or Avatar.Weapons[Avatar.RangedWeapon]
    end
    return Weapon
  end
end

function M:UpdateAccessoryCamera(AccessoryId, AccessoryType)
  if self.ActorController:IsWeaponActorLoading() then
    return
  end
  if self.ActorController then
    local _AccessoryType = AccessoryType
    if not _AccessoryType then
      local Data = DataMgr.CharAccessory[AccessoryId]
      if Data then
        _AccessoryType = Data.AccessoryType
      else
        Data = DataMgr.CharPartMesh[AccessoryId]
        _AccessoryType = Data.AccessoryType
      end
    end
    self.ActorController.CameraOffsetAccessoryId = AccessoryId
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, _AccessoryType, CommonConst.ArmoryTag.Appearance)
  end
end

function M:SwitchWeaponAccessoryPreview(TabIdx)
  local Avatar = GWorld:GetAvatar()
  if not self.ActorController or not Avatar then
    return
  end
  local WeaponToDisplay
  if 1 == TabIdx then
    WeaponToDisplay = Avatar.Weapons[Avatar.MeleeWeapon]
  elseif 2 == TabIdx then
    WeaponToDisplay = Avatar.Weapons[Avatar.RangedWeapon]
  else
    return
  end
  if not WeaponToDisplay then
    return
  end
  local AccessoryId = self.CurRoleContent and self.CurRoleContent.AccessoryId
  if not AccessoryId then
    return
  end
  self.ActorController.ExCameraOffset = self.WeaponCameraOffset
  self.ActorController:ChangeSingleWeapon(WeaponToDisplay)
  self.ActorController:ChangeWeaponAccessory(AccessoryId)
end

function M:ClearCharAccessoryPreview()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.ActorController:StopPlayerFX()
  self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
  self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Body)
  if self.ActorController.ArmoryPlayer then
    self.ActorController.ArmoryPlayer:RemoveAllEffectCreature()
  end
  local Char = Avatar.Chars[Avatar.CurrentChar]
  local CharSkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
  local AppearanceInfo = {
    CharId = Char.CharId,
    SkinId = CharSkinId,
    AccessorySuit = {}
  }
  self.ActorController:ChangeCharAppearance(AppearanceInfo)
end

function M:Destruct()
  if self.NeedDestroyActorController and self.ActorController then
    self.ActorController:OnDestruct()
  end
end

AssembleComponents(M)
return M
