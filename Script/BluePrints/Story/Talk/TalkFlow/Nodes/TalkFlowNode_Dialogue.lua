local TalkFlowUtils = require("BluePrints.Story.Talk.TalkFlow.TalkFlowUtils")
local ReviewUtils = require("BluePrints.UI.WBP.StoryReview.StoryReviewUtils")
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
end

function M:CreateSubFlow(DialogueId)
  local SubFlow, ParallelNode, WaitAllNode = TalkFlowUtils:CreateFlow(DialogueId, self.TalkTask, function()
    if not self.bStoped then
      self:Iterate(EDialogueIterType.Out)
    end
    self.SubFlow = nil
  end)
  self.SubFlow = SubFlow
  if self.OnFlowCreated then
    self.OnFlowCreated(self.EventReceiver, self.SubFlow, ParallelNode, WaitAllNode)
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
  self:CreateSubFlow(self.DialogueId)
  if self.SubFlow then
    self.SubFlow:Start()
    if bSkip then
      self.SubFlow:Skip()
    end
  else
    self:Iterate(EDialogueIterType.Out)
  end
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

function M:AllowSkip()
  return self.SubFlow and self.SubFlow.bAllowClick or false
end

function M:RealSkip()
  if self.SubFlow then
    self.SubFlow:Skip()
  end
end

function M:Record()
  M.Super.Record(self)
  self.DialogueRecordComponent:OnDialogueRecord(self.Dialogue.DialogueId, self.Dialogue)
end

return M
