local M = {}
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")

function M:IsStorylineComplete(TalkTriggerId)
  return ImpressionModel:IsStorylineComplete(TalkTriggerId)
end

function M:IsStorylineUnComplete(TalkTriggerId)
  return ImpressionModel:IsStorylineUnComplete(TalkTriggerId)
end

function M:IsImpressionCheckSuccess(DialogueId)
  return ImpressionModel:IsImpressionCheckSuccess(DialogueId)
end

function M:IsImpressionCheckFailure(DialogueId)
  return ImpressionModel:IsImpressionCheckFailure(DialogueId)
end

return M
