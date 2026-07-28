local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.SkillEffect = self.UnitParams.SkillEffect
  self.Condition = self.UnitParams.Condition
end

function M:AuthorityInitInfo(Info)
  M.Super.AuthorityInitInfo(self, Info)
  self.Box.OnComponentBeginOverlap:Add(self, self.CollisionBeginOverlap)
end

function M:CollisionBeginOverlap(Component, OtherActor)
  if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
    return
  end
  if not IsStandAlone(self) or not IsAuthority(self) then
    return
  end
  if self.Condition == "Jump" and OtherActor.InSlideMechJump then
    return
  end
  if self.Condition == "Slide" and OtherActor.InSlideMechSlide then
    return
  end
  if self.OnHitPlayer then
    self:OnHitPlayer()
  end
  self.Super.PropUseSkill(self, self.SkillEffect, OtherActor)
end

return M
