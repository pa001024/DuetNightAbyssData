local FCheckOptionConditionNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Condition")
local FDialogueNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Dialogue")
local FOptionNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Option")
local FStartNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Start")
local FEndNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_End")
local TalkFlowController = require("BluePrints.Story.Talk.TalkFlow.TalkFlowController")
local M = {}

function M:GetOrCreateNode(NodeType, DialogueId, Comps, NodeMaps, Events)
  local Flow = TalkFlowController:GetTalkFlow()
  local Node = self:TryGetNode(NodeType, DialogueId, NodeMaps)
  if nil ~= Node then
    return Node
  end
  if "Dialogue" == NodeType then
    Node = FDialogueNode:New(DialogueId, Comps, NodeMaps, Events)
  elseif "Option" == NodeType then
    Node = FOptionNode:New(DialogueId, Comps, NodeMaps, Events)
  elseif "CheckOptionCondition" == NodeType then
    Node = FCheckOptionConditionNode:New(DialogueId, Comps, NodeMaps, Events)
  elseif "Start" == NodeType then
    Node = FStartNode:New(DialogueId, Comps, NodeMaps, Events)
  elseif "End" == NodeType then
    Node = FEndNode:New(nil, nil, nil, Events)
  else
    DebugPrint("FTalkFlow:GetOrCreateNode: NodeType无效", NodeType)
    return
  end
  return Node
end

function M:TryGetNode(NodeType, DialogueId, NodeMaps)
  if not NodeMaps then
    return
  end
  local NodeMap
  if "Dialogue" == NodeType then
    local NodeMap = NodeMaps.DialogueNodeMap
  elseif "Option" == NodeType then
    local NodeMap = NodeMaps.OptionNodeMap
  elseif "CheckOptionCondition" == NodeType then
    local NodeMap = NodeMaps.CheckConditionNodeMap
  end
  return NodeMap and NodeMap[DialogueId]
end

function M:CreateDialogueFlow(DialogueId, OnFinished)
  local DialogueScriptTable = DataMgr.DialogueConvert[DialogueId]
  if not DialogueScriptTable or not DialogueScriptTable.Operations then
    if OnFinished then
      OnFinished()
    end
    return nil
  end
  local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkSubsystem)
  if nil == TalkSubsystem then
    DebugPrint("LogExecutionFlow:Error: Create flow failed: talk subsystem is nil")
    return nil
  end
  local Flow = TalkSubsystem:CreateDialogueFlow(DialogueId)
  Flow.DialogueId = DialogueId
  Flow.bAllowClick = DialogueScriptTable.bAllowClick
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
  local NodeStartPin, NodeFinishPin = self:PARA(Flow, DialogueScriptTable.Operations)
  if NodeStartPin and NodeFinishPin then
    StartNode.FinishPin:LinkTo(NodeStartPin)
    NodeFinishPin:LinkTo(FinishNode.StartPin)
  else
    StartNode.FinishPin:LinkTo(FinishNode.StartPin)
  end
  return Flow
end

function M:SEQ(Flow, Operations)
  local StartPin, FinishPin
  for _, Operation in ipairs(Operations) do
    for FunctionName, Params in pairs(Operation) do
      local NodeStartPin, NodeFinishPin = self[FunctionName](self, Flow, Params)
      if NodeStartPin and NodeFinishPin then
        StartPin = StartPin or NodeStartPin
        if FinishPin then
          FinishPin:LinkTo(NodeStartPin)
        end
        FinishPin = NodeFinishPin
      end
    end
  end
  return StartPin, FinishPin
end

function M:PARA(Flow, Operations)
  local StartPin, FinishPin
  local ParallelNode = Flow:CreateNode(UEFNode_Parallel)
  local WaitAllNode = Flow:CreateNode(UEFNode_WaitAll)
  for _, Operation in ipairs(Operations) do
    for FunctionName, Params in pairs(Operation) do
      local NodeStartPin, NodeFinishPin = self[FunctionName](self, Flow, Params)
      if NodeStartPin and NodeFinishPin then
        if not StartPin then
          StartPin = ParallelNode.StartPin
          FinishPin = WaitAllNode.FinishPin
        end
        ParallelNode.FinishPin:LinkTo(NodeStartPin)
        NodeFinishPin:LinkTo(WaitAllNode.StartPin)
      end
    end
  end
  return StartPin, FinishPin
end

return M
