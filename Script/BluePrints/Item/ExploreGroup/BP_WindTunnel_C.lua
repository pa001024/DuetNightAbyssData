require("UnLua")
local M = Class("BluePrints/Item/BP_CombatItemBase_C")
local CSpace = ESplineCoordinateSpace.World
local ACTIVE_STATE_ID = 702041
local INIT_STATE_ID = 702040
local HIDE_REASON = "WindTunnelState"

function M:_GetActiveStateId()
  return self.ActiveStateId or ACTIVE_STATE_ID
end

function M:_GetInitStateId()
  return self.InitStateId or INIT_STATE_ID
end

function M:_IsWindTunnelActive()
  return self.StateId == self:_GetActiveStateId()
end

function M:_SetInteractiveEnabled(bEnabled)
  local function ApplyComp(Comp)
    if not Comp then
      return
    end
    Comp.bCanUsed = bEnabled
    if Comp.UpdateInteractiveUIState and (IsClient(self) or IsStandAlone(self)) then
      Comp:UpdateInteractiveUIState()
    end
  end
  
  if self.InteractiveComponents and self.InteractiveComponents:Length() > 0 then
    for i = 1, self.InteractiveComponents:Length() do
      ApplyComp(self.InteractiveComponents:GetRef(i))
    end
    return
  end
  ApplyComp(self.DefaultInteractiveComponent or self.ChestInteractiveComponent)
end

function M:_ApplyWindTunnelState(NowStateId)
  local bActive = NowStateId == self:_GetActiveStateId()
  if bActive then
    self:ShowMechanism(HIDE_REASON)
    self:_SetInteractiveEnabled(true)
    if IsClient(self) or IsStandAlone(self) then
      self:SetActorTickEnabled(true)
    end
  else
    self:_ResetWindTunnelState()
    self:HideMechanism(false, HIDE_REASON)
    self:_SetInteractiveEnabled(false)
    if IsClient(self) or IsStandAlone(self) then
      self:SetActorTickEnabled(false)
    end
  end
end

function M:OnEnterState(NowStateId)
  if self.Overridden and self.Overridden.OnEnterState then
    self.Overridden.OnEnterState(self, NowStateId)
  end
  self:RemoveTimer("WindTunnelApplyState")
  self:AddTimer(0, function()
    self:_ApplyWindTunnelState(NowStateId)
  end, false, nil, "WindTunnelApplyState")
end

function M:_GetConfig()
  return {
    ActivateDistance = tonumber(self.ActivateDistance) or 800,
    AttractDistance = tonumber(self.AttractDistance) or 400,
    ForwardSpeed = tonumber(self.ForwardSpeed) or 500,
    AttractSpeed = tonumber(self.AttractSpeed) or 800,
    DeadZone = tonumber(self.DeadZone) or 30,
    bReverseFlow = self.bReverseFlow == true,
    FlowBlendSpeed = tonumber(self.FlowBlendSpeed) or 10,
    bRequireMountFly = self.bRequireMountFly ~= false,
    bAlignToFlow = false ~= self.bAlignToFlow,
    AlignSpeed = tonumber(self.AlignSpeed) or 5,
    bAutoCamera = false ~= self.bAutoCamera,
    CameraIdleCD = tonumber(self.CameraIdleCD) or 1.5,
    CameraAutoTurnSpeed = tonumber(self.CameraAutoTurnSpeed) or 3
  }
end

function M:ReceiveBeginPlay()
  self.Super.ReceiveBeginPlay(self)
  self.PrimaryActorTick.bCanEverTick = true
  self.PrimaryActorTick.TickInterval = 0
  self:_InvalidateSplineAxis()
  self:_ResetWindTunnelState()
  if not self.Spline then
    print(_G.ErrorTag, "[WindTunnel] 找不到 Spline 组件 self.Spline，请检查蓝图组件名")
  end
  DebugPrint("[WindTunnel] ReceiveBeginPlay")
end

function M:_ResetAutoCamera()
  self._CamIdleTime = 0
  self._LastControlRot = nil
end

function M:_ResetWindTunnelState()
  self:_ResetAutoCamera()
end

function M:_InvalidateSplineAxis()
  self._SplineAxisReady = false
  self._SplineLen = nil
  self._SplineStart = nil
  self._SplineAxisDir = nil
end

function M:_EnsureSplineAxis()
  if self._SplineAxisReady or not self.Spline then
    return
  end
  local Spline = self.Spline
  self._SplineLen = Spline:GetSplineLength()
  self._SplineStart = Spline:GetLocationAtDistanceAlongSpline(0, CSpace)
  local EndLoc = Spline:GetLocationAtDistanceAlongSpline(self._SplineLen, CSpace)
  self._SplineAxisDir = UKismetMathLibrary.Normal(EndLoc - self._SplineStart, 1.0E-4)
  self._SplineAxisReady = true
end

function M:_GetPlayerSplineInfo(PlayerLoc, Cfg)
  self:_EnsureSplineAxis()
  local Spline = self.Spline
  local ProjRaw = UKismetMathLibrary.Dot_VectorVector(PlayerLoc - self._SplineStart, self._SplineAxisDir)
  local ProjDist = math.max(0, math.min(self._SplineLen, ProjRaw))
  local CenterLoc = Spline:GetLocationAtDistanceAlongSpline(ProjDist, CSpace)
  local PerpDist = (PlayerLoc - CenterLoc):Size()
  local FlowDir = Spline:GetDirectionAtDistanceAlongSpline(ProjDist, CSpace)
  FlowDir = UKismetMathLibrary.Normal(FlowDir, 1.0E-4)
  if Cfg.bReverseFlow then
    FlowDir = FlowDir * -1
  end
  return PerpDist, CenterLoc, FlowDir
end

function M:_IsPlayerInMountFly(Player, Cfg)
  if not IsValid(Player) then
    return false
  end
  if not Cfg.bRequireMountFly then
    return true
  end
  if Player.IsInMountState and not Player:IsInMountState() then
    return false
  end
  local Movement = Player:GetMovementComponent()
  if Movement and Movement.IsFlying and Movement:IsFlying() then
    return true
  end
  return false
end

function M:ReceiveTick(DeltaSeconds)
  if not IsClient(self) and not IsStandAlone(self) then
    return
  end
  if not self:_IsWindTunnelActive() then
    self:_ResetWindTunnelState()
    return
  end
  if not self.Spline then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Cfg = self:_GetConfig()
  if not self:_IsPlayerInMountFly(Player, Cfg) then
    self:_ResetWindTunnelState()
    return
  end
  self:_ApplyWindTunnel(Player, DeltaSeconds, Cfg)
end

function M:_BuildLateralPullVel(PlayerLoc, CenterLoc, FlowDir, PerpDist, Cfg)
  if PerpDist <= Cfg.DeadZone or PerpDist > Cfg.AttractDistance then
    return FVector(0, 0, 0)
  end
  local ToCenter = CenterLoc - PlayerLoc
  local Along = UKismetMathLibrary.Dot_VectorVector(ToCenter, FlowDir)
  local Lateral = ToCenter - FlowDir * Along
  local LatDist = Lateral:Size()
  if LatDist <= Cfg.DeadZone then
    return FVector(0, 0, 0)
  end
  local PullDir = UKismetMathLibrary.Normal(Lateral, 1.0E-4)
  local PullSpeed = Cfg.AttractSpeed * (LatDist / Cfg.AttractDistance)
  return PullDir * PullSpeed
end

function M:_ApplyWindVelocity(Player, FlowDir, CenterLoc, PlayerLoc, PerpDist, Cfg, DeltaSeconds)
  local MoveComp = Player.CharacterMovement
  if not MoveComp then
    return
  end
  local Vel = MoveComp.Velocity
  local Along = UKismetMathLibrary.Dot_VectorVector(Vel, FlowDir)
  local VelPerp = Vel - FlowDir * Along
  local Blend = math.min(1, DeltaSeconds * Cfg.FlowBlendSpeed)
  local NewAlong = Along + (Cfg.ForwardSpeed - Along) * Blend
  local PullVel = self:_BuildLateralPullVel(PlayerLoc, CenterLoc, FlowDir, PerpDist, Cfg)
  MoveComp.Velocity = VelPerp + FlowDir * NewAlong + PullVel
end

function M:_ApplyWindTunnel(Player, DeltaSeconds, Cfg)
  local PlayerLoc = Player:K2_GetActorLocation()
  local PerpDist, CenterLoc, FlowDir = self:_GetPlayerSplineInfo(PlayerLoc, Cfg)
  if PerpDist > Cfg.ActivateDistance then
    self:_ResetWindTunnelState()
    return
  end
  self:_ApplyWindVelocity(Player, FlowDir, CenterLoc, PlayerLoc, PerpDist, Cfg, DeltaSeconds)
  if Cfg.bAlignToFlow then
    local FlowYaw = UKismetMathLibrary.MakeRotFromX(FlowDir).Yaw
    local CurRot = Player:K2_GetActorRotation()
    local TargetRot = FRotator(CurRot.Pitch, FlowYaw, CurRot.Roll)
    local NewRot = UKismetMathLibrary.RInterpTo(CurRot, TargetRot, DeltaSeconds, Cfg.AlignSpeed)
    Player:K2_SetActorRotation(NewRot, false)
  end
  self:_UpdateAutoCamera(Player, DeltaSeconds, Cfg, FlowDir)
end

function M:_UpdateAutoCamera(Player, DeltaSeconds, Cfg, FlowDir)
  if not Cfg.bAutoCamera then
    return
  end
  local Controller = Player:GetController()
  if not Controller then
    return
  end
  local CurCtrlRot = Controller:GetControlRotation()
  if not self._LastControlRot then
    self._LastControlRot = CurCtrlRot
    self._CamIdleTime = 0
    return
  end
  local Delta = UKismetMathLibrary.NormalizedDeltaRotator(CurCtrlRot, self._LastControlRot)
  local MovedAmount = math.abs(Delta.Yaw) + math.abs(Delta.Pitch) + math.abs(Delta.Roll)
  if MovedAmount > 0.5 then
    self._CamIdleTime = 0
    self._LastControlRot = CurCtrlRot
    return
  end
  self._CamIdleTime = self._CamIdleTime + DeltaSeconds
  if self._CamIdleTime < Cfg.CameraIdleCD then
    self._LastControlRot = CurCtrlRot
    return
  end
  local FlowYaw = UKismetMathLibrary.MakeRotFromX(FlowDir).Yaw
  local TargetRot = FRotator(CurCtrlRot.Pitch, FlowYaw, CurCtrlRot.Roll)
  local NewRot = UKismetMathLibrary.RInterpTo(CurCtrlRot, TargetRot, DeltaSeconds, Cfg.CameraAutoTurnSpeed)
  Controller:SetControlRotation(NewRot)
  self._LastControlRot = NewRot
end

function M:ReceiveEndPlay(Reason)
  self:RemoveTimer("WindTunnelApplyState")
end

return M
