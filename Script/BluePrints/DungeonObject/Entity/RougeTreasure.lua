local RougeTreasure = DungeonClass.Class()
RougeTreasure.__Class__ = "RougeTreasure"
RougeTreasure.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport"
}

function RougeTreasure:__Init__(DungeonObject, TreasureId)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self, "TreasureId", TreasureId)
  self:PostOnInit()
end

function RougeTreasure:PostOnInit()
end

DungeonClass.AssembleComponents(RougeTreasure)
return RougeTreasure
