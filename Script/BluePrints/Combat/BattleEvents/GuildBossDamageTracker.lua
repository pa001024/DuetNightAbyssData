require("UnLua")
local M = Class()

function M:ActivateTracker(BossEid)
  self.BossEid = BossEid
  self.TrialConditions = {}
  self.MatchingDamage = {}
  self.MatchingHitCount = {}
  self.TotalDamage = 0
  self.bStatsDirty = false
  self:SetTrackerActive(true)
end

function M:DeactivateTracker()
  self:SetTrackerActive(false)
end

function M:AddTrialCondition(TrialId, ConditionType, ConditionValue)
  local List = self.TrialConditions[TrialId]
  if not List then
    List = {}
    self.TrialConditions[TrialId] = List
  end
  table.insert(List, {Type = ConditionType, Value = ConditionValue})
end

function M:RemoveTrialCondition(TrialId)
  if self.TrialConditions then
    self.TrialConditions[TrialId] = nil
  end
  if self.MatchingDamage then
    self.MatchingDamage[TrialId] = nil
  end
  if self.MatchingHitCount then
    self.MatchingHitCount[TrialId] = nil
  end
end

function M:GetTrialMatchingDamage(TrialId)
  return self.MatchingDamage and self.MatchingDamage[TrialId] or 0
end

function M:GetTrialMatchingHitCount(TrialId)
  return self.MatchingHitCount and self.MatchingHitCount[TrialId] or 0
end

function M:GetTotalDamage()
  return self.TotalDamage or 0
end

function M:OnGuildBossDamage(DamageEvent)
  if not DamageEvent or DamageEvent.TargetEid ~= self.BossEid then
    return
  end
  self.TotalDamage = (self.TotalDamage or 0) + DamageEvent.RawValue
  self.bStatsDirty = true
  for TrialId, Conditions in pairs(self.TrialConditions or {}) do
    if self:MatchAllConditions(TrialId, Conditions, DamageEvent) then
      self.MatchingDamage[TrialId] = (self.MatchingDamage[TrialId] or 0) + DamageEvent.RawValue
      self.MatchingHitCount[TrialId] = (self.MatchingHitCount[TrialId] or 0) + 1
      self.bStatsDirty = true
    end
  end
end

function M:MatchAllConditions(TrialId, Conditions, DamageEvent)
  for _, Cond in ipairs(Conditions) do
    if not self:MatchDamageCondition(TrialId, Cond.Type, Cond.Value, DamageEvent) then
      return false
    end
  end
  return true
end

function M:MatchDamageCondition(TrialId, ConditionType, ConditionValue, DamageEvent)
  if "DamageTag" == ConditionType then
    return DamageEvent:HaveDamageTag(ConditionValue)
  elseif "DamageType" == ConditionType then
    return DamageEvent:HaveDamageType(ConditionValue)
  elseif "Extra" == ConditionType then
    if "Crit" == ConditionValue then
      return DamageEvent.IsCrit
    elseif "Trigger" == ConditionValue then
      return DamageEvent.IsTrigger
    end
  end
  return false
end

return M
