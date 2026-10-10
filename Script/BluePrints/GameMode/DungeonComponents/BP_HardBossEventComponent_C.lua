local M = Class({
  "BluePrints.Common.TimerMgr"
})
local PlayerGameState = {
  NotReady = 1,
  Ready = 2,
  Disconnect = 3,
  Exit = 4
}
local MAX_WAIT_FOR_PLAYERS_READY = 30

function M:InitHardBossEventComponent()
  self.GameMode = self:GetOwner()
  self.BossEids = {}
  self:RegisterGameModeEvents()
  DebugPrint("HardBossEventComponent: InitHardBossEventComponent IsDedicatedServer:", tostring(IsDedicatedServer(self)), "IsStandAlone:", tostring(IsStandAlone(self)), "DungeonId:", tostring(self.GameMode and self.GameMode.DungeonId))
end

function M:RegisterGameModeEvents()
  self.GameMode.EMGameState:RegisterGameModeEvent("OnExit", self, self.OnPlayerExitGame)
  self.GameMode.EMGameState:RegisterGameModeEvent("OnDisconnect", self, self.OnPlayerDisconnectGame)
  EventManager:AddEvent(EventID.OnAvatarLogout, self, self.OnPlayerAvatarLogout)
end

function M:InitHardBossEventBaseInfo()
  GWorld:DSBLog("Info", "HardBossEventComponent: InitHardBossEventBaseInfo", "GameMode")
  if IsDedicatedServer(self) then
    DebugPrint("HardBossEventComponent: InitHardBossEventBaseInfo -> 进入等待(DS)")
    self:StartWaitForPlayers()
  else
    DebugPrint("HardBossEventComponent: InitHardBossEventBaseInfo -> 单机跳过等待,直接开打")
  end
end

function M:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
  if not IsDedicatedServer(self) or "HardBossMain" ~= EventName or "Monster" ~= UnitType then
    return
  end
  local Boss = Battle(self):GetEntity(Eid)
  if IsValid(Boss) then
    Boss:StopBT("HardBossOpening")
    Battle(self):AddBuffToTarget(Boss, Boss, Const.BossInvincibleBuffId, -1)
    table.insert(self.BossEids, Eid)
  end
end

function M:StartWaitForPlayers()
  self.IsWaitingGameStart = true
  self.ClientReadyMap = {}
  DebugPrint("HardBossEventComponent: StartWaitForPlayers TargetPlayerNum:", self.GameMode:GetTargetPlayerNum())
  self:AddTimer(MAX_WAIT_FOR_PLAYERS_READY, function()
    if not self.IsWaitingGameStart then
      return
    end
    DebugPrint("HardBossEventComponent: 等待玩家就绪超时(" .. MAX_WAIT_FOR_PLAYERS_READY .. "s),强制开局")
    self:OnAllPlayersReady()
  end)
  local Players = self.GameMode:GetAllPlayer()
  for _, Player in pairs(Players) do
    self:MutePlayerAction(Player, true)
    self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
    local PlayerState = Player.PlayerState
    local AvatarEidStr = PlayerState and PlayerState.AvatarEidStr or ""
    local IsClientReady = "" ~= AvatarEidStr and self.GameMode.ClientReadyMap and true == self.GameMode.ClientReadyMap:Find(AvatarEidStr)
    DebugPrint("HardBossEventComponent: StartWaitForPlayers AvatarEidStr:", AvatarEidStr, "ClientReady:", tostring(IsClientReady))
    if IsClientReady then
      self:MarkPlayerReady(AvatarEidStr)
    end
  end
end

function M:OnPlayerEnter(Eid)
  if not self.IsWaitingGameStart then
    return
  end
  DebugPrint("HardBossEventComponent: OnPlayerEnter", Eid)
  GWorld:DSBLog("Info", "HardBossEventComponent: OnPlayerEnter PlayerEid: " .. Eid, "GameMode")
  local Player = Battle(self):GetEntity(Eid)
  if not IsValid(Player) then
    return
  end
  self:MutePlayerAction(Player, true)
  self.GameMode:PausePhantomBTByPlayer(Player, true, "HardBossOpening")
  local PlayerState = Player.PlayerState
  if PlayerState and PlayerState.AvatarEidStr then
    self:MarkPlayerReady(PlayerState.AvatarEidStr)
  end
end

function M:MarkPlayerReady(AvatarEidStr)
  if not AvatarEidStr then
    return
  end
  self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Ready
  DebugPrint("HardBossEventComponent: MarkPlayerReady AvatarEidStr:", AvatarEidStr, "ReadyCount:", self:GetReadyCount(), "TargetNum:", self.GameMode:GetTargetPlayerNum())
  if self:IsAllActiveClientReady() then
    self:OnAllPlayersReady()
  end
end

function M:GetReadyCount()
  local ActiveReadyCount = 0
  for AvatarEidStr, State in pairs(self.ClientReadyMap) do
    if State == PlayerGameState.Ready then
      ActiveReadyCount = ActiveReadyCount + 1
    end
  end
  return ActiveReadyCount
end

function M:IsAllActiveClientReady()
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  return PlayerNum <= self:GetReadyCount()
end

function M:OnAllPlayersReady()
  if not self.IsWaitingGameStart then
    return
  end
  self.IsWaitingGameStart = false
  DebugPrint("HardBossEventComponent: OnAllPlayersReady")
  GWorld:DSBLog("Info", "HardBossEventComponent: OnAllPlayersReady ", "GameMode")
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
    DebugPrint("HardBossEventComponent: RealGameStart", Player.Eid)
    GWorld:DSBLog("Info", "HardBossEventComponent: RealGameStart PlayerEid: " .. Player.Eid, "GameMode")
    self:MutePlayerAction(Player, false)
    self.GameMode:PausePhantomBTByPlayer(Player, false, "HardBossOpening")
  end
  local PreAirWallCreatorId = self.GameMode and self.GameMode.PreAirWallCreatorId
  local Creator = PreAirWallCreatorId and self.GameMode.EMGameState:GetStaticCreatorInfo(PreAirWallCreatorId)
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
  if not self.IsWaitingGameStart then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  for i = 1, AvatarArr:Length() do
    local AvatarEidStr = AvatarArr:GetRef(i)
    self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Exit
    DebugPrint("HardBossEventComponent: OnPlayerExitGame", AvatarEidStr, "PlayerNum", PlayerNum)
    GWorld:DSBLog("Info", "HardBossEventComponent: OnPlayerExitGame AvatarEidStr: " .. AvatarEidStr .. " PlayerNum: " .. PlayerNum, "GameMode")
  end
  if self:IsAllActiveClientReady() then
    self:OnAllPlayersReady()
  end
end

function M:OnPlayerDisconnectGame(AvatarEidStr)
  if not self.IsWaitingGameStart then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  self.ClientReadyMap[AvatarEidStr] = PlayerGameState.Disconnect
  DebugPrint("HardBossEventComponent: OnPlayerDisconnectGame", AvatarEidStr, "PlayerNum", PlayerNum)
  GWorld:DSBLog("Info", "HardBossEventComponent: OnPlayerDisconnectGame AvatarEidStr: " .. AvatarEidStr .. " PlayerNum: " .. PlayerNum, "GameMode")
end

function M:OnPlayerAvatarLogout(AvatarEidStr)
  if not self.IsWaitingGameStart then
    return
  end
  local PlayerNum = self.GameMode:GetTargetPlayerNum()
  DebugPrint("HardBossEventComponent: OnPlayerAvatarLogout", AvatarEidStr, "PlayerNum", PlayerNum)
  GWorld:DSBLog("Info", "HardBossEventComponent: OnPlayerAvatarLogout AvatarEidStr: " .. AvatarEidStr .. " PlayerNum: " .. PlayerNum, "GameMode")
  if self:IsAllActiveClientReady() then
    self:OnAllPlayersReady()
  end
end

function M:MutePlayerAction(Player, IsMute)
  if not IsValid(Player) then
    return
  end
  if IsMute then
    Battle(self):AddBuffToTarget(Player, Player, Const.MuteBuffId, -1)
  else
    Battle(self):RemoveBuffFromTarget(Player, Player, Const.MuteBuffId, false, -1)
  end
end

return M
