local M = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function M:Init()
  self.IsShow = true
  self.HideTag = "ShowOrHideBattlePetNode"
end

function M:Execute()
  self.PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if IsValid(self.PlayerCharacter) and self.PlayerCharacter.HideBattlePet then
    self.PlayerCharacter:HideBattlePet(self.HideTag, not self.IsShow)
  end
end

function M:Clear()
end

function M:OnStop()
  self:ClearBattlePetHideTag()
end

function M:OnQuestlineFinish()
  self:ClearBattlePetHideTag()
end

function M:ClearBattlePetHideTag()
  if IsValid(self.PlayerCharacter) and self.PlayerCharacter.HideBattlePet then
    self.PlayerCharacter:HideBattlePet(self.HideTag, false)
  end
  self.PlayerCharacter = nil
end

return M
