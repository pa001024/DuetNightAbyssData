local M = Class()

function M:PlayFacial(Section, Input)
  local FacialSaveData = UE.FFacialSaveData()
  FacialSaveData.Input = Input
  FacialSaveData.Section = Section
  FacialSaveData.Character = self:GetAnimatedObject()
  if not Section then
    return FacialSaveData
  end
  if not FacialSaveData.Character then
    return FacialSaveData
  end
  local Character = FacialSaveData.Character
  local AnimInstance = Character.NpcAnimInstance
  if not AnimInstance then
    return FacialSaveData
  end
  if Section.bForbidDefaultBlink then
    AnimInstance:StopBlinkTimer()
  end
  if 0 == self:GetNumInputs() then
    Character:StopFacial()
  end
  Section:RefreshFacial(Character)
  UTalkFunctionLibrary.SetMontageBlendInTime(Section.NpcEye1, 0)
  UTalkFunctionLibrary.SetMontageBlendInTime(Section.NpcMouthLoop, 0)
  UTalkFunctionLibrary.SetMontageBlendInTime(Section.SoundBaseMouth, 0)
  self:TryClearAllExternMontage(AnimInstance, Section.NpcEye1)
  self:TryClearAllExternMontage(AnimInstance, Section.NpcMouthLoop)
  self:TryClearAllExternMontage(AnimInstance, Section.SoundBaseMouth)
  self:TryPlayMontage(AnimInstance, Section.NpcEye1)
  self:TryPlayMontage(AnimInstance, Section.NpcMouthLoop)
  self:TryPlayMontage(AnimInstance, Section.SoundBaseMouth)
  return FacialSaveData
end

return M
