local FlowDialogueData = require("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.FlowDialogueData")
local FFlowDialogue = FlowDialogueData.FFlowDialogue
local FNpcDataManager = require("BluePrints.Managers.NpcDataManager")
local FlowLogType = UE.EStoryLogType.TalkFlow
local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")

local function GetTalkNode(self)
  return self:GetFlowAsset().TalkNode
end

local function GetLineData(self)
  local Body = self:GetFlowAsset()
  local Entry = Body.DialogueMap[self.DialogueId]
  if Entry then
    return Entry.Data, Entry.Setting
  end
  return nil, nil
end

function M:BindDelegates()
  local TalkNode = GetTalkNode(self)
  local RuntimeProxy = TalkNode.RuntimeProxy
  local SequencePlayer = TalkNode.SequencePlayer
  if not IsValid(RuntimeProxy) or not IsValid(SequencePlayer) then
    DebugPrint("WXT__TalkSentence_Sequence:BindDelegates", "Invalid", self.DialogueId)
    return false
  end
  if not self._OnSpecialDialoguePlay then
    function self._OnSpecialDialoguePlay(_, Section)
      return self:OnSpecialDialoguePlay(Section)
    end
  end
  if not self._OnSpecialDialogueEnd then
    function self._OnSpecialDialogueEnd(_, Section)
      return self:OnSpecialDialogueEnd(Section)
    end
  end
  if not self._OnSequencePause then
    function self._OnSequencePause(_)
      return self:OnSequencePause()
    end
  end
  if not self._OnSpecialDialoguePortraitFacial then
    function self._OnSpecialDialoguePortraitFacial(_, Section, PortraitFacialType)
      return self:OnSpecialDialoguePortraitFacial(Section, PortraitFacialType)
    end
  end
  RuntimeProxy.OnSpecialDialoguePlay:Add(self, self._OnSpecialDialoguePlay)
  RuntimeProxy.OnSpecialDialogueEnd:Add(self, self._OnSpecialDialogueEnd)
  RuntimeProxy.OnSpecialDialoguePortraitFacialChanged:Add(self, self._OnSpecialDialoguePortraitFacial)
  SequencePlayer.PauseAtFrameEvent:Add(self, self._OnSequencePause)
  return true
end

function M:UnbindDelegates()
  local TalkNode = GetTalkNode(self)
  local RuntimeProxy = TalkNode.RuntimeProxy
  local SequencePlayer = TalkNode.SequencePlayer
  if IsValid(RuntimeProxy) then
    if self._OnSpecialDialoguePlay then
      RuntimeProxy.OnSpecialDialoguePlay:Remove(self, self._OnSpecialDialoguePlay)
    end
    if self._OnSpecialDialogueEnd then
      RuntimeProxy.OnSpecialDialogueEnd:Remove(self, self._OnSpecialDialogueEnd)
    end
    if self._OnSpecialDialoguePortraitFacial then
      RuntimeProxy.OnSpecialDialoguePortraitFacialChanged:Remove(self, self._OnSpecialDialoguePortraitFacial)
    end
  end
  if IsValid(SequencePlayer) and self._OnSequencePause then
    SequencePlayer.PauseAtFrameEvent:Remove(self, self._OnSequencePause)
  end
end

function M:ExitSequence()
  self:UnbindDelegates()
  local TalkNode = GetTalkNode(self)
  if not self.bTailSentence and IsValid(TalkNode.SequencePlayer) then
    TalkNode.SequencePlayer:TryStopDialogueId(self.DialogueId)
  end
  self:TriggerFirstOutput(true)
end

function M:K2_ExecuteInput(PinName)
  self.IterSection = nil
  self.bPlayed = false
  self.bFinish = false
  local TalkNode = GetTalkNode(self)
  if not IsValid(TalkNode.SequencePlayer) then
    DebugPrint("WXT__TalkSentence_Sequence:Enter", "SequencePlayer invalid", self.DialogueId)
    self:ExitSequence()
    return
  end
  if not self:BindDelegates() then
    self:ExitSequence()
    return
  end
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ForceCompleteDialogue()
  if IsValid(TalkNode.RuntimeProxy) and not self.bPlayed then
    local Section = TalkNode.RuntimeProxy:GetPlayingSpecialSection()
    if Section and Section.DialogueId == self.DialogueId then
      self:Play(Section)
      self:OnSpecialDialoguePortraitFacial(Section, Section:GetCachedPortraitFacialName())
    end
  end
  TalkNode.SequencePlayer:TryPlayToDialogueId(self.DialogueId)
end

function M:Play(Section)
  local DialogueData, Setting = GetLineData(self)
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  local DialogueRecordComponent = self:TryGetRecordComponent()
  local DialogueWikiComponent = self:TryGetWikiComponent()
  local FlowDialogue = FFlowDialogue.New(DialogueData, Setting, Section)
  FlowDialogue:BindOnForceCompleteDialogue(function(Id)
    self:OnDialogueForceToEnd(Id)
  end)
  FlowDialogue:BindOnDialogueFinish(function(Id)
    self:OnDialogueFinish(Id)
  end)
  if Section and Section.bAutoPlay then
    FlowDialogue:SetAutoToNext()
  end
  FlowDialogue:SetForbiddenDSL(true)
  FlowDialogue:SetWaitAsyncTag(true)
  FlowDialogue:SetOverrideDuration()
  if DialogueWikiComponent then
    DialogueWikiComponent:AddListenWikiIdByDialogueId(self.DialogueId)
  end
  DialogueFlowGraphComponent:PlayDialogue(FlowDialogue)
  DialogueRecordComponent:OnDialogueRecord(self.DialogueId, DataMgr.Dialogue[self.DialogueId])
  self:ReportNodeStarted()
  self.bPlayed = true
end

function M:OnSpecialDialoguePlay(Section)
  if not Section then
    return
  end
  if Section.DialogueId ~= self.DialogueId then
    DebugPrint("WXT__TalkSentence_Sequence:OnSpecialDialoguePlay", "Mismatch", self.DialogueId, Section.DialogueId)
    return
  end
  if self.bPlayed then
    return
  end
  if self.IterSection then
    local Message = string.format("上句台本尚未结束 %d，就要播放下一句台本 %d", self.IterSection.DialogueId, Section.DialogueId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:SequenceIterForward", Message)
  end
  self.IterSection = Section
  self:Play(Section)
end

function M:OnSpecialDialogueEnd(Section)
  local DialogueId = Section.DialogueId
  if DialogueId ~= self.DialogueId then
    return
  end
  self.IterSection = nil
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ForceCompleteDialogue(DialogueId)
end

function M:OnSpecialDialoguePortraitFacial(Section, PortraitFacialType)
  if not Section or Section.DialogueId ~= self.DialogueId then
    return
  end
  local TalkTask = self:TryGetTalkTask()
  local PortraitComp = TalkTask and IsValid(TalkTask.UI) and TalkTask.UI.PortraitComp
  if not PortraitComp then
    return
  end
  local DialogueRow = DataMgr.Dialogue[self.DialogueId]
  local SpeakNpcId = DialogueRow and DialogueRow.SpeakNpcId
  local bSpeakerExists = nil ~= DialogueRow and (nil ~= SpeakNpcId or not string.isempty(DialogueRow.SpeakNpcName))
  local PortraitFacialRow
  if SpeakNpcId and 0 ~= SpeakNpcId then
    PortraitFacialRow = FNpcDataManager:GetPortraitFacialRow(SpeakNpcId, PortraitFacialType)
  end
  PortraitComp:SetFacial(bSpeakerExists, PortraitFacialRow)
end

function M:OnSequencePause()
  self.bPlayed = false
  self.bFinish = true
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:CompleteWaitSequence()
end

function M:OnDialogueFinish(DialogueId)
  if DialogueId ~= self.DialogueId then
    local Message = string.format("句节点OnDialogueFinish DialogueId %d 与回调 %d 不同，请检查", self.DialogueId or 0, DialogueId or 0)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueFinish", Message)
    return
  end
  self:ExitSequence()
end

function M:OnDialogueForceToEnd(DialogueId)
  if DialogueId ~= self.DialogueId then
    return
  end
  local TalkNode = GetTalkNode(self)
  if IsValid(TalkNode.SequencePlayer) and not self.bFinish then
    TalkNode.RuntimeProxy:EnterSkip()
    TalkNode.SequencePlayer:SkipToDialogueEnd(DialogueId)
    TalkNode.RuntimeProxy:ExitSkip()
    self:OnSequencePause()
  end
end

function M:Skip()
  local TalkNode = GetTalkNode(self)
  if IsValid(TalkNode.SequencePlayer) then
    TalkNode.SequencePlayer:TrySkipToDialogueId(self.DialogueId)
  end
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:SkipDialogue()
  self:ExitSequence()
end

function M:CanSkip()
  local Body = self:GetFlowAsset()
  return Body.SkipTarget ~= self.DialogueId
end

function M:Pause()
  local TalkNode = GetTalkNode(self)
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:PauseDialogue()
  if IsValid(TalkNode.SequencePlayer) then
    TalkNode.SequencePlayer:Pause()
  end
end

function M:Resume()
  local TalkNode = GetTalkNode(self)
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ResumeDialogue()
  if IsValid(TalkNode.SequencePlayer) then
    TalkNode.SequencePlayer:TryPlayToDialogueId(self.DialogueId)
  end
end

function M:K2_Cleanup()
  self:UnbindDelegates()
end

return M
