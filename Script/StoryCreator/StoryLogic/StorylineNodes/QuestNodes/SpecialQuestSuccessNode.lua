local SpecialQuestSuccessNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")

function SpecialQuestSuccessNode:Execute(Callback)
  local CurrentEvent = ClientEventUtils:GetCurrentEvent()
  if not CurrentEvent or CurrentEvent.Type ~= "SpecialQuest" then
    local Message = "客户端不存在特殊任务" .. [[

FileName:]] .. self.Context.FileName .. [[

NodeInfo:]] .. self:ToString()
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.SpecialQuest, "客户端不存在特殊任务", Message)
  end
  DebugPrint("gyy@SpecialQuestSuccess,ExecuteSpecialQuestSuccessNode ", CurrentEvent.SpecialQuestId)
  
  local function FinishNodeCallback()
    Callback()
  end
  
  CurrentEvent:AddSuccessNodeCallback(self, FinishNodeCallback)
  CurrentEvent:TryFinishEvent("SuccessNode")
end

function SpecialQuestSuccessNode:Clear()
  local CurrentEvent = ClientEventUtils:GetCurrentEvent()
  if CurrentEvent and CurrentEvent.Type == "SpecialQuest" then
    CurrentEvent:RemoveSuccessNodeCallback(self)
  end
end

return SpecialQuestSuccessNode
