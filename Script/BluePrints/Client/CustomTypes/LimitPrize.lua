local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local LimitPrizeRecord = Class("LimitPrizeRecord", CustomTypes.CustomAttr)
LimitPrizeRecord.__Props__ = {
  TimeStamp = prop.prop("Int", "client save"),
  Round = prop.prop("Int", "client save"),
  PrizeIndex = prop.prop("Int", "client save"),
  SelfSelectId = prop.prop("Int", "client save", 0)
}

function LimitPrizeRecord:Init(TimeStamp, Round, PrizeIndex, SelfSelectId)
  self.TimeStamp = TimeStamp
  self.Round = Round
  self.PrizeIndex = PrizeIndex
  self.SelfSelectId = SelfSelectId
end

FormatProperties(LimitPrizeRecord)
local LimitPrizeRecordList = Class("LimitPrizeRecordList", CustomTypes.CustomList)
LimitPrizeRecordList.ValueType = LimitPrizeRecord
local LimitPrize = Class("LimitPrize", CustomTypes.CustomAttr)
LimitPrize.__Props__ = {
  Round = prop.prop("Int", "client save", 0),
  DrawCounts = prop.prop("Int", "client save", 0),
  Prizes = prop.prop("IntList", "save"),
  SelfSelect = prop.prop("Int2IntDict", "client save", {}),
  HasDrawPrizes = prop.prop("IntList", "client save"),
  Record = prop.prop("LimitPrizeRecordList", "client save")
}

function LimitPrize:IsRoundEnd()
  return self.DrawCounts == self.Prizes:Length()
end

function LimitPrize:AddRecord(TimeStamp, Round, PrizeIndex, SelfSelectId)
  local Record = LimitPrizeRecord(TimeStamp, Round, PrizeIndex, SelfSelectId)
  self.Record:Append(Record)
end

FormatProperties(LimitPrize)
local LimitPrizeDict = Class("LimitPrizeDict", CustomTypes.CustomDict)
LimitPrizeDict.KeyType = BaseTypes.Int
LimitPrizeDict.ValueType = LimitPrize

function LimitPrizeDict:New()
  return LimitPrize()
end

return {
  LimitPrize = LimitPrize,
  LimitPrizeDict = LimitPrizeDict,
  LimitPrizeRecord = LimitPrizeRecord,
  LimitPrizeRecordList = LimitPrizeRecordList
}
