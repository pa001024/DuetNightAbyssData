local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

function M:CollisionBeginOverlap(Component, OtherActor)
  if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
    return
  end
  self:ExecuteForbid(OtherActor, true)
  self.OverlappingPlayer = OtherActor
  M.Super.CollisionBeginOverlap(self, Component, OtherActor)
end

function M:CollisionEndOverlap(Component, OtherActor)
  if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
    return
  end
  self:ExecuteForbid(OtherActor, false)
  self.OverlappingPlayer = nil
  M.Super.CollisionEndOverlap(self, Component, OtherActor)
end

function M:OnPreTransformPlayer()
  if not self.OverlappingPlayer then
    return false, FTransform()
  end
  local PlayerTrans = self.OverlappingPlayer:GetTransform()
  local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
  return true, UE.UKismetMathLibrary.MakeRelativeTransform(PlayerTrans, BoxTrans)
end

function M:SetNewTransform(Transform)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Player then
    return
  end
  local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
  local NewPlayerTrans = UE.UKismetMathLibrary.ComposeTransforms(Transform, BoxTrans)
  Player:K2_SetActorTransform(NewPlayerTrans, false, nil, false)
  Player:GetController():SetControlRotation(Player:K2_GetActorRotation())
  Player:Landed()
end

return M
