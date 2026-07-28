require("UnLua")
local M = Class()
local InGameModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingInGameModel")

function M:Initialize(Initializer)
  self.OriginalFOV = 0
  self.TargetPetRaceFov = 0
end

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState then
    GameState:AddPetRaceSpline(self)
  end
  self:TriggerProcessRaceGameLogic(false)
  self:HideRaceSplineArrow()
end

function M:ReceiveEndPlay(EndPlayReason)
  self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function M:TriggerProcessRaceGameLogic(IsStart)
  self:SetActorTickEnabled(IsStart)
  self.GameLogicComponent:SetComponentTickEnabled(IsStart)
end

function M:TestCreatPet()
  self.GameLogicComponent:TestCreateRacePet()
  self:InitDefaultCamera()
  self:TriggerProcessRaceGameLogic(true)
end

function M:StartRaceLottery(TrackData)
  self.GameLogicComponent:StartRaceLotteryLogic()
  self:TriggerProcessRaceGameLogic(true)
  self:HideRaceSplineArrow()
end

function M:GMEndRaceLottery()
  self:TriggerProcessRaceGameLogic(false)
  self:DestoryDefaultCamera()
  self.GameLogicComponent:EndRaceGameLogic()
  self.GameLogicComponent:DestoryAllPetMoveData()
  self.GameLogicComponent:DestoryAllPetRace()
  self:EndRaceLottery()
end

function M:SetCameraUpdateType(PetUnitId, IsRacePetType)
  if IsRacePetType then
    self.DefaultLookAtType = ERaceCameraUpdateType.RacePet
    local NewLookAtRotator = self:GetDefaultCameraLookAtImmediately()
    self.DefaultCamera:K2_SetActorRotation(NewLookAtRotator, false, nil, false)
    self.DefaultCamera.CameraComponent:SetFieldOfView(self.TargetPetRaceFov)
  else
    self.DefaultLookAtType = ERaceCameraUpdateType.Default
    local NewLookAtRotator = self:GetDefaultCameraLookAtByTargetPetImmediately()
    self.DefaultCamera:K2_SetActorRotation(NewLookAtRotator, false, nil, false)
    self.DefaultCamera.CameraComponent:SetFieldOfView(self.OriginalFOV)
  end
  self.TargetPetUnitId = PetUnitId
end

function M:EndRaceLottery()
  self:HideRaceSplineArrow()
  self:SetActorTickEnabled(false)
  self:DestoryDefaultCamera()
  self.GameLogicComponent:EndRaceGameLogic()
  self.GameLogicComponent:DestoryAllPetMoveData()
  self.GameLogicComponent:DestoryAllPetRace()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if IsValid(GameState) and GameState.HideAllNpcs then
    GameState:HideAllNpcs(false, "PetRace")
  end
  local PetRaceInGameUI = UIManager(self):GetUIObj("PetRaceInGame")
  if PetRaceInGameUI then
    PetRaceInGameUI:Close()
  end
  local Avatar = GWorld:GetAvatar()
  local PlayerList = {}
  if Avatar and Avatar.RaceLotteryInfo and Avatar.RaceLotteryInfo.RaceLotteryPlayerList then
    PlayerList = Avatar.RaceLotteryInfo.RaceLotteryPlayerList
  end
  AudioManager(self):SetParamToWorldChallengeSound("state", 1)
  local Result = UIManager(self):LoadUINew("ActivityRacingResult")
  if Result then
    Result:ShowList(InGameModel:BuildRaceResultPlayerMap(), PlayerList)
  end
  InGameModel:Destory()
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.Shadow.CacheViewLocation 0")
end

function M:BornRaceWinner(InRaceId)
  self:SpawnCelebrateFX(InRaceId)
  AudioManager(self):PlayUISound(self, "event:/sfx/common/scene/gear/firework", "CelebrateFirework", nil)
end

function M:InitPetRaceAllBuffIno(PetId, RaceProcessTotalRecord)
  self.GameLogicComponent:InitPetProcessMoveRecord(PetId, RaceProcessTotalRecord)
end

function M:InitPetRaceArrivedTime(PetId, ArrivedSecondNum)
  self.GameLogicComponent:InitPetArrivedTime(PetId, ArrivedSecondNum)
end

function M:GMSetRaceTimes(InTimes)
  self.GameLogicComponent.RaceGameTimes = InTimes
end

function M:SpawnPetMoveRaceAndInitRaceLotteryInfo(TrackData)
  local TotalSeconds = TrackData.TotalSecondNum
  local RandomRaceId, RaceTrackData, SpeedInfo
  if TrackData.RaceTrackData then
    RaceTrackData = TrackData.RaceTrackData
  end
  if nil == RaceTrackData then
    return
  end
  if TrackData.SpeedInfp then
    SpeedInfo = TrackData.SpeedInfp
  end
  if nil == SpeedInfo then
    return
  end
  InGameModel:SaveSpeedInfo(SpeedInfo)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local PlayerList = {}
  if Avatar.RaceLotteryInfo and Avatar.RaceLotteryInfo.RaceLotteryPlayerList then
    PlayerList = Avatar.RaceLotteryInfo.RaceLotteryPlayerList
  end
  for PlayerId, Ranges in pairs(RaceTrackData) do
    local PetId = tonumber(PlayerId)
    self.GameLogicComponent:CreatePetMoveRace(PetId, Ranges, SpeedInfo[PetId], PlayerList)
    if Avatar then
      Avatar:RaceLotteryQueryRaceInfo(PetId, self.RaceId)
    end
  end
  Avatar:RacceLotteryQueryJoinPlayerTotalCostSecond(function(RetCode, list)
    if RetCode == ErrorCode.RET_SUCCESS then
      for Index, Data in pairs(list or {}) do
        self:InitPetRaceArrivedTime(Data.PlayerId, Data.TotalCostSecond)
        DebugPrint("PetRaceLotteryGame InitRaceArrivedTime, RaceId:", Data.PlayerId, "ArrivedSeconds:", Data.TotalCostSecond)
      end
      InGameModel:SaveTotalPlayerList(list)
      local GameInstance = GWorld.GameInstance
      local UIManager = GameInstance:GetGameUIManager()
      if nil == UIManager then
        return
      end
      local PetRaceInGameStart = UIManager:GetUIObj("PetRaceInGameStart")
      PetRaceInGameStart = PetRaceInGameStart or UIManager:LoadUINew("PetRaceInGameStart", list, self.RaceId)
    end
  end)
  self.GameLogicComponent.TotalGameSeconds = TotalSeconds
  DebugPrint("PetRaceLotteryGame InitRaceInfo, RaceId:", self.RaceId, "TotalSeconds:", TotalSeconds)
  if 0 == TotalSeconds then
    DebugPrint(ErrorTag, "魔灵赛跑总时长为0, 请检查开赛流程 TotalSeconds: " .. TotalSeconds)
  end
end

function M:StartPetRaceProcess(TrackData)
  InGameModel:Init()
  self.GameLogicComponent.RaceSplineId = self.RaceId
  self:InitDefaultCamera()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  GameState.bInPetRace = true
  local Panel = UIManager(self):GetUI("DungeonMatchTimingBar")
  if Panel then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:VoteStartBattle(false, 0)
    end
  end
  InGameModel:SetInGameCamera(self.DefaultCamera.CameraComponent)
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.Shadow.CacheViewLocation 1")
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  if PlayerController and self.DefaultCamera then
    PlayerController:SetAudioListenerOverride(self.DefaultCamera.CameraComponent, Const.ZeroVector, Const.ZeroRotator)
  end
  local AudioManager = AudioManager(self)
  local Event = AudioManager:GetFMODEventByPath_Sync("event:/bgm/mute")
  AudioManager:PlayWorldChallengeSound(Event, nil, 0, true)
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if BattleMain then
    BattleMain:Hide("PetRace")
  end
  UIManager(self):HideAllUI_EX(InGameModel:GetShowUIList(), true, "PetRaceInGame")
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(Player) then
    Player:AddDisableInputTag("PetRace")
    Player:SetCanInteractiveTrigger(false, "PetRace")
    Player:SetESCMenuForbiddenState(true)
  end
  self:ShowRaceSplineArrow()
  MissionIndicatorManager:TriggerAllIndicatorVisible(false)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if IsValid(GameState) and GameState.HideAllNpcs then
    GameState:HideAllNpcs(true, "PetRace")
  end
  local Params = {}
  local BlackScreenHandle = "PetRaceSetViewTargetToCameraHandle"
  Params.BlackScreenHandle = BlackScreenHandle
  Params.InAnimationObj = self
  
  function Params.InAnimationCallback(obj)
    GWorld.GameInstance:AddTimer(5, function()
      UIManager(obj):HideCommonBlackScreen(BlackScreenHandle)
    end, false, 0)
  end
  
  Params.InAnimationPlayTime = 0
  Params.OutAnimationObj = self
  
  function Params.OutAnimationCallback(obj)
    obj:PlayerStartSequence(TrackData)
  end
  
  Params.OutAnimationPlayTime = 0
  UIManager(self):ShowCommonBlackScreen(Params)
  self:SetDefaultCameraToSplineStart()
end

function M:GMStartPetRaceProcess(TrackData)
  local RaceProcessRecordMap = {}
  local TotalPlayerList = {}
  local RaceSamplesNum = self:GetRaceSampleNum()
  local MockTrackData = TrackData
  DebugPrint("PetRaceLotteryGame GMStartPetRaceProcess, RaceId:", self.RaceId, "RaceSamplesNum:", RaceSamplesNum)
  InGameModel:Init()
  self.GameLogicComponent.RaceSplineId = self.RaceId
  self:InitDefaultCamera()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  if PlayerController and self.DefaultCamera then
    PlayerController:SetAudioListenerOverride(self.DefaultCamera.CameraComponent, Const.ZeroVector, Const.ZeroVector)
  end
  local AudioManager = AudioManager(self)
  local Event = AudioManager:GetFMODEventByPath_Sync("event:/bgm/mute")
  AudioManager:PlayWorldChallengeSound(Event, nil, 0, true)
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if BattleMain then
    BattleMain:Hide("PetRace")
  end
  local AchUI = UIManager(self):GetUIObj("AchievementPanel")
  if AchUI then
    AchUI:SetUIVisibilityTag("PetRace", true)
  end
  local RewardUI = UIManager(self):GetUIObj("CommonHudReward")
  if RewardUI then
    RewardUI:SetUIVisibilityTag("PetRace", true)
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(Player) then
    Player:AddDisableInputTag("PetRace")
    Player:SetCanInteractiveTrigger(false, "PetRace")
    Player:SetESCMenuForbiddenState(true)
  end
  self:ShowRaceSplineArrow()
  MissionIndicatorManager:TriggerAllIndicatorVisible(false)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if IsValid(GameState) and GameState.HideAllNpcs then
    GameState:HideAllNpcs(true, "PetRace")
  end
  local Params = {}
  local BlackScreenHandle = "PetRaceSetViewTargetToCameraHandle"
  Params.BlackScreenHandle = BlackScreenHandle
  Params.InAnimationObj = self
  
  function Params.InAnimationCallback(obj)
    GWorld.GameInstance:AddTimer(5, function()
      UIManager(obj):HideCommonBlackScreen(BlackScreenHandle)
    end, false, 0)
  end
  
  Params.InAnimationPlayTime = 0
  Params.OutAnimationObj = self
  
  function Params.OutAnimationCallback(obj)
    obj:GMPlayerStartSequence(MockTrackData, RaceProcessRecordMap, TotalPlayerList)
  end
  
  Params.OutAnimationPlayTime = 0
  UIManager(self):ShowCommonBlackScreen(Params)
  self:SetDefaultCameraToSplineStart()
end

function M:SetDefaultCameraToSplineStart()
  if not (IsValid(self.DefaultCamera) and IsValid(self.CameraSplineComponent)) or not IsValid(self.RaceSplineComponent) then
    return
  end
  local CameraStartLocation = self.CameraSplineComponent:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
  local RaceStartLocation = self.RaceSplineComponent:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
  local LookAtRotation = UE4.UKismetMathLibrary.FindLookAtRotation(CameraStartLocation, RaceStartLocation)
  self.DefaultCamera:K2_SetActorLocationAndRotation(CameraStartLocation, LookAtRotation, false, nil, false)
  self.CurrentLookAtRotation = LookAtRotation
  self.CurrentCameraLocation = RaceStartLocation
  self.OriginalFOV = self.DefaultCamera.CameraComponent.FieldOfView
  self.TargetPetRaceFov = self.DefaultCamera.RacePetFOV
end

function M:PlayCountDownSequence()
  local SequenceAsset = LoadObject(self.CountDownSequencePath)
  if not IsValid(SequenceAsset) then
    return
  end
  local DefaultTrans = UE4.UKismetMathLibrary.MakeTransform(self:K2_GetActorLocation(), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
  self.LevelSequenceActor = UE4.ULevelSequencePlayer.CreateLevelSequencePlayer(GWorld.GameInstance, SequenceAsset, UE4.FMovieSceneSequencePlaybackSettings())
  self.SequencePlayer = self.LevelSequenceActor.SequencePlayer
  if self.LevelSequenceActor and self.SequencePlayer then
    self.SequencePlayer.OnFinished:Clear()
    self.SequencePlayer.OnFinished:Add(self, function()
      if IsValid(self.LevelSequenceActor) then
        self.LevelSequenceActor:K2_DestroyActor()
        self.LevelSequenceActor = nil
        self.SequencePlayer = nil
      end
    end)
    self.SequencePlayer:Play()
  end
end

function M:PlayerStartSequence(TrackData)
  local SequenceAsset = LoadObject(self.SplineShowSequencePath)
  if not IsValid(SequenceAsset) then
    self:SpawnPetMoveRaceAndInitRaceLotteryInfo(TrackData)
    return
  end
  local DefaultTrans = UE4.UKismetMathLibrary.MakeTransform(self:K2_GetActorLocation(), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
  self.LevelSequenceActor = UE4.ULevelSequencePlayer.CreateLevelSequencePlayer(GWorld.GameInstance, SequenceAsset, UE4.FMovieSceneSequencePlaybackSettings())
  self.SequencePlayer = self.LevelSequenceActor.SequencePlayer
  if self.LevelSequenceActor and self.SequencePlayer then
    self.SequencePlayer.OnFinished:Clear()
    self.SequencePlayer.OnFinished:Add(self, function()
      local PetRaceStartSkip = UIManager(self):GetUIObj("PetRaceStartSkip")
      if PetRaceStartSkip then
        PetRaceStartSkip:Close()
      end
      self:SpawnPetMoveRaceAndInitRaceLotteryInfo(TrackData)
      if IsValid(self.LevelSequenceActor) then
        self.LevelSequenceActor:K2_DestroyActor()
        self.LevelSequenceActor = nil
        self.SequencePlayer = nil
      end
    end)
    local PetRaceStartSkip = UIManager(self):LoadUINew("PetRaceStartSkip", self.RaceId)
    self.SequencePlayer:Play()
  end
end

function M:GMSpawnPetMoveRaceAndInitRaceLotteryInfo(TrackData, RaceProcessRecordMap, TotalPlayerList)
  local TotalSeconds = TrackData.TotalSecondNum
  local RaceTrackData = TrackData.RaceTrackData
  if nil == RaceTrackData then
    return
  end
  local SpeedInfo = TrackData.SpeedInfp
  if nil == SpeedInfo then
    return
  end
  InGameModel:SaveSpeedInfo(SpeedInfo)
  local PlayerList = TrackData.PlayerList or {}
  for PlayerId, Ranges in pairs(RaceTrackData) do
    local PetId = tonumber(PlayerId)
    self.GameLogicComponent:CreatePetMoveRace(PetId, Ranges, SpeedInfo[PetId], PlayerList)
    self:InitPetRaceAllBuffIno(PetId, RaceProcessRecordMap[PetId] or {})
  end
  if TotalPlayerList then
    InGameModel:SaveTotalPlayerList(TotalPlayerList)
  end
  for Index, Data in pairs(TotalPlayerList or {}) do
    self:InitPetRaceArrivedTime(Data.PlayerId, Data.TotalCostSecond)
    DebugPrint("PetRaceLotteryGame InitRaceArrivedTime, RaceId:", Data.PlayerId, "ArrivedSeconds:", Data.TotalCostSecond)
  end
  local GameInstance = GWorld.GameInstance
  local UIManager = GameInstance:GetGameUIManager()
  if nil ~= UIManager then
    local PetRaceInGameStart = UIManager:GetUIObj("PetRaceInGameStart")
    if not PetRaceInGameStart then
      UIManager:LoadUINew("PetRaceInGameStart", TotalPlayerList, self.RaceId)
    end
  end
  self.GameLogicComponent.TotalGameSeconds = TotalSeconds
  DebugPrint("PetRaceLotteryGame GMInitRaceInfo, RaceId:", self.RaceId, "TotalSeconds:", TotalSeconds)
  if 0 == TotalSeconds then
    DebugPrint(ErrorTag, "榄旂伒璧涜窇鎬绘椂闀夸负0, 璇锋鏌ュ紑璧涙祦绋?TotalSeconds: " .. TotalSeconds)
  end
end

function M:GMPlayerStartSequence(TrackData, RaceProcessRecordMap, TotalPlayerList)
  local SequenceAsset = LoadObject(self.SplineShowSequencePath)
  if not IsValid(SequenceAsset) then
    self:GMSpawnPetMoveRaceAndInitRaceLotteryInfo(TrackData, RaceProcessRecordMap, TotalPlayerList)
    return
  end
  local DefaultTrans = UE4.UKismetMathLibrary.MakeTransform(self:K2_GetActorLocation(), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
  self.LevelSequenceActor = UE4.ULevelSequencePlayer.CreateLevelSequencePlayer(GWorld.GameInstance, SequenceAsset, UE4.FMovieSceneSequencePlaybackSettings())
  self.SequencePlayer = self.LevelSequenceActor.SequencePlayer
  if self.LevelSequenceActor and self.SequencePlayer then
    self.SequencePlayer.OnFinished:Clear()
    self.SequencePlayer.OnFinished:Add(self, function()
      local PetRaceStartSkip = UIManager(self):GetUIObj("PetRaceStartSkip")
      if PetRaceStartSkip then
        PetRaceStartSkip:Close()
      end
      self:GMSpawnPetMoveRaceAndInitRaceLotteryInfo(TrackData, RaceProcessRecordMap, TotalPlayerList)
      if IsValid(self.LevelSequenceActor) then
        self.LevelSequenceActor:K2_DestroyActor()
        self.LevelSequenceActor = nil
        self.SequencePlayer = nil
      end
    end)
    local PetRaceStartSkip = UIManager(self):LoadUINew("PetRaceStartSkip", self.RaceId)
    self.SequencePlayer:Play()
  end
end

function M:GoToEndSequence()
  if self.LevelSequenceActor and self.SequencePlayer then
    local FrameLength = self.SequencePlayer:GetFrameDuration()
    local MiscUtils = require("Utils.MiscUtils")
    local EndFrame = math.max(MiscUtils.Int(FrameLength) - 1, 0)
    local PlaybackParams = FMovieSceneSequencePlaybackParams()
    PlaybackParams.Frame.FrameNumber.Value = EndFrame
    self.SequencePlayer:SetPlaybackPosition(PlaybackParams)
  end
end

function M:DestoryDefaultCamera()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if IsValid(PlayerController) and IsValid(Player) then
    USequenceFunctionLibrary.SetViewTarget(PlayerController, Player)
    if Player.AudioListener then
      PlayerController:SetAudioListenerOverride(Player.AudioListener, Const.ZeroVector, Const.ZeroRotator)
    end
  end
  self.DefaultCamera:K2_DestroyActor()
  self.DefaultCamera = nil
end

function M:GetRaceSampleNum()
  local SplineLength = self.RaceSplineComponent:GetSplineLength()
  return math.max(2, math.ceil(SplineLength / self.RaceSampleInterval) + 1)
end

function M:OnEndPlayInLua()
end

return M
