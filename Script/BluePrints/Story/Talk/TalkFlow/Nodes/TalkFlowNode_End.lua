local EDialogueNodeType = require("BluePrints.Story.Talk.View.TalkUtils").EDialogueNodeType
local M = Class({
  "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode"
})
M.NodeType = EDialogueNodeType.End

function M:BuildNode()
end

function M:Execute(bSkip)
  if bSkip then
    return
  end
  if self.OnDialogueEnd then
    self.OnDialogueEnd()
  end
end

function M:Iterate(...)
  local Message = "TalkFlow:尝试在EndNode进行Iterate，对话FirstDialogue：" .. self.Flow.InitialDialogueId
  local Title = "FStoryIterationGraph迭代错误"
  UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
end

return M
