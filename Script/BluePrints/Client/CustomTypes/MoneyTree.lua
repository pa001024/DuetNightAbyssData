local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local MoneyTreeEvent = Class("MoneyTreeEvent", CustomTypes.CustomAttr)
MoneyTreeEvent.__Props__ = {
  EventId = prop.prop("Int", "client save", 0),
  ClaimCount = prop.prop("Int", "client save", 0),
  LastClaimTime = prop.prop("Int", "client save", 0),
  TodayClaimCount = prop.prop("Int", "client save", 0),
  TodayReward = prop.prop("Int", "client save", 0),
  TodayRewardResourceId = prop.prop("Int", "client save", 0),
  LastDoubleTime = prop.prop("Int", "client save", 0),
  TodayDoubleReward = prop.prop("Int", "client save", 0),
  SingleDoubleUsed = prop.prop("Bool", "client save", false),
  AllDoubleUnlocked = prop.prop("Bool", "client save", false),
  AllDoubleUnlockTime = prop.prop("Int", "client save", 0),
  TotalReward = prop.prop("Int", "client save", 0)
}

function MoneyTreeEvent:Init(EventId)
  self.EventId = EventId or 0
end

FormatProperties(MoneyTreeEvent)
local MoneyTreeDict = Class("MoneyTreeDict", CustomTypes.CustomDict)
MoneyTreeDict.KeyType = BaseTypes.Int
MoneyTreeDict.ValueType = MoneyTreeEvent

function MoneyTreeDict:NewMoneyTreeEvent(EventId)
  return MoneyTreeEvent(EventId)
end

return {MoneyTreeEvent = MoneyTreeEvent, MoneyTreeDict = MoneyTreeDict}
