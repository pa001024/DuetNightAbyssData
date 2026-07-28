local ClientDungeonRPC = DungeonClass.Class()
ClientDungeonRPC.__Component__ = {}

function ClientDungeonRPC:NotifyServerDungeonEvent(...)
  local ServerEntity = GWorld:GetServerEntity()
  if ServerEntity then
    ServerEntity:NotifyServerDungeonEvent(...)
  end
end

function ClientDungeonRPC:NotifyGameModeDungeonEvent(...)
  local CProperty = GWorld:GetDungeonObjectCProperty()
  if not CProperty then
    return
  end
  CProperty:NotifyGameModeDungeonEvent(...)
end

function ClientDungeonRPC:NotifyClientDungeonEvent(...)
  self:NotifyClientDungeonEvent(...)
end

DungeonClass.AssembleComponents(ClientDungeonRPC)
return ClientDungeonRPC
