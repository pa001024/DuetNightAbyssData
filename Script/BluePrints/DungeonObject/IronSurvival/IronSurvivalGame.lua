local IronSurvivalGame = DungeonClass.Class()

function IronSurvivalGame:BeginPlay()
  print("ljl@ IronSurvivalGame BeginPlay", self.DungeonId)
  self.IsRoundBegin = false
  self.RoundIndex = 0
  self.MaxSurvivalMiniValue = DataMgr.GlobalConstant.SurvivalValue.ConstantValue
  self.GameModeLevel = 1
  self.DungeonFixLevel = DataMgr.Dungeon[self.DungeonId] and DataMgr.Dungeon[self.DungeonId].DungeonFixLevel or 0
  local IronSurvivalInfo = DataMgr.IronSurvival[self.DungeonId]
  if not IronSurvivalInfo then
    return
  end
  self.ISMonsterSpawnIds = IronSurvivalInfo.MonsterSpawnId
  self.ISStrongLoopSpawnIds = CommonUtils.DeepCopy(IronSurvivalInfo.StrongLoopSpawnId)
  self.ISStrongKillCounts = IronSurvivalInfo.StrongKillCount
  self.ISLevelThresholds = IronSurvivalInfo.LevelThreshold
  self.MiniGameCreatorId = IronSurvivalInfo.MiniGameCreatorId
  self.CurKillCount = 0
  self.CurKillTargetNum = self.ISStrongKillCounts[1] or 1
  self.CurStrongSpawnIndex = 1
end

function IronSurvivalGame:OnNotifyServerDungeonEvent_OnInit()
  self:Log("IronSurvival OnInit")
  self:InnerSetGameModeLevel(self.GameModeLevel)
  if self.IronTicketId then
    self:NotifyGameModeDungeonEvent("SetIronTicketId", self.IronTicketId)
  end
  self:ActiveStaticCreator({
    self.MiniGameCreatorId
  })
end

function IronSurvivalGame:InitExtra(Info)
  if not Info or not Info.PlayerInfo then
    return
  end
  local GameModeLevel = Info.PlayerInfo.IronSurvivalGameModeLevel
  if nil == GameModeLevel then
    return
  end
  self:Log("IronSurvival InitExtra GameModeLevel")
  self.GameModeLevel = GameModeLevel
  self.TicketLeaderEid = Info.PlayerInfo.TicketLeaderEid
  print("TicketLeaderEid", self.TicketLeaderEid)
  self:NotifyGameModeDungeonEvent("SetTicketLeaderEid", self.TicketLeaderEid)
  self.IronTicketId = Info.PlayerInfo.TicketConfId
  print("InitExtra IronTicketId", self.IronTicketId)
  self:NotifyGameModeDungeonEvent("SetIronTicketId", self.IronTicketId)
end

function IronSurvivalGame:OnNotifyServerDungeonEvent_SetGameModeLevel(GameModeLevel)
  if nil == GameModeLevel then
    return
  end
  self.GameModeLevel = GameModeLevel
  self:Log("ljl@ IronSurvival SetGameModeLevel", GameModeLevel)
end

function IronSurvivalGame:OnNotifyServerDungeonEvent_SetIronTicketId(IronTicketId)
  if nil == IronTicketId then
    return
  end
  self.IronTicketId = IronTicketId
  self:Log("ljl@ IronSurvival SetIronTicketId", IronTicketId)
end

function IronSurvivalGame:CustomFinishInfo()
  return {
    GameModeLevel = self.GameModeLevel
  }
end

function IronSurvivalGame:OnNotifyServerDungeonEvent_ServerStartRound()
  if self.IsRoundBegin then
    return
  end
  self.IsRoundBegin = true
  self.RoundIndex = self.RoundIndex + 1
  self:FixGameModeLevelEachRound()
  print("IronSurvivalGame:RoundStart, Current GameModeLevel", self.GameModeLevel, "RoundIndex", self.RoundIndex)
  self:UpdateKillTargetNumEachRound()
  self:SpawnMonsters()
end

function IronSurvivalGame:UpdateKillTargetNumEachRound()
  local Index = 1
  for _, LevelThreshold in pairs(self.ISLevelThresholds) do
    if LevelThreshold <= self.GameModeLevel then
      Index = Index + 1
    end
  end
  self.CurKillTargetNum = self.ISStrongKillCounts[Index] or self.ISStrongKillCounts[1]
end

function IronSurvivalGame:FixGameModeLevelEachRound()
  if 1 == self.RoundIndex then
    return
  end
  self:InnerSetGameModeLevel(self.GameModeLevel + self.DungeonFixLevel)
end

function IronSurvivalGame:InnerSetGameModeLevel(NewLevel)
  self.GameModeLevel = NewLevel
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnSyncGameModeLevel", self.GameModeLevel)
end

function IronSurvivalGame:SpawnMonsters()
  if self.RoundIndex < 1 then
    return
  end
  local ThisRoundSpawnIds = {}
  local RealMonsterIndex = self.RoundIndex % #self.ISMonsterSpawnIds
  if 0 == RealMonsterIndex then
    RealMonsterIndex = #self.ISMonsterSpawnIds
  end
  for _, Id in pairs(self.ISMonsterSpawnIds[RealMonsterIndex]) do
    table.insert(ThisRoundSpawnIds, Id)
  end
  self:ServerTriggerCreateMonsterSpawn(ThisRoundSpawnIds, false)
  self:AddMonsterSpawnDropRuleByArray(ThisRoundSpawnIds)
  self.LastSpanwnIdsCache = ThisRoundSpawnIds
end

function IronSurvivalGame:GetCurStrongSpawnIds()
  local Index = 1
  for _, LevelThreshold in pairs(self.ISLevelThresholds) do
    if LevelThreshold <= self.GameModeLevel then
      Index = Index + 1
    end
  end
  return self.ISStrongLoopSpawnIds[Index]
end

function IronSurvivalGame:StopSpawnMonsters()
  if not self.LastSpanwnIdsCache then
    return
  end
  self:ServerTriggerDestroyMonsterSpawn(self.LastSpanwnIdsCache)
  self:DeleteMonsterSpawnDropRuleByArray(self.LastSpanwnIdsCache)
end

function IronSurvivalGame:TriggerRoundEnd()
  if not self.IsRoundBegin then
    return
  end
  self.IsRoundBegin = false
  print("IronSurvivalGame:TriggerRoundEnd")
  self:StopSpawnMonsters()
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "GameModeRoundEnd")
end

function IronSurvivalGame:OnNotifyServerDungeonEvent_AddSurvivalValueGameMode(AddValue)
  self:ServerUpdateSurvivalMiniValue(AddValue)
end

function IronSurvivalGame:ServerUpdateSurvivalMiniValue(SurvivalMiniValue)
  if not SurvivalMiniValue then
    return
  end
  print("IronSurvivalGame:ServerUpdateSurvivalMiniValue", SurvivalMiniValue)
  local CurSurvivalMiniValue = (self.CurSurvivalMiniValue or 0) + SurvivalMiniValue
  CurSurvivalMiniValue = math.min(CurSurvivalMiniValue, self.MaxSurvivalMiniValue)
  CurSurvivalMiniValue = math.max(CurSurvivalMiniValue, 0)
  self:SetCurSurvivalMiniValue(CurSurvivalMiniValue)
  if self.CurSurvivalMiniValue == self.MaxSurvivalMiniValue then
    self:SetCurSurvivalMiniValue(0)
    self:TriggerRoundEnd()
  end
end

function IronSurvivalGame:SetCurSurvivalMiniValue(SurvivalMiniValue)
  if not SurvivalMiniValue then
    return
  end
  self.CurSurvivalMiniValue = SurvivalMiniValue
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnServerUpdateSurvivalMiniValue", self.CurSurvivalMiniValue)
end

function IronSurvivalGame:CheckPlayerAllowedFinish(IsWin, AvatarEid, GameEndReason)
  return true
end

function IronSurvivalGame:DungeonMonsterDead(MonsterInfo)
  self.CurKillCount = (self.CurKillCount or 0) + 1
  print("IronSurvivalGame:DungeonMonsterDead, CurKillCount", self.CurKillCount, "CurKillTargetNum", self.CurKillTargetNum)
  if self.CurKillCount >= self.CurKillTargetNum then
    self.CurKillCount = 0
    local CurStrongSpawnIds = self:GetCurStrongSpawnIds()
    if CurStrongSpawnIds and #CurStrongSpawnIds > 0 then
      local Index = (self.CurStrongSpawnIndex - 1) % #CurStrongSpawnIds + 1
      local SpawnId = CurStrongSpawnIds[Index]
      print("IronSurvivalGame: StrongSpawnId", SpawnId)
      self:ServerTriggerCreateMonsterSpawn({SpawnId}, false)
      self:AddMonsterSpawnDropRuleByArray({SpawnId})
      self.CurStrongSpawnIndex = self.CurStrongSpawnIndex + 1
    end
  end
end

function IronSurvivalGame:FillCustomGameInfo(tbl)
  table.insert(tbl, "GameModeLevel: " .. tostring(self.GameModeLevel) .. "\n")
  table.insert(tbl, "RoundIndex: " .. tostring(self.RoundIndex) .. "\n")
end

DungeonClass.AssembleComponents(IronSurvivalGame)
return IronSurvivalGame
