local M = {}
local FCheckOptionConditionNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Condition")
local FDialogueNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Dialogue")
local FOptionNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Option")
local FStartNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Start")
local FEndNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_End")

function M:New(Context, Comps, NodeEvents, FlowChecker)
  local NodeMap = setmetatable({}, {__index = M})
  NodeMap.Context = Context
  NodeMap.Comps = Comps
  NodeMap.NodeEvents = NodeEvents
  NodeMap.FlowChecker = FlowChecker
  NodeMap.CheckConditionNodeMap = {}
  NodeMap.DialogueNodeMap = {}
  NodeMap.OptionNodeMap = {}
  return NodeMap
end

function M:GetOrCreateNode(NodeType, DialogueId)
  local Node = self:TryGetNode(NodeType, DialogueId)
  if nil ~= Node then
    return Node
  end
  local Context = self.Context
  local Comps = self.Comps
  local NodeEvents = self.NodeEvents
  local FlowChecker = self.FlowChecker
  if "Dialogue" == NodeType then
    Node = FDialogueNode:New(DialogueId, Context, NodeEvents, FlowChecker, Comps, self)
  elseif "Option" == NodeType then
    Node = FOptionNode:New(DialogueId, Context, NodeEvents, FlowChecker, Comps, self)
  elseif "CheckOptionCondition" == NodeType then
    Node = FCheckOptionConditionNode:New(DialogueId, Context, NodeEvents, FlowChecker, Comps, self)
  elseif "Start" == NodeType then
    Node = FStartNode:New(DialogueId, Context, NodeEvents, FlowChecker, Comps, self)
  elseif "End" == NodeType then
    Node = FEndNode:New(nil, Context, NodeEvents, FlowChecker, nil, nil)
  else
    DebugPrint("FTalkFlow:GetOrCreateNode: NodeType无效", NodeType)
    return
  end
  return Node
end

function M:TryGetNode(NodeType, DialogueId)
  local NodeMap
  if "Dialogue" == NodeType then
    NodeMap = self.DialogueNodeMap
  elseif "Option" == NodeType then
    NodeMap = self.OptionNodeMap
  elseif "CheckOptionCondition" == NodeType then
    NodeMap = self.CheckConditionNodeMap
  end
  return NodeMap and NodeMap[DialogueId]
end

return M
