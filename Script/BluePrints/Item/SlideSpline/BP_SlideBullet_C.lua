require("UnLua")
local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.SkillEffect = self.UnitParams.SkillEffect
end

function M:ReceiveBeginPlay()
  M.Super.ReceiveBeginPlay(self)
  self.PrimaryActorTick.bCanEverTick = true
  self.PrimaryActorTick.TickInterval = 0.2
end

function M:AuthorityInitInfo(Info)
  M.Super.AuthorityInitInfo(self, Info)
  if IsValid(self.Box) then
    self.Box.OnComponentBeginOverlap:Add(self, self.CollisionBeginOverlap)
  end
  self.LifeTime = 0
  self.FlyElapsed = 0
  self.bFlyStarted = false
  self.bHasHitPlayer = false
  self.RelativeToBossOffset = nil
  self.RelativeDisplacement = nil
end

function M:GetBossActor()
  local Boss = self:GetDirectSource()
  if Boss and IsValid(Boss) then
    return Boss
  end
  return nil
end

function M:InitRelativeToBoss()
  if self.RelativeToBossOffset then
    return true
  end
  local Boss = self:GetBossActor()
  if not Boss then
    return false
  end
  local BulletLoc = self:K2_GetActorLocation()
  local BossLoc = Boss:K2_GetActorLocation()
  self.RelativeToBossOffset = BulletLoc - BossLoc
  return true
end

function M:StartFlyToPlayer(BossLoc)
  self.bFlyStarted = true
  self.FlyElapsed = 0
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local BaseLoc = BossLoc + self.RelativeToBossOffset
  if Player then
    self.RelativeDisplacement = Player:K2_GetActorLocation() - BaseLoc
  else
    self.RelativeDisplacement = UE4.FVector(0, 0, 0)
  end
end

function M:UpdateSlideBulletMove(DeltaSeconds)
  if not IsAuthority(self) then
    return
  end
  self.LifeTime = (self.LifeTime or 0) + DeltaSeconds
  local DestroyTime = self.DestroyTime or 0
  local Boss = self:GetBossActor()
  if not Boss then
    return
  end
  if not self:InitRelativeToBoss() then
    return
  end
  local StartMoveTime = self.StartMoveTime or 0
  local MoveTotalTime = self.MoveTotalTime or 0
  local BossLoc = Boss:K2_GetActorLocation()
  local BaseLoc = BossLoc + self.RelativeToBossOffset
  local NewLoc = BaseLoc
  if StartMoveTime <= self.LifeTime then
    if not self.bFlyStarted then
      self:StartFlyToPlayer(BossLoc)
    end
    if self.RelativeDisplacement then
      self.FlyElapsed = self.FlyElapsed + DeltaSeconds
      if DestroyTime > 0 and DestroyTime <= self.FlyElapsed then
        self:EMActorDestroy(EDestroyReason.MechanismLifeTime)
        return
      end
      local Alpha = 1
      if MoveTotalTime > 0 then
        Alpha = math.min(1, self.FlyElapsed / MoveTotalTime)
      end
      NewLoc = BaseLoc + self.RelativeDisplacement * Alpha
    end
  end
  self:K2_SetActorLocation(NewLoc, false, nil, false)
end

function M:ReceiveTick(DeltaSeconds)
  self:UpdateSlideBulletMove(DeltaSeconds)
end

function M:TryTriggerBossDamageEvent()
  if not IsAuthority(self) then
    return
  end
  local BossDamageDistance = self.BossDamageDistance or 0
  if BossDamageDistance <= 0 then
    return
  end
  local Boss = self:GetBossActor()
  if not Boss then
    return
  end
  local Dist = UE4.UKismetMathLibrary.Vector_Distance(self:K2_GetActorLocation(), Boss:K2_GetActorLocation())
  if BossDamageDistance < Dist then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    GameMode:TriggerGameModeEvent("OnSlideBulletBreakBoss", Boss.Eid)
  end
end

function M:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
  self:TryTriggerBossDamageEvent()
  M.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
  self:EMActorDestroy(EDestroyReason.MechanismDead)
end

function M:CollisionBeginOverlap(Component, OtherActor)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    return
  end
  if not IsStandAlone(self) or not IsAuthority(self) then
    return
  end
  if self.bHasHitPlayer then
    return
  end
  if not self.SkillEffect then
    return
  end
  self.bHasHitPlayer = true
  M.Super.PropUseSkill(self, self.SkillEffect, OtherActor)
  self:EMActorDestroy(EDestroyReason.MechanismDead)
end

return M
