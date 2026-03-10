require("UnLua")
require("Utils")
local EMLuaConst = require("EMLuaConst")
local BP_CharacterFashion_C = Class("BluePrints.Common.FashionComponent_C")

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
  CreateAccessoryHideTags(self)
  if not Info then
    self:ChangeAccessoryWithDefautl()
    self:InitPartMeshCompWithDefault()
    return
  end
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  if EMLuaConst.ShouldCombinePartMesh then
    self.InitWithCombinePart = (not Owner or not Owner.FromArmory) and (not Owner or not Owner.FromOtherWorld)
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit combine", self.InitWithCombinePart, Owner.FromArmory)
  end
  if self.InitWithCombinePart then
    Owner:RemoveAllPartMeshComps()
  end
  self:ChangeCharSkin(Info.SkinId)
  local DefaultFacePart = Owner.DefaultCharPartId:Find("Faces")
  if self.InitWithCombinePart then
    table.insert(self.InitPartIds, DefaultFacePart)
  else
    Owner:SetPartMesh(DefaultFacePart, true)
  end
  self:CheckShouldHideHair(Info.AccessorySuit)
  self:ChangeCharHair(Info.HairId)
  print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit hair", Info.HairId)
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
    if InValidAccId and not IsAccessoryHiddenByAnyTag(self, AccessoryType) then
      if self.InitWithCombinePart then
        local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
        if DefaultPartId then
          table.insert(self.InitPartIds, DefaultPartId)
        end
      else
        Owner:RecoverDefaultPartMesh(AccessoryType)
      end
    end
    print(_G.LogTag, "BP_CharacterFashion_C:InitAppearanceSuit acc", AccessoryId, AccessoryType)
  end
  if Owner and self.InitWithCombinePart and #self.InitPartIds > 0 then
    Owner:InitPartMeshComp(self.InitPartIds)
  end
  local Colors = Info.Colors
  if Owner.FromArmory then
    self:RefreshUncoloredSkinColors(Owner, Colors)
  else
    self:InitSkinColors(Colors)
  end
  self:InitHairColors(Info.HairColors)
  if Owner.InfoForInit then
    self:GradeUpEmissive(Owner.InfoForInit.GradeLevel)
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
  if self.InitWithCombinePart then
    return
  end
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  local HairType = CommonConst.DataType.Hair
  local HairData = DataMgr.Hair[rawget(self, "CurrentHairId")]
  Owner:DeactivatePartMeshComp(HairType)
  if HairData then
    if HairData.LinkAccessory then
      self:ChangeAccessory(HairData.LinkAccessory, HairType)
    elseif HairData.CharPartId then
      Owner:SetPartMesh(HairData.CharPartId)
    end
  else
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
        table.insert(self.InitPartIds, DefaultHairId)
      end
      return
    end
    if self:IsHideHiarByAnyAccessory() and not HairData.IsHideHat then
      return
    end
    local CharPartId
    if HairData.LinkAccessory then
      self:ChangeAccessory(HairData.LinkAccessory, HairType)
      return
    elseif HairData.CharPartId then
      CharPartId = HairData.CharPartId
    end
    if CharPartId then
      table.insert(self.InitPartIds, CharPartId)
    end
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
    if HairData.LinkAccessory then
      self:ChangeAccessory(HairData.LinkAccessory, HairType)
      return
    end
    if not self:IsHideHiarByAnyAccessory() then
      Owner:RecoverDefaultPartMesh(HairType)
      if HairData.CharPartId then
        Owner:SetPartMesh(HairData.CharPartId)
      end
    end
  end
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
  local Colors = self.AppearanceSuitInfo.Colors
  if Colors and #Colors > 0 then
    self:InitSkinColors(Colors)
    return
  end
  local Owner = self:GetOwner()
  if not Owner then
    return
  end
  self:RefreshUncoloredSkinColors(Owner, nil)
end

function BP_CharacterFashion_C:RefreshUncoloredSkinColors(Owner, Colors)
  local _Owner = Owner or self:GetOwner()
  if not _Owner then
    return
  end
  local hasColors = Colors and #Colors > 0
  if hasColors then
    self:InitSkinColors(Colors)
  end
  local SkinId = self.AppearanceSuitInfo and self.AppearanceSuitInfo.SkinId
  local DefaultSkinId = self:GetDefaultSkinId(_Owner, SkinId)
  local IsOriginalSkin = DefaultSkinId and SkinId == DefaultSkinId
  if not _Owner.FromArmory or not not IsOriginalSkin then
    return
  end
  local DefaultColors = {
    self:GetCharDefaultColorsFromDataTable(_Owner)
  }
  if not DefaultColors or 0 == #DefaultColors then
    return
  end
  local PartCount = DataMgr.GlobalConstant and DataMgr.GlobalConstant.CharColorPart and DataMgr.GlobalConstant.CharColorPart.ConstantValue or #DefaultColors
  local LastVal = DefaultColors[#DefaultColors]
  local Fresnel8 = type(LastVal) == "number" and LastVal or nil
  for i = 1, PartCount do
    if not hasColors or -1 == Colors[i] or nil == Colors[i] then
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
  if not Colors then
    return
  end
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
end

function BP_CharacterFashion_C:ChangePartColor(PartIdx, Color, Fresnel)
  local FunctionName = "SetCharTintColor" .. PartIdx
  local Func = self[FunctionName]
  if Func then
    Func(self, Color, Fresnel)
  end
end

function BP_CharacterFashion_C:InitHairColors(Colors)
  rawset(self, "CurrentHairColors", Colors)
  rawset(self, "RealHairPartColors", {})
  if not Colors then
    return
  end
  local SwatchData = DataMgr.Swatch
  local Color = FLinearColor()
  for i = 1, #Colors do
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
  if self:IsHideHiarByAccessory(AccessoryType) then
    self:SetHideHiarByAccessory(AccessoryType, false)
    self:RecoverHairMesh()
  end
  if IsAccessoryHiddenByAnyTag(self, AccessoryType) then
    RemoveType2Id(self, AccessoryType)
    Owner:DeactivatePartMeshComp(AccessoryType)
    return
  end
  print(_G.LogTag, "BP_CharacterFashion_C:ChangeAccessory", self.InitWithCombinePart, AccessoryId, AccessoryType)
  if not self.InitWithCombinePart then
    Owner:RecoverDefaultPartMesh(AccessoryType)
  end
  local LastId = self.Type2Id:Find(AccessoryType)
  local LastAccessoryData = DataMgr.CharAccessory[LastId]
  RemoveType2Id(self, AccessoryType)
  if AccessoryId == DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue or AccessoryId <= 0 then
    local PartMeshAccessoryId, PartMeshAccessoryType = self:GetOwnerPartMeshInfo(Owner.CurrentSkinId)
    if PartMeshAccessoryType == AccessoryType then
      Owner:DeactivatePartMeshComp(AccessoryType)
    elseif self.InitWithCombinePart then
      local DefaultPartId = Owner.DefaultCharPartId:Find(AccessoryType)
      if DefaultPartId then
        table.insert(self.InitPartIds, DefaultPartId)
      end
    end
    if LastAccessoryData and LastAccessoryData.CreatureId and self.UpdateFxAccessory then
      self.UpdateFxAccessory(self, AccessoryType)
    end
    return
  end
  Owner:DeactivatePartMeshComp(AccessoryType)
  local CharPartId = GetCharPartIdByAccessoryId(AccessoryId)
  if CharPartId then
    if self.InitWithCombinePart then
      table.insert(self.InitPartIds, CharPartId)
      return
    else
      Owner:SetPartMesh(CharPartId)
    end
  end
  AddType2Id(self, AccessoryType, AccessoryId)
  local Data = DataMgr.CharAccessory[AccessoryId]
  if not Data then
    if self.UpdateFxAccessory then
      self.UpdateFxAccessory(self, AccessoryType)
    end
    return
  end
  if Data.IsTail and not IsAccessoryHiddenByAnyTag(self, AccessoryType) then
    self:SetHideHiarByAccessory(AccessoryType, true)
    Owner:DeactivatePartMeshComp(CommonConst.DataType.Hair)
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
  if Transform then
    local AddLoc, AddRot, AddScale = UKismetMathLibrary.BreakTransform(Transform)
    local Translation, Rotation, Scale = FVector(), FRotator(), FVector()
    for key, value in pairs(Offsets) do
      UKismetMathLibrary.BreakTransform(value, Translation, Rotation, Scale)
      Translation:Add(AddLoc)
      Rotation:Add(AddRot)
      Scale:Add(AddScale)
      Scale:Add(-Const.OneVector)
      Offsets[key] = UKismetMathLibrary.MakeTransform(Translation, Rotation, Scale)
    end
  end
  Owner:AttachSuitItems(Data.AccessoryType, Paths, SocketNames, Offsets, EffectPaths, EffectSocketNames, VisualEffectIds)
  self:ChangePartLook(AccessoryType, Data.ChangeColor or 1)
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
  local ModelData = DataMgr.Model[ModelId] or {}
  local OffsetId = ModelData.CharAccessoryOffsetId and ModelData.CharAccessoryOffsetId[1] or ModelId
  local OffsetData = DataMgr.CharAccessoryOffset[OffsetId]
  OffsetData = OffsetData and OffsetData.OffsetParameter or {}
  local Offset
  for _, OffsetParameter in pairs(OffsetData) do
    for key, value in pairs(OffsetParameter) do
      if key == Data.AccessorySocket then
        Offset = CommonUtils:DataToFTransform(value)
        Offsets:Add(Offset)
        break
      end
    end
  end
  if not Offset then
    Offset = FTransform()
    Offsets:Add(Offset)
  end
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

function BP_CharacterFashion_C:GetCurrentHairMeshName()
  local HairData = DataMgr.Hair[rawget(self, "CurrentHairId")]
  if nil == HairData then
    return
  end
  local ModelPath
  if nil == HairData.CharPartId then
    if HairData.LinkAccessory then
      local CharAccessoryData = DataMgr.CharAccessory[HairData.LinkAccessory]
      ModelPath = CharAccessoryData and CharAccessoryData.ModelPath
    end
  else
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

return BP_CharacterFashion_C
