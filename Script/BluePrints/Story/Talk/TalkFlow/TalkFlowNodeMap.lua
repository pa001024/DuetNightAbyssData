local M = {}
local FCheckOptionConditionNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Condition")
local FDialogueNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Dialogue")
local FOptionNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Option")
local FStartNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_Start")
local FEndNode = require("BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode_End")

function M:New(TalkTask, Comps, Events)
  local NodeMap = setmetatable({}, {__index = M})
  NodeMap.TalkTask = TalkTask
  NodeMap.Comps = Comps
  NodeMap.Events = Events
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
  local TalkTask = self.TalkTask
  local Comps = self.Comps
  local Events = self.Events
  if "Dialogue" == NodeType then
    Node = FDialogueNode:New(DialogueId, TalkTask, Comps, self, Events)
  elseif "Option" == NodeType then
    Node = FOptionNode:New(DialogueId, TalkTask, Comps, self, Events)
  elseif "CheckOptionCondition" == NodeType then
    Node = FCheckOptionConditionNode:New(DialogueId, TalkTask, Comps, self, Events)
  elseif "Start" == NodeType then
    Node = FStartNode:New(DialogueId, TalkTask, Comps, self, Events)
  elseif "End" == NodeType then
    Node = FEndNode:New(nil, TalkTask, nil, nil, Events)
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
