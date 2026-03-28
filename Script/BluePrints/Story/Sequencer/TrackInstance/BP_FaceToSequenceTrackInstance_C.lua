local M = Class()

function M:SetControlParamWithNewInterface(EyePitch, EyeYaw, HeadPitch, HeadYaw)
  local NpcCharacter = self:GetAnimatedObject()
  if not NpcCharacter or not NpcCharacter.NpcAnimInstance then
    return
  end
  local AnimInstance = NpcCharacter.NpcAnimInstance
  AnimInstance.OpenAnimationEyeControl = true
  AnimInstance.HeadControlPitch = HeadPitch
  AnimInstance.HeadControlYaw = HeadYaw
  AnimInstance.EyeControlPitch = EyePitch
  AnimInstance.EyeControlYaw = EyeYaw
end

function M:CloseNewInterfaceControl()
  local NpcCharacter = self:GetAnimatedObject()
  if not NpcCharacter then
    return
  end
  local AnimInstance = NpcCharacter.NpcAnimInstance
  if AnimInstance then
    AnimInstance.OpenAnimationEyeControl = false
    AnimInstance.HeadControlPitch = 0
    AnimInstance.HeadControlYaw = 0
    AnimInstance.EyeControlPitch = 0
    AnimInstance.EyeControlYaw = 0
  end
end

return M
