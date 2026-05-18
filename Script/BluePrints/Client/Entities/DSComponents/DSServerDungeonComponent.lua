local DungeonFactory = require("BluePrints.DungeonObject.DungeonFactory")
local Component = {}
local bInitEnv = false
local DungeonInstance

local function ClearDungeonInstance()
  if DungeonInstance then
    DungeonInstance:EndPlay()
  end
  DungeonInstance = nil
end

function Component:TryCreateServerDungeon(DungeonId)
  ClearDungeonInstance()
  if not bInitEnv then
    bInitEnv = true
    DebugPrint("TryCreateServerDungeon InitEnv")
    DungeonFactory.InitEnv({
      ServerPrint = ServerPrint
    })
  end
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not DungeonInfo then
    return
  end
  local DungeonType = DungeonInfo.DungeonType
  DungeonInstance = DungeonFactory.CreateDedicatedServerDungeon(DungeonType)
  if not DungeonInstance then
    return
  end
  DebugPrint("TryCreateServerDungeon Success")
  DungeonInstance:Init({
    DungeonId = DungeonId,
    GameInstance = GWorld.GameInstance,
    DSEntity = self
  })
  DungeonInstance:BeginPlay()
end

function Component:OnResponseDungeonCallback(...)
  if not DungeonInstance then
    return
  end
  DungeonInstance:OnResponseDungeonCallback(...)
end

function Component:RealNotifyServerDungeonEventWithCallback(Callback, EventName, ...)
  if not DungeonInstance then
    return
  end
  local ret = table.pack(DungeonInstance:OnNotifyServerDungeonEvent(EventName, ...))
  if type(Callback) ~= "function" then
    return
  end
  Callback(table.unpack(ret))
end

function Component:DungeonObjectAddPlayer(AvatarEid)
  if not DungeonInstance then
    return
  end
  DungeonInstance:AddPlayer(AvatarEid)
end

function Component:DungeonObjectRemovePlayer(AvatarEid)
  if not DungeonInstance then
    return
  end
  DungeonInstance:RemovePlayer(AvatarEid)
end

function Component:AddMoreInfoForDungeonObject(Info)
  if not DungeonInstance then
    return
  end
  DungeonInstance:InitExtra(Info)
end

return Component
