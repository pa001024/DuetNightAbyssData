local ServerDungeon = DungeonClass.Class()
ServerDungeon.__Name__ = "ServerDungeon"
ServerDungeon.__Component__ = {
  "BluePrints.DungeonObject.Server.ServerDungeonBase",
  "src.components.dungeon_components.ServerBaseDungeonObject",
  "BluePrints.DungeonObject.WeaponVerify.WeaponVerifyGame",
  "BluePrints.DungeonObject.TimerSync.ServerTimerSyncComponent"
}
local GameModeDungeon = DungeonClass.Class()
GameModeDungeon.__Name__ = "GameModeDungeon"
GameModeDungeon.__Component__ = {
  "BluePrints.DungeonObject.GameMode.GameModeDungeonBase",
  "BluePrints.DungeonObject.TimerSync.GameModeTimerSyncComponent"
}
local ClientDungeon = DungeonClass.Class()
ClientDungeon.__Name__ = "ClientDungeon"
ClientDungeon.__Component__ = {
  "BluePrints.DungeonObject.Client.ClientDungeonBase"
}
local Dungeon = {
  Server = ServerDungeon,
  GameMode = GameModeDungeon,
  Client = ClientDungeon
}

local function CreateFunction(Type)
  local Value = Dungeon[Type]
  DungeonClass.AssembleComponents(Value)
  return Value()
end

return CreateFunction
