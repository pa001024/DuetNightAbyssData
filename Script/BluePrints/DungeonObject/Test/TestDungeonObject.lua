package.path = package.path .. ";../../../?.lua;../?.lua"
local DungeonFactory = require("DungeonFactory")

function Test(SoloTreasure)
  local m = SoloTreasure:CreateMechanism()
  for k, v in pairs(m) do
    print(k, v)
  end
  local m = SoloTreasure:CreateDrop()
  for k, v in pairs(m) do
    print(k, v)
  end
end

local SoloTreasure = DungeonFactory.CreateGameModeDungeon("SoloTreasure")
print(SoloTreasure)
local SoloTreasure1 = DungeonFactory.CreateGameModeDungeon("SoloTreasure")
print(SoloTreasure1)
