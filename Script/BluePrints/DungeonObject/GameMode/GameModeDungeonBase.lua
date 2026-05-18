local DungeonObjectConst = require("BluePrints.DungeonObject.DungeonObjectConst")
local GameModeDungeonBase = DungeonClass.Class()
GameModeDungeonBase.__Component__ = {
  "BluePrints.DungeonObject.DungeonBase",
  "BluePrints.DungeonObject.GameMode.GameModeDungeonRPC",
  "BluePrints.DungeonObject.GameMode.GameModeDungeonReplicatedProperty",
  "BluePrints.DungeonObject.GameMode.GameModeCProperty"
}

function GameModeDungeonBase:GetActorClassPath()
  return DungeonObjectConst.TypeToActorClass[self.__Type__]
end

DungeonClass.AssembleComponents(GameModeDungeonBase)
return GameModeDungeonBase
