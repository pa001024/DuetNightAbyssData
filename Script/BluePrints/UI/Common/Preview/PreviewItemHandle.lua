require("UnLua")
local M = {}

local function ApplyMeshSelectionCollision(Component)
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

local function EnableActorSelectionCollision(TargetActor)
  if not IsValid(TargetActor) then
    return
  end
  TargetActor:SetActorEnableCollision(true)
  ApplyMeshSelectionCollision(TargetActor.StaticMeshComponent)
  ApplyMeshSelectionCollision(TargetActor.Mesh)
  if not TargetActor.K2_GetComponentsByClass then
    return
  end
  local Components = TargetActor:K2_GetComponentsByClass(UMeshComponent:StaticClass())
  local ComponentList = Components and Components.ToTable and Components:ToTable() or Components
  if not ComponentList then
    return
  end
  for _, Component in pairs(ComponentList) do
    ApplyMeshSelectionCollision(Component)
  end
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.SceneService = Params.SceneService
  self.EnableSelectionCollision = Params.EnableSelectionCollision == true
  self.ItemData = nil
  self.Actor = nil
  self.RootActor = nil
  self.CurrentTransform = nil
  self.SpawnHostActor = nil
  self.EffectCreatureId = nil
end

function M:GetActor()
  return self.Actor
end

function M:IsValid()
  return IsValid(self.Actor)
end

function M:_ApplyPreviewCollision()
  if not IsValid(self.Actor) then
    return
  end
  if self.EnableSelectionCollision then
    EnableActorSelectionCollision(self.Actor)
    return
  end
  self.Actor:SetActorEnableCollision(false)
end

function M:_AttachToPreviewRoot()
  if not self.Actor then
    return
  end
  if self.RootActor then
    self.Actor:K2_AttachToActor(self.RootActor, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
  end
  if self.CurrentTransform then
    self:SetTransform(self.CurrentTransform)
  end
  self.Actor:SetActorHiddenInGame(false)
end

function M:_DestroyEffectCreature()
  if IsValid(self.SpawnHostActor) and IsValid(self.Actor) and self.SpawnHostActor.RemoveEffectCreatureByRef then
    self.SpawnHostActor:RemoveEffectCreatureByRef(self.Actor)
  elseif IsValid(self.Actor) then
    self.Actor:K2_DestroyActor()
  end
  self.Actor = nil
  self.SpawnHostActor = nil
  self.EffectCreatureId = nil
end

function M:Create(ItemData, CreateParams)
  self:Dispose()
  self.ItemData = ItemData
  CreateParams = CreateParams or {}
  self.CurrentTransform = CreateParams.Transform
  local Path = ItemData and ItemData.Path or nil
  local EffectCreatureId = ItemData and ItemData.EffectCreatureId or nil
  local SpawnHostActor = CreateParams.SpawnHostActor
  local World = self.ViewUI and self.ViewUI:GetWorld() or nil
  self.RootActor = self.SceneService and self.SceneService:GetPreviewRootActor() or nil
  DebugPrint(string.format("PreviewItemHandle: create begin itemId=%s effectCreatureId=%s path=%s hasRoot=%s hasHost=%s", tostring(ItemData and ItemData.ItemId or nil), tostring(EffectCreatureId), tostring(Path), tostring(IsValid(self.RootActor)), tostring(IsValid(SpawnHostActor))))
  if not EffectCreatureId and ("string" ~= type(Path) or "" == Path) then
    DebugPrint(string.format("PreviewItemHandle: missing actor path itemId=%s", tostring(ItemData and ItemData.ItemId or nil)))
    return false
  end
  if not World then
    DebugPrint(string.format("PreviewItemHandle: missing world itemId=%s path=%s", tostring(ItemData and ItemData.ItemId or nil), Path))
    return false
  end
  local bBlueprintActor = false
  if EffectCreatureId then
    if not self.SceneService or not self.SceneService.SpawnPreviewEffectCreature then
      DebugPrint(string.format("PreviewItemHandle: missing preview effect creature service itemId=%s effectCreatureId=%s", tostring(ItemData and ItemData.ItemId or nil), tostring(EffectCreatureId)))
      return false
    end
    self.SpawnHostActor = SpawnHostActor
    self.EffectCreatureId = EffectCreatureId
    self.Actor = self.SceneService:SpawnPreviewEffectCreature(EffectCreatureId, SpawnHostActor)
    if not IsValid(self.Actor) then
      self.SpawnHostActor = nil
      self.EffectCreatureId = nil
      return false
    end
    if self.Actor.SkeletalMesh and self.Actor.SkeletalMesh.SetTickableWhenPaused then
      self.Actor.SkeletalMesh:SetTickableWhenPaused(true)
    end
    self:_AttachToPreviewRoot()
    self:_ApplyPreviewCollision()
    DebugPrint(string.format("PreviewItemHandle: effect creature attached itemId=%s effectCreatureId=%s actor=%s", tostring(ItemData and ItemData.ItemId or nil), tostring(EffectCreatureId), tostring(self.Actor)))
    return true
  else
    bBlueprintActor = string.sub(Path, 1, 10) == "Blueprint'" or string.sub(Path, 1, 24) == "BlueprintGeneratedClass'"
  end
  if not self.Actor and bBlueprintActor then
    local ActorClass = LoadClass(Path)
    if not ActorClass then
      DebugPrint(string.format("PreviewItemHandle: load blueprint actor class failed itemId=%s path=%s", tostring(ItemData and ItemData.ItemId or nil), Path))
      return false
    end
    self.Actor = World:SpawnActor(ActorClass, FTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  elseif not self.Actor then
    local StaticMesh = LoadObject(Path)
    if not StaticMesh then
      DebugPrint(string.format("PreviewItemHandle: load static mesh failed itemId=%s path=%s", tostring(ItemData and ItemData.ItemId or nil), Path))
      return false
    end
    local ActorClass = UE4.AStaticMeshActor:StaticClass()
    self.Actor = World:SpawnActor(ActorClass, FTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    if self.Actor then
      self.Actor.StaticMeshComponent:SetMobility(EComponentMobility.Movable)
      self.Actor.StaticMeshComponent:SetStaticMesh(StaticMesh)
    end
  end
  if not self.Actor then
    DebugPrint(string.format("PreviewItemHandle: spawn actor failed itemId=%s path=%s", tostring(ItemData and ItemData.ItemId or nil), Path))
    return false
  end
  if not bBlueprintActor then
    self.Actor:SetActorTickEnabled(false)
  end
  if self.RootActor then
    self.Actor:K2_AttachToActor(self.RootActor, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
  end
  if self.CurrentTransform then
    self:SetTransform(self.CurrentTransform)
  end
  self:_ApplyPreviewCollision()
  DebugPrint(string.format("PreviewItemHandle: normal actor attached itemId=%s actor=%s blueprint=%s", tostring(ItemData and ItemData.ItemId or nil), tostring(self.Actor), tostring(bBlueprintActor)))
  return true
end

function M:SetTransform(Transform)
  self.CurrentTransform = Transform
  if not self.Actor or not Transform then
    return false
  end
  if self.RootActor then
    self.Actor:K2_SetActorRelativeTransform(Transform, false, nil, false)
  else
    self.Actor:K2_SetActorTransform(Transform, false, nil, false)
  end
  return true
end

function M:GetTransform()
  if self.Actor then
    if self.RootActor and self.Actor.GetActorRelativeTransform then
      return self.Actor:GetActorRelativeTransform()
    end
    return self.Actor:GetTransform()
  end
  return self.CurrentTransform
end

function M:Show()
  if self.Actor then
    self.Actor:SetActorHiddenInGame(false)
  end
end

function M:Hide()
  if self.Actor then
    self.Actor:SetActorHiddenInGame(true)
  end
end

function M:Dispose()
  self:_DestroyEffectCreature()
  self.RootActor = nil
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

return M
