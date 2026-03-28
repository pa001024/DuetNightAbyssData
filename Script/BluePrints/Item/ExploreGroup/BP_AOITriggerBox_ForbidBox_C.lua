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
  if self.InTransformCD then
    return false, FTransform()
  end
  self.InTransformCD = true
  self:AddTimer(0.01, function()
    self.InTransformCD = false
  end, false, 0)
  local PlayerTrans = self.OverlappingPlayer:GetTransform()
  local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
  DebugPrint("zwjkjk PlayerTrans ", PlayerTrans)
  DebugPrint("zwjkjk BoxTrans ", BoxTrans)
  return true, UE.UKismetMathLibrary.MakeRelativeTransform(PlayerTrans, BoxTrans)
end

function M:SetNewTransform(Transform)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Player then
    return
  end
  local Controller = Player:GetController()
  local OldActorRot = Player:K2_GetActorRotation()
  local OldCtrlRot
  if Controller then
    OldCtrlRot = Controller:GetControlRotation()
  end
  local BoxTrans = self.CollisionComponent:K2_GetComponentToWorld()
  local NewPlayerTrans = UE.UKismetMathLibrary.ComposeTransforms(Transform, BoxTrans)
  Player:K2_SetActorTransform(NewPlayerTrans, false, nil, true)
  DebugPrint("zwjkjk SetNewTransform ", NewPlayerTrans)
  if Controller and OldCtrlRot then
    local NewActorRot = NewPlayerTrans.Rotator and NewPlayerTrans:Rotator() or Player:K2_GetActorRotation()
    local DeltaYaw = NewActorRot.Yaw - OldActorRot.Yaw
    local NewCtrlRot = UE.FRotator(OldCtrlRot.Pitch, OldCtrlRot.Yaw + DeltaYaw, OldCtrlRot.Roll)
    Controller:SetControlRotation(NewCtrlRot)
    local MovementComp = Player.CharacterMovement or Player:GetMovementComponent()
    if MovementComp then
      local OldVelocity = MovementComp.Velocity
      if OldVelocity and (0 ~= OldVelocity.X or 0 ~= OldVelocity.Y or 0 ~= OldVelocity.Z) then
        local DeltaRotator = UE.FRotator(0, DeltaYaw, 0)
        local NewVelocity = UE.UKismetMathLibrary.GreaterGreater_VectorRotator(OldVelocity, DeltaRotator)
        MovementComp.Velocity = NewVelocity
      end
    end
  end
end

return M
