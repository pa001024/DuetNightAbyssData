local M = Class({
  "BluePrints.Common.TimerMgr"
})
local OPENING_WAIT_TIME = 5

function M:InitHardBossDgComponent()
  self.GameMode = self:GetOwner()
  local HardBossInfo = DataMgr.HardBossDg[self.GameMode.DungeonId]
  if not HardBossInfo then
    GameState(self):ShowDungeonError("HardBossDgComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  local HardBossMainInfo = DataMgr.HardBossMain[HardBossInfo.HardBossId]
  if not HardBossMainInfo then
    GameState(self):ShowDungeonError("HardBossDgComponent:读取梦魇配置失败! 读入配置Id：" .. tostring(HardBossInfo.HardBossId), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.BossUnitId = HardBossInfo.BossUnitId
  self.BossStaticCreatorId = HardBossInfo.BossStaticId
  self.AirWallStaticCreatorId = HardBossInfo.AirWallStaticId
  DebugPrint("HardBossDgComponent: InitHardBossDgComponent")
end

function M:InitHardBossDgBaseInfo()
  self:SpawnMainActors()
  self:PlayOpeningSequence()
end

function M:SpawnMainActors()
  local BossCreator = self.GameMode.EMGameState.StaticCreatorMap:Find(self.BossStaticCreatorId)
  if BossCreator then
    local Index = self.GameMode:GetTargetPlayerNum()
    Index = math.clamp(Index, 1, #self.BossUnitId)
    BossCreator.UnitId = self.BossUnitId[Index]
    self.NowBossUnitId = self.BossUnitId[Index]
  end
  local CreatorIds = TArray(0)
  CreatorIds:Add(self.BossStaticCreatorId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIds, "HardBossMain")
end

function M:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType)
  if "HardBossMain" == EventName and UnitId == self.NowBossUnitId then
    local Boss = Battle(self):GetEntity(Eid)
    if IsValid(Boss) then
      Boss:StopBT("HardBossOpening")
      self.BossEid = Eid
    end
  end
end

function M:PlayOpeningSequence()
  self.ClientReadyNum = 0
  self.IsWaitingClientOpening = true
  local Players = self.GameMode:GetAllPlayer()
  for _, Player in pairs(Players) do
    DebugPrint("HardBossDgComponent: PlayOpeningSequence", Player.Eid)
    self.GameMode:SetPlayerInvincible(Player, true)
    self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
  end
  self.GameMode:AddDungeonEvent("OpeningSequence")
  self:AddTimer(Const.BossOpeningEnsureTime, function()
    GameState(self):ShowDungeonError("HardBossDgComponent:开场动画超时触发保底！", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Process)
    self:OnAllClientOpeningReady()
  end, false, 0, "EnsureClientOpening")
end

function M:OnPlayerEnter(Eid)
  if not self.IsWaitingClientOpening then
    return
  end
  DebugPrint("HardBossDgComponent: OnPlayerEnter", Eid)
  local Player = Battle(self):GetEntity(Eid)
  self.GameMode:SetPlayerInvincible(Player, true)
  self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
end

function M:ClientPlayOpeningFinish(PlayerEid)
  self.ClientReadyNum = self.ClientReadyNum + 1
  local TotalPlayerNum = self.GameMode:GetTargetPlayerNum()
  DebugPrint("HardBossDgComponent: ClientPlaySequenceFinish PlayerEid:", PlayerEid, " ClientReadyNum:", self.ClientReadyNum, " TotalPlayerNum:", TotalPlayerNum, "IsWaitingClientOpening", self.IsWaitingClientOpening)
  if 1 == self.ClientReadyNum then
    self:AddTimer(OPENING_WAIT_TIME, function()
      self:OnAllClientOpeningReady()
    end, false, 0, "WaitingClientOpening", true)
  end
  if TotalPlayerNum <= self.ClientReadyNum then
    self:OnAllClientOpeningReady()
  end
end

function M:OnAllClientOpeningReady()
  if not self.IsWaitingClientOpening then
    return
  end
  self.IsWaitingClientOpening = false
  self:RemoveTimer("WaitingClientOpening")
  DebugPrint("HardBossDgComponent: OnAllClientOpeningReady")
  self.GameMode:RemoveDungeonEvent("OpeningSequence")
  local AllPlayers = self.GameMode:GetAllPlayer()
  for _, Player in pairs(AllPlayers) do
    DebugPrint("HardBossDgComponent: OnAllClientOpeningReady", Player.Eid)
    self.GameMode:SetPlayerInvincible(Player, false)
    self.GameMode:PausePhantomBTByPlayer(Player, false, "HardBossOpening")
  end
  local Boss = Battle(self):GetEntity(self.BossEid)
  if IsValid(Boss) then
    Boss:RestartBT()
  end
  local CreatorIds = TArray(0)
  CreatorIds:Add(self.AirWallStaticCreatorId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIds)
  self.GameMode:TriggerGameModeEvent("Event_OnAllClientOpeningReady")
end

return M
