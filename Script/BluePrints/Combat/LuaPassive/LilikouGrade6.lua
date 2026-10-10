local M = {}

function M:Damage(Character, Damage, Source, Target)
  if not Damage.IsCrit then
    return
  end
  if not Target then
    return
  end
  if self.Grade6OnCd then
    return
  end
  local CD = self.Grade6CD or 0.5
  self.Grade6OnCd = true
  local P = self
  self:AddTimer(CD, function()
    P.Grade6OnCd = false
  end, false, 0, "LilikouGrade6CD")
  local Buff = self.OwnerBuff
  if not Buff then
    return
  end
  local BattleObj = UE4.UBattleFunctionLibrary.Battle(self.PassiveOwner)
  if not BattleObj or Buff.RootSourceEid <= 0 then
    return
  end
  local RootSource = BattleObj:GetEntity(Buff.RootSourceEid)
  if not RootSource then
    return
  end
  UE4.UBattleFunctionLibrary.ExecuteSkillEffects(RootSource, {540241, 540242}, Target, Buff.SourceSkill, Buff)
end

return M
