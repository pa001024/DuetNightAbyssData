local TalkFlowUtils = require("BluePrints.Story.Talk.TalkFlow.TalkFlowUtils")
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local EDialogueNodeType = TalkUtils.EDialogueNodeType
local EDialogueIterType = TalkUtils.EDialogueIterType
local M = Class({
  "BluePrints.Story.Talk.TalkFlow.Nodes.TalkFlowNode"
})
M.NodeType = EDialogueNodeType.Dialogue

function M:BuildNode(DialogueId, Comps)
  rawset(self, "DialogueRecordComponent", Comps.RecordComp)
  rawset(self, "DialogueWikiComponent", Comps.WikiComp)
  M.Super.BuildNode(self, DialogueId, Comps)
  self.bStoped = false
  self.bPendingIterate = false
  self.PendingIterArgs = nil
  self.bSkipToNext = false
end

function M:CreateFlow(DialogueId)
  local SubFlow, ParallelNode, WaitAllNode = TalkFlowUtils:CreateFlow(DialogueId, self.Context.FlowType, self.Context.FlowOwner, function()
    if not self.bStoped then
      if self.bSkipToNext then
        self.bSkipToNext = false
        self:Iterate(EDialogueIterType.Out)
      else
        self:RequestIterate(EDialogueIterType.Out)
      end
    end
    self.SubFlow = nil
  end)
  self.SubFlow = SubFlow
  if self.OnFlowCreated then
    self.OnFlowCreated(self.SubFlow, ParallelNode, WaitAllNode)
  end
end

function M:CreateNodeData(DialogueId)
  local Dialogue = DataMgr.Dialogue[DialogueId]
  self.Dialogue = Dialogue
  self.DialogueId = DialogueId
  self.NextOptions = Dialogue.NextOptions
  self.NextDialogue = Dialogue.NextDialogue
  self.FinalDialogue = Dialogue.FinalDialogueId
  self.Content = TalkUtils:DialogueIdToContent(DialogueId)
  if self.DialogueWikiComponent and Dialogue.RelatedWikiId then
    self.DialogueWikiComponent:AddListenWikiId(Dialogue.RelatedWikiId)
  end
  self:RecordNodeInMap(DialogueId, self.NodeMaps)
  M.Super.CreateNodeData(self, DialogueId)
end

function M:GenerateNextNodes()
  if self.NextDialogue and self.NextOptions then
    local DialogueId = self.DialogueId
    local NextNode = self:CreateNextNode("CheckOptionCondition", DialogueId)
    self:SetOutPort(EDialogueIterType.Out, NextNode)
    return
  end
  if self.NextDialogue then
    local DialogueId = self.NextDialogue
    local NextNode = self:CreateNextNode("Dialogue", DialogueId)
    self:SetOutPort(EDialogueIterType.Out, NextNode)
  elseif self.NextOptions then
    local DialogueId = self.DialogueId
    local NextOptionNode = self:CreateNextNode("Option", DialogueId)
    self:SetOutPort(EDialogueIterType.Out, NextOptionNode)
  elseif self.FinalDialogue then
    local NextNode = self:CreateNextNode("Dialogue", self.FinalDialogue)
    self:SetOutPort(EDialogueIterType.Final, NextNode)
  else
    local NextNode = self:CreateNextNode("End")
    self:SetOutPort(EDialogueIterType.Out, NextNode)
  end
end

function M:RecordNodeInMap(DialogueId, NodeMaps)
  if not NodeMaps then
    return
  end
  local NodeMap = NodeMaps.DialogueNodeMap
  if NodeMap then
    rawset(NodeMap, DialogueId, self)
  end
end

function M:Enter(bSkip)
  M.Super.Enter(self, bSkip)
  self:Record()
end

function M:Execute(bSkip)
  if self.bStoped then
    return
  end
  self:CreateFlow(self.DialogueId)
  if self.SubFlow then
    self.SubFlow:Start()
  else
    self:Iterate(EDialogueIterType.Out)
  end
end

function M:RequestIterate(...)
  local OutPortName = (...) or EDialogueIterType.Out
  if self.FlowChecker.CheckAutoIterate() then
    self:Iterate(OutPortName)
    return true
  end
  self.bPendingIterate = true
  self.PendingIterArgs = {OutPortName}
  return false
end

function M:ResumePendingIterate()
  if not self.bPendingIterate then
    return false
  end
  local Args = self.PendingIterArgs or {}
  self.bPendingIterate = false
  self.PendingIterArgs = nil
  self:Iterate(table.unpack(Args))
  return true
end

function M:Pause()
  if self.SubFlow then
    self.SubFlow:Pause()
  end
end

function M:Resume()
  if self.SubFlow then
    self.SubFlow:Resume()
  end
end

function M:Stop()
  self.bStoped = true
  if self.SubFlow then
    self.SubFlow:Stop()
  end
end

function M:RequestSkip()
  if self.SubFlow then
    self.SubFlow:Skip()
    return true
  end
  return self:ResumePendingIterate()
end

function M:RealSkip()
  if self.SubFlow then
    self.bSkipToNext = true
    self.SubFlow:Skip()
    return true
  end
  return self:ResumePendingIterate()
end

function M:Record()
  M.Super.Record(self)
  self.DialogueRecordComponent:OnDialogueRecord(self.Dialogue.DialogueId, self.Dialogue)
end

return M
