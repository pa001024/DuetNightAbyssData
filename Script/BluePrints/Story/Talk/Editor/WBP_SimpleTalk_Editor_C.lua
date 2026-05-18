local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local TalkAudioComp_C = require("BluePrints.Story.Talk.Controller.TalkAudioComp")
local M = Class("BluePrints.Common.TimerMgr")

function M:Construct()
  self.AudioComp = TalkAudioComp_C.New()
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
  self.TypingText:Typing(TalkUtils:DialogueIdToContent(DialogueId))
  self:PlayAudio(DialogueId)
end

function M:StopDialogue(DialogueId)
  self:SetVisibility(ESlateVisibility.Collapsed)
  self:StopAudio(DialogueId)
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

function M:Tick(DeltaTime)
end

return M
