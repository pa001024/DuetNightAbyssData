local M = Class("BluePrints.Combat.BP_SkillFeatureLevelSequenceActorBase_C")

function M:IsCanPlay()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Player then
    return false
  end
  if 0 == self.SkillFeatureBuffId then
    return true
  end
  local HasBuff = Player.BuffManager:HasBuff(self.SkillFeatureBuffId)
  return HasBuff
end

function M:SetSequencerLocationOnClient()
  local Mesh = self.OwnerCharacter.Mesh
  if Mesh then
    self:K2_SetActorLocation(Mesh:GetSocketLocation("Root"), false, nil, false)
    local Rotation = Mesh:GetSocketRotation("Root")
    if self.BossSkillFeatureName == "Lianhuo_Skill07" then
      local Correction = FRotator(0, 90, 0)
      Rotation = Rotation + Correction
    end
    self:K2_SetActorRotation(Rotation, false, nil, false)
  end
end

return M
