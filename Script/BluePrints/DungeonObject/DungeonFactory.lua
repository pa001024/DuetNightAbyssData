local DungeonClass = require("BluePrints.DungeonObject.DungeonClass")
local GlobalFunction = require("BluePrints.DungeonObject.GlobalFunction")
local DungeonObjectConst = require("BluePrints.DungeonObject.DungeonObjectConst")
local DungeonFactory = {}

function DungeonFactory.CreateDungeon(ShortName, Type, Name, Env)
  if not DungeonObjectConst.OpenDungeonObjectsTypes[ShortName] then
    return
  end
  if not Name then
    return
  end
  local Path = "BluePrints.DungeonObject." .. Name .. "." .. Name
  local ClearPackageFunc = Env and Env.ClearPackageFunc
  DungeonClass.ClearPackageFunc = ClearPackageFunc
  if ClearPackageFunc then
    ClearPackageFunc(Path)
  end
  local Module = require(Path)
  local Value = Module(Type)
  return Value
end

function DungeonFactory.CreateServerDungeon(Name, Env)
  if not Name then
    return
  end
  return DungeonFactory.CreateDungeon(Name, "Server", Name, Env)
end

function DungeonFactory.CreateDedicatedServerDungeon(Name, Env)
  if not Name then
    return
  end
  return DungeonFactory.CreateDungeon(Name, "DedicatedServer", Name, Env)
end

function DungeonFactory.CreateGameModeDungeon(Name, Env)
  if not Name then
    return
  end
  return DungeonFactory.CreateDungeon(Name, "GameMode", Name, Env)
end

function DungeonFactory.CreateClientDungeon(Name, Env)
  if not Name then
    return
  end
  return DungeonFactory.CreateDungeon(Name, "Client", Name, Env)
end

function DungeonFactory.InitEnv(Outer)
  for k, v in pairs(Outer) do
    rawset(GlobalFunction, k, v)
  end
end

return DungeonFactory
