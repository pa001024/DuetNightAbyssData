local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local EventReview = Class("EventReview", CustomTypes.CustomAttr)
EventReview.__Props__ = {
  ReviewId = prop.prop("Int", "client save"),
  State = prop.prop("Int", "client save", CommonConst.EventReviewState.WaitExplore),
  FinishCondition = prop.getter("Data", "FinishCondition"),
  UnlockCondition = prop.getter("Data", "UnlockCondition"),
  QuestChainId = prop.getter("Data", "QuestChainId")
}

function EventReview:Init(ReviewId)
  self.ReviewId = ReviewId
end

function EventReview:Data()
  return DataMgr.Review[self.ReviewId]
end

function EventReview:GetState()
  return self.State
end

function EventReview:IsExploring()
  return self:GetState() == CommonConst.EventReviewState.Exploring
end

function EventReview:IsExplored()
  return self:GetState() == CommonConst.EventReviewState.Explored
end

function EventReview:TrySetState(NewState)
  if not CommonUtils.HasValue(CommonConst.EventReviewState, NewState) then
    return false
  end
  if NewState <= self:GetState() then
    return false
  end
  self.State = NewState
  return true
end

FormatProperties(EventReview)
local EventReviewDict = Class("EventReviewDict", CustomTypes.CustomDict)
EventReviewDict.KeyType = BaseTypes.Int
EventReviewDict.ValueType = EventReview

function EventReviewDict:GetEventReview(ReviewId)
  local Review = self:Get(ReviewId)
  if Review then
    return Review
  end
  return self:_NewEventReview(ReviewId)
end

function EventReviewDict:_NewEventReview(ReviewId)
  if not DataMgr.Review[ReviewId] then
    return
  end
  local Review = EventReview(ReviewId)
  self:AddValue(ReviewId, Review)
  return self:GetEventReview(ReviewId)
end

local EventReviewPage = Class("EventReviewPage", CustomTypes.CustomAttr)
EventReviewPage.__Props__ = {
  ReviewPageId = prop.prop("Int", "client save"),
  Reviews = prop.prop("EventReviewDict", "client save")
}

function EventReviewPage:Init(ReviewPageId)
  self.ReviewPageId = ReviewPageId
  self:Rebuild()
end

function EventReviewPage:Rebuild()
  for ReviewId, ReviewPageId in pairs(DataMgr.ReviewId2ReviewChainPageId) do
    if ReviewPageId == self.ReviewPageId then
      self:GetEventReview(ReviewId)
    end
  end
end

function EventReviewPage:Data()
  return DataMgr.ReviewPage[self.ReviewPageId]
end

function EventReviewPage:GetReviewPageId()
  return self.ReviewPageId
end

function EventReviewPage:GetEventReview(ReviewId)
  local Review = self.Reviews:Get(ReviewId)
  if Review then
    return Review
  end
  return self:_NewEventReview(ReviewId)
end

function EventReviewPage:_NewEventReview(ReviewId)
  if DataMgr.ReviewId2ReviewChainPageId[ReviewId] ~= self.ReviewPageId then
    return
  end
  return self.Reviews:GetEventReview(ReviewId)
end

FormatProperties(EventReviewPage)
local EventReviewPageDict = Class("EventReviewPageDict", CustomTypes.CustomDict)
EventReviewPageDict.KeyType = BaseTypes.Int
EventReviewPageDict.ValueType = EventReviewPage

function EventReviewPageDict:GetEventReviewPage(ReviewPageId)
  local ReviewPage = self:Get(ReviewPageId)
  if ReviewPage then
    return ReviewPage
  end
  return self:_NewEventReviewPage(ReviewPageId)
end

function EventReviewPageDict:GetEventReview(ReviewId)
  local ReviewPageId = DataMgr.ReviewId2ReviewChainPageId[ReviewId]
  if not ReviewPageId then
    return
  end
  local ReviewPage = self:GetEventReviewPage(ReviewPageId)
  if not ReviewPage then
    return
  end
  local Review = ReviewPage:GetEventReview(ReviewId)
  if not Review then
    return
  end
  return Review, ReviewPage
end

function EventReviewPageDict:_NewEventReviewPage(ReviewPageId)
  if not DataMgr.ReviewPage[ReviewPageId] then
    return
  end
  local ReviewPage = EventReviewPage(ReviewPageId)
  self:AddValue(ReviewPageId, ReviewPage)
  return self:GetEventReviewPage(ReviewPageId)
end

return {
  EventReview = EventReview,
  EventReviewDict = EventReviewDict,
  EventReviewPage = EventReviewPage,
  EventReviewPageDict = EventReviewPageDict
}
