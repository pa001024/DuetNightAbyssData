require("UnLua")
local M = Class({
  "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C"
})

function M:OnEnergyZero()
  self.Overridden.OnEnergyZero(self)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local PlayerLoc = Player:K2_GetActorLocation()
  self.bCanMove = true
  self:SetMovementTarget(5, true, PlayerLoc)
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
  M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
  self:EMActorDestroy(EDestroyReason.MechanismDead)
end

function M:MoveTargetEnd()
  if not self.bCanMove then
    return
  end
  self.Overridden.MoveTargetEnd(self)
  self.bCanMove = false
end

function M:StateCreateReward(PlayerId, NextStateId)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local ExtraInfo = {
      UniqueSign = self.Eid,
      SourceEid = Player.Eid,
      WorldRegionEid = self.WorldRegionEid,
      RegionDataType = self.RegionDataType
    }
    
    local function CallBack()
      self.CombatStateChangeComponent:TriggerOnEventEnd(NextStateId)
    end
    
    return GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Chest, self:GetTransform(), ExtraInfo, CallBack)
  end
  return false
end

function M:GetEffectCreature()
  local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
  local EffectList = Player:GetEffectCreatureByTag("Prop")
  if EffectList:Length() > 0 then
    return EffectList:GetRef(1)
  end
  return Player
end

return M
