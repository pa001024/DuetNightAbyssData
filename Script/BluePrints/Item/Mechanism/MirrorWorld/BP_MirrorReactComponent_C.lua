require("UnLua")
local BP_MirrorReactComponent_C = Class("BluePrints.Item.Mechanism.MirrorWorld.MirrorComponentBase")
local MirrorWorldState = CommonConst.MirrorWorldState
local ALIGN_RETRY_INTERVAL = 0.1
local ALIGN_MAX_RETRY = 50

function BP_MirrorReactComponent_C:OnRegisteredToAreaBox()
  self:RequestAlignWorldState()
end

function BP_MirrorReactComponent_C:OnMirrorWorldStateChange_Logic(NewState, OldState)
  self:RequestAlignWorldState(NewState)
end

function BP_MirrorReactComponent_C:ReceiveEndPlay(EndPlayReason)
  self:RemoveTimer("MirrorAlignRetry")
  BP_MirrorReactComponent_C.Super.ReceiveEndPlay(self, EndPlayReason)
end

function BP_MirrorReactComponent_C:RequestAlignWorldState(WorldState)
  if nil ~= WorldState then
    rawset(self, "PendingWorldState", WorldState)
  else
    rawset(self, "PendingWorldState", self:GetMirrorWorldState())
  end
  rawset(self, "AlignRetryCount", 0)
  self:TryAlignWorldState()
end

function BP_MirrorReactComponent_C:IsOwnerReadyForMirrorReact()
  local Owner = self:GetOwner()
  if not IsValid(Owner) or not Owner.InitSuccess then
    return false
  end
  if self.bToggleInteractive and not Owner.DefaultInteractiveComponent then
    return false
  end
  return true
end

function BP_MirrorReactComponent_C:TryAlignWorldState()
  if self:IsOwnerReadyForMirrorReact() then
    self:RemoveTimer("MirrorAlignRetry")
    local WorldState = rawget(self, "PendingWorldState")
    if nil == WorldState then
      WorldState = self:GetMirrorWorldState()
    end
    self:ApplyWorldState(WorldState)
    return
  end
  self.AlignRetryCount = (self.AlignRetryCount or 0) + 1
  if self.AlignRetryCount >= ALIGN_MAX_RETRY then
    DebugPrint("[MirrorWorld] ReactAlign timeout, Owner not ready:", self:GetOwner() and self:GetOwner():GetName())
    return
  end
  self:AddTimer(ALIGN_RETRY_INTERVAL, self.TryAlignWorldState, false, 0, "MirrorAlignRetry")
end

function BP_MirrorReactComponent_C:ApplyWorldState(WorldState)
  local bInRealWorld = WorldState == MirrorWorldState.RealWorld
  local bActive = bInRealWorld == self.bActiveInRealWorld
  if self.bToggleInteractive then
    self:ApplyInteractive(bActive)
  end
  if self.bToggleCollision then
    self:ApplyCollision(bActive)
  end
  if self.bToggleAppearance then
    self:ApplyAppearance(bActive)
  end
end

function BP_MirrorReactComponent_C:ApplyInteractive(bActive)
  local Owner = self:GetOwner()
  local InteractComp = Owner.DefaultInteractiveComponent
  if not InteractComp then
    DebugPrint("yly BP_MirrorReactComponent_C:ApplyInteractive InteractComp not found")
    return
  end
  if rawget(self, "CachedCanUsed") == nil then
    rawset(self, "CachedCanUsed", InteractComp.bCanUsed)
  end
  if bActive then
    InteractComp.bCanUsed = self.CachedCanUsed
  else
    InteractComp.bCanUsed = false
  end
end

function BP_MirrorReactComponent_C:ApplyCollision(bActive)
  if rawget(self, "CachedCollision") == nil then
    rawset(self, "CachedCollision", {})
  end
  for _, Comp in ipairs(self:GetTargetPrimitiveComponents()) do
    if self.CachedCollision[Comp] == nil then
      self.CachedCollision[Comp] = Comp:GetCollisionEnabled()
    end
    if bActive then
      Comp:SetCollisionEnabled(self.CachedCollision[Comp])
    else
      Comp:SetCollisionEnabled(UE4.ECollisionEnabled.NoCollision)
    end
  end
end

function BP_MirrorReactComponent_C:GetTargetPrimitiveComponents()
  local Owner = self:GetOwner()
  local Result = {}
  if self.CollisionComponentNames:Length() > 0 then
    for i = 1, self.CollisionComponentNames:Length() do
      local Comp = Owner[tostring(self.CollisionComponentNames:Get(i))]
      if Comp then
        table.insert(Result, Comp)
      end
    end
  else
    local Comps = Owner:K2_GetComponentsByClass(UE4.UPrimitiveComponent.StaticClass())
    for i = 1, Comps:Length() do
      table.insert(Result, Comps:Get(i))
    end
  end
  return Result
end

function BP_MirrorReactComponent_C:ApplyAppearance(bActive)
  local Owner = self:GetOwner()
  for i = 1, self.AppearanceConfigs:Length() do
    local Config = self.AppearanceConfigs:Get(i)
    local Mesh = Owner[tostring(Config.MeshComponentName)]
    if Mesh then
      self:CacheOriginMaterials(Mesh)
      if bActive then
        self:RestoreMaterials(Mesh)
      else
        for SlotIndex = 1, Config.InactiveMaterials:Length() do
          local Material = Config.InactiveMaterials:Get(SlotIndex)
          if Material then
            Mesh:SetMaterial(SlotIndex - 1, Material)
          end
        end
      end
    end
  end
end

function BP_MirrorReactComponent_C:CacheOriginMaterials(Mesh)
  if rawget(self, "CachedMaterials") == nil then
    rawset(self, "CachedMaterials", {})
  end
  if self.CachedMaterials[Mesh] then
    return
  end
  local Materials = {}
  for SlotIndex = 0, Mesh:GetNumMaterials() - 1 do
    Materials[SlotIndex] = Mesh:GetMaterial(SlotIndex)
  end
  self.CachedMaterials[Mesh] = Materials
end

function BP_MirrorReactComponent_C:RestoreMaterials(Mesh)
  local Materials = self.CachedMaterials and self.CachedMaterials[Mesh]
  if not Materials then
    return
  end
  for SlotIndex, Material in pairs(Materials) do
    Mesh:SetMaterial(SlotIndex, Material)
  end
end

return BP_MirrorReactComponent_C
