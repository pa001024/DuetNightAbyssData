local LookToHookNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode")

function LookToHookNode:Init()
  self.StaticCreatorIdList = {}
  self.bOpenNode = true
  self.DurationTime = 3
end

function LookToHookNode:Execute()
  local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
  GameState.LookHookTime = self.DurationTime
  if self.bOpenNode then
    for i, v in pairs(self.StaticCreatorIdList) do
      print(_G.LogTag, "LXZ LookToHookNode:Execute()", v)
      GameState:AddHookLookToList(v)
    end
  else
    GameState.HookLookToList:Clear()
  end
  return nil
end

function LookToHookNode:Clear()
end

function LookToHookNode:OnQuestlineFinish()
  ScreenPrint("lxz TestPrintNode:OnQuestlineFinish")
  local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
  GameState.HookLookToList:Clear()
end

return LookToHookNode
