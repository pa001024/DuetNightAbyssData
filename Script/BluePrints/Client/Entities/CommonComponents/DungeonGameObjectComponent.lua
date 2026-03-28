local DungeonFactory = require("BluePrints.DungeonObject.DungeonFactory")
local Component = {}
local DungeonObject, DungeonNetGuid

function Component:NotifyServerDungeonEvent(EventName, ...)
  self:NotifyServerDungeonEventWithCallback(-1, EventName, ...)
end

function Component:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
  if self.bClientEntity then
    local CallbackId
    if type(Callback) == "function" then
      CallbackId = self:BindCallbackFunc(Callback)
    else
      CallbackId = Callback
    end
    self:CallServerMethod("NotifyServerDungeonEvent", CallbackId, EventName, {
      ...
    })
  else
    self:RealNotifyServerDungeonEventWithCallback(Callback, EventName, ...)
  end
end

function Component:NotifyGameModeDungeonEvent(EventName, ...)
  if not DungeonObject then
    DebugPrint("NotifyGameModeDungeonEvent bug DungeonObject is nil")
    return
  end
  DungeonObject:OnNotifyGameModeDungeonEvent(EventName, ...)
end

function Component:ReplicatedDungeonObject(ReplicatedType, ...)
  DebugPrint("ReplicatedDungeonObject", ReplicatedType, ...)
  if 0 == ReplicatedType then
    self:CreateDungeonObject(...)
  elseif 1 == ReplicatedType then
    self:CreateDungeonObjectActor(...)
  elseif 2 == ReplicatedType then
    self:ReplicatedDungeonObjectProperty(...)
  elseif 3 == ReplicatedType then
    self:DeleteDungeonObjectActor(...)
  else
    ServerPrint("ReplicatedDungeonObject Unknown ReplicatedType", ReplicatedType)
  end
end

function Component:CreateDungeonObject(DungeonId, NetGuid)
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not DungeonInfo then
    return
  end
  local DungeonType = DungeonInfo.DungeonType
  if DungeonObject then
    DebugPrint("Warning!!! GameModeDungeonObject Exists")
  end
  local Env = {
    ClearPackageFunc = require("UnLuaHotReload").RemoveLoadedModule
  }
  DungeonObject = DungeonFactory.CreateGameModeDungeon(DungeonType, Env)
  if not DungeonObject then
    DebugPrint("ReplicatedDungeonObject CreateDungeonObject failed", DungeonType)
    return
  end
  DungeonNetGuid = NetGuid
  DungeonObject:Init({DungeonId = DungeonId, NetGuid = NetGuid})
end

function Component:GetDungeonObject()
  return DungeonObject
end

function Component:CreateDungeonObjectActor(...)
  if not DungeonObject then
    DebugPrint("CreateDungeonObjectActor but DungeonObject is not created")
    return
  end
  DungeonObject:ReplicatedActor(...)
end

function Component:ReplicatedDungeonObjectProperty(...)
  if not DungeonObject then
    DebugPrint("ReplicatedDungeonObjectProperty but DungeonObject is not created")
    return
  end
  DungeonObject:ReplicatedProperty(...)
end

function Component:DeleteDungeonObjectActor(NetGuid)
  if not DungeonObject then
    DebugPrint("DeleteDungeonObjectActor but DungeonObject is not created")
    return
  end
  if DungeonNetGuid == NetGuid then
    DungeonObject:EndPlay()
    DungeonObject = nil
  else
    DungeonObject:ReplicatedDeleteActor(NetGuid)
  end
end

function Component:DungeonObjectBindCObject(CObj)
  if not DungeonObject then
    return
  end
  DungeonObject:BindCObject(CObj)
end

return Component
