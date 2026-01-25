require("UnLua")
local BP_SurvivalProComponent_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.GameMode.DungeonComponents.BP_SurvivalComponent_C"
})

function BP_SurvivalProComponent_C:InitSurvivalProComponent()
  self.GameMode = self:GetOwner()
  self.GameState = self.GameMode.EMGameState
  self:InitVoteComponent()
  self.SurvivalVitaminStop = false
  self.MinExtraFixVitamin = DataMgr.GlobalConstant.MinExtraFixVitamin.ConstantValue
  self.MaxSurvivalValue = DataMgr.GlobalConstant.SurvivalValue.ConstantValue
  self.SurvivalProInfo = DataMgr.SurvivalPro[self.GameMode.DungeonId]
  if not self.SurvivalProInfo then
    GameState(self):ShowDungeonError("SurvivalProComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.RoundTime = self.SurvivalProInfo.RoundTime or 180.0
  self.MonsterFirstSpawnId = self.SurvivalProInfo.MonsterFirstSpawnId or {501}
  self.LoopRule = self.SurvivalProInfo.LoopRule or {1}
  self.MonsterSpawnIds = self.SurvivalProInfo.MonsterSpawnId or {501}
  self.MonsterSpawnDelay = self.SurvivalProInfo.MonsterSpawnDelay or 0.0
  self.SpLoopRule = self.SurvivalProInfo.SpLoopRule or {1}
  self.SpMonsterSpawnRules = self.SurvivalProInfo.SpMonster
  self.MonsterSpawnIndex = 0
  self.bIsFirstRound = true
  self.SpMonsterInfos = {}
  self.GameMode:InitCreateEmergencyMonsterProb("Butcher", self, self.SurvivalProInfo)
end

function BP_SurvivalProComponent_C:InitSurvivalProBaseInfo()
end

function BP_SurvivalProComponent_C:RecordDungeonRoundData()
  local RoundData = {
    DungeonProgress = self.GameMode.EMGameState.DungeonProgress,
    GameModeLevel = self.GameMode:GetGameModeLevel(),
    SurvivalValue = self.GameMode.EMGameState.SurvivalValue,
    SurvivalTime = self.GameMode.EMGameState.CumulativeSurvivalTime,
    MonsterSpawnIndex = self.MonsterSpawnIndex,
    bIsFirstRound = self.bIsFirstRound
  }
  PrintTable(RoundData, 3)
  return RoundData
end

function BP_SurvivalProComponent_C:RecoverDungeonRoundData(Data)
  PrintTable(Data, 3)
  self.GameMode.EMGameState:SetDungeonProgress(Data.DungeonProgress)
  self.GameMode.EMGameState:SetGameModeLevel(Data.GameModeLevel)
  self.TmpSurvivalValue = Data.SurvivalValue
  self.TmpSurvivalTime = Data.SurvivalTime
  self.MonsterSpawnIndex = Data.MonsterSpawnIndex
  self.bIsFirstRound = Data.bIsFirstRound
end

function BP_SurvivalProComponent_C:OnMonsterDeadOut()
  if not IsStandAlone(self) then
    return
  end
  local MaxMonsterDeadOut = DataMgr.GlobalConstant.MaxMonsterDeadOut.ConstantValue
  self.MonsterDeadOut = self.MonsterDeadOut + 1
  if MaxMonsterDeadOut <= self.MonsterDeadOut and self.HasInEnergySurvival then
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    UE4.UPlayTalkAsyncAction.PlayTalk(GameInstance, 600306, nil)
    self.MonsterDeadOut = 0
  end
end

function BP_SurvivalProComponent_C:TryToPostSurpossedLeave()
  local SupplyArray = UE4.UGameplayStatics.GetGameState(self).MechanismMap:FindRef("Supply").Array
  for i = 1, SupplyArray:Length() do
    if IsValid(SupplyArray[i]) and 0 ~= SupplyArray[i].NowEnergy then
      return
    end
  end
  if not self.HasPostSurpossedLeave and self.Success then
    self.GameMode:PostCustomEvent("SurvivalProSurpossedLeave", Const.GameModeEventServerClient)
    self.HasPostSurpossedLeave = true
  end
end

function BP_SurvivalProComponent_C:TryToPostBeginTutorial()
  if not self.HasPostBeginTutorial then
    self.GameMode:PostCustomEvent("SurvivalProBeginTutorial", Const.GameModeEventServerClient)
    self.HasPostBeginTutorial = true
  end
end

function BP_SurvivalProComponent_C:TryToPostFinishTutorial()
  if not self.HasPostFinishTutorial and self.HasPostBeginTutorial then
    self.GameMode:PostCustomEvent("SurvivalProFinishTutorial", Const.GameModeEventServerClient)
    self.HasPostFinishTutorial = true
  end
end

function BP_SurvivalProComponent_C:RoundsStart()
  DebugPrint("SurvivalProComponent: RoundsStart", self.GameMode.EMGameState.DungeonProgress)
  if 2 == self.GameMode.EMGameState.DungeonProgress and self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
    self.GameMode:TriggerSpawnPet()
  end
  self:AddTimer(self.RoundTime, self.RoundsEnd, false, 0, "RoundsTimer")
end

function BP_SurvivalProComponent_C:RoundsEnd()
  if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
    return
  end
  DebugPrint("SurvivalProComponent: RoundsEnd", self.GameMode.EMGameState.DungeonProgress)
  if self.bIsFirstRound then
    self.bIsFirstRound = false
    self.GameMode:TriggerDestoryMonsterSpawn(self:TableToTArray(self.MonsterFirstSpawnId))
    self.GameMode:TriggerGameModeEvent("OnFirstRoundEnd")
  end
  self.GameMode:TriggerGameModeEvent("OnEachRoundEnd")
end

function BP_SurvivalProComponent_C:TriggerMonsterSpawn()
  if self.bIsFirstRound then
    return
  end
  if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
    return
  end
  self:TriggerSpecialMonsterSpawn()
  self:ClearPreviousMonsterSpawnRule()
  self:UpdateNewMonsterSpawnRule()
  self:RoundsStart()
end

function BP_SurvivalProComponent_C:ClearPreviousMonsterSpawnRule()
  if self.MonsterSpawnIndex > 0 then
    self.GameMode:TriggerDestoryMonsterSpawn(self:GetMonsterSpawnIdPro())
  end
end

function BP_SurvivalProComponent_C:UpdateNewMonsterSpawnRule()
  self.MonsterSpawnIndex = self.MonsterSpawnIndex + 1
  self.GameMode:TriggerCreateMonsterSpawn(self:GetMonsterSpawnIdPro())
  self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.SurvivalProInfo)
end

function BP_SurvivalProComponent_C:GetMonsterSpawnIdPro()
  local RealIndex = self.MonsterSpawnIndex % #self.LoopRule
  if 0 == RealIndex then
    RealIndex = #self.LoopRule
  end
  return self:TableToTArray(self.MonsterSpawnIds[self.LoopRule[RealIndex]])
end

function BP_SurvivalProComponent_C:TriggerMonsterFirstSpawn()
  if self.bIsFirstRound then
    self.GameMode:TriggerCreateMonsterSpawn(self:TableToTArray(self.MonsterFirstSpawnId))
  end
end

function BP_SurvivalProComponent_C:TriggerSpecialMonsterSpawn()
  local SpMonsterId = self:GetSpMonsterId()
  local SpMonsterSpawnRule = self.SpMonsterSpawnRules[SpMonsterId]
  DebugPrint("ljl_TriggerSpecialMonsterSpawn", SpMonsterId, self.MonsterSpawnIndex)
  if SpMonsterSpawnRule then
    self:AddTimer(SpMonsterSpawnRule.SpMonsterSpawnTime, function()
      if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
        return
      end
      self.GameMode:TriggerGameModeEvent("OnSpMonsterTimerEnd", SpMonsterId)
    end)
  else
    GameState(self):ShowDungeonError("SurvivalProComponent:SurvivalPro表内没有对应特殊怪信息，Id：" .. SpMonsterId .. ", " .. self.MonsterSpawnIndex, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
  end
  self.GameMode:CreateEmergencyMonsterEachWave("Butcher", self, self.SurvivalProInfo)
end

function BP_SurvivalProComponent_C:GetSpMonsterId()
  local SpMonsterIndex = self.MonsterSpawnIndex // 2 + 1
  local RealIndex = SpMonsterIndex % #self.SpLoopRule
  if 0 == RealIndex then
    RealIndex = #self.SpLoopRule
  end
  return RealIndex
end

function BP_SurvivalProComponent_C:RealSpMonsterSpawn(SpMonsterId)
  DebugPrint("ljl_RealSpMonsterSpawn", SpMonsterId)
  local SpMonsterSpawnRule = self.SpMonsterSpawnRules[SpMonsterId]
  if SpMonsterSpawnRule then
    local SpMonsterSpawnId = SpMonsterSpawnRule.SpMonsterSpawnId
    self.GameMode:TriggerCreateMonsterSpawn(self:TableToTArray(SpMonsterSpawnId))
  else
    GameState(self):ShowDungeonError("SurvivalProComponent:特殊怪Id错误，检查蓝图！Id：" .. SpMonsterId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
  end
  self:ClearPreviousMonsterSpawnRule()
  self:AddTimer(self.MonsterSpawnDelay, self.UpdateNewMonsterSpawnRule, false, 0, "MonsterSpawnDelay")
end

function BP_SurvivalProComponent_C:GetWaveIndex()
  return self.MonsterSpawnIndex
end

return BP_SurvivalProComponent_C
