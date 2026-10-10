local SwitchStoryModeNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function SwitchStoryModeNode:Init()
  self.IsOpen = false
end

function SwitchStoryModeNode:Execute()
  DebugPrint("-----------------------------------SwitchStoryModeNode-----------------------------------", self.IsOpen)
  self:SetStoryModeInternal(self.IsOpen)
end

function SwitchStoryModeNode:SetStoryModeInternal(bEnable)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  PlayerController:SetStoryModeState(bEnable, "SwitchStoryModeNode")
  self:UpdateCurrentSTLData()
end

function SwitchStoryModeNode:OnQuestlineSuccess()
  if not self.Context then
    return
  end
  self.Context:SaveSuitUpdateData("UpdateSuitKey2Value", CommonConst.SuitType.PlayerCharacterSuit, CommonConst.PlayerCharacterSuit.SwitchStoryMode, "IsInStoryMode", nil)
end

function SwitchStoryModeNode:UpdateCurrentSTLData()
  if not self.Context then
    return
  end
  self.Context:UpdateCurrentSTLData(CommonConst.QuestSuit.SwitchStoryMode, "IsInStoryMode", {
    IsAdd = self.IsOpen,
    Tag = "SwitchStoryModeNode"
  })
end

return SwitchStoryModeNode
