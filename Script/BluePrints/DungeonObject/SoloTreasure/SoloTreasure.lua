local ServerDungeon = DungeonClass.Class()
ServerDungeon.__Name__ = "ServerDungeon"
ServerDungeon.__Component__ = {
  "BluePrints.DungeonObject.Server.ServerDungeonBase",
  "src.components.dungeon_components.ServerBaseDungeonObject",
  "BluePrints.DungeonObject.SoloTreasure.SoloTreasureGameStruct",
  "BluePrints.DungeonObject.SoloTreasure.DungeonSoloTreasure",
  "BluePrints.DungeonObject.DungeonComponent.TableDrivenServerEventComponent"
}
local GameModeDungeon = DungeonClass.Class()
GameModeDungeon.__Name__ = "GameModeDungeon"
GameModeDungeon.__Component__ = {
  "BluePrints.DungeonObject.SoloTreasure.ClientDungeonSoloTreasure",
  "BluePrints.DungeonObject.GameMode.GameModeDungeonBase"
}
local Dungeon = {Server = ServerDungeon, GameMode = GameModeDungeon}

local function CreateFunction(Type)
  local Value = Dungeon[Type]
  if Value then
    DungeonClass.AssembleComponents(Value)
    return Value()
  end
  return nil
end

return CreateFunction
