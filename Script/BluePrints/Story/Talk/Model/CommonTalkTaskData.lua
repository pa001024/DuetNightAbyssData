local TalkOptionData_C = require("BluePrints.Story.Talk.Model.TalkOptionData").TalkOptionData_C
local ETalkCategory = {None = "None", Cutscene = "Cutscene"}

local function CollectPanMediaSectionInfos(Sequence)
  local SectionInfos = {}
  local MasterTracks = UE4.UMovieSceneSequenceExtensions.GetMasterTracks(Sequence)
  if MasterTracks then
    for _, Track in pairs(MasterTracks:ToTable()) do
      if IsValid(Track) and Track:IsA(UE4.UEMMovieSceneMediaTrack) then
        local Sections = UE4.UMovieSceneTrackExtensions.GetSections(Track)
        if Sections then
          for _, Section in pairs(Sections:ToTable()) do
            if IsValid(Section) and Section:IsA(UE4.UEMMovieSceneMediaSection) and Section:IsActive() and IsValid(Section.MediaSource) then
              local StartFrame, EndFrame
              if UE4.UMovieSceneSectionExtensions.HasStartFrame(Section) then
                StartFrame = UE4.UMovieSceneSectionExtensions.GetStartFrame(Section)
              end
              if UE4.UMovieSceneSectionExtensions.HasEndFrame(Section) then
                EndFrame = UE4.UMovieSceneSectionExtensions.GetEndFrame(Section)
              end
              table.insert(SectionInfos, {
                MediaSource = Section.MediaSource,
                Rate = math.max(0.01, math.min(3.0, Section.Rate or 1.0)),
                StartFrame = StartFrame,
                EndFrame = EndFrame,
                bWasActive = false,
                bPlaybackObserved = false,
                bSetRateRequested = false
              })
            end
          end
        end
      end
    end
  end
  return SectionInfos
end

local function StartMobilePanMediaRateTick(TalkTask, SequenceActor, Sequence)
  if not (CommonUtils.GetRuntimePlatform(GWorld.GameInstance) == "Mobile" and TalkTask and TalkTask.TalkTimerManager and IsValid(SequenceActor)) or not IsValid(Sequence) then
    return
  end
  local SectionInfos = CollectPanMediaSectionInfos(Sequence)
  if 0 == #SectionInfos then
    return
  end
  local RateTickTimer
  RateTickTimer = TalkTask.TalkTimerManager:AddTimer(TalkTask, 0.01, true, 0.01, TalkTask, function(Task)
    if not IsValid(SequenceActor) then
      Task.TalkTimerManager:DestroyTimer(Task, RateTickTimer)
      return
    end
    local SequencePlayer = SequenceActor.SequencePlayer
    if not IsValid(SequencePlayer) or not SequencePlayer:IsPlaying() then
      return
    end
    local CurrentTime = SequencePlayer:GetCurrentTime()
    local CurrentFrame = CurrentTime.Time.FrameNumber.Value
    local bHasPendingSection = false
    for _, SectionInfo in pairs(SectionInfos) do
      local bAfterStart = SectionInfo.StartFrame == nil or CurrentFrame >= SectionInfo.StartFrame
      local bBeforeEnd = nil == SectionInfo.EndFrame or CurrentFrame < SectionInfo.EndFrame
      local bIsActive = bAfterStart and bBeforeEnd
      if bIsActive and not SectionInfo.bWasActive then
        SectionInfo.bPlaybackObserved = false
        SectionInfo.bSetRateRequested = false
      elseif not bIsActive and SectionInfo.bWasActive then
        SectionInfo.bPlaybackObserved = false
        SectionInfo.bSetRateRequested = false
      end
      SectionInfo.bWasActive = bIsActive
      if bIsActive and not SectionInfo.bPlaybackObserved then
        bHasPendingSection = true
      end
    end
    if not bHasPendingSection then
      return
    end
    local PoolSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(SequenceActor, UE4.UMediaPlayerPoolSubsystem)
    if not IsValid(PoolSystem) or not PoolSystem.Pool then
      return
    end
    local PoolEntries = PoolSystem.Pool:ToTable()
    for _, SectionInfo in pairs(SectionInfos) do
      if SectionInfo.bWasActive and not SectionInfo.bPlaybackObserved then
        local PoolEntry = PoolEntries[SectionInfo.MediaSource]
        local MediaPlayer = PoolEntry and PoolEntry.Player or nil
        if IsValid(MediaPlayer) then
          local PlaybackRate = SequencePlayer:IsReversed() and -SectionInfo.Rate or SectionInfo.Rate
          if MediaPlayer:IsPlaying() then
            SectionInfo.bPlaybackObserved = true
            if SectionInfo.bSetRateRequested then
              DebugPrint("Mobile PanMedia resumed by Lua SetRate", PlaybackRate, MediaPlayer)
            end
          elseif MediaPlayer:SetRate(PlaybackRate) then
            SectionInfo.bSetRateRequested = true
          end
        end
      end
    end
  end)
  return RateTickTimer
end

local function GetSequence(SequencePath)
  local Sequence = UE4.LoadObject(SequencePath)
  if Sequence then
    return Sequence
  end
  local Avatar = GWorld:GetAvatar()
  local Gender = "F"
  if Avatar and 0 == Avatar.Sex then
    Gender = "M"
  end
  local GenderSequencePath = SequencePath .. "_" .. Gender
  local GenderSequence = UE4.LoadObject(GenderSequencePath)
  if GenderSequence then
    return GenderSequence
  end
  local EXGender = "EF"
  if Avatar and 0 == Avatar.WeitaSex then
    EXGender = "EM"
  end
  local EXGenderSequencePath = SequencePath .. "_" .. EXGender
  local EXGenderSequence = UE4.LoadObject(EXGenderSequencePath)
  if EXGenderSequence then
    return EXGenderSequence
  end
  local CombGenderSequencePath = SequencePath .. "_" .. Gender .. EXGender
  local CombGenderSequence = UE4.LoadObject(CombGenderSequencePath)
  if CombGenderSequence then
    return CombGenderSequence
  end
  local ReverseEXGender = "EF" == EXGender and "EM" or "EF"
  local ReverseEXGenderSequencePath = SequencePath .. "_" .. ReverseEXGender
  local ReverseEXGenderSequence = UE4.LoadObject(ReverseEXGenderSequencePath)
  if ReverseEXGenderSequence then
    return ReverseEXGenderSequence
  end
  local ReverseCombGenderSequencePath = SequencePath .. "_" .. Gender .. ReverseEXGender
  local ReverseCombGenderSequence = UE4.LoadObject(ReverseCombGenderSequencePath)
  if ReverseCombGenderSequence then
    return ReverseCombGenderSequence
  end
  return nil
end

local function AddExternTalkactors(TalkNodeData, ExternTalkActors, bUseExternActors, FlowAsset)
  local TalkActors = {}
  local NativeTalkActors = {}
  if bUseExternActors then
    for _, TalkActor in pairs(ExternTalkActors) do
      NativeTalkActors[TalkActor.TalkActorId] = true
      table.insert(TalkActors, TalkActor)
    end
    if TalkNodeData.TalkActors then
      for _, TalkActor in pairs(TalkNodeData.TalkActors) do
        if not NativeTalkActors[TalkActor.TalkActorId] then
          table.insert(TalkActors, TalkActor)
        end
      end
    end
  elseif TalkNodeData.TalkActors then
    for _, TalkActor in pairs(TalkNodeData.TalkActors) do
      table.insert(TalkActors, TalkActor)
    end
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar and UTalkEditorFunctionLibrary then
    for _, TalkActor in pairs(TalkActors) do
      TalkActor.OriginTalkActorId = TalkActor.TalkActorId
      TalkActor.TalkActorId = UTalkEditorFunctionLibrary.GetEditorNpcIdByGender(TalkActor.TalkActorId, FlowAsset)
    end
    UTalkEditorFunctionLibrary.InitVoiceGender(FlowAsset)
  end
  TalkNodeData.TalkActors = TalkActors
end

local function AddLevelSequenceTalkActors(TalkNodeData)
  local Tags = UE4.TArray(UE4.FName)
  UTalkSequenceFunctionLibrary.GetLevelSequenceTags(TalkNodeData.Sequence, Tags)
  local LevelSequenceActorDatas = {}
  Tags = Tags:ToTable()
  for _, Tag in pairs(Tags) do
    local Id = tonumber(Tag)
    if Id then
      local DefaultPos
      local Type = "Npc"
      if 0 == Id then
        Type = "Player"
      else
        DefaultPos = UE4.FVector(0, 0, 0)
      end
      table.insert(LevelSequenceActorDatas, {
        TalkActorId = Id,
        TalkActorType = Type,
        TalkActorVisible = true,
        DefaultPos = DefaultPos
      })
    end
  end
  local NewActorDatas = {}
  local NativeTalkActorIds = {}
  if TalkNodeData.TalkActors then
    for _, TalkActor in pairs(TalkNodeData.TalkActors) do
      NativeTalkActorIds[TalkActor.TalkActorId] = true
      table.insert(NewActorDatas, TalkActor)
    end
  end
  for _, ActorData in pairs(LevelSequenceActorDatas) do
    if not NativeTalkActorIds[ActorData.TalkActorId] then
      table.insert(NewActorDatas, ActorData)
    end
  end
  TalkNodeData.TalkActors = NewActorDatas
end

local function TryAutoCreateStageForFixSimple(Obj)
  if Obj.BasicTalkType ~= "FixSimple" or Obj.BlendInType == "BlendIn" or Obj.bNeedStage and Obj.TalkStage or not Obj.FlowAsset then
    return
  end
  local Stage = Obj.FlowAsset:TryAutoSpawnStage()
  if IsValid(Stage) then
    Obj.TalkStage = Stage
    Obj.bNeedStage = true
  end
end

local CommonTalkTaskData_C = {}

function CommonTalkTaskData_C.New(TalkNodeData)
  local Obj = setmetatable({}, {__index = TalkNodeData})
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
  Obj.SetPlayerInvincible = TalkTypeData.SetPlayerInvincible
  Obj.bDisableGameInput = not TalkTypeData.GameInput
  Obj.bExitOnline = true
  Obj.bPopMouse = TalkTypeData.UICanInteractive
  Obj.bShowGameUI = TalkTypeData.ShowGameUI
  Obj.bShowInStoryReview = TalkTypeData.ShowInStoryReview
  Obj.UIName = TalkTypeData.UIName
  Obj.BasicTalkType = TalkTypeData.BasicType
  Obj.bTaskDefaultAutoPlay = not TalkTypeData.UICanInteractive
  Obj.CameraType = TalkTypeData.CameraType
  Obj.ExtraParams = TalkTypeData.ExtraParams or {}
  local GameInstance = GWorld.GameInstance
  Obj.TalkContext = GameInstance:GetTalkContext()
  Obj.bNeedStage = Obj.ExtraParams.bNeedStage
  if Obj.bNeedStage then
    Obj.TalkStage = Obj.TalkContext:GetStage(TalkNodeData.TalkStageName)
  end
  Obj.bHideNpcs = TalkNodeData.HideNpcs
  Obj.bHideMonsters = TalkNodeData.HideMonsters
  Obj.bDisableNpcOptimization = TalkNodeData.DisableNpcOptimization
  Obj.bForceAutoPlay = TalkNodeData.ForceAutoPlay
  Obj.bShowAutoPlayButton = TalkNodeData.ShowAutoPlayButton
  Obj.bShowSkipButton = TalkNodeData.ShowSkipButton
  Obj.bShowReviewButton = TalkNodeData.ShowReviewButton
  Obj.bShowWikiButton = TalkNodeData.ShowWikiButton
  Obj.bPauseGameGlobal = TalkNodeData.PauseGameGlobal
  Obj.bDisableMonsterAI = TalkNodeData.DisableMonsterAI
  Obj.bDisableNPCAI = TalkNodeData.DisableNPCAI
  Obj.bHidePickup = TalkNodeData.bHidePickup
  Obj.bHideSkillCreature = TalkNodeData.bHideSkillCreature
  Obj.bFreezeWorldComposition = TalkNodeData.FreezeWorldComposition
  Obj.bTravelFullLoadWorldComposition = TalkNodeData.bTravelFullLoadWorldComposition
  Obj.SwitchToMasterType = TalkNodeData.SwitchToMaster
  Obj.bHideElseCharacter = TalkNodeData.HideElseCharacter
  Obj.BeginTargetPoint = GameState:GetTargetPoint(TalkNodeData.BeginNewTargetPointName)
  Obj.EndTargetPoint = GameState:GetTargetPoint(TalkNodeData.EndNewTargetPointName)
  if TalkNodeData.CameraLookAtTartgetPoint and TalkNodeData.CameraLookAtTartgetPoint ~= "" then
    Obj.CameraLookAtTartgetPoint = TalkNodeData.CameraLookAtTartgetPoint
  end
  Obj.Player = UE4.UGameplayStatics.GetPlayerCharacter(Obj.TalkContext, 0)
  Obj.PlayerController = UE4.UGameplayStatics.GetPlayerController(Obj.TalkContext, 0)
  Obj.ChapterId = 1001
  Obj.bEnableRandomOption = TalkNodeData.EnableRandomOption
  Obj.OptionData = TalkOptionData_C.New(TalkNodeData.OptionType, TalkNodeData)
  Obj.bUseProceduralCamera = TalkNodeData.UseProceduralCamera
  Obj.CameraBlendEaseExp = TalkNodeData.CameraBlendEaseExp or 2
  Obj.bHideSceneEffects = TalkNodeData.bHideSceneEffects
  Obj.bBlendDialogueCamera = Obj.ExtraParams.bBlendDialogueCamera
  Obj.bSkipToOption = TalkNodeData.SkipToOption
  Obj.bIsPlayerTurnToNPC = TalkNodeData.IsPlayerTurnToNPC
  Obj.bIsNPCTurnToPlayer = TalkNodeData.IsNPCTurnToPlayer
  Obj.bShowInteractiveActor = true
  Obj.GuideTalkStyle = TalkNodeData.GuideTalkStyle
  Obj.BubblePlayType = TalkNodeData.BubblePlayType
  Obj.BubbleDelayLoopSeconds = TalkNodeData.BubbleDelayLoopSeconds
  Obj.bBubblePlayCDEnable = TalkNodeData.bBubblePlayCDEnable
  Obj.BubblePlayCD = TalkNodeData.BubblePlayCD
  Obj.AudioAttachActor = TalkNodeData.AudioAttachActor
  Obj.PlayDialogueCallBack = TalkNodeData.PlayDialogueCallBack
  Obj.bPauseNpcBT = TalkNodeData.PauseNpcBT
  Obj.QuestChainId = TalkNodeData.QuestChainId
  Obj.PlayerSwitchEmoIdle = TalkNodeData.PlayerSwitchEmoIdle
  Obj.SequencePath = TalkNodeData.ShowFilePath
  if Obj.SequencePath and "" ~= Obj.SequencePath then
    local World = Obj.TalkContext:GetWorld()
    local LevelSequenceActorClass = Obj.TalkContext.LevelSequenceActorClass or UE4.LoadClass(Const.Talk_LevelSequenceActorPath)
    local DefaultTrans = UE4.UKismetMathLibrary.MakeTransform(UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
    local SequenceActor = World:SpawnActor(LevelSequenceActorClass, DefaultTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    local Sequence = GetSequence(Obj.SequencePath)
    if not Sequence then
      local Message = "找不到Sequence资源" .. "\nSequence路径:" .. Obj.SequencePath .. "\n对话节点:" .. tostring(TalkNodeData.Name)
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.Talk, "Seqeuence资源缺失/配置错误", Message)
    else
      UE4.UMovieSceneSequenceExtensions.SetClockSource(Sequence, UE4.EUpdateClockSource.Platform)
      SequenceActor:SetSequence(Sequence)
      Obj.Sequence = Sequence
    end
    Obj.SequenceActor = SequenceActor
    Obj.SequencePlayer = Obj.SequenceActor.SequencePlayer
  end
  if TalkNodeData.FlowAssetPath and "" ~= TalkNodeData.FlowAssetPath then
    local TS = TalkSubsystem()
    local FlowAsset = UE4.LoadObject(TalkNodeData.FlowAssetPath)
    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(TS) then
      local FlowEditorSubSystem = UEditorSubsystemBlueprintLibrary.GetEditorSubsystem(UFlowEditorSubSystem)
      FlowEditorSubSystem:CheckFlowAsset(FlowAsset)
    end
    if not FlowAsset then
      local Message = "找不到DialogueAsset资源" .. "\nSequence路径:" .. TalkNodeData.FlowAssetPath .. "\n对话节点:" .. tostring(TalkNodeData.Name)
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.TalkFlow, "DialogueAsset资源缺失/配置错误", Message)
    elseif TS then
      local FlowKey = UE4.UKismetSystemLibrary.GetPathName(FlowAsset)
      Obj.FlowAsset = TS:CreateFlowTalkTask(FlowKey, FlowAsset)
      Obj.FlowAssetPath = FlowKey
      Obj.FirstDialogueId = Obj.FlowAsset:GetFirstDialogueId()
      local TalkActors = Obj.FlowAsset:GetTalkActorData()
      AddExternTalkactors(Obj, TalkActors, Obj.bUseFlowAssetActors, Obj.FlowAsset)
    end
  end
  if Obj.BasicTalkType == "Black" then
    Obj.BlendInType = "FadeIn"
    Obj.BlendOutType = "FadeOut"
  end
  TryAutoCreateStageForFixSimple(Obj)
  if Obj.BasicTalkType == "Cinematic" then
    AddLevelSequenceTalkActors(Obj)
  end
  if TalkNodeData.TalkType == "White" then
    Obj.ScreenEffectDurationSeconds = 0
    Obj.FinishFadeInTime = 0
    Obj.BeginFadeOutTime = 0
  else
    Obj.ScreenEffectDurationSeconds = 1
    Obj.FinishFadeInTime = 1
    Obj.BeginFadeOutTime = 0.5
  end
  if TalkNodeData.ShowFadeDetail then
    Obj.BeginFadeOutTime = TalkNodeData.StartFadeOutTime
    Obj.ScreenEffectDurationSeconds = TalkNodeData.StartScreenEffectDuration
    Obj.FinishFadeInTime = TalkNodeData.FinishFadeInTime
  end
  if Obj.BasicTalkType == "Cinematic" or IsValid(Obj.FlowAsset) and Obj.FlowAsset:IsCutsceneFlow() then
    Obj.TalkCategory = ETalkCategory.Cutscene
  end
  return Obj
end

CommonTalkTaskData_C.StartMobilePanMediaRateTick = StartMobilePanMediaRateTick
return CommonTalkTaskData_C
