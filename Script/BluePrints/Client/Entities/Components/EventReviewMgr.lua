local Component = {}
local CommonConst = require("CommonConst")
local EventReviewUtils = require("Utils.EventReviewUtils")

local function RequestStringBoardReddotSync()
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  StringBoardReddotHelper.RequestSyncAllNews()
end

function Component:_OnPropChangeEventReviewPages(Keys)
  RequestStringBoardReddotSync()
end

function Component:TrackEventReviewQuestChain(ReviewId, InCallback)
  self.logger.debug("TrackEventReviewQuestChain Begin", ReviewId)
  
  local function Callback(Ret)
    self.logger.debug("TrackEventReviewQuestChain Callback ", Ret, ReviewId)
    if InCallback then
      InCallback(Ret, ReviewId)
    end
  end
  
  self:CallServer("TrackEventReviewQuestChain", Callback, ReviewId)
end

function Component:IsReviewChainSequenceShow(ReviewChainSequenceId)
  local PreReviewChainSequenceId = EventReviewUtils:GetPreSequenceId(ReviewChainSequenceId)
  if not PreReviewChainSequenceId then
    return false
  end
  if PreReviewChainSequenceId ~= CommonConst.DefaultNoReviewChainSequenceId then
    return self:IsReviewChainSequenceExplored(PreReviewChainSequenceId)
  end
  local SequenceData = DataMgr.ReviewChain[ReviewChainSequenceId]
  local FirstShowCondition = SequenceData.FirstShowCondition
  if not FirstShowCondition then
    self.logger.error("IsReviewChainSequenceShow FirstShowCondition is nil", ReviewChainSequenceId)
    return false
  end
  return self:CheckCondition(FirstShowCondition)
end

function Component:IsReviewChainSequenceExplored(ReviewChainSequenceId)
  local SequenceData = DataMgr.ReviewChain[ReviewChainSequenceId]
  if not SequenceData then
    return false
  end
  local ReviewIds = SequenceData.ReviewChainMain
  for _, ReviewId in ipairs(ReviewIds) do
    local Review = self.EventReviewPages:GetEventReview(ReviewId)
    if not Review then
      return false
    end
    if not Review:IsExplored() then
      return false
    end
  end
  return true
end

return Component
