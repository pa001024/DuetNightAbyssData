local LayoutPlanNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function LayoutPlanNode:Execute()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Index = Avatar:GetCurrentMobileHudPlanIndex()
  if 1 == Index then
    return "OldPlan"
  else
    return "NewPlan"
  end
end

return LayoutPlanNode
