require("UnLua")
local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})
local HUD_HIDE_TAG = "RollerCoaster"
local HUD_HIDE_SUBSYSTEMS = {
  "Pos_Instruction",
  "Char_Skill"
}

local function ClampAngleAroundBase(Angle, Base, Range)
  local Delta = UKismetMathLibrary.NormalizeAxis(Angle - Base)
  return Base + math.clamp(Delta, -Range, Range)
end

function M:AuthorityInitInfo(Info)
  DebugPrint("yly BP_RollerCoasterBase_C AuthorityInitInfo")
  M.Super.AuthorityInitInfo(self, Info)
end

function M:CommonInitInfo(Info)
  DebugPrint("yly BP_RollerCoasterBase_C CommonInitInfo")
  M.Super.CommonInitInfo(self, Info)
  if not self.Spline or not IsValid(self.Spline) then
    DebugPrint("yly BP_RollerCoasterBase_C CommonInitInfo: Spline is not valid")
    return
  end
  self.RailSpline = self.Spline
  if not self.Player_Pos or not IsValid(self.Player_Pos) then
    DebugPrint("yly BP_RollerCoasterBase_C CommonInitInfo: Player_Pos is not valid")
    return
  end
  self.PlayerPosComp = self.Player_Pos
  self.CurrentDistance = 0.0
  self.bIsMoving = false
  self.SplineLength = 0.0
  self.bIsLerping = false
  self.LerpStartSpeed = 0.0
  self.LerpTargetSpeed = 0.0
  self.LerpDuration = 0.0
  self.LerpElapsed = 0.0
  self.CameraYawRange = self.CameraYawRange or 70.0
  self.CameraPitchRange = self.CameraPitchRange or 45.0
  self.CameraBaseRotation = nil
  self.CameraAlignTime = self.CameraAlignTime or 0.5
  self.CameraAlignSpeed = self.CameraAlignSpeed or 20.0
  self.CameraTakeoverState = "None"
  self.CameraPullBackTime = self.CameraPullBackTime or 0.35
  self.CameraPullBackSpeed = self.CameraPullBackSpeed or 15.0
  self.PendingCameraExitTimeout = self.PendingCameraExitTimeout or 5.0
  self.bHudHidden = false
  self.SitActionSubFile = self.SitActionSubFile or "Interactive/MechInteractive"
  self.SitMontageSuffix = self.SitMontageSuffix or "Interactive_Sit02_Montage"
  self.SitStandSection = self.SitStandSection or "SitEnd"
  self.SitDownDelay = self.SitDownDelay or 1.0
  self.StandUpDelay = self.StandUpDelay or 1.0
end

function M:ClientInitInfo(Info)
  DebugPrint("yly BP_RollerCoasterBase_C ClientInitInfo")
  M.Super.ClientInitInfo(self, Info)
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self.DeactiveStateId = 1800010
  self.ActiveStateId = 1800011
  if IsValid(self.Spline) then
    self.SplineLength = self.Spline:GetSplineLength()
  end
end

function M:StartSpeedTransition(TargetSpeed, TransitionTime)
  if self.EventOnRollerSpeedChange then
    self:EventOnRollerSpeedChange(TargetSpeed, TransitionTime)
  end
  if TransitionTime <= 0 then
    self.Speed = TargetSpeed
    self.bIsLerping = false
  else
    self.LerpStartSpeed = self.Speed or 0.0
    self.LerpTargetSpeed = TargetSpeed
    self.LerpDuration = TransitionTime
    self.LerpElapsed = 0.0
    self.bIsLerping = true
  end
end

function M:UpdateSpeedLerp(DeltaSeconds)
  if not self.bIsLerping then
    return
  end
  self.LerpElapsed = self.LerpElapsed + DeltaSeconds
  local t = math.min(self.LerpElapsed / self.LerpDuration, 1.0)
  self.Speed = self.LerpStartSpeed + (self.LerpTargetSpeed - self.LerpStartSpeed) * t
  if t >= 1.0 then
    self.Speed = self.LerpTargetSpeed
    self.bIsLerping = false
  end
end

function M:OnEnterState(NowStateId)
  if NowStateId == self.DeactiveStateId then
    self:OnRollerCoasterDeactivate()
  elseif NowStateId == self.ActiveStateId then
    self:OnRollerCoasterActivate()
  end
end

function M:OnRollerCoasterActivate()
  self.CurrentDistance = 0.0
  self.bIsMoving = true
  self.CameraTakeoverState = "None"
  self.CameraBaseRotation = nil
  self.PendingCameraExitPlayer = nil
  self.PendingCameraExitElapsed = nil
  self:UpdateCubePosition()
  self:BoardLocalPlayer()
  self:SetActorTickEnabled(true)
end

function M:OnRollerCoasterDeactivate()
  self.bIsMoving = false
  self:SetActorTickEnabled(false)
  self:DisembarkLocalPlayer()
  self:SetGameplayHudHidden(false)
end

function M:ReceiveTick(DeltaSeconds)
  if self.PendingCameraExitPlayer then
    self:UpdatePendingCameraExit(DeltaSeconds)
    return
  end
  if not self.bIsMoving then
    return
  end
  self:UpdateSpeedLerp(DeltaSeconds)
  local MoveSpeed = self.Speed or 0.0
  self.CurrentDistance = self.CurrentDistance + MoveSpeed * DeltaSeconds
  if self.CurrentDistance >= self.SplineLength then
    self.CurrentDistance = self.SplineLength
    self:UpdateCubePosition()
    self:UpdateRidingPlayerTransform()
    self:OnReachSplineEnd()
    return
  end
  self:UpdateCubePosition()
  self:UpdateRidingPlayerTransform()
  self:KeepFirstPerson()
  self:UpdateRidingCameraYawAndPitchLimit()
end

function M:KeepFirstPerson(Player)
  Player = Player or self.RidingPlayer
  if not IsValid(Player) then
    return
  end
  local SpringArm = Player.CharSpringArmComponent
  if not IsValid(SpringArm) then
    return
  end
  SpringArm.MouseWheelTargetArmLength = 0.0
  SpringArm.BaseTargetArmLength = 0.0
end

function M:UpdateCubePosition()
  local dist = math.max(0.0, math.min(self.CurrentDistance, self.SplineLength))
  local Location = self.RailSpline:GetLocationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.Local)
  local Rotation = self.RailSpline:GetRotationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.Local)
  self.Cube:K2_SetRelativeLocationAndRotation(Location, Rotation, false, nil, false)
end

function M:UpdateRidingPlayerTransform()
  local Player = self.RidingPlayer
  if not IsValid(Player) or not IsValid(self.PlayerPosComp) then
    return
  end
  local BallLocation = self.PlayerPosComp:K2_GetComponentLocation()
  local BallRotation = self.PlayerPosComp:K2_GetComponentRotation()
  Player:K2_SetActorLocationAndRotation(BallLocation, BallRotation, false, nil, true)
  local MoveComp = Player.CharacterMovement
  if IsValid(MoveComp) then
    MoveComp:StopMovementImmediately()
  end
end

function M:OnReachSplineEnd()
  self.bIsMoving = false
  self:SetActorTickEnabled(false)
  DebugPrint("yly BP_RollerCoasterBase_C OnReachSplineEnd: 到达 Spline 终点")
  self:DisembarkLocalPlayer()
end

function M:SetGameplayHudHidden(bHide)
  bHide = bHide and true or false
  if bHide == (self.bHudHidden == true) then
    return
  end
  local UIMgr = UIManager(self)
  local BattleMain = UIMgr and UIMgr:GetUIObj("BattleMain")
  if not BattleMain or not BattleMain.HideSubSystem then
    DebugPrint("yly BP_RollerCoasterBase_C SetGameplayHudHidden: BattleMain 无效，跳过")
    return
  end
  for _, Name in ipairs(HUD_HIDE_SUBSYSTEMS) do
    BattleMain:HideSubSystem(Name, HUD_HIDE_TAG, bHide)
  end
  self.bHudHidden = bHide
  DebugPrint("yly BP_RollerCoasterBase_C SetGameplayHudHidden: bHide =", bHide)
end

function M:BoardLocalPlayer()
  local Player = GWorld:GetMainPlayer()
  if not IsValid(Player) then
    DebugPrint("yly BP_RollerCoasterBase_C BoardLocalPlayer: 本地玩家无效，无法上车")
    return
  end
  if not IsValid(self.PlayerPosComp) then
    DebugPrint("yly BP_RollerCoasterBase_C BoardLocalPlayer: PlayerPosComp 组件无效")
    return
  end
  local BallLocation = self.PlayerPosComp:K2_GetComponentLocation()
  local BallRotation = self.PlayerPosComp:K2_GetComponentRotation()
  Player:K2_SetActorLocationAndRotation(BallLocation, BallRotation, false, nil, false)
  local MoveComp = Player.CharacterMovement or Player:GetMovementComponent()
  if IsValid(MoveComp) then
    MoveComp:StopMovementImmediately()
    DebugPrint("yly BP_RollerCoasterBase_C BoardLocalPlayer: 关闭重力", MoveComp.GravityScale)
    self.SavedGravityScale = MoveComp.GravityScale
    MoveComp.GravityScale = 0.0
    MoveComp:SetMovementMode(EMovementMode.MOVE_Flying)
  end
  local Controller = Player:GetController()
  if IsValid(Controller) then
    Controller:SetIgnoreMoveInput(true)
  end
  Player:MoveAlongSplineBanSkills()
  Player:ForbidActionWhileMoveAlongSpline(true)
  self:SetGameplayHudHidden(true)
  self:EnterFirstPerson(Player)
  self:UpdateRidingCameraYawAndPitchLimit(Player)
  self.RidingPlayer = Player
  self:PlayerSitDown(Player)
  Player:SetActorHideTag("RollerCoaster", true)
  DebugPrint("yly BP_RollerCoasterBase_C BoardLocalPlayer: 玩家已上车")
end

function M:EnterFirstPerson(Player)
  local SpringArm = Player.CharSpringArmComponent
  if not IsValid(SpringArm) then
    DebugPrint("yly BP_RollerCoasterBase_C EnterFirstPerson: 弹簧臂无效")
    return
  end
  SpringArm.BaseTargetArmLength = 0.0
  SpringArm.MouseWheelTargetArmLength = 0.0
  SpringArm.BaseSpringArmForReset = 0.0
  Player:ResetSpringArm()
end

function M:ExitFirstPerson(Player)
  if Player.DefaultSpringArmRate then
    Player:SetDefaultSpringArmRate(Player.DefaultSpringArmRate)
  end
end

function M:UpdateRidingCameraYawAndPitchLimit(InPlayer)
  local Player = InPlayer or self.RidingPlayer
  if not IsValid(Player) or not IsValid(self.PlayerPosComp) then
    return
  end
  local Controller = Player:GetController()
  if not IsValid(Controller) then
    return
  end
  local CameraManager = Controller.PlayerCameraManager
  if not IsValid(CameraManager) then
    return
  end
  self:BackupCameraViewLimits(CameraManager)
  local BaseRot = self:GetCameraBaseRotation(self.PlayerPosComp:K2_GetComponentRotation())
  local OldBaseRot = self.CameraBaseRotation
  self.CameraBaseRotation = BaseRot
  if self:IsCameraTakenOverByOthers(Player) then
    if self.CameraTakeoverState ~= "Released" then
      self.CameraTakeoverState = "Released"
      self:ReleaseCameraViewLimits(CameraManager)
      DebugPrint("yly BP_RollerCoasterBase_C: 外部接管相机，暂停跟随和环顾范围夹取")
    end
    return
  end
  if self.CameraTakeoverState == "Released" then
    self:StartCameraLerpToTangent(Player, BaseRot, self.CameraPullBackTime, self.CameraPullBackSpeed, "TakeoverEnd")
    return
  end
  if self.CameraTakeoverState == "PullingBack" then
    return
  end
  if nil == OldBaseRot then
    self:StartCameraLerpToTangent(Player, BaseRot, self.CameraAlignTime, self.CameraAlignSpeed, "BoardAlign")
    return
  end
  self:ApplyCameraViewLimits(CameraManager, BaseRot)
  self:FollowCameraToTangent(Controller, BaseRot, OldBaseRot)
end

function M:GetCameraBaseRotation(Rotation)
  return FRotator(math.clamp(UKismetMathLibrary.NormalizeAxis(Rotation.Pitch), -89.9, 89.9), UKismetMathLibrary.NormalizeAxis(Rotation.Yaw), 0)
end

function M:FollowCameraToTangent(Controller, BaseRot, OldBaseRot)
  local CtrlRot = Controller:GetControlRotation()
  local DeltaYaw = UKismetMathLibrary.NormalizeAxis(BaseRot.Yaw - OldBaseRot.Yaw)
  local DeltaPitch = UKismetMathLibrary.NormalizeAxis(BaseRot.Pitch - OldBaseRot.Pitch)
  local Yaw = ClampAngleAroundBase(CtrlRot.Yaw + DeltaYaw, BaseRot.Yaw, self.CameraYawRange)
  local Pitch = ClampAngleAroundBase(CtrlRot.Pitch + DeltaPitch, BaseRot.Pitch, self.CameraPitchRange)
  Controller:SetControlRotation(FRotator(math.clamp(Pitch, -89.9, 89.9), Yaw, 0))
end

function M:StartCameraLerpToTangent(Player, BaseRot, Time, Speed, Reason)
  local Comp = self:GetCameraRotationComponent(Player)
  if not Comp then
    self.CameraTakeoverState = "None"
    return
  end
  self.CameraTakeoverState = "PullingBack"
  Comp:SetControlRotationAbsolute_Lerp(BaseRot, Time, Speed, false, function()
    if self.CameraTakeoverState == "PullingBack" then
      self.CameraTakeoverState = "None"
    end
  end)
  DebugPrint("yly BP_RollerCoasterBase_C StartCameraLerpToTangent:", Reason, "目标 Yaw =", BaseRot.Yaw)
end

function M:GetCameraRotationComponent(InPlayer)
  local Player = InPlayer or self.RidingPlayer
  if not IsValid(Player) then
    return nil
  end
  local Comp = Player.CameraRotationComponent
  if not IsValid(Comp) then
    return nil
  end
  return Comp
end

function M:IsCameraTakenOverByOthers(InPlayer)
  local Comp = self:GetCameraRotationComponent(InPlayer)
  if not Comp then
    return false
  end
  if Comp.IsCameraLookingToTarget then
    return true
  end
  if self.CameraTakeoverState ~= "PullingBack" and Comp:GetIsControllerAutoRotating() then
    return true
  end
  return false
end

function M:BackupCameraViewLimits(CameraManager)
  if self.OriginalViewYawMin ~= nil then
    return
  end
  self.OriginalViewYawMin = CameraManager.ViewYawMin
  self.OriginalViewYawMax = CameraManager.ViewYawMax
  self.OriginalViewPitchMin = CameraManager.ViewPitchMin
  self.OriginalViewPitchMax = CameraManager.ViewPitchMax
end

function M:ApplyCameraViewLimits(CameraManager, BaseRot)
  CameraManager.ViewYawMin = BaseRot.Yaw - self.CameraYawRange
  CameraManager.ViewYawMax = BaseRot.Yaw + self.CameraYawRange
  CameraManager.ViewPitchMin = math.max(BaseRot.Pitch - self.CameraPitchRange, -89.9)
  CameraManager.ViewPitchMax = math.min(BaseRot.Pitch + self.CameraPitchRange, 89.9)
end

function M:ReleaseCameraViewLimits(CameraManager)
  if self.OriginalViewYawMin == nil then
    return
  end
  CameraManager.ViewYawMin = self.OriginalViewYawMin
  CameraManager.ViewYawMax = self.OriginalViewYawMax
  CameraManager.ViewPitchMin = self.OriginalViewPitchMin
  CameraManager.ViewPitchMax = self.OriginalViewPitchMax
end

function M:ClearCameraViewLimitsBackup()
  self.OriginalViewYawMin = nil
  self.OriginalViewYawMax = nil
  self.OriginalViewPitchMin = nil
  self.OriginalViewPitchMax = nil
end

function M:UpdatePendingCameraExit(DeltaSeconds)
  local Player = self.PendingCameraExitPlayer
  if not IsValid(Player) then
    self:FinishPendingCameraExit()
    return
  end
  self:KeepFirstPerson(Player)
  self.PendingCameraExitElapsed = (self.PendingCameraExitElapsed or 0.0) + DeltaSeconds
  local Timeout = self.PendingCameraExitTimeout or 5.0
  if self:IsCameraTakenOverByOthers(Player) and Timeout > self.PendingCameraExitElapsed then
    return
  end
  self:ExitFirstPerson(Player)
  DebugPrint("yly BP_RollerCoasterBase_C UpdatePendingCameraExit: 外部接管结束，已恢复第三人称")
  self:FinishPendingCameraExit()
end

function M:FinishPendingCameraExit()
  self.PendingCameraExitPlayer = nil
  self.PendingCameraExitElapsed = nil
  self:SetActorTickEnabled(false)
end

function M:PlayerSitDown(Player)
  if not IsValid(Player) or not Player.PlayActionMontage then
    return
  end
  local Callback = {
    OnCompleted = function()
    end,
    OnBlendOut = function()
    end,
    OnInterrupted = function()
    end,
    OnNotifyBegin = function()
    end,
    OnNotifyEnd = function()
    end
  }
  Player:PlayActionMontage(self.SitActionSubFile, self.SitMontageSuffix, Callback, false, false, false)
end

function M:PlayerStandUp(Player)
  if not IsValid(Player) then
    return
  end
  local AnimInstance = Player.Mesh and Player.Mesh:GetAnimInstance()
  if IsValid(AnimInstance) then
    AnimInstance:Montage_JumpToSection(self.SitStandSection)
  end
end

function M:DisembarkLocalPlayer()
  local Player = self.RidingPlayer
  if not IsValid(Player) then
    return
  end
  if self.CameraTakeoverState == "PullingBack" then
    local Comp = self:GetCameraRotationComponent(Player)
    if Comp then
      Comp:StopControlRotationLerp()
    end
  end
  self.CameraTakeoverState = "None"
  self.CameraBaseRotation = nil
  local Controller = Player:GetController()
  if IsValid(Controller) then
    Controller:SetIgnoreMoveInput(false)
    local CameraManager = Controller.PlayerCameraManager
    if IsValid(CameraManager) then
      self:ReleaseCameraViewLimits(CameraManager)
    end
  end
  self:ClearCameraViewLimitsBackup()
  local MoveComp = Player.CharacterMovement or Player:GetMovementComponent()
  if IsValid(MoveComp) then
    DebugPrint("yly BP_RollerCoasterBase_C DisembarkLocalPlayer: 恢复重力与移动模式", self.SavedGravityScale)
    MoveComp.GravityScale = self.SavedGravityScale or 1.0
    MoveComp:SetMovementMode(EMovementMode.MOVE_Walking)
  end
  self.SavedGravityScale = nil
  Player:MoveAlongSplineUnBanSkills()
  Player:ForbidActionWhileMoveAlongSpline(false)
  self:SetGameplayHudHidden(false)
  if self:IsCameraTakenOverByOthers(Player) then
    self.PendingCameraExitPlayer = Player
    self.PendingCameraExitElapsed = 0.0
    self:SetActorTickEnabled(true)
    DebugPrint("yly BP_RollerCoasterBase_C DisembarkLocalPlayer: 外部仍在接管相机，延后恢复第三人称")
  else
    self:ExitFirstPerson(Player)
  end
  self:PlayerStandUp(Player)
  Player:SetActorHideTag("RollerCoaster", false)
  self.RidingPlayer = nil
  DebugPrint("yly BP_RollerCoasterBase_C DisembarkLocalPlayer: 玩家已下车")
end

return M
