local Class = _G.TypeClass
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local D4Season = Class("D4Season", CustomTypes.CustomAttr)
D4Season.__Props__ = {
  D4SeasonBuffLevels = prop.prop("Str2IntDict", "client"),
  Bag = prop.prop("D4SeasonBag.D4SeasonBag", "client"),
  D4SeasonItemModule = prop.prop("D4SeasonItemModule.D4SeasonItemModule", "client")
}
FormatProperties(D4Season)
return {D4Season = D4Season}
