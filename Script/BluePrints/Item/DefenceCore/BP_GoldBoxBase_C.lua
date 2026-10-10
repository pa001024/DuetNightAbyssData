require("UnLua")
local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function M:OnActiveStateChange()
  local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  if self.IsActive then
    GameState.HatredCombatProp:Add(self.Eid, self)
    self.CombatClientEffectComponent:OnActiveEffect()
  else
    GameState.HatredCombatProp:Remove(self.Eid)
    self.CombatClientEffectComponent:OnDeactiveEffect()
  end
end

function M:GetRealSkillId()
  print(_G.LogTag, "LXZ GetRealSkillId", self.UnitId)
  self.SkillList = self.UnitParams.SkillId
  if not self.SkillList then
    return 0
  end
  local WeightSum = 0
  for _, Data in pairs(self.SkillList) do
    WeightSum = WeightSum + Data[1]
  end
  print(_G.LogTag, "LXZ GetRealSkillId11", WeightSum)
  for SkillId, Data in pairs(self.SkillList) do
    local RandomNumber = math.random(1, WeightSum)
    if #Data < 4 then
      print(_G.LogTag, "Error: GoldBoxBase 机关参数错误")
    else
      print(_G.LogTag, "LXZ GetRealSkillId22", SkillId, Data[1], RandomNumber)
      if RandomNumber <= Data[1] then
        return SkillId, Data
      else
        WeightSum = WeightSum - Data[1]
      end
    end
  end
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
  local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  if GameState then
    GameState.HatredCombatProp:Remove(self.Eid)
  end
  local SkillId, Data = self:GetRealSkillId()
  if not Data then
    print(_G.LogTag, "Error: GoldBoxBase 机关SkillId配置错误, UnitId:", self.UnitId)
    M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    return
  end
  print(_G.LogTag, "LXZ GetRealSkillId  OnDead", SkillId, Data[1], Data[2], Data[3], Data[4])
  local Killer = Battle(self):GetEntity(KillMineRoleEid)
  local Source = self
  local PreTarget = self
  local SourceComp = self.RootComponent
  if "Target" == Data[2] then
    Source = Killer
  end
  if "Target" == Data[3] then
    PreTarget = Killer
  end
  if "Target" == Data[4] then
    SourceComp = Killer.RootComponent
  end
  if 0 ~= SkillId and IsValid(Killer) and Killer.IsPlayer and Killer:IsPlayer() then
    local EffectIds = TArray(0)
    EffectIds:Add(SkillId)
    Battle(self):ExecuteSkillEffectsWithType(Source, EffectIds, PreTarget, nil, self, SourceComp)
  end
  M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
end

function M:OnEMActorDestroy(DestroyReason)
  M.Super.OnEMActorDestroy(self, DestroyReason)
  local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  if GameState then
    GameState.HatredCombatProp:Remove(self.Eid)
  end
end

return M
