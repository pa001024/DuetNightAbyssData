local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local TalkAudioComp_C = require("BluePrints.Story.Talk.Controller.TalkAudioComp")
local FNpcDataManager = require("BluePrints.Managers.NpcDataManager")
local M = Class("BluePrints.Common.TimerMgr")

function M:Construct()
  self.AudioComp = TalkAudioComp_C.New(function(AudioState)
    self:OnTalkAudioStateChanged(AudioState)
  end)
  local TS = TalkSubsystem()
  TS.bInImmersiveTalk = true
end

function M:PlayDialogue(DialogueId)
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local DialogueData = DataMgr.Dialogue[DialogueId]
  local NpcId = DialogueData.SpeakNpcId
  local Name = TalkUtils:GetTalkActorName("Npc", NpcId)
  if not string.isempty(DialogueData.SpeakNpcName) then
    Name = DialogueData.SpeakNpcName
  end
  self.TypingText:SetTypingSpeed(0.5)
  self.NpcNameText:SetText(Name)
  local Alignment = EHorizontalAlignment.HAlign_Center
  if not string.isempty(Name) then
    Alignment = EHorizontalAlignment.HAlign_Left
  end
  self.TypingText:SetHorizontalAlignment(Alignment)
  self.TypingText:Typing(TalkUtils:DialogueIdToContent(DialogueId))
  self:PlayAudio(DialogueId)
end

function M:StopDialogue(DialogueId)
  self:SetVisibility(ESlateVisibility.Collapsed)
  self:StopAudio(DialogueId)
end

function M:SetPortraitFacial(DialogueId, PortraitFacialType)
  local PortraitComp = self.PortraitComp or self.Avatar
  if PortraitComp then
    local DialogueRow = DialogueId and DataMgr.Dialogue[DialogueId]
    local SpeakNpcId = DialogueRow and DialogueRow.SpeakNpcId
    local bSpeakerExists = nil ~= DialogueRow and (nil ~= SpeakNpcId or not string.isempty(DialogueRow.SpeakNpcName))
    local PortraitFacialRow
    if 0 ~= SpeakNpcId then
      PortraitFacialRow = FNpcDataManager:GetPortraitFacialRow(SpeakNpcId, PortraitFacialType)
    end
    PortraitComp:SetFacial(bSpeakerExists, PortraitFacialRow)
  end
end

function M:PlayAudio(DialogueId)
  self.AudioComp:Clear()
  local DialogueData = DataMgr.Dialogue[DialogueId]
  local NpcId = DialogueData.SpeakNpcId
  local Subsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkEditorContextSubSystem)
  if not Subsystem then
    return
  end
  local Npc = Subsystem:GetNpcWithGender(NpcId)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.AudioComp:PlayAudio(DialogueData.VoiceName, Npc or Player, nil, DialogueData, false, "Editor")
end

function M:StopAudio(DialogueId)
  self.AudioComp:Clear()
end

function M:OnTalkAudioStateChanged(AudioState)
  local PortraitComp = self.PortraitComp or self.Avatar
  if not PortraitComp then
    return
  end
  if "Play" == AudioState then
    PortraitComp:SetMouthState(PortraitComp.EMouthState.Speak)
  else
    PortraitComp:SetMouthState(PortraitComp.EMouthState.Idle)
  end
end

function M:Tick(DeltaTime)
end

return M
