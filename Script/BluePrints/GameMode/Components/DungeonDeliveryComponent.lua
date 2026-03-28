require("UnLua")
local DungeonDeliveryComponent = {}

function DungeonDeliveryComponent:ActiveDungeonDeliveryPoint(DeliveryPointId)
  if not IsDedicatedServer(self) then
    return
  end
  self.ActivatedDeliveryPointId = DeliveryPointId
  self:UpdateDeliveryInfo()
  self:AddTimer(Const.DunegonDeliveryPointUpdateInterval, self.UpdateDeliveryInfo, true, 0, Const.DunegonDeliveryPointUpdateTimerHandle)
  GWorld:DSBLog("Info", "DungeonDeliveryComponent: Active DeliveryPoint " .. DeliveryPointId, "GameMode")
end

function DungeonDeliveryComponent:DeactiveDungeonDeliveryPoint()
  self.ActivatedDeliveryPointId = -1
  local AllPlayers = self:GetAllPlayer()
  for _, Player in pairs(AllPlayers) do
    local PlayerState = Player.PlayerState
    PlayerState:SetActivatedDungeonDelivertPointId(-1)
  end
  self:RemoveTimer(Const.DunegonDeliveryPointUpdateTimerHandle)
  GWorld:DSBLog("Info", "DungeonDeliveryComponent: Deactive DeliveryPoint ", "GameMode")
end

function DungeonDeliveryComponent:UpdateDeliveryInfo()
  self:UpdatePlayerDeliveryPointInfo(self.ActivatedDeliveryPointId)
end

function DungeonDeliveryComponent:OnReceivePlayerDeliveryStart(PlayerEid)
  local DeliverPoint = self.EMGameState.DungeonDeliveryPointMap:FindRef(self.ActivatedDeliveryPointId)
  DebugPrint("DungeonDeliveryComponent: OnReceivePlayerDeliveryStart", PlayerEid, "ActivatedDeliveryPointId", self.ActivatedDeliveryPointId)
  if not IsValid(DeliverPoint) then
    return
  end
  local Player = Battle(self):GetEntity(PlayerEid)
  if not IsValid(Player) then
    return
  end
  local PlayerState = Player.PlayerState
  if PlayerState and -1 == PlayerState.ActivatedDungeonDeliveryPointId then
    DebugPrint("DungeonDeliveryComponent: DS校验不通过 此时该玩家无法传送", PlayerEid, "ActivatedDeliveryPointId", self.ActivatedDeliveryPointId)
    return
  end
  local LevelLoader = self:GetLevelLoader()
  if not LevelLoader then
    self.EMGameState:ShowDungeonError("尝试传送玩家失败！没有LevelLoader!", Const.DungeonErrorType.DungeonDelivery, Const.DungeonErrorTitle.FindObject)
    return
  end
  local TargetLocation, TargetRotation = DeliverPoint:GetDeliveryInfo(Player.Eid)
  if not TargetLocation then
    self.EMGameState:ShowDungeonError("尝试传送玩家失败！该点位有效位置已用完，请检查逻辑！Id:" .. self.ActivatedDeliveryPointId, Const.DungeonErrorType.DungeonDelivery, Const.DungeonErrorTitle.Process)
    return
  end
  self:SetPlayerInvincible(Player, true)
  LevelLoader:TeleportInDedicatedServer(Player, TargetLocation, TargetRotation, "DungeonDelivery")
  GWorld:DSBLog("Info", "DungeonDeliveryComponent: Teleport player " .. Player.Eid, "GameMode")
end

function DungeonDeliveryComponent:OnDungeonPlayerDeliveryEnd(Player, TeleportTag)
  if not IsValid(Player) then
    return
  end
  local FunName = "OnDungeonPlayerDeliveryEnd_" .. TeleportTag
  if not self[FunName] then
    return
  end
  self[FunName](self, Player)
end

function DungeonDeliveryComponent:OnDungeonPlayerDeliveryEnd_DungeonDelivery(Player)
  DebugPrint("DungeonDeliveryComponent: OnDungeonPlayerDeliveryEnd_DungeonDelivery", Player.Eid)
  self:SetPlayerInvincible(Player, false)
  Battle(self):RemoveBuffFromTarget(Player, Player, Const.SynthesisSpeedUpBuffId, false, -1)
  if Player.PlayerState then
    Player.PlayerState:SetActivatedDungeonDelivertPointId(-1)
  end
end

function DungeonDeliveryComponent:ActiveExitDelivery(StaticCreatorId, PrivateEnable)
  self.EMGameState:SetIsExitDeliveryActive(true)
  self.LevelGameMode.ExitStaticCreatorId = StaticCreatorId
  self.LevelGameMode.ExitPrivateEnable = PrivateEnable
  self.LevelGameMode:ChangeBindAfterNotExecuteSkillDelegates(true)
end

function DungeonDeliveryComponent:OnReceiveExitDeliveryStart(PlayerEid)
  DebugPrint("DungeonDeliveryComponent: OnReceiveExitDeliveryStart", PlayerEid, "IsExitDeliveryActive", self.EMGameState.IsExitDeliveryActive)
  if not self.EMGameState.IsExitDeliveryActive then
    return
  end
  if not self.EMGameState:CheckGameModeStateEnable() then
    return
  end
  local Player = Battle(self):GetEntity(PlayerEid)
  if not IsValid(Player) then
    return
  end
  local LevelLoader = self:GetLevelLoader()
  if not LevelLoader then
    self.EMGameState:ShowDungeonError("尝试传送玩家失败！没有LevelLoader!", Const.DungeonErrorType.DungeonDelivery, Const.DungeonErrorTitle.FindObject)
    return
  end
  local ExitCreator
  if self.ExitPrivateEnable then
    local Creators = TMap(0, UObject)
    self.EMGameState:GetSubStaticCreatorInfo(self.LevelName, Creators)
    ExitCreator = Creators:FindRef(self.ExitStaticCreatorId)
  else
    ExitCreator = self.EMGameState.StaticCreatorMap:FindRef(self.ExitStaticCreatorId)
  end
  if not IsValid(ExitCreator) then
    self.EMGameState:ShowDungeonError("激活撤离传送点失败！找不到撤离点的静态点！请检查逻辑！Id:" .. tostring(self.ExitStaticCreatorId), Const.DungeonErrorType.DungeonDelivery, Const.DungeonErrorTitle.Process)
    return
  end
  local TargetLocation = ExitCreator:K2_GetActorLocation()
  local TargetRotation = ExitCreator:K2_GetActorRotation()
  LevelLoader:TeleportInDedicatedServer(Player, TargetLocation, TargetRotation, "ExitDelivery")
  DebugPrint("DungeonDeliveryComponent: ExitDeliveryStart", Player.Eid, TargetLocation)
  GWorld:DSBLog("Info", "DungeonDeliveryComponent: ExitDeliveryStart " .. Player.Eid, "GameMode")
end

function DungeonDeliveryComponent:OnDungeonPlayerDeliveryEnd_ExitDelivery(Player)
  DebugPrint("DungeonDeliveryComponent: OnDungeonPlayerDeliveryEnd_ExitDelivery", Player.Eid)
end

function DungeonDeliveryComponent:OnReceiveAfterNotExecuteSkill(Player, Skill)
  if not IsValid(Player) and not IsValid(Skill) then
    return
  end
  local IsSupportSkill = Skill.SkillType == "Support"
  if not IsSupportSkill then
    DebugPrint("DungeonDeliveryComponent: OnReceiveAfterNotExecuteSkill Not SupportSkill", Player.Eid)
    return
  end
  local Pet = Player:GetBattlePet()
  local IsPetTeleportAble = Pet and Pet:HasAutoTransfer()
  if not IsPetTeleportAble then
    DebugPrint("DungeonDeliveryComponent: OnReceiveAfterNotExecuteSkill Not PetTeleportAble", Player.Eid)
    return
  end
  self:OnReceiveExitDeliveryStart(Player.Eid)
end

return DungeonDeliveryComponent
