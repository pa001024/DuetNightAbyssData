local Class = _G.TypeClass
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local D4SeasonBag = Class("D4SeasonBag", CustomTypes.CustomAttr)
D4SeasonBag.__Props__ = {
  Capacity = prop.prop("Int", "client", 100),
  Slots = prop.prop("D4Resource.D4ResourceSlotDict", "client")
}
FormatProperties(D4SeasonBag)
return {D4SeasonBag = D4SeasonBag}
