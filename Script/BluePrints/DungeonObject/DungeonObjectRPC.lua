local DungeonObjectRPC = DungeonClass.Class()
DungeonObjectRPC.__Name__ = "DungeonObjectRPC"
DungeonObjectRPC.__Component__ = {}

function DungeonObjectRPC:NotifyServerDungeonEvent(EventName, ...)
end

function DungeonObjectRPC:OnNotifyServerDungeonEvent(EventName, ...)
  print("DungeonObjectRPC:OnNotifyServerDungeonEvent: ", EventName)
  local FunName = "OnNotifyServerDungeonEvent_" .. EventName
  if self[FunName] then
    return self[FunName](self, ...)
  else
    print("DungeonObjectRPC:OnNotifyServerDungeonEvent No Fun, FunName:", FunName)
  end
end

function DungeonObjectRPC:NotifyGameModeDungeonEvent(EventName, ...)
end

function DungeonObjectRPC:OnNotifyGameModeDungeonEvent(EventName, ...)
  print("DungeonObjectRPC:OnNotifyGameModeDungeonEvent: ", EventName)
  local FunName = "OnNotifyGameModeDungeonEvent_" .. EventName
  if self[FunName] then
    self[FunName](self, ...)
    return
  end
  if self.GameMode then
    self.GameMode:OnNotifyGameModeDungeonEvent(EventName, ...)
  else
    print("DungeonObjectRPC:OnNotifyGameModeDungeonEvent GameMode nil or No Fun, FunName:", FunName)
  end
end

function DungeonObjectRPC:NotifyClientDungeonEvent(EventName, ...)
end

function DungeonObjectRPC:OnNotifyClientDungeonEvent(EventName, ...)
  print("DungeonObjectRPC:OnNotifyClientDungeonEvent: ", EventName)
  local FunName = "OnNotifyClientDungeonEvent_" .. EventName
  if self[FunName] then
    self[FunName](self, ...)
  else
    print("DungeonObjectRPC:OnNotifyClientDungeonEvent No Fun, FunName:", FunName)
  end
end

DungeonClass.AssembleComponents(DungeonObjectRPC)
return DungeonObjectRPC
