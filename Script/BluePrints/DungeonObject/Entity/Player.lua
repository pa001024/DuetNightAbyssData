local Player = DungeonClass.Class()
Player.__Class__ = "Player"
Player.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport",
  "BluePrints.DungeonObject.RougePro.RougeProPlayer"
}

function Player:__Init__(DungeonObject)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self)
  self:PostOnInit()
end

function Player:PostOnInit()
end

DungeonClass.AssembleComponents(Player)
return Player
