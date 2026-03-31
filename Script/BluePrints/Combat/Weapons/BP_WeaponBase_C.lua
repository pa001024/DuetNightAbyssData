require("UnLua")
local EffectResults = require("BluePrints.Combat.BattleLogic.EffectResults")
local EMCache = require("EMCache.EMCache")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local BP_WeaponBase_C = Class({
  "BluePrints.Combat.Components.EffectSourceInterface"
})
BP_WeaponBase_C._components = {
  "BluePrints.Combat.Weapons.WeaponAttrComponent",
  "BluePrints.Combat.Components.SkillLevelInterface",
  "BluePrints.Combat.Components.ActorTypeComponent",
  "BluePrints.Common.DelayFrameComponent"
}

function BP_WeaponBase_C:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self.ForbidTag = {}
  self.AccessoryAuName_Accessory = nil
  self.AccessoryAuName_RunAttack = nil
end

function BP_WeaponBase_C:OnRep_ServerBornInfo()
  self.BornInfo = EffectResults.UnpackEffectStruct(self.ServerBornInfo)
end

function BP_WeaponBase_C:SetBornInfo()
  if not self.BornInfo then
    self.BornInfo = EffectResults.Result()
  end
end

function BP_WeaponBase_C:IsReplaceAttrs()
  return not self.ReplaceAttrs
end

function BP_WeaponBase_C:SetBornInfoAppearance()
  self.BornInfo.AppearanceInfo = self.AppearanceInfo
end

function BP_WeaponBase_C:SetData()
  self.Data = DataMgr.BattleWeapon[self.WeaponId]
end

function BP_WeaponBase_C:ApplyWeaponAttributes()
  if not self:CanApplyWeaponAttributes() then
    return
  end
  local attrs = rawget(self, "ReplaceAttrs")
  self:SetTableAttr(attrs)
end

function BP_WeaponBase_C:SetServerBornInfo()
  self.ServerBornInfo = self.BornInfo:ToEffectStruct()
end

function BP_WeaponBase_C:Lua_InitWeaponAppearance()
  self:InitWeaponAppearance(self.AppearanceInfo)
end

function BP_WeaponBase_C:InitWeaponAppearance(AppearanceInfo)
  self.AppearanceInfo = AppearanceInfo
  self:InitWeaponSkin(AppearanceInfo and AppearanceInfo.SkinId)
  if self.bIsShow then
    return
  end
  self:Lua_InitShowWeaponAppearance()
end

function BP_WeaponBase_C:Lua_InitShowWeaponAppearance()
  self:InitWeaponBreakMI()
  self:InitWeaponColor(self.AppearanceInfo and self.AppearanceInfo.Colors)
  local AccessorySuit = self.AppearanceInfo and self.AppearanceInfo.AccessorySuit or {}
  for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.WeaponAccessoryTypeIndex) do
    self:ChangeAccessory(AccessorySuit[AccessoryTypeIdx], AccessoryType)
  end
  EventManager:FireEvent(EventID.OnShowWeaponLoadFinished, self)
end

function BP_WeaponBase_C:InitWeaponSkin(SkinId)
  self:InitWeaponSkinImpl(SkinId, self.bIsShow)
end

function BP_WeaponBase_C:InitWeaponColor(Colors)
  if Colors then
    local SpecialColor = Colors.SpecialColor
    if SpecialColor == DataMgr.GlobalConstant.WeaponDefaultColor.ConstantValue then
      self:InitWeaponPartsColor(Colors)
    else
    end
  end
end

function BP_WeaponBase_C:InitWeaponPartsColor(Colors)
  if self.ChildWeapon then
    self.ChildWeapon:InitWeaponPartsColor(Colors)
  end
  if Colors.Colors then
    local SwatchData = DataMgr.Swatch
    local Color = FLinearColor()
    for PartIdx, ColorId in ipairs(Colors.Colors) do
      local func = self["SetWPTintColor" .. PartIdx]
      local ColorData = SwatchData[ColorId]
      if ColorData and func then
        if ColorData.ActualR and ColorData.ActualG and ColorData.ActualB then
          Color = FLinearColor(ColorData.ActualR, ColorData.ActualG, ColorData.ActualB)
          func(self, Color)
        elseif ColorData.ColorNumber then
          local ColorNumber = ColorData.ColorNumber
          UKismetMathLibrary.LinearColor_SetFromSRGB(Color, FColor(ColorNumber[1] or 0, ColorNumber[2] or 0, ColorNumber[3] or 0))
          func(self, Color)
        end
      end
    end
  end
end

function BP_WeaponBase_C:InitWeaponSpecialColor(Colors)
  if self.ChildWeapon then
    self.ChildWeapon:InitWeaponSpecialColor(Colors)
  end
  if Colors.SpecialColor then
    local Data = DataMgr.SpecialSwatch[Colors.SpecialColor]
    if Data and Data.LinkedMaterial then
      self:ChangeWPMaterial(Data.LinkedMaterial)
    end
  end
end

function BP_WeaponBase_C:ChangeAccessory(AccessoryId, AccessoryType)
  local Data = DataMgr.WeaponAccessory[AccessoryId]
  if AccessoryType == CommonConst.WeaponAccessoryTypes.Accessory then
    self:DetachWeaponSuit()
    if nil == Data then
      self.AccessoryAuName_Accessory = nil
      self.AccessoryAuName = self.AccessoryAuName_Accessory or self.AccessoryAuName_RunAttack or ""
      return
    end
    local Offsets = Data.Offset or {
      0,
      0,
      0
    }
    local Offset = FTransform(FRotator(0, 0, 0):ToQuat(), FVector(Offsets[1] or 0, Offsets[2] or 0, Offsets[3] or 0))
    self:AttachWeaponSuit(Data.AccessorySocket, Data.ModelPath, Offset, Data.NiagaraPath, Data.SocketName)
    self:ChangeWPSuitLook(Data.ChangeColor or 1)
    if Data.AuSplice then
      self.AccessoryAuName_Accessory = Data.AuSplice
      self.AccessoryAuName = self.AccessoryAuName_Accessory or self.AccessoryAuName_RunAttack or ""
    else
      self.AccessoryAuName_Accessory = nil
      self.AccessoryAuName = self.AccessoryAuName_Accessory or self.AccessoryAuName_RunAttack or ""
    end
    return
  end
  if AccessoryType == CommonConst.WeaponAccessoryTypes.RunAttack then
    if nil == Data then
      self.AccessoryAuName_RunAttack = nil
      self.AccessoryAuName = self.AccessoryAuName_Accessory or self.AccessoryAuName_RunAttack or ""
      return
    end
    if Data.AuSplice then
      self.AccessoryAuName_RunAttack = Data.AuSplice
      self.AccessoryAuName = self.AccessoryAuName_Accessory or self.AccessoryAuName_RunAttack or ""
    else
      self.AccessoryAuName_RunAttack = nil
      self.AccessoryAuName = self.AccessoryAuName_Accessory or self.AccessoryAuName_RunAttack or ""
    end
  end
  if nil == Data then
    return
  end
  if Data.StanceFXType and Data.StanceFXTag then
    self.StanceFXName = Data.StanceFXType .. "_" .. Data.StanceFXTag .. "_"
    self.StanceFXType = Data.StanceFXType
    self.StanceFXTag = Data.StanceFXTag
  else
    self.StanceFXName = ""
    self.StanceFXType = ""
    self.StanceFXTag = ""
  end
end

function BP_WeaponBase_C:ClearAccessories()
  for i = 1, self.Accessories:Length() do
    local Accessory = self.Accessories:GetRef(i)
    Accessory:K2_DestroyActor()
  end
  self.Accessories:Clear()
end

function BP_WeaponBase_C:Destroy()
  if self.Owner ~= nil then
    self.Owner:RemovePassiveEffectByWeapon(self)
    self:RemoveWeaponSkill()
  end
  self:ClearAccessories()
  if self.ChildWeapon then
    self.ChildWeapon:K2_DestroyActor()
  end
  self:K2_DestroyActor()
end

function BP_WeaponBase_C:GetSkillByType(SkillType)
  if not self.TypeSkills then
    return 0
  end
  return self.TypeSkills[SkillType]
end

function BP_WeaponBase_C:GetWeaponOwner()
  return self.Owner
end

function BP_WeaponBase_C:AddWeaponSkill()
  if not self.Owner then
    return
  end
  if self.Owner.FromOtherWorld then
    return
  end
  if self.SkillInfos then
    for SkillId, SkillInfo in pairs(self.SkillInfos) do
      local SkillLevel = SkillInfo.Level or Const.DefaultSkillLevel
      local SkillGrade = SkillInfo.Grade or Const.DefaultSkillGrade
      if self.Owner.SkillsComponent then
        self.Owner.SkillsComponent:ServerAddSkillInfo(SkillId, SkillLevel, SkillGrade, 0, self)
      end
    end
  else
    local SkillLevel = 1
    local SkillGrade = 0
    local SkillList = self.Data.WeaponSkillList
    if self.Data.InheritSkillId then
      local Skill = self.Owner:GetSkill(self.Data.InheritSkillId)
      if Skill then
        SkillLevel = 0 == Skill.SkillLevel and 1 or Skill.SkillLevel
        SkillGrade = 0 == Skill.SkillGrade and 0 or Skill.SkillGrade
      end
    end
    if nil ~= SkillList then
      for _, SkillId in ipairs(SkillList) do
        if self.Owner.SkillsComponent then
          self.Owner.SkillsComponent:ServerAddSkillInfo(SkillId, SkillLevel, SkillGrade, 0, self)
        end
      end
    end
  end
end

function BP_WeaponBase_C:RemoveWeaponSkill()
  if not self.Owner then
    return
  end
  local SkillList = self.Data.WeaponSkillList
  if nil ~= SkillList then
    for i, SkillId in pairs(SkillList) do
      if self.Owner.SkillsComponent then
        self.Owner.SkillsComponent:ServerRemoveSkillInfo(SkillId)
      end
      if SkillId == self.Owner.CurrentSkillId then
        self.Owner:StopSkill(UE.ESkillStopReason.SkillRemove)
      end
    end
  end
end

function BP_WeaponBase_C:GetSkills()
  local Skills = {}
  if self.Owner.SkillsComponent and self.Owner.SkillsComponent.SkillInfos then
    for _, Data in pairs(self.Owner.SkillsComponent.SkillInfos) do
      if Data.Weapon and Data.Weapon == self then
        local SkillId = Data.SkillId
        table.insert(Skills, SkillId)
      end
    end
  else
    local SkillList = self.Data.WeaponSkillList
    if nil ~= SkillList then
      for _, v in pairs(SkillList) do
        table.insert(Skills, v)
      end
    end
  end
  return Skills
end

function BP_WeaponBase_C:OnLeave(DontPlayDissolve)
  if not self.InHand then
    return
  end
  self.InHand = false
  if not self.InitSuccess then
    return
  end
  self:ShouldHideWeapon()
  self:UnBindWeaponFromHand(DontPlayDissolve)
  for i = 1, self.Accessories:Length() do
    self.Accessories:GetRef(i):OnLeave()
  end
end

function BP_WeaponBase_C:WeaponBright()
  if not self:CheckWeaponIsClient() then
    return
  end
  self.Overridden.WeaponBright(self)
  if self.ChildWeapon then
    self.ChildWeapon:WeaponBright()
  end
end

function BP_WeaponBase_C:RemoveWeaponBright()
  if not self:CheckWeaponIsClient() then
    return
  end
  self.Overridden.RemoveWeaponBright(self)
  if self.ChildWeapon then
    self.ChildWeapon:RemoveWeaponBright()
  end
end

function BP_WeaponBase_C:EnterIdleAnimationRepPlay_Implementation(AnimIndex)
  self:EnterIdleAnimation(AnimIndex)
end

function BP_WeaponBase_C:GetWeaponTypes()
  return CommonConst.WeaponTypes
end

function BP_WeaponBase_C:GetWeaponMeleeOrRanged()
  local WeaponTags = self:GetWeaponTags()
  if WeaponTags:Contains("Condemn") then
    return "Condemn"
  end
  if WeaponTags:Contains("Ultra") then
    return "Ultra"
  end
  if WeaponTags:Contains("Ranged") then
    return "Ranged"
  end
  return "Melee"
end

function BP_WeaponBase_C:GetHideDelayTimeOnMoveToBack()
  return 5
end

function BP_WeaponBase_C:IsHyperWeapon()
  return HyperWeaponUtils.IsHyperWeapon(self.WeaponId)
end

function BP_WeaponBase_C:IsHyperWeaponSkillActivated(HyperWeaponSkillId)
  if not self:IsHyperWeapon() then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  local HyperWeaponUid
  local _ServerMeleeWeapon = Avatar and Avatar.Weapons[Avatar.MeleeWeapon]
  if _ServerMeleeWeapon and _ServerMeleeWeapon.WeaponId == self.WeaponId then
    HyperWeaponUid = Avatar.MeleeWeapon
  else
    local _ServerRangedWeapon = Avatar and Avatar.Weapons[Avatar.RangedWeapon]
    if _ServerRangedWeapon and _ServerRangedWeapon.WeaponId == self.WeaponId then
      HyperWeaponUid = Avatar.RangedWeapon
    end
  end
  if not HyperWeaponUid then
    return false
  end
  return HyperWeaponUtils.IsHyperWeaponSkillActivated(HyperWeaponUid, HyperWeaponSkillId)
end

AssembleComponents(BP_WeaponBase_C)
return BP_WeaponBase_C
