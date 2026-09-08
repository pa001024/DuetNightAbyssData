require("UnLua")
local CommonUtils = require("Utils.CommonUtils")
local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})
local REVEAL_PARAMETER_NAME = "Dis"
local REVEAL_HIDDEN_VALUE = 1
local REVEAL_VISIBLE_VALUE = 0
local DEFAULT_REVEAL_SPEED = 2500
local MIN_REVEAL_SEGMENT_LENGTH = 1
local TRAIN_MOVE_TIMER_KEY = "SplineTrainMove"
local TRAIN_LIFETIME_TIMER_KEY = "TrainLifeTime"
local CARRIAGE_MODE_HEAD = 1
local CARRIAGE_MODE_BODY = 2
local CARRIAGE_MODE_CONNECT = 3
local DELAYED_INIT_SEC = 0.2
local DEFAULT_HEAD_HALF_X = 6000
local DEFAULT_BODY_HALF_X = 3000
local DEFAULT_BODY_HALF_YZ = 300
local DEFAULT_SLOW_FORWARD = 3000
local MIN_MOVE_SPEED = 100
local MAX_MOVE_DELTA = 0.03333333333333333
local TICK_HEARTBEAT_INTERVAL = 2.0
local TICK_HEARTBEAT_TIMEOUT = 2.5
local DEATH_BOX_CD = 1.0
local SLOW_EFFECT_DURATION = 3.0
local SLOW_EXTRA_CD = 2.0
local SLOW_TIME_BUFF_ID = 68
local SLOW_END_DEBOUNCE = 0.15

local function PlayRailTrainMoveSound(self)
  if self.SoundTriggerOn then
    return
  end
  if self._RailTrainSfxPlayed then
    return
  end
  self._RailTrainSfxPlayed = true
  AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/scene/ex02/rail_train")
end

local FALLING_IMPULSE = 10000
local LEGACY_MESH_SCAN_MAX = 10
local LEGACY_TRIGGER_SCAN_MAX = 30
local PORTAL_START_DELAY = 1.5
local PREPARE_START_DELAY = 0.1
local AUTO_TRANSITION_RETRY_SEC = 0.2
local TRACK_BIND_PARALLEL_DOT = 0.9
local TRACK_BIND_LAT_MAX = 500
local TRACK_BIND_LONG_MARGIN = 400
local TRACK_BIND_LONG_MAX = 1500
local TRACK_BIND_RETRY_INTERVAL = 0.2
local TRACK_BIND_RETRY_MAX = 15
local TRACK_BIND_RETRY_KEY = "SplineTrainBindRetry"
local SIDE_SCAN_LAT_MIN = 250
local SIDE_SCAN_LAT_MAX = 1100
local SIDE_SCAN_FWD_ALIGN_MAX = 1500
local ADJ_LAND_LAT_MIN = 150
local ADJ_LAND_LAT_MAX = 3000
local ADJ_LAND_Z_REACH = 800
local ADJ_LAND_BODY_UP = 90
local ADJ_LAND_PT_INFLATE = 120
local SWITCH_OBSTACLE_DEBUG_DRAW = false

local function DbgPrint(ctx, ...)
  if ctx and ctx.IsDebug then
    DebugPrint(...)
  end
end

local function MakeRotationFromChordAndSpline(forward, up)
  if not forward then
    return nil
  end
  if up then
    local ok, rot = pcall(UE4.UKismetMathLibrary.MakeRotFromXZ, forward, up)
    if ok and rot then
      return rot
    end
    local x = UE4.UKismetMathLibrary.Normal(forward, 0.001)
    local z = UE4.UKismetMathLibrary.Normal(up, 0.001)
    local y = FVector(z.Y * x.Z - z.Z * x.Y, z.Z * x.X - z.X * x.Z, z.X * x.Y - z.Y * x.X)
    y = UE4.UKismetMathLibrary.Normal(y, 0.001)
    z = FVector(x.Y * y.Z - x.Z * y.Y, x.Z * y.X - x.X * y.Z, x.X * y.Y - x.Y * y.X)
    local ok2, rot2 = pcall(UE4.UKismetMathLibrary.MakeRotationFromAxes, x, y, z)
    if ok2 and rot2 then
      return rot2
    end
  end
  return UE4.UKismetMathLibrary.MakeRotFromX(forward)
end

function M:GetStateNumber()
  return (self.StateId or 0) % 10
end

function M:FindStateIdByNumber(stateNum)
  if not self.UnitId or self.UnitId <= 0 then
    DebugPrint("BP_SplineTrain_Dynamic: FindStateIdByNumber FAILED - UnitId is nil or 0")
    return nil
  end
  local mechanismData = DataMgr.Mechanism[self.UnitId]
  if not mechanismData or not mechanismData.StateIdList then
    DebugPrint("BP_SplineTrain_Dynamic: FindStateIdByNumber FAILED - no StateIdList for UnitId=", self.UnitId, "mechanismData=", mechanismData and "exists" or "nil")
    return nil
  end
  for _, id in ipairs(mechanismData.StateIdList) do
    if type(id) == "number" and id % 10 == stateNum then
      DbgPrint(self, "BP_SplineTrain_Dynamic: FindStateIdByNumber OK", "UnitId=", self.UnitId, "stateNum=", stateNum, "foundStateId=", id)
      return id
    end
  end
  DebugPrint("BP_SplineTrain_Dynamic: FindStateIdByNumber FAILED", "stateNum=", stateNum, "not found in StateIdList={", table.concat(mechanismData.StateIdList, ","), "}")
  return nil
end

local AllTrains = {}

local function CreateDynamicComponent(owner, class, name)
  local comp
  local needRegister = false
  if owner.AddComponentByClass then
    comp = owner:AddComponentByClass(class, false, UE4.FTransform(), false)
  end
  if (not comp or not IsValid(comp)) and NewObject then
    comp = NewObject(class, owner, name)
    needRegister = true
  end
  if needRegister and comp and comp.RegisterComponent then
    comp:RegisterComponent()
  end
  return comp
end

function M:IsSequentialRevealEnabled()
  return self.EnableSequentialReveal ~= false
end

function M:GetSequentialRevealSpeed()
  local configuredSpeed = self.RevealSpeed
  if type(configuredSpeed) == "number" and configuredSpeed > 0 then
    return configuredSpeed
  end
  return DEFAULT_REVEAL_SPEED
end

function M:GetSequentialRevealHalfLength(carriageIndex)
  if 1 == carriageIndex then
    return self._CachedHeadHX or DEFAULT_HEAD_HALF_X
  end
  return self._CachedBodyHX or DEFAULT_BODY_HALF_X
end

function M:CreateSequentialRevealMIDs(mesh)
  local result = {}
  if not mesh or not IsValid(mesh) then
    return result
  end
  local materialCount = mesh.GetNumMaterials and mesh:GetNumMaterials() or 0
  for materialIndex = 0, materialCount - 1 do
    local mid = mesh:CreateDynamicMaterialInstance(materialIndex)
    if mid and IsValid(mid) then
      mid:SetScalarParameterValue(REVEAL_PARAMETER_NAME, REVEAL_HIDDEN_VALUE)
      table.insert(result, mid)
    end
  end
  return result
end

function M:InitializeSequentialRevealMaterials()
  if self._SequentialRevealMaterialsInitialized then
    return
  end
  self._SequentialRevealMeshMIDs = {}
  self._SequentialRevealConnectMIDs = {}
  for i = 1, self.ActiveMeshCount or 0 do
    self._SequentialRevealMeshMIDs[i] = self:CreateSequentialRevealMIDs(self.AllTrainMeshes and self.AllTrainMeshes[i])
  end
  for i = 1, self.ActiveConnectCount or 0 do
    self._SequentialRevealConnectMIDs[i] = self:CreateSequentialRevealMIDs(self.AllConnectMeshes and self.AllConnectMeshes[i])
  end
  self._SequentialRevealMaterialsInitialized = true
end

local function SetRevealDisValue(materials, value)
  if not materials then
    return
  end
  for _, mid in ipairs(materials) do
    if mid and IsValid(mid) then
      mid:SetScalarParameterValue(REVEAL_PARAMETER_NAME, value)
    end
  end
end

function M:GetSequentialRevealHeadFront()
  if (self.ActiveMeshCount or 0) <= 0 then
    return 0
  end
  return self:GetCarriageSplineDistance(1) + self:GetSequentialRevealHalfLength(1)
end

function M:GetSequentialRevealMeshSegment(carriageIndex)
  local headFront = self:GetSequentialRevealHeadFront()
  local center = self:GetCarriageSplineDistance(carriageIndex)
  local halfLength = self:GetSequentialRevealHalfLength(carriageIndex)
  local segmentStart = headFront - (center + halfLength)
  local segmentLength = math.max(halfLength * 2, MIN_REVEAL_SEGMENT_LENGTH)
  return math.max(segmentStart, 0), segmentLength
end

function M:GetSequentialRevealConnectSegment(connectIndex)
  local headFront = self:GetSequentialRevealHeadFront()
  local firstCenter = self:GetCarriageSplineDistance(connectIndex)
  local secondCenter = self:GetCarriageSplineDistance(connectIndex + 1)
  local firstBack = firstCenter - self:GetSequentialRevealHalfLength(connectIndex)
  local secondFront = secondCenter + self:GetSequentialRevealHalfLength(connectIndex + 1)
  local firstOffset = headFront - firstBack
  local secondOffset = headFront - secondFront
  local segmentStart = math.min(firstOffset, secondOffset)
  local segmentEnd = math.max(firstOffset, secondOffset)
  return math.max(segmentStart, 0), math.max(segmentEnd - segmentStart, MIN_REVEAL_SEGMENT_LENGTH)
end

function M:GetSequentialRevealTotalLength()
  if (self.ActiveMeshCount or 0) <= 0 then
    return 0
  end
  local tailIndex = self.ActiveMeshCount
  local tailCenter = self:GetCarriageSplineDistance(tailIndex)
  local tailBack = tailCenter - self:GetSequentialRevealHalfLength(tailIndex)
  return math.max(self:GetSequentialRevealHeadFront() - tailBack, MIN_REVEAL_SEGMENT_LENGTH)
end

local function SegmentProgress(revealDistance, segmentStart, segmentLength)
  return math.max(0, math.min(1, (revealDistance - segmentStart) / math.max(segmentLength, MIN_REVEAL_SEGMENT_LENGTH)))
end

function M:IsSequentialRevealMeshVisible(carriageIndex)
  if not self:IsSequentialRevealEnabled() then
    return true
  end
  return self._SequentialRevealMeshVisible ~= nil and self._SequentialRevealMeshVisible[carriageIndex] == true
end

function M:IsSequentialRevealConnectVisible(connectIndex)
  if not self:IsSequentialRevealEnabled() then
    return true
  end
  return self._SequentialRevealConnectVisible ~= nil and self._SequentialRevealConnectVisible[connectIndex] == true
end

function M:ApplySequentialRevealDistance(revealDistance)
  local distance = math.max(revealDistance or 0, 0)
  self._SequentialRevealDistance = distance
  self._SequentialRevealMeshVisible = self._SequentialRevealMeshVisible or {}
  self._SequentialRevealConnectVisible = self._SequentialRevealConnectVisible or {}
  for i = 1, self.ActiveMeshCount or 0 do
    local mesh = self.AllTrainMeshes and self.AllTrainMeshes[i]
    if mesh and IsValid(mesh) then
      local segmentStart, segmentLength = self:GetSequentialRevealMeshSegment(i)
      local progress = SegmentProgress(distance, segmentStart, segmentLength)
      local revealVisible = progress > 0
      self._SequentialRevealMeshVisible[i] = revealVisible
      SetRevealDisValue(self._SequentialRevealMeshMIDs and self._SequentialRevealMeshMIDs[i], REVEAL_HIDDEN_VALUE + (REVEAL_VISIBLE_VALUE - REVEAL_HIDDEN_VALUE) * progress)
      local portalVisible = not self._IsBoss or self.AlwaysShow == true or self._PortalRevealed and true == self._PortalRevealed[i]
      local shouldShow = revealVisible and portalVisible and not self._TrainHidden
      mesh:SetVisibility(shouldShow, true)
      mesh:SetHiddenInGame(not shouldShow, true)
      if self.SoundTrigger and mesh == self.HeadMesh then
        self.SoundTrigger:SetVisibility(false, true)
        self.SoundTrigger:SetHiddenInGame(true, true)
      end
    end
  end
  for i = 1, self.ActiveConnectCount or 0 do
    local mesh = self.AllConnectMeshes and self.AllConnectMeshes[i]
    if mesh and IsValid(mesh) then
      local segmentStart, segmentLength = self:GetSequentialRevealConnectSegment(i)
      local progress = SegmentProgress(distance, segmentStart, segmentLength)
      local revealVisible = progress > 0
      self._SequentialRevealConnectVisible[i] = revealVisible
      SetRevealDisValue(self._SequentialRevealConnectMIDs and self._SequentialRevealConnectMIDs[i], REVEAL_HIDDEN_VALUE + (REVEAL_VISIBLE_VALUE - REVEAL_HIDDEN_VALUE) * progress)
      local portalVisible = not self._IsBoss or self.AlwaysShow == true or self._PortalRevealed and true == self._PortalRevealed[i] and true == self._PortalRevealed[i + 1]
      local shouldShow = revealVisible and portalVisible and not self._TrainHidden
      mesh:SetVisibility(shouldShow, true)
      mesh:SetHiddenInGame(not shouldShow, true)
    end
  end
end

function M:ResetSequentialReveal()
  self._SequentialRevealPlaying = false
  self._SequentialRevealDistance = 0
  self._SequentialRevealMeshVisible = {}
  self._SequentialRevealConnectVisible = {}
  self:InitializeSequentialRevealMaterials()
  local showFully = self._IsStatic or not self:IsSequentialRevealEnabled()
  self:ApplySequentialRevealDistance(showFully and self:GetSequentialRevealTotalLength() or 0)
end

function M:StartSequentialReveal()
  self:ResetSequentialReveal()
  if not self:IsSequentialRevealEnabled() then
    return
  end
  self._SequentialRevealPlaying = true
  if self.PrimaryActorTick then
    self.PrimaryActorTick.bCanEverTick = true
  end
  if self.SetActorTickInterval then
    self:SetActorTickInterval(0)
  end
  self:SetActorTickEnabled(true)
end

function M:UpdateSequentialRevealTick(DeltaSeconds)
  if not self._SequentialRevealPlaying then
    return
  end
  if not DeltaSeconds or DeltaSeconds <= 0 then
    return
  end
  local totalLength = self:GetSequentialRevealTotalLength()
  local nextDistance = math.min((self._SequentialRevealDistance or 0) + self:GetSequentialRevealSpeed() * DeltaSeconds, totalLength)
  self:ApplySequentialRevealDistance(nextDistance)
  if totalLength <= nextDistance then
    self._SequentialRevealPlaying = false
  end
end

local function HideNamedComponentSeries(actor, baseName, maxIndex)
  if actor[baseName] then
    actor:HideComponent(actor[baseName])
  end
  for i = 1, maxIndex do
    local comp = actor[baseName .. i]
    if comp then
      actor:HideComponent(comp)
    end
  end
end

function M:ReceiveBeginPlay()
  if self.BpBorn and IsAuthority(self) and self.TryInitActorInfo then
    self:TryInitActorInfo("BeginPlay")
  end
  M.Super.ReceiveBeginPlay(self)
  self:SetActorTickEnabled(false)
  if not self.IsDebug then
    return
  end
  if self.AddTimer then
    self:AddTimer(DELAYED_INIT_SEC, function()
      if not self._CarriagesBuilt then
        self:EnsureTrainInitialized(nil)
      end
    end, false, 0, "SplineTrainDelayedInit")
  end
end

function M:_DestroyGeneratedTrainForMechanismReset()
  DebugPrint("BP_SplineTrain_Dynamic: DestroyGeneratedTrainForMechanismReset", "UnitId=", self.UnitId, "CarriagesBuilt=", self._CarriagesBuilt, "HasCompletedState0To1=", self._HasCompletedState0To1, "TrainHidden=", self._TrainHidden, "IsMoving=", self.IsMoving)
  self.IsMoving = false
  self._RailTrainSfxPlayed = false
  self:ClearMoveTimer()
  self:ClearLoopResetTimer()
  if self.RemoveTimer then
    self:RemoveTimer("TrainTickHeartbeat")
    self:RemoveTimer(TRAIN_LIFETIME_TIMER_KEY)
  end
  self:SetActorTickEnabled(false)
  self:StopLoop()
  self:_ClearAllNamedTimers()
  self:DestroyPortalVfx()
  if self._DodgePromptActive then
    self:HideDodgePrompt(self._DodgePlayer)
  end
  self:_HideAllLegacyVisuals()
  if self.SetActorHiddenInGame then
    self:SetActorHiddenInGame(true)
  end
  self._TrainHidden = true
  self:DisableTrainCollisions(true)
  if self.HeadMesh and IsValid(self.HeadMesh) and self.HeadMesh.K2_SetRelativeLocationAndRotation then
    self.HeadMesh:K2_SetRelativeLocationAndRotation(FVector(0, 0, 0), FRotator(0, 0, 0), false, nil, false)
  end
  self:ClearCarriages()
  self._TrainDestroying = false
  self.CurrentDistance = nil
  self._CachedStartDistance = nil
  self._CachedStartLocalLoc = nil
  self._CachedStartLocalRot = nil
  self.IsActive = false
  self.IsMoving = false
  self._HasCompletedState0To1 = false
end

function M:ReceiveEndPlay(Reason)
  AllTrains[self] = nil
  EventManager:RemoveEvent(EventID.OnSlideMechSwitchSuccess, self)
  self:_UnbindDirectSourceWatch()
  self:_DestroyGeneratedTrainForMechanismReset()
  M.Super.ReceiveEndPlay(self, Reason)
end

function M:RecoverBpBornData()
  DebugPrint("BP_SplineTrain_Dynamic: RecoverBpBornData", "UnitId=", self.UnitId, "StateId=", self.StateId, "CurrentDistance=", self.CurrentDistance)
  self:_DestroyGeneratedTrainForMechanismReset()
  M.Super.RecoverBpBornData(self)
end

function M:CommonInitInfo(Info)
  self:EnsureTrainInitialized(Info)
  M.Super.CommonInitInfo(self, Info)
end

function M:ClientInitInfo(Info)
  self:EnsureTrainInitialized(Info)
  M.Super.ClientInitInfo(self, Info)
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self:EnsureTrainInitialized(Info)
  self:DisableLegacyTriggerBoxes()
end

function M:AuthorityInitInfo(Info)
  M.Super.AuthorityInitInfo(self, Info)
  local NeedAttach = Info.BoolParams:FindRef("NeedAttach")
  local Boss = self:GetDirectSource()
  if not IsValid(Boss) and Info and IsValid(Info.DirectSource) then
    Boss = Info.DirectSource
  end
  if IsValid(Boss) then
    if (not self.QuestChainId or 0 == self.QuestChainId) and Boss.QuestChainId and 0 ~= Boss.QuestChainId then
      self.QuestChainId = Boss.QuestChainId
    end
    if (not self.QuestId or 0 == self.QuestId) and Boss.QuestId and 0 ~= Boss.QuestId then
      self.QuestId = Boss.QuestId
    end
  end
  if NeedAttach and IsValid(Boss) then
    local PosIndex = Info.IntParams:Find("PosIndex")
    local PosComp = Boss["Pos" .. PosIndex]
    local ArrowComp = Boss["Arrow" .. PosIndex]
    if IsValid(PosComp) and IsValid(ArrowComp) then
      self:K2_SetActorLocationAndRotation(PosComp:K2_GetComponentLocation(), ArrowComp:K2_GetComponentRotation(), false, nil, true)
    end
    if IsValid(Boss.Core) then
      self:K2_AttachToComponent(Boss.Core, "None", UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, true)
    end
  end
  if IsValid(Boss) then
    self:_BindDirectSourceWatch(Boss)
  end
end

function M:_BindDirectSourceWatch(Boss)
  if not IsValid(Boss) then
    return
  end
  self:_UnbindDirectSourceWatch()
  self._CachedDirectSource = Boss
  self._HadDirectSource = true
  if Boss.OnDestroyed and Boss.OnDestroyed.Add then
    Boss.OnDestroyed:Add(self, self._OnDirectSourceDestroyed)
    self._DirectSourceDestroyBound = true
  end
  if self.AddTimer then
    if self.RemoveTimer then
      self:RemoveTimer("DirectSourceWatch")
    end
    self:AddTimer(TICK_HEARTBEAT_INTERVAL, function()
      self:_CheckDirectSourceStillAlive()
    end, true, 0, "DirectSourceWatch", true)
  end
  DebugPrint("BP_SplineTrain_Dynamic: BindDirectSourceWatch", "train=", self:GetName(), "source=", Boss:GetName(), "QuestChainId=", self.QuestChainId)
end

function M:_UnbindDirectSourceWatch()
  local Boss = self._CachedDirectSource
  if self._DirectSourceDestroyBound and IsValid(Boss) and Boss.OnDestroyed and Boss.OnDestroyed.Remove then
    Boss.OnDestroyed:Remove(self, self._OnDirectSourceDestroyed)
  end
  self._DirectSourceDestroyBound = false
  self._CachedDirectSource = nil
  if self.RemoveTimer then
    self:RemoveTimer("DirectSourceWatch")
  end
end

function M:_OnDirectSourceDestroyed()
  if self._TrainDestroying then
    return
  end
  DebugPrint("BP_SplineTrain_Dynamic: DirectSource destroyed, self-destroy", "train=", self:GetName(), "UnitId=", self.UnitId)
  self:_UnbindDirectSourceWatch()
  self._HadDirectSource = false
  self:_DestroyTrainByReason(EDestroyReason.QuestChainClear, "DirectSourceGone")
end

function M:_CheckDirectSourceStillAlive()
  if self._TrainDestroying or not self._HadDirectSource then
    return
  end
  local cached = self._CachedDirectSource
  if IsValid(cached) then
    return
  end
  local live = self.GetDirectSource and self:GetDirectSource() or nil
  if IsValid(live) then
    self._CachedDirectSource = live
    return
  end
  local srcEid = self.GetDirectSourceEid and self:GetDirectSourceEid() or 0
  if 0 == srcEid then
    self._HadDirectSource = false
    return
  end
  DebugPrint("BP_SplineTrain_Dynamic: DirectSource missing (heartbeat), self-destroy", "train=", self:GetName(), "DirectSourceEid=", srcEid)
  self._HadDirectSource = false
  self:_UnbindDirectSourceWatch()
  self:_DestroyTrainByReason(EDestroyReason.QuestChainClear, "DirectSourceGoneHeartbeat")
end

function M:ApplyTrainConfig(Info)
  if (not self.UnitParams or not next(self.UnitParams)) and self.UnitId and self.UnitId > 0 then
    local mechanismData = DataMgr.Mechanism[self.UnitId]
    if mechanismData then
      self.Data = self.Data or mechanismData
      self.UnitParams = mechanismData.UnitParams or self.UnitParams
    end
  end
  local params = not self.UnitParams and self.Data and self.Data.UnitParams
  if params then
    if self._IsBoss == nil then
      self._IsBoss = params.IsBoss
    end
    if nil == self._IsStatic then
      self._IsStatic = params.IsStatic and true or false
    end
    if self._IsBoss and self._IsStatic then
      DebugPrint("BP_SplineTrain_Dynamic: WARNING - IsBoss 与 IsStatic 互斥但同时配置，", "UnitId=", self.UnitId, "；按 IsBoss 处理，IsStatic 忽略")
      self._IsStatic = false
    end
    if params.CarriageCount and params.CarriageCount > 0 then
      self._ConfigCarriageCount = params.CarriageCount
    end
    if params.HeadMeshPath and params.HeadMeshPath ~= "" then
      self._ConfigHeadMeshPath = params.HeadMeshPath
    end
    if params.BodyMeshPath and "" ~= params.BodyMeshPath then
      self._ConfigBodyMeshPath = params.BodyMeshPath
    end
    if params.ConnectMeshPath and "" ~= params.ConnectMeshPath then
      self._ConfigConnectMeshPath = params.ConnectMeshPath
    end
  end
  if Info and Info.IntParams then
    local count = Info.IntParams:Find("CarriageCount")
    if count and count > 0 then
      self._ConfigCarriageCount = count
    end
  end
end

local function SnapshotVector(vec)
  if not vec then
    return nil
  end
  return {
    X = vec.X,
    Y = vec.Y,
    Z = vec.Z
  }
end

local function SnapshotMeshKey(mesh)
  if mesh and IsValid(mesh) then
    if mesh.GetPathName then
      return mesh:GetPathName()
    end
    if mesh.GetName then
      return mesh:GetName()
    end
  end
  return nil
end

function M:CollectInitParamsSnapshot()
  self:ApplyTrainConfig(nil)
  local params = not self.UnitParams and self.Data and self.Data.UnitParams
  local unitParamsSnap
  if params then
    unitParamsSnap = {
      CarriageCount = params.CarriageCount,
      HeadMeshPath = params.HeadMeshPath,
      BodyMeshPath = params.BodyMeshPath,
      ConnectMeshPath = params.ConnectMeshPath,
      IsBoss = params.IsBoss
    }
  end
  return {
    UnitParams = unitParamsSnap,
    CarriageCount = self.CarriageCount,
    _ConfigCarriageCount = self._ConfigCarriageCount,
    _ConfigHeadMeshPath = self._ConfigHeadMeshPath,
    _ConfigBodyMeshPath = self._ConfigBodyMeshPath,
    _ConfigConnectMeshPath = self._ConfigConnectMeshPath,
    _ConfigPortalEffectPath = self._ConfigPortalEffectPath,
    HeadMeshKey = SnapshotMeshKey(self:ResolveHeadMesh()),
    BodyMeshKey = SnapshotMeshKey(self:ResolveBodyMesh()),
    ConnectMeshKey = SnapshotMeshKey(self:ResolveConnectMesh()),
    Distance = self.Distance,
    FirstDistance = self.FirstDistance,
    FirstDistanceOffset = self.FirstDistanceOffset,
    bUseManualSpacing = self.bUseManualSpacing,
    speed = self.speed,
    IsLoop = self.IsLoop,
    Loop = self.Loop,
    LoopTime = self.LoopTime,
    LoopTIme = self.LoopTIme,
    PortalStartDelay = self.PortalStartDelay,
    PrepareStartDelay = self.PrepareStartDelay,
    bAutoStartOnSpawn = self.bAutoStartOnSpawn,
    PortalOffset = SnapshotVector(self.PortalOffset),
    PortalPassDistance = self.PortalPassDistance,
    HeadBehindPortalDistance = self.HeadBehindPortalDistance,
    ConnectDistanceOffset = self.ConnectDistanceOffset,
    ConnectFirstDistanceOffset = self.ConnectFirstDistanceOffset,
    HeadOffset = SnapshotVector(self.HeadOffset),
    BodyOffset = SnapshotVector(self.BodyOffset),
    ConnectOffset = SnapshotVector(self.ConnectOffset),
    HeadOffsetYaw = self.HeadOffsetYaw,
    ConnectOffsetYaw = self.ConnectOffsetYaw,
    HeadMeshScale = SnapshotVector(self.HeadMeshScale),
    BodyMeshScale = SnapshotVector(self.BodyMeshScale),
    BoxScale = SnapshotVector(self.BoxScale),
    EnableDeathBox = self.EnableDeathBox,
    EnableSlowBox = self.EnableSlowBox,
    SlowBoxForwardDistance = self.SlowBoxForwardDistance,
    SlowBoxScale = SnapshotVector(self.SlowBoxScale)
  }
end

function M:SaveInitParamsSnapshot()
  self._LastInitParamsSnapshot = self:CollectInitParamsSnapshot()
end

function M:IsInitParamsUnchanged()
  if not self._LastInitParamsSnapshot then
    return false
  end
  local current = self:CollectInitParamsSnapshot()
  return CommonUtils.DeepEqual(current, self._LastInitParamsSnapshot)
end

function M:ResolveSpline()
  if self.Spline and IsValid(self.Spline) and self.Spline ~= self.MyDynamicSpline then
    return self.Spline
  end
  local found
  local allComponents = self:K2_GetComponentsByClass(UE4.USplineComponent.StaticClass())
  if allComponents then
    for i = 1, allComponents:Length() do
      local comp = allComponents:Get(i)
      if comp and IsValid(comp) and comp ~= self.MyDynamicSpline then
        found = comp
        break
      end
    end
  end
  if found then
    DebugPrint("BP_SplineTrain_Dynamic: found other Spline component, using it")
    self.Spline = found
    return found
  end
  if self.MyDynamicSpline and IsValid(self.MyDynamicSpline) then
    DebugPrint("BP_SplineTrain_Dynamic: no other Spline found, using MyDynamicSpline")
    self.Spline = self.MyDynamicSpline
    return self.MyDynamicSpline
  end
  DebugPrint("BP_SplineTrain_Dynamic: no Spline component found at all")
  return nil
end

function M:UseSplineTrack()
  if not (self.Spline and IsValid(self.Spline)) or not ((self.SplineLength or 0) > 0) then
    return false
  end
  if self._IsStatic then
    if not self._IsStaticLogged then
      self._IsStaticLogged = true
      DebugPrint("BP_SplineTrain_Dynamic: IsStatic=true，忽略 Spline(", self.Spline:GetName(), ", len=", self.SplineLength, ")，走直线模式（Forward 箭头基准）", "UnitId=", self.UnitId)
    end
    return false
  end
  return true
end

function M:ResolveCarriageCount()
  local configCount = self._ConfigCarriageCount and self._ConfigCarriageCount > 0 and math.floor(self._ConfigCarriageCount) or nil
  local blueprintCount = self.CarriageCount and self.CarriageCount > 0 and math.floor(self.CarriageCount) or nil
  if blueprintCount then
    return blueprintCount
  end
  if configCount then
    return configCount
  end
  DebugPrint("BP_SplineTrain_Dynamic: CarriageCount not configured in blueprint or UnitParams")
  return 0
end

function M:GetStaticMeshAsset(meshRef)
  if not meshRef or not IsValid(meshRef) then
    return nil
  end
  if meshRef.GetStaticMesh then
    local mesh = meshRef:GetStaticMesh()
    if mesh and IsValid(mesh) then
      return mesh
    end
    return nil
  end
  if meshRef.GetBounds then
    return meshRef
  end
  return nil
end

function M:_ResolveMeshByKind(assetField, configPathField, legacyCompName)
  local mesh = self:GetStaticMeshAsset(self[assetField])
  if mesh then
    return mesh
  end
  local configPath = self[configPathField]
  if configPath then
    mesh = self:LoadStaticMeshAsset(configPath)
    if mesh then
      return mesh
    end
  end
  return self:GetMeshFromLegacyComponent(legacyCompName)
end

function M:ResolveHeadMesh()
  return self:_ResolveMeshByKind("HeadMesh", "_ConfigHeadMeshPath", "Mesh")
end

function M:ResolveBodyMesh()
  return self:_ResolveMeshByKind("BodyMesh", "_ConfigBodyMeshPath", "Mesh1")
end

function M:ResolveConnectMesh()
  return self:_ResolveMeshByKind("ConnectMesh", "_ConfigConnectMeshPath", "Connect")
end

function M:GetExpectedConnectCount(carriageCount)
  carriageCount = carriageCount or self:ResolveCarriageCount()
  if not self:ResolveConnectMesh() then
    return 0
  end
  return carriageCount >= 2 and carriageCount - 1 or 0
end

function M:CanChangeState()
  return true
end

function M:ResetDeathStateForStateMachine()
  local wasBIsDead = self.bIsDead
  local wasIsDead = self.IsDead and self:IsDead()
  DebugPrint("BP_SplineTrain_Dynamic: ResetDeathStateForStateMachine BEFORE", "UnitId=", self.UnitId, "bIsDead=", wasBIsDead, "IsDead()=", wasIsDead)
  self.bIsDead = false
  if self.SetDead then
    local reason = EDeathReason and EDeathReason.NoReason or 0
    self:SetDead(false, reason, 0, 0)
  end
  local nowIsDead = self.IsDead and self:IsDead()
  DebugPrint("BP_SplineTrain_Dynamic: ResetDeathStateForStateMachine AFTER", "UnitId=", self.UnitId, "bIsDead=", self.bIsDead, "IsDead()=", nowIsDead)
end

function M:ChangeState(Type, PlayerId, NextState)
  DebugPrint("BP_SplineTrain_Dynamic: ChangeState", "Type=", Type, "NextState=", NextState, "IsDead()=", self.IsDead and self:IsDead(), "bIsDead=", self.bIsDead, "TimeSeconds=", UE4.UGameplayStatics.GetTimeSeconds(self), "\n", debug.traceback("", 2))
  self:ResetDeathStateForStateMachine()
  M.Super.ChangeState(self, Type, PlayerId, NextState)
end

function M:EnsureTrainInitialized(Info)
  self:ApplyTrainConfig(Info)
  self:ResolveSpline()
  self.SplineLength = self.Spline and IsValid(self.Spline) and self.Spline:GetSplineLength() or 0
  self.MoveDirection = self.MoveDirection or 1
  self.IsMoving = self.IsMoving == true
  self.LoopResetTimerHandle = self.LoopResetTimerHandle or nil
  self:HideLegacyBlueprintComponents()
  if self._IsBuildingTrain then
    return
  end
  if not self:ShouldRebuildCarriages() then
    return
  end
  self._IsBuildingTrain = true
  local buildOk, buildErr = pcall(self.BuildCarriages, self)
  self._IsBuildingTrain = false
  if not buildOk then
    print(_G.LogTag, "[SplineTrain] ERROR - BuildCarriages threw exception!", "UnitId=", self.UnitId, "ActorName=", self:GetName(), "Error=", tostring(buildErr), "-- _IsBuildingTrain lock released, will retry on next EnsureTrainInitialized")
    return
  end
  self._CarriagesBuilt = true
  self:ResetTrain()
  AllTrains[self] = true
  self:_TryBindOwnTrackMech(true)
end

function M:ShouldRebuildCarriages()
  local expectedCount = self:ResolveCarriageCount()
  if not (self._CarriagesBuilt and self.AllTrainMeshes) or 0 == #self.AllTrainMeshes then
    return true
  end
  if self.ActiveMeshCount ~= expectedCount then
    return true
  end
  local expectedConnectCount = self:GetExpectedConnectCount(expectedCount)
  return (self.ActiveConnectCount or 0) ~= expectedConnectCount
end

function M:SetupTrainMeshCollision(comp)
  if not comp or not IsValid(comp) then
    return
  end
  local profile
  if self.DeathCollisionBox and IsValid(self.DeathCollisionBox) and self.DeathCollisionBox.GetCollisionProfileName then
    profile = self.DeathCollisionBox:GetCollisionProfileName()
  end
  if profile and comp.SetCollisionProfileName then
    comp:SetCollisionProfileName(profile, true)
  else
    comp:SetCollisionResponseToAllChannels(ECollisionResponse.ECR_Ignore)
    comp:SetCollisionResponseToChannel(ECollisionChannel.ECC_Pawn, ECollisionResponse.ECR_Overlap)
  end
  comp:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
  if comp.SetGenerateOverlapEvents then
    comp:SetGenerateOverlapEvents(true)
  end
  comp.OnComponentBeginOverlap:Clear()
  comp.OnComponentBeginOverlap:Add(self, self.OnTrainMeshOverlap)
end

function M:SetCarriageMeshCollision(carriageIndex, enable)
  local mesh = self.AllTrainMeshes and self.AllTrainMeshes[carriageIndex]
  if not mesh or not IsValid(mesh) then
    return
  end
  enable = enable and true or false
  self._MeshCollisionOn = self._MeshCollisionOn or {}
  if self._MeshCollisionOn[carriageIndex] == enable then
    return
  end
  self._MeshCollisionOn[carriageIndex] = enable
  mesh:SetCollisionEnabled(enable and ECollisionEnabled.QueryOnly or ECollisionEnabled.NoCollision)
end

function M:CreateCarriageMesh(StaticMesh, CompName, bDeathCollision)
  if not StaticMesh or not IsValid(StaticMesh) then
    return nil
  end
  local attachParent = self:GetTrainAttachComponent()
  if not attachParent or not IsValid(attachParent) then
    DebugPrint("BP_SplineTrain_Dynamic: attach parent missing")
    return nil
  end
  local comp = CreateDynamicComponent(self, UE4.UStaticMeshComponent.StaticClass(), CompName)
  if not comp or not IsValid(comp) then
    DebugPrint("BP_SplineTrain_Dynamic: failed to create mesh component", CompName)
    return nil
  end
  comp:SetStaticMesh(StaticMesh)
  comp:SetMobility(EComponentMobility.Movable)
  comp:SetVisibility(true, true)
  comp:SetHiddenInGame(false, true)
  if bDeathCollision then
    self:SetupTrainMeshCollision(comp)
  else
    comp:SetCollisionEnabled(ECollisionEnabled.NoCollision)
  end
  local meshScale = self:ResolveMeshScaleVector(comp)
  if 1 ~= meshScale.X or 1 ~= meshScale.Y or 1 ~= meshScale.Z then
    comp:SetWorldScale3D(meshScale)
  end
  comp:K2_AttachToComponent(attachParent, "", EAttachmentRule.KeepRelative, EAttachmentRule.KeepRelative, EAttachmentRule.KeepRelative, false)
  return comp
end

function M:ClearCarriages()
  if self._DodgePromptActive then
    self:HideDodgePrompt(self._DodgePlayer)
  end
  if self.AllTrainMeshes then
    for i = 2, #self.AllTrainMeshes do
      local mesh = self.AllTrainMeshes[i]
      if mesh and IsValid(mesh) then
        mesh:K2_DestroyComponent(mesh)
      end
    end
  end
  if self.AllConnectMeshes then
    for _, mesh in ipairs(self.AllConnectMeshes) do
      if mesh and IsValid(mesh) then
        mesh:K2_DestroyComponent(mesh)
      end
    end
  end
  self.AllTrainMeshes = {}
  self.AllConnectMeshes = {}
  self._SequentialRevealMeshMIDs = {}
  self._SequentialRevealConnectMIDs = {}
  self._SequentialRevealMeshVisible = {}
  self._SequentialRevealConnectVisible = {}
  self._SequentialRevealDistance = 0
  self._SequentialRevealPlaying = false
  self._SequentialRevealMaterialsInitialized = false
  self.HeadMeshComponent = nil
  self._HeadAppliedScale = nil
  self.ActiveMeshCount = 0
  self.ActiveConnectCount = 0
  self._CarriagesBuilt = false
  self._CachedSpacing = nil
  self._CachedFirstDist = nil
  self._CachedHeadMesh = nil
  self._CachedBodyMesh = nil
  self._CachedHeadHX, self._CachedHeadHY, self._CachedHeadHZ = nil, nil, nil
  self._CachedBodyHX, self._CachedBodyHY, self._CachedBodyHZ = nil, nil, nil
  AllTrains[self] = nil
  if self.DeathCollisionBox and IsValid(self.DeathCollisionBox) then
    self.DeathCollisionBox.OnComponentBeginOverlap:Clear()
  end
  if self.HeadMesh and IsValid(self.HeadMesh) then
    self.HeadMesh.OnComponentBeginOverlap:Clear()
    self.HeadMesh:SetCollisionEnabled(ECollisionEnabled.NoCollision)
  end
  self._MeshCollisionOn = {}
  if self._SlowBox and IsValid(self._SlowBox) then
    self._SlowBox.OnComponentBeginOverlap:Clear()
    self._SlowBox.OnComponentEndOverlap:Clear()
  end
  self._SlowBox = nil
end

function M:BuildCarriages()
  self:ClearCarriages()
  local count = self:ResolveCarriageCount()
  local bodyMesh = self:ResolveBodyMesh()
  local connectMesh = self:ResolveConnectMesh()
  self.AllTrainMeshes = {}
  self.AllConnectMeshes = {}
  if self.HeadMesh and IsValid(self.HeadMesh) then
    self.HeadMesh:SetVisibility(true, true)
    self.HeadMesh:SetHiddenInGame(false, true)
    if self.SoundTrigger then
      self.SoundTrigger:SetVisibility(false, true)
      self.SoundTrigger:SetHiddenInGame(true, true)
    end
    self:SetupTrainMeshCollision(self.HeadMesh)
    self.HeadMeshComponent = self.HeadMesh
    local headScale = self:ResolveMeshScaleVector(self.HeadMeshComponent)
    if 1 ~= headScale.X or 1 ~= headScale.Y or 1 ~= headScale.Z then
      self.HeadMesh:SetWorldScale3D(headScale)
      self._HeadAppliedScale = headScale
    else
      local cs = self.HeadMesh.K2_GetComponentScale and self.HeadMesh:K2_GetComponentScale() or nil
      self._HeadAppliedScale = cs and FVector(cs.X or 1, cs.Y or 1, cs.Z or 1) or FVector(1, 1, 1)
    end
    table.insert(self.AllTrainMeshes, self.HeadMesh)
    DebugPrint("BP_SplineTrain_Dynamic: head from blueprint HeadMesh")
  else
    DebugPrint("BP_SplineTrain_Dynamic: WARNING - HeadMesh not found in blueprint")
  end
  DebugPrint("BP_SplineTrain_Dynamic: BuildCarriages", "count=", count, "head=", self.HeadMeshComponent and "valid" or "nil", "bodyMesh=", bodyMesh and bodyMesh:GetName() or "nil", "connectMesh=", connectMesh and connectMesh:GetName() or "nil")
  for i = 2, count do
    local body = self:CreateCarriageMesh(bodyMesh, "DynamicBody_" .. i, true)
    if body then
      table.insert(self.AllTrainMeshes, body)
    end
  end
  local meshCount = #self.AllTrainMeshes
  if connectMesh and meshCount >= 2 then
    for i = 1, meshCount - 1 do
      local connector = self:CreateCarriageMesh(connectMesh, "DynamicConnect_" .. i)
      if connector then
        table.insert(self.AllConnectMeshes, connector)
      end
    end
  end
  self.ActiveMeshCount = #self.AllTrainMeshes
  self.ActiveConnectCount = #self.AllConnectMeshes
  if self.ActiveMeshCount <= 0 then
    DebugPrint("BP_SplineTrain_Dynamic: no carriage meshes created")
    return
  end
  local headMeshAsset = self:ResolveHeadMesh()
  local bodyMeshAsset = self:ResolveBodyMesh()
  self._CachedHeadMesh = headMeshAsset
  self._CachedBodyMesh = bodyMeshAsset
  local headBounds = self:GetMeshCollisionBounds(self.HeadMeshComponent, headMeshAsset)
  self._CachedHeadHX = headBounds and headBounds.hx or DEFAULT_HEAD_HALF_X
  self._CachedHeadOX = headBounds and headBounds.ox or 0
  self._CachedHeadHY = headBounds and headBounds.hy or DEFAULT_BODY_HALF_YZ
  self._CachedHeadHZ = headBounds and headBounds.hz or 0
  self._CachedHeadOY = headBounds and headBounds.oy or 0
  self._CachedHeadOZ = headBounds and headBounds.oz or 0
  local bodyMeshComp = self.AllTrainMeshes[2]
  local bodyBounds = self:GetMeshCollisionBounds(bodyMeshComp, bodyMeshAsset)
  self._CachedBodyHX = bodyBounds and bodyBounds.hx or DEFAULT_BODY_HALF_X
  self._CachedBodyOX = bodyBounds and bodyBounds.ox or 0
  self._CachedBodyHY = bodyBounds and bodyBounds.hy or DEFAULT_BODY_HALF_YZ
  self._CachedBodyHZ = bodyBounds and bodyBounds.hz or DEFAULT_BODY_HALF_YZ
  self._CachedBodyOY = bodyBounds and bodyBounds.oy or 0
  self._CachedBodyOZ = bodyBounds and bodyBounds.oz or 0
  if not bodyMeshComp or not IsValid(bodyMeshComp) then
    self._CachedBodyHX = self._CachedHeadHX * 0.5
    self._CachedBodyOX = self._CachedHeadOX * 0.5
    self._CachedBodyHY = self._CachedHeadHY * 0.5
    self._CachedBodyHZ = self._CachedHeadHZ * 0.5
    self._CachedBodyOY = self._CachedHeadOY * 0.5
    self._CachedBodyOZ = self._CachedHeadOZ * 0.5
  end
  local finalSpacing, finalFirstDist = self:GetSpacingConfig()
  DbgPrint(self, "BP_SplineTrain_Dynamic: BuildCarriages done", "CarriageCount=", count, "ActiveMeshCount=", self.ActiveMeshCount, "ActiveConnectCount=", self.ActiveConnectCount, "finalSpacing=", finalSpacing, "finalFirstDist=", finalFirstDist, "TailOffset=", self:GetTrainTailOffset())
  self:ResetSequentialReveal()
  self:BuildTriggerBoxes()
end

function M:_HideSlowBoxVisual(box)
  if not box or not IsValid(box) then
    return
  end
  box.bDrawOnlyIfSelected = true
  if box.MarkRenderStateDirty then
    box:MarkRenderStateDirty()
  end
end

function M:NormalizeBoxComponentScale(box, boxName)
  if not box or not IsValid(box) then
    return
  end
  local cs = box.K2_GetComponentScale and box:K2_GetComponentScale() or nil
  if not cs then
    return
  end
  local sx, sy, sz = cs.X or 1, cs.Y or 1, cs.Z or 1
  if 1 == sx and 1 == sy and 1 == sz then
    return
  end
  DebugPrint("BP_SplineTrain_Dynamic: NormalizeBoxComponentScale found non-1 scale", "box=", boxName, "scale=(", sx, sy, sz, ") -> reset to (1,1,1)")
  box:SetWorldScale3D(FVector(1, 1, 1))
end

function M:ReparentHeadBoxToRoot(box, boxName)
  if not box or not IsValid(box) then
    return
  end
  local attachParent = self:GetTrainAttachComponent()
  if not attachParent or not IsValid(attachParent) then
    return
  end
  local oldParent = box.GetAttachParent and box:GetAttachParent()
  local oldParentName = oldParent and IsValid(oldParent) and oldParent.GetName and oldParent:GetName() or "nil"
  local cs = box.K2_GetComponentScale and box:K2_GetComponentScale() or nil
  DebugPrint("BP_SplineTrain_Dynamic: ReparentHeadBoxToRoot", "box=", boxName, "oldParent=", oldParentName, "worldScaleBeforeReparent=(", cs and cs.X or "?", cs and cs.Y or "?", cs and cs.Z or "?", ")")
  box:K2_AttachToComponent(attachParent, "", EAttachmentRule.KeepWorld, EAttachmentRule.KeepWorld, EAttachmentRule.SnapToTarget, false)
end

function M:BuildTriggerBoxes()
  if self.DeathCollisionBox and IsValid(self.DeathCollisionBox) then
    self.DeathCollisionBox.OnComponentBeginOverlap:Clear()
    self.DeathCollisionBox:SetCollisionEnabled(ECollisionEnabled.NoCollision)
    self:_HideSlowBoxVisual(self.DeathCollisionBox)
    DebugPrint("BP_SplineTrain_Dynamic: DeathCollisionBox disabled (profile template only, death via carriage mesh)")
  end
  if self.SlowCollisionBox and IsValid(self.SlowCollisionBox) then
    self.SlowCollisionBox.OnComponentBeginOverlap:Clear()
    self.SlowCollisionBox.OnComponentBeginOverlap:Add(self, self.OnSlowBoxOverlap)
    self.SlowCollisionBox.OnComponentEndOverlap:Clear()
    self.SlowCollisionBox.OnComponentEndOverlap:Add(self, self.OnSlowBoxEndOverlap)
    self:_HideSlowBoxVisual(self.SlowCollisionBox)
    self:ReparentHeadBoxToRoot(self.SlowCollisionBox, "SlowCollisionBox")
    self:NormalizeBoxComponentScale(self.SlowCollisionBox, "SlowCollisionBox")
    if self.SlowCollisionBox.SetGenerateOverlapEvents then
      self.SlowCollisionBox:SetGenerateOverlapEvents(true)
    end
    local slowProfile = "OnlyPlayer"
    slowProfile = self.DeathCollisionBox and IsValid(self.DeathCollisionBox) and self.DeathCollisionBox.GetCollisionProfileName and self.DeathCollisionBox:GetCollisionProfileName() or slowProfile
    if self.SlowCollisionBox.SetCollisionProfileName then
      self.SlowCollisionBox:SetCollisionProfileName(slowProfile, true)
    end
    self._SlowBox = self.SlowCollisionBox
    self._SlowBoxLastExtent = nil
    self._SlowBoxCollisionOn = false
    DebugPrint("BP_SplineTrain_Dynamic: SlowCollisionBox bound from blueprint", "profile=", slowProfile, "genOverlap=", self.SlowCollisionBox.GetGenerateOverlapEvents and self.SlowCollisionBox:GetGenerateOverlapEvents() or "?", "EnableSlowBox=", self.EnableSlowBox, "collision=", self.SlowCollisionBox.GetCollisionEnabled and self.SlowCollisionBox:GetCollisionEnabled() or "?")
  else
    DebugPrint("BP_SplineTrain_Dynamic: WARNING - SlowCollisionBox not found in blueprint, slow trigger disabled")
    self._SlowBox = nil
  end
  self._TriggerBoxesLogCount = 0
end

function M:ResolveMeshScaleVector(meshComp)
  local scaleVec
  if meshComp and IsValid(meshComp) and meshComp == self.HeadMeshComponent then
    scaleVec = self.HeadMeshScale or self.BoxScale
  else
    scaleVec = self.BodyMeshScale or self.BoxScale
  end
  if not scaleVec then
    return FVector(1, 1, 1)
  end
  local sx = scaleVec.X and scaleVec.X > 0 and scaleVec.X or 1
  local sy = scaleVec.Y and scaleVec.Y > 0 and scaleVec.Y or 1
  local sz = scaleVec.Z and scaleVec.Z > 0 and scaleVec.Z or 1
  return FVector(sx, sy, sz)
end

function M:GetMeshCollisionBounds(meshComp, staticMesh)
  local ox, oy, oz = 0, 0, 0
  local hx, hy, hz, src, sm
  if meshComp and IsValid(meshComp) then
    sm = self:GetStaticMeshAsset(meshComp)
  end
  if (not sm or not IsValid(sm)) and staticMesh and IsValid(staticMesh) then
    sm = self:GetStaticMeshAsset(staticMesh)
  end
  if sm and IsValid(sm) and sm.GetBounds then
    local meshBounds = sm:GetBounds()
    local extent = meshBounds and (meshBounds.BoxExtent or meshBounds.box_extent)
    local boundsOrigin = meshBounds and (meshBounds.Origin or meshBounds.origin)
    local extX = extent and (extent.X or extent.x) or 0
    if extX > 0 then
      local sx, sy, sz
      if meshComp and meshComp == self.HeadMeshComponent and self._HeadAppliedScale then
        sx, sy, sz = self._HeadAppliedScale.X, self._HeadAppliedScale.Y, self._HeadAppliedScale.Z
      else
        local cs = meshComp and IsValid(meshComp) and meshComp.K2_GetComponentScale and meshComp:K2_GetComponentScale() or nil
        sx, sy, sz = cs and cs.X or 1, cs and cs.Y or 1, cs and cs.Z or 1
        if 1 == sx and 1 == sy and 1 == sz then
          local cfgScale = self:ResolveMeshScaleVector(meshComp)
          if 1 ~= cfgScale.X or 1 ~= cfgScale.Y or 1 ~= cfgScale.Z then
            sx, sy, sz = cfgScale.X, cfgScale.Y, cfgScale.Z
          end
        end
      end
      if boundsOrigin then
        ox = (boundsOrigin.X or boundsOrigin.x or 0) * sx
        oy = (boundsOrigin.Y or boundsOrigin.y or 0) * sy
        oz = (boundsOrigin.Z or boundsOrigin.z or 0) * sz
      end
      hx = extX * sx
      hy = (extent.Y or extent.y or 0) * sy
      hz = (extent.Z or extent.z or 0) * sz
      src = "sm_bounds"
      self._LastBoundsDebug = {
        meshName = sm.GetName and sm:GetName() or "?",
        rawExtX = extX,
        rawExtY = extent.Y or extent.y or 0,
        rawExtZ = extent.Z or extent.z or 0,
        usedScaleX = sx,
        usedScaleY = sy,
        usedScaleZ = sz
      }
    end
  end
  if not src and meshComp and IsValid(meshComp) and meshComp.GetLocalBounds then
    local minV, maxV = meshComp:GetLocalBounds()
    local minX = minV and (minV.X or minV.x) or nil
    local maxX = maxV and (maxV.X or maxV.x) or nil
    if minX and maxX then
      local minY, minZ = minV.Y or minV.y or 0, minV.Z or minV.z or 0
      local maxY, maxZ = maxV.Y or maxV.y or 0, maxV.Z or maxV.z or 0
      local rawHx, rawHy, rawHz = (maxX - minX) * 0.5, (maxY - minY) * 0.5, (maxZ - minZ) * 0.5
      local rawOx, rawOy, rawOz = (maxX + minX) * 0.5, (maxY + minY) * 0.5, (maxZ + minZ) * 0.5
      if rawHx > 0 or rawHy > 0 or rawHz > 0 then
        local sx, sy, sz
        if meshComp == self.HeadMeshComponent and self._HeadAppliedScale then
          sx, sy, sz = self._HeadAppliedScale.X, self._HeadAppliedScale.Y, self._HeadAppliedScale.Z
        else
          local cs = meshComp.K2_GetComponentScale and meshComp:K2_GetComponentScale() or nil
          sx, sy, sz = cs and cs.X or 1, cs and cs.Y or 1, cs and cs.Z or 1
        end
        ox, oy, oz = rawOx * sx, rawOy * sy, rawOz * sz
        hx, hy, hz = rawHx * sx, rawHy * sy, rawHz * sz
        src = "comp_bounds"
        self._LastBoundsDebug = {
          meshName = "(comp_bounds, no asset)",
          rawExtX = rawHx,
          rawExtY = rawHy,
          rawExtZ = rawHz,
          usedScaleX = sx,
          usedScaleY = sy,
          usedScaleZ = sz
        }
      end
    end
  end
  if not src then
    return nil
  end
  return {
    ox = ox,
    oy = oy,
    oz = oz,
    hx = hx,
    hy = hy,
    hz = hz,
    source = src
  }
end

function M:GetMeshWorldBoundsCenter(meshComp, staticMesh)
  if not meshComp or not IsValid(meshComp) then
    return nil, nil
  end
  local loc = meshComp:K2_GetComponentLocation()
  local rot = meshComp:K2_GetComponentRotation()
  local ox, oy, oz
  if meshComp == self.HeadMeshComponent and self._CachedHeadHX then
    ox, oy, oz = self._CachedHeadOX or 0, self._CachedHeadOY or 0, self._CachedHeadOZ or 0
  elseif self._CachedBodyHX then
    ox, oy, oz = self._CachedBodyOX or 0, self._CachedBodyOY or 0, self._CachedBodyOZ or 0
  else
    local b = self:GetMeshCollisionBounds(meshComp, staticMesh)
    if not b then
      return loc, rot
    end
    ox, oy, oz = b.ox, b.oy, b.oz
  end
  local worldOffset = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(FVector(ox, oy, oz), rot)
  return FVector(loc.X + worldOffset.X, loc.Y + worldOffset.Y, loc.Z + worldOffset.Z), rot
end

function M:ProjectMeshBoundsToRotation(meshComp, targetRot, ox, oy, oz, hx, hy, hz)
  if not (meshComp and IsValid(meshComp)) or not targetRot then
    return nil
  end
  if not (hx and hy) or not hz then
    return nil
  end
  ox, oy, oz = ox or 0, oy or 0, oz or 0
  local loc = meshComp:K2_GetComponentLocation()
  local meshRot = meshComp:K2_GetComponentRotation()
  local originOff = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(FVector(ox, oy, oz), meshRot)
  local center = FVector(loc.X + originOff.X, loc.Y + originOff.Y, loc.Z + originOff.Z)
  local maxX, maxY, maxZ = 0, 0, 0
  local signs = {-1, 1}
  for _, sx in ipairs(signs) do
    for _, sy in ipairs(signs) do
      for _, sz in ipairs(signs) do
        local localCorner = FVector(ox + sx * hx, oy + sy * hy, oz + sz * hz)
        local worldOff = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(localCorner, meshRot)
        local rel = FVector(loc.X + worldOff.X - center.X, loc.Y + worldOff.Y - center.Y, loc.Z + worldOff.Z - center.Z)
        local trackLocal = UE4.UKismetMathLibrary.LessLess_VectorRotator(rel, targetRot)
        local tx = math.abs(trackLocal.X or trackLocal.x or 0)
        local ty = math.abs(trackLocal.Y or trackLocal.y or 0)
        local tz = math.abs(trackLocal.Z or trackLocal.z or 0)
        if maxX < tx then
          maxX = tx
        end
        if maxY < ty then
          maxY = ty
        end
        if maxZ < tz then
          maxZ = tz
        end
      end
    end
  end
  if maxX < 1 then
    maxX = hx
  end
  if maxY < 1 then
    maxY = hy
  end
  if maxZ < 1 then
    maxZ = hz
  end
  return maxX, maxY, maxZ, center
end

function M:UpdateTriggerBoxes()
  local bodyHalfX = self._CachedBodyHX
  local bodyHalfY = self._CachedBodyHY
  local bodyHalfZ = self._CachedBodyHZ
  local headHalfX = self._CachedHeadHX
  local headHalfY = self._CachedHeadHY
  local headHalfZ = self._CachedHeadHZ
  local headOriginX = self._CachedHeadOX or 0
  local headOriginY = self._CachedHeadOY or 0
  local headOriginZ = self._CachedHeadOZ or 0
  local headMeshAsset = self._CachedHeadMesh
  local bodyMeshAsset = self._CachedBodyMesh
  if not (bodyHalfX and bodyHalfY) or not bodyHalfZ then
    local bodyMeshComp = self.AllTrainMeshes and self.AllTrainMeshes[2]
    if not bodyMeshAsset then
      bodyMeshAsset = self:ResolveBodyMesh()
      self._CachedBodyMesh = bodyMeshAsset
    end
    local bodyBounds = self:GetMeshCollisionBounds(bodyMeshComp, bodyMeshAsset)
    if bodyBounds then
      bodyHalfX, bodyHalfY, bodyHalfZ = bodyBounds.hx, bodyBounds.hy, bodyBounds.hz
      self._CachedBodyHX, self._CachedBodyHY, self._CachedBodyHZ = bodyHalfX, bodyHalfY, bodyHalfZ
      self._CachedBodyOX, self._CachedBodyOY, self._CachedBodyOZ = bodyBounds.ox, bodyBounds.oy, bodyBounds.oz
    else
      bodyHalfX, bodyHalfY, bodyHalfZ = DEFAULT_BODY_HALF_X, DEFAULT_BODY_HALF_YZ, DEFAULT_BODY_HALF_YZ
    end
  end
  if not (headHalfX and headHalfY) or not headHalfZ then
    if not headMeshAsset then
      headMeshAsset = self:ResolveHeadMesh()
      self._CachedHeadMesh = headMeshAsset
    end
    local headBounds = self:GetMeshCollisionBounds(self.HeadMeshComponent, headMeshAsset)
    if headBounds then
      headHalfX, headHalfY, headHalfZ = headBounds.hx, headBounds.hy, headBounds.hz
      headOriginX, headOriginY, headOriginZ = headBounds.ox, headBounds.oy, headBounds.oz
      self._CachedHeadHX, self._CachedHeadHY, self._CachedHeadHZ = headHalfX, headHalfY, headHalfZ
      self._CachedHeadOX, self._CachedHeadOY, self._CachedHeadOZ = headOriginX, headOriginY, headOriginZ
    else
      headHalfX, headHalfY, headHalfZ = bodyHalfX, bodyHalfY, bodyHalfZ
    end
  end
  if 0 == self._TriggerBoxesLogCount then
    DbgPrint(self, "BP_SplineTrain_Dynamic: BoxSizeComputed", "bodyHalf=(", bodyHalfX, bodyHalfY, bodyHalfZ, ")", "headHalf=(", headHalfX, headHalfY, headHalfZ, ")")
  end
  local headDeathCenter, headDeathRot, headForward
  local bHasSpline = self:UseSplineTrack()
  local moveDir = self.MoveDirection or 1
  if moveDir >= 0 then
    moveDir = 1
  else
    moveDir = -1
  end
  
  local function ResolveTrackForwardAndRotation(carriageIndex, halfX)
    local dist = self:GetCarriageSplineDistance(carriageIndex)
    local frontPos = self:GetSplineWorldLocation(dist + halfX)
    local backPos = self:GetSplineWorldLocation(dist - halfX)
    local rawChord = frontPos - backPos
    local chordDir
    if bHasSpline and UE4.UKismetMathLibrary.VSize(rawChord) < 0.5 then
      local tangent = self.Spline:GetTangentAtDistanceAlongSpline(math.max(dist, 0), ESplineCoordinateSpace.World)
      chordDir = UE4.UKismetMathLibrary.Normal(tangent, 0.001)
    else
      chordDir = UE4.UKismetMathLibrary.Normal(rawChord, 0.001)
    end
    local forward = UE4.UKismetMathLibrary.Multiply_VectorFloat(chordDir, moveDir)
    local boxRot
    if bHasSpline then
      local up = dist >= 0 and self.Spline:GetUpVectorAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World) or nil
      boxRot = self:RebaseRotationToForward(MakeRotationFromChordAndSpline(forward, up))
    else
      boxRot = self:GetTrainForwardRotation()
      if moveDir < 0 then
        boxRot = UE4.UKismetMathLibrary.ComposeRotators(FRotator(0, 180, 0), boxRot)
      end
    end
    return forward, boxRot, dist
  end
  
  if self.AllTrainMeshes then
    local enableDeath = self.EnableDeathBox ~= false
    for i = 1, self.ActiveMeshCount do
      self:SetCarriageMeshCollision(i, enableDeath and self:IsCarriagePortalRevealed(i))
    end
  end
  if (not headDeathCenter or not headDeathRot) and self.AllTrainMeshes then
    local headMesh = self.AllTrainMeshes[1]
    if headMesh and IsValid(headMesh) then
      local meshHX = headHalfX or DEFAULT_HEAD_HALF_X
      local meshHY = headHalfY or DEFAULT_BODY_HALF_YZ
      local meshHZ = headHalfZ or DEFAULT_BODY_HALF_YZ
      headForward, headDeathRot = ResolveTrackForwardAndRotation(1, meshHX)
      local hx, hy, hz, center = self:ProjectMeshBoundsToRotation(headMesh, headDeathRot, headOriginX or 0, headOriginY or 0, headOriginZ or 0, meshHX, meshHY, meshHZ)
      if center then
        headDeathCenter = center
        headHalfX, headHalfY, headHalfZ = hx, hy, hz
      else
        headDeathCenter = self:GetMeshWorldBoundsCenter(headMesh, headMeshAsset) or headMesh:K2_GetComponentLocation()
      end
    end
  end
  if self._SlowBox and IsValid(self._SlowBox) then
    if false ~= self.EnableSlowBox and headDeathCenter and headDeathRot and headForward and self:IsCarriagePortalRevealed(1) then
      local forwardDistRaw = self.SlowBoxForwardDistance
      if nil == forwardDistRaw then
        forwardDistRaw = DEFAULT_SLOW_FORWARD
      end
      local forwardAbs = math.abs(forwardDistRaw)
      if forwardAbs < 1 then
        forwardAbs = DEFAULT_SLOW_FORWARD
      end
      local halfForward = forwardAbs * 0.5
      local worldOff = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(FVector(halfForward, 0, 0), headDeathRot)
      local boxCenter = FVector(headDeathCenter.X + worldOff.X, headDeathCenter.Y + worldOff.Y, headDeathCenter.Z + worldOff.Z)
      local scale = self.SlowBoxScale
      local sx = scale and scale.X and scale.X > 0 and scale.X or 1
      local sy = scale and scale.Y and scale.Y > 0 and scale.Y or 1
      local sz = scale and scale.Z and scale.Z > 0 and scale.Z or 1
      local ex = (headHalfX + halfForward) * sx
      local ey = headHalfY * sy
      local ez = headHalfZ * sz
      if ex < 1 then
        ex = 1
      end
      if ey < 1 then
        ey = 1
      end
      if ez < 1 then
        ez = 1
      end
      local boxExtent = FVector(ex, ey, ez)
      self._SlowBox:K2_SetWorldLocationAndRotation(boxCenter, headDeathRot, false, nil, false)
      local last = self._SlowBoxLastExtent
      local extentChanged = not last or math.abs(last.X - ex) > 0.5 or math.abs(last.Y - ey) > 0.5 or math.abs(last.Z - ez) > 0.5
      if extentChanged then
        self._SlowBox:SetBoxExtent(boxExtent, true)
        self._SlowBoxLastExtent = {
          X = ex,
          Y = ey,
          Z = ez
        }
      end
      if not self._SlowBoxCollisionOn then
        if self._SlowBox.SetGenerateOverlapEvents then
          self._SlowBox:SetGenerateOverlapEvents(true)
        end
        self._SlowBox:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
        self._SlowBoxCollisionOn = true
      end
      self:_HideSlowBoxVisual(self._SlowBox)
      if self._TriggerBoxesLogCount < 3 then
        DbgPrint(self, "BP_SplineTrain_Dynamic: SlowBox enabled", "center=", boxCenter, "extent=", boxExtent, "extentChanged=", extentChanged)
      end
    else
      if self._SlowBoxCollisionOn then
        self._SlowBox:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        self._SlowBoxCollisionOn = false
      end
      if self._TriggerBoxesLogCount < 3 then
        DbgPrint(self, "BP_SplineTrain_Dynamic: SlowBox DISABLED", "EnableSlowBox=", self.EnableSlowBox, "hasCenter=", nil ~= headDeathCenter)
      end
    end
  elseif self._TriggerBoxesLogCount < 3 then
    DbgPrint(self, "BP_SplineTrain_Dynamic: SlowBox missing")
  end
  if self._TriggerBoxesLogCount < 3 then
    self._TriggerBoxesLogCount = self._TriggerBoxesLogCount + 1
  end
end

function M:OnTrainMeshOverlap(Comp, OtherActor, OtherComp)
  if not (OtherActor and IsValid(OtherActor)) or OtherActor == self then
    return
  end
  if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
    return
  end
  if OtherActor:IsDead() then
    return
  end
  if OtherActor.IsSwitchingSlideMech then
    DebugPrint("[TrackDodgeFix#2] DeathBox SKIP - IsSwitchingSlideMech", "train=", self:GetName(), "player=", OtherActor:GetName(), "UnitId=", self.UnitId)
    return
  end
  local now = UE4.UGameplayStatics.GetTimeSeconds(self)
  if self._DeathBoxCD and now < self._DeathBoxCD then
    return
  end
  self._DeathBoxCD = now + DEATH_BOX_CD
  DebugPrint("[TrackDodgeFix#2] DeathBox HIT - apply falling", "train=", self:GetName(), "player=", OtherActor:GetName(), "UnitId=", self.UnitId)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode and GameMode.TriggerFallingCallable then
    local DefaultEnable = self.DefaultEnable or false
    local DefaultTransform = Comp and Comp.K2_GetComponentToWorld and Comp:K2_GetComponentToWorld()
    if DefaultEnable and self.GetNearestDefaultTransform then
      local NearestComp = self:GetNearestDefaultTransform(OtherActor:K2_GetActorLocation())
      if NearestComp then
        DefaultTransform = NearestComp:K2_GetComponentToWorld()
      end
    end
    if not DefaultTransform then
      if self.DefaultTransform and IsValid(self.DefaultTransform) then
        DefaultTransform = self.DefaultTransform:K2_GetComponentToWorld()
      else
        DefaultTransform = self:GetTransform()
      end
    end
    GameMode:TriggerFallingCallable(OtherActor, DefaultTransform, FALLING_IMPULSE, DefaultEnable)
  end
end

function M:_RestoreSlowTimeDilation()
  if self._SlowTimeActive then
    self._SlowTimeActive = false
    EventManager:RemoveEvent(EventID.OnSlideMechSwitchSuccess, self)
    if self._SlowTimePlayer and IsValid(self._SlowTimePlayer) then
      Battle(self):RemoveBuffFromTarget(self, self._SlowTimePlayer, SLOW_TIME_BUFF_ID, false, -1)
    end
    self._SlowTimePlayer = nil
    local now = UE4.UGameplayStatics.GetTimeSeconds(self)
    self._SlowBoxCD = now + SLOW_EXTRA_CD
    DebugPrint("[TrackDodgeFix#1] SlowTime RESTORED + CD set", "train=", self:GetName(), "UnitId=", self.UnitId, "CurrentDistance=", self.CurrentDistance, "cdSec=", SLOW_EXTRA_CD, "SlowBoxCD=", self._SlowBoxCD, "promptWas=", self._DodgePromptActive == true)
  end
  if self.RemoveTimer then
    self:RemoveTimer("SlowBoxRestore")
    self:RemoveTimer("SlowBoxEndDebounce")
    self:RemoveTimer("SlowBoxRestoreAfterSwitch")
  end
end

function M:_OnSlideMechSwitchSuccess(Player, SlideMechEid, TrackIndex)
  if not self._SlowTimeActive then
    return
  end
  if Player ~= self._SlowTimePlayer then
    return
  end
  DebugPrint("BP_SplineTrain_Dynamic: switch success event, removing Buff 68", "Player=", Player and Player:GetName() or "nil", "TrackIndex=", TrackIndex)
  self:_RestoreSlowTimeDilation()
  self:HideDodgeTipUI(true)
end

function M:OnSlowBoxOverlap(Comp, OtherActor, OtherComp)
  if not (OtherActor and IsValid(OtherActor)) or OtherActor == self then
    return
  end
  if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
    return
  end
  if OtherActor:IsDead() then
    return
  end
  if OtherActor.IsSwitchingSlideMech then
    DebugPrint("[TrackDodgeFix#3] SlowBox SKIP - IsSwitchingSlideMech (no slow/no prompt)", "train=", self:GetName(), "player=", OtherActor:GetName(), "UnitId=", self.UnitId)
    return
  end
  if self.RemoveTimer then
    self:RemoveTimer("SlowBoxEndDebounce")
  end
  if self._SlowTimeActive then
    if not self._DodgePromptActive then
      DebugPrint("[TrackDodgeFix#1] SlowBox REENTER - reshow prompt (slow still active)", "train=", self:GetName(), "player=", OtherActor:GetName(), "UnitId=", self.UnitId)
      self._DodgePlayer = OtherActor
      self:ShowDodgePrompt(OtherActor)
    else
      DebugPrint("[TrackDodgeFix#1] SlowBox REENTER - keep buff+prompt", "train=", self:GetName(), "UnitId=", self.UnitId)
    end
    return
  end
  local now = UE4.UGameplayStatics.GetTimeSeconds(self)
  if self._SlowBoxCD and now < self._SlowBoxCD then
    DebugPrint("[TrackDodgeFix#1] SlowBox SKIP - CD", "remain=", self._SlowBoxCD - now, "train=", self:GetName(), "UnitId=", self.UnitId)
    return
  end
  local duration = self.SlowEffectDuration or SLOW_EFFECT_DURATION
  DebugPrint("[TrackDodgeFix#1] SlowBox TRIGGER - apply buff + show prompt", "train=", self:GetName(), "player=", OtherActor:GetName(), "duration=", duration, "UnitId=", self.UnitId)
  Battle(self):AddBuffToTarget(self, OtherActor, SLOW_TIME_BUFF_ID, -1, nil, nil, 1)
  self._SlowTimePlayer = OtherActor
  self._SlowTimeActive = true
  EventManager:AddEvent(EventID.OnSlideMechSwitchSuccess, self, self._OnSlideMechSwitchSuccess)
  if self._DodgePromptActive then
    self:HideDodgePrompt(self._DodgePlayer)
  end
  self._DodgePlayer = OtherActor
  if self.AddTimer then
    self:AddTimer(duration, function()
      self:_RestoreSlowTimeDilation()
      self:HideDodgePrompt(OtherActor)
    end, false, 0, "SlowBoxRestore")
  end
  self:ShowDodgePrompt(OtherActor)
end

function M:OnSlowBoxEndOverlap(Comp, OtherActor, OtherComp)
  if not (OtherActor and IsValid(OtherActor)) or OtherActor == self then
    return
  end
  if not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
    return
  end
  if not self._SlowTimeActive then
    self:HideDodgePrompt(OtherActor)
    return
  end
  if self.IsRestoreTimeNow == false and self.IsExistTimer and self:IsExistTimer("SlowBoxRestoreAfterSwitch") then
    return
  end
  DebugPrint("[TrackDodgeFix#1] SlowBox EndOverlap - schedule debounce", "debounce=", SLOW_END_DEBOUNCE, "prompt=", self._DodgePromptActive == true, "train=", self:GetName(), "UnitId=", self.UnitId)
  
  local function DoEndRestore()
    if self._SlowBox and IsValid(self._SlowBox) and self._SlowBox.IsOverlappingActor and self._SlowBox:IsOverlappingActor(OtherActor) then
      DebugPrint("[TrackDodgeFix#1] SlowBox EndDebounce SKIP - still overlapping (fake leave)", "promptKept=", self._DodgePromptActive == true, "train=", self:GetName(), "UnitId=", self.UnitId)
      return
    end
    DebugPrint("[TrackDodgeFix#1] SlowBox EndDebounce APPLY - restore+hide", "train=", self:GetName(), "UnitId=", self.UnitId)
    self:_RestoreSlowTimeDilation()
    self:HideDodgePrompt(OtherActor)
  end
  
  if self.AddTimer then
    self:AddTimer(SLOW_END_DEBOUNCE, DoEndRestore, false, 0, "SlowBoxEndDebounce")
  else
    DoEndRestore()
  end
end

function M:OnDodgeSwitchTriggered()
  if self.IsRestoreTimeNow == false then
    local delay = 1.0
    local mv = DataMgr and DataMgr.MovementParams and DataMgr.MovementParams.SideJumpAttachTime
    if mv and mv.ParamValue and mv.ParamValue > 0 then
      delay = mv.ParamValue
    end
    if self.AddTimer then
      self:AddTimer(delay, function()
        self:_RestoreSlowTimeDilation()
      end, false, 0, "SlowBoxRestoreAfterSwitch")
    end
    DbgPrint(self, "BP_SplineTrain_Dynamic: OnDodgeSwitchTriggered - keep slow, restore in", delay, "s")
  else
    self:_RestoreSlowTimeDilation()
  end
  self:HideDodgeTipUI(true)
end

function M:_GetSlowBoxTrackIndex(Player)
  return self:_ResolveOwnTrackIndex(Player) or self:_GetPlayerTrackIndex(Player)
end

function M:_ComputeSlowBoxSwitchDirections(Player)
  local anchorLoc, rightAxis, fwdAxis, excludeSpline = self:_GetSideScanBasis(Player)
  local canLeft, canRight = self:_ScanSideTracks(anchorLoc, rightAxis, fwdAxis, excludeSpline)
  if canLeft and M.CheckObstacleForSwitch(Player, -1, self, self, true) then
    canLeft = false
  end
  if canRight and M.CheckObstacleForSwitch(Player, 1, self, self, true) then
    canRight = false
  end
  DbgPrint(self, "BP_SplineTrain_Dynamic: _ComputeSlowBoxSwitchDirections", "canLeft=", canLeft, "canRight=", canRight, "playerTrack=", self:_GetPlayerTrackIndex(Player))
  return canLeft, canRight
end

function M:_GetCameraPreferredDirection(Player)
  if not Player or not IsValid(Player) then
    return false
  end
  local camForward = UE4.UKismetMathLibrary.GetForwardVector(Player:GetControlRotation())
  local trackRight = Player:GetActorRightVector()
  local dot = camForward:Dot(trackRight)
  return dot > 0
end

function M:ShowDodgePrompt(Player)
  if self._DodgePromptActive then
    DebugPrint("BP_SplineTrain_Dynamic: ShowDodgePrompt skip - already active")
    return
  end
  local canLeft, canRight = self:_ComputeSlowBoxSwitchDirections(Player)
  self._DodgeAvailableLeft = canLeft
  self._DodgeAvailableRight = canRight
  if canLeft and canRight then
    if self:_GetCameraPreferredDirection(Player) then
      canLeft = false
    else
      canRight = false
    end
  end
  if not canLeft and not canRight then
    DebugPrint("[TrackDodgeFix#1] ShowDodgePrompt FAIL - no direction", "TotalTracks=", self.TotalTracks, "TrackIndex=", self.TrackIndex, "availL/R=", self._DodgeAvailableLeft, self._DodgeAvailableRight, "Player=", Player and Player.GetName and Player:GetName() or Player, "UnitId=", self.UnitId)
    return
  end
  self._DodgePromptActive = true
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if not BattleMain then
    DebugPrint("[TrackDodgeFix#1] ShowDodgePrompt WARNING - BattleMain nil", "Left=", canLeft, "Right=", canRight, "UnitId=", self.UnitId)
  elseif not BattleMain.SetTrackDodgePromptVisible then
    DebugPrint("[TrackDodgeFix#1] ShowDodgePrompt WARNING - missing SetTrackDodgePromptVisible")
  else
    DebugPrint("[TrackDodgeFix#1] ShowDodgePrompt SHOW UI", "Left=", canLeft, "Right=", canRight, "cacheL/R=", self._DodgeAvailableLeft, self._DodgeAvailableRight, "TotalTracks=", self.TotalTracks, "for=", Player and Player.GetName and Player:GetName() or Player, "UnitId=", self.UnitId)
    BattleMain:SetTrackDodgePromptVisible(true, canLeft, canRight)
  end
  DbgPrint(self, "BP_SplineTrain_Dynamic: ShowDodgePrompt done", "Left=", canLeft, "Right=", canRight)
end

function M:HideDodgeTipUI(bIsPlayAudio)
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if not BattleMain or not BattleMain.SetTrackDodgePromptVisible then
    DebugPrint("[TrackDodgeFix#1] HideDodgeTipUI WARNING - BattleMain nil or missing API")
    return
  end
  if bIsPlayAudio then
    BattleMain:SetTrackDodgePromptVisible(false, false, false, true)
  else
    BattleMain:SetTrackDodgePromptVisible(false)
  end
end

function M:HideDodgePrompt(Player)
  if not self._DodgePromptActive then
    return
  end
  self._DodgePromptActive = false
  DebugPrint("[TrackDodgeFix#1] HideDodgePrompt", "train=", self:GetName(), "UnitId=", self.UnitId, "player=", Player and Player.GetName and Player:GetName() or "nil", "slowActive=", self._SlowTimeActive == true)
  self:HideDodgeTipUI(false)
  if Player and IsValid(Player) then
    local ctrl = Player:GetController()
    if ctrl and ctrl.ResetIgnoreMoveInput then
      ctrl:ResetIgnoreMoveInput()
    end
  end
  self._DodgeAvailableLeft = nil
  self._DodgeAvailableRight = nil
  self._DodgePlayer = nil
  DbgPrint(self, "BP_SplineTrain_Dynamic: HideDodgePrompt")
end

function M.ClearAllDodgePrompts(Player)
  for train, _ in pairs(AllTrains) do
    if train and IsValid(train) and train._DodgePromptActive and train.HideDodgePrompt then
      train:HideDodgePrompt(Player)
    end
  end
end

function M.GetActiveDodgeSwitchPlan(Player)
  if not Player or not IsValid(Player) then
    return nil
  end
  for train, _ in pairs(AllTrains) do
    if train and IsValid(train) and train._DodgePromptActive and train._DodgePlayer == Player then
      return {
        train = train,
        canLeft = train._DodgeAvailableLeft == true,
        canRight = true == train._DodgeAvailableRight
      }
    end
  end
  return nil
end

function M:_GetAvailableDirections(Player)
  local anchorLoc, rightAxis, fwdAxis, excludeSpline = self:_GetSideScanBasis(Player)
  return self:_ScanSideTracks(anchorLoc, rightAxis, fwdAxis, excludeSpline)
end

function M:_GetPlayerTrackIndex(Player)
  if not Player.IsInSlideMech then
    return nil
  end
  local eid = Player.CurSlideMechEid
  if not eid or 0 == eid then
    return nil
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState or not GameState.SlideMechanismMap then
    return nil
  end
  local mech = GameState.SlideMechanismMap:Find(eid)
  if mech and IsValid(mech) and mech.TrackIndex then
    return mech.TrackIndex
  end
  return nil
end

function M:_GetSplineStartTangent(spline)
  if not spline or not IsValid(spline) then
    return nil
  end
  local d = spline:GetDirectionAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
  if not d then
    return nil
  end
  return UE4.UKismetMathLibrary.Normal(d, 0.001)
end

function M:_ClosestOnSpline(spline, worldLoc)
  if spline.FindLocationClosestToWorldLocation then
    return spline:FindLocationClosestToWorldLocation(worldLoc, ESplineCoordinateSpace.World)
  end
  return spline:GetLocationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
end

function M:_ClosestPointAndTangent(spline, worldLoc)
  if not spline or not IsValid(spline) then
    return nil, nil
  end
  local closest, dist
  if spline.FindInputKeyClosestToWorldLocation and spline.GetDistanceAlongSplineAtSplineInputKey then
    local key = spline:FindInputKeyClosestToWorldLocation(worldLoc)
    dist = spline:GetDistanceAlongSplineAtSplineInputKey(key)
    closest = spline:GetLocationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World)
  else
    closest = self:_ClosestOnSpline(spline, worldLoc)
    dist = 0
  end
  local tangent
  if spline.GetDirectionAtDistanceAlongSpline then
    local d = spline:GetDirectionAtDistanceAlongSpline(math.max(dist or 0, 0), ESplineCoordinateSpace.World)
    if d then
      tangent = UE4.UKismetMathLibrary.Normal(d, 0.001)
    end
  end
  return closest, tangent
end

function M:_ScanSideTracks(anchorLoc, rightAxis, fwdAxis, excludeSpline)
  local hasLeft, hasRight = false, false
  if not anchorLoc or not rightAxis then
    return hasLeft, hasRight
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState or not GameState.SlideMechanismMap then
    return hasLeft, hasRight
  end
  for _, mech in pairs(GameState.SlideMechanismMap:ToTable()) do
    if mech and IsValid(mech) and mech.Spline and IsValid(mech.Spline) and mech.Spline ~= excludeSpline then
      local closest = self:_ClosestOnSpline(mech.Spline, anchorLoc)
      if closest then
        local dx = closest.X - anchorLoc.X
        local dy = closest.Y - anchorLoc.Y
        local dz = closest.Z - anchorLoc.Z
        local lat = dx * rightAxis.X + dy * rightAxis.Y + dz * rightAxis.Z
        local fwd = fwdAxis and dx * fwdAxis.X + dy * fwdAxis.Y + dz * fwdAxis.Z or 0
        local absLat = math.abs(lat)
        if math.abs(fwd) <= SIDE_SCAN_FWD_ALIGN_MAX and absLat >= SIDE_SCAN_LAT_MIN and absLat <= SIDE_SCAN_LAT_MAX then
          if lat < 0 then
            hasLeft = true
          else
            hasRight = true
          end
          DbgPrint(self, "BP_SplineTrain_Dynamic: _ScanSideTracks hit", "mech=", mech.GetName and mech:GetName() or "?", "lat=", math.floor(lat), "fwd=", math.floor(fwd))
        end
      end
    end
  end
  DbgPrint(self, "BP_SplineTrain_Dynamic: _ScanSideTracks", "hasLeft=", hasLeft, "hasRight=", hasRight)
  return hasLeft, hasRight
end

function M:_GetSideScanBasis(Player)
  if Player and IsValid(Player) then
    local rot = Player:K2_GetActorRotation()
    local anchorLoc = Player:K2_GetActorLocation()
    local rightAxis = UE4.UKismetMathLibrary.GetRightVector(rot)
    local fwdAxis = UE4.UKismetMathLibrary.GetForwardVector(rot)
    local excludeSpline
    local eid = Player.CurSlideMechEid
    if Player.IsInSlideMech and eid and 0 ~= eid then
      local GameState = UE4.UGameplayStatics.GetGameState(self)
      if GameState and GameState.SlideMechanismMap then
        local mech = GameState.SlideMechanismMap:Find(eid)
        if mech and IsValid(mech) then
          excludeSpline = mech.Spline
        end
      end
    end
    return anchorLoc, rightAxis, fwdAxis, excludeSpline
  end
  local anchorLoc, anchorRot = self:GetStartAnchorWorld()
  if not anchorLoc or not anchorRot then
    return nil, nil, nil, nil
  end
  local rightAxis = UE4.UKismetMathLibrary.NegateVector(UE4.UKismetMathLibrary.GetRightVector(anchorRot))
  local fwdAxis = UE4.UKismetMathLibrary.GetForwardVector(anchorRot)
  return anchorLoc, rightAxis, fwdAxis, self.Spline and IsValid(self.Spline) and self.Spline or nil
end

function M:_TryBindOwnTrackMech(scheduleRetry)
  if self._BoundTrackIndex then
    return true
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState or not GameState.SlideMechanismMap then
    if scheduleRetry then
      self:_ScheduleTrackBindRetry()
    end
    return false
  end
  local anchorLoc = self:GetStartAnchorWorld()
  if not anchorLoc then
    return false
  end
  local _, trainDir = self:_ClosestPointAndTangent(self.Spline, anchorLoc)
  trainDir = trainDir or self:_GetSplineStartTangent(self.Spline)
  if not trainDir then
    return false
  end
  local longMin = -TRACK_BIND_LONG_MARGIN
  local longMax = self.SplineLength
  if not longMax or longMax <= 0 then
    longMax = TRACK_BIND_LONG_MAX
  else
    longMax = longMax + TRACK_BIND_LONG_MARGIN
  end
  local bestEid, bestMech, bestLat
  for eid, mech in pairs(GameState.SlideMechanismMap:ToTable()) do
    if mech and IsValid(mech) and mech.Spline and IsValid(mech.Spline) then
      local closeLoc, mechDir = self:_ClosestPointAndTangent(mech.Spline, anchorLoc)
      if closeLoc and mechDir and math.abs(trainDir:Dot(mechDir)) >= TRACK_BIND_PARALLEL_DOT then
        local dx = closeLoc.X - anchorLoc.X
        local dy = closeLoc.Y - anchorLoc.Y
        local dz = closeLoc.Z - anchorLoc.Z
        local longOfs = dx * trainDir.X + dy * trainDir.Y + dz * trainDir.Z
        local latX = dx - trainDir.X * longOfs
        local latY = dy - trainDir.Y * longOfs
        local latZ = dz - trainDir.Z * longOfs
        local latDist = UE4.UKismetMathLibrary.VSize(FVector(latX, latY, latZ))
        if latDist <= TRACK_BIND_LAT_MAX and longMin <= longOfs and longMax >= longOfs then
          if not bestLat or bestLat > latDist then
            bestEid, bestMech, bestLat = eid, mech, latDist
          end
        else
          DbgPrint(self, "BP_SplineTrain_Dynamic: 轨道绑定候选被拒", "mech=", mech:GetName(), "latDist=", math.floor(latDist), "longOfs=", math.floor(longOfs))
        end
      end
    end
  end
  if not bestMech then
    if not self._BindFailLogged then
      self._BindFailLogged = true
      DebugPrint("BP_SplineTrain_Dynamic: 轨道机关绑定失败（无满足平行/横向/纵向条件的机关）", "UnitId=", self.UnitId, "-> 走空间推断兜底")
    end
    if scheduleRetry then
      self:_ScheduleTrackBindRetry()
    end
    return false
  end
  local idx, cnt = self:_DeriveBoundTrackIndex(bestMech)
  if not idx then
    DebugPrint("BP_SplineTrain_Dynamic: 轨道编号推导失败，走空间推断兜底", "mech=", bestMech:GetName(), "UnitId=", self.UnitId)
    return false
  end
  self._BoundSlideMechEid = bestEid
  self._BoundTrackIndex = idx
  self.TrackIndex = idx
  self.TotalTracks = cnt
  self:_StopTrackBindRetry()
  DebugPrint("BP_SplineTrain_Dynamic: 轨道机关绑定成功", "mechEid=", bestEid, "mech=", bestMech:GetName(), "latDist=", math.floor(bestLat), "trackIndex=", idx, "trackCount=", cnt, "TotalTracks=", self.TotalTracks, "UnitId=", self.UnitId)
  return true
end

function M:_DeriveBoundTrackIndex(mech)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState or not GameState.SlideMechanismMap then
    return nil, nil
  end
  local anchorLoc = self:GetStartAnchorWorld()
  if not anchorLoc then
    return nil, nil
  end
  local baseDist = 0
  if mech.Spline.FindInputKeyClosestToWorldLocation and mech.Spline.GetDistanceAlongSplineAtSplineInputKey then
    local key = mech.Spline:FindInputKeyClosestToWorldLocation(anchorLoc)
    baseDist = mech.Spline:GetDistanceAlongSplineAtSplineInputKey(key)
  end
  local mechDir = mech.Spline:GetDirectionAtDistanceAlongSpline(math.max(baseDist, 0), ESplineCoordinateSpace.World)
  mechDir = mechDir and UE4.UKismetMathLibrary.Normal(mechDir, 0.001) or nil
  if not mechDir then
    return nil, nil
  end
  local right = mech.Spline:GetRightVectorAtDistanceAlongSpline(math.max(baseDist, 0), ESplineCoordinateSpace.World)
  right = right or UE4.UKismetMathLibrary.GetRightVector(mech:K2_GetActorRotation())
  if not right then
    return nil, nil
  end
  local B = mech.Spline:GetLocationAtDistanceAlongSpline(math.max(baseDist, 0), ESplineCoordinateSpace.World)
  local TOL, GAP = 100.0, 1500.0
  local slots = {}
  for _, m in pairs(GameState.SlideMechanismMap:ToTable()) do
    if m and IsValid(m) and m.Spline and IsValid(m.Spline) then
      local loc, d = self:_ClosestPointAndTangent(m.Spline, anchorLoc)
      if loc and d and math.abs(d:Dot(mechDir)) >= TRACK_BIND_PARALLEL_DOT then
        local L = (loc.X - B.X) * right.X + (loc.Y - B.Y) * right.Y + (loc.Z - B.Z) * right.Z
        local dup = false
        for _, v in ipairs(slots) do
          if TOL > math.abs(v - L) then
            dup = true
            break
          end
        end
        if not dup then
          slots[#slots + 1] = L
        end
      end
    end
  end
  table.sort(slots)
  if 0 == #slots then
    return nil, nil
  end
  local first, last, i = nil, nil, 1
  while i <= #slots do
    local j = i
    while j < #slots and GAP > slots[j + 1] - slots[j] do
      j = j + 1
    end
    if slots[i] - GAP < 0 and slots[j] + GAP > 0 then
      first, last = i, j
      break
    end
    i = j + 1
  end
  if not first then
    return nil, nil
  end
  local idx = 1
  for k = first, last do
    if slots[k] < 0 - TOL then
      idx = idx + 1
    end
  end
  DbgPrint(self, "BP_SplineTrain_Dynamic: _DeriveBoundTrackIndex", "anchor=", mech:GetName(), "slots=", table.concat(slots, ","), "trackIndex=", idx, "trackCount=", last - first + 1)
  return idx, last - first + 1
end

function M:_ScheduleTrackBindRetry()
  if not self.AddTimer then
    return
  end
  if self.IsExistTimer and self:IsExistTimer(TRACK_BIND_RETRY_KEY) then
    return
  end
  self:AddTimer(TRACK_BIND_RETRY_INTERVAL, function()
    self:_TrackBindRetryTick()
  end, true, 0, TRACK_BIND_RETRY_KEY)
end

function M:_TrackBindRetryTick()
  if self._BoundTrackIndex then
    self:_StopTrackBindRetry()
    return
  end
  self._BindRetryCount = (self._BindRetryCount or 0) + 1
  if self._BindRetryCount > TRACK_BIND_RETRY_MAX then
    self:_StopTrackBindRetry()
    DebugPrint("BP_SplineTrain_Dynamic: 轨道机关绑定重试超时，等待 SlowBox 懒绑定兜底", "UnitId=", self.UnitId)
    return
  end
  self:_TryBindOwnTrackMech(false)
end

function M:_StopTrackBindRetry()
  self._BindRetryCount = nil
  if self.RemoveTimer then
    self:RemoveTimer(TRACK_BIND_RETRY_KEY)
  end
end

function M:_ResolveOwnTrackIndex(Player)
  if self._BoundTrackIndex then
    return self._BoundTrackIndex
  end
  if self.Spline and IsValid(self.Spline) then
    self:_TryBindOwnTrackMech(false)
    if self._BoundTrackIndex then
      return self._BoundTrackIndex
    end
  end
  if self._AutoTrackIndex then
    return self._AutoTrackIndex
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState or not GameState.SlideMechanismMap then
    return nil
  end
  local anchorLoc = self:GetStartAnchorWorld()
  if not anchorLoc then
    return nil
  end
  local right, axisSrc
  if Player and IsValid(Player) then
    right = Player:GetActorRightVector()
    axisSrc = "player"
  end
  local rawLocs = {}
  for eid, mech in pairs(GameState.SlideMechanismMap:ToTable()) do
    if mech and IsValid(mech) then
      if not right then
        right = UE4.UKismetMathLibrary.GetRightVector(mech:K2_GetActorRotation())
        axisSrc = "mech:" .. (mech.GetName and mech:GetName() or "?")
      end
      local loc, fromSpline = nil, false
      local spline = mech.Spline
      if spline and IsValid(spline) then
        loc = self:_ClosestOnSpline(spline, anchorLoc)
        fromSpline = true
      else
        loc = mech:K2_GetActorLocation()
      end
      rawLocs[#rawLocs + 1] = {
        loc = loc,
        name = mech:GetName(),
        spline = fromSpline
      }
    end
  end
  if not right then
    local _, anchorRot = self:GetStartAnchorWorld()
    if not anchorRot then
      return nil
    end
    right = UE4.UKismetMathLibrary.NegateVector(UE4.UKismetMathLibrary.GetRightVector(anchorRot))
    axisSrc = "trainRightNegated"
  end
  if 0 == #rawLocs then
    return nil
  end
  
  local function Project(loc)
    return loc.X * right.X + loc.Y * right.Y + loc.Z * right.Z
  end
  
  local TOL = 100.0
  local slots = {}
  for _, item in ipairs(rawLocs) do
    local L = Project(item.loc)
    DebugPrint("BP_SplineTrain_Dynamic: 轨道推断候选", "mech=", item.name, "L=", math.floor(L), "spline=", item.spline)
    local dup = false
    for _, v in ipairs(slots) do
      if TOL > math.abs(v - L) then
        dup = true
        break
      end
    end
    if not dup then
      slots[#slots + 1] = L
    end
  end
  table.sort(slots)
  local GAP = 1500.0
  local selfL = Project(anchorLoc)
  local first, last
  local i = 1
  while i <= #slots do
    local j = i
    while j < #slots and GAP > slots[j + 1] - slots[j] do
      j = j + 1
    end
    if selfL > slots[i] - GAP and selfL < slots[j] + GAP then
      first, last = i, j
      break
    end
    i = j + 1
  end
  if not first then
    if not self._AutoTrackIndexFailLogged then
      self._AutoTrackIndexFailLogged = true
      DebugPrint("BP_SplineTrain_Dynamic: 自动推断轨道编号失败（锚点不在任何轨道簇内）", "selfL=", math.floor(selfL), "UnitId=", self.UnitId)
    end
    return nil
  end
  local idx = 1
  for k = first, last do
    if slots[k] < selfL - TOL then
      idx = idx + 1
    end
  end
  self._AutoTrackIndex = idx
  local latStr = {}
  for k = first, last do
    latStr[#latStr + 1] = tostring(math.floor(slots[k]))
  end
  DebugPrint("BP_SplineTrain_Dynamic: 轨道横向槽位(玩家视角左→右)=", table.concat(latStr, ", "), "selfL=", math.floor(selfL), "axisSrc=", axisSrc)
  DebugPrint("BP_SplineTrain_Dynamic: 自动推断轨道编号(机关横向排序)", "trackIndex=", idx, "trackCount=", last - first + 1, "TotalTracks=", self.TotalTracks, "UnitId=", self.UnitId)
  local total = self.TotalTracks or 0
  if total > 0 and idx > total and not self._AutoTrackIndexFailLogged then
    self._AutoTrackIndexFailLogged = true
    DebugPrint("BP_SplineTrain_Dynamic: WARNING - 推断轨道号(", idx, ")超过 TotalTracks(", total, ")，轨道簇可能混入其它区域机关，推断不可信；UnitId=", self.UnitId)
  end
  return idx
end

function M.FindNearestTrain(Player)
  if not Player or not IsValid(Player) then
    return nil
  end
  local playerLoc = Player:K2_GetActorLocation()
  local nearest, nearestDistSq
  local count = 0
  for train, _ in pairs(AllTrains) do
    if train and IsValid(train) then
      count = count + 1
      local loc = train:K2_GetActorLocation()
      local dx = loc.X - playerLoc.X
      local dy = loc.Y - playerLoc.Y
      local dz = loc.Z - playerLoc.Z
      local distSq = dx * dx + dy * dy + dz * dz
      if not nearestDistSq or nearestDistSq > distSq then
        nearest, nearestDistSq = train, distSq
      end
    end
  end
  DbgPrint(nearest, "[TrackDodge] FindNearestTrain", "trainCount=", count, "nearest=", nearest and nearest.GetName and nearest:GetName() or "nil")
  return nearest
end

function M.IsDirectionInBounds(trackIndex, totalTracks, direction)
  if not (trackIndex and totalTracks) or totalTracks <= 1 then
    return true
  end
  local target = trackIndex + direction
  return target >= 1 and totalTracks >= target
end

local function IsPointInsideTrainBox(point, box, inflate)
  if not (point and box) or not IsValid(box) then
    return false
  end
  inflate = inflate or 10
  local loc = box:K2_GetComponentLocation()
  local rot = box:K2_GetComponentRotation()
  local extent = box.GetScaledBoxExtent and box:GetScaledBoxExtent() or nil
  if not extent then
    return false
  end
  local tf = UE4.UKismetMathLibrary.MakeTransform(loc, rot, FVector(1, 1, 1))
  local localPt = UE4.UKismetMathLibrary.InverseTransformLocation(tf, point)
  return math.abs(localPt.X) <= extent.X + inflate and math.abs(localPt.Y) <= extent.Y + inflate and math.abs(localPt.Z) <= extent.Z + inflate
end

local function IsPointInsideOBB(point, center, rot, hx, hy, hz, inflate)
  if not (point and center) or not rot then
    return false
  end
  inflate = inflate or 10
  local tf = UE4.UKismetMathLibrary.MakeTransform(center, rot, FVector(1, 1, 1))
  local localPt = UE4.UKismetMathLibrary.InverseTransformLocation(tf, point)
  return math.abs(localPt.X) <= hx + inflate and math.abs(localPt.Y) <= hy + inflate and math.abs(localPt.Z) <= hz + inflate
end

local function FindAdjacentLandingPoint(Player, direction, startLoc, right)
  local GameState = UE4.UGameplayStatics.GetGameState(Player)
  if not GameState or not GameState.SlideMechanismMap then
    return nil, nil, nil
  end
  local excludeEid = Player.CurSlideMechEid
  local bestPoint, bestAbsLat, bestMech
  for eid, mech in pairs(GameState.SlideMechanismMap:ToTable()) do
    if mech and IsValid(mech) and mech.Spline and IsValid(mech.Spline) and (not excludeEid or 0 == excludeEid or eid ~= excludeEid) then
      local spline = mech.Spline
      local closest = spline.FindLocationClosestToWorldLocation and spline:FindLocationClosestToWorldLocation(startLoc, ESplineCoordinateSpace.World) or nil
      if closest then
        local dx = closest.X - startLoc.X
        local dy = closest.Y - startLoc.Y
        local dz = closest.Z - startLoc.Z
        local lat = dx * right.X + dy * right.Y + dz * right.Z
        local latInDir = lat * direction
        local absLat = math.abs(lat)
        local zReach = math.abs(dz) <= ADJ_LAND_Z_REACH
        if latInDir >= ADJ_LAND_LAT_MIN and absLat <= ADJ_LAND_LAT_MAX and zReach and (not bestAbsLat or bestAbsLat > absLat) then
          bestAbsLat, bestPoint, bestMech = absLat, closest, mech
        end
      end
    end
  end
  return bestPoint, bestAbsLat, bestMech
end

function M:GetCarriageWorldOBB(carriageIndex)
  local mesh = self.AllTrainMeshes and self.AllTrainMeshes[carriageIndex]
  if not mesh or not IsValid(mesh) then
    return nil
  end
  local isHead = 1 == carriageIndex
  local hx = isHead and (self._CachedHeadHX or DEFAULT_HEAD_HALF_X) or self._CachedBodyHX or DEFAULT_BODY_HALF_X
  local hy = isHead and (self._CachedHeadHY or DEFAULT_BODY_HALF_YZ) or self._CachedBodyHY or DEFAULT_BODY_HALF_YZ
  local hz = isHead and (self._CachedHeadHZ or DEFAULT_BODY_HALF_YZ) or self._CachedBodyHZ or DEFAULT_BODY_HALF_YZ
  local ox = isHead and (self._CachedHeadOX or 0) or self._CachedBodyOX or 0
  local oy = isHead and (self._CachedHeadOY or 0) or self._CachedBodyOY or 0
  local oz = isHead and (self._CachedHeadOZ or 0) or self._CachedBodyOZ or 0
  local moveDir = (self.MoveDirection or 1) >= 0 and 1 or -1
  local boxRot
  if self:UseSplineTrack() then
    local dist = self:GetCarriageSplineDistance(carriageIndex)
    local frontPos = self:GetSplineWorldLocation(dist + hx)
    local backPos = self:GetSplineWorldLocation(dist - hx)
    local rawChord = frontPos - backPos
    local chordDir
    if UE4.UKismetMathLibrary.VSize(rawChord) < 0.5 then
      local tangent = self.Spline:GetTangentAtDistanceAlongSpline(math.max(dist, 0), ESplineCoordinateSpace.World)
      chordDir = UE4.UKismetMathLibrary.Normal(tangent, 0.001)
    else
      chordDir = UE4.UKismetMathLibrary.Normal(rawChord, 0.001)
    end
    local fwd = UE4.UKismetMathLibrary.Multiply_VectorFloat(chordDir, moveDir)
    local up = dist >= 0 and self.Spline:GetUpVectorAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World) or nil
    boxRot = self:RebaseRotationToForward(MakeRotationFromChordAndSpline(fwd, up))
  else
    boxRot = self:GetTrainForwardRotation()
    if moveDir < 0 then
      boxRot = UE4.UKismetMathLibrary.ComposeRotators(FRotator(0, 180, 0), boxRot)
    end
  end
  local phx, phy, phz, center = self:ProjectMeshBoundsToRotation(mesh, boxRot, ox, oy, oz, hx, hy, hz)
  if not center then
    center = self:GetMeshWorldBoundsCenter(mesh, isHead and self._CachedHeadMesh or self._CachedBodyMesh) or mesh:K2_GetComponentLocation()
    phx, phy, phz = hx, hy, hz
  end
  return center, boxRot, phx, phy, phz
end

function M:GetActiveCarriageOBBs()
  local result = {}
  if not self.AllTrainMeshes then
    return result
  end
  local NoCol = ECollisionEnabled.NoCollision
  for i = 1, self.ActiveMeshCount or #self.AllTrainMeshes do
    local mesh = self.AllTrainMeshes[i]
    if mesh and IsValid(mesh) and (not mesh.GetCollisionEnabled or mesh:GetCollisionEnabled() ~= NoCol) then
      local center, rot, hx, hy, hz = self:GetCarriageWorldOBB(i)
      if center then
        table.insert(result, {
          mesh = mesh,
          center = center,
          rot = rot,
          hx = hx,
          hy = hy,
          hz = hz
        })
      end
    end
  end
  return result
end

function M.CheckObstacleForSwitch(Player, direction, refTrain, excludeTrain, includeSlowBox, curSpline)
  if not Player or not IsValid(Player) then
    return false
  end
  if nil == includeSlowBox then
    includeSlowBox = true
  end
  
  local function IsTrainObstacleActive(train)
    return train and IsValid(train) and train ~= excludeTrain and not train._TrainDestroying and not train._TrainHidden and train._CarriagesBuilt and (train.ActiveMeshCount or 0) > 0
  end
  
  local startLoc = Player:K2_GetActorLocation()
  local playerRot = Player:K2_GetActorRotation()
  local right = UE4.UKismetMathLibrary.GetRightVector(playerRot)
  local landingPoint, absLat, adjMech = FindAdjacentLandingPoint(Player, direction, startLoc, right)
  if not landingPoint then
    DbgPrint(refTrain, "[TrackDodge] CheckObstacleForSwitch no adjacent track", "direction=", direction)
    return false
  end
  local landBody = FVector(landingPoint.X, landingPoint.Y, landingPoint.Z + ADJ_LAND_BODY_UP)
  DbgPrint(refTrain, "[TrackDodge] CheckObstacleForSwitch landing", "direction=", direction, "absLat=", absLat, "mech=", adjMech and adjMech.GetName and adjMech:GetName() or "nil", "exclude=", excludeTrain and excludeTrain.GetName and excludeTrain:GetName() or "nil")
  if SWITCH_OBSTACLE_DEBUG_DRAW then
    UE4.UKismetSystemLibrary.DrawDebugSphere(Player, landBody, 80, 12, FLinearColor(0, 1, 0, 1), 2.0, 2)
    DebugPrint("[TrackDodge] CheckObstacleForSwitch landing dir=", direction, "absLat=", absLat, "mech=", adjMech and adjMech.GetName and adjMech:GetName() or "nil", "landingZ=", landingPoint.Z, "startZ=", startLoc.Z)
  end
  local NoCollision = UE4.ECollisionEnabled and UE4.ECollisionEnabled.NoCollision or ECollisionEnabled.NoCollision
  for train, _ in pairs(AllTrains) do
    if IsTrainObstacleActive(train) and (train.EnableDeathBox ~= false or false ~= train.EnableSlowBox) then
      local obbs = train.GetActiveCarriageOBBs and train:GetActiveCarriageOBBs() or nil
      if obbs then
        for _, obb in ipairs(obbs) do
          if IsPointInsideOBB(landBody, obb.center, obb.rot, obb.hx, obb.hy, obb.hz, ADJ_LAND_PT_INFLATE) then
            if SWITCH_OBSTACLE_DEBUG_DRAW then
              UE4.UKismetSystemLibrary.DrawDebugBox(Player, obb.center, FVector(obb.hx, obb.hy, obb.hz), FLinearColor(1, 0, 0, 1), obb.rot, 2.0, 4)
              DebugPrint("[TrackDodge] HIT landingInCarriage train=", train:GetName(), "carriage=", obb.mesh and obb.mesh:GetName() or "?")
            end
            DbgPrint(refTrain or train, "[TrackDodge] CheckObstacleForSwitch HIT landingInCarriage", "train=", train:GetName(), "carriage=", obb.mesh and obb.mesh:GetName() or "?")
            return true
          end
        end
      end
      if includeSlowBox then
        local slow = train._SlowBox
        if slow and IsValid(slow) then
          local col = slow.GetCollisionEnabled and slow:GetCollisionEnabled() or nil
          if col ~= NoCollision and not IsPointInsideTrainBox(startLoc, slow, ADJ_LAND_PT_INFLATE) and IsPointInsideTrainBox(landBody, slow, ADJ_LAND_PT_INFLATE) then
            if SWITCH_OBSTACLE_DEBUG_DRAW then
              local slowLoc = slow:K2_GetComponentLocation()
              local slowRot = slow:K2_GetComponentRotation()
              local extent = slow.GetScaledBoxExtent and slow:GetScaledBoxExtent() or FVector(200, 200, 200)
              UE4.UKismetSystemLibrary.DrawDebugBox(Player, slowLoc, extent, FLinearColor(1, 0.4, 0, 1), slowRot, 2.0, 4)
              DebugPrint("[TrackDodge] HIT landingInSlowBox train=", train:GetName(), "box=", slow:GetName())
            end
            DbgPrint(refTrain or train, "[TrackDodge] CheckObstacleForSwitch HIT landingInSlowBox", "train=", train:GetName(), "box=", slow:GetName())
            return true
          end
        end
      end
    end
  end
  return false
end

function M:ResetTrain()
  self:InitStartDistance()
  self:UpdateTrainPosition()
end

function M:ResetToState0Runtime()
  self:StopMove()
  if self.RemoveTimer then
    self:RemoveTimer("TrainPrepareAutoTransition")
  end
  if self._DodgePromptActive then
    self:HideDodgePrompt(self._DodgePlayer)
  end
  self.MoveDirection = 1
  self.IsMoving = false
  if self._IsBoss then
    self:DestroyPortalVfx()
  end
  self:ResetTrain()
  if self._IsBoss then
    self:UpdateBossPortalCarriageVisibility()
  end
  self:UpdateTriggerBoxes()
  DebugPrint("BP_SplineTrain_Dynamic: ResetToState0Runtime done", "CurrentDistance=", self.CurrentDistance, "MoveDirection=", self.MoveDirection)
end

function M:GetRootSceneComponent()
  return self.DefaultSceneRoot or self:K2_GetRootComponent()
end

function M:LoadStaticMeshAsset(AssetPath)
  if not AssetPath or "" == AssetPath then
    return nil
  end
  local mesh = LoadObject(AssetPath)
  if mesh and IsValid(mesh) then
    return mesh
  end
  if UE4.UObject and UE4.UObject.Load then
    mesh = UE4.UObject.Load(AssetPath)
    if mesh and IsValid(mesh) then
      return mesh
    end
  end
  DebugPrint("BP_SplineTrain_Dynamic: failed to load mesh", AssetPath)
  return nil
end

function M:GetMeshFromLegacyComponent(CompName)
  local comp = self[CompName]
  if comp and IsValid(comp) and comp.GetStaticMesh then
    local mesh = comp:GetStaticMesh()
    if mesh and IsValid(mesh) then
      return mesh
    end
  end
  return nil
end

function M:HideComponent(Comp)
  if not Comp or not IsValid(Comp) then
    return
  end
  Comp:SetVisibility(false, true)
  Comp:SetHiddenInGame(true, true)
  Comp:SetCollisionEnabled(ECollisionEnabled.NoCollision)
end

function M:HideLegacyBlueprintComponents()
  HideNamedComponentSeries(self, "Mesh", LEGACY_MESH_SCAN_MAX)
  if self.DefaultTransform and IsValid(self.DefaultTransform) then
    self:HideComponent(self.DefaultTransform)
  end
  HideNamedComponentSeries(self, "Connect", LEGACY_MESH_SCAN_MAX)
  self:DisableLegacyTriggerBoxes()
end

function M:DisableLegacyTriggerBoxes()
  if self.TriggerBox and IsValid(self.TriggerBox) then
    self.TriggerBox:SetCollisionEnabled(ECollisionEnabled.NoCollision)
  end
  for i = 1, LEGACY_TRIGGER_SCAN_MAX do
    local box = self["TriggerBox" .. i]
    if box and IsValid(box) then
      box:SetCollisionEnabled(ECollisionEnabled.NoCollision)
    end
  end
end

function M:GetTrainAttachComponent()
  return self:GetRootSceneComponent()
end

function M:_FinalizeSpacing(spacing, firstDist, autoSpacing, autoFirstDist, hookFirstDist, logSuffix)
  if not spacing or spacing < 1 then
    spacing = autoSpacing >= 1 and autoSpacing or 1
  end
  if not firstDist or firstDist < 1 then
    firstDist = autoFirstDist >= 1 and autoFirstDist or 1
  end
  firstDist = firstDist + (self.FirstDistanceOffset or 0)
  self._SpacingConfigLogCount = (self._SpacingConfigLogCount or 0) + 1
  if self._SpacingConfigLogCount <= 3 then
    DebugPrint("BP_SplineTrain_Dynamic: GetSpacingConfig" .. logSuffix, "logCount=", self._SpacingConfigLogCount, "bUseManualSpacing=", self.bUseManualSpacing, "blueprint Distance=", self.Distance, "blueprint FirstDistance=", self.FirstDistance, "FirstDistanceOffset=", self.FirstDistanceOffset or 0, "autoSpacing=", autoSpacing, "hookFirstDist=", hookFirstDist, "final spacing=", spacing, "final firstDist=", firstDist)
  end
  self._CachedSpacing = spacing
  self._CachedFirstDist = firstDist
  return spacing, firstDist
end

function M:GetSpacingConfig()
  local bodyHX = self._CachedBodyHX or DEFAULT_BODY_HALF_X
  local bodyOX = self._CachedBodyOX or 0
  local headHX = self._CachedHeadHX or bodyHX
  local headOX = self._CachedHeadOX or 0
  local autoSpacing = bodyHX * 2
  local hookFirstDist = headHX - headOX + (bodyHX + bodyOX)
  local autoFirstDist = autoSpacing
  if self.bUseManualSpacing then
    local spacing = self.Distance
    local firstDist = self.FirstDistance
    if not spacing or spacing < 1 then
      DbgPrint(self, "BP_SplineTrain_Dynamic: WARNING Distance invalid, fallback autoSpacing")
    end
    if not firstDist or firstDist < 1 then
      DbgPrint(self, "BP_SplineTrain_Dynamic: WARNING FirstDistance invalid, fallback autoFirstDist")
    end
    if spacing and autoSpacing > 1 and spacing > autoSpacing * 3 then
      DbgPrint(self, "BP_SplineTrain_Dynamic: WARNING manual spacing too large!", spacing)
    end
    if firstDist and hookFirstDist > 1 and firstDist > hookFirstDist * 3 then
      DbgPrint(self, "BP_SplineTrain_Dynamic: WARNING manual firstDist too large!", firstDist)
    end
    return self:_FinalizeSpacing(spacing, firstDist, autoSpacing, autoFirstDist, hookFirstDist, " [manual]")
  end
  return self:_FinalizeSpacing(autoSpacing, autoFirstDist, autoSpacing, autoFirstDist, hookFirstDist, "")
end

function M:GetCarriageSplineOffset(carriageIndex)
  local spacing = self._CachedSpacing
  local firstDist = self._CachedFirstDist
  if not spacing or not firstDist then
    spacing, firstDist = self:GetSpacingConfig()
  end
  if carriageIndex > 2 then
    return -firstDist - (carriageIndex - 2) * spacing
  elseif 2 == carriageIndex then
    return -firstDist
  end
  return 0
end

function M:GetCarriageSplineDistance(carriageIndex)
  local offset = self:GetCarriageSplineOffset(carriageIndex)
  local currentDistance = self.CurrentDistance or 0
  local splineLen = self:UseSplineTrack() and (self.SplineLength or 0) or 0
  local dist = currentDistance + offset
  if splineLen > 0 then
    return math.min(splineLen, dist)
  end
  return dist
end

function M:GetConnectExtraOffset(_connectIndex)
  local connOff = self.ConnectOffset
  return {
    X = connOff and connOff.X or 0,
    Y = connOff and connOff.Y or 0,
    Z = connOff and connOff.Z or 0,
    Yaw = self.ConnectOffsetYaw or 0
  }
end

function M:_ResolveForwardArrow()
  if self._ForwardArrowResolved then
    return self._CachedForwardArrow
  end
  self._ForwardArrowResolved = true
  local arrow = self.Forward
  if type(arrow) == "userdata" and IsValid(arrow) and arrow.K2_GetComponentRotation then
    self._CachedForwardArrow = arrow
  else
    local first
    local comps = self:K2_GetComponentsByClass(UE4.UArrowComponent.StaticClass())
    if comps then
      for i = 1, comps:Length() do
        local c = comps:Get(i)
        if c and IsValid(c) then
          if "Forward" == c:GetName() then
            first = c
            break
          end
          first = first or c
        end
      end
    end
    self._CachedForwardArrow = first
  end
  if self._CachedForwardArrow then
    DbgPrint(self, "BP_SplineTrain_Dynamic: ForwardArrow resolved", "arrow=", self._CachedForwardArrow:GetName())
    local parent = self._CachedForwardArrow.GetAttachParent and self._CachedForwardArrow:GetAttachParent()
    while parent and IsValid(parent) do
      local drivenName = self.HeadMesh and parent == self.HeadMesh and "HeadMesh" or self.DeathCollisionBox and parent == self.DeathCollisionBox and "DeathCollisionBox" or self.SlowCollisionBox and parent == self.SlowCollisionBox and "SlowCollisionBox" or self.PortalEffect and parent == self.PortalEffect and "PortalEffect"
      if drivenName then
        DebugPrint("BP_SplineTrain_Dynamic: WARNING - Forward(Arrow) attached under", drivenName, "- 父级会被列车逻辑改写 Transform，请将 Forward 挂到 Actor 根组件（与 Spline 同级）")
        break
      end
      if not parent.GetAttachParent then
        break
      end
      parent = parent:GetAttachParent()
    end
    if self._CachedForwardArrow.bAbsoluteRotation then
      DebugPrint("BP_SplineTrain_Dynamic: WARNING - Forward(Arrow) 勾选了 Absolute Rotation，", "世界旋转不随父级变化——RebaseRotationToForward 的 actorRot^-1 项会失去抵消，", "表现为列车方向与 Actor 旋转「反向」耦合；请取消勾选（组件 Details > Transform）")
    end
  else
    DebugPrint("BP_SplineTrain_Dynamic: WARNING - Forward(Arrow) component not found, fallback to actor rotation")
  end
  return self._CachedForwardArrow
end

function M:GetTrainForwardRotation()
  local arrow = self:_ResolveForwardArrow()
  if arrow then
    return arrow:K2_GetComponentRotation()
  end
  return self:K2_GetActorRotation()
end

function M:RebaseRotationToForward(rot)
  if not rot then
    return rot
  end
  local arrow = self:_ResolveForwardArrow()
  if not arrow then
    return rot
  end
  local delta = UE4.UKismetMathLibrary.ComposeRotators(UE4.UKismetMathLibrary.NegateRotator(self:K2_GetActorRotation()), arrow:K2_GetComponentRotation())
  return UE4.UKismetMathLibrary.ComposeRotators(rot, delta)
end

function M:_CacheStartAnchor(worldLoc, worldRot)
  local actorRot = self:K2_GetActorRotation()
  self._CachedStartLocalLoc = UE4.UKismetMathLibrary.InverseTransformLocation(self:GetTransform(), worldLoc)
  self._CachedStartLocalRot = UE4.UKismetMathLibrary.ComposeRotators(worldRot, UE4.UKismetMathLibrary.NegateRotator(actorRot))
  self._AutoTrackIndex = nil
  self._AutoTrackIndexFailLogged = nil
  self._BoundTrackIndex = nil
  self._BoundSlideMechEid = nil
  self._BindFailLogged = nil
  self:_StopTrackBindRetry()
end

function M:GetStartAnchorWorld()
  local loc = self._CachedStartLocalLoc and UE4.UKismetMathLibrary.TransformLocation(self:GetTransform(), self._CachedStartLocalLoc) or self:K2_GetActorLocation()
  local rot = self._CachedStartLocalRot and UE4.UKismetMathLibrary.ComposeRotators(self._CachedStartLocalRot, self:K2_GetActorRotation()) or self:GetTrainForwardRotation()
  return loc, rot
end

function M:_DumpDirectionDebug(tag)
  if not self.IsDebug then
    return
  end
  
  local function BoolStr(v)
    return v and "true" or "false"
  end
  
  local arrow = self:_ResolveForwardArrow()
  local arrowParentName = "-"
  if arrow and arrow.GetAttachParent then
    local p = arrow:GetAttachParent()
    if p and IsValid(p) then
      arrowParentName = p:GetName()
    end
  end
  local parentActor = self.GetAttachParentActor and self:GetAttachParentActor() or nil
  local bHasSpline = self.Spline and IsValid(self.Spline) and (self.SplineLength or 0) > 0
  local _, anchorRot = self:GetStartAnchorWorld()
  DebugPrint("BP_SplineTrain_Dynamic: DirDump[", tag, "]", "actorRot=", self:K2_GetActorRotation(), "anchorRot=", anchorRot, "arrowRot=", arrow and arrow:K2_GetComponentRotation() or "nil", "arrowAbsRot=", arrow and BoolStr(arrow.bAbsoluteRotation) or "-", "arrowParent=", arrowParentName, "isStatic=", self._IsStatic, "isBoss=", self._IsBoss)
  local splineParentName, splineScale, splinePts, splinePt0, splinePt1 = "-", "-", "-"
  if self.Spline and IsValid(self.Spline) then
    if self.Spline.GetAttachParent then
      local sp = self.Spline:GetAttachParent()
      if sp and IsValid(sp) then
        splineParentName = sp:GetName()
      end
    end
    if self.Spline.K2_GetComponentScale then
      splineScale = self.Spline:K2_GetComponentScale()
    end
    if self.Spline.GetNumberOfSplinePoints then
      local n = self.Spline:GetNumberOfSplinePoints()
      splinePts = n
      if n and n >= 1 and self.Spline.GetLocationAtSplinePoint then
        splinePt0 = self.Spline:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.Local)
      end
      if n and n >= 2 and self.Spline.GetLocationAtSplinePoint then
        splinePt1 = self.Spline:GetLocationAtSplinePoint(1, ESplineCoordinateSpace.Local)
      end
    end
  end
  DebugPrint("BP_SplineTrain_Dynamic: DirDump2[", tag, "]", "splineStartRot=", bHasSpline and self.Spline:GetRotationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World) or "-", "splineAbsRot=", self.Spline and IsValid(self.Spline) and BoolStr(self.Spline.bAbsoluteRotation) or "-", "rootAbsRot=", self.RootComponent and IsValid(self.RootComponent) and BoolStr(self.RootComponent.bAbsoluteRotation) or "-", "carriageRot=", self._LastCarriageRot or "-", "chordRot=", self._LastChordRot or "-", "parentActor=", parentActor and parentActor:GetName() or "-", "parentRot=", parentActor and parentActor:K2_GetActorRotation() or "-")
  DebugPrint("BP_SplineTrain_Dynamic: DirDump3[", tag, "]", "splineParent=", splineParentName, "splineScale=", splineScale, "splinePts=", splinePts, "pt0Local=", splinePt0 or "-", "pt1Local=", splinePt1 or "-")
end

function M:GetSplineWorldLocation(dist)
  local bUseSpline = self:UseSplineTrack()
  if bUseSpline then
    if dist >= 0 then
      return self.Spline:GetLocationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World)
    else
      local startLoc = self.Spline:GetLocationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
      local tangent = self.Spline:GetTangentAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
      local tangentDir = UE4.UKismetMathLibrary.Normal(tangent, 0.001)
      return startLoc + tangentDir * dist
    end
  else
    local startLoc, startRotation = self:GetStartAnchorWorld()
    local startDist = self._CachedStartDistance or 0
    local forward = UE4.UKismetMathLibrary.GetForwardVector(startRotation)
    local travelDist = dist - startDist
    return startLoc + forward * travelDist
  end
end

function M:GetTrainTailOffset()
  local spacing = self._CachedSpacing
  local firstDist = self._CachedFirstDist
  if not spacing or not firstDist then
    spacing, firstDist = self:GetSpacingConfig()
  end
  local meshCount = self.ActiveMeshCount or 0
  if meshCount > 2 then
    return firstDist + (meshCount - 2) * spacing
  elseif 2 == meshCount then
    return firstDist
  end
  return 0
end

function M:GetMoveSpeed()
  local speed = self.speed
  if not speed or speed < MIN_MOVE_SPEED then
    DebugPrint("BP_SplineTrain_Dynamic: ERROR - speed not configured or too low!", "UnitId=", self.UnitId, "speed=", tostring(speed), "ActorName=", self:GetName())
    return 0, false
  end
  return speed, true
end

function M:_WarnIfSplineTooShort(tailOffset, context)
  local splineLen = self:UseSplineTrack() and (self.SplineLength or 0) or 0
  if splineLen > 0 and tailOffset and tailOffset > splineLen then
    DebugPrint("BP_SplineTrain_Dynamic: WARNING Spline too short!", "context=", context or "", "SplineLength=", splineLen, "NeedTailOffset=", tailOffset)
  end
end

function M:SetMeshOnSpline(mesh, dist, mode, extraOffset, overrideRotation, positionOverride)
  local offsetX, offsetY, offsetZ = 0, 0, 0
  local offsetYaw = 0
  if mode == CARRIAGE_MODE_BODY then
    local bodyOff = self.BodyOffset
    if bodyOff then
      offsetX, offsetY, offsetZ = bodyOff.X or 0, bodyOff.Y or 0, bodyOff.Z or 0
    end
    offsetYaw = self.BodyOffsetYaw or 0
  elseif mode == CARRIAGE_MODE_HEAD then
    local headOff = self.HeadOffset
    if headOff then
      offsetX, offsetY, offsetZ = headOff.X or 0, headOff.Y or 0, headOff.Z or 0
    end
    offsetYaw = self.HeadOffsetYaw or self.OffsetYaw or 0
  end
  if self.bAlignBottom then
    local cachedHZ = mode == CARRIAGE_MODE_HEAD and (self._CachedHeadHZ or 0) or self._CachedBodyHZ or 0
    local cachedOZ = mode == CARRIAGE_MODE_HEAD and (self._CachedHeadOZ or 0) or self._CachedBodyOZ or 0
    offsetZ = offsetZ + (cachedHZ - cachedOZ)
  end
  if extraOffset then
    offsetX = offsetX + (extraOffset.X or 0)
    offsetY = offsetY + (extraOffset.Y or 0)
    offsetZ = offsetZ + (extraOffset.Z or 0)
    offsetYaw = offsetYaw + (extraOffset.Yaw or 0)
  end
  local bUseSpline = self:UseSplineTrack()
  local location
  if positionOverride then
    location = positionOverride
  else
    location = self:GetSplineWorldLocation(dist)
  end
  local rotation
  if overrideRotation then
    rotation = overrideRotation
  elseif bUseSpline and dist >= 0 then
    rotation = self:RebaseRotationToForward(self.Spline:GetRotationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World))
  else
    local _, anchorRot = self:GetStartAnchorWorld()
    rotation = anchorRot
    if bUseSpline then
      rotation = self:RebaseRotationToForward(rotation)
    end
  end
  if 0 ~= offsetYaw then
    rotation = UE4.UKismetMathLibrary.ComposeRotators(FRotator(0, offsetYaw, 0), rotation)
  end
  if 0 ~= offsetX or 0 ~= offsetY or 0 ~= offsetZ then
    local localOffset = FVector(offsetX, offsetY, offsetZ)
    local rotatedOffset = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(localOffset, rotation)
    location = location + rotatedOffset
  end
  mesh:K2_SetWorldLocationAndRotation(location, rotation, false, nil, false)
end

function M:ClearMoveTimer()
  if self.RemoveTimer then
    self:RemoveTimer(TRAIN_MOVE_TIMER_KEY)
  end
end

function M:ClearLoopResetTimer()
  if self.LoopResetTimerHandle then
    UE4.UKismetSystemLibrary.K2_ClearTimerHandle(self, self.LoopResetTimerHandle)
    self.LoopResetTimerHandle = nil
  end
end

function M:OnLoopResetTimer()
  if not self.IsMoving then
    return
  end
  self.CurrentDistance = self._CachedStartDistance or 0
  self:UpdateTrainPosition()
end

function M:TryStartLoopResetTimer()
  self:ClearLoopResetTimer()
  if not self.IsLoop then
    return
  end
  local loopTime = self.LoopTime or self.LoopTIme
  if not loopTime or loopTime <= 0 then
    return
  end
  self.LoopResetTimerHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({
    self,
    self.OnLoopResetTimer
  }, loopTime, true)
end

function M:InitStartDistance()
  self:GetSpacingConfig()
  local tailOffset = self:GetTrainTailOffset()
  local startDist = 0
  if self._IsBoss then
    startDist = -self:ResolveHeadBehindPortalDistance()
  end
  self.CurrentDistance = startDist
  self._CachedStartDistance = startDist
  DbgPrint(self, "BP_SplineTrain_Dynamic: InitStartDistance", "SplineLength=", self.SplineLength, "TailOffset=", tailOffset, "startDist=", startDist, "IsBoss=", self._IsBoss, "IsStatic=", self._IsStatic, "HeadBehindCfg=", self.HeadBehindPortalDistance, "spacing=", self._CachedSpacing, "firstDist=", self._CachedFirstDist)
  self:_WarnIfSplineTooShort(tailOffset, "InitStartDistance")
  local headHX = self._CachedHeadHX
  if self._IsBoss and startDist < 0 and headHX and headHX > -startDist then
    DebugPrint("BP_SplineTrain_Dynamic: WARNING - HeadBehindPortalDistance(", -startDist, ") < 车头半长(", headHX, ")，车头起步即探出传送门；如需整车藏门后请调大")
  end
  if self:UseSplineTrack() then
    local worldLoc = self.Spline:GetLocationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
    local worldRot = self.Spline:GetRotationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
    self:_CacheStartAnchor(worldLoc, worldRot)
  else
    self:_CacheStartAnchor(self:K2_GetActorLocation(), self:GetTrainForwardRotation())
  end
  self:_DumpDirectionDebug("InitStartDistance")
  if self._IsBoss then
    self:ResetBossPortalReveal()
  end
end

function M:OnTrainMoveTick(DeltaSeconds)
  if not self.IsMoving then
    return
  end
  if not DeltaSeconds or DeltaSeconds <= 0 then
    DeltaSeconds = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
  end
  if not DeltaSeconds or DeltaSeconds <= 0 then
    return
  end
  local rawDelta = DeltaSeconds
  local bClamped = false
  if DeltaSeconds > MAX_MOVE_DELTA then
    bClamped = true
    DeltaSeconds = MAX_MOVE_DELTA
  end
  local moveSpeed, speedValid = self:GetMoveSpeed()
  if not speedValid then
    DebugPrint("BP_SplineTrain_Dynamic: OnTrainMoveTick STOP - speed invalid")
    self:StopMove()
    return
  end
  local distBefore = self.CurrentDistance or 0
  local moveDistance = moveSpeed * DeltaSeconds * (self.MoveDirection or 1)
  self.CurrentDistance = distBefore + moveDistance
  local dilation = UE4.UGameplayStatics.GetGlobalTimeDilation(self) or 1.0
  local prevDilation = self._LastDilation
  local spikeDelta = rawDelta > 0.05
  local spikeMove = math.abs(moveDistance) > moveSpeed * 0.05
  local spikeDil = nil ~= prevDilation and math.abs(dilation - prevDilation) > 0.05
  if self.IsDebug and (bClamped or spikeDelta or spikeMove or spikeDil) then
    DebugPrint(bClamped and "BP_SplineTrain_Dynamic: JUMP clamp" or "BP_SplineTrain_Dynamic: JUMP", "train=", self:GetName(), "rawDelta=", rawDelta, "delta=", DeltaSeconds, "moveDist=", moveDistance, "distAfter=", self.CurrentDistance, "dilation=", dilation)
  end
  self._LastMoveDelta = DeltaSeconds
  self._LastMoveDist = moveDistance
  self._LastDilation = dilation
  local bLoop = self.IsLoop or self.Loop
  local splineLen = self:UseSplineTrack() and (self.SplineLength or 0) or 0
  if splineLen <= 0 then
    if not self._DiagnosedSplineLen then
      self._DiagnosedSplineLen = true
      DebugPrint("BP_SplineTrain_Dynamic: OnTrainMoveTick splineLen<=0", "UnitId=", self.UnitId, "CurrentDistance=", self.CurrentDistance, "SplineLength=", self.SplineLength, "Spline=", self.Spline and IsValid(self.Spline) and self.Spline:GetName() or "nil/invalid", "StateId=", self.StateId, "IsMoving=", self.IsMoving)
    end
    self:UpdateTrainPosition()
    self:CheckPortalPassThrough()
    return
  end
  local bForward = (self.MoveDirection or 1) > 0
  local atEnd = splineLen <= self.CurrentDistance
  local atStart = self.CurrentDistance <= 0
  if bForward and atEnd or not bForward and atStart then
    if bLoop then
      self.MoveDirection = bForward and -1 or 1
      self.CurrentDistance = bForward and splineLen or 0
    else
      self.CurrentDistance = bForward and splineLen or 0
      self:StopMove()
      if bForward and self.OnDestination then
        self:OnDestination()
      end
      self:CheckPortalPassThrough()
      return
    end
  end
  self:UpdateTrainPosition()
  self:CheckPortalPassThrough()
end

function M:ReceiveTick(DeltaSeconds)
  if self.IsMoving and self.SetActorTickInterval then
    self:SetActorTickInterval(0)
  end
  if self.IsMoving then
    PlayRailTrainMoveSound(self)
    self._LastTickTime = UE4.UGameplayStatics.GetTimeSeconds(self)
    self:OnTrainMoveTick(DeltaSeconds)
  end
  self:UpdateSequentialRevealTick(DeltaSeconds)
end

function M:UpdateTrainPosition()
  if (self.ActiveMeshCount or 0) <= 0 then
    return
  end
  local backPositions = {}
  local frontPositions = {}
  for i = 1, self.ActiveMeshCount do
    local mesh = self.AllTrainMeshes[i]
    if mesh and IsValid(mesh) then
      local dist = self:GetCarriageSplineDistance(i)
      local mode = 1 == i and CARRIAGE_MODE_HEAD or CARRIAGE_MODE_BODY
      local hx = 1 == i and (self._CachedHeadHX or DEFAULT_HEAD_HALF_X) or self._CachedBodyHX or DEFAULT_BODY_HALF_X
      local frontPos = self:GetSplineWorldLocation(dist + hx)
      local backPos = self:GetSplineWorldLocation(dist - hx)
      frontPositions[i] = frontPos
      backPositions[i] = backPos
      local centerPos = FVector((frontPos.X + backPos.X) * 0.5, (frontPos.Y + backPos.Y) * 0.5, (frontPos.Z + backPos.Z) * 0.5)
      local chordDir = UE4.UKismetMathLibrary.Normal(frontPos - backPos, 0.001)
      local bHasSpline = self:UseSplineTrack()
      local rotation
      if bHasSpline then
        local up = dist >= 0 and self.Spline:GetUpVectorAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World) or nil
        rotation = self:RebaseRotationToForward(MakeRotationFromChordAndSpline(chordDir, up))
      else
        rotation = self:GetTrainForwardRotation()
      end
      if 1 == i and self.IsDebug then
        self._LastCarriageRot = rotation
        self._LastChordRot = MakeRotationFromChordAndSpline(chordDir, bHasSpline and dist >= 0 and self.Spline:GetUpVectorAtDistanceAlongSpline(dist, ESplineCoordinateSpace.World) or nil)
      end
      self:SetMeshOnSpline(mesh, dist, mode, nil, rotation, centerPos)
    end
  end
  if self.IsDebug then
    local now = os.clock()
    if not self._LastDirDumpClock or now - self._LastDirDumpClock > 1.0 then
      self._LastDirDumpClock = now
      self:_DumpDirectionDebug("Tick")
    end
  end
  for i = 1, self.ActiveConnectCount do
    local mesh = self.AllConnectMeshes[i]
    if mesh and IsValid(mesh) then
      local backA = backPositions[i]
      local frontB = frontPositions[i + 1]
      if backA and frontB then
        local midPos = FVector((backA.X + frontB.X) * 0.5, (backA.Y + frontB.Y) * 0.5, (backA.Z + frontB.Z) * 0.5)
        local connDir = UE4.UKismetMathLibrary.Normal(frontB - backA, 0.001)
        local distA = self:GetCarriageSplineDistance(i)
        local distB = self:GetCarriageSplineDistance(i + 1)
        local connDist = (distA + distB) * 0.5
        local bHasSpline = self:UseSplineTrack()
        local connRotation
        if bHasSpline then
          local up = connDist >= 0 and self.Spline:GetUpVectorAtDistanceAlongSpline(connDist, ESplineCoordinateSpace.World) or nil
          connRotation = self:RebaseRotationToForward(MakeRotationFromChordAndSpline(connDir, up))
        else
          connRotation = self:GetTrainForwardRotation()
        end
        local extraOffset = self:GetConnectExtraOffset(i)
        local finalLoc = midPos
        local finalRot = connRotation
        if extraOffset then
          if 0 ~= (extraOffset.Yaw or 0) then
            finalRot = UE4.UKismetMathLibrary.ComposeRotators(FRotator(0, extraOffset.Yaw, 0), finalRot)
          end
          local localOff = FVector(extraOffset.X or 0, extraOffset.Y or 0, extraOffset.Z or 0)
          if 0 ~= localOff.X or 0 ~= localOff.Y or 0 ~= localOff.Z then
            local worldOff = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(localOff, finalRot)
            finalLoc = FVector(finalLoc.X + worldOff.X, finalLoc.Y + worldOff.Y, finalLoc.Z + worldOff.Z)
          end
        end
        mesh:K2_SetWorldLocationAndRotation(finalLoc, finalRot, false, nil, false)
      end
    end
  end
  if self.IsDebug then
    self._PositionLogCount = (self._PositionLogCount or 0) + 1
    if self._PositionLogCount <= 3 then
      for i = 1, math.min(self.ActiveMeshCount, 5) do
        local mesh = self.AllTrainMeshes[i]
        if mesh and IsValid(mesh) then
          DebugPrint("BP_SplineTrain_Dynamic: Carriage[" .. i .. "]", "splineDist=", self:GetCarriageSplineDistance(i), "worldLoc=", mesh:K2_GetComponentLocation())
        end
      end
    end
  end
  if self._IsBoss then
    self:UpdateBossPortalCarriageVisibility()
  end
  self:UpdateTriggerBoxes()
end

function M:ActiveCombat()
  local stateNum = self:GetStateNumber()
  DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat", "UnitId=", self.UnitId, "StateId=", self.StateId, "stateNum=", stateNum, "IsActive=", self.IsActive, "IsBoss=", self._IsBoss, "CarriagesBuilt=", self._CarriagesBuilt)
  if 1 == stateNum then
    local sp, spValid = self:GetMoveSpeed()
    if not spValid then
      DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat stateNum=1 REJECTED - speed invalid, stay in current state")
      return
    end
    self.IsActive = true
    self._HasCompletedState0To1 = true
    self:StartMove()
    self:UpdateTriggerBoxes()
    return
  end
  if 0 == stateNum then
    if self._HasCompletedState0To1 then
      DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat stateNum=0 after completed 0→1, force reprepare", "UnitId=", self.UnitId, "IsActive=", self.IsActive, "CarriagesBuilt=", self._CarriagesBuilt)
    elseif self.IsActive and self._CarriagesBuilt and not self._TrainHidden then
      local expectAutoStart = self._IsBoss or self.bAutoStartOnSpawn ~= false
      local hasAutoTimer = self.IsExistTimer and self:IsExistTimer("TrainPrepareAutoTransition")
      if expectAutoStart and not self.IsMoving and not hasAutoTimer then
        DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat stateNum=0 re-entry - auto-transition timer missing", "UnitId=", self.UnitId, "IsBoss=", self._IsBoss, "IsMoving=", self.IsMoving)
      else
        DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat SKIP (already active and built, stateNum=0)", "expectAutoStart=", expectAutoStart, "hasAutoTimer=", hasAutoTimer, "IsMoving=", self.IsMoving)
        return
      end
    end
    DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat stateNum=0 re-entry allowed", "IsActive=", self.IsActive, "CarriagesBuilt=", self._CarriagesBuilt, "TrainHidden=", self._TrainHidden, "HasCompletedState0To1=", self._HasCompletedState0To1)
    self.IsActive = true
    self:_EnterPrepareState()
  elseif self.IsActive then
    DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat SKIP (already active, stateNum=", stateNum, ")")
    return
  else
    self.IsActive = true
    DebugPrint("BP_SplineTrain_Dynamic: ActiveCombat unknown stateNum=", stateNum)
  end
  self:UpdateTriggerBoxes()
end

function M:_EnterPrepareState()
  if self._HasCompletedState0To1 then
    if self.RemoveTimer then
      self:RemoveTimer("TrainPrepareAutoTransition")
    end
  elseif self.IsExistTimer and self:IsExistTimer("TrainPrepareAutoTransition") then
    DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState - auto-transition timer pending, skip re-entry", "UnitId=", self.UnitId)
    return
  end
  if self._IsBoss == nil then
    local params = not self.UnitParams and self.Data and self.Data.UnitParams
    self._IsBoss = params and params.IsBoss
  end
  if nil == self._IsStatic then
    local params = not self.UnitParams and self.Data and self.Data.UnitParams
    self._IsStatic = params and params.IsStatic and true or false
  end
  DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState", "UnitId=", self.UnitId, "IsBoss=", self._IsBoss, "IsStatic=", self._IsStatic, "CarriagesBuilt=", self._CarriagesBuilt, "HasCompletedState0To1=", self._HasCompletedState0To1, "StateId=", self.StateId, "bAutoStartOnSpawn=", self.bAutoStartOnSpawn)
  self:ApplyTrainConfig(nil)
  if self._TrainHidden then
    DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState - was hidden, force rebuild", "HasCompletedState0To1=", self._HasCompletedState0To1)
    if self._HasCompletedState0To1 then
      self:_DestroyGeneratedTrainForMechanismReset()
    end
    self:_RestoreTrainAfterHide()
  elseif self._HasCompletedState0To1 then
    DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState - completed 0→1, force teardown rebuild", "UnitId=", self.UnitId, "paramsUnchanged=", self:IsInitParamsUnchanged())
    self:_DestroyGeneratedTrainForMechanismReset()
    self:_RestoreTrainAfterHide()
  elseif not self._LastInitParamsSnapshot then
    self:SaveInitParamsSnapshot()
    self:EnsureTrainInitialized(nil)
  elseif self._CarriagesBuilt then
    self:ResetToState0Runtime()
  else
    self:EnsureTrainInitialized(nil)
  end
  if self._IsBoss then
    self:ResetTrain()
    self:SpawnPortalVfx()
    self:ResetBossPortalReveal()
    self:UpdateBossPortalCarriageVisibility()
  else
    self:DestroyPortalVfx()
  end
  if self.RemoveTimer then
    self:RemoveTimer("TrainPrepareAutoTransition")
  end
  
  local function DoTransitionToState1()
    if self._TrainHidden then
      DebugPrint("BP_SplineTrain_Dynamic: auto-transition SKIPPED - train is hidden")
      return
    end
    if not self.InitSuccess then
      DebugPrint("BP_SplineTrain_Dynamic: auto-transition DEFERRED - InitSuccess not ready, retry", "UnitId=", self.UnitId)
      if self.AddTimer then
        self:AddTimer(AUTO_TRANSITION_RETRY_SEC, DoTransitionToState1, false, 0, "TrainPrepareAutoTransition", true)
      end
      return
    end
    self._HasCompletedState0To1 = true
    if not self.IsActive then
      DebugPrint("BP_SplineTrain_Dynamic: auto-transition - IsActive=false, restore then ChangeState", "UnitId=", self.UnitId)
      self.IsActive = true
    end
    local runningStateId = self:FindStateIdByNumber(1)
    if runningStateId then
      DebugPrint("BP_SplineTrain_Dynamic: auto-transition -> ChangeState", "UnitId=", self.UnitId, "stateNum=1", "targetStateId=", runningStateId)
      self:ChangeState("Manual", 0, runningStateId)
    else
      DebugPrint("BP_SplineTrain_Dynamic: auto-transition FAILED - stateNum=1 not found, fallback to StartMove")
      self:StartMove()
    end
  end
  
  if self._IsBoss then
    local delay = self.PortalStartDelay
    if nil == delay then
      delay = PORTAL_START_DELAY
    end
    if self.AddTimer then
      self:AddTimer(delay, DoTransitionToState1, false, 0, "TrainPrepareAutoTransition", true)
      DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState arm timer (Boss)", "PortalStartDelay=", self.PortalStartDelay, "delay=", delay, "bAutoStartOnSpawn=", self.bAutoStartOnSpawn, "(ignored)")
    end
  else
    if self.bAutoStartOnSpawn == false then
      DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState", "isBoss=false", "autoStart=false, stay in state 0")
      return
    end
    local delay = self.PrepareStartDelay
    if nil == delay then
      delay = PREPARE_START_DELAY
    end
    if self.AddTimer then
      self:AddTimer(delay, DoTransitionToState1, false, 0, "TrainPrepareAutoTransition")
      DebugPrint("BP_SplineTrain_Dynamic: EnterPrepareState arm timer (non-Boss)", "PrepareStartDelay=", self.PrepareStartDelay, "delay=", delay, "bAutoStartOnSpawn=", self.bAutoStartOnSpawn)
    end
  end
end

function M:DisableTrainCollisions(ClearOverlapEvents)
  if self.AllTrainMeshes then
    for i, mesh in ipairs(self.AllTrainMeshes) do
      if mesh and IsValid(mesh) then
        self:SetCarriageMeshCollision(i, false)
        if ClearOverlapEvents and mesh.OnComponentBeginOverlap then
          mesh.OnComponentBeginOverlap:Clear()
        end
      end
    end
  end
  if self._SlowBox and IsValid(self._SlowBox) then
    self._SlowBox:SetCollisionEnabled(ECollisionEnabled.NoCollision)
    self._SlowBoxCollisionOn = false
    if ClearOverlapEvents and self._SlowBox.OnComponentBeginOverlap then
      self._SlowBox.OnComponentBeginOverlap:Clear()
    end
    if ClearOverlapEvents and self._SlowBox.OnComponentEndOverlap then
      self._SlowBox.OnComponentEndOverlap:Clear()
    end
  end
end

function M:DeActiveCombat()
  if not self.IsActive then
    return
  end
  DebugPrint("BP_SplineTrain_Dynamic: DeActiveCombat", "UnitId=", self.UnitId, "StateId=", self.StateId, "stateNum=", self:GetStateNumber(), "CurrentDistance=", self.CurrentDistance, "IsMoving=", self.IsMoving)
  self.IsActive = false
  if self.RemoveTimer then
    self:RemoveTimer("TrainPrepareAutoTransition")
  end
  self:SetActorTickEnabled(false)
  self:StopMove()
  self:DisableTrainCollisions(false)
end

function M:_DestroyTrainByReason(Reason, Tag)
  if self._TrainDestroying then
    return
  end
  if not IsValid(self) then
    return
  end
  self._TrainDestroying = true
  self:_UnbindDirectSourceWatch()
  self._HadDirectSource = false
  local lastTick = self._LastTickTime
  local now = UE4.UGameplayStatics.GetTimeSeconds(self)
  DebugPrint("BP_SplineTrain_Dynamic: DESTROY", "Reason=", Reason, "Tag=", Tag, "UnitId=", self.UnitId, "ActorName=", self:GetName(), "CurrentDistance=", self.CurrentDistance, "StateId=", self.StateId, "LifeTime=", self.LifeTime, "IsMoving=", self.IsMoving, "lastTick=", lastTick, "now=", now)
  print(_G.LogTag, "[SplineTrain] DESTROY", "Reason=", Reason, "Tag=", Tag, "UnitId=", self.UnitId, "ActorName=", self:GetName(), "CurrentDistance=", self.CurrentDistance, "StateId=", self.StateId)
  self.IsMoving = false
  self._RailTrainSfxPlayed = false
  if self.RemoveTimer then
    self:RemoveTimer(TRAIN_LIFETIME_TIMER_KEY)
    self:RemoveTimer("TrainTickHeartbeat")
  end
  self:_ClearAllNamedTimers()
  self:ClearMoveTimer()
  self:ClearLoopResetTimer()
  self:SetActorTickEnabled(false)
  if self.GetAttachParentActor and self:GetAttachParentActor() and self.K2_DetachFromActor then
    self:K2_DetachFromActor(UE4.EDetachmentRule.KeepWorld, UE4.EDetachmentRule.KeepWorld, UE4.EDetachmentRule.KeepWorld)
  end
  if self.EMActorDestroy then
    self:EMActorDestroy(Reason)
  end
end

function M:_TryStartLifeTimeDestroy()
  local lifeTime = self.LifeTime
  if nil == lifeTime or 0 == lifeTime or -1 == lifeTime then
    return
  end
  if type(lifeTime) ~= "number" or lifeTime < 0 then
    DebugPrint("BP_SplineTrain_Dynamic: _TryStartLifeTimeDestroy SKIP - invalid LifeTime", "LifeTime=", lifeTime, "UnitId=", self.UnitId)
    return
  end
  if not self.AddTimer then
    return
  end
  if self.RemoveTimer then
    self:RemoveTimer(TRAIN_LIFETIME_TIMER_KEY)
  end
  DebugPrint("BP_SplineTrain_Dynamic: _TryStartLifeTimeDestroy", "LifeTime=", lifeTime, "UnitId=", self.UnitId, "ActorName=", self:GetName())
  self:AddTimer(lifeTime, function()
    self:_DestroyTrainByReason(EDestroyReason.MechanismLifeTime, "LifeTimeExpired")
  end, false, 0, TRAIN_LIFETIME_TIMER_KEY)
end

function M:StartMove()
  if (self.ActiveMeshCount or 0) <= 0 then
    self:EnsureTrainInitialized(nil)
  end
  if self._IsStatic then
    DebugPrint("BP_SplineTrain_Dynamic: StartMove REJECTED - IsStatic（静态机关不移动）", "UnitId=", self.UnitId)
    if self._TrainHidden then
      self:_RestoreTrainAfterHide()
    else
      self:ResetSequentialReveal()
      self:ResetTrain()
      self:UpdateTriggerBoxes()
    end
    return
  end
  local sp, spValid = self:GetMoveSpeed()
  if not spValid then
    DebugPrint("BP_SplineTrain_Dynamic: StartMove REJECTED - speed invalid")
    return
  end
  self:_RestoreTrainAfterHide()
  self.SplineLength = self.Spline and IsValid(self.Spline) and self.Spline:GetSplineLength() or 0
  self:_WarnIfSplineTooShort(self:GetTrainTailOffset(), "StartMove")
  self:ResetTrain()
  self:StartSequentialReveal()
  if self._IsBoss then
    self:ResetBossPortalReveal()
    self:UpdateBossPortalCarriageVisibility()
  end
  self.IsMoving = true
  self._TrainDestroying = false
  self:ClearMoveTimer()
  if self.PrimaryActorTick then
    self.PrimaryActorTick.bCanEverTick = true
  end
  if self.SetActorTickInterval then
    self:SetActorTickInterval(0)
  elseif self.PrimaryActorTick then
    self.PrimaryActorTick.TickInterval = 0
  end
  self:SetActorTickEnabled(true)
  self:UpdateTrainPosition()
  PlayRailTrainMoveSound(self)
  self._LastTickTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  DbgPrint(self, "BP_SplineTrain_Dynamic: StartMove", "SplineLength=", self.SplineLength, "CurrentDistance=", self.CurrentDistance, "TimeSeconds=", UE4.UGameplayStatics.GetTimeSeconds(self), "speed=", sp, "tickInterval=", self.GetActorTickInterval and self:GetActorTickInterval() or "?")
  self:TryStartLoopResetTimer()
  self:_TryStartLifeTimeDestroy()
  if self.AddTimer then
    if self.RemoveTimer then
      self:RemoveTimer("TrainTickHeartbeat")
    end
    self:AddTimer(TICK_HEARTBEAT_INTERVAL, function()
      if self._TrainDestroying or not self.IsMoving then
        return
      end
      local last = self._LastTickTime
      local now = UE4.UGameplayStatics.GetTimeSeconds(self)
      if not last or now - last > TICK_HEARTBEAT_TIMEOUT then
        self:_DestroyTrainByReason(EDestroyReason.MechanismDead, "TickHeartbeatTimeout")
      end
    end, true, 0, "TrainTickHeartbeat", true)
  end
end

function M:StopMove()
  if self._TrainDestroying then
    self.IsMoving = false
    self._RailTrainSfxPlayed = false
    self:ClearMoveTimer()
    self:ClearLoopResetTimer()
    if self.RemoveTimer then
      self:RemoveTimer("TrainTickHeartbeat")
      self:RemoveTimer(TRAIN_LIFETIME_TIMER_KEY)
    end
    self:SetActorTickEnabled(false)
    return
  end
  if self.IsMoving then
    DebugPrint("BP_SplineTrain_Dynamic: StopMove trace", "UnitId=", self.UnitId, "StateId=", self.StateId, "CurrentDistance=", self.CurrentDistance, "SplineLength=", self.SplineLength, "\n", debug.traceback("", 2))
  end
  self.IsMoving = false
  self._RailTrainSfxPlayed = false
  self:ClearMoveTimer()
  self:ClearLoopResetTimer()
  if self.RemoveTimer then
    self:RemoveTimer("TrainTickHeartbeat")
    self:RemoveTimer(TRAIN_LIFETIME_TIMER_KEY)
  end
  self:SetActorTickEnabled(false)
  if not self._IsStatic then
    local hideOk, hideErr = pcall(self.HideTrain, self)
    if not hideOk then
      print(_G.LogTag, "[SplineTrain] ERROR - HideTrain threw", tostring(hideErr))
      if self.SetActorHiddenInGame then
        self:SetActorHiddenInGame(true)
      end
      self.IsActive = false
    end
  end
end

function M:StopLoop()
  self:ClearLoopResetTimer()
end

function M:ResetBossPortalReveal()
  self._PortalRevealed = {}
  if not self._IsBoss or self.AlwaysShow == true then
    return
  end
  if self.AllTrainMeshes then
    for _, mesh in ipairs(self.AllTrainMeshes) do
      if mesh and IsValid(mesh) then
        mesh:SetVisibility(false, true)
        mesh:SetHiddenInGame(true, true)
      end
    end
  end
  if self.AllConnectMeshes then
    for _, mesh in ipairs(self.AllConnectMeshes) do
      if mesh and IsValid(mesh) then
        mesh:SetVisibility(false, true)
        mesh:SetHiddenInGame(true, true)
      end
    end
  end
end

function M:IsCarriagePortalRevealed(carriageIndex)
  if not self._IsBoss or self.AlwaysShow == true then
    return true
  end
  return self._PortalRevealed ~= nil and true == self._PortalRevealed[carriageIndex]
end

function M:UpdateBossPortalCarriageVisibility()
  if not self._IsBoss then
    return
  end
  if not self.AllTrainMeshes or (self.ActiveMeshCount or 0) <= 0 then
    return
  end
  self._PortalRevealed = self._PortalRevealed or {}
  local bAlwaysShow = self.AlwaysShow == true
  for i = 1, self.ActiveMeshCount do
    local mesh = self.AllTrainMeshes[i]
    if mesh and IsValid(mesh) then
      if not bAlwaysShow and not self._PortalRevealed[i] then
        local hx = 1 == i and (self._CachedHeadHX or DEFAULT_HEAD_HALF_X) or self._CachedBodyHX or DEFAULT_BODY_HALF_X
        local frontDist = self:GetCarriageSplineDistance(i) + hx
        if frontDist >= 0 then
          self._PortalRevealed[i] = true
          DebugPrint("BP_SplineTrain_Dynamic: Portal reveal carriage", "index=", i, "frontDist=", frontDist, "UnitId=", self.UnitId)
        end
      end
      local bShow = (bAlwaysShow or self._PortalRevealed[i] == true) and self:IsSequentialRevealMeshVisible(i)
      mesh:SetVisibility(bShow, true)
      mesh:SetHiddenInGame(not bShow, true)
    end
  end
  if self.AllConnectMeshes then
    for i = 1, self.ActiveConnectCount or 0 do
      local mesh = self.AllConnectMeshes[i]
      if mesh and IsValid(mesh) then
        local bShow = (bAlwaysShow or self._PortalRevealed[i] == true and self._PortalRevealed[i + 1] == true) and self:IsSequentialRevealConnectVisible(i)
        mesh:SetVisibility(bShow, true)
        mesh:SetHiddenInGame(not bShow, true)
      end
    end
  end
end

function M:ResolveHeadBehindPortalDistance()
  local d = self.HeadBehindPortalDistance
  if type(d) == "number" and d > 0 then
    return d
  end
  DbgPrint(self, "BP_SplineTrain_Dynamic: HeadBehindPortalDistance fallback to head half length", "bpValue=", d, "UnitId=", self.UnitId)
  return self._CachedHeadHX or DEFAULT_HEAD_HALF_X
end

function M:SpawnPortalVfx()
  if not self.PortalEffect or not IsValid(self.PortalEffect) then
    DebugPrint("BP_SplineTrain_Dynamic: IsBoss but no PortalEffect component in blueprint")
    return
  end
  if not self.PortalEffect.GetAsset or not IsValid(self.PortalEffect:GetAsset()) then
    return
  end
  local anchorLoc, anchorRot = self:GetStartAnchorWorld()
  local spawnLoc = self:GetSplineWorldLocation(0) or anchorLoc or self:K2_GetActorLocation()
  local offsetBasisRot = anchorRot
  if self:UseSplineTrack() then
    offsetBasisRot = self.Spline:GetRotationAtDistanceAlongSpline(0, ESplineCoordinateSpace.World)
    offsetBasisRot = self:RebaseRotationToForward(offsetBasisRot)
  end
  local offset = self.PortalOffset
  if offset and (0 ~= offset.X or 0 ~= offset.Y or 0 ~= offset.Z) then
    local worldOff = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(FVector(offset.X, offset.Y, offset.Z), offsetBasisRot)
    spawnLoc = spawnLoc + worldOff
  end
  if self._PortalDesignedRelRot == nil then
    self._PortalDesignedRelRot = self.PortalEffect.RelativeRotation
  end
  self.PortalEffect:K2_SetWorldLocation(spawnLoc, false, nil, false)
  self.PortalEffect:K2_SetRelativeRotation(self._PortalDesignedRelRot, false, nil, false)
  self.PortalEffect:SetNiagaraVariableBool("DeadTime", false)
  self._PortalDeadTimeTriggered = nil
  self.PortalEffect:SetVisibility(true, true)
  self.PortalEffect:SetHiddenInGame(false, true)
  self.PortalEffect:Activate(true)
  AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/scene/ex02/rail_portal")
  DebugPrint("BP_SplineTrain_Dynamic: PortalEffect activated at", spawnLoc, "HeadBehind=", self:ResolveHeadBehindPortalDistance(), "CurrentDistance=", self.CurrentDistance, "relRot=", self._PortalDesignedRelRot)
end

function M:CheckPortalPassThrough()
  if not self.PortalEffect or not IsValid(self.PortalEffect) then
    return
  end
  if not self.PortalEffect.GetAsset or not IsValid(self.PortalEffect:GetAsset()) then
    return
  end
  if self._PortalDeadTimeTriggered then
    return
  end
  if self.PortalEffect.bHiddenInGame then
    return
  end
  local tailOffset = self:GetTrainTailOffset()
  local threshold = tailOffset + (self.PortalPassDistance or 0)
  if threshold < (self.CurrentDistance or 0) then
    DebugPrint("BP_SplineTrain_Dynamic: Train passed portal threshold, destroying", "CurrentDistance=", self.CurrentDistance, "tailOffset=", tailOffset, "PortalPassDistance=", self.PortalPassDistance)
    self:DestroyPortalVfx()
  end
end

function M:DestroyPortalVfx()
  if self.PortalEffect and IsValid(self.PortalEffect) then
    self.PortalEffect:SetNiagaraVariableBool("DeadTime", true)
    self._PortalDeadTimeTriggered = true
  end
  DebugPrint("BP_SplineTrain_Dynamic: PortalEffect DeadTime triggered")
end

function M:InitTrain()
  self:EnsureTrainInitialized(nil)
  DebugPrint("BP_SplineTrain_Dynamic: InitTrain called")
end

function M:StartTrainMove()
  if self.RemoveTimer then
    self:RemoveTimer("TrainPrepareAutoTransition")
  end
  self:EnsureTrainInitialized(nil)
  self.IsActive = true
  self._HasCompletedState0To1 = true
  self:StartMove()
  self:UpdateTriggerBoxes()
  DebugPrint("BP_SplineTrain_Dynamic: StartTrainMove called")
end

function M:StopTrainMove()
  if self.RemoveTimer then
    self:RemoveTimer("TrainPrepareAutoTransition")
  end
  self.IsActive = false
  self:StopMove()
  self:DisableTrainCollisions(false)
  DebugPrint("BP_SplineTrain_Dynamic: StopTrainMove called")
end

function M:SetPortalEffectPath(AssetPath)
  if not AssetPath or "" == AssetPath then
    return
  end
  self._ConfigPortalEffectPath = AssetPath
  DebugPrint("BP_SplineTrain_Dynamic: SetPortalEffectPath =", AssetPath)
end

function M:_ClearAllNamedTimers()
  self:_RestoreSlowTimeDilation()
  if not self.RemoveTimer then
    return
  end
  self:RemoveTimer("TrainPrepareAutoTransition")
  self:RemoveTimer("SplineTrainDelayedInit")
  self:RemoveTimer(TRAIN_LIFETIME_TIMER_KEY)
  self:RemoveTimer("TrainTickHeartbeat")
end

function M:_HideAllLegacyVisuals()
  if self.HeadMeshComponent and IsValid(self.HeadMeshComponent) then
    self:HideComponent(self.HeadMeshComponent)
  end
  HideNamedComponentSeries(self, "Mesh", LEGACY_MESH_SCAN_MAX)
  HideNamedComponentSeries(self, "Connect", LEGACY_MESH_SCAN_MAX)
  if self.DefaultTransform and IsValid(self.DefaultTransform) then
    self:HideComponent(self.DefaultTransform)
  end
  if self.PortalEffect and IsValid(self.PortalEffect) then
    self.PortalEffect:SetNiagaraVariableBool("DeadTime", true)
    self:HideComponent(self.PortalEffect)
  end
  if self.MyDynamicSpline and IsValid(self.MyDynamicSpline) then
    self:HideComponent(self.MyDynamicSpline)
  end
end

function M:HideTrain()
  if self._TrainHidden then
    return
  end
  self._TrainHidden = true
  DebugPrint("BP_SplineTrain_Dynamic: HideTrain begin", "UnitId=", self.UnitId, "ActorName=", self:GetName())
  self:StopMove()
  self:StopLoop()
  self:ClearMoveTimer()
  self:ClearLoopResetTimer()
  self:_ClearAllNamedTimers()
  self:DestroyPortalVfx()
  if self._DodgePromptActive then
    self:HideDodgePrompt(self._DodgePlayer)
  end
  self:DisableTrainCollisions(true)
  self:_HideAllLegacyVisuals()
  self:SetActorHiddenInGame(true)
  self.IsActive = false
  self.IsMoving = false
  AllTrains[self] = nil
  DebugPrint("BP_SplineTrain_Dynamic: HideTrain complete")
end

function M:ShowTrain()
  if not self._TrainHidden then
    return
  end
  self._TrainHidden = false
  DebugPrint("BP_SplineTrain_Dynamic: ShowTrain", "ActorName=", self:GetName())
  self:SetActorHiddenInGame(false)
end

function M:_RestoreTrainAfterHide()
  if not self._TrainHidden then
    return
  end
  self:ShowTrain()
  self:ClearCarriages()
  self:SaveInitParamsSnapshot()
  self:EnsureTrainInitialized(nil)
  if self._IsBoss then
    self:ResetTrain()
    self:SpawnPortalVfx()
    self:ResetBossPortalReveal()
    self:UpdateBossPortalCarriageVisibility()
  end
end

function M:SetTrainSpeed(Speed)
  if type(Speed) == "number" and Speed > 0 then
    self.speed = Speed
    DebugPrint("BP_SplineTrain_Dynamic: SetTrainSpeed =", Speed)
  else
    self.speed = nil
    DebugPrint("BP_SplineTrain_Dynamic: SetTrainSpeed reset to default")
  end
end

function M:SetCarriageCount(Count)
  if type(Count) ~= "number" or Count < 1 then
    DebugPrint("BP_SplineTrain_Dynamic: SetCarriageCount IGNORED - invalid count=", Count)
    return
  end
  Count = math.floor(Count)
  DebugPrint("BP_SplineTrain_Dynamic: SetCarriageCount", "count=", Count, "was=", self.CarriageCount or self:ResolveCarriageCount())
  self.CarriageCount = Count
  self:ClearCarriages()
  self._LastInitParamsSnapshot = nil
  self:EnsureTrainInitialized(nil)
end

function M:GMSwitchState(stateNum)
  if not stateNum or type(stateNum) ~= "number" then
    DebugPrint("BP_SplineTrain_Dynamic: GMSwitchState FAILED - stateNum must be a number")
    return
  end
  stateNum = math.floor(stateNum)
  local targetStateId = self:FindStateIdByNumber(stateNum)
  if not targetStateId then
    DebugPrint("BP_SplineTrain_Dynamic: GMSwitchState FAILED", "stateNum=", stateNum, "UnitId=", self.UnitId, "no matching StateId found in StateIdList")
    return
  end
  DebugPrint("BP_SplineTrain_Dynamic: GMSwitchState", "UnitId=", self.UnitId, "currentStateId=", self.StateId, "targetStateNum=", stateNum, "targetStateId=", targetStateId)
  self:ChangeState("GM", 0, targetStateId)
end

function M.GetAllTrains()
  return AllTrains
end

return M
