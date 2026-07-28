local Class = _G.TypeClass
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local GuildHomeVector3 = Class("GuildHomeVector3", CustomTypes.CustomAttr)
GuildHomeVector3.__Props__ = {
  X = prop.prop("Float", "client save", 0),
  Y = prop.prop("Float", "client save", 0),
  Z = prop.prop("Float", "client save", 0)
}
FormatProperties(GuildHomeVector3)
local GuildHomeLayoutInstance = Class("GuildHomeLayoutInstance", CustomTypes.CustomAttr)
GuildHomeLayoutInstance.__Props__ = {
  InstanceId = prop.prop("Str", "client save", ""),
  ComponentId = prop.prop("Int", "client save", 0),
  Position = prop.prop("GuildHomeVector3", "client save"),
  Rotation = prop.prop("GuildHomeVector3", "client save"),
  Scale = prop.prop("GuildHomeVector3", "client save"),
  Height = prop.prop("Float", "client save", 0),
  ParentId = prop.prop("Str", "client save", "")
}
FormatProperties(GuildHomeLayoutInstance)
local GuildHomeLayoutInstanceList = Class("GuildHomeLayoutInstanceList", CustomTypes.CustomList)
GuildHomeLayoutInstanceList.ValueType = GuildHomeLayoutInstance
local GuildHomePublishedLayout = Class("GuildHomePublishedLayout", CustomTypes.CustomAttr)
GuildHomePublishedLayout.__Props__ = {
  LayoutVersion = prop.prop("Int", "client save", 0),
  Performance = prop.prop("Int", "client save", 0),
  CategoryCounts = prop.prop("Int2IntDict", "client save", {}),
  InstanceList = prop.prop("GuildHomeLayoutInstanceList", "client save", {}),
  UpdateTime = prop.prop("Int", "client save", 0),
  OperatorUid = prop.prop("Int", "client save", 0)
}
FormatProperties(GuildHomePublishedLayout)
local GuildHomeBuildLock = Class("GuildHomeBuildLock", CustomTypes.CustomAttr)
GuildHomeBuildLock.__Props__ = {
  HolderUid = prop.prop("Int", "client save", 0),
  HolderName = prop.prop("Str", "client save", ""),
  LockTime = prop.prop("Int", "client save", 0),
  LastOpTime = prop.prop("Int", "client save", 0),
  SessionId = prop.prop("Str", "client save", "")
}
FormatProperties(GuildHomeBuildLock)
local GuildHomeHeat = Class("GuildHomeHeat", CustomTypes.CustomAttr)
GuildHomeHeat.__Props__ = {
  CurrentValue = prop.prop("Int", "client save", 0),
  RankValue = prop.prop("Int", "client save", 0),
  LastCalcTime = prop.prop("Int", "client save", 0),
  Buckets = prop.prop("Int2IntDict", "client save", {})
}
FormatProperties(GuildHomeHeat)
local GuildHomeData = Class("GuildHomeData", CustomTypes.CustomAttr)
GuildHomeData.__Props__ = {
  Version = prop.prop("Int", "client save", 0),
  Fund = prop.prop("Int", "client save", 0),
  ComponentInventory = prop.prop("Int2IntDict", "client save", {}),
  PublishedLayout = prop.prop("GuildHomePublishedLayout", "client save"),
  BuildLock = prop.prop("GuildHomeBuildLock", "client save"),
  Heat = prop.prop("GuildHomeHeat", "client save")
}
FormatProperties(GuildHomeData)
return {
  GuildHomeVector3 = GuildHomeVector3,
  GuildHomeLayoutInstance = GuildHomeLayoutInstance,
  GuildHomeLayoutInstanceList = GuildHomeLayoutInstanceList,
  GuildHomePublishedLayout = GuildHomePublishedLayout,
  GuildHomeBuildLock = GuildHomeBuildLock,
  GuildHomeHeat = GuildHomeHeat,
  GuildHomeData = GuildHomeData
}
