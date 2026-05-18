local PlayerGenderBranchNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function PlayerGenderBranchNode:Execute()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return "女"
  end
  local Gender = self.IsEXPlayer and Avatar.WeitaSex or Avatar.Sex
  return 0 == Gender and "男" or "女"
end

return PlayerGenderBranchNode
