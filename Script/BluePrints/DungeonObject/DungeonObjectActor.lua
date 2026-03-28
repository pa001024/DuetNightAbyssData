local DungeonObjectActor = Class()

function DungeonObjectActor:ReceiveBeginPlay()
  self.Super:ReceiveBeginPlay()
  local ServerEntity = GWorld:GetServerEntity()
  if ServerEntity then
    self.DungeonObject = ServerEntity:GetDungeonObject()
    if self.DungeonObject then
      print("DungeonObjectActor: Bind to DungeonObject success")
    else
      print("DungeonObjectActor: DungeonObject not found")
    end
  else
    print("DungeonObjectActor: ServerEntity not found")
  end
end

return DungeonObjectActor
