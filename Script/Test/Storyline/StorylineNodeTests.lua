local M = Class()

function M:ReceiveStartTest()
  local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
  local WaitOfTimeNode = StorylineUtils.CreateQuestNode("WaitOfTimeNode")
  WaitOfTimeNode.WaitTime = 1
  WaitOfTimeNode:Execute(function()
    self:FinishTest(UE4.EFunctionalTestResult.Succeeded, "Test succeeded")
  end)
end

return M
