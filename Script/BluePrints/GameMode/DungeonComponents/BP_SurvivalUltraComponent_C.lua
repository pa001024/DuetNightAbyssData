local M = Class({
  "BluePrints.GameMode.DungeonComponents.BP_SurvivalMiniBaseComponent_C",
  "BluePrints.GameMode.DungeonComponents.BP_DungeonVoteComponent_C"
})

function M:InitSurvivalUltraComponent()
  self:InitSurvivalMiniBaseComponent()
  self:InitVoteComponent()
  self.SurvivalUltraInfo = DataMgr.SurvivalUltra[self.GameMode.DungeonId]
  if not self.SurvivalUltraInfo then
    GameState(self):ShowDungeonError("SurvivalUltraComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.MonsterSpawnIds = self.SurvivalUltraInfo.MonsterSpawnId
  self.StrongLoopSpawnIds = self.SurvivalUltraInfo.StrongLoopSpawnId
  self.LevelThresholds = self.SurvivalUltraInfo.LevelThreshold
  self.ExtraLevel = 0
end

function M:InitSurvivalUltraBaseInfo()
  local CurLevel = self.GameMode:GetGameModeLevel()
  self.GameMode:SetGameModeLevel(CurLevel + self.ExtraLevel)
end

function M:StartRound()
  M.Super.StartRound(self)
end

function M:SpawnMonsters()
  local CurRoundIndex = self:GetRoundIndex()
  if self.LastSpanwnIdsCache then
    local LastSpawnIdArray = self:TableToTArray(self.LastSpanwnIdsCache)
    self.GameMode:TriggerDestoryMonsterSpawn(LastSpawnIdArray)
    self.GameMode:DeleteMonsterSpawnDropRuleByArray(LastSpawnIdArray)
  end
  local NewSpawnIds = self:GetMonsterSpawnIdByRoundIndex(CurRoundIndex)
  local NesSpawnIdArray = self:TableToTArray(NewSpawnIds)
  self.GameMode:TriggerCreateMonsterSpawn(NesSpawnIdArray)
  self.GameMode:AddMonsterSpawnDropRuleByArray(NesSpawnIdArray)
  self.LastSpanwnIdsCache = NewSpawnIds
end

function M:GetRoundIndex()
  return self.GameMode.EMGameState.DungeonProgress
end

function M:GetWaveIndex()
  return self:GetRoundIndex()
end

function M:GetMonsterSpawnIdByRoundIndex(RoundIndex)
  local ResTable = {}
  if RoundIndex < 1 then
    return ResTable
  end
  local RealMonsterIndex = RoundIndex % #self.MonsterSpawnIds
  if 0 == RealMonsterIndex then
    RealMonsterIndex = #self.MonsterSpawnIds
  end
  for _, Id in pairs(self.MonsterSpawnIds[RealMonsterIndex]) do
    table.insert(ResTable, Id)
  end
  local CurStrongSpawnIds = self:GetCurStrongSpawnIds()
  if CurStrongSpawnIds then
    local RealStrongIndex = RoundIndex % #CurStrongSpawnIds
    if 0 == RealStrongIndex then
      RealStrongIndex = #CurStrongSpawnIds
    end
    table.insert(ResTable, CurStrongSpawnIds[RealStrongIndex])
  end
  return ResTable
end

function M:GetCurStrongSpawnIds()
  local CurLevel = self.GameMode:GetGameModeLevel()
  local Index = 1
  for _, LevelThreshold in pairs(self.LevelThresholds) do
    if LevelThreshold <= CurLevel then
      Index = Index + 1
    end
  end
  return self.StrongLoopSpawnIds[Index]
end

return M
