local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local STLogType = UE.EStoryLogType.STL
local Storyline = Class("StoryCreator.StoryLogic.StorylineNodes.Storyline.BaseStoryline")

function Storyline:Init(StorylineData, FileName, EndCallback, StopCallback, Payload)
  Storyline.Super.Init(self, StorylineData, FileName, EndCallback, StopCallback, Payload)
  self.Data = StorylineData
  self.FileName = FileName
  self.FilePath = FileName
  self.EndCallback = EndCallback
  self.StopCallback = StopCallback
  self.Payload = Payload
  self:TimerInit()
  self.RunningNodeList = {}
  self.FinishedNodeList = {}
  self.bLockRunningNodeList = false
  self.OnStartNodeCallbacks = {}
  self.OnFinishNodeCallbacks = {}
  self:BuildStoryline()
end

function Storyline:GetPayload(Key)
  return self.Payload and self.Payload[Key]
end

function Storyline:AddPayload(Key, Value)
  if not self.Payload then
    self.Payload = {}
  end
  self.Payload[Key] = Value
end

function Storyline:BuildStoryline()
  for NodeId, NodeData in pairs(self.Data.storyNodeData) do
    local Node = StorylineUtils.CreateStoryNode(NodeData.type, self)
    if Node.IsStartNode then
      self:SetStartNode(Node)
    elseif Node.IsEndNode then
      self:SetEndNode(Node)
    elseif Node.IsSuccessNode then
      self:SetSuccessNode(Node)
    elseif Node.IsFailNode then
      self:SetFailNode(Node)
    end
    Node:BuildNode(NodeId, NodeData, nil)
    self:AddNode(NodeId, Node)
  end
  if not self:GetStartNode() then
    local Message = "任务链没有StartStoryNode连线" .. [[

FileName:]] .. self.FileName
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链没有StartStoryNode连线", Message)
    return
  end
  self.QuestChainId = self._StartNode.QuestChainId or 0
  DebugPrint("StorylineBuilder BuildStoryline QuestChainId", self.QuestChainId)
  self:BuildAdjacencyMap(self.Data.lineData, "startStory", "endStory")
  self.QuestIdNodeList = {}
  for _, Node in pairs(self:GetNodes()) do
    if Node.QuestId then
      self.QuestIdNodeList[Node.QuestId] = Node
    end
  end
end

function Storyline:GetStoryNode(QuestId)
  return self.QuestIdNodeList[QuestId]
end

function Storyline:StartStory(QuestId, NodeId)
  DebugPrint("Storyline StartStory QuestId:", QuestId, ",NodeId:", NodeId)
  if self.HasStarted then
    self.StartedNode = self.QuestIdNodeList[QuestId]
    self:StartNode(self.StartedNode, NodeId)
    return
  end
  if QuestId and 0 ~= QuestId then
    self.StartedNode = self.QuestIdNodeList[QuestId]
    if not self.StartedNode then
      local Message = "任务Id不存在" .. [[

FileName:]] .. self.FileName .. [[

QuestChainId:]] .. self.QuestChainId .. [[

QuestId:]] .. QuestId
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务Id不存在", Message)
      self:FinishStory()
      return
    end
    if self.QuestChainId and 0 ~= self.QuestChainId then
      local Avatar = GWorld:GetAvatar()
      if Avatar and Avatar:IsQuestFinished(QuestId) then
        self.StartedNode:Finish("Success")
        return
      end
    end
  else
    self.StartedNode = self._StartNode
  end
  DebugPrint("Storyline Start", self.QuestChainId)
  self.RunningNodeList = {}
  self.HasStarted = true
  self.HasFinished = false
  self:StartNode(self.StartedNode, NodeId)
end

function Storyline:StartNode(Node, NodeId)
  if self.HasFinished then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，开始节点失败", Message)
    return
  end
  if self.bLockRunningNodeList then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已锁定，开始节点失败", Message)
    return
  end
  if Node.HasStarted then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "节点已开始，开始节点失败", Message)
    return
  end
  for _, Callback in ipairs(self.OnStartNodeCallbacks) do
    Callback.Func(Callback.Obj, self.QuestChainId, Node.QuestId)
  end
  Node.HasStarted = true
  Node.HasFinished = false
  self.RunningNodeList[Node.Key] = Node
  DebugPrint("----------------------------------------------------------StartNode ", Node:ToString())
  Node:Start(self, NodeId)
end

function Storyline:FinishNode(Node, OutPortNames, Result)
  if self.HasFinished then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，完成节点失败", Message)
    return
  end
  if self.bLockRunningNodeList then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已锁定，完成节点失败", Message)
    return
  end
  if Node.HasFinished then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "节点已完成，完成节点失败", Message)
    return
  end
  Node.HasFinished = true
  Node.HasStarted = false
  table.insert(self.FinishedNodeList, Node)
  self.RunningNodeList[Node.Key] = nil
  DebugPrint("----------------------------------------------------------FinishNode", Result, Node:ToString())
  for _, Callback in ipairs(self.OnFinishNodeCallbacks) do
    Callback.Func(Callback.Obj, self.QuestChainId, Node, OutPortNames, Result)
  end
  if Node == self._EndNode then
    if false == self._EndNode:GetEndResult() then
      self:Stop()
    else
      self:FinishStory()
    end
    return
  end
  if not self.QuestChainId or 0 == self.QuestChainId then
    local HaveFailOutPort = self:CheckHaveOutPort(OutPortNames, "Fail")
    local HaveNextNode = self:CheckHaveNextNode(Node, OutPortNames)
    if false == Result and false == HaveNextNode and HaveFailOutPort then
      self._EndNode:SetEndResult(false)
      self:StartNode(self._EndNode)
    else
      for _, OutPortName in pairs(OutPortNames) do
        local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
        if NodeInfoList then
          for _, NextNodeInfo in pairs(NodeInfoList) do
            local NextNode = NextNodeInfo.Node
            self:StartNode(NextNode)
          end
        end
      end
    end
  end
end

function Storyline:FinishStory(IgnoreFinishClear)
  if self.HasFinished then
    local Message = "任务链已结束" .. [[

FileName:]] .. self.FileName .. [[

QuestChainId:]] .. self.QuestChainId
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已结束", Message)
    return
  end
  self:ClearStory(IgnoreFinishClear)
  self.HasFinished = true
  self.HasStarted = false
  self:OnFinish()
  DebugPrint("Storyline Finish", self.QuestChainId)
  if self.EndCallback then
    self:EndCallback()
  end
end

function Storyline:ClearStory(IgnoreFinishClear)
  self.bLockRunningNodeList = true
  local RunningNodes = {}
  for _, Node in pairs(self.RunningNodeList) do
    table.insert(RunningNodes, Node)
  end
  for _, Node in pairs(RunningNodes) do
    if Node.StopQuest then
      Node:StopQuest(IgnoreFinishClear)
    end
    Node.HasFinished = true
    Node.HasStarted = false
    table.insert(self.FinishedNodeList, Node)
  end
  self.bLockRunningNodeList = false
  self.RunningNodeList = {}
  self:ClearNodeCallbacks()
end

function Storyline:Stop(IgnoreFinishClear)
  self:ClearStory(IgnoreFinishClear)
  self.HasFinished = true
  self.HasStarted = false
  self:OnStop()
  if self.StopCallback then
    self:StopCallback()
  end
end

function Storyline:Success()
  for _, StoryNode in pairs(self.RunningNodeList) do
    if StoryNode.SuccessQuest then
      StoryNode:SuccessQuest()
    end
  end
end

function Storyline:PrintInfo()
  DebugPrint("---------------------------StorylineInfo---------------------------")
  DebugPrint("QuestchainId: ", self.QuestChainId)
  for _, StoryNode in pairs(self.RunningNodeList) do
    if StoryNode.PrintInfo then
      StoryNode:PrintInfo()
    end
  end
  DebugPrint("---------------------------StorylineInfo---------------------------")
end

function Storyline:TimerInit()
  if self.TimerHandles == nil then
    self.TimerHandles = {}
    self.TimerKeyIdx = 0
  end
end

function Storyline:GetTimerSource(IsRealTime)
  if IsRealTime then
    return URuntimeCommonFunctionLibrary
  else
    return UE4.UKismetSystemLibrary
  end
end

function Storyline:StopStory()
  self:Stop()
end

function Storyline:CheckHaveNextNode(Node, OutPortNames)
  for _, OutPortName in pairs(OutPortNames) do
    local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
    if NodeInfoList then
      return true
    end
  end
  return false
end

function Storyline:CheckHaveOutPort(OutPortNames, TargetOutPortName)
  for _, OutPortName in pairs(OutPortNames) do
    if OutPortName == TargetOutPortName then
      return true
    end
  end
  return false
end

function Storyline:ClearNodeCallbacks()
  self.OnStartNodeCallbacks = {}
  self.OnFinishNodeCallbacks = {}
end

function Storyline:AddFinishNodeCallback(Obj, Func)
  table.insert(self.OnFinishNodeCallbacks, {Obj = Obj, Func = Func})
end

function Storyline:RemoveFinishNodeCallback(Obj)
  for i = #self.OnFinishNodeCallbacks, 1, -1 do
    if self.OnFinishNodeCallbacks[i].Obj == Obj then
      table.remove(self.OnFinishNodeCallbacks, i)
    end
  end
end

function Storyline:AddStartNodeCallback(Obj, Func)
  table.insert(self.OnStartNodeCallbacks, {Obj = Obj, Func = Func})
end

function Storyline:RemoveStartNodeCallback(Obj)
  for i = #self.OnStartNodeCallbacks, 1, -1 do
    if self.OnStartNodeCallbacks[i].Obj == Obj then
      table.remove(self.OnStartNodeCallbacks, i)
    end
  end
end

function Storyline:IsGuideNodeRunning()
  if self.HasFinished then
    return false
  end
  for _, StoryNode in pairs(self.RunningNodeList or {}) do
    if StoryNode.IsGuideNodeRunning and StoryNode:IsGuideNodeRunning() then
      return true
    end
  end
  return false
end

function Storyline:OnStop()
  for i = #self.FinishedNodeList, 1, -1 do
    local Node = self.FinishedNodeList[i]
    if Node.HasFinished then
      Node:OnStop()
    end
  end
  self.FinishedNodeList = {}
end

function Storyline:OnFinish()
  for i = #self.FinishedNodeList, 1, -1 do
    local Node = self.FinishedNodeList[i]
    if Node.HasFinished then
      Node:OnFinish()
    end
  end
  self.FinishedNodeList = {}
end

return Storyline
