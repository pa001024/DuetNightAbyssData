local SetTimeOfDayNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")
local TIME_ELAPSE_TAG_PREFIX = "SetTimeOfDayNode_"

function SetTimeOfDayNode:Init()
  self.TargetTime = 0
  self.NeedLerp = false
  self.LerpTime = 0
  self.StopTimeElapse = false
end

function SetTimeOfDayNode:GetTimeElapseTag()
  return TIME_ELAPSE_TAG_PREFIX .. tostring(self.Key or "Unknown")
end

function SetTimeOfDayNode:Execute()
  if not self.EnvironmentManager or not IsValid(self.EnvironmentManager) then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    self.EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(Player, UE4.AEnvironmentManager:StaticClass())
  end
  self.EnvironmentManager:SetTimeOfDay(self.TargetTime, true, ESetTODReason.DesignSet, self.NeedLerp, self.LerpTime)
  local Tag = self:GetTimeElapseTag()
  if self.StopTimeElapse then
    self.EnvironmentManager:SetEnableTimeElapse(false, Tag)
  else
    self.EnvironmentManager:RevertEnableTimeElapse(Tag)
  end
end

return SetTimeOfDayNode
