local M = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function M:Init()
  self.StorylinePath = nil
  self.Callback = nil
  self.Storyline = nil
end

function M:Execute(Callback)
  self.Callback = Callback or function(OutPortName)
  end
  local bSucceed = GWorld.StoryMgr:RunStory(self.StorylinePath, nil, nil, function()
    self.Callback("End")
  end, function()
    self.Callback("Stop")
  end)
  if not bSucceed then
    DebugPrint(_G.WarningTag, "SubStoryLineNode Execute Failed, StorylinePath: ", self.StorylinePath)
    return
  end
  self.Storyline = GWorld.StoryMgr:GetStory(self.StorylinePath)
end

function M:Clear()
  GWorld.StoryMgr:StopStoryline(self.StorylinePath)
end

return M
