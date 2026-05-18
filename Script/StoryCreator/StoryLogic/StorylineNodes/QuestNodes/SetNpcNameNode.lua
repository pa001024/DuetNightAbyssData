local SetNpcNameNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function SetNpcNameNode:Init()
  self.NpcId = 0
  self.HideNpcName = false
  self.TempNpcName = ""
  self.RestoreOriginalName = false
end

function SetNpcNameNode:Execute()
  if self.NpcId <= 0 then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not IsValid(GameState) then
    return
  end
  local CustomName
  if not self.RestoreOriginalName and self.TempNpcName and self.TempNpcName ~= "" then
    CustomName = self.TempNpcName
  end
  GameState:SetNpcNameOverride(self.NpcId, self.HideNpcName, CustomName)
end

function SetNpcNameNode:OnQuestlineFinish()
  if self.NpcId <= 0 then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not IsValid(GameState) then
    return
  end
  GameState:RemoveNpcNameOverride(self.NpcId)
end

return SetNpcNameNode
