local TalkFlow_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlow")
local TalkFlowController_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlowController")
local TalkFlowUtils = require("BluePrints.Story.Talk.TalkFlow.TalkFlowUtils")
local ObservationTalkComponent = {}

function ObservationTalkComponent:PlayDialogue(DialogueId)
  if not DialogueId or not DataMgr.Dialogue[DialogueId] then
    return
  end
  self:StopTalkFlow()
  local TalkFlowController, TalkFlow = self:CreateObserveTalkFlow(DialogueId)
  if not TalkFlowController or not TalkFlow then
    return
  end
  self:SetPanelState(self.PanelState.Dialog)
  self:UpdateKeyState("Dialog")
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
  TalkFlow:BindOnFlowCreatedEvent(self, self.OnObserveSubFlowCreated)
  TalkFlow:BindOnFlowEndEvent(self, self.OnObserveTalkFlowEnded)
  TalkFlow:BuildFlow()
  if not TalkFlow.StartNode then
    return nil
  end
  local TalkFlowController = TalkFlowController_C:New(self)
  TalkFlowController:RegisterFlow(TalkFlow)
  return TalkFlowController, TalkFlow
end

function ObservationTalkComponent:OnObserveSubFlowCreated(SubFlow, ParallelNode, WaitAllNode)
  local DialogueData = DataMgr.Dialogue[SubFlow.DialogueId]
  if not DialogueData then
    return
  end
  local TypingNode = TalkFlowUtils:TypingTextNode(SubFlow, self, {
    DialogueData = DialogueData,
    NameWidget = self.NpcNameText,
    TypingWidget = self.TypingText
  })
  if TypingNode then
    TalkFlowUtils:LinkChain({
      ParallelNode,
      TypingNode,
      WaitAllNode
    })
  end
end

function ObservationTalkComponent:OnObserveTalkFlowEnded()
  self.CurrentFlow = nil
  self.CurrentFlowController = nil
  self:OnObserveCompleted()
  self:UpdateKeyState("Normal")
end

function ObservationTalkComponent:EndDialogue()
  if self.CurrentFlow then
    self.CurrentFlow:End()
  end
end

function ObservationTalkComponent:StopTalkFlow()
  if self.CurrentFlowController then
    self.CurrentFlowController:Stop()
    return
  end
  if self.CurrentFlow then
    self.CurrentFlow:Stop()
  end
end

function ObservationTalkComponent:ClearTalkFlow()
  self:StopTalkFlow()
end

return ObservationTalkComponent
