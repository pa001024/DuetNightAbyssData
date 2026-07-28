local GameModeDungeonRPC = DungeonClass.Class()
GameModeDungeonRPC.__Component__ = {}

function GameModeDungeonRPC:NotifyServerDungeonEvent(...)
  local ServerEntity = GWorld:GetServerEntity()
  if ServerEntity then
    ServerEntity:NotifyServerDungeonEvent(...)
  end
end

function GameModeDungeonRPC:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
  local ServerEntity = GWorld:GetServerEntity()
  if ServerEntity then
    ServerEntity:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
  end
end

function GameModeDungeonRPC:NotifyGameModeDungeonEvent(...)
  self:OnNotifyGameModeDungeonEvent(...)
end

function GameModeDungeonRPC:NotifyClientDungeonEvent(...)
  self.CProperty:MulticastGameModeDungeonEvent(...)
end

function GameModeDungeonRPC:NotifySingleClientDungeonEvent(AvatarEidStr, ...)
  self.CProperty:UnicastGameModeDungeonEvent(AvatarEidStr, ...)
end

DungeonClass.AssembleComponents(GameModeDungeonRPC)
return GameModeDungeonRPC
