require("UnLua")
local M = {}

local function BuildWorldTransform(BaseTransform, RelativeTransform)
  if not RelativeTransform then
    return nil
  end
  BaseTransform = BaseTransform or FTransform()
  local WorldTransform = FTransform()
  WorldTransform.Translation = UE4.UKismetMathLibrary.TransformLocation(BaseTransform, RelativeTransform.Translation or FVector(0, 0, 0))
  if RelativeTransform.Rotation then
    WorldTransform.Rotation = UE4.UKismetMathLibrary.TransformRotation(BaseTransform, RelativeTransform.Rotation:ToRotator()):ToQuat()
  else
    WorldTransform.Rotation = BaseTransform.Rotation
  end
  WorldTransform.Scale3D = RelativeTransform.Scale3D or BaseTransform.Scale3D or FVector(1, 1, 1)
  return WorldTransform
end

local function SetActorRelativeTransformInternal(TargetActor, Transform)
  if not TargetActor then
    return
  end
  TargetActor:K2_SetActorRelativeTransform(Transform, false, nil, false)
end

local function GetActorRelativeTransformInternal(TargetActor)
  if not TargetActor then
    return nil
  end
  if TargetActor.GetActorRelativeTransform then
    return TargetActor:GetActorRelativeTransform()
  end
  return nil
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.SceneService = Params.SceneService
  self.OwnerCharacterHandle = nil
  self.PetInfo = nil
  self.Actor = nil
  self.HideTags = {}
  self.CurrentTransform = nil
  self.RootActor = nil
end

function M:GetActor()
  return self.Actor
end

function M:IsValid()
  return IsValid(self.Actor)
end

function M:Create(PetInfo, OwnerCharacterHandle, CreateParams)
  self.PetInfo = PetInfo
  self.OwnerCharacterHandle = OwnerCharacterHandle
  CreateParams = CreateParams or {}
  self.RootActor = self.SceneService and self.SceneService:GetPreviewRootActor() or nil
  if not self.OwnerCharacterHandle or not self.OwnerCharacterHandle:GetActor() then
    return
  end
  local OwnerActor = self.OwnerCharacterHandle:GetActor()
  OwnerActor:ServerRemoveBattlePet()
  if PetInfo and PetInfo.PetId then
    OwnerActor:ServerSetBattlePet(PetInfo.PetId, PetInfo.BattlePetLevel or 1, false, TArray(0))
    local BattlePet = OwnerActor:GetBattlePet()
    self.Actor = BattlePet and BattlePet.EffectCreature
    if self.Actor and self.RootActor then
      self.Actor:K2_AttachToActor(self.RootActor, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
    end
    if self.Actor and CreateParams.Transform then
      self:SetTransform(CreateParams.Transform)
    end
  end
end

function M:AttachToCharacter(CharacterHandle)
  self.OwnerCharacterHandle = CharacterHandle
end

function M:DetachFromCharacter()
  self.OwnerCharacterHandle = nil
end

function M:SetTransform(Transform)
  self.CurrentTransform = Transform
  if not self.Actor or not Transform then
    return
  end
  local RootActor = self.RootActor or self.SceneService and self.SceneService:GetPreviewRootActor() or nil
  local BaseTransform = RootActor and RootActor:GetTransform() or self.SceneService and self.SceneService.GetPreviewSceneTrans and self.SceneService:GetPreviewSceneTrans() or nil
  local WorldTransform = BuildWorldTransform(BaseTransform, Transform)
  if RootActor then
    SetActorRelativeTransformInternal(self.Actor, Transform)
    return
  end
  self.Actor:K2_SetActorTransform(WorldTransform or Transform, false, nil, false)
end

function M:SetLocation(Location)
  if self.Actor then
    local Transform = self.RootActor and GetActorRelativeTransformInternal(self.Actor) or self.Actor:GetTransform()
    if not Transform then
      return
    end
    Transform.Translation = Location
    self:SetTransform(Transform)
  end
end

function M:SetRotation(Rotation)
  if self.Actor then
    local Transform = self.RootActor and GetActorRelativeTransformInternal(self.Actor) or self.Actor:GetTransform()
    if not Transform then
      return
    end
    Transform.Rotation = Rotation:ToQuat()
    self:SetTransform(Transform)
  end
end

function M:SetScale(Scale)
  if self.Actor then
    local Transform = self.RootActor and GetActorRelativeTransformInternal(self.Actor) or self.Actor:GetTransform()
    if not Transform then
      return
    end
    Transform.Scale3D = Scale
    self:SetTransform(Transform)
  end
end

function M:GetTransform()
  if self.Actor then
    if self.RootActor then
      local RelativeTransform = GetActorRelativeTransformInternal(self.Actor)
      if RelativeTransform then
        return RelativeTransform
      end
    end
    return self.Actor:GetTransform()
  end
  return self.CurrentTransform
end

function M:Show(Tag)
  Tag = Tag or "PreviewPetHandle"
  self.HideTags[Tag] = nil
  if self.Actor then
    self.Actor:SetActorHiddenInGame(false)
  end
end

function M:Hide(Tag)
  Tag = Tag or "PreviewPetHandle"
  self.HideTags[Tag] = true
  if self.Actor then
    self.Actor:SetActorHiddenInGame(true)
  end
end

function M:ClearHideTag(Tag)
  self.HideTags[Tag] = nil
  if self.Actor then
    self.Actor:SetActorHiddenInGame(false)
  end
end

function M:PlayVoice(VoiceKey)
  local OwnerActor = self.OwnerCharacterHandle and self.OwnerCharacterHandle:GetActor()
  local PetId = self.PetInfo and self.PetInfo.PetId
  local PetData = PetId and DataMgr.Pet[PetId]
  if OwnerActor and PetData then
    AudioManager(OwnerActor):PlayPetVoice(OwnerActor, PetData.PetNameTag, VoiceKey or "vo_hello", "PreviewPetVoice")
  end
end

function M:Dispose()
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

return M
