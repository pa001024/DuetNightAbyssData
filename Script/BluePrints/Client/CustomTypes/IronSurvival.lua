local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local IronSurvivalTicket = Class("IronSurvivalTicket", CustomTypes.CustomAttr)
IronSurvivalTicket.__Props__ = {
  Uid = prop.prop("Int", "client save"),
  TicketId = prop.prop("Int", "client save"),
  Level = prop.prop("Int", "client save")
}

function IronSurvivalTicket:Init(TicketId, Level)
  self.TicketId = TicketId
  self.Level = Level
end

function IronSurvivalTicket:SetUid(Uid)
  self.Uid = Uid
end

local IronSurvivalTicketDict = Class("IronSurvivalTicketDict", CustomTypes.CustomDict)
IronSurvivalTicketDict.KeyType = BaseTypes.Int
IronSurvivalTicketDict.ValueType = IronSurvivalTicket

function IronSurvivalTicketDict:NewTicket(TicketId, Level)
  return IronSurvivalTicket(TicketId, Level)
end

FormatProperties(IronSurvivalTicket)
return {IronSurvivalTicket = IronSurvivalTicket, IronSurvivalTicketDict = IronSurvivalTicketDict}
