local RougeProDungeonGamePlayContext = DungeonClass.Class()

function RougeProDungeonGamePlayContext:InitCommonInfo()
  self.SeasonId = 1
  local SeasonInfo = DataMgr.RougeProSeason[self.SeasonId]
  self.CommonInfo = {
    RewardStageTime = SeasonInfo.RewardStageTime,
    RewardCollectTime = SeasonInfo.RewardCollectTime,
    RewardMonsterSpawnRule = SeasonInfo.RewardMonsterSpawnRule,
    AutoNextRoundTime = SeasonInfo.AutoNextRoundTime,
    MaxEventNum = SeasonInfo.MaxEventNum,
    RegionUnlockTime = SeasonInfo.RegionUnlockTime
  }
end

function RougeProDungeonGamePlayContext:InitRoundInfo()
  local SeasonInfo = DataMgr.RougeProSeason[self.SeasonId]
  self.CurRoundInfo = {
    RougeMainTime = SeasonInfo.RoundMainTime[self.Round],
    BossShowTime = SeasonInfo.BossShowTime[self.Round],
    IsLastRound = self.Round == #self.RoomList
  }
  local BossRandomRules = SeasonInfo.BossRandomRule[self.Round]
  local CurBossCreateRule = BossRandomRules[CommonUtils:RandomInt(1, #BossRandomRules)]
  self.CurRoundInfo.CurBossCreateRule = CurBossCreateRule
  print("@ljl 当前阶段", self.Round, "随机到的Boss特殊刷怪规则Id:", CurBossCreateRule)
end

function RougeProDungeonGamePlayContext:CreateRoundBoss()
  print("@ljl 轮次刷boss RuleId:", self.CurRoundInfo.CurBossCreateRule)
  self:TriggerRougeProMonsterSpecialSpawn(self.CurRoundInfo.CurBossCreateRule)
  self:NotifyGameModeDungeonEvent("OnRoundBossCreated")
end

function RougeProDungeonGamePlayContext:OnRoundBossDead()
  self:RemoveSyncTimer("RoundMain", true)
  print("RougeProDungeonGamePlayContext:OnRoundBossDead RoundIndex", self.Round)
  self:OnRoundEnd("BossDead")
  self:NotifyGameModeDungeonEvent("OnRoundBossDead")
end

function RougeProDungeonGamePlayContext:OnRoundMainTimerEnd()
  print("RougeProDungeonGamePlayContext:OnRoundMainTimerEnd RoundIndex", self.Round)
  self:OnRoundEnd("MainTimerEnd")
end

function RougeProDungeonGamePlayContext:OnChangeRound(Duration)
  self:AddSyncTimer("RoundMain", self.CurRoundInfo.RougeMainTime, nil, function()
    self:OnRoundMainTimerEnd()
  end)
  self:AddTimer(self.CurRoundInfo.BossShowTime, function()
    self:CreateRoundBoss()
  end, "BossCreate")
end

function RougeProDungeonGamePlayContext:OnRoundFinish()
  self:RemoveSyncTimer("RoundMain", true)
  self:RemoveTimer("BossCreate")
  self:ForEachPlayer(function(Player)
    if Player.OnRoundFinish then
      Player:OnRoundFinish()
    end
  end)
end

function RougeProDungeonGamePlayContext:GenerateRandomRoomList(MaxRound)
  local list = {}
  local WeightList = {}
  local TotalWeight = 0
  for RoomId, tabRougePro_Room in pairs(DataMgr.RougePro_Room) do
    if not CommonUtils.HasValue(list, RoomId) then
      TotalWeight = TotalWeight + tabRougePro_Room.RoomWeight
      WeightList[RoomId] = tabRougePro_Room.RoomWeight
    end
  end
  
  local function RandomOnce()
    local RandomWeight = math.random(0, TotalWeight)
    for RoomId, RoomWeight in pairs(WeightList) do
      RandomWeight = RandomWeight - RoomWeight
      if RandomWeight <= 0 then
        table.insert(list, RoomId)
        WeightList[RoomId] = nil
        TotalWeight = TotalWeight - RoomWeight
        break
      end
    end
  end
  
  for i = 1, MaxRound do
    RandomOnce()
  end
  return list
end

return RougeProDungeonGamePlayContext
