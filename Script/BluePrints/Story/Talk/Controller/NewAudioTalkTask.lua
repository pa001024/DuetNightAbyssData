local TalkAudioComp_C = require("BluePrints.Story.Talk.Controller.TalkAudioComp")
local TalkFlowUtils = require("BluePrints.Story.Talk.TalkFlow.TalkFlowUtils")
local TalkFlow_C = require("BluePrints.Story.Talk.TalkFlow.TalkFlow")
local M = Class("BluePrints.Story.Talk.Controller.TalkTaskBase")

function M:Start(TalkTaskData, NodeFinished_Callback)
  M.Super.Start(self, TalkTaskData, NodeFinished_Callback)
  self.TalkTaskData = TalkTaskData
  self.NodeFinished_Callback = NodeFinished_Callback
  self.bCleared = false
  self.TalkFlow = nil
  self.TalkAudioComp = TalkAudioComp_C.New()
  AudioManager(GWorld.GameInstance):AddAuANotifyForbidTag(self.UnitKey)
  if not self.TalkTaskData.FirstDialogueId or not DataMgr.Dialogue[self.TalkTaskData.FirstDialogueId] then
    self:EndDialogue()
    return
  end
  self:StartTalkFlow()
end

function M:StartTalkFlow()
  self.TalkFlow = self:CreateTalkFlow()
  if not self.TalkFlow then
    self:EndDialogue()
    return
  end
  self.TalkFlow:Start()
end

function M:CreateTalkFlow()
  local FirstDialogueId = self.TalkTaskData.FirstDialogueId
  local Comps = {
    RecordComp = self.DialogueRecordComponent
  }
  local TalkFlow = TalkFlow_C:New(FirstDialogueId, self, Comps)
  TalkFlow:BindOnFlowCreatedEvent(self, self.OnFlowCreated)
  TalkFlow:BuildFlow()
  return TalkFlow
end

function M:OnFlowCreated(SubFlow, ParallelNode, WaitAllNode)
  local DialogueData = DataMgr.Dialogue[SubFlow.DialogueId]
  local NodeStartPin, NodeFinishPin = TalkFlowUtils:PlayAudioNode(SubFlow, self, {
    VoiceName = DialogueData and DialogueData.VoiceName,
    OverrideAttachActor = self.TalkTaskData.AudioAttachActor,
    bIsAttachActor = IsValid(self.TalkTaskData.AudioAttachActor)
  })
  if NodeStartPin and NodeFinishPin then
    ParallelNode.FinishPin:LinkTo(NodeStartPin)
    NodeFinishPin:LinkTo(WaitAllNode.StartPin)
  end
end

function M:EndDialogue()
  if self.bCleared then
    return
  end
  self.TalkFlow = nil
  self:Clear()
  if self.NodeFinished_Callback and self.NodeFinished_Callback[2] then
    local NodeFinished_Obj = self.NodeFinished_Callback[1]
    local NodeFinished_Func = self.NodeFinished_Callback[2]
    NodeFinished_Func(NodeFinished_Obj, self)
  end
end

function M:Clear()
  if self.bCleared then
    return
  end
  self.bCleared = true
  M.Super.Clear(self)
  AudioManager(GWorld.GameInstance):RemoveAuANotifyForbidTag(self.UnitKey)
  self:ClearAudio()
end

function M:OnInterrupted()
  if self.TalkFlow then
    self.TalkFlow:Stop()
    self.TalkFlow = nil
  end
  self:Clear()
end

function M:OnPaused()
  if self.TalkFlow then
    self.TalkFlow:Pause()
  else
    self:PauseAudio()
  end
end

function M:OnPauseResumed()
  if self.TalkFlow then
    self.TalkFlow:Resume()
  else
    self:ResumePauseAudio()
  end
end

return M
