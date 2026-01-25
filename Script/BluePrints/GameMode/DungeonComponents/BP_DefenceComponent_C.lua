require("UnLua")
local BP_DefenceComponent_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C"
})

function BP_DefenceComponent_C:InitDefenceComponent()
  self.GameMode = self:GetOwner()
  self:InitVoteComponent()
  self.GameMode.EMGameState:SetDefenceWaveInterval(DataMgr.GlobalConstant.DefenceWaveInterval.ConstantValue or 5)
  self.DefenceInfo = self:GetDataMgrInfo()
  if not self.DefenceInfo then
    GameState(self):ShowDungeonError("DefenceComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.MonsterTotalBaseNum = self.DefenceInfo.MonsterTotalBaseNum or 15
  self.MonsterTotalNum = self.MonsterTotalBaseNum
  self.MonsterSpawnIds = self.DefenceInfo.MonsterSpawnId
  self.bMissionSwitched = false
  self.bMonRuleReseted = false
  self.GameMode:InitCreateEmergencyMonsterProb("Butcher", self, self.DefenceInfo)
  local WavesPerStage = self.DefenceInfo.WavesPerStage or 3
  self.GameMode.EMGameState:SetDefenceWavesPerStage(WavesPerStage)
  self.EnsureGuideTime = self.DefenceInfo.EnsureGuideTime or -1
end

function BP_DefenceComponent_C:GetDataMgrInfo()
  return DataMgr.Defence[self.GameMode.DungeonId]
end

function BP_DefenceComponent_C:RecordDungeonRoundData()
  local RoundData = {
    DungeonProgress = self.GameMode.EMGameState.DungeonProgress,
    GameModeLevel = self.GameMode:GetGameModeLevel(),
    DefenceWave = self.GameMode.EMGameState.DefenceWave
  }
  PrintTable(RoundData, 2)
  return RoundData
end

function BP_DefenceComponent_C:RecoverDungeonRoundData(Data)
  PrintTable(Data, 2)
  self.GameMode.EMGameState:SetDungeonProgress(Data.DungeonProgress)
  self.GameMode.EMGameState:SetGameModeLevel(Data.GameModeLevel)
  self.GameMode.EMGameState:SetDefenceWave(Data.DefenceWave)
end

function BP_DefenceComponent_C:WaveStart()
  self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.DefenceInfo)
  self.MonsterTotalNum = self.MonsterTotalBaseNum
  self.GameMode:TriggerCreateMonsterSpawn(self:GetMonsterSpawnId())
  self.bMonRuleReseted = false
  self:InitEnsureGuideTimerEachWave()
end

function BP_DefenceComponent_C:GetMonsterSpawnId()
  local RealIndex = self:GetWaveIndex() % #self.MonsterSpawnIds
  if 0 == RealIndex then
    RealIndex = #self.MonsterSpawnIds
  end
  return self:TableToTArray(self.MonsterSpawnIds[RealIndex])
end

function BP_DefenceComponent_C:TriggerMonsterDead(Monster)
  if Monster.CreatorType and Monster.CreatorId and Monster:GetCamp() == ECampName.Monster then
    self.MonsterTotalNum = self.MonsterTotalNum - 1
    if self.MonsterTotalNum <= 0 then
      if self:GetMonsterNum() <= 6 and self:GetMonsterNum() > 0 then
        for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
          if IsValid(Monster) and not Monster:IsDead() and "Monster" == Monster.UnitType and self.GameMode:CheckCanGuide(Monster.UnitId, Monster.UnitType) then
            self.GameMode.EMGameState:AddGuideEid(Monster.Eid)
          end
        end
        if not self.bMissionSwitched then
          self.bMissionSwitched = true
          self.GameMode:TriggerGameModeEvent("OnShowRemainMonster")
        end
      elseif 0 == self:GetMonsterNum() then
        self.bMissionSwitched = false
      end
      if not self.bMonRuleReseted then
        self.bMonRuleReseted = true
        self.GameMode:DestroyAllMonsterSpawn()
        self:AddTimer(3.5, function()
          self:AddTimer(2, self.MonsterNumCheck, true, 0, "MonsterNumCheck")
        end, false, 0, "MonRuleReset")
      end
    end
  end
end

function BP_DefenceComponent_C:MonsterNumCheck()
  DebugPrint("DefenceComponent TriggerMonsterDead, GetMonsterNum:", self:GetMonsterNum(), "MonsterTotalNum:", self.MonsterTotalNum)
  if 0 == self:GetMonsterNum() and self.MonsterTotalNum <= 0 then
    self:ClearEnsureGuideTimer()
    self.GameMode:PostCustomEvent("DefenceWaveEnd")
    self:RemoveTimer("MonsterNumCheck")
    self.GameMode:TriggerGameModeEvent("OnShowDefenceTarget")
  end
end

function BP_DefenceComponent_C:OnDefenceCoreActive()
  self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

function BP_DefenceComponent_C:GetMonsterNum()
  return self.GameMode.EMGameState.MonsterNum
end

function BP_DefenceComponent_C:GetWaveIndex()
  return self.GameMode.EMGameState.DefenceWave
end

function BP_DefenceComponent_C:AddWaveIndex(Value)
  self.GameMode.EMGameState:SetDefenceWave(self.GameMode.EMGameState.DefenceWave + Value)
end

function BP_DefenceComponent_C:SetWaveIndex(Value)
  self.GameMode.EMGameState:SetDefenceWave(Value)
end

function BP_DefenceComponent_C:TableToTArray(table)
  local ResTArray = TArray(0)
  if table then
    for _, Item in ipairs(table) do
      ResTArray:Add(Item)
    end
  end
  return ResTArray
end

function BP_DefenceComponent_C:InitEnsureGuideTimerEachWave()
  if self.EnsureGuideTime < 0 then
    return
  end
  self:AddTimer(self.EnsureGuideTime, function()
    self:DoEnsureGuide()
    self:AddTimer(5, self.DoEnsureGuide, true, 0, "DoEnsureGuide")
  end, false, 0, "EnsureGuideDelayTimer")
end

function BP_DefenceComponent_C:DoEnsureGuide()
  for _, Monster in pairs(self.GameMode.EMGameState.MonsterMap) do
    if not IsValid(Monster) then
    elseif Monster:IsDead() then
    elseif Monster.UnitType ~= "Monster" then
    elseif not self.GameMode:CheckCanGuide(Monster.UnitId, Monster.UnitType) then
    else
      self.GameMode.EMGameState:AddGuideEid(Monster.Eid)
    end
  end
end

function BP_DefenceComponent_C:ClearEnsureGuideTimer()
  self:RemoveTimer("EnsureGuideDelayTimer")
  self:RemoveTimer("DoEnsureGuide")
end

return BP_DefenceComponent_C
