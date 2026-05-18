local Npc = DungeonClass.Class()
Npc.__Class__ = "Npc"
Npc.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport",
  "BluePrints.DungeonObject.RougePro.RougeProShopNpc"
}

function Npc:__Init__(DungeonObject)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self)
  self:PostOnInit()
end

function Npc:PostOnInit()
end

DungeonClass.AssembleComponents(Npc)
return Npc
