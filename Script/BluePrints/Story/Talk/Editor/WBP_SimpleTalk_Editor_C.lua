local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local FSoundOralComponent = require("BluePrints.Story.Talk.Component.SoundOralComponent").FSoundOralComponent
local M = Class("BluePrints.Common.TimerMgr")
local EditorTalkAudioComp = {}

function EditorTalkAudioComp.New(Context)
  local Obj = setmetatable({}, {__index = EditorTalkAudioComp})
  Obj.SoundOralComponent = FSoundOralComponent.New()
  Obj.RecordPlayedAudio = nil
  Obj.Context = Context
  return Obj
end

function EditorTalkAudioComp:GetEventKey()
  return "TalkAudio_Editor"
end

function EditorTalkAudioComp:StopVOSound(Actor)
  AudioManager(self.Context):StopSound(Actor, self:GetEventKey())
end

function EditorTalkAudioComp:ClearPlayAudioProxy()
  if self.PlayAudioProxy then
    self.PlayAudioProxy.bIsValid = false
  end
end

function EditorTalkAudioComp:StartTalkTimer(Callback)
  self:ClearTimer()
  local TalkTimer
  TalkTimer = self.Context:AddTimer(0.1, function()
    if self:CheckSoundIsStopped(Callback) then
      self.Context:RemoveTimer(TalkTimer)
    end
  end, true, 0.1)
  self.TalkTimer = TalkTimer
end

function EditorTalkAudioComp:ClearTimer()
  self.Context:RemoveTimer(self.TalkTimer)
  self.TalkTimer = nil
end

function EditorTalkAudioComp:CheckSoundIsStopped(Callback)
  if not self.sound_event_instance or AudioManager(self.Context):IsSoundStoped_CPP(self.sound_event_instance) then
    if Callback then
      Callback()
    end
    return true
  end
end

function EditorTalkAudioComp:PlayDialogue(DialogueId, LightTalkTask, Callback, Actor)
  local AudioManager = AudioManager(self.Context)
  local DialogueData = DataMgr.Dialogue[DialogueId]
  if not DialogueData.VoiceName then
    self:StopVOSound(Actor)
    if Callback then
      Callback()
    end
    return
  end
  if DialogueData and DialogueData.SnapShot then
    AudioManager:SetEventSoundParam(nil, Const.DialogueEffectSoundKey, {
      voice_effect_type = Const.DialogueSnapShot[DialogueData.SnapShot]
    })
  else
    AudioManager:SetEventSoundParam(nil, Const.DialogueEffectSoundKey, {voice_effect_type = 0})
  end
  local AssetPaths = self.SoundOralComponent:GetAssetPaths(AudioManager, DialogueData.VoiceName, DialogueData.ExStoryInfo)
  if not AssetPaths or 0 == #AssetPaths then
    self:StopVOSound(Actor)
    DebugPrint(string.format("Error:DialogueData.DialogueId: %d 的音频资源不存在", DialogueId))
    if Callback then
      Callback()
    end
    return
  end
  self:ClearPlayAudioProxy()
  local PlayAudioProxy = {bIsValid = true}
  self.PlayAudioProxy = PlayAudioProxy
  local LoadedCount = 0
  local TotalToLoad = #AssetPaths
  DebugPrint("self.SoundOralComponent:PlaySoundWithOral", DialogueData.VoiceName, Actor:GetName())
  for _, Path in pairs(AssetPaths) do
    UResourceLibrary.LoadObjectAsync(self.Context, Path, {
      self.Context,
      function(_, Asset)
        LoadedCount = LoadedCount + 1
        if LoadedCount < TotalToLoad then
          return
        end
        if PlayAudioProxy.bIsValid == false then
          if Callback then
            Callback()
          end
          return
        end
        self:StopVOSound(self.AttachActor)
        self.AttachActor = Actor
        local AttachActor = Actor
        self.RecordPlayedAudio = DialogueData.VoiceName
        if DialogueData.DisableMouth then
          AttachActor = nil
        end
        DebugPrint("self.SoundOralComponent:PlaySoundWithOral", DialogueData.VoiceName, Actor:GetName())
        local SoundEventInstance = self.SoundOralComponent:PlaySoundWithOral(AudioManager, DialogueData.VoiceName, AttachActor, true, DialogueData.ExStoryInfo, self:GetEventKey())
        self.sound_event_instance = SoundEventInstance
        self:StartTalkTimer(Callback)
      end
    })
  end
end

function EditorTalkAudioComp:StopAndClear()
  self:StopVOSound(self.AttachActor)
  self:ClearTimer()
  self:ClearPlayAudioProxy()
  self.AttachActor = nil
end

function M:Construct()
  self.AudioComp = EditorTalkAudioComp.New(self)
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
  local TS = TalkSubsystem()
  TS.bInImmersiveTalk = true
end

function M:StopDialogue(DialogueId)
  self:SetVisibility(ESlateVisibility.Collapsed)
  self:StopAudio(DialogueId)
end

function M:PlayAudio(DialogueId)
  self.AudioComp:StopAndClear()
  local DialogueData = DataMgr.Dialogue[DialogueId]
  local NpcId = DialogueData.SpeakNpcId
  local Subsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkEditorContextSubSystem)
  if not Subsystem then
    return
  end
  local Npc = Subsystem:GetNpcWithGender(NpcId)
  if not Npc then
    return
  end
  self.AudioComp:PlayDialogue(DialogueId, nil, function()
  end, Npc)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local TargetLocation = Npc:K2_GetActorLocation()
  DebugPrint("TargetLocation", TargetLocation)
  if UE4.UKismetMathLibrary.VSize(Player:K2_GetActorLocation() - TargetLocation) >= 10000 then
    TargetLocation = TargetLocation - Player:K2_GetActorLocation()
    DebugPrint("TargetLocation", TargetLocation, Player:K2_GetActorLocation())
    TargetLocation:Normalize()
    TargetLocation = TargetLocation * 10000 + Player:K2_GetActorLocation()
  end
  DebugPrint("TargetLocation", TargetLocation)
  Player:K2_SetActorLocation(TargetLocation, false, nil, true)
  Player:SetActorHideTag("TalkEditorUI", true)
  local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
  GMFunctionLibrary.SetPlayerGhost(GWorld.GameInstance, true)
end

function M:StopAudio(DialogueId)
  self.AudioComp:StopAndClear()
end

function M:Tick(DeltaTime)
end

return M
