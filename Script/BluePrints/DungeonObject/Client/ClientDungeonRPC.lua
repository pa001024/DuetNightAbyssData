local ClientDungeonRPC = DungeonClass.Class()
ClientDungeonRPC.__Component__ = {}

function ClientDungeonRPC:NotifyServerDungeonEvent(...)
  local ServerEntity = GWorld:GetServerEntity()
  if ServerEntity then
    ServerEntity:NotifyServerDungeonEvent(...)
  end
end

function ClientDungeonRPC:NotifyGameModeDungeonEvent(...)
  local ServerEntity = GWorld:GetServerEntity()
  if not ServerEntity then
    return
  end
  local DungeonObject = ServerEntity:GetDungeonObject()
  if not DungeonObject then
    return
  end
  DungeonObject:OnNotifyGameModeDungeonEvent(...)
end

function ClientDungeonRPC:NotifyClientDungeonEvent(...)
  self:NotifyClientDungeonEvent(...)
end

DungeonClass.AssembleComponents(ClientDungeonRPC)
return ClientDungeonRPC
