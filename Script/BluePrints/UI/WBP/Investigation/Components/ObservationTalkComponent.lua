local TalkFlow_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlow")
local TalkFlowController_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlowController")
local ObservationTalkComponent = {}

function ObservationTalkComponent:PlayDialogue(DialogueId)
  if not DialogueId or not DataMgr.Dialogue[DialogueId] then
    return
  end
  self:StopTalkFlow()
  self.bObserveTalkFlowEnded = nil
  local TalkFlowController, TalkFlow = self:CreateObserveTalkFlow(DialogueId)
  if not TalkFlowController or not TalkFlow then
    return
  end
  GWorld.GameInstance.bTalkContextTickable = true
  self.CurrentFlow = TalkFlow
  self.CurrentFlowController = TalkFlowController
  TalkFlowController:Start()
end

function ObservationTalkComponent:CreateObserveTalkFlow(DialogueId)
  self.TalkTaskData = self.TalkTaskData or {}
  local TalkFlow = TalkFlow_C:New(DialogueId, "Observation", self)
  if not TalkFlow then
    return nil
  end
  TalkFlow:BindOnCheckAutoIterateEvent(self, self.IsAutoIterateDialogue)
  TalkFlow:BindOnDialogueEndEvent(self, self.OnObserveTalkFlowFinished)
  TalkFlow:BindOnFlowEndEvent(self, self.OnObserveTalkFlowEnded)
  TalkFlow:BuildFlow()
  if not TalkFlow.StartNode then
    return nil
  end
  local TalkFlowController = TalkFlowController_C:New(self)
  TalkFlowController:RegisterFlow(TalkFlow)
  return TalkFlowController, TalkFlow
end

function ObservationTalkComponent:IsAutoIterateDialogue()
  return self:IsAutoPlay()
end

function ObservationTalkComponent:OnAutoPlayEnabled()
  if self.CurrentFlowController then
    self.CurrentFlowController:ResumePendingIterate()
  end
end

function ObservationTalkComponent:OnObserveTalkFlowFinished()
  if self.bObserveTalkFlowEnded then
    return
  end
  self.bObserveTalkFlowEnded = true
  self:OnObserveCompleted()
end

function ObservationTalkComponent:OnObserveTalkFlowEnded()
  self.CurrentFlow = nil
  self.CurrentFlowController = nil
end

function ObservationTalkComponent:SkipTalkFlow()
  if self.CurrentFlowController then
    self.CurrentFlowController:SkipToEnd()
  end
end

function ObservationTalkComponent:StopTalkFlow()
  self.bObserveTalkFlowEnded = nil
  if self.CurrentFlowController then
    self.CurrentFlowController:Stop()
  end
end

function ObservationTalkComponent:ClearTalkFlow()
  self:StopTalkFlow()
  GWorld.GameInstance.bTalkContextTickable = false
end

function ObservationTalkComponent:SkipCurrentDialogue()
  local FlowController = self.CurrentFlowController
  local CurrentFlow = FlowController and FlowController.TalkFlow
  local CurrentNode = CurrentFlow and CurrentFlow:GetCurrentNode()
  if CurrentFlow and CurrentFlow:GetCurrentNode() == CurrentNode then
    FlowController:RequestSkipDialogue()
  end
end

return ObservationTalkComponent
