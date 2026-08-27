local ShowOrHideUINode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")

function ShowOrHideUINode:Init()
  self.Function = nil
  self.UIParam = nil
  self.ActionParam = nil
  self.ShowOrHide = false
end

function ShowOrHideUINode:Start(Context)
  self.Context = Context
  local GameInstance = GWorld.GameInstance
  local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
  DebugPrint("ShowOrHideUINode: Start", self.Function, self.UIParam, self.ActionParam, self.ShowOrHide)
  if self.Function == "HideUIInScreen" then
    if GameMode and GameMode.HideUIInScreen then
      GameMode:HideUIInScreen(self.UIParam, self.ShowOrHide, "ShowOrHideUINode")
      DebugPrint("ShowOrHideUINode: Start self.RealSetVisibility", self.RealSetVisibility)
    end
  elseif self.Function == "SetContinuedPCGuideVisibility" and GameMode.SetContinuedPCGuideVisibility then
    GameMode:SetContinuedPCGuideVisibility(self.ActionParam, self.ShowOrHide, "ShowOrHideUINode")
  end
  self:UpdateCurrentSTLData()
  self:FinishAction()
end

function ShowOrHideUINode:FinishAction()
  self:Finish()
end

function ShowOrHideUINode:OnQuestlineSuccess()
  if not self.Context then
    return
  end
  if self.Function == "HideUIInScreen" then
    self.Context:SaveSuitUpdateData("UpdateSuitKey2Value", CommonConst.SuitType.PlayerCharacterSuit, CommonConst.PlayerCharacterSuit.HideUIInScreen, self.UIParam, nil)
  elseif self.Function == "SetContinuedPCGuideVisibility" then
    self.Context:SaveSuitUpdateData("UpdateSuitKey2Value", CommonConst.SuitType.PlayerCharacterSuit, CommonConst.PlayerCharacterSuit.ContinuedGuide, self.ActionParam, nil)
  end
end

function ShowOrHideUINode:UpdateCurrentSTLData()
  if not self.Context then
    return
  end
  if self.Function == "HideUIInScreen" then
    self.Context:UpdateCurrentSTLData(CommonConst.QuestSuit.HideUIInScreen, self.UIParam, {
      IsHide = self.ShowOrHide,
      Tag = "ShowOrHideUINode"
    })
  elseif self.Function == "SetContinuedPCGuideVisibility" then
    self.Context:UpdateCurrentSTLData(CommonConst.QuestSuit.ContinuedGuide, self.ActionParam, {
      IsHide = self.ShowOrHide,
      Tag = "ShowOrHideUINode"
    })
  end
end

return ShowOrHideUINode
