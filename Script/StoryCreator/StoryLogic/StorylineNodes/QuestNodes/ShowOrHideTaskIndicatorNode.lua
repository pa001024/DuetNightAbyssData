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
  self:CreateOrDestoryEffect(self.bOpenRangeEffect)
end

function ShowOrHideTaskIndicatorNode:ClearWhenQuestSuccess()
  if self.IsShow then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
  self:CreateOrDestoryEffect(false)
end

function ShowOrHideTaskIndicatorNode:ClearWhenQuestFail()
  if self.IsShow then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
  self:CreateOrDestoryEffect(false)
end

function ShowOrHideTaskIndicatorNode:CreateOrDestoryEffect(bCreate)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local NewTargetPoint = GameState:GetTargetPoint(self.GuideName)
  if nil == NewTargetPoint then
    return
  end
  if bCreate then
    NewTargetPoint:SetTargetRangeEffect()
  else
    NewTargetPoint:DestoryTargetRangeEffect()
  end
end

return ShowOrHideTaskIndicatorNode
