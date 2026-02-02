local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local TargetCounter = require("BluePrints.Client.CustomTypes.TargetCounter")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonQuestBase = Class("CommonQuestBase", CustomTypes.CustomAttr)
CommonQuestBase.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  FinishRewardGot = prop.prop("Int2IntDict", "client save"),
  AccumulateTarget = prop.prop("Int", "client save", 0)
}

function CommonQuestBase:Init(EventId)
  self.EventId = EventId
end

function CommonQuestBase:IsFinishRewardGot(Id)
  return 1 == self.FinishRewardGot[Id]
end

function CommonQuestBase:SetFinishRewardGot(Id)
  self.FinishRewardGot[Id] = 1
end

FormatProperties(CommonQuestBase)
local CommonQuestBaseDict = Class("CommonQuestBaseDict", CustomTypes.CustomDict)
CommonQuestBaseDict.KeyType = BaseTypes.Int
CommonQuestBaseDict.ValueType = CommonQuestBase

function CommonQuestBaseDict:GetCommonQuestBase(EventId)
  return self[EventId]
end

function CommonQuestBaseDict:NewCommonQuestBase(EventId)
  return CommonQuestBase(EventId)
end

function CommonQuestBaseDict:GetNewCommonQuestBase(EventId)
  if not self[EventId] then
    self[EventId] = self:NewCommonQuestBase(EventId)
  end
  return self[EventId]
end

local CommonQuestDict = Class("CommonQuestDict", CustomTypes.CustomDict)
CommonQuestDict.KeyType = BaseTypes.Int
CommonQuestDict.ValueType = TargetCounter.TargetCounterDict

function CommonQuestDict:NewCommonQuests()
  return TargetCounter.TargetCounterDict()
end

function CommonQuestDict:GetNewCommonQuests(EventId)
  if not self[EventId] then
    self[EventId] = self:NewCommonQuests()
  end
  return self[EventId]
end

function CommonQuestDict:GetCommonQuests(EventId)
  return self[EventId]
end

function CommonQuestDict:SetCommonQuests(EventId, CommonQuests)
  self[EventId] = CommonQuests
end

return {
  CommonQuestDict = CommonQuestDict,
  CommonQuestBase = CommonQuestBase,
  CommonQuestBaseDict = CommonQuestBaseDict
}
