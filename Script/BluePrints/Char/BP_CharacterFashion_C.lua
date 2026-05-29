require("UnLua")
require("Utils")
local EMLuaConst = require("EMLuaConst")
local BP_CharacterFashion_C = Class({
  "BluePrints.Common.FashionComponent_C",
  "BluePrints.Common.TimerMgr"
})

function BP_CharacterFashion_C:EnableDrawMaterialCharacterRim(bEnabled)
  for i = 1, self.AllMaterials:Length() do
    local v = self.AllMaterials:GetRef(i)
    if IsValid(v) then
      if bEnabled then
        v:SetScalarParameterValue("RimIntensity", 1.0)
      else
        v:SetScalarParameterValue("RimIntensity", 0.0)
      end
    end
  end
end

function BP_CharacterFashion_C:ShowDamage()
  if self.AllMaterials:Length() > 0 then
    for i = 1, self.AllMaterials:Length() do
      local v = self.AllMaterials:GetRef(i)
      if IsValid(v) then
        v:SetScalarParameterValue("StartTime_BeAttacked", UE4.UGameplayStatics.GetTimeSeconds(self))
      end
    end
  end
end

function BP_CharacterFashion_C:ShowDissolve(DissolveDuration)
  for i = 1, self.AllMaterials:Length() do
    local v = self.AllMaterials:GetRef(i)
    if IsValid(v) then
      v:SetScalarParameterValue("StartTime_Dissolve", UE4.UGameplayStatics.GetTimeSeconds(self))
      v:SetScalarParameterValue("Duration_Dissolve", DissolveDuration)
      v.NextPass = nil
    end
  end
end

function BP_CharacterFashion_C:GetPartMesh(PartName)
  local Owner = self:GetOwner()
  if "Horn" == PartName then
    local Result = TArray(USkeletalMeshComponent)
    Result:Add(Owner.Mesh)
    return Result
  end
  if Owner.SuitMeshComponentsMap then
    return Owner.SuitMeshComponentsMap:FindRef(PartName)
  end
end

function BP_CharacterFashion_C:ColletctPartMeshIds(AppearanceSuitInfo, PartMeshIds)
  if not AppearanceSuitInfo then
    return
  end
  local AccessorySuit = AppearanceSuitInfo.AccessorySuit or {}
  local PartMeshAccessoryId, _ = self:GetOwnerPartMeshInfo(AppearanceSuitInfo.SkinId)
  table.insert(PartMeshIds, PartMeshAccessoryId)
  for _, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
    local AccessoryId = AccessorySuit[AccessoryTypeIdx]
    if AccessoryId and AccessoryId ~= PartMeshAccessoryId then
      table.insert(PartMeshIds, AccessoryId)
    end
  end
end

local function CreateAccessoryHideTags(self)
  rawset(self, "AccessoryHideTags", {})
  for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
    self.AccessoryHideTags[AccessoryType] = {}
  end
end

local function AddAccessoryHideTag(self, AccessoryType, Tag)
  self.AccessoryHideTags[AccessoryType][Tag] = true
end

local function RemoveAccessoryHideTag(self, AccessoryType, Tag)
  self.AccessoryHideTags[AccessoryType][Tag] = nil
end

local function IsAccessoryHiddenByAnyTag(self, AccessoryType)
  return self.AccessoryHideTags[AccessoryType] and not not next(self.AccessoryHideTags[AccessoryType])
end

function BP_CharacterFashion_C:InitAppearanceSuit(Info)
  print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit")
  rawset(self, "AppearanceSuitInfo", Info)
  rawset(self, "Type2Id", rawget(self, "Type2Id") or TMap(FName, 0))
  self:InitWeaponColor(Info.Colors)
  self.InitPartIds = {}
  self.InitWithCombinePart = false
  self.SkinLevel = Info.SkinLevel
  CreateAccessoryHideTags(self)
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  if not Info then
    self:ChangeAccessoryWithDefautl()
    Owner:InitPartMeshCompWithDefault()
    return
  end
  self.Type2PartId = nil
  self.InitWithCombinePart = true
  print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit Show Cloak", Info.IsShowPartMesh)
  if EMLuaConst.ShouldCombinePartMesh then
    self.InitWithCombinePart = true
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit combine", self.InitWithCombinePart, Owner.FromArmory)
  end
  self:ChangeCharSkin(Info.SkinId)
  local DefaultFacePart = Owner.DefaultCharPartId:Find("Body")
  if self.InitWithCombinePart then
    table.insert(self.InitPartIds, DefaultFacePart)
  else
    Owner:SetPartMesh(DefaultFacePart, true)
  end
  self:CheckShouldHideHair(Info.AccessorySuit)
  self:ChangeCharHair(Info.HairId)
  print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit hair", Info.HairId, #self.InitPartIds)
  local AccessorySuit = Info.AccessorySuit or self:GetDefaultAccessorySuit()
  local AccessoryCustomParams = Info.AccessoryCustomParams or {}
  for i, v in pairs(Owner.DefaultCharPartId) do
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit part", v, i)
  end
  for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
    local AccessoryId = AccessorySuit[AccessoryTypeIdx]
    local Transform = CommonUtils.UnSerializeAccessoryCustomParams(AccessoryCustomParams[AccessoryId], AccessoryType)
    self:ChangeAccessory(AccessoryId, AccessoryType, Transform)
    local InValidAccId = not AccessoryId
    if not InValidAccId or IsAccessoryHiddenByAnyTag(self, AccessoryType) or self.InitWithCombinePart then
    else
      Owner:RecoverDefaultPartMesh(AccessoryType)
    end
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit acc", AccessoryId, AccessoryType)
  end
  if Owner and self.InitWithCombinePart then
    if #self.InitPartIds > 0 then
      Owner:InitPartMeshComp(self.InitPartIds)
    end
    self.InitWithCombinePart = false
  end
  local HairData = DataMgr.Hair[Info.HairId]
  if HairData then
    self:ChangePartLook("Hair", HairData.ChangeColor or 1)
  end
  self:CreateAllDynamicMaterialNew()
  if self.CharTinColorMap then
    self.CharTinColorMap:Clear()
  end
  local Colors = Info.Colors
  self:InitSkinColors(Colors)
  self:InitHairColors(Info.HairColors)
  if Owner.InfoForInit then
    self:GradeUpEmissive(Owner.InfoForInit.GradeLevel)
  end
end

function BP_CharacterFashion_C:RecordPartTypeAndId()
  self.Type2PartId = {}
  for i, v in pairs(self.InitPartIds) do
    local PartData = DataMgr.CharPartModel[v]
    if PartData then
      local PartType = PartData.PartType
      if PartType and not self.Type2PartId[PartType] then
        self.Type2PartId[PartType] = v
      end
    end
  end
end

function BP_CharacterFashion_C:ChangeCharSkin(SkinId)
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  if Owner.ChangeSkinModel then
    Owner:ChangeSkinModel(SkinId)
  end
  self:InitSkinLevelUpVisEffect(SkinId)
end

function BP_CharacterFashion_C:InitSkinLevelUpVisEffect(SkinId)
  self:StopCreateEffectTimer(true)
  self:RemoveAllSkinLevelUpVisEffect()
  self:RemoveAllSkinLevelUpEffectCreature()
  self:CreateSkinLevelUpEffect(SkinId)
end

function BP_CharacterFashion_C:StopCreateEffectTimer(ForceRemove)
  local Owner = self:GetOwner()
  if not ForceRemove and Owner.FromArmory then
    return
  end
  Owner:RemoveTimer("FirstCreateEffect")
  Owner:RemoveTimer("SecondCreateEffect")
end

function BP_CharacterFashion_C:SetTimerForCreateEffectOnSkillLevelUp(SkinId)
  local Owner = self:GetOwner()
  local SkinConfig = DataMgr.Skin[SkinId]
  if not SkinConfig or not SkinConfig.TimerInterval then
    return
  end
  if not self.NotAlwaysVisualEffect and not self.NotAlwaysEffectCreature then
    return
  end
  self:StopCreateEffectTimer(true)
  local TimerInterval = SkinConfig.TimerInterval
  local FirstTime = Owner.FromArmory and TimerInterval[1] or TimerInterval[2]
  if FirstTime then
    Owner:AddTimer(FirstTime, function()
      local NotAlwaysVisualEffect = self.NotAlwaysVisualEffect or {}
      for Id, Data in pairs(NotAlwaysVisualEffect) do
        Owner.FXComponent:PlayEffectByIDParams(Id, {
          NotAttached = not Data.IsAttach
        })
      end
      local NotAlwaysEffectCreature = self.NotAlwaysEffectCreature or {}
      for Id, Data in pairs(NotAlwaysEffectCreature) do
        Owner:AsyncCreateEffectCreature(Id, FTransform(), not not Data.IsAttach, "")
      end
      local SecondTime = TimerInterval[3]
      if SecondTime then
        Owner:AddTimer(SecondTime, function()
          for Id, Data in pairs(NotAlwaysVisualEffect) do
            Owner.FXComponent:PlayEffectByIDParams(Id, {
              NotAttached = not Data.IsAttach
            })
          end
          for Id, Data in pairs(NotAlwaysEffectCreature) do
            Owner:AsyncCreateEffectCreature(Id, FTransform(), not not Data.IsAttach, "")
          end
        end, true, 0, "SecondCreateEffect", Owner.FromArmory)
      end
    end, false, 0, "FirstCreateEffect", Owner.FromArmory)
  end
end

function BP_CharacterFashion_C:CreateSkinLevelUpEffect(SkinId)
  local Owner = self:GetOwner()
  self.NotAlwaysVisualEffect = self:CreateSkinLevelUpVisualEffect(SkinId)
  self.NotAlwaysEffectCreature = self:CreateSkinLevelUpEffectCreature(SkinId)
  local CharacterTag = Owner:GetCharacterTag()
  if Owner.FromArmory or "Idle" == CharacterTag then
    self:SetTimerForCreateEffectOnSkillLevelUp(SkinId)
  end
end

function BP_CharacterFashion_C:IsContainsLevel(Levels)
  if not Levels then
    return
  end
  if type(Levels) == "number" then
    return Levels == self.SkinLevel
  end
  for i = 1, #Levels do
    if Levels[i] == self.SkinLevel then
      return true
    end
  end
end

function BP_CharacterFashion_C:RemoveAllSkinLevelUpVisEffect()
  if not self.LevelUpVisualEffects or 0 == #self.LevelUpVisualEffects then
    return
  end
  local Owner = self:GetOwner()
  for i, v in ipairs(self.LevelUpVisualEffects) do
    Owner.FXComponent:StopEffectByID(v, true)
    self.NiagaraGroup1:Remove(v)
  end
end

function BP_CharacterFashion_C:RemoveAllSkinLevelUpEffectCreature()
  if not self.LevelUpEffectCreatures or 0 == #self.LevelUpEffectCreatures then
    return
  end
  local Owner = self:GetOwner()
  for i, v in ipairs(self.LevelUpEffectCreatures) do
    Owner:RemoveEffectCreature(v)
  end
end

function BP_CharacterFashion_C:CreateSkinLevelUpVisualEffect(SkinId)
  local SkinConfig = DataMgr.Skin[SkinId]
  if not SkinConfig or not SkinConfig.LevelUpVisualEffects then
    return {}
  end
  local NotAlwaysVisualEffect = {}
  local Owner = self:GetOwner()
  local LevelUpVisualEffects = SkinConfig.LevelUpVisualEffects
  self.LevelUpVisualEffects = {}
  for VisualEffectId, LevelUpVisualEffect in pairs(LevelUpVisualEffects) do
    if self:IsContainsLevel(LevelUpVisualEffect.Level) then
      if LevelUpVisualEffect.IsAlways then
        local FxObject = Owner.FXComponent:PlayEffectByIDParams(VisualEffectId, {
          NotAttached = not LevelUpVisualEffect.IsAttach
        })
        if FxObject then
          self.NiagaraGroup1:Add(VisualEffectId, FxObject)
        end
      else
        NotAlwaysVisualEffect[VisualEffectId] = LevelUpVisualEffect
      end
      table.insert(self.LevelUpVisualEffects, VisualEffectId)
    end
  end
  return NotAlwaysVisualEffect
end

function BP_CharacterFashion_C:CreateSkinLevelUpEffectCreature(SkinId)
  local SkinConfig = DataMgr.Skin[SkinId]
  if not SkinConfig or not SkinConfig.LevelUpEffectCreatures then
    return {}
  end
  local NotAlwaysEffectCreature = {}
  local Owner = self:GetOwner()
  local LevelUpEffectCreatures = SkinConfig.LevelUpEffectCreatures
  self.LevelUpEffectCreatures = {}
  for EffectCreatureId, LevelUpEffectCreature in pairs(LevelUpEffectCreatures) do
    if self:IsContainsLevel(LevelUpEffectCreature.Level) then
      if LevelUpEffectCreature.IsAlways then
        Owner:AsyncCreateEffectCreatureWithCallBack(EffectCreatureId, FTransform(), not not LevelUpEffectCreature.IsAttach, "", {
          self,
          function(_, Creature)
            Creature:OnSkinLevelUp()
            Creature:OnSkinLeveupTin(self.CharTinColorMap)
          end
        })
      else
        NotAlwaysEffectCreature[EffectCreatureId] = LevelUpEffectCreature
      end
      table.insert(self.LevelUpEffectCreatures, EffectCreatureId)
    end
  end
  return NotAlwaysEffectCreature
end

local function GetCharPartIdByAccessoryId(AccessoryId)
  local Data = DataMgr.CharAccessory[AccessoryId]
  local CharPartId = Data and Data.CharPartId
  if not CharPartId then
    local CharPartMeshData = DataMgr.CharPartMesh[AccessoryId]
    CharPartId = CharPartMeshData and CharPartMeshData.CharPartId
  end
  return CharPartId
end

function BP_CharacterFashion_C:CheckShouldHideHair(AccessorySuit)
  rawset(self, "HideHiarByAccessory", {})
  if not AccessorySuit then
    return
  end
  for AccessoryTypeIdx, AccessoryId in pairs(AccessorySuit) do
    local Data = DataMgr.CharAccessory[AccessoryId]
    if Data and Data.IsTail then
      self.HideHiarByAccessory[AccessoryTypeIdx] = true
      break
    end
  end
end

function BP_CharacterFashion_C:IsHideHiarByAccessory(AccessoryType)
  if not CommonConst.NewCharAccessoryTypes[AccessoryType] then
    return
  end
  return self.HideHiarByAccessory[CommonConst.NewCharAccessoryTypes[AccessoryType]]
end

function BP_CharacterFashion_C:IsHideHiarByAnyAccessory()
  return not not next(self.HideHiarByAccessory)
end

function BP_CharacterFashion_C:SetHideHiarByAccessory(AccessoryType, bHide)
  if not CommonConst.NewCharAccessoryTypes[AccessoryType] then
    return
  end
  if bHide then
    self.HideHiarByAccessory[CommonConst.NewCharAccessoryTypes[AccessoryType]] = true
  else
    self.HideHiarByAccessory[CommonConst.NewCharAccessoryTypes[AccessoryType]] = nil
  end
end

function BP_CharacterFashion_C:RecoverHairMesh()
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  local HairType = CommonConst.DataType.Hair
  local HairData = DataMgr.Hair[rawget(self, "CurrentHairId")]
  Owner:DeactivatePartMeshComp(HairType)
  if HairData then
    if HairData.CharPartId then
      if self.Type2PartId then
        self.Type2PartId[HairType] = HairData.CharPartId
      else
        Owner:SetPartMesh(HairData.CharPartId)
      end
    end
  elseif not self.InitWithCombinePart then
    Owner:RecoverDefaultPartMesh(HairType)
  end
  for PartIdx, value in pairs(self.RealHairPartColors or {}) do
    self:ChangeHairPartColor(PartIdx, value.Color, value.Fresnel)
  end
end

function BP_CharacterFashion_C:ChangeCharHair(HairId)
  RemoveAccessoryHideTag(self, CommonConst.CharAccessoryTypes.Hat, CommonConst.DataType.Hair)
  rawset(self, "CurrentHairId", HairId)
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  local HairType = CommonConst.DataType.Hair
  local DefaultHairId = Owner.DefaultCharPartId:Find(HairType)
  if 2101 == HairId and Owner.CurrentSkinId == 210102 or 5101 == HairId and Owner.CurrentSkinId == 510101 or 5101 == HairId and Owner.CurrentSkinId == 51010010 then
    HairId = DefaultHairId
    rawset(self, "CurrentHairId", HairId)
  end
  local HairData = DataMgr.Hair[HairId]
  if HairData and HairData.IsHideHat then
    AddAccessoryHideTag(self, CommonConst.CharAccessoryTypes.Hat, CommonConst.DataType.Hair)
  end
  if self.InitWithCombinePart then
    Owner:DetachSuitItem(HairType)
    Owner:DeactivatePartMeshComp(HairType)
    if not HairData then
      if not self:IsHideHiarByAnyAccessory() then
        if self.Type2PartId then
          self.Type2PartId[HairType] = DefaultHairId
          self:ReInitPartMesh()
          return
        end
        table.insert(self.InitPartIds, DefaultHairId)
      end
      return
    end
    if self:IsHideHiarByAnyAccessory() and not HairData.IsHideHat then
      if self.Type2PartId then
        self.Type2PartId[HairType] = 0
        self:ReInitPartMesh()
      end
      return
    end
    local RealHairId = DefaultHairId
    if HairData.CharPartId then
      RealHairId = HairData.CharPartId
    end
    if self.Type2PartId then
      self.Type2PartId[HairType] = RealHairId
      self:ReInitPartMesh()
    elseif RealHairId then
      table.insert(self.InitPartIds, RealHairId)
    end
    Owner:DetachSuitItem(HairType)
    if HairData.IsHideHat then
      AddAccessoryHideTag(self, CommonConst.CharAccessoryTypes.Hat, CommonConst.DataType.Hair)
      self:ChangeAccessory(DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue, CommonConst.CharAccessoryTypes.Hat)
    end
    self:ChangePartLook(HairType, HairData.ChangeColor or 1)
  else
    Owner:DetachSuitItem(HairType)
    if not HairData then
      if self:IsHideHiarByAnyAccessory() then
        Owner:DeactivatePartMeshComp(HairType)
      else
        Owner:RecoverDefaultPartMesh(HairType)
      end
      return
    end
    Owner:DeactivatePartMeshComp(HairType)
    if HairData.IsHideHat then
      AddAccessoryHideTag(self, CommonConst.CharAccessoryTypes.Hat, CommonConst.DataType.Hair)
      self:ChangeAccessory(DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue, CommonConst.CharAccessoryTypes.Hat)
    end
    if not self:IsHideHiarByAnyAccessory() then
      Owner:RecoverDefaultPartMesh(HairType)
      if HairData.CharPartId then
        Owner:SetPartMesh(HairData.CharPartId)
      end
    end
    self:ChangePartLook(HairType, HairData.ChangeColor or 1)
  end
end

function BP_CharacterFashion_C:ReInitPartMesh()
  print(_G.LogTag, "BP_CharacterFashion_C:ReInitPartMesh", self:IsHideHiarByAnyAccessory())
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  local ModelComp = Owner:GetCharModelComponent()
  if not ModelComp then
    return
  end
  local ModelId = ModelComp:GetCurrentModelId()
  local SkinId = Owner.CurrentSkinId
  local SkinData = DataMgr.Skin[SkinId]
  if SkinData and SkinData.SkinModelId then
    ModelId = SkinData.SkinModelId
  end
  local ModelData = DataMgr.Model[ModelId]
  if not ModelData then
    return
  end
  local ModelPath = ModelData.SkeletonMeshPath
  if not ModelPath then
    return
  end
  if Owner.CurrentCompositeMesh then
    Owner.CurrentCompositeMesh = nil
  end
  ModelComp:LoadFullModel(ModelPath)
  local CurrentPartIds = {}
  for i, v in pairs(self.Type2PartId) do
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit part", v, i)
    table.insert(CurrentPartIds, v)
  end
  local OldFromArmory = Owner.FromArmory
  Owner.FromArmory = false
  Owner:InitPartMeshComp(CurrentPartIds)
  Owner.FromArmory = OldFromArmory
end

function BP_CharacterFashion_C:GetDefaultAccessorySuit()
  local Owner = self:GetOwner()
  if not Owner then
    return {}
  end
  if not IsStandAlone(Owner) then
    return {}
  end
  local DefaultAccessorySuit = {}
  for AccessoryType, AccessoryId in pairs(Const.DeafaultCharAccessoryTypes) do
    local AccessoryTypeIdx = CommonConst.NewCharAccessoryTypes[AccessoryType]
    DefaultAccessorySuit[AccessoryTypeIdx] = AccessoryId
  end
  return DefaultAccessorySuit
end

function BP_CharacterFashion_C:ChangeAccessoryWithDefautl()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return
  end
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  if not IsStandAlone(Owner) then
    return
  end
  self.InitWithCombinePart = true
  for AccessoryType, AccessoryTypeIdx in pairs(Const.DeafaultCharAccessoryTypes) do
    local AccessoryId = -1
    self:ChangeAccessory(AccessoryId, AccessoryType)
  end
end

function BP_CharacterFashion_C:InitWeaponColor(Colors)
  local SwatchData = DataMgr.Swatch
  local ColorData
  self.WeaponColor = nil
  local Color = FLinearColor()
  if Colors then
    ColorData = SwatchData[Colors[#Colors]]
    if ColorData then
      self.bHasWeaponColor = true
      if ColorData.ActualR and ColorData.ActualG and ColorData.ActualB then
        Color = FLinearColor(ColorData.ActualR, ColorData.ActualG, ColorData.ActualB)
        self.WeaponColor = Color
      elseif ColorData.ColorNumber then
        UKismetMathLibrary.LinearColor_SetFromSRGB(Color, FColor(ColorData.ColorNumber[1] or 0, ColorData.ColorNumber[2] or 0, ColorData.ColorNumber[3] or 0))
        self.WeaponColor = Color
      end
    else
      self.bHasWeaponColor = false
    end
  end
end

function BP_CharacterFashion_C:InitColorsWithInfo()
  if not self.AppearanceSuitInfo then
    return
  end
  if self.CharTinColorMap then
    self.CharTinColorMap:Clear()
  end
  local Colors = self.AppearanceSuitInfo.Colors
  if Colors and #Colors > 0 then
    self:InitSkinColors(Colors)
  end
end

local function GetMeshNameBySkinId(SkinId)
  local SkinData = DataMgr.Skin[SkinId]
  if nil == SkinData then
    return
  end
  local ModelData = DataMgr.Model[SkinData.SkinModelId]
  if nil == ModelData or nil == ModelData.PartModelsId then
    return
  end
  for _, value in pairs(ModelData.PartModelsId) do
    local CharPartModelData = DataMgr.CharPartModel[value]
    if CharPartModelData and CharPartModelData.PartType == "Body" then
      local PartPath = CharPartModelData.PartPath or ""
      local Res = string.split(PartPath, ".")
      local MeshName = Res[#Res] or ""
      local Len = #MeshName
      local LastChar = string.sub(MeshName, Len, Len)
      if "'" == LastChar then
        MeshName = string.sub(MeshName, 1, Len - 1)
      end
      return MeshName
    end
  end
end

function BP_CharacterFashion_C:RefreshUncoloredSkinColors(Colors)
  local _Owner = self:GetOwner()
  if not _Owner then
    return
  end
  local DefaultSkinId = self:GetDefaultSkinId(_Owner, SkinId)
  local SkinId = self.AppearanceSuitInfo and self.AppearanceSuitInfo.SkinId or DefaultSkinId
  local IsOriginalSkin = DefaultSkinId and SkinId == DefaultSkinId
  if IsOriginalSkin then
    return
  end
  local DefaultColors = {
    self:GetCharDefaultColorsFromDataTable(GetMeshNameBySkinId(SkinId))
  }
  if not DefaultColors or 0 == #DefaultColors then
    return
  end
  local PartCount = DataMgr.GlobalConstant and DataMgr.GlobalConstant.CharColorPart and DataMgr.GlobalConstant.CharColorPart.ConstantValue or #DefaultColors
  local LastVal = DefaultColors[#DefaultColors]
  local Fresnel8 = type(LastVal) == "number" and LastVal or nil
  for i = 1, PartCount do
    if -1 == Colors[i] or nil == Colors[i] then
      local Color = DefaultColors[i]
      if Color then
        local Fresnel = 8 == i and Fresnel8 or nil
        self:ChangePartColor(i, Color, Fresnel)
      end
    end
  end
end

local function IsPartSupportDyeing(PartIdx, ColorId)
  local DyePartData = DataMgr.DyePart[PartIdx] or {}
  if not DyePartData.ColorID then
    return true
  end
  for key, value in pairs(DyePartData.ColorID) do
    if value == ColorId then
      return true
    end
  end
  return false
end

function BP_CharacterFashion_C:InitSkinColors(Colors)
  Colors = Colors or {}
  local SwatchData = DataMgr.Swatch
  local Color = FLinearColor()
  for i = 1, #Colors - 1 do
    local ColorId = Colors[i]
    local PartIdx = i
    local ColorData = SwatchData[ColorId]
    if ColorData and IsPartSupportDyeing(i, ColorId) then
      if ColorData.ActualR and ColorData.ActualG and ColorData.ActualB then
        Color = FLinearColor(ColorData.ActualR, ColorData.ActualG, ColorData.ActualB)
        self:ChangePartColor(PartIdx, Color, ColorData.Fresnel)
      elseif ColorData.ColorNumber then
        local ColorNumber = ColorData.ColorNumber
        UKismetMathLibrary.LinearColor_SetFromSRGB(Color, FColor(ColorNumber[1] or 0, ColorNumber[2] or 0, ColorNumber[3] or 0))
        self:ChangePartColor(PartIdx, Color, ColorData.Fresnel)
      end
    end
  end
  self:RefreshUncoloredSkinColors(Colors)
end

function BP_CharacterFashion_C:ChangePartColor(PartIdx, Color, Fresnel)
  local FunctionName = "SetCharTintColor" .. PartIdx
  local Func = self[FunctionName]
  if Func then
    Func(self, Color, Fresnel)
  end
  if self.CharTinColorMap then
    if self.CharTinColorMap:Find(PartIdx) then
      self.CharTinColorMap:Remove(PartIdx)
    end
    self.CharTinColorMap:Add(PartIdx, Color)
  end
  self:TriggerEffectCreatureEvent()
  self:TriggerEffectCreatureTintEvent()
end

function BP_CharacterFashion_C:TriggerEffectCreatureTintEvent()
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  local EffectCreatures = Owner:GetEffectCreatureByTag("LevelUpEffectCreature")
  if 0 == EffectCreatures:Num() then
    return
  end
  for i = 1, EffectCreatures:Num() do
    local Creature = EffectCreatures:GetRef(i)
    if Creature and Creature.OnSkinLeveupTin then
      Creature:OnSkinLeveupTin(self.CharTinColorMap)
    end
  end
end

function BP_CharacterFashion_C:TriggerEffectCreatureEvent()
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  local EffectCreatures = Owner:GetEffectCreatureByTag("Skin")
  if 0 == EffectCreatures:Num() then
    return
  end
  for i = 1, EffectCreatures:Num() do
    local Creature = EffectCreatures:GetRef(i)
    if not self.NotAlwaysEffectCreature or not self.NotAlwaysEffectCreature[Creature.EffectCreatureId] then
      Creature:OnSkinLevelUp()
    end
  end
end

function BP_CharacterFashion_C:InitHairColors(Colors)
  rawset(self, "CurrentHairColors", Colors)
  rawset(self, "RealHairPartColors", {})
  Colors = Colors or {}
  local SwatchData = DataMgr.Swatch
  local Color = FLinearColor()
  local DefaultColors = {
    self:GetHiarDefaultColors()
  }
  for i = 1, DataMgr.GlobalConstant.HairColorPart.ConstantValue do
    local ColorId = Colors[i]
    local PartIdx = i
    local ColorData = SwatchData[ColorId]
    if ColorData then
      if ColorData.ActualR and ColorData.ActualG and ColorData.ActualB then
        Color = FLinearColor(ColorData.ActualR, ColorData.ActualG, ColorData.ActualB)
        self:ChangeHairPartColor(PartIdx, Color, ColorData.Fresnel)
      elseif ColorData.ColorNumber then
        local ColorNumber = ColorData.ColorNumber
        UKismetMathLibrary.LinearColor_SetFromSRGB(Color, FColor(ColorNumber[1] or 0, ColorNumber[2] or 0, ColorNumber[3] or 0))
        self:ChangeHairPartColor(PartIdx, Color, ColorData.Fresnel)
      end
    elseif DefaultColors[i] then
      self:ChangeHairPartColor(PartIdx, DefaultColors[i])
    end
  end
end

local HairColorFuncNames = {
  "SetHairTintColor1",
  "SetHairTintColor2",
  "SetHairPartTintColor1",
  "SetHairPartTintColor2",
  "SetHairPartTintColor3",
  "SetHairPartTintColor4"
}

function BP_CharacterFashion_C:ChangeHairPartColor(PartIdx, Color, Fresnel)
  self.RealHairPartColors[PartIdx] = {Color = Color, Fresnel = Fresnel}
  local FunctionName = HairColorFuncNames[PartIdx]
  local Func = self[FunctionName]
  if Func then
    Func(self, Color, Fresnel)
  end
end

local function RemoveType2Id(self, AccessoryType)
  self.Type2Id:Remove(AccessoryType)
  self:ResetSuitAccessoryType()
  self:UpdateSuitAccessoryType2Id(self.Type2Id)
end

local function AddType2Id(self, AccessoryType, AccessoryId)
  self.Type2Id:Add(AccessoryType, AccessoryId)
  self:ResetSuitAccessoryType()
  self:UpdateSuitAccessoryType2Id(self.Type2Id)
end

function BP_CharacterFashion_C:ChangeAccessory(AccessoryId, AccessoryType, Transform)
  local InValidAccId = not AccessoryId
  AccessoryId = AccessoryId or -1
  if CommonConst.ActionAccessoryTypes[AccessoryType] then
    RemoveType2Id(self, AccessoryType)
    if DataMgr.CharAccessory[AccessoryId] then
      AddType2Id(self, AccessoryType, AccessoryId)
    end
    return
  end
  local Owner = self:GetOwner()
  Owner:DetachSuitItem(AccessoryType)
  print(_G.LogTag, "Bp_CharacterFashion_C:InitAppearanceSuit ChangeAccessory", AccessoryId, AccessoryType, self:IsHideHiarByAccessory(AccessoryType))
  if self:IsHideHiarByAccessory(AccessoryType) then
    self:SetHideHiarByAccessory(AccessoryType, false)
    self:RecoverHairMesh()
  end
  if IsAccessoryHiddenByAnyTag(self, AccessoryType) then
    RemoveType2Id(self, AccessoryType)
    Owner:DeactivatePartMeshComp(AccessoryType)
    if self.Type2PartId then
      self.Type2PartId[AccessoryType] = 0
      self:ReInitPartMesh()
    end
    return
  end
  print(_G.LogTag, "Bp_CharacterFashion_C:InitAppearanceSuit ChangeAccessory", self.InitWithCombinePart, AccessoryId, AccessoryType)
  if not self.InitWithCombinePart then
    Owner:RecoverDefaultPartMesh(AccessoryType)
  end
  local LastId = self.Type2Id:Find(AccessoryType)
  local LastAccessoryData = DataMgr.CharAccessory[LastId]
  RemoveType2Id(self, AccessoryType)
  if AccessoryId == DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue or AccessoryId <= 0 then
    local PartMeshAccessoryId, PartMeshAccessoryType = self:GetOwnerPartMeshInfo(Owner.CurrentSkinId)
    if PartMeshAccessoryType == AccessoryType and not InValidAccId then
      Owner:DeactivatePartMeshComp(AccessoryType)
      if self.Type2PartId then
        self.Type2PartId[AccessoryType] = 0
      end
    elseif self.InitWithCombinePart then
      local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
      if DefaultPartId then
        if self.Type2PartId then
          self.Type2PartId[AccessoryType] = DefaultPartId
        else
          print(_G.LogTag, "Bp_CharacterFashion_C:InitAppearanceSuit 3333", DefaultPartId)
          table.insert(self.InitPartIds, DefaultPartId)
        end
      end
    elseif InValidAccId and self.InitWithCombinePart then
      local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
      if DefaultPartId then
        if self.Type2PartId then
          self.Type2PartId[AccessoryType] = DefaultPartId
        else
          table.insert(self.InitPartIds, DefaultPartId)
        end
        print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit acc11", #self.InitPartIds, DefaultPartId, AccessoryType)
      end
    end
    if LastAccessoryData and LastAccessoryData.CreatureId and self.UpdateFxAccessory then
      self.UpdateFxAccessory(self, AccessoryType)
    end
    print(_G.LogTag, "Bp_CharacterFashion_C:ChangeAccessory", self.Type2PartId)
    if self.Type2PartId then
      self:ReInitPartMesh()
    end
    return
  end
  Owner:DeactivatePartMeshComp(AccessoryType)
  if self.Type2PartId then
    self.Type2PartId[AccessoryType] = 0
  end
  local CharPartId = GetCharPartIdByAccessoryId(AccessoryId)
  if not self.InitWithCombinePart and CharPartId then
    Owner:SetPartMesh(CharPartId)
  elseif CharPartId and self.InitWithCombinePart then
    if self.Type2PartId then
      self.Type2PartId[AccessoryType] = CharPartId
    else
      print(_G.LogTag, "Bp_CharacterFashion_C:InitAppearanceSuit  Info", CharPartId)
      table.insert(self.InitPartIds, CharPartId)
    end
  end
  AddType2Id(self, AccessoryType, AccessoryId)
  print(_G.LogTag, "Bp_CharacterFashion_C:ChangeAccessory", self.Type2PartId)
  local Data = DataMgr.CharAccessory[AccessoryId]
  if not Data then
    if self.UpdateFxAccessory then
      self.UpdateFxAccessory(self, AccessoryType)
    end
    if self.Type2PartId then
      self:ReInitPartMesh()
    end
    return
  end
  if Data.IsTail and not IsAccessoryHiddenByAnyTag(self, AccessoryType) then
    self:SetHideHiarByAccessory(AccessoryType, true)
    Owner:DeactivatePartMeshComp(CommonConst.DataType.Hair)
    if self.Type2PartId then
      self.Type2PartId[CommonConst.DataType.Hair] = 0
    end
  end
  if self.Type2PartId then
    self:ReInitPartMesh()
  end
  local ModelId = Owner.ModelId
  local Paths = TArray(FString)
  local SocketNames = TArray(FName)
  local EffectSocketNames = TArray(FName)
  local EffectPaths = TArray(FString)
  local Offsets = TArray(FTransform)
  local VisualEffectIds = TArray(0)
  self:AddAccessoryParameter(AccessoryId, Paths, SocketNames, Offsets, EffectSocketNames, EffectPaths, ModelId, VisualEffectIds)
  if Data.ChildAccessory then
    for _, id in ipairs(Data.ChildAccessory) do
      self:AddAccessoryParameter(id, Paths, SocketNames, Offsets, EffectSocketNames, EffectPaths, ModelId, VisualEffectIds)
    end
  end
  Owner:AttachSuitItems(Data.AccessoryType, Paths, SocketNames, Offsets, EffectPaths, EffectSocketNames, VisualEffectIds)
  self:ChangePartLook(AccessoryType, Data.ChangeColor or 1)
  if Transform then
    Transform = Offsets[1] * Transform
    Owner:SetAccessoryTransform(AccessoryId, AccessoryType, Transform)
  end
  if self.UpdateFxAccessory then
    self.UpdateFxAccessory(self, AccessoryType)
  end
end

function BP_CharacterFashion_C:GetOwnerPartMeshInfo(SkinId)
  local Owner = self:GetOwner()
  local _SkinId = SkinId or Owner and Owner.CurrentRoleId
  if not _SkinId then
    return
  end
  for AccessoryId, value in pairs(DataMgr.CharPartMesh) do
    if value.PartName == "PartMesh" then
      local SkinIds = value.Skin or {}
      for _, Id in pairs(SkinIds) do
        if Id == _SkinId then
          return AccessoryId, value.AccessoryType
        end
      end
    end
  end
end

function BP_CharacterFashion_C:GetDefaultSkinId(Owner, SkinId)
  local _Owner = Owner or self:GetOwner()
  local _SkinId = SkinId or self.AppearanceSuitInfo and self.AppearanceSuitInfo.SkinId
  local DefaultSkinId
  local SkinInfo = _SkinId and DataMgr.Skin[_SkinId]
  if SkinInfo and SkinInfo.CharId then
    local CharInfo = DataMgr.Char[SkinInfo.CharId]
    DefaultSkinId = CharInfo and CharInfo.DefaultSkinId
  end
  if not DefaultSkinId and _Owner and _Owner.CurrentRoleId then
    local CharInfo2 = DataMgr.Char[_Owner.CurrentRoleId]
    DefaultSkinId = CharInfo2 and CharInfo2.DefaultSkinId
  end
  return DefaultSkinId
end

function BP_CharacterFashion_C:AddAccessoryParameter(AccessoryId, Paths, SocketNames, Offsets, EffectSocketNames, EffectPaths, ModelId, VisualEffectIds)
  local Data = DataMgr.CharAccessory[AccessoryId]
  if not Data then
    return
  end
  local Path = Data.ModelPath
  local Socket = Data.AccessorySocket
  Paths:Add(Path)
  SocketNames:Add(Socket)
  Offsets:Add(self:GetAccessoryOriginOffset(AccessoryId))
  if Data.NiagaraPath then
    EffectPaths:Add(Data.NiagaraPath)
  end
  if Data.AccessorySocket then
    EffectSocketNames:Add(Data.SocketName)
  end
  if Data.VisualEffectId then
    VisualEffectIds:Add(Data.VisualEffectId)
  end
end

function BP_CharacterFashion_C:GetAccessoryOriginOffset(AccessoryId)
  local Data = DataMgr.CharAccessory[AccessoryId]
  if not Data then
    return FTransform(Const.ZeroRotator:ToQuat(), Const.ZeroVector, Const.OneVector)
  end
  local Owner = self:GetOwner()
  local ModelId = Owner.ModelId
  local ModelData = DataMgr.Model[ModelId] or {}
  local OffsetId = ModelData.CharAccessoryOffsetId and ModelData.CharAccessoryOffsetId[1] or ModelId
  local OffsetData = DataMgr.CharAccessoryOffset[OffsetId]
  OffsetData = OffsetData and OffsetData.OffsetParameter or {}
  for _, OffsetParameter in pairs(OffsetData) do
    for key, value in pairs(OffsetParameter) do
      if key == Data.AccessorySocket then
        return CommonUtils:DataToFTransform(value)
      end
    end
  end
  return FTransform(Const.ZeroRotator:ToQuat(), Const.ZeroVector, Const.OneVector)
end

function BP_CharacterFashion_C:GetCurrentHairMeshName()
  local HairData = DataMgr.Hair[rawget(self, "CurrentHairId")]
  if nil == HairData then
    return
  end
  local ModelPath
  if nil ~= HairData.CharPartId then
    local CharPartModelData = DataMgr.CharPartModel[HairData.CharPartId]
    ModelPath = CharPartModelData and CharPartModelData.PartPath
  end
  if ModelPath then
    local Res = string.split(ModelPath, ".")
    local MeshName = Res[#Res] or ""
    local Len = #MeshName
    local LastChar = string.sub(MeshName, Len, Len)
    if "'" == LastChar then
      MeshName = string.sub(MeshName, 1, Len - 1)
    end
    return MeshName
  end
end

function BP_CharacterFashion_C:GetHiarDefaultColors()
  local HairMeshName = self:GetCurrentHairMeshName()
  if HairMeshName then
    return self:GetHairDefaultColorsFromDataTable(HairMeshName)
  end
end

return BP_CharacterFashion_C
