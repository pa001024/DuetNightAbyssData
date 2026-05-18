local EDialogueNodeType = require("BluePrints.Story.Talk.View.TalkUtils").EDialogueNodeType
local EDialogueIterType = require("BluePrints.Story.Talk.View.TalkUtils").EDialogueIterType
local TalkFlowNodeMap = require("BluePrints.Story.Talk.TalkFlow.TalkFlowNodeMap")
local M = {}

function M:New(FirstDialogueId, TalkTask, Comps)
  local TalkFlow = setmetatable({}, {__index = M})
  rawset(TalkFlow, "FirstDialogueId", FirstDialogueId)
  rawset(TalkFlow, "TalkTask", TalkTask)
  rawset(TalkFlow, "Comps", Comps)
  return TalkFlow
end

function M:BuildFlow()
  if not self.FirstDialogueId or not DataMgr.Dialogue[self.FirstDialogueId] then
    DebugPrint("FTalkFlow:BuildFlow, FirstDialogueId is Invalid", self.FirstDialogueId)
    return
  end
  if not self.TalkTask then
    DebugPrint("FTalkFlow:BuildFlow, TalkTask is nil", self.FirstDialogueId)
    return
  end
  local NodeEvents = {
    EventReceiver = self,
    OnNodeEnter = self.OnNodeEnter,
    OnNodeCreated = self.OnNodeCreated,
    OnFlowCreated = self.OnFlowCreated
  }
  local NodeMaps = TalkFlowNodeMap:New(self.TalkTask, self.Comps, NodeEvents)
  self.NodeMaps = NodeMaps
  self.EndNode = NodeMaps:GetOrCreateNode("End")
  self.StartNode = NodeMaps:GetOrCreateNode("Start", self.FirstDialogueId)
  self.CurrentNode = self.StartNode
end

function M:Start()
  if self.CurrentNode then
    self.CurrentNode:Execute()
  else
    DebugPrint("FTalkFlow:Start(),CurrentNode is nil")
  end
end

function M:Iterate(...)
  if self.CurrentNode then
    self.CurrentNode:Iterate(...)
  else
    DebugPrint("FTalkFlow:Iterate(),CurrentNode is nil", ...)
  end
end

function M:Pause()
  if self.CurrentNode then
    self.CurrentNode:Pause()
  else
    DebugPrint("FTalkFlow:Pause(),CurrentNode is nil")
  end
end

function M:Resume()
  if self.CurrentNode then
    self.CurrentNode:Resume()
  else
    DebugPrint("FTalkFlow:Resume(),CurrentNode is nil")
  end
end

function M:Stop()
  if self.CurrentNode then
    self.CurrentNode:Stop()
  else
    DebugPrint("FTalkFlow:Stop(),CurrentNode is nil")
  end
  self:End()
end

function M:Skip()
  local bSkipFail = self.CurrentNode:Skip()
  return not bSkipFail
end

function M:End()
  if self.OnFlowEndObj and self.OnFlowEndEvent then
    self.OnFlowEndEvent(self.OnFlowEndObj, self)
  end
  self:Clear()
end

function M:Clear()
end

function M:OnNodeEnd(...)
end

function M:BindDelegateOnEnd(Func)
  self.OnEndDelegate = Func
end

function M:OnNodeCreated(Node)
  if Node:GetType() == EDialogueNodeType.Option and Node.RestartTag then
    self:SetRestartTag(Node.RestartTag)
  end
end

function M:BindOnFlowEndEvent(Obj, Func)
  self.OnFlowEndObj = Obj
  self.OnFlowEndEvent = Func
end

function M:BindOnFlowCreatedEvent(Obj, Event)
  self.OnFlowCreatedObj = Obj
  self.OnFlowCreatedEvent = Event
end

function M:OnFlowCreated(Flow, ParallelNode, WaitAllNode)
  if self.OnFlowCreatedObj and self.OnFlowCreatedEvent then
    self.OnFlowCreatedEvent(self.OnFlowCreatedObj, Flow, ParallelNode, WaitAllNode)
  end
end

function M:OnNodeEnter(Node)
  if not Node then
    DebugPrint("FTalkFlow:OnNodeEnter: Node无效")
    return
  end
  if self.CurrentNode == Node then
    DebugPrint("FTalkFlow:OnNodeEnter: 重复进入节点")
    return
  end
  self.CurrentNode = Node
  if Node:GetType() == EDialogueNodeType.End then
    self:End()
  end
end

function M:GetCurrentNode()
  return self.CurrentNode
end

function M:GetDialogue()
  if self:IsInText() == false then
    return nil
  end
  return self.CurrentNode.Dialogue
end

function M:GetSavedOptions()
  if self:IsInOption() == false then
    return nil
  end
  return self.CurrentNode and self.CurrentNode.LastSelectedId
end

function M:GetOptions()
  if self:IsInOption() == false then
    return nil
  end
  return self.CurrentNode and self.CurrentNode:GetOptions()
end

function M:IsInImpression()
  return self.CurrentNode and self.CurrentNode.IsImpression
end

function M:IsInText()
  return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.Dialogue
end

function M:IsInOption()
  return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.Option
end

function M:IsStart()
  return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.Start
end

function M:IsEnd()
  return self.CurrentNode and self.CurrentNode:GetType() == EDialogueNodeType.End
end

function M:IsLastText()
  if not self:IsInText() then
    return false
  end
  local NextNode = self.CurrentNode:GetOutPort(EDialogueIterType.Out)
  if not NextNode then
    return false
  end
  return NextNode:GetType() == EDialogueNodeType.End
end

function M:IsLastAndOnlyOption()
  if not self:IsInOption() then
    return false
  end
  local Options = self:GetOptions()
  if not Options or 1 ~= #self:GetOptions() then
    return false
  end
  local NextNode = self.CurrentNode:GetOutPort(EDialogueIterType.Option .. 1)
  if not NextNode then
    return false
  end
  return NextNode:GetType() == EDialogueNodeType.End
end

function M:IsSelectedOption(OptionId)
  local CurrentNode = self.CurrentNode
  if not CurrentNode or CurrentNode:GetType() ~= EDialogueNodeType.Option then
    return false
  end
  return CurrentNode.VisitedOptions[OptionId]
end

function M:HasFinalDialogue()
  local CurrentNode = self.CurrentNode
  if not CurrentNode or CurrentNode:GetType() ~= EDialogueNodeType.Option then
    return false
  end
  return CurrentNode:HasFinalDialogue()
end

function M:GetCurrentNodeType()
  return self.CurrentNode and self.CurrentNode.NodeType
end

function M:SetRestartTag(RestartDialogueId)
  self.RestartDialogueId = RestartDialogueId
end

function M:GetRestartTag()
  return self.RestartDialogueId
end

return M
