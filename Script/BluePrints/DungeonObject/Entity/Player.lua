local Player = DungeonClass.Class()
Player.__Class__ = "Player"
Player.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport"
}

function Player:__Init__(DungeonObject)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self)
end

DungeonClass.AssembleComponents(Player)
return Player
