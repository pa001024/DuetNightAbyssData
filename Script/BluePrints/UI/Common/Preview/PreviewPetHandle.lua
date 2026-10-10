require("UnLua")
local M = {}
local SELECTION_SPHERE_FALLBACK_RADIUS = 25.0
local SELECTION_SPHERE_MIN_RADIUS = 20.0
local SELECTION_SPHERE_FALLBACK_HEIGHT = 15.0
local DEFAULT_EFFECT_CREATURE_CLASS_PATH = "/Game/BluePrints/Combat/SkillCreatures/BP_EffectCreature.BP_EffectCreature_C"

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

local function SetComponentSelectionCollision(Component)
  if not Component or not Component.SetCollisionEnabled then
    return
  end
  Component:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
  if Component.SetCollisionResponseToAllChannels then
    Component:SetCollisionResponseToAllChannels(UE4.ECollisionResponse.ECR_Ignore)
  end
  if Component.SetCollisionResponseToChannel then
    Component:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_GameTraceChannel3, UE4.ECollisionResponse.ECR_Block)
    Component:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Visibility, UE4.ECollisionResponse.ECR_Block)
    Component:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Camera, UE4.ECollisionResponse.ECR_Block)
  end
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.SceneService = Params.SceneService
  self.EnableSelectionCollision = Params.EnableSelectionCollision == true
  self.OwnerCharacterHandle = nil
  self.SpawnHostActor = nil
  self.EffectCreatureId = nil
  self.PetInfo = nil
  self.Actor = nil
  self.HideTags = {}
  self.CurrentTransform = nil
  self.RootActor = nil
  self.SelectionSphere = nil
  self.SelectionReadyBoundActor = nil
end

function M:GetActor()
  return self.Actor
end

function M:IsValid()
  return IsValid(self.Actor)
end

function M:_SpawnStandalonePet(EffectCreatureId)
  local EffectCreatureData = DataMgr and DataMgr.EffectCreature and DataMgr.EffectCreature[EffectCreatureId] or nil
  local EffectCreaturePath = EffectCreatureData and EffectCreatureData.EffectCreaturePath or nil
  if type(EffectCreaturePath) ~= "string" or "" == EffectCreaturePath then
    EffectCreaturePath = DEFAULT_EFFECT_CREATURE_CLASS_PATH
  elseif string.sub(EffectCreaturePath, -2) ~= "_C" then
    EffectCreaturePath = EffectCreaturePath .. "_C"
  end
  local World = self.ViewUI and self.ViewUI:GetWorld() or nil
  local EffectCreatureClass = World and LoadClass(EffectCreaturePath) or nil
  if not EffectCreatureClass then
    return nil
  end
  local EffectCreature = World:SpawnActor(EffectCreatureClass, FTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  if not IsValid(EffectCreature) then
    return nil
  end
  EffectCreature:SetActorHiddenInGame(true)
  EffectCreature:SetActorEnableCollision(false)
  if self.RootActor and EffectCreature.SetOwner then
    EffectCreature:SetOwner(self.RootActor)
  end
  EffectCreature.EffectCreatureId = EffectCreatureId
  EffectCreature.ReplaceSkinEffectCreatureId = EffectCreatureId
  EffectCreature.SkillSpeed = 1
  EffectCreature.LoadTime = 0
  EffectCreature:Active()
  EffectCreature:SetTickableWhenPaused(true)
  if EffectCreature.SkeletalMesh and EffectCreature.SkeletalMesh.SetTickableWhenPaused then
    EffectCreature.SkeletalMesh:SetTickableWhenPaused(true)
  end
  EffectCreature:LoadEffectCreatureResource()
  if EffectCreature.PlayCreateSe then
    EffectCreature:PlayCreateSe()
  end
  if EffectCreature.OnBeginPlay then
    EffectCreature:OnBeginPlay()
  end
  if EffectCreature.TickFlag ~= nil then
    EffectCreature.TickFlag = false
  end
  if EffectCreature.SetActorTickEnabled then
    EffectCreature:SetActorTickEnabled(false)
  end
  if EffectCreature.SkeletalMesh and EffectCreature.SkeletalMesh.SetTickableWhenPaused then
    EffectCreature.SkeletalMesh:SetTickableWhenPaused(true)
  end
  return EffectCreature
end

function M:_UnbindSelectionCollisionReadyCallback()
  local BoundActor = self.SelectionReadyBoundActor
  self.SelectionReadyBoundActor = nil
  if IsValid(BoundActor) then
    BoundActor.PreviewSelectionReadyCallback = nil
  end
end

function M:_BindSelectionCollisionReadyCallback()
  self:_UnbindSelectionCollisionReadyCallback()
  if not self.EnableSelectionCollision or not IsValid(self.Actor) then
    return
  end
  local ActorRef = self.Actor
  self.SelectionReadyBoundActor = ActorRef
  
  function ActorRef.PreviewSelectionReadyCallback(EffectCreature)
    if self.Actor ~= ActorRef or EffectCreature ~= ActorRef then
      return
    end
    if not IsValid(ActorRef) then
      return
    end
    if self.EnableSelectionCollision then
      self:_RefreshSelectionCollision("OnResourceReady")
    end
    if self.OnResourceReady then
      self:OnResourceReady()
    end
  end
end

function M:_DestroySelectionSphere()
  local Sphere = self.SelectionSphere
  self.SelectionSphere = nil
  if not IsValid(Sphere) then
    return
  end
  if Sphere.DestroyComponent then
    Sphere:DestroyComponent(false)
  elseif Sphere.K2_DestroyComponent then
    Sphere:K2_DestroyComponent(Sphere)
  end
end

local function TryGetMeshWorldBounds(MeshComp)
  if not IsValid(MeshComp) then
    return nil, nil
  end
  local Bounds = MeshComp.Bounds
  if Bounds then
    local Origin = Bounds.Origin or Bounds.origin
    local BoxExtent = Bounds.BoxExtent or Bounds.box_extent
    if Origin and BoxExtent then
      local ExtentSum = math.abs(BoxExtent.X or 0) + math.abs(BoxExtent.Y or 0) + math.abs(BoxExtent.Z or 0)
      if ExtentSum > 1.0 then
        return Origin, BoxExtent
      end
    end
  end
  if not MeshComp.GetLocalBounds then
    return nil, nil
  end
  local MinV, MaxV = MeshComp:GetLocalBounds()
  if not MinV or not MaxV then
    return nil, nil
  end
  local MinX, MinY, MinZ = MinV.X or 0, MinV.Y or 0, MinV.Z or 0
  local MaxX, MaxY, MaxZ = MaxV.X or 0, MaxV.Y or 0, MaxV.Z or 0
  local LocalCenter = FVector((MinX + MaxX) * 0.5, (MinY + MaxY) * 0.5, (MinZ + MaxZ) * 0.5)
  local LocalExtent = FVector((MaxX - MinX) * 0.5, (MaxY - MinY) * 0.5, (MaxZ - MinZ) * 0.5)
  if LocalExtent.X + LocalExtent.Y + LocalExtent.Z <= 1.0 then
    return nil, nil
  end
  local ComponentTransform = MeshComp.K2_GetComponentToWorld and MeshComp:K2_GetComponentToWorld() or nil
  if not ComponentTransform then
    return nil, nil
  end
  local WorldOrigin = UE4.UKismetMathLibrary.TransformLocation(ComponentTransform, LocalCenter)
  local Scale = MeshComp.K2_GetComponentScale and MeshComp:K2_GetComponentScale() or FVector(1, 1, 1)
  local WorldExtent = FVector(math.abs(LocalExtent.X * (Scale.X or 1)), math.abs(LocalExtent.Y * (Scale.Y or 1)), math.abs(LocalExtent.Z * (Scale.Z or 1)))
  return WorldOrigin, WorldExtent
end

local function GetPetMeshWorldBounds(TargetActor)
  local MergedMin, MergedMax
  
  local function Accumulate(MeshComp)
    local Origin, BoxExtent = TryGetMeshWorldBounds(MeshComp)
    if not Origin or not BoxExtent then
      return
    end
    local MinV = FVector(Origin.X - BoxExtent.X, Origin.Y - BoxExtent.Y, Origin.Z - BoxExtent.Z)
    local MaxV = FVector(Origin.X + BoxExtent.X, Origin.Y + BoxExtent.Y, Origin.Z + BoxExtent.Z)
    if not MergedMin then
      MergedMin = MinV
      MergedMax = MaxV
      return
    end
    MergedMin = FVector(math.min(MergedMin.X, MinV.X), math.min(MergedMin.Y, MinV.Y), math.min(MergedMin.Z, MinV.Z))
    MergedMax = FVector(math.max(MergedMax.X, MaxV.X), math.max(MergedMax.Y, MaxV.Y), math.max(MergedMax.Z, MaxV.Z))
  end
  
  Accumulate(TargetActor.SkeletalMesh)
  Accumulate(TargetActor.Mesh)
  local MeshResourceList = TargetActor.MeshResourceList
  if MeshResourceList then
    local Count = MeshResourceList.Num and MeshResourceList:Num() or #MeshResourceList
    for Index = 1, Count do
      local Component = MeshResourceList.Get and MeshResourceList:Get(Index - 1) or MeshResourceList[Index]
      Accumulate(Component)
    end
  end
  if not MergedMin or not MergedMax then
    return nil, nil
  end
  local Origin = FVector((MergedMin.X + MergedMax.X) * 0.5, (MergedMin.Y + MergedMax.Y) * 0.5, (MergedMin.Z + MergedMax.Z) * 0.5)
  local BoxExtent = FVector((MergedMax.X - MergedMin.X) * 0.5, (MergedMax.Y - MergedMin.Y) * 0.5, (MergedMax.Z - MergedMin.Z) * 0.5)
  return Origin, BoxExtent
end

local function ComputeSelectionSphereMetrics(TargetActor)
  local Origin, BoxExtent = GetPetMeshWorldBounds(TargetActor)
  local ActorLocation = TargetActor:K2_GetActorLocation()
  if not Origin or not BoxExtent then
    local Center = FVector(ActorLocation.X, ActorLocation.Y, ActorLocation.Z + SELECTION_SPHERE_FALLBACK_HEIGHT)
    return SELECTION_SPHERE_FALLBACK_RADIUS, Center
  end
  local ExtentX = math.abs(BoxExtent.X or 0)
  local ExtentY = math.abs(BoxExtent.Y or 0)
  local ExtentZ = math.abs(BoxExtent.Z or 0)
  local Radius = math.max(ExtentX, ExtentY, ExtentZ, SELECTION_SPHERE_MIN_RADIUS)
  return Radius, FVector(Origin.X, Origin.Y, Origin.Z)
end

function M:_EnsureSelectionSphere()
  if not IsValid(self.Actor) or not self.Actor.AddComponentByClass then
    return false
  end
  if self.Actor.SetActorEnableCollision then
    self.Actor:SetActorEnableCollision(true)
  end
  local Sphere = self.SelectionSphere
  if not IsValid(Sphere) then
    Sphere = self.Actor:AddComponentByClass(USphereComponent:StaticClass(), false, FTransform(), false)
    if not IsValid(Sphere) then
      return false
    end
    if URuntimeCommonFunctionLibrary and URuntimeCommonFunctionLibrary.RegisterComponent then
      URuntimeCommonFunctionLibrary.RegisterComponent(Sphere)
    elseif Sphere.RegisterComponent then
      Sphere:RegisterComponent()
    end
    local RootComponent = self.Actor.K2_GetRootComponent and self.Actor:K2_GetRootComponent() or self.Actor:GetRootComponent()
    if RootComponent and Sphere.K2_AttachToComponent then
      Sphere:K2_AttachToComponent(RootComponent, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
    end
    if Sphere.SetHiddenInGame then
      Sphere:SetHiddenInGame(true)
    end
    if Sphere.SetGenerateOverlapEvents then
      Sphere:SetGenerateOverlapEvents(false)
    end
    self.SelectionSphere = Sphere
  end
  local Radius, Center = ComputeSelectionSphereMetrics(self.Actor)
  if Sphere.SetSphereRadius then
    Sphere:SetSphereRadius(Radius, true)
  end
  if Sphere.K2_SetWorldLocation then
    Sphere:K2_SetWorldLocation(Center, false, nil, false)
  end
  SetComponentSelectionCollision(Sphere)
  return true
end

function M:_RefreshSelectionCollision(Reason)
  if not self.EnableSelectionCollision or not IsValid(self.Actor) then
    return
  end
  self:_EnsureSelectionSphere()
end

function M:_SetupSelectionCollisionRefresh()
  self:_BindSelectionCollisionReadyCallback()
  if not IsValid(self.Actor) then
    return
  end
  if self.Actor.IsLoadedMesh then
    self:_RefreshSelectionCollision("create_loaded")
    if self.OnResourceReady then
      self:OnResourceReady()
    end
  else
    self:_RefreshSelectionCollision("create_pending")
  end
end

function M:_DestroyEffectCreature()
  self:_UnbindSelectionCollisionReadyCallback()
  self:_DestroySelectionSphere()
  if IsValid(self.SpawnHostActor) and IsValid(self.Actor) then
    if self.SpawnHostActor.RemoveEffectCreatureByRef then
      self.SpawnHostActor:RemoveEffectCreatureByRef(self.Actor)
    elseif self.EffectCreatureId and self.SpawnHostActor.RemoveEffectCreature then
      self.SpawnHostActor:RemoveEffectCreature(self.EffectCreatureId)
    end
  elseif IsValid(self.Actor) then
    self.Actor:K2_DestroyActor()
  end
  self.Actor = nil
  self.EffectCreatureId = nil
  self.SpawnHostActor = nil
end

function M:Create(PetInfo, OwnerCharacterHandle, CreateParams)
  self:Dispose()
  self.PetInfo = PetInfo
  self.OwnerCharacterHandle = OwnerCharacterHandle
  CreateParams = CreateParams or {}
  self.RootActor = self.SceneService and self.SceneService:GetPreviewRootActor() or nil
  local PetId = PetInfo and PetInfo.PetId or nil
  local PetCfg = PetId and DataMgr.Pet and DataMgr.Pet[PetId] or nil
  local EffectCreatureId = PetCfg and PetCfg.EffectCreatureId or nil
  if not EffectCreatureId then
    return
  end
  self.SpawnHostActor = nil
  self.EffectCreatureId = EffectCreatureId
  self.Actor = self:_SpawnStandalonePet(EffectCreatureId)
  if not IsValid(self.Actor) then
    self.Actor = nil
    self.EffectCreatureId = nil
    return
  end
  if self.Actor.SkeletalMesh and self.Actor.SkeletalMesh.SetTickableWhenPaused then
    self.Actor.SkeletalMesh:SetTickableWhenPaused(true)
  end
  if self.RootActor then
    self.Actor:K2_AttachToActor(self.RootActor, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
  end
  self.Actor:SetActorHiddenInGame(false)
  if self.EnableSelectionCollision then
    self:_SetupSelectionCollisionRefresh()
  end
  if CreateParams.Transform then
    self:SetTransform(CreateParams.Transform)
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
  if not IsValid(self.Actor) or not Transform then
    return false
  end
  local RootActor = self.RootActor or self.SceneService and self.SceneService:GetPreviewRootActor() or nil
  if RootActor then
    SetActorRelativeTransformInternal(self.Actor, Transform)
    return true
  end
  local BaseTransform = self.SceneService and self.SceneService.GetPreviewSceneTrans and self.SceneService:GetPreviewSceneTrans() or nil
  local WorldTransform = BuildWorldTransform(BaseTransform, Transform)
  self.Actor:K2_SetActorTransform(WorldTransform or Transform, false, nil, false)
  return true
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
  if not IsValid(OwnerActor) then
    OwnerActor = self.Actor
  end
  local PetId = self.PetInfo and self.PetInfo.PetId
  local PetData = PetId and DataMgr.Pet[PetId]
  if OwnerActor and PetData then
    AudioManager(OwnerActor):PlayPetVoice(OwnerActor, PetData.PetNameTag, VoiceKey or "vo_hello", "PreviewPetVoice")
  end
end

function M:Dispose()
  self:_DestroyEffectCreature()
  self.OnResourceReady = nil
  self.OwnerCharacterHandle = nil
  self.PetInfo = nil
  self.CurrentTransform = nil
  self.RootActor = nil
  self.HideTags = {}
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

return M
