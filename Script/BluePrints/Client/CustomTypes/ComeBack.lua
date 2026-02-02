local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local ComeBack = Class("ComeBack", CustomTypes.CustomAttr)
ComeBack.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  EventSchemeId = prop.prop("Int", "client save"),
  LoginDay = prop.prop("Int", "client save", 0),
  LastLoginRefresh = prop.prop("Int", "client save", 0),
  BackRewardGot = prop.prop("Int", "client save", 0),
  ProgressRewardGot = prop.prop("Int2IntDict", "client save"),
  LoginRewardGot = prop.prop("Int2IntDict", "client save"),
  QuestProgress = prop.prop("Int", "client save", 0)
}

function ComeBack:Init(EventId, EventSchemeId)
  self.EventId = EventId
  self.EventSchemeId = EventSchemeId
end

function ComeBack:HasLoginRefreshToday()
  return TimeUtils.GetIntervalDay(self.LastLoginRefresh, TimeUtils.NowTime()) < 1
end

function ComeBack:LoginAdd()
  self.LoginDay = self.LoginDay + 1
  self.LastLoginRefresh = TimeUtils.NowTime()
end

function ComeBack:HasGotLoginReward(LoginDay)
  return 1 == self.LoginRewardGot[LoginDay]
end

function ComeBack:SetLoginRewardGot(LoginDay)
  self.LoginRewardGot[LoginDay] = 1
end

function ComeBack:HasGotBackReward()
  return 1 == self.BackRewardGot
end

function ComeBack:SetBackRewardGot()
  self.BackRewardGot = 1
end

function ComeBack:HasGotProgressReward(RewardIdx)
  return 1 == self.ProgressRewardGot[RewardIdx]
end

function ComeBack:SetProgressRewardGot(RewardIdx)
  self.ProgressRewardGot[RewardIdx] = 1
end

function ComeBack:AddQuestProgress(ProgressAdd)
  self.QuestProgress = self.QuestProgress + ProgressAdd
  return self.QuestProgress
end

FormatProperties(ComeBack)
local ComeBackDict = Class("ComeBackDict", CustomTypes.CustomDict)
ComeBackDict.KeyType = BaseTypes.Int
ComeBackDict.ValueType = ComeBack

function ComeBackDict:GetComeBack(EventId)
  return self[EventId]
end

function ComeBackDict:NewComeBack(EventId, EventSchemeId)
  return ComeBack(EventId, EventSchemeId)
end

function ComeBackDict:GetNewComeBack(EventId, EventSchemeId)
  if not self[EventId] then
    self[EventId] = self:NewComeBack(EventId, EventSchemeId)
  end
  return self[EventId]
end

return {ComeBack = ComeBack, ComeBackDict = ComeBackDict}
