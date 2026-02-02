local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local AccumulateRechargeRecord = Class("AccumulateRechargeRecord", CustomTypes.CustomAttr)
AccumulateRechargeRecord.__Props__ = {
  Score = prop.prop("Int", "client save", 0),
  GoodsId = prop.prop("Str", "client save"),
  TimeStamp = prop.prop("Int", "client save")
}

function AccumulateRechargeRecord:Init(Score, GoodsId, TimeStamp)
  self.Score = Score
  self.GoodsId = GoodsId
  self.TimeStamp = TimeStamp
end

FormatProperties(AccumulateRechargeRecord)
local AccumulateRechargeRecordList = Class("AccumulateRechargeRecordList", CustomTypes.CustomList)
AccumulateRechargeRecordList.ValueType = AccumulateRechargeRecord
local AccumulateRecharge = Class("AccumulateRecharge", CustomTypes.CustomAttr)
AccumulateRecharge.__Props__ = {
  Score = prop.prop("Int", "client save", 0),
  RewardGot = prop.prop("IntSet", "client save"),
  ScoreRecord = prop.prop("AccumulateRechargeRecordList", "client save")
}

function AccumulateRecharge:AddScore(Score, GoodsId, TimeStamp)
  self.Score = self.Score + Score
  self:AddRecord(Score, GoodsId, TimeStamp)
end

function AccumulateRecharge:AddRecord(Score, GoodsId, TimeStamp)
  self.ScoreRecord:Append(AccumulateRechargeRecord(Score, GoodsId, TimeStamp))
end

FormatProperties(AccumulateRecharge)
local AccumulateRechargeDict = Class("AccumulateRechargeDict", CustomTypes.CustomDict)
AccumulateRechargeDict.KeyType = BaseTypes.Int
AccumulateRechargeDict.ValueType = AccumulateRecharge

function AccumulateRechargeDict:New(EventId)
  self[EventId] = AccumulateRecharge()
  return self[EventId]
end

return {
  AccumulateRechargeRecord = AccumulateRechargeRecord,
  AccumulateRechargeRecordList = AccumulateRechargeRecordList,
  AccumulateRecharge = AccumulateRecharge,
  AccumulateRechargeDict = AccumulateRechargeDict
}
