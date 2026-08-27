local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local FunctionNode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")

local function GetTemplateRequirePath(TemplatePath)
  local RequirePath = string.gsub(TemplatePath, "%.lua$", "")
  RequirePath = string.gsub(RequirePath, "[\\/]", ".")
  if string.sub(RequirePath, 1, string.len("StoryCreator.StoryFunctions.")) ~= "StoryCreator.StoryFunctions." then
    RequirePath = "StoryCreator.StoryFunctions." .. RequirePath
  end
  return RequirePath
end

function FunctionNode:Init()
  self.NodeMap = {}
  self.ConnectionMap = {}
  self.PortByName = {}
  self.PortByNodeId = {}
  self.RunningNodeList = {}
  self.FinishedNodeList = {}
  self.bLockRunningNodeList = false
end

function FunctionNode:BuildNode(NodeId, Data, ExtraInfo)
  FunctionNode.Super.BuildNode(self, NodeId, Data, ExtraInfo)
  self.Questline = self.Context
  self.Storyline = self.Questline.Storyline
  self.FileName = self.Questline.FileName
  self.FilePath = self.Questline.FilePath
  self.QuestChainId = self.Questline.QuestChainId
  self.QuestId = self.Questline.QuestId
  self.Data = self.Questline.Data
  local TemplatePath = self.TemplatePath
  if not TemplatePath or "" == TemplatePath then
    DebugPrint("FunctionNode TemplatePath is empty", NodeId)
    return
  end
  local RequirePath = GetTemplateRequirePath(TemplatePath)
  local Success, TemplateData = pcall(require, RequirePath)
  if not Success or type(TemplateData) ~= "table" then
    DebugPrint("FunctionNode template load failed", NodeId, RequirePath, TemplateData)
    return
  end
  self:BuildGraph(TemplateData)
end

function FunctionNode:BuildGraph(TemplateData)
  for _, PortData in pairs(TemplateData.ports or {}) do
    self.PortByName[PortData.name] = PortData
    self.PortByNodeId[PortData.internalNodeId] = PortData
  end
  for NodeId, NodeData in pairs(TemplateData.nodeData or {}) do
    if not self.PortByNodeId[NodeId] then
      local Node = StorylineUtils.CreateQuestNode(NodeData.type, self)
      if Node then
        Node:BuildNode(NodeId, NodeData, self.QuestData)
        self.NodeMap[NodeId] = Node
      else
        DebugPrint("FunctionNode node create failed", self.Key, NodeId, NodeData.type)
      end
    end
  end
  for _, LineData in pairs(TemplateData.lineData or {}) do
    local ConnectionByPort = self.ConnectionMap[LineData.startQuest]
    if not ConnectionByPort then
      ConnectionByPort = {}
      self.ConnectionMap[LineData.startQuest] = ConnectionByPort
    end
    local ConnectionList = ConnectionByPort[LineData.startPort]
    if not ConnectionList then
      ConnectionList = {}
      ConnectionByPort[LineData.startPort] = ConnectionList
    end
    table.insert(ConnectionList, LineData)
  end
end

function FunctionNode:Start(Context, InPortName)
  local PortData = self.PortByName[InPortName]
  if not PortData or not PortData.inOut then
    DebugPrint("FunctionNode input port not found", self.Key, InPortName)
    return
  end
  self:StartFromPort(PortData.internalNodeId, PortData.internalPortName)
end

function FunctionNode:StartFromPort(NodeId, OutPortName, Result)
  local ConnectionByPort = self.ConnectionMap[NodeId]
  local ConnectionList = ConnectionByPort and ConnectionByPort[OutPortName]
  if not ConnectionList then
    DebugPrint("FunctionNode connection not found", self.Key, NodeId, OutPortName)
    return
  end
  for _, LineData in pairs(ConnectionList) do
    if self.HasFinished then
      return
    end
    local NextNode = self.NodeMap[LineData.endQuest]
    if NextNode then
      self:StartNode(NextNode, LineData.endPort)
    else
      local PortData = self.PortByNodeId[LineData.endQuest]
      if PortData and not PortData.inOut and LineData.endPort == PortData.internalPortName then
        self:Finish(PortData.name, Result)
      else
        DebugPrint("FunctionNode target not found", self.Key, LineData.endQuest, LineData.endPort)
      end
    end
  end
end

function FunctionNode:StartNode(NextNode, InPortInfo)
  if self.HasFinished or NextNode.HasStopped then
    return
  end
  if "Stop" == InPortInfo then
    NextNode.HasStopped = true
    NextNode:Stop()
    return
  end
  NextNode.HasStarted = true
  NextNode.HasFinished = false
  self.RunningNodeList[NextNode.Key] = NextNode
  self.Questline:TryAddAfterSpecialQuestFailMark(NextNode)
  NextNode:Start(self, InPortInfo)
end

function FunctionNode:FinishNode(Node, OutPortNames, Result)
  if self.HasFinished or Node.HasFinished or self.bLockRunningNodeList then
    return
  end
  Node.HasFinished = true
  Node.HasStarted = false
  self.RunningNodeList[Node.Key] = nil
  table.insert(self.FinishedNodeList, Node)
  for _, OutPortName in pairs(OutPortNames) do
    if self.HasFinished then
      return
    end
    self:StartFromPort(Node.NodeId, OutPortName, Result)
  end
end

function FunctionNode:Clear()
  self.bLockRunningNodeList = true
  local RunningNodes = {}
  for _, Node in pairs(self.RunningNodeList) do
    table.insert(RunningNodes, Node)
  end
  for _, Node in pairs(RunningNodes) do
    Node:Clear()
    Node.HasFinished = true
    Node.HasStarted = false
    table.insert(self.FinishedNodeList, Node)
    self.Questline:CheckAfterSpecialQuestFailMark(Node)
  end
  self.RunningNodeList = {}
  self.bLockRunningNodeList = false
end

function FunctionNode:OnQuestlineFinish()
  for _, Node in ipairs(self.FinishedNodeList) do
    Node:OnQuestlineFinish()
  end
end

function FunctionNode:OnQuestlineSuccess()
  for _, Node in ipairs(self.FinishedNodeList) do
    Node:OnQuestlineSuccess()
  end
end

function FunctionNode:OnQuestlineFail()
  for i = #self.FinishedNodeList, 1, -1 do
    self.FinishedNodeList[i]:OnQuestlineFail()
  end
end

function FunctionNode:OnStop()
  for i = #self.FinishedNodeList, 1, -1 do
    self.FinishedNodeList[i]:OnStop()
  end
  self.FinishedNodeList = {}
end

function FunctionNode:OnFinish()
  for i = #self.FinishedNodeList, 1, -1 do
    self.FinishedNodeList[i]:OnFinish()
  end
  self.FinishedNodeList = {}
end

function FunctionNode:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
  if self.Type == NodeType then
    table.insert(OutRunningNodeTable, self)
  end
  for _, Node in pairs(self.RunningNodeList) do
    Node:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
  end
end

function FunctionNode:IsGuideNode()
  for _, Node in pairs(self.RunningNodeList) do
    if Node.IsGuideNode and Node:IsGuideNode() then
      return true
    end
  end
  return false
end

function FunctionNode:GetPayload(...)
  return self.Questline:GetPayload(...)
end

function FunctionNode:AddPayload(Key, Value)
  self.Questline:AddPayload(Key, Value)
end

function FunctionNode:SaveSuitUpdateData(...)
  self.Questline:SaveSuitUpdateData(...)
end

function FunctionNode:FailQuest()
  self.Questline:FailQuest()
end

function FunctionNode:StopStory()
  self.Questline:StopStory()
end

return FunctionNode
