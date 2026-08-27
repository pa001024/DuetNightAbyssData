local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local GuildSeatPlan = Class("GuildSeatPlan", CustomTypes.CustomAttr)
GuildSeatPlan.__Props__ = {
  PlanId = prop.prop("Int", "client save", 0),
  TargetId = prop.prop("Int", "client save", 0),
  Type = prop.prop("Int", "client save", 0),
  AppearanceIndex = prop.prop("Int", "client save", 0),
  LastShowTime = prop.prop("Int", "client save", 0)
}
FormatProperties(GuildSeatPlan)
local GuildSeatPlanList = Class("GuildSeatPlanList", CustomTypes.CustomList)
GuildSeatPlanList.ValueType = GuildSeatPlan
local GuildSeat = Class("GuildSeat", CustomTypes.CustomAttr)
GuildSeat.__Props__ = {
  LockUid = prop.prop("Int", "client save", 0),
  Type = prop.prop("Int", "client save", 0),
  PlanId = prop.prop("Int", "client save", 0),
  JoinTime = prop.prop("Int", "client save", 0),
  LeaseSeconds = prop.prop("Int", "client save", 0),
  ExtendCount = prop.prop("Int", "client save", 0),
  DisplayInfo = prop.prop("Dict", "client", {})
}
FormatProperties(GuildSeat)
local GuildSeatDict = Class("GuildSeatDict", CustomTypes.CustomDict)
GuildSeatDict.KeyType = BaseTypes.Int
GuildSeatDict.ValueType = GuildSeat
local GuildSeatPlanRef = Class("GuildSeatPlanRef", CustomTypes.CustomAttr)
GuildSeatPlanRef.__Props__ = {
  Uid = prop.prop("Int", "client save", 0),
  PlanId = prop.prop("Int", "client save", 0),
  LastShowTime = prop.prop("Int", "client save", 0),
  AppearanceScore = prop.prop("Int", "client save", 0),
  ActivityLevel = prop.prop("Int", "client save", 0)
}
FormatProperties(GuildSeatPlanRef)
local GuildSeatPlanRefList = Class("GuildSeatPlanRefList", CustomTypes.CustomList)
GuildSeatPlanRefList.ValueType = GuildSeatPlanRef
local GuildSeatPlanRefListDict = Class("GuildSeatPlanRefListDict", CustomTypes.CustomDict)
GuildSeatPlanRefListDict.KeyType = BaseTypes.Int
GuildSeatPlanRefListDict.ValueType = GuildSeatPlanRefList
return {
  GuildSeatPlan = GuildSeatPlan,
  GuildSeatPlanList = GuildSeatPlanList,
  GuildSeat = GuildSeat,
  GuildSeatDict = GuildSeatDict,
  GuildSeatPlanRef = GuildSeatPlanRef,
  GuildSeatPlanRefList = GuildSeatPlanRefList,
  GuildSeatPlanRefListDict = GuildSeatPlanRefListDict
}
