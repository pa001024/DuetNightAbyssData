local WaitingObservationFinishNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function WaitingObservationFinishNode:Init()
  self.SequencePath = nil
  self.PauseMark = nil
end

function WaitingObservationFinishNode:Execute(Callback)
  Callback()
end

function WaitingObservationFinishNode:Clear()
end

return WaitingObservationFinishNode
