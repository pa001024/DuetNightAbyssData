local ServerDungeon = DungeonClass.Class()
ServerDungeon.__Name__ = "ServerDungeon"
ServerDungeon.__Component__ = {
  "BluePrints.DungeonObject.Server.ServerDungeonBase",
  "src.components.dungeon_components.ServerBaseDungeonObject",
  "src.components.dungeon_components.ServerRougePro",
  "BluePrints.DungeonObject.RougePro.RougeProGame"
}
local GameModeDungeon = DungeonClass.Class()
GameModeDungeon.__Name__ = "GameModeDungeon"
GameModeDungeon.__Component__ = {
  "BluePrints.DungeonObject.GameMode.GameModeDungeonBase",
  "BluePrints.DungeonObject.RougePro.GameModeRougeProGame"
}
local ClientDungeon = DungeonClass.Class()
ClientDungeon.__Name__ = "ClientDungeon"
ClientDungeon.__Component__ = {
  "BluePrints.DungeonObject.Client.ClientDungeonBase"
}
local DedicatedServerDungeon = DungeonClass.Class()
DedicatedServerDungeon.__Name__ = "DedicatedServerDungeon"
DedicatedServerDungeon.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProGame",
  "BluePrints.DungeonObject.Server.ServerDungeonBase",
  "BluePrints.DungeonObject.DedicatedServer.DedicatedServerBase",
  "BluePrints.DungeonObject.RougePro.DedicatedServerRougePro"
}
local Dungeon = {
  Server = ServerDungeon,
  DedicatedServer = DedicatedServerDungeon,
  GameMode = GameModeDungeon,
  Client = ClientDungeon
}

local function CreateFunction(Type)
  local Value = Dungeon[Type]
  DungeonClass.AssembleComponents(Value)
  return Value()
end

return CreateFunction
