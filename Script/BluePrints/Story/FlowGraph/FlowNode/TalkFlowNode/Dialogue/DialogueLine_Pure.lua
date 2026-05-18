local FlowDialogueData = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.FlowDialogueData")
local FFlowDialogue = FlowDialogueData.FFlowDialogue
local FlowLogType = UE.EStoryLogType.TalkFlow
local DialogueLine_Pure = {}
DialogueLine_Pure.__index = DialogueLine_Pure

function DialogueLine_Pure.New(Driver, DialogueData, DialogueSetting)
  local Obj = setmetatable({}, DialogueLine_Pure)
  Obj.Driver = Driver
  Obj.Node = Driver.Node
  Obj.DialogueData = DialogueData
  Obj.DialogueSetting = DialogueSetting
  Obj.DialogueId = DialogueData and DialogueData.DialogueId
  Obj.Next = nil
  return Obj
end

function DialogueLine_Pure:Enter()
  return self:Play()
end

function DialogueLine_Pure:Play()
  local Node = self.Node
  local DialogueFlowGraphComponent = Node:TryGetFlowGraphComponent()
  local DialogueRecordComponent = Node:TryGetRecordComponent()
  local DialogueWikiComponent = Node:TryGetWikiComponent()
  local FlowDialogue = FFlowDialogue.New(self.DialogueData, self.DialogueSetting)
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
  Node:TriggerNormalOutput(self.DialogueId)
  return true
end

function DialogueLine_Pure:OnDialogueFinish(DialogueId)
  if DialogueId ~= self.DialogueId then
    DebugPrint("WXT__DialogueLine_Pure:OnDialogueFinish", "Mismatch", self.DialogueId, DialogueId)
    local Message = string.format("当前Dialogue节点OnDialogueFinish时 DialogueId %d 与回调 %d不同，请检查", self.DialogueId or 0, DialogueId or 0)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueFinish", Message)
    return
  end
  self.Driver:OnLineFinished(self, "finish")
end

function DialogueLine_Pure:OnDialogueForceToEnd(DialogueId)
  if DialogueId ~= self.DialogueId then
    DebugPrint("WXT__DialogueLine_Pure:OnDialogueForceToEnd", "Mismatch", self.DialogueId, DialogueId)
    local Message = string.format("当前Dialogue节点OnDialogueForceToEnd时 DialogueId %d 与回调 %d不同，请检查", self.DialogueId or 0, DialogueId or 0)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueForceToEnd", Message)
    return
  end
end

function DialogueLine_Pure:SkipCurrent()
  local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:SkipDialogue()
  self.Driver:OnLineFinished(self, "skip")
end

function DialogueLine_Pure:CanSkip()
  return true
end

function DialogueLine_Pure:Pause()
  local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:PauseDialogue()
end

function DialogueLine_Pure:Resume()
  local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ResumeDialogue()
end

function DialogueLine_Pure:Cleanup()
end

return DialogueLine_Pure
