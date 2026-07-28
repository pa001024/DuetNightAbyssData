local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local RaceLotteryHistory = Class("RaceLotteryHistory", CustomTypes.CustomAttr)
RaceLotteryHistory.__Props__ = {
  RecordTime = prop.prop("Int", "client save"),
  Income = prop.prop("Int", "client save", 0),
  Hit = prop.prop("Int", "client save", 0),
  Total = prop.prop("Int", "client save", 0)
}
FormatProperties(RaceLotteryHistory)
local RaceLotteryHistoryList = Class("RaceLotteryHistoryList", CustomTypes.CustomList)
RaceLotteryHistoryList.ValueType = RaceLotteryHistory

function RaceLotteryHistoryList:NewRecord()
  return RaceLotteryHistory()
end

local RaceLotteryInfo = Class("RaceLotteryInfo", CustomTypes.CustomAttr)
RaceLotteryInfo.__Props__ = {
  RaceLotteryHistoryList = prop.prop("RaceLotteryHistoryList", "client save", {}),
  RaceLotteryRumorList = prop.prop("Int2IntListDict", "client save", {}),
  RaceLotteryPlayerList = prop.prop("IntList", "client save", {}),
  RaceLotteryAnteNum = prop.prop("Int", "client save", 0),
  RaceLotteryTime = prop.prop("Int", "client save", -1),
  RaceLotteryGotReward = prop.prop("Bool", "client save", false)
}
FormatProperties(RaceLotteryInfo)
return {
  RaceLotteryHistory = RaceLotteryHistory,
  RaceLotteryHistoryList = RaceLotteryHistoryList,
  RaceLotteryInfo = RaceLotteryInfo
}
