local M = Class({
  "BluePrints.Common.TimerMgr"
})
local OPENING_WAIT_TIME = 5
local PlayerGameState = {
  NotReady = 1,
  Ready = 2,
  Disconnect = 3,
  Exit = 4
}

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
  self.PreparingAirWallStaticId = HardBossInfo.PreparingAirWallStaticId
  self.CustomBossStaticCreatorIds = HardBossInfo.CustomBossStaticId or {}
  self.CustomBossUnitIds = HardBossInfo.CustomBossUnitId or {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {}
  }
  self.NowBossUnitIds = {}
  self.BossEids = {}
  self:RegisterGameModeEvents()
  DebugPrint("HardBossDgComponent: InitHardBossDgComponent")
end

function M:RegisterGameModeEvents()
  self.GameMode.EMGameState:RegisterGameModeEvent("OnExit", self, self.OnPlayerExitGame)
  self.GameMode.EMGameState:RegisterGameModeEvent("OnDisconnect", self, self.OnPlayerDisconnectGame)
  EventManager:AddEvent(EventID.OnAvatarLogout, self, self.OnPlayerAvatarLogout)
end

function M:InitHardBossDgBaseInfo()
  GWorld:DSBLog("Info", "HardBossDgComponent: InitHardBossDgBaseInfo", "GameMode")
  self:SpawnMainActors()
  self:PlayOpeningSequence()
end

function M:SpawnMainActors()
  local CreatorIds = TArray(0)
  for GroupIndex, CreatorId in pairs(self.BossStaticCreatorId) do
    local BossCreator = self.GameMode.EMGameState.StaticCreatorMap:Find(CreatorId)
    local Index = self.GameMode:GetTargetPlayerNum()
    Index = math.clamp(Index, 1, #self.BossUnitId)
    local BossUnitId = self.BossUnitId[Index][GroupIndex]
    if BossCreator and BossUnitId then
      CreatorIds:Add(CreatorId)
      BossCreator.UnitId = BossUnitId
      self.NowBossUnitIds[BossUnitId] = true
    end
  end
  CreatorIds:Add(self.PreparingAirWallStaticId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIds, "HardBossMain")
end

function M:ActiveCustomBossCreator(Index)
  local CreatorId = self.CustomBossStaticCreatorIds[Index]
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  PlayerNum = math.clamp(PlayerNum, 1, #self.CustomBossUnitIds)
  local UnitId = self.CustomBossUnitIds[PlayerNum][Index]
  if not CreatorId or not UnitId then
    return
  end
  local BossCreator = self.GameMode.EMGameState.StaticCreatorMap:Find(CreatorId)
  if not IsValid(BossCreator) then
    return
  end
  local CreatorIds = TArray(0)
  CreatorIds:Add(CreatorId)
  BossCreator.UnitId = UnitId
  self.GameMode:TriggerActiveStaticCreator(CreatorIds, "HardBossCustomBoss")
end

function M:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
  if "HardBossMain" == EventName and self.NowBossUnitIds[UnitId] then
    local Boss = Battle(self):GetEntity(Eid)
    if IsValid(Boss) then
      Boss:StopBT("HardBossOpening")
      Battle(self):AddBuffToTarget(Boss, Boss, Const.BossInvincibleBuffId, -1)
      table.insert(self.BossEids, Eid)
    end
  end
end

function M:PlayOpeningSequence()
  self.IsWaitingClientOpening = true
  self.ClientReadyMap = {}
  local Players = self.GameMode:GetAllPlayer()
  for _, Player in pairs(Players) do
    DebugPrint("HardBossDgComponent: PlayOpeningSequence", Player.Eid)
    GWorld:DSBLog("Info", "HardBossDgComponent: PlayOpeningSequence PlayerEid: " .. Player.Eid, "GameMode")
    self:MutePlayerAction(Player, true)
    self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
  end
  self.GameMode:AddDungeonEvent("OpeningSequence")
end

function M:OnPlayerEnter(Eid)
  if not self.IsWaitingClientOpening then
    return
  end
  DebugPrint("HardBossDgComponent: OnPlayerEnter", Eid)
  GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerEnter PlayerEid: " .. Eid, "GameMode")
  local Player = Battle(self):GetEntity(Eid)
  self:MutePlayerAction(Player, true)
  self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
end

function M:ClientPlayOpeningFinish(PlayerEid)
  local PlayerCharacter = Battle(self):GetEntity(PlayerEid)
  if not PlayerCharacter then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  local AvatarEidStr = PlayerCharacter:GetOwner().AvatarEidStr
  DebugPrint("HardBossDgComponent: ClientPlaySequenceFinish PlayerEid:", PlayerEid, " PlayerNum:", PlayerNum, "AvatarEidStr", AvatarEidStr)
  GWorld:DSBLog("Info", "HardBossDgComponent: ClientPlaySequenceFinish PlayerEid: " .. PlayerEid .. " PlayerNum: " .. PlayerNum .. " AvatarEidStr: " .. AvatarEidStr, "GameMode")
  self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Ready
  if self:IsAllActiveClientReady() then
    self:OnAllClientOpeningReady()
  end
end

function M:IsAllActiveClientReady()
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  local ActiveReadyCount = 0
  for AvatarEidStr, State in pairs(self.ClientReadyMap) do
    if State == PlayerGameState.Ready then
      ActiveReadyCount = ActiveReadyCount + 1
    end
  end
  return PlayerNum <= ActiveReadyCount
end

function M:OnAllClientOpeningReady()
  if not self.IsWaitingClientOpening then
    return
  end
  self.IsWaitingClientOpening = false
  DebugPrint("HardBossDgComponent: OnAllClientOpeningReady")
  GWorld:DSBLog("Info", "HardBossDgComponent: OnAllClientOpeningReady ", "GameMode")
  self.GameMode:RemoveDungeonEvent("OpeningSequence")
  local CreatorIds = TArray(0)
  CreatorIds:Add(self.AirWallStaticCreatorId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIds)
  self.GameMode:TriggerGameModeEvent("Event_OnAllClientOpeningReady")
end

function M:RealGameStart()
  for _, BossEid in pairs(self.BossEids) do
    local Boss = Battle(self):GetEntity(BossEid)
    if IsValid(Boss) then
      Boss:RestartBT()
      Battle(self):RemoveBuffFromTarget(Boss, Boss, Const.BossInvincibleBuffId, false, -1)
    end
  end
  local AllPlayers = self.GameMode:GetAllPlayer()
  for _, Player in pairs(AllPlayers) do
    DebugPrint("HardBossDgComponent: RealGameStart", Player.Eid)
    GWorld:DSBLog("Info", "HardBossDgComponent: RealGameStart PlayerEid: " .. Player.Eid, "GameMode")
    self:MutePlayerAction(Player, false)
    self.GameMode:PausePhantomBTByPlayer(Player, false, "HardBossOpening")
  end
  local Creator = self.GameMode.EMGameState:GetStaticCreatorInfo(self.PreparingAirWallStaticId)
  if IsValid(Creator) then
    local ChildEids = Creator:GetChildEids()
    for _, ChildEid in pairs(ChildEids) do
      local AirWall = Battle(self):GetEntity(ChildEid)
      if IsValid(AirWall) and AirWall.HardBossPreAirWallEnd then
        AirWall:HardBossPreAirWallEnd()
      end
    end
  end
end

function M:OnPlayerExitGame(AvatarArr)
  if not self.IsWaitingClientOpening then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  for i = 1, AvatarArr:Length() do
    local AvatarEidStr = AvatarArr:GetRef(i)
    self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Exit
    DebugPrint("HardBossDgComponent: OnPlayerExitGame", AvatarEidStr, "PlayerNum", PlayerNum)
    GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerExitGame AvatarEidStr: " .. AvatarEidStr .. " PlayerNum: " .. PlayerNum, "GameMode")
  end
  if self:IsAllActiveClientReady() then
    self:OnAllClientOpeningReady()
  end
end

function M:OnPlayerDisconnectGame(AvatarEidStr)
  if not self.IsWaitingClientOpening then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Disconnect
  DebugPrint("HardBossDgComponent: OnPlayerDisconnectGame", AvatarEidStr, "PlayerNum", PlayerNum)
  GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerDisconnectGame AvatarEidStr: " .. AvatarEidStr .. " PlayerNum: " .. PlayerNum, "GameMode")
end

function M:OnPlayerAvatarLogout(AvatarEidStr)
  if not self.IsWaitingClientOpening then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  DebugPrint("HardBossDgComponent: OnPlayerAvatarLogout", AvatarEidStr, "PlayerNum", PlayerNum)
  GWorld:DSBLog("Info", "HardBossDgComponent: OnPlayerAvatarLogout AvatarEidStr: " .. AvatarEidStr .. " PlayerNum: " .. PlayerNum, "GameMode")
  if self:IsAllActiveClientReady() then
    self:OnAllClientOpeningReady()
  end
end

function M:MutePlayerAction(Player, IsMute)
  if not IsValid(Player) then
    return
  end
  DebugPrint("HardBossDgComponent: MutePlayerAction", IsMute, "PlayerEid:", Player.Eid)
  if IsMute then
    Battle(self):AddBuffToTarget(Player, Player, Const.MuteBuffId, -1)
  else
    Battle(self):RemoveBuffFromTarget(Player, Player, Const.MuteBuffId, false, -1)
  end
end

return M
