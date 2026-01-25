local DynamicQuestSuccessNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function DynamicQuestSuccessNode:Execute(Callback)
  local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
  local CurrentEvent = ClientEventUtils:GetCurrentDoingDynamicEvent()
  assert(CurrentEvent, "客户端不存在动态任务")
  
  local function CompositeCallback()
    if self.UseTalkFadeOut and self.TalkFadeOutTime then
      local TalkContext = GWorld.GameInstance:GetTalkContext()
      if TalkContext then
        local TalkBlackUI = TalkContext:GetSimpleBlackUI()
        if TalkBlackUI then
          TalkBlackUI:FadeOut(self.TalkFadeOutTime)
        end
      end
    end
    if Callback then
      Callback()
    end
  end
  
  CurrentEvent:TryFinishEvent(true, CompositeCallback, self.NodeId, self.DialogueId)
end

return DynamicQuestSuccessNode
