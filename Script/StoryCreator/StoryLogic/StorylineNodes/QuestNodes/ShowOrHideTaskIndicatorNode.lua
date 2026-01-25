local ShowOrHideTaskIndicatorNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")

function ShowOrHideTaskIndicatorNode:Init()
  self.IsShow = nil
  self.GuideType = nil
  self.GuideName = nil
  self.GuideRadius = nil
end

function ShowOrHideTaskIndicatorNode:Execute(Callback)
  self:ShowOrHideIndicator()
  Callback()
end

function ShowOrHideTaskIndicatorNode:ShowOrHideIndicator()
  if self.IsShow then
    MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
  else
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
end

function ShowOrHideTaskIndicatorNode:ClearWhenQuestSuccess()
  if self.IsShow then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
end

function ShowOrHideTaskIndicatorNode:ClearWhenQuestFail()
  if self.IsShow then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
end

return ShowOrHideTaskIndicatorNode
