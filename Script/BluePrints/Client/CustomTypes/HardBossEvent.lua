local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local HardBossEvent = Class("HardBossEvent", CustomTypes.CustomAttr)
HardBossEvent.__Props__ = {
  CurrentEventId = prop.prop("Int", "client save", 0),
  RewardTimesLeft = prop.prop("Int", "client save", 0)
}
FormatProperties(HardBossEvent)
return {HardBossEvent = HardBossEvent}
