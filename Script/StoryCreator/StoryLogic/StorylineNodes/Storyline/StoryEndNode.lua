local StoryEndNode = Class("StoryCreator.StoryLogic.StorylineNodes.Node")
StoryEndNode.IsEndNode = true
StoryEndNode.EndResult = true

function StoryEndNode:Start(Context)
  self:Finish()
end

function StoryEndNode:SetEndResult(EndResult)
  self.EndResult = EndResult
end

function StoryEndNode:GetEndResult()
  return self.EndResult
end

return StoryEndNode
