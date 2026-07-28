local LayoutPlanNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function LayoutPlanNode:Execute()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Index = Avatar:GetCurrentMobileHudPlanIndex()
  local LayoutEntryIndex = Avatar.GetLayoutEntryIndexByPlanIndex and Avatar:GetLayoutEntryIndexByPlanIndex(Index) or Index
  if 1 == LayoutEntryIndex then
    return "OldPlan"
  else
    return "NewPlan"
  end
end

return LayoutPlanNode
