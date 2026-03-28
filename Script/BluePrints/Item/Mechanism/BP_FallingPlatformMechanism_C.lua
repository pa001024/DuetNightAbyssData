local BP_FallingPlatformMechanism_C = Class({
  "BluePrints.Item.BP_CombatItemBase_C"
})

function BP_FallingPlatformMechanism_C:OnPlayerIn(Player)
  if self.OnBreak then
    return
  end
  if not self.IsInside then
    self:ChangeState("Manual", 0, self.BrokenStateId)
  end
  self.IsInside = true
end

function BP_FallingPlatformMechanism_C:OnPlayerOut(Player)
  self.IsInside = false
end

function BP_FallingPlatformMechanism_C:FallDown()
  self.IsInside = false
  self.Cube:SetVisibility(false, true)
  self:AddTimer(self.ReplaceTime, self.FallUp)
  self.Cube:SetCollisionEnabled(0)
end

function BP_FallingPlatformMechanism_C:FallUp()
  self:ChangeState("Manual", 0, self.RecoverStateId)
end

function BP_FallingPlatformMechanism_C:ResetCollision()
  self.Cube:SetCollisionEnabled(3)
end

function BP_FallingPlatformMechanism_C:MoveDown()
  local Loc = self:K2_GetActorLocation()
  Loc.Z = Loc.Z - 1000
  self:K2_SetActorLocation(Loc, false, nil, false)
end

function BP_FallingPlatformMechanism_C:AdjustPlayersAbovePlatform()
  if not self.CollisionMesh then
    return
  end
  local UKismetSystemLibrary = UE.UKismetSystemLibrary
  local MeshLoc = self.CollisionMesh:K2_GetComponentLocation()
  local Origin, BoxExtent = self.CollisionMesh:GetLocalBounds()
  local WorldScale = self.CollisionMesh:K2_GetComponentScale()
  local ScaledExtent = UE.FVector(BoxExtent.X * WorldScale.X, BoxExtent.Y * WorldScale.Y, BoxExtent.Z * WorldScale.Z)
  local PlatformTopZ = MeshLoc.Z + ScaledExtent.Z
  local ObjectTypes = UE.TArray(UE.EObjectTypeQuery)
  ObjectTypes:Add(UE.EObjectTypeQuery.Pawn)
  local ActorsToIgnore = UE.TArray(UE.AActor)
  ActorsToIgnore:Add(self)
  local OutActors = UE.TArray(UE.AActor)
  local bHit = UKismetSystemLibrary.BoxOverlapActors(self, MeshLoc, ScaledExtent, ObjectTypes, nil, ActorsToIgnore, OutActors)
  if bHit then
    for i = 1, OutActors:Length() do
      local Actor = OutActors:Get(i)
      local CapsuleComp = Actor.CapsuleComponent or Actor.CollisionComponent
      if CapsuleComp then
        local CapsuleHalfHeight = CapsuleComp:GetScaledCapsuleHalfHeight()
        local PlayerLoc = Actor:K2_GetActorLocation()
        local PlayerFootZ = PlayerLoc.Z - CapsuleHalfHeight
        if PlatformTopZ > PlayerFootZ then
          PlayerLoc.Z = PlatformTopZ + CapsuleHalfHeight + 5.0
          Actor:K2_SetActorLocation(PlayerLoc, false, nil, true)
        end
      end
    end
  end
end

function BP_FallingPlatformMechanism_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == self.BrokenStateId and not self.OnBreak then
    if self.OnPlatformBreak then
      self:OnPlatformBreak()
      self.OnPlayerInHandle = self:AddTimer(self.WarningTime, self.FallDown)
    end
  elseif NowStateId == self.RecoverStateId then
    if self.OnPlatformReplace then
      self:OnPlatformReplace()
    end
    self.Cube:SetVisibility(true, true)
  elseif NowStateId == self.NormalStateId then
    self:AdjustPlayersAbovePlatform()
  end
end

return BP_FallingPlatformMechanism_C
