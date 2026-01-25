require("UnLua")
require("Utils")
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

function BP_CharacterFashion_C:InitAppearanceSuit(Info)
  rawset(self, "AppearanceSuitInfo", Info)
  rawset(self, "Type2Id", rawget(self, "Type2Id") or TMap(FName, 0))
  self:InitWeaponColor(Info.Colors)
  if not Info then
    return
  end
  local Owner = self:GetOwner()
  if Owner.ChangeSkinModel then
    Owner:ChangeSkinModel(Info.SkinId)
  end
  self:InitSkinColors(Info.Colors)
  local AccessorySuit = Info.AccessorySuit or {}
  local PartMeshAccessoryId, PartMeshAccessoryType = self:GetOwnerPartMeshInfo(Owner.CurrentSkinId)
  local IsShowPartMesh = Info.IsShowPartMesh == nil and true or Info.IsShowPartMesh
  for AccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
    local AccessoryId = AccessorySuit[AccessoryTypeIdx] or -1
    if PartMeshAccessoryType == AccessoryType and AccessoryId > 0 and AccessoryId ~= PartMeshAccessoryId then
      IsShowPartMesh = false
    end
    self:ChangeAccessory(AccessoryId, AccessoryType)
  end
  if Owner.PartsMesh then
    Owner.PartsMesh:SetVisibility(IsShowPartMesh, false)
  end
  if Owner.InfoForInit then
    self:GradeUpEmissive(Owner.InfoForInit.GradeLevel)
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
  if not Colors then
    return
  end
  self:InitSkinColors(Colors)
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
    if ColorData then
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

local BP_UpdateAccessoryFunc = {
  [CommonConst.CharAccessoryTypes.FX_Body] = "UpdateFxBody",
  [CommonConst.CharAccessoryTypes.FX_Footprint] = "UpdateFxFoot"
}

function BP_CharacterFashion_C:ChangeAccessory(AccessoryId, AccessoryType)
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
  local LastId = self.Type2Id:Find(AccessoryType)
  local LastAccessoryData = DataMgr.CharAccessory[LastId]
  if LastAccessoryData and LastAccessoryData.IsTail and Owner.TailMesh then
    Owner.TailMesh:SetVisibility(true, false)
  end
  RemoveType2Id(self, AccessoryType)
  local PartMeshAccessoryId, PartMeshAccessoryType = self:GetOwnerPartMeshInfo()
  if AccessoryId == DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue or AccessoryId <= 0 then
    if PartMeshAccessoryType and PartMeshAccessoryType == AccessoryType then
      Owner.PartsMesh:SetVisibility(false, false)
    end
    if BP_UpdateAccessoryFunc[AccessoryType] and self[BP_UpdateAccessoryFunc[AccessoryType]] then
      self[BP_UpdateAccessoryFunc[AccessoryType]](self, false)
    end
    return
  end
  local Data = DataMgr.CharAccessory[AccessoryId]
  if nil == Data or AccessoryId <= 0 or PartMeshAccessoryId == AccessoryId then
    if nil == Data then
      local CharPartMeshData = DataMgr.CharPartMesh[AccessoryId]
      if CharPartMeshData then
        Owner.PartsMesh:SetVisibility(true, false)
      end
    end
    return
  end
  AddType2Id(self, AccessoryType, AccessoryId)
  if BP_UpdateAccessoryFunc[AccessoryType] and self[BP_UpdateAccessoryFunc[AccessoryType]] then
    self[BP_UpdateAccessoryFunc[AccessoryType]](self, not not Data.CreatureId)
  end
  if Data.IsTail and Owner.TailMesh then
    Owner.TailMesh:SetVisibility(false, false)
  end
  if Data.CreatureId then
    return
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
  if PartMeshAccessoryType and PartMeshAccessoryType == AccessoryType then
    Owner.PartsMesh:SetVisibility(false, false)
  end
  Owner:AttachSuitItems(Data.AccessoryType, Paths, SocketNames, Offsets, EffectPaths, EffectSocketNames, VisualEffectIds)
  self:ChangePartLook(AccessoryType, Data.ChangeColor or 1)
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

return BP_CharacterFashion_C
