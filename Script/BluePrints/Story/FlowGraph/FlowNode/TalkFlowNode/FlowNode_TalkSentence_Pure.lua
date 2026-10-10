local FlowDialogueData = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.FlowDialogueData")
local FFlowDialogue = FlowDialogueData.FFlowDialogue
local FlowLogType = UE.EStoryLogType.TalkFlow
local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")

local function GetLineData(self)
  local Body = self:GetFlowAsset()
  local Entry = Body.DialogueMap[self.DialogueId]
  if Entry then
    return Entry.Data, Entry.Setting
  end
  return nil, nil
end

function M:K2_ExecuteInput(PinName)
  return self:Play()
end

function M:Play()
  local DialogueData, Setting = GetLineData(self)
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  local DialogueRecordComponent = self:TryGetRecordComponent()
  local DialogueWikiComponent = self:TryGetWikiComponent()
  local FlowDialogue = FFlowDialogue.New(DialogueData, Setting)
  FlowDialogue:BindOnForceCompleteDialogue(function(Id)
    self:OnDialogueForceToEnd(Id)
  end)
  FlowDialogue:BindOnDialogueFinish(function(Id)
    self:OnDialogueFinish(Id)
  end)
  if DialogueWikiComponent then
    DialogueWikiComponent:AddListenWikiIdByDialogueId(self.DialogueId)
  end
  DialogueFlowGraphComponent:PlayDialogue(FlowDialogue)
  DialogueRecordComponent:OnDialogueRecord(self.DialogueId, DataMgr.Dialogue[self.DialogueId])
  self:ReportNodeStarted()
  return true
end

function M:OnDialogueFinish(DialogueId)
  if DialogueId ~= self.DialogueId then
    local Message = string.format("句节点OnDialogueFinish DialogueId %d 与回调 %d 不同，请检查", self.DialogueId or 0, DialogueId or 0)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueFinish", Message)
    return
  end
  self:TriggerFirstOutput(true)
end

function M:OnDialogueForceToEnd(DialogueId)
  if DialogueId ~= self.DialogueId then
    return
  end
end

function M:Skip()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:SkipDialogue()
  self:TriggerFirstOutput(true)
end

function M:CanSkip()
  local Body = self:GetFlowAsset()
  return Body.SkipTarget ~= self.DialogueId
end

function M:Pause()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:PauseDialogue()
end

function M:Resume()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ResumeDialogue()
end

function M:K2_Cleanup()
end

return M
