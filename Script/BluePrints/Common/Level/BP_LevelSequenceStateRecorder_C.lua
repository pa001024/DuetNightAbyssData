require("UnLua")
local M = Class("BluePrints.Common.TimerMgr")

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self.PlayEndSequence = {}
  self.NpcActors = {}
  local GameMode = UGameplayStatics.GetGameMode(self)
  if GameMode then
    GameMode.LevelSequenceStateRecorders:Add(self.SubRegionId, self)
  end
  self:ClearBinding()
end

function M:Active()
  self:ClearBinding()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  for UniqueId, Recorder in pairs(Avatar.LevelSequenceStateRecorder) do
    if Recorder.RegionId == self.SubRegionId then
      if Recorder.PlayState == ELevelSequenceRuntimeState.ERunning then
        DebugPrint("LevelStateRecorder", "Recover,ERunning:", self.SubRegionId, Recorder.RecorderId, Recorder.SequenceState)
        self:PlaySequence_CPP(Recorder.RecorderId, Recorder.SequenceState, false, false, true)
      elseif Recorder.PlayState == ELevelSequenceRuntimeState.EComplete then
        DebugPrint("LevelStateRecorder", "Recover,EComplete:", self.SubRegionId, Recorder.RecorderId, Recorder.SequenceState)
        self:PlaySequence_CPP(Recorder.RecorderId, Recorder.SequenceState, true, false, true)
        self.PlayEndSequence[Recorder.RecorderId] = Recorder.SequenceState
      end
    end
  end
end

function M:PlaySequence_Lua(Id, State, LevelSequenceActor, PlayToEnd, ForceFromStart)
  self:SetupSequenceNpc(LevelSequenceActor, Id)
  self.PlayEndSequence[Id] = nil
  local LableFrom, LableTo
  if State.IsRevrse then
    LableFrom = State.MarkLableTo
    LableTo = State.MarkLableFrom
  else
    LableFrom = State.MarkLableFrom
    LableTo = State.MarkLableTo
  end
  if PlayToEnd then
    local PlaybackParams = FMovieSceneSequencePlaybackParams()
    PlaybackParams.MarkedFrame = LableTo
    PlaybackParams.UpdateMethod = EUpdatePositionMethod.Jump
    PlaybackParams.PositionType = EMovieScenePositionType.MarkedFrame
    LevelSequenceActor:GetSequencePlayer():SetPlaybackPosition(PlaybackParams)
  else
    self:ReportLevelSequenceState(Id, State.StateId, ELevelSequenceRuntimeState.ERunning)
    local PlaybackParams = FMovieSceneSequencePlaybackParams()
    PlaybackParams.PositionType = EMovieScenePositionType.MarkedFrame
    if ForceFromStart or State.RuntimeState ~= ELevelSequenceRuntimeState.ERunning then
      PlaybackParams.MarkedFrame = LableFrom
      PlaybackParams.UpdateMethod = EUpdatePositionMethod.Jump
      LevelSequenceActor:GetSequencePlayer():SetPlaybackPosition(PlaybackParams)
    end
    PlaybackParams.MarkedFrame = LableTo
    PlaybackParams.UpdateMethod = EUpdatePositionMethod.Play
    LevelSequenceActor:GetSequencePlayer():PlayTo(PlaybackParams)
    State.RuntimeState = ELevelSequenceRuntimeState.ERunning
    local UIManger = GWorld.GameInstance:GetGameUIManager()
    if State.HideUI and UIManger then
      UIManger:HideAllUI_EX({}, true, Const.LevelSequenceStateRecorderTag)
    end
    if State.DisableInput then
      local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
      PlayerCharacter:AddDisableInputTag(Const.LevelSequenceStateRecorderTag)
      UIManger:SetUIInputEnable(false, Const.LevelSequenceStateRecorderTag)
      local BattleMain = UIManger:GetUI("BattleMain")
      if BattleMain then
        BattleMain:BlockAllUIInput_CPP(true, Const.LevelSequenceStateRecorderTag)
      end
      UGameplayStatics.GetGameMode(self):SetPlayerCharacterForceIdle(PlayerCharacter)
    end
  end
end

function M:OnMarkedFrameEnd(Id, State, LevelSequenceActor, Action)
  if self.PauseTag then
    return
  end
  local UIManger = GWorld.GameInstance:GetGameUIManager()
  if State.HideUI and UIManger then
    UIManger:HideAllUI_EX({}, false, Const.LevelSequenceStateRecorderTag)
  end
  if State.DisableInput then
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    PlayerCharacter:RemoveDisableInputTag(Const.LevelSequenceStateRecorderTag)
    UIManger:SetUIInputEnable(true, Const.LevelSequenceStateRecorderTag)
    local BattleMain = UIManger:GetUI("BattleMain")
    if BattleMain then
      BattleMain:BlockAllUIInput_CPP(false, Const.LevelSequenceStateRecorderTag)
    end
  end
  DebugPrint("LevelStateRecorder", "MarkedFrameEnd", self.SubRegionId, Id, State.StateId, State.IsLoop, State.AutoChangeState)
  if State.IsLoop then
    self:PlaySequence_Lua(Id, State, LevelSequenceActor, false, true)
  elseif State.AutoChangeState then
    State.RuntimeState = ELevelSequenceRuntimeState.EComplete
    self:ReportLevelSequenceState(Id, State.StateId, ELevelSequenceRuntimeState.EComplete)
  end
  if not State.IsLoop then
    self.PlayEndSequence[Id] = State.StateId
    if IsValid(Action) and Action.OnSequencePlayEnd then
      Action.OnSequencePlayEnd:Broadcast()
    end
  end
end

function M:ReportLevelSequenceState(RecroderId, StateId, State)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  for UniqueId, Recorder in pairs(Avatar.LevelSequenceStateRecorder) do
    if Recorder.RegionId == self.SubRegionId and Recorder.RecorderId == RecroderId then
      if Recorder.SequenceState == StateId and Recorder.PlayState == State then
        return
      else
        break
      end
    end
  end
  DebugPrint("LevelStateRecorder", "Report", self.SubRegionId, RecroderId, StateId, State)
  Avatar:ReportLevelSequenceState(self.SubRegionId, RecroderId, StateId, State)
end

function M:AddBinding(LevelSequenceActor, LevelSequenceBindingParams, Id, StateId)
  local GameState = UGameplayStatics.GetGameState(self)
  for _, Param in pairs(LevelSequenceBindingParams:ToTable()) do
    local Creator = GameState.StaticCreatorMap:Find(Param.CreatorId)
    if Creator then
      local ChildEids = Creator:GetActorToChildEids():ToTable()
      if 0 ~= #ChildEids then
        local Entity = Battle(self):GetEntity(ChildEids[1])
        if IsValid(Entity) then
          LevelSequenceActor:AddBindingByTag(Param.Tag, Entity, false)
        end
      end
      table.insert(self.BindingCreator, Creator)
      Creator.OnStaticCreatorChildReadyDelegate:Add(self, function(self, NewEntity)
        if IsValid(NewEntity) then
          LevelSequenceActor:AddBindingByTag(Param.Tag, NewEntity, false)
          if self.PlayEndSequence[Id] == StateId then
            self:PlaySequence_CPP(Id, StateId, true, false, true)
          end
        end
      end)
    else
      GWorld.logger.error("LevelSequence AddBinding Error, Creator Not Found!!! Tag:", Param.Tag, "CreatorId:", Param.CreatorId)
    end
  end
end

function M:ClearBinding()
  if self.BindingCreator then
    for _, Creator in pairs(self.BindingCreator) do
      Creator.OnStaticCreatorChildReadyDelegate:Clear()
    end
  end
  self.BindingCreator = {}
end

function M:SetupSequenceNpc(LevelSequenceActor, SequenceId)
  if not IsValid(LevelSequenceActor) then
    return
  end
  local Sequence = LevelSequenceActor:GetSequence()
  if not IsValid(Sequence) then
    return
  end
  local Tags = UE4.TArray(UE4.FName)
  UTalkSequenceFunctionLibrary.GetLevelSequenceTags(Sequence, Tags)
  local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  if not IsValid(GameState) then
    return
  end
  for _, Tag in pairs(Tags) do
    local NpdId = tonumber(Tag)
    local NpcData = DataMgr.Npc[NpdId]
    if NpcData and (not self.NpcActors[SequenceId] or not self.NpcActors[SequenceId][NpdId]) then
      local Context = UE4.AEventMgr.CreateUnitContext()
      Context.UnitType = "Npc"
      Context.UnitId = NpdId
      Context.IntParams:Add("Level", GameState.GameModeLevel)
      Context.BoolParams:Add("InStory", true)
      Context.IntParams:Add("RegionDataType", 0)
      Context.OnUnitInitCreateReadyDynamic:Add(self, function(_, NewNpc)
        self.NpcActors[SequenceId] = self.NpcActors[SequenceId] or {}
        self.NpcActors[SequenceId][NpdId] = NewNpc
        NewNpc:PreEnterStory(nil, true, true)
        NewNpc:EnableSkeletalMeshActorRules(true)
        LevelSequenceActor:AddBindingByTag(Tag, NewNpc, false)
        LevelSequenceActor.SequencePlayer.OnFinished:Add(LevelSequenceActor, function()
          if not IsValid(NewNpc) then
            return
          end
          LevelSequenceActor:RemoveBindingByTag(Tag, NewNpc)
          NewNpc:EnableSkeletalMeshActorRules(false)
          NewNpc:PreExitStory(nil, false, false)
        end)
      end)
      GameState.EventMgr:CreateUnitNew(Context, true)
    end
  end
end

return M
