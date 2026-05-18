local M = Class({
  "BluePrints/Item/AirWall/BP_FieldCreature_C"
})

function M:OnBreakCountDown(SourceEid)
  M.Super.OnBreakCountDown(self, SourceEid)
  self:ChangeState("Hit", SourceEid)
end

function M:AuthorityInitInfo(Info)
  M.Super.AuthorityInitInfo(self, Info)
  self.HasMonsterInRange = false
  self.InRangeMonsters = {}
  self.Center = self.DetectMonBox:K2_GetComponentLocation()
end

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  EventManager:AddEvent(EventID.OnTempleSmeltChangeBlue, self, self.OnTempleSmeltChangeBlue)
  EventManager:AddEvent(EventID.OnNoticeCageUp, self, self.OnNoticeCageUp)
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
end

function M:ResetInfo()
  self.Overridden.ResetInfo(self)
  self:K2_SetActorLocation(self.LocDown, false, nil, false)
  self:ChangeState("Manual", 0, self.InitStateId)
  self.InRangeMonsters = {}
end

function M:OnMonsterIn(OtherActor)
  if OtherActor and OtherActor.IsPureMonster and OtherActor:IsPureMonster() and self:CheckMonsterValid(OtherActor.UnitId) and not OtherActor:IsDead() then
    self.InRangeMonsters[OtherActor.Eid] = OtherActor
    DebugPrint("zwkkk 添加怪物", OtherActor:GetName(), OtherActor.Eid)
    if not self.HasMonsterInRange and self.StateId ~= self.UpToDownStateId then
      self.HasMonsterInRange = true
      self:OnMonsterInRangeChange()
    end
  end
end

function M:OnMonsterOut(OtherActor)
  if OtherActor and OtherActor.IsPureMonster and OtherActor:IsPureMonster() and self:CheckMonsterValid(OtherActor.UnitId) and self.InRangeMonsters[OtherActor.Eid] then
    local PreHasMonster = self.HasMonsterInRange
    self:CheckMonInRange()
    if PreHasMonster and not self.HasMonsterInRange then
      self:OnMonsterInRangeChange()
    end
  end
end

function M:CheckMonsterValid(UnitId)
  for i, v in pairs(self.MonsterUnitIds) do
    if v == UnitId then
      return true
    end
  end
  return false
end

function M:CheckMonInRange()
  self.InRangeMonsters = {}
  self.HasMonsterInRange = false
  local Actors = self.preBox:GetOverlappingActors()
  if Actors:Length() > 0 then
    for i = 1, Actors:Length() do
      if Actors[i].IsPureMonster and Actors[i]:IsPureMonster() and self:CheckMonsterValid(Actors[i].UnitId) and not Actors[i]:IsDead() then
        DebugPrint("zwkkk 重新添加怪物", Actors[i]:GetName(), Actors[i].Eid)
        self.InRangeMonsters[Actors[i].Eid] = Actors[i]
        self.HasMonsterInRange = true
      end
    end
  end
end

function M:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == self.DownStateId then
    self:ChangeSmelt(true)
  end
end

function M:OnLeaveState(NowStateId, NextStateId)
  self.Overridden.OnLeaveState(self, NowStateId, NextStateId)
  if NowStateId == self.DownStateId then
    self:ChangeSmelt(false)
  end
end

function M:AddMonsterBuff()
  if not self.InRangeMonsters then
    return
  end
  local MonsterNum = 0
  for i, v in pairs(self.InRangeMonsters) do
    if v and not v:IsDead() then
      v:SetVector("CageCenterLoc", self.Center)
      Battle(self):AddBuffToTarget(self, v, self.BuffId, -1, nil, nil)
      MonsterNum = MonsterNum + 1
    end
  end
  if MonsterNum > 0 then
    self.Stage = 1 + self.StageSpecial
    if MonsterNum >= 4 then
      self.Stage = 3 + self.StageSpecial
    elseif MonsterNum > 1 then
      self.Stage = 2 + self.StageSpecial
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
      GameMode:GetDungeonComponent():TriggerGetCageStage(self.ManualItemId, self.Stage)
    end
  else
    self.Stage = 0
  end
end

function M:ChangeSmelt(IsEnterDown)
  EventManager:FireEvent(EventID.OnTempleCageEnterDown, self.ManualItemId, IsEnterDown)
end

function M:OnTempleSmeltChangeBlue(ManualId)
end

function M:KillMonsterInRange()
  local MonsterNum = 0
  local TotalGold = 0
  for i, v in pairs(self.InRangeMonsters) do
    if v and not v:IsDead() then
      local GameMode = UE4.UGameplayStatics.GetGameMode(self)
      if GameMode then
        GameMode:GetDungeonComponent():OnCageMonsterDead(v, self.ManualItemId)
      end
      MonsterNum = MonsterNum + 1
      local GoldNum = self.UnitToGoldNum:Find(v.UnitId)
      if GoldNum then
        TotalGold = TotalGold + GoldNum
      end
      DebugPrint("zwkkk 即将杀死怪物 ", v:GetName(), v.Eid)
      Battle(self):BattleOnDead(v.Eid, v.Eid, 0, EDeathReason.NoReason)
    end
  end
  if MonsterNum > 0 then
    self.Stage = 1 + self.StageSpecial
    if MonsterNum >= 4 then
      self.Stage = 3 + self.StageSpecial
    elseif MonsterNum > 1 then
      self.Stage = 2 + self.StageSpecial
    end
    TotalGold = TotalGold * self.Stage
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
      GameMode:GetDungeonComponent():TriggerSpawnCoin(self.ManualItemId, TotalGold)
    end
  else
    self.Stage = 0
  end
  DebugPrint("zwkkk 完全重置 Stage", self.Stage)
  self.InRangeMonsters = {}
end

function M:OnNoticeCageUp(ManualId)
  if ManualId ~= self.TransMechanId then
    return
  end
  self:ChangeState("Manual", 0, self.AutoUpStateId)
end

return M
