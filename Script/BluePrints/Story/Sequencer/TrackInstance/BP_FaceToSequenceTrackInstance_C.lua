local M = Class()

function M:ForceFinishTurnTo(LookAtData)
  local Section = LookAtData.Section
  local Character = LookAtData.Character
  if not IsValid(Section) or not IsValid(Character) then
    return
  end
  local AnimInstance = Character.NpcAnimInstance
  local IsRotating = false
  if AnimInstance then
    IsRotating = AnimInstance.IsRotating
  end
  local TargetRotator = Character:K2_GetActorRotation()
  Character:AbortRotation()
  TargetRotator.Yaw = LookAtData.TargetYaw
  Character:K2_SetActorRotation(TargetRotator, false, nil, false)
  if IsRotating and UTrackInstanceFunctionLibrary.IsPlayerJump(self, LookAtData.Input) then
    Character:ForceResetDynamics(true)
  end
end

return M
