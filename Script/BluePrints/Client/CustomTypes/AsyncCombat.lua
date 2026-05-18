local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local AsyncCombat = Class("AsyncCombat", CustomTypes.CustomAttr)
AsyncCombat.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  CreateRoomTimes = prop.prop("Int", "client save", 0),
  GoingRoom = prop.prop("IntSet", "client save"),
  OwnedRoom = prop.prop("IntSet", "client save"),
  CreatedRoom = prop.prop("IntSet", "client save")
}

function AsyncCombat:Init(EventId)
  self.EventId = EventId
end

function AsyncCombat:AddCreateRoomTimes()
  self.CreateRoomTimes = self.CreateRoomTimes + 1
end

function AsyncCombat:AddOwnedRoom(RoomUniId)
  self.OwnedRoom:AddElement(RoomUniId)
end

function AsyncCombat:DelOwnedRoom(RoomUniId)
  self.OwnedRoom:RemoveElement(RoomUniId)
end

function AsyncCombat:AddCreatedRoom(RoomUniId)
  self.CreatedRoom:AddElement(RoomUniId)
end

function AsyncCombat:DelCreatedRoom(RoomUniId)
  self.CreatedRoom:RemoveElement(RoomUniId)
end

function AsyncCombat:AddGoingRoom(RoomUniId)
  self.GoingRoom:AddElement(RoomUniId)
end

function AsyncCombat:DelGoingRoom(RoomUniId)
  self.GoingRoom:RemoveElement(RoomUniId)
end

FormatProperties(AsyncCombat)
local AsyncCombatDict = Class("AsyncCombatDict", CustomTypes.CustomDict)
AsyncCombatDict.KeyType = BaseTypes.Int
AsyncCombatDict.ValueType = AsyncCombat

function AsyncCombatDict:GetNewAsyncCombat(EventId)
  if not self[EventId] then
    self[EventId] = self:NewAsyncCombat(EventId)
  end
  return self[EventId]
end

function AsyncCombatDict:GetAsyncCombat(EventId)
  return self[EventId]
end

function AsyncCombatDict:NewAsyncCombat(EventId)
  return AsyncCombat(EventId)
end

return {AsyncCombat = AsyncCombat, AsyncCombatDict = AsyncCombatDict}
