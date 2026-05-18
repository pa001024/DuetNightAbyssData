local FEFNode_PlayAudio = require("BluePrints.Story.Talk.TalkFlow.Nodes.DelegateNodes.EFNode_PlayAudio")
local FlowUtils = require("BluePrints.Story.ExecutionFlow.ExecutionFlowUtils")
local M = {}

function M:CreateFlow(DialogueId, TalkTask, OnFinished)
  local DialogueData = DataMgr.Dialogue[DialogueId]
  local DialogueScriptTable = DataMgr.DialogueConvert[DialogueId]
  local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkSubsystem)
  if nil == TalkSubsystem then
    DebugPrint("TalkFlowUtils@CreateFlow: Create flow failed: talk subsystem is nil")
    return nil
  end
  local Flow = TalkSubsystem:CreateDialogueFlow(DialogueId)
  Flow.DialogueId = DialogueId
  Flow.bAllowClick = DialogueData.bAllowClick
  Flow.OnFinish:Add(TalkSubsystem, function()
    TalkSubsystem:DestroyDialogueFlow(DialogueId)
    if OnFinished then
      OnFinished()
    end
  end)
  Flow.OnStop:Add(TalkSubsystem, function()
    TalkSubsystem:DestroyDialogueFlow(DialogueId)
    if OnFinished then
      OnFinished()
    end
  end)
  local StartNode = Flow.StartNode
  local FinishNode = Flow.FinishNode
  local ParallelNode = Flow:CreateNode(UEFNode_Parallel)
  local WaitAllNode = Flow:CreateNode(UEFNode_WaitAll)
  StartNode.FinishPin:LinkTo(ParallelNode.StartPin)
  ParallelNode.FinishPin:LinkTo(WaitAllNode.StartPin)
  WaitAllNode.FinishPin:LinkTo(FinishNode.StartPin)
  if DialogueScriptTable then
    local NodeStartPin, NodeFinishPin = FlowUtils:PARA(Flow, TalkTask, DialogueScriptTable.Operations)
    if NodeStartPin and NodeFinishPin then
      ParallelNode.FinishPin:LinkTo(NodeStartPin)
      NodeFinishPin:LinkTo(WaitAllNode.StartPin)
    end
  end
  return Flow, ParallelNode, WaitAllNode
end

function M:PlayAudioNode(Flow, TalkTask, Params)
  local PlayAudioNode = FEFNode_PlayAudio:CreateNode(Flow, TalkTask, Params)
  if nil == PlayAudioNode then
    return
  end
  return PlayAudioNode.StartPin, PlayAudioNode.FinishPin
end

return M
