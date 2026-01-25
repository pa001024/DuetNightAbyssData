require("UnLua")
local DungeonDeliveryComponent = {}

function DungeonDeliveryComponent:ActiveDungeonDeliveryPoint(DeliveryPointId)
  self.ActivatedDeliveryPointId = DeliveryPointId
  self:UpdateDeliveryInfo()
  self:AddTimer(Const.DunegonDeliveryPointUpdateInterval, self.UpdateDeliveryInfo, true, 0, Const.DunegonDeliveryPointUpdateTimerHandle)
end

function DungeonDeliveryComponent:DeactiveDungeonDeliveryPoint()
  self.ActivatedDeliveryPointId = -1
  local AllPlayers = self:GetAllPlayer()
  for _, Player in pairs(AllPlayers) do
    local PlayerState = Player.PlayerState
    PlayerState:SetActivatedDungeonDelivertPointId(-1)
  end
  self:RemoveTimer(Const.DunegonDeliveryPointUpdateTimerHandle)
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
  LevelLoader:TeleportInDedicatedServer(Player, TargetLocation, TargetRotation)
end

function DungeonDeliveryComponent:OnDungeonPlayerDeliveryEnd(Player)
  if not IsValid(Player) then
    return
  end
  self:SetPlayerInvincible(Player, false)
  Battle(self):RemoveBuffFromTarget(Player, Player, Const.SynthesisSpeedUpBuffId, false, -1)
  if Player.PlayerState then
    Player.PlayerState:SetActivatedDungeonDelivertPointId(-1)
  end
end

return DungeonDeliveryComponent
