local EDialogueIterType = require("BluePrints.Story.Talk.View.TalkUtils").EDialogueIterType
local M = Class()

function M:New(DialogueId, Context, NodeEvents, FlowChecker, Comps, NodeMaps)
  local TalkFlowNode = setmetatable({}, {__index = self})
  rawset(TalkFlowNode, "Context", Context)
  rawset(TalkFlowNode, "Comps", Comps)
  rawset(TalkFlowNode, "NodeMaps", NodeMaps)
  rawset(TalkFlowNode, "FlowChecker", FlowChecker)
  TalkFlowNode:BindNodeEvents(NodeEvents)
  TalkFlowNode:BuildNode(DialogueId, Comps)
  return TalkFlowNode
end

function M:CreateNextNodeMap()
  rawset(self, "NextNodeMap", {})
end

function M:BuildNode(DialogueId)
  if not DialogueId or not DataMgr.Dialogue[DialogueId] then
    DebugPrint("FTalkFlowNode:BuildNode, Dialogue is nil, DialogueId: ", DialogueId, self.NodeType)
    return
  end
  self:CreateNextNodeMap()
  self:CreateNodeData(DialogueId)
  self:GenerateNextNodes()
end

function M:Enter(bSkip)
  if self.OnNodeEnter then
    self.OnNodeEnter(self)
  end
  self:Execute(bSkip)
end

function M:Record(...)
  if self.bRecorded then
    return
  end
  self.bRecorded = true
end

function M:Execute(bSkip)
end

function M:Pause()
end

function M:Resume()
end

function M:Stop()
end

function M:RealSkip()
end

function M:AllowSkip()
  return true
end

function M:Skip()
  if not self:AllowSkip() then
    return false
  end
  self:RealSkip()
  local NextNode = self:GetOutPort(EDialogueIterType.Out)
  if NextNode then
    NextNode:Enter(true)
  end
  return false
end

function M:RecordNodeInMap(DialogueId, NodeMaps)
end

function M:BindNodeEvents(NodeEvents)
  self.OnNodeEnter = NodeEvents.OnNodeEnter
  self.OnNodeCreated = NodeEvents.OnNodeCreated
  self.OnFlowCreated = NodeEvents.OnFlowCreated
  self.OnDialogueEnd = NodeEvents.OnDialogueEnd
end

function M:CreateNodeData(DialogueId)
  if self.OnNodeCreated then
    self.OnNodeCreated(self)
  end
end

function M:GenerateNextNodes()
end

function M:CreateNextNode(NodeType, DialogueId)
  return self.NodeMaps:GetOrCreateNode(NodeType, DialogueId)
end

function M:SetOutPort(OutPortName, IterNode)
  self.NextNodeMap[OutPortName] = IterNode
end

function M:GetOutPort(OutPortName)
  return self.NextNodeMap[OutPortName] and self.NextNodeMap[OutPortName]:GetDesiredNode()
end

function M:Iterate(...)
  local OutPortName = (...) or EDialogueIterType.Out
  local NextNode = self:GetOutPort(OutPortName)
  if NextNode then
    NextNode:Enter()
  end
end

function M:GetType()
  return self.NodeType
end

function M:GetDesiredNode()
  return self
end

return M
