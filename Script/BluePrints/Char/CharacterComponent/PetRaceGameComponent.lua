require("UnLua")
local M = Class()
local BaseSpeed = 100
local PlayerBuffFXPath = "NiagaraSystem'/Game/Asset/Effect/Niagara/Pet/NS_Pet_SceneHalo.NS_Pet_SceneHalo'"
local PlayerBuffFXName = "PetRacePlayerBuff"
local InGameModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingInGameModel")

local function BuildPetRuntimeData(PetUnitId, PetMoveData)
  return {
    PetId = PetUnitId,
    Ranking = PetMoveData.CurrentRankNumber
  }
end

local function BuildPetRuntimeList(AllMoveData)
  local PetList = {}
  if not AllMoveData then
    return PetList
  end
  for PetUnitId, PetMoveData in pairs(AllMoveData:ToTable()) do
    PetList[PetUnitId] = BuildPetRuntimeData(PetUnitId, PetMoveData)
  end
  return PetList
end

function M:Initialize(Initializer)
end

function M:OnBeginPlayInLua()
end

function M:SingleCreateRacePet(UnitId, PlayerList)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not IsValid(GameMode) then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not IsValid(GameState) then
    return
  end
  local Context = AEventMgr.CreateUnitContext()
  Context.UnitType = "Pet"
  Context.UnitId = UnitId
  Context.Loc = self.RaceSpline:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
  GameMode.EMGameState.EventMgr:CreateUnitNew(Context, true)
  for _, entity in pairs(GameState.PetCharacterMap:ToTable()) do
    if IsValid(entity) and entity.UnitId == Context.UnitId then
      self:CreateRacePet(Context.UnitId, entity)
      entity.FXComponent:StopFX_Level("Halo")
      local IsPlayerPet = false
      for _, PlayerPetId in pairs(PlayerList) do
        if PlayerPetId == entity.UnitId then
          IsPlayerPet = true
          break
        end
      end
      if IsPlayerPet then
        entity.FXComponent:StopFX_Level(PlayerBuffFXName)
        entity.FXComponent:SpawnFXAttached_Level(PlayerBuffFXPath, PlayerBuffFXName, entity.Mesh, "", FVector(0, 0, 0), FRotator(0, 0, 0), FVector(1, 1, 1), EAttachLocation.KeepRelativeOffset, false)
      end
    end
  end
end

function M:StartRaceLotteryLogic()
  self:SetComponentTickEnabled(true)
  for _, Pet in pairs(self.RacePets) do
    if IsValid(Pet) then
      Pet:SetNpcMovementTickEnable(false)
    end
  end
end

function M:InitPetProcessMoveRecord(PetId, RaceProcessTotalRecord)
  for _, BuffData in pairs(RaceProcessTotalRecord) do
    self:InitPetMoveBuffData(PetId, BuffData[1], BuffData[2], BuffData[3])
    DebugPrint("PetRaceLotteryGame BuffTimePointPetSpeed, PetId:", PetId, "TimeNum:", BuffData[1], "BuffId:", BuffData[2], "NewSpeed:", BuffData[3])
  end
end

function M:InitPetArrivedTime(PetId, ArrivedSecondNumber)
  self:InitPetMoveArrivedSecondNum(PetId, ArrivedSecondNumber)
end

function M:CreatePetMoveRace(UnitId, MoveTrackData, FirstSpeed, PlayerList)
  self:InitPetMoveSplineData(UnitId, MoveTrackData)
  self:SingleCreateRacePet(UnitId, PlayerList)
  self:CreatePetMoveSpline(UnitId)
  self:InitPetMoveSpeedData(UnitId, FirstSpeed)
end

function M:EndRaceGameLogic()
  self:SetComponentTickEnabled(false)
  self:DestoryAllPetMoveData()
end

function M:InitPetMoveSpeedData(UnitId, FirstSpeed)
  local PetMoveData = self.MoveData:FindRef(UnitId)
  if PetMoveData then
    PetMoveData.InitialRaceSpeed = BaseSpeed * FirstSpeed
  end
  self.PetRaceSpeed:Add(UnitId, BaseSpeed * FirstSpeed)
  DebugPrint("PetRaceLotteryGame InitPetSpeed, PetId:", UnitId, "InitialRaceSpeed:", FirstSpeed)
end

function M:SpawnRacePetSpeedBuff_Lua(RacePet, BuffId, IsDebuff)
  if not IsValid(RacePet) or not IsValid(RacePet.FXComponent) then
    return
  end
  local PetId = RacePet:GetPetUnitId()
  local PetRaceInGameUI = UIManager(self):GetUIObj("PetRaceInGame")
  if PetRaceInGameUI then
    PetRaceInGameUI:OnPetUseSkill(PetId, BuffId)
  end
  local FXPath, InsideBuffEffect
  if DataMgr.RaceLotteryInsideBuff[BuffId] and DataMgr.RaceLotteryInsideBuff[BuffId].BuffEffectPath ~= nil and DataMgr.RaceLotteryInsideBuff[BuffId].BuffEffectPath ~= "" then
    FXPath = DataMgr.RaceLotteryInsideBuff[BuffId].BuffEffectPath
    InsideBuffEffect = DataMgr.RaceLotteryInsideBuff[BuffId].InsideBuffEffect
  end
  if not FXPath then
    return
  end
  if RacePet.FXComponent:IsFXPlay_Level("RaceBuffFX") then
    RacePet.FXComponent:StopFX_Level("RaceBuffFX")
    if InGameModel:IsPetInLoopSound(PetId) then
      local EventKey = PetId .. "PetBuffLoop"
      AudioManager(self):StopSound(self, EventKey)
      InGameModel:ClearPetLoopSound(PetId)
    end
  end
  local Player = InGameModel:GetInGameCamera()
  local PetData = DataMgr.Pet[RacePet:GetPetUnitId()]
  local PetNameTag = PetData and PetData.PetNameTag
  local PlayStruct = FPlayFMODSoundStruct()
  PlayStruct.bStopWhenAttachedToDestoryed = true
  PlayStruct.FollowSocket = true
  if InsideBuffEffect > 1 then
    PlayStruct.FMODEventPath = "event:/ui/common/pet_race_buff_speed_acc"
    PlayStruct.EventKey = PetId .. "PetBuffAcc"
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_skill", "PetVoice" .. PetId)
  elseif InsideBuffEffect > 0 and InsideBuffEffect < 1 then
    PlayStruct.FMODEventPath = "event:/ui/common/pet_race_buff_speed_dec"
    PlayStruct.EventKey = PetId .. "PetBuffDec"
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_upset", "PetVoice" .. PetId)
  elseif 0 == InsideBuffEffect then
    PlayStruct.FMODEventPath = "event:/ui/common/pet_race_buff_stop"
    PlayStruct.EventKey = PetId .. "PetBuffStop"
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_death", "PetVoice" .. PetId)
  elseif InsideBuffEffect < 0 then
    PlayStruct.FMODEventPath = "event:/ui/common/pet_race_buff_reverse_loop"
    PlayStruct.EventKey = PetId .. "PetBuffLoop"
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_angry", "PetVoice" .. PetId)
    InGameModel:SetPetLoopSound(PetId)
  end
  PlayStruct = UE4.UAudioManager.SetObjectToFPlayFMODSoundStruct(PlayStruct, RacePet)
  AudioManager(self):PlayFMODSound_Async(PlayStruct)
  RacePet.FXComponent:SpawnFXAttached_Level(FXPath, "RaceBuffFX", RacePet.Mesh, "", FVector(0, 0, 0), FRotator(0, 0, 0), FVector(1, 1, 1), EAttachLocation.KeepRelativeOffset, true)
end

function M:DestoryAllPetMoveData()
  for PetId, Pet in pairs(self.PetRealMoveSpline) do
    self:DestoryMoveSpline(PetId)
  end
  self.MoveData:Clear()
  self.PetRaceSpeed:Clear()
  self.PetRealMoveSpline:Clear()
  self.CurrentGameSeconds = 0
  self.TotalGameSeconds = 0
  self.IshasWinner = false
  self.CurrentFinishedCount = 0
end

function M:DestoryAllPetRace()
  for PetId, Pet in pairs(self.RacePets) do
    if IsValid(Pet) then
      Pet:EMActorDestroy(EDestroyReason.PetRace)
    end
  end
  self.RacePets:Clear()
end

function M:OnPlayerDeliverEnd()
end

function M:OnPetReachEndInLua(PlayerId)
  local PetRaceInGameUI = UIManager(self):GetUIObj("PetRaceInGame")
  if PetRaceInGameUI and PetRaceInGameUI.OnPetReachEnd then
    PetRaceInGameUI:OnPetReachEnd(PlayerId)
  end
end

function M:OnEndPlayInLua()
end

function M:PetRaceStartProgress()
  self:ShowPetRaceCountDown()
end

function M:ChagneBattleUIState(bShow)
  local BattleMainUI = UIManager(self):GetUI("BattleMain")
  local VisibilityOp = ESlateVisibility.Collapsed
  if bShow then
    VisibilityOp = ESlateVisibility.SelfHitTestInvisible
  end
end

function M:ShowPetRaceCountDown()
  if not self.Countdown then
    self.Countdown = 4
  end
  self.TimerHandle = GWorld.GameInstance:AddTimer(self.Countdown, function()
    self:ShowPetRaceInGame()
  end, false, 0, "PetRaceStartCountDown")
  local GuideCountDownFloat = UIManager(self):GetUIObj("GuideCountDown")
  GuideCountDownFloat = GuideCountDownFloat or UIManager(self):LoadUINew("GuideCountDown")
  GuideCountDownFloat:InitStartPetRaceCountDown()
end

function M:ShowPetRaceInGame(RaceId)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Spline = GameState.PetRaceSplineMaps:FindRef(RaceId)
  if Spline then
    Spline:StartRaceLottery()
    local InitParams = {
      Progress = 0,
      TotalCount = self.MoveData and self.MoveData:Length() or 0,
      PetList = BuildPetRuntimeList(self.MoveData),
      RaceId = RaceId
    }
    UIManager(self):LoadUINew("PetRaceInGame", InitParams)
  end
end

function M:UpdateCurrentPetRaceInfo(RaceSplineLength, FirstPetUnitId, DeltaTime)
  if self.MoveData then
    local PetRaceInGameUI = UIManager(self):GetUIObj("PetRaceInGame")
    if PetRaceInGameUI then
      local Progress = 0
      local FirstPetDistance
      if RaceSplineLength and RaceSplineLength > 0 and FirstPetUnitId and FirstPetUnitId > 0 then
        local FirstPetData = self.MoveData:FindRef(FirstPetUnitId)
        if FirstPetData then
          FirstPetDistance = FirstPetData.CurrentRaceDistance
          Progress = FirstPetData.CurrentRaceDistance / RaceSplineLength
        end
      end
      local RuntimeData = {
        Progress = Progress,
        PetList = BuildPetRuntimeList(self.MoveData)
      }
      PetRaceInGameUI:UpdateRaceRuntimeData(RuntimeData)
    end
  end
end

return M
