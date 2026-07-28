local Class = _G.TypeClass
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local MonthlyCheck = Class("MonthlyCheck", CustomTypes.CustomAttr)
MonthlyCheck.__Props__ = {
  Year = prop.prop("Int", "client save", 0),
  Month = prop.prop("Int", "client save", 0),
  CheckCount = prop.prop("Int", "client save", 0),
  MonthlyCheckCount = prop.prop("Int", "client save", 0),
  LastCheckTime = prop.prop("Int", "client save", 0),
  LastPopupTime = prop.prop("Int", "client save", 0),
  DailyRewardRecord = prop.prop("Int2IntDict", "client save", {}),
  TotalRewardRecord = prop.prop("Int2IntDict", "client save", {})
}
FormatProperties(MonthlyCheck)
return {MonthlyCheck = MonthlyCheck}
