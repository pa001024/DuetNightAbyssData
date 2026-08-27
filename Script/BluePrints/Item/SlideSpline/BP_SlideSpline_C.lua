local BP_SlideSpline_C = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})
local SLIDE_TURN_CAMERA_INPUT_TAG = "SlideSplineTurn"
local SLIDE_INTERACTIVE_FX_NAME = "Slide_Interactive_Icon"
local SLIDE_INTERACTIVE_FX_PATH = "/Game/Asset/Effect/Niagara/GamePlay/Railway/NS_Railway_Icon.NS_Railway_Icon"
local SLIDE_INTERACTIVE_FX_Z_OFFSET = -40
local SLIDE_INTERACTIVE_ARROW_FX_NAME = "Slide_Interactive_Arrow"
local SLIDE_INTERACTIVE_ARROW_FX_PATH = "/Game/Asset/Effect/Niagara/GamePlay/Railway/NS_Railway_jiantou.NS_Railway_jiantou"
local SLIDE_INTERACTIVE_ARROW_OFFSET = 100
local SLIDE_INTERACTIVE_ARROW_YAW_OFFSET = 90

function BP_SlideSpline_C:CommonInitInfo(Info)
  BP_SlideSpline_C.Super.CommonInitInfo(self, Info)
  self.Progress = 0.0
  self.Length = self.Spline:GetSplineLength()
  self.SpeedModify = self.SpeedModify or 1.0
  self.PassiveDeattachSpeedPer = self.PassiveDeattachSpeedPer or 1.5
  self.Speed = (DataMgr.MovementParams.Speed.ParamValue or 400.0) * self.SpeedModify
  self.ChangeCD = DataMgr.MovementParams.SideJumpAttachTime.ParamValue or 1.0
  self.bIsTurning = false
  self.bPostTurnRootAlign = false
  self.SlideSavedOrientToMove = nil
  self.SlideSavedAllowPhysicsRot = nil
  self.SlideSavedUseCtrlDesired = nil
  self.SlideSavedUseCtrlYaw = nil
  self.SlideSavedForbidOrient = nil
  self.bSlideCMCTickPrereq = false
  self.SwitchCurrentRotation = nil
  self.MoveDirection = 1
  self.TurnElapsed = 0.0
  self.TurnTime = DataMgr.MovementParams.TurnTime.ParamValue or 0.5
  if nil == self.MoveForward then
    self.MoveForward = true
  end
  self.AccTime = DataMgr.MovementParams.AccTime.ParamValue or 0.1
  self.CameraMinPitch = DataMgr.MovementParams.CameraMinPitch.ParamValue or 0
  self.CameraMaxPitch = DataMgr.MovementParams.CameraMaxPitch.ParamValue or 0
  self.CameraMinYaw = DataMgr.MovementParams.CameraMinYaw.ParamValue or 0
  self.CameraMaxYaw = DataMgr.MovementParams.CameraMaxYaw.ParamValue or 0
  local LockCameraOnTurnCfg = DataMgr.MovementParams.IsLockCamera
  self.IsLockCameraOnTurn = LockCameraOnTurnCfg and LockCameraOnTurnCfg.ParamValue or 0
  self.bTurnCameraLockActive = false
  self.bProximityPromptShowing = false
  self.bInteractiveIconFXShowing = false
  self.CachedEntryDistance = nil
  self.CachedEntryProgress = nil
  self.CachedPlayerDist = nil
  self.SmoothedEntryDistance = nil
  self.NearbyPlayer = nil
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState then
    GameState:AddSlideMech(self)
  end
end

function BP_SlideSpline_C:OnActorReady(Info)
  BP_SlideSpline_C.Super.OnActorReady(self, Info)
  if 0 ~= self.CurrentTypeStateId and IsAuthority(self) then
    self:ChangeState("Manual", 0, self.CurrentTypeStateId)
  end
  self.Widget:SetHiddenInGame(true)
  local Spheres = self:K2_GetComponentsByClass(UE4.USphereComponent)
  if Spheres then
    for i = 1, Spheres:Length() do
      local Sphere = Spheres[i]
      Sphere:SetCollisionProfileName("OnlyPlayer", true)
      Sphere:SetGenerateOverlapEvents(true)
      Sphere.OnComponentBeginOverlap:Add(self, self.OnSphereBeginOverlap)
      Sphere.OnComponentEndOverlap:Add(self, self.OnSphereEndOverlap)
    end
  end
  self:CheckInitialOverlap()
end

function BP_SlideSpline_C:ClearSlideTurnState()
  if not self.bIsTurning then
    return
  end
  self:RemoveTimer("SlideStartTurn")
  self.bIsTurning = false
  self.bTurnCameraLockActive = false
  self.bPostTurnRootAlign = false
  if IsValid(self.CurPlayer) then
    self.CurPlayer.InSlideMechTurning = false
    if self.CurPlayer.PlayerAnimInstance then
      self.CurPlayer.PlayerAnimInstance.InSlideMechTurn = false
    end
    local Controller = self.CurPlayer:GetController()
    if Controller and Controller.RemoveDisableRotationInputTag then
      Controller:RemoveDisableRotationInputTag("SlideSplineTurn")
    end
  end
end

function BP_SlideSpline_C:OnEnterState(NowStateId)
  if self.Overridden and self.Overridden.OnEnterState then
    self.Overridden.OnEnterState(self, NowStateId)
  end
  if not self.PlayerInSlide and not IsValid(self.CurPlayer) then
    return
  end
  self:ClearSlideTurnState()
  self:LeaveSlideMechanism(false)
end

function BP_SlideSpline_C:CheckInitialOverlap()
  if self.NearbyPlayer then
    return
  end
  local Spheres = self:K2_GetComponentsByClass(UE4.USphereComponent)
  if not Spheres then
    return
  end
  for i = 1, Spheres:Length() do
    local Actors = Spheres[i]:GetOverlappingActors()
    if Actors then
      for j = 1, Actors:Length() do
        local Actor = Actors[j]
        if IsValid(Actor) and Actor.IsPlayer and Actor:IsPlayer() then
          self.NearbyPlayer = Actor
          self:AddTimer(0.02, self.CheckProximity, true, 0, "ProximityCheck")
          return
        end
      end
    end
  end
end

function BP_SlideSpline_C:ReceiveTick(DeltaSeconds)
  self.Overridden.ReceiveTick(self, DeltaSeconds)
  if IsValid(self.CurPlayer) and self.PlayerInSlide then
    self:EnsureSlideCMCLocked(self.CurPlayer)
    if self.PlayerInSwitch then
      if self.SwitchCurrentRotation then
        self.CurPlayer:K2_SetActorRotation(self.SwitchCurrentRotation, false)
      end
      return
    end
    if self.bIsTurning then
      self:TickTurn(DeltaSeconds)
      if not self.bIsTurning then
        self:MoveWithSpline(0, self.CurPlayer, true)
      end
    else
      self.CurPlayer:UpdateSlideSpeedState(DeltaSeconds, self.Speed)
      self:MoveWithSpline(DeltaSeconds, self.CurPlayer)
    end
  end
end

function BP_SlideSpline_C:ChangeSlideMechanism_Lua(IsChangeLeft)
  if self.PlayerInSwitch then
    DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua skip - PlayerInSwitch")
    return
  end
  local Player = self.CurPlayer
  if not Player or not IsValid(Player) then
    Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  end
  if Player and Player.bSlideMechEnterMontagePlaying then
    DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua skip - enter montage playing")
    return
  end
  local direction = IsChangeLeft and -1 or 1
  local TrainDynamic = require("BluePrints.Item.Mechanism.BP_SplineTrain_Dynamic_C")
  if Player and IsValid(Player) then
    local ctrl = Player:GetController()
    if ctrl and ctrl.IsMoveInputIgnored and ctrl:IsMoveInputIgnored() and ctrl.ResetIgnoreMoveInput then
      DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua recover stuck IgnoreMoveInput")
      ctrl:ResetIgnoreMoveInput()
    end
  end
  DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua enter", "IsChangeLeft=", IsChangeLeft, "direction=", direction, "TrackIndex=", self.TrackIndex, "spline=", self.GetName and self:GetName() or "?", "Player=", Player and Player.GetName and Player:GetName() or "nil", "CurSlideMechEid=", Player and Player.CurSlideMechEid or "nil")
  if Player and IsValid(Player) then
    local plan = TrainDynamic.GetActiveDodgeSwitchPlan and TrainDynamic.GetActiveDodgeSwitchPlan(Player) or nil
    if plan then
      local allowed = direction < 0 and plan.canLeft or direction > 0 and plan.canRight
      if not allowed then
        DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua BLOCKED - dodge plan forbids", "direction=", direction, "canLeft=", plan.canLeft, "canRight=", plan.canRight)
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Track_NoEnter"), 1.5)
        return
      end
      if TrainDynamic.CheckObstacleForSwitch and TrainDynamic.CheckObstacleForSwitch(Player, direction, plan.train, plan.train, true, self) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Track_NoEnter"), 1.5)
        return
      end
      if plan.train and plan.train.OnDodgeSwitchTriggered then
        plan.train:OnDodgeSwitchTriggered()
      end
    else
      local refTrain = TrainDynamic.FindNearestTrain(Player)
      if TrainDynamic.CheckObstacleForSwitch(Player, direction, refTrain, nil, true, self) then
        DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua BLOCKED - obstacle (filtered)")
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Track_NoEnter"), 1.5)
        return
      end
    end
  end
  DebugPrint("[TrackDodge] ChangeSlideMechanism_Lua PASS - execute switch", "direction=", direction)
  if IsChangeLeft then
    self:OnChangeLeft()
  else
    self:OnChangeRight()
  end
  if TrainDynamic.ClearAllDodgePrompts then
    TrainDynamic.ClearAllDodgePrompts(Player)
  end
end

function BP_SlideSpline_C:LeaveSlideMechanism_Lua(IsPassive)
  if self.CurPlayer and not self:IsExistTimer("SlideLaunchPlayer") then
    if self.bIsTurning then
      return
    end
    self:RemoveTimer("MovePlayer")
    self.PlayerInSwitch = false
    self.SwitchCurrentRotation = nil
    local Distance = self.Progress * self.Length
    local Tangent = self.Spline:GetDirectionAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    Tangent:Normalize()
    local ActiveDeattachSpeedPer = DataMgr.MovementParams.ActiveDeattachSpeedPer.ParamValue or 1.0
    local SpeedPer, PitchAngle
    if IsPassive then
      SpeedPer = self.PassiveDeattachSpeedPer
      PitchAngle = self.PassiveDeattachSpeedAngel
      self:EndSlideSplineMove(true)
    else
      SpeedPer = ActiveDeattachSpeedPer
      PitchAngle = self.ActiveDeattachSpeedAngel
      self:EndSlideSplineMove(false)
    end
    local BaseVelocity = Tangent * self.Speed * SpeedPer * self.MoveDirection
    local Right = self.CurPlayer:GetActorRightVector()
    local FinalVelocity = UKismetMathLibrary.RotateAngleAxis(BaseVelocity, -PitchAngle, Right)
    AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/scene/ex02/rail_jumppad")
    self.CurPlayer:ChangeBackToHeroSlideMech()
    self:AddTimer(0.01, function()
      if not IsValid(self.CurPlayer) then
        return
      end
      self.CurPlayer.CharacterMovement:SetMovementMode(UE4.EMovementMode.MOVE_Falling)
      self.CurPlayer:LaunchCharacter(FinalVelocity, true, true)
      self:RestoreSlideCMCProperties(self.CurPlayer)
      if self.CurPlayer.Mesh then
        self:RemoveTickPrerequisiteComponent(self.CurPlayer.Mesh)
      end
      self.bPostTurnRootAlign = false
      self.CurPlayer = nil
      self.PlayerInSlide = false
      self.CanChange = false
      self.MoveDirection = 1
      self:OnEndLeave()
      self:CheckInitialOverlap()
    end, false, 0, "SlideLaunchPlayer")
    self:AddTimer(self.ChangeCD, function()
      self.CanChange = true
    end, false, 0)
  end
end

function BP_SlideSpline_C:ForceReleaseForFlow(bForceDead)
  local Player = self.CurPlayer
  self:RemoveTimer("SlideLaunchPlayer")
  self:RemoveTimer("MovePlayer")
  self:RemoveTimer("SlideStartTurn")
  self.PlayerInSwitch = false
  self.SwitchCurrentRotation = nil
  self.bIsTurning = false
  if IsValid(Player) then
    self:EndSlideSplineMove(true)
    AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/scene/ex02/rail_jumppad")
    Player:ChangeBackToHeroSlideMech(bForceDead)
    if Player.RestoreSlideMechFlyCollision then
      Player:RestoreSlideMechFlyCollision()
    end
    if Player.Mesh then
      self:RemoveTickPrerequisiteComponent(Player.Mesh)
    end
    self:RestoreSlideCMCProperties(Player)
    if Player.CharacterMovement then
      Player.CharacterMovement:SetMovementMode(UE4.EMovementMode.MOVE_Falling)
    end
  end
  self.CurPlayer = nil
  self.PlayerInSlide = false
  self.PlayerInSwitch = false
  self.bIsTurning = false
  self.bTurnCameraLockActive = false
  self.bPostTurnRootAlign = false
  self.TurnStartRootLocalYaw = nil
  self.MoveDirection = 1
  self.CachedEntryDistance = nil
  self.CachedEntryProgress = nil
  self.CachedEntryMoveDirection = nil
  self.CachedPlayerForward = nil
  self:OnEndLeave()
  self:CheckInitialOverlap()
end

function BP_SlideSpline_C:GetCameraBaseRotation(Rotation)
  return FRotator(math.clamp(UKismetMathLibrary.NormalizeAxis(Rotation.Pitch), -89.9, 89.9), UKismetMathLibrary.NormalizeAxis(Rotation.Yaw), 0)
end

function BP_SlideSpline_C:ApplyLockedCameraLimits(Player, BaseRotation)
  local Controller = Player:GetController()
  local CameraManager = Controller and Controller.PlayerCameraManager
  if not CameraManager then
    return
  end
  local MinPitchOffset = math.min(self.CameraMinPitch, self.CameraMaxPitch)
  local MaxPitchOffset = math.max(self.CameraMinPitch, self.CameraMaxPitch)
  local MinYawOffset = math.min(self.CameraMinYaw, self.CameraMaxYaw)
  local MaxYawOffset = math.max(self.CameraMinYaw, self.CameraMaxYaw)
  CameraManager.ViewPitchMin = math.max(BaseRotation.Pitch + MinPitchOffset, -89.9)
  CameraManager.ViewPitchMax = math.min(BaseRotation.Pitch + MaxPitchOffset, 89.9)
  CameraManager.ViewYawMin = BaseRotation.Yaw + MinYawOffset
  CameraManager.ViewYawMax = BaseRotation.Yaw + MaxYawOffset
end

function BP_SlideSpline_C:UpdateLockedCamera(Rotation)
  if not self.CurPlayer then
    return
  end
  if not self.LockCamera then
    if self.PlayerInSwitch then
      return
    end
    if self.CurPlayer.SlideCameraActive then
      self.CurPlayer:RestoreSlideCameraState()
    end
    return
  end
  local Player = self.CurPlayer
  local Controller = Player:GetController()
  local CameraManager = Controller and Controller.PlayerCameraManager
  if not Controller or not CameraManager then
    return
  end
  local NewBaseRotation = self:GetCameraBaseRotation(Rotation)
  if not Player.SlideCameraActive then
    if self.PlayerInSwitch then
      return
    end
    Player.SlideCameraActive = true
    Player.SlideCameraBaseRotation = NewBaseRotation
    Player.SlideCameraOriginalViewYawMin = CameraManager.ViewYawMin
    Player.SlideCameraOriginalViewYawMax = CameraManager.ViewYawMax
    Player.SlideCameraOriginalViewPitchMin = CameraManager.ViewPitchMin
    Player.SlideCameraOriginalViewPitchMax = CameraManager.ViewPitchMax
    Player.SlideCameraLerping = true
    Player.CameraRotationComponent:SetControlRotationAbsolute_Lerp(NewBaseRotation, 0.5, 20, false, function()
      if IsValid(Player) and Player.SlideCameraActive then
        Player.SlideCameraLerping = false
      end
    end)
    return
  end
  local OldBaseRotation = Player.SlideCameraBaseRotation or NewBaseRotation
  Player.SlideCameraBaseRotation = NewBaseRotation
  if Player.SlideCameraLerping then
    return
  end
  self:ApplyLockedCameraLimits(Player, NewBaseRotation)
  local ControlRotation = Controller:GetControlRotation()
  local Pitch = ControlRotation.Pitch + UKismetMathLibrary.NormalizeAxis(NewBaseRotation.Pitch - OldBaseRotation.Pitch)
  local Yaw = ControlRotation.Yaw + UKismetMathLibrary.NormalizeAxis(NewBaseRotation.Yaw - OldBaseRotation.Yaw)
  local RelativePitch = UKismetMathLibrary.NormalizeAxis(Pitch - NewBaseRotation.Pitch)
  local RelativeYaw = UKismetMathLibrary.NormalizeAxis(Yaw - NewBaseRotation.Yaw)
  Pitch = NewBaseRotation.Pitch + math.clamp(RelativePitch, math.min(self.CameraMinPitch, self.CameraMaxPitch), math.max(self.CameraMinPitch, self.CameraMaxPitch))
  Yaw = NewBaseRotation.Yaw + math.clamp(RelativeYaw, math.min(self.CameraMinYaw, self.CameraMaxYaw), math.max(self.CameraMinYaw, self.CameraMaxYaw))
  Controller:SetControlRotation(FRotator(math.clamp(Pitch, -89.9, 89.9), Yaw, 0))
end

function BP_SlideSpline_C:IsTurnCameraLockOn()
  if self.LockCamera then
    return true
  end
  if 1 == self.IsLockCameraOnTurn then
    return true
  end
  return false
end

function BP_SlideSpline_C:GetAdjustLocation(Location, Player, Distance)
  local CapsuleComp = Player.CapsuleComponent
  local CapsuleHalfHeight = CapsuleComp:GetScaledCapsuleHalfHeight()
  local ExtraHeight = self.AddHeight or 0
  local Offset = CapsuleHalfHeight + ExtraHeight
  if Distance then
    local UpVector = self.Spline:GetUpVectorAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    return FVector(Location.X + UpVector.X * Offset, Location.Y + UpVector.Y * Offset, Location.Z + UpVector.Z * Offset)
  end
  return FVector(Location.X, Location.Y, Location.Z + Offset)
end

function BP_SlideSpline_C:MoveWithSpline(DeltaSeconds, Player, OnlyAlign)
  local MoveDistance = (Player.SlideCurrentSpeed or self.Speed) * DeltaSeconds * self.MoveDirection
  self.Progress = self.Progress + MoveDistance / self.Length
  if not OnlyAlign then
    if self.Progress >= 1.0 and 1 == self.MoveDirection then
      self:LeaveSlideMechanism(true)
      self.Progress = 1.0
      return
    elseif self.Progress <= 0.0 and -1 == self.MoveDirection then
      self:LeaveSlideMechanism(true)
      self.Progress = 0.0
      return
    elseif self.Progress < 0.0 then
      self.Progress = 0.0
    end
  end
  local Distance = self.Progress * self.Length
  local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  NewLocation = self:GetAdjustLocation(NewLocation, Player, Distance)
  local NewRotation = self:ApplySlideMoveDirection(self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World), self.MoveDirection)
  Player:K2_SetActorLocation(NewLocation, false, nil, false)
  local CameraFacing = NewRotation
  local ActorRotation = NewRotation
  if self.bPostTurnRootAlign then
    local RootLocal = self:GetRootLocalYaw(Player)
    ActorRotation = UE4.FRotator(NewRotation.Pitch, NewRotation.Yaw - RootLocal, NewRotation.Roll)
    if math.abs(RootLocal) < 1.0 then
      self.bPostTurnRootAlign = false
      if Player.Mesh then
        self:RemoveTickPrerequisiteComponent(Player.Mesh)
      end
    end
  end
  Player:K2_SetActorRotation(ActorRotation, false)
  self:UpdateLockedCamera(CameraFacing)
end

function BP_SlideSpline_C:GetAimLocation(DeltaSeconds, Player)
  local MoveDistance = (Player.SlideCurrentSpeed or self.Speed) * DeltaSeconds * self.MoveDirection
  self.TargetProgress = self.Progress + MoveDistance / self.Length
  if self.TargetProgress >= 1.0 then
    self.TargetProgress = 1.0
  elseif self.TargetProgress < 0.0 then
    self.TargetProgress = 0.0
  end
  local Distance = self.TargetProgress * self.Length
  local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  NewLocation = self:GetAdjustLocation(NewLocation, Player, Distance)
  local NewRotation = self:ApplySlideMoveDirection(self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World), self.MoveDirection)
  return NewLocation, NewRotation
end

function BP_SlideSpline_C:MovePlayerSmooth()
  if not self.CurPlayer then
    return
  end
  self.CurPlayer.IsSwitchingSlideMech = true
  if self.CurPlayer.PlayerAnimInstance then
    self.CurPlayer.PlayerAnimInstance.IsSwitchingSlideMech = true
  end
  self.SwitchBeginLocation = self.CurPlayer:K2_GetActorLocation()
  self.SwitchBeginRotation = self.CurPlayer:K2_GetActorRotation()
  self.SwitchCurrentRotation = self.SwitchBeginRotation
  self.SwitchBeginProgress = self.Progress
  self.CurPlayer:PauseSlideBuffDecay()
  self.SwitchTargetLocation, self.SwitchTargetRotation = self:GetAimLocation(self.ChangeCD, self.CurPlayer)
  self.CurSwitchDeltaNum = 0
  self.SwitchDeltaTotalNum = self.ChangeCD / 0.01
  self:AddTimer(0.01, self.MovePlayer, true, -0.01, "MovePlayer")
end

function BP_SlideSpline_C:CalcCurLocation()
  local BeginDist = self.Progress * self.Length
  local BeginLoc = self.Spline:GetLocationAtDistanceAlongSpline(BeginDist, ESplineCoordinateSpace.World)
  BeginLoc = self:GetAdjustLocation(BeginLoc, self.CurPlayer, BeginDist)
  return BeginLoc
end

function BP_SlideSpline_C:MovePlayer()
  local Player = self.CurPlayer
  if not IsValid(Player) or not Player.SlideSpeedStateActive then
    self:RemoveTimer("MovePlayer")
    self.PlayerInSwitch = false
    if IsValid(Player) then
      Player.IsSwitchingSlideMech = false
      if Player.PlayerAnimInstance then
        Player.PlayerAnimInstance.IsSwitchingSlideMech = false
      end
    end
    return
  end
  self.CurSwitchDeltaNum = self.CurSwitchDeltaNum + 1
  self:EnsureSlideCMCLocked(Player)
  local Alpha = self.CurSwitchDeltaNum / self.SwitchDeltaTotalNum
  if Alpha > 1.0 then
    Alpha = 1.0
  end
  Player:UpdateSlideSpeedState(0.01, self.Speed)
  local SmoothAlpha = UKismetMathLibrary.Ease(0.0, 1.0, Alpha, EEasingFunc.EaseInOut)
  local NewLocation = UKismetMathLibrary.VLerp(self.SwitchBeginLocation, self.SwitchTargetLocation, SmoothAlpha)
  local NewRotation = UKismetMathLibrary.RLerp(self.SwitchBeginRotation, self.SwitchTargetRotation, SmoothAlpha, true)
  self.SwitchCurrentRotation = NewRotation
  self.Progress = self.SwitchBeginProgress + (self.TargetProgress - self.SwitchBeginProgress) * Alpha
  Player:K2_SetActorLocation(NewLocation, false, nil, false)
  Player:K2_SetActorRotation(NewRotation, false)
  local bYawChanged = math.abs(UKismetMathLibrary.NormalizeAxis(self.SwitchTargetRotation.Yaw - self.SwitchBeginRotation.Yaw)) > 0.1
  if bYawChanged then
    self:UpdateLockedCamera(UE4.FRotator(0, NewRotation.Yaw, 0))
  end
  if self.CurSwitchDeltaNum >= self.SwitchDeltaTotalNum then
    self:RemoveTimer("MovePlayer")
    self.Progress = self.TargetProgress
    self.PlayerInSwitch = false
    self.SwitchCurrentRotation = nil
    Player:ResumeSlideBuffDecay()
    self:BeginSlideSplineMove(false)
    Player.IsSwitchingSlideMech = false
    if Player.PlayerAnimInstance then
      Player.PlayerAnimInstance.IsSwitchingSlideMech = false
    end
    self:UpdateLockedCamera(self:GetSlideFacingRotation())
    EventManager:FireEvent(EventID.OnSlideMechSwitchSuccess, Player, self.Eid or 0, self.TrackIndex or 0)
  end
end

function BP_SlideSpline_C:GetConfiguredMoveDirection()
  return self.MoveForward == false and -1 or 1
end

function BP_SlideSpline_C:RequestTurn()
  if not self.AllowTurn then
    return
  end
  if self.bIsTurning then
    return
  end
  if not self.CurPlayer or not self.PlayerInSlide then
    return
  end
  if self.PlayerInSwitch then
    return
  end
  if self.CurPlayer.InSlideMechJump then
    return
  end
  if self.CurPlayer.CurrentSkillId and self.CurPlayer.CurrentSkillId > 0 then
    self.CurPlayer:StopSkill(UE.ESkillStopReason.JumpCancel)
  end
  self.bIsTurning = true
  self.TurnElapsed = 0.0
  local Facing = self:GetSlideFacingRotation()
  self.CurPlayer:K2_SetActorRotation(Facing, false)
  self.TurnStartActorRotation = FRotator(Facing.Pitch, Facing.Yaw, Facing.Roll)
  self.TurnStartRootLocalYaw = self:GetRootLocalYaw(self.CurPlayer)
  self.TurnHeldDeltaYaw = nil
  self.CurPlayer.InSlideMechTurning = true
  if self.CurPlayer.PlayerAnimInstance then
    self.CurPlayer.PlayerAnimInstance.InSlideMechTurn = true
  end
  if self.CurPlayer.InSlideMechSlide then
    self.CurPlayer:OnSlideMechSlideEnd()
  end
  self.CurPlayer.CharacterMovement:SetMovementMode(UE4.EMovementMode.MOVE_Walking)
  self:AddTimer(0.01, self.StartTurn, false, 0, "SlideStartTurn")
end

function BP_SlideSpline_C:StartTurn()
  self.TurnElapsed = 0.0
  self.bTurnCameraLockActive = self:IsTurnCameraLockOn()
  self.CurPlayer:PauseSlideSpeedForTurn()
  if self.CurPlayer.Mesh then
    self:AddTickPrerequisiteComponent(self.CurPlayer.Mesh)
  end
  if self.TurnStartActorRotation == nil then
    self.TurnStartActorRotation = self.CurPlayer:K2_GetActorRotation()
  end
  if nil == self.TurnStartRootLocalYaw then
    self.TurnStartRootLocalYaw = self:GetRootLocalYaw(self.CurPlayer)
  end
  if self.bTurnCameraLockActive then
    local Controller = self.CurPlayer:GetController()
    if Controller then
      self.TurnStartControlRotation = Controller:GetControlRotation()
      Controller:AddDisableRotationInputTag(SLIDE_TURN_CAMERA_INPUT_TAG)
    end
  end
end

function BP_SlideSpline_C:ApplySlideMoveDirection(SplineRotation, MoveDirection)
  if (MoveDirection or 1) < 0 then
    return UKismetMathLibrary.ComposeRotators(UE4.FRotator(0, 180.0, 0), SplineRotation)
  end
  return SplineRotation
end

function BP_SlideSpline_C:GetSlideFacingRotation()
  local Distance = self.Progress * self.Length
  return self:ApplySlideMoveDirection(self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World), self.MoveDirection)
end

function BP_SlideSpline_C:TickTurn(DeltaSeconds)
  self.TurnElapsed = self.TurnElapsed + DeltaSeconds
  local RawDeltaYaw = 0
  local RootLocalYaw = 0
  if IsValid(self.CurPlayer) and self.CurPlayer.Mesh and self.TurnStartRootLocalYaw ~= nil then
    local RootTransform = self.CurPlayer.Mesh:GetSocketTransform("Root", UE4.ERelativeTransformSpace.RTS_Component)
    RootLocalYaw = RootTransform.Rotation:ToRotator().Yaw
    RawDeltaYaw = UKismetMathLibrary.NormalizeAxis(RootLocalYaw - self.TurnStartRootLocalYaw)
  end
  local Held = self.TurnHeldDeltaYaw
  if nil == Held or math.abs(RawDeltaYaw) >= math.abs(Held) then
    self.TurnHeldDeltaYaw = RawDeltaYaw
    Held = RawDeltaYaw
  end
  local bRootUnwinding = nil ~= Held and math.abs(Held) > 90.0 and math.abs(RawDeltaYaw) < math.abs(Held)
  if self.TurnStartActorRotation then
    if bRootUnwinding then
      local CompYaw = self.TurnStartActorRotation.Yaw + UKismetMathLibrary.NormalizeAxis(Held - RawDeltaYaw)
      self.CurPlayer:K2_SetActorRotation(FRotator(self.TurnStartActorRotation.Pitch, CompYaw, self.TurnStartActorRotation.Roll), false)
    else
      self.CurPlayer:K2_SetActorRotation(self.TurnStartActorRotation, false)
    end
  end
  if self.bTurnCameraLockActive and self.TurnStartControlRotation and IsValid(self.CurPlayer) then
    local Controller = self.CurPlayer:GetController()
    if Controller then
      local CamDeltaYaw = bRootUnwinding and Held or RawDeltaYaw
      Controller:SetControlRotation(FRotator(self.TurnStartControlRotation.Pitch, self.TurnStartControlRotation.Yaw + CamDeltaYaw, 0))
    end
  end
  if self.TurnElapsed >= self.TurnTime then
    self:EndTurn()
  end
end

function BP_SlideSpline_C:EndTurn()
  self.bIsTurning = false
  local Controller = self.CurPlayer:GetController()
  if Controller then
    Controller:RemoveDisableRotationInputTag(SLIDE_TURN_CAMERA_INPUT_TAG)
  end
  self.bTurnCameraLockActive = false
  self.TurnStartControlRotation = nil
  self.TurnHeldDeltaYaw = nil
  self.TurnStartActorRotation = nil
  self.TurnStartRootLocalYaw = nil
  self.MoveDirection = -self.MoveDirection
  local NewFacing = self:GetSlideFacingRotation()
  local RootLocal = self:GetRootLocalYaw(self.CurPlayer)
  local AlignYaw = UKismetMathLibrary.NormalizeAxis(NewFacing.Yaw - RootLocal)
  self.CurPlayer:K2_SetActorRotation(UE4.FRotator(NewFacing.Pitch, AlignYaw, NewFacing.Roll), false)
  self.bPostTurnRootAlign = true
  if self.CurPlayer.Mesh then
    self:AddTickPrerequisiteComponent(self.CurPlayer.Mesh)
  end
  if self.CurPlayer.SlideCameraActive then
    local NewBase = self:GetCameraBaseRotation(NewFacing)
    self.CurPlayer.SlideCameraBaseRotation = NewBase
    self:ApplyLockedCameraLimits(self.CurPlayer, NewBase)
  end
  if self.CurPlayer.PlayerAnimInstance then
    self.CurPlayer.InSlideMechTurning = false
    self.CurPlayer.PlayerAnimInstance.InSlideMechTurn = false
  end
  if self.CurPlayer.CharacterMovement then
    self.CurPlayer.CharacterMovement:SetMovementMode(UE4.EMovementMode.MOVE_Flying)
  end
  self.CurPlayer:ResumeSlideSpeedAfterTurn(self.Speed)
end

function BP_SlideSpline_C:EnsureSlideCMCLocked(Player)
  if not IsValid(Player) then
    return
  end
  if self.SlideSavedForbidOrient == nil then
    self.SlideSavedForbidOrient = Player.ForbidOrient
  end
  if not Player.ForbidOrient then
    Player.ForbidOrient = true
    if Player.ChangeOrientControll then
      Player:ChangeOrientControll()
    end
  end
  local Move = Player.CharacterMovement
  if Move then
    if nil == self.SlideSavedOrientToMove then
      self.SlideSavedOrientToMove = Move.bOrientRotationToMovement
      self.SlideSavedAllowPhysicsRot = Move.bAllowPhysicsRotationDuringAnimRootMotion
      self.SlideSavedUseCtrlDesired = Move.bUseControllerDesiredRotation
    end
    Move.bOrientRotationToMovement = false
    Move.bAllowPhysicsRotationDuringAnimRootMotion = false
    Move.bUseControllerDesiredRotation = false
    if not self.bSlideCMCTickPrereq then
      self:AddTickPrerequisiteComponent(Move)
      self.bSlideCMCTickPrereq = true
    end
  end
  if nil == self.SlideSavedUseCtrlYaw then
    self.SlideSavedUseCtrlYaw = Player.bUseControllerRotationYaw
  end
  Player.bUseControllerRotationYaw = false
end

function BP_SlideSpline_C:RestoreSlideCMCProperties(Player)
  if not IsValid(Player) then
    return
  end
  if Player.CharacterMovement then
    if self.bSlideCMCTickPrereq then
      self:RemoveTickPrerequisiteComponent(Player.CharacterMovement)
      self.bSlideCMCTickPrereq = false
    end
    if self.SlideSavedOrientToMove ~= nil then
      Player.CharacterMovement.bOrientRotationToMovement = self.SlideSavedOrientToMove
      self.SlideSavedOrientToMove = nil
    end
    if nil ~= self.SlideSavedAllowPhysicsRot then
      Player.CharacterMovement.bAllowPhysicsRotationDuringAnimRootMotion = self.SlideSavedAllowPhysicsRot
      self.SlideSavedAllowPhysicsRot = nil
    end
    if nil ~= self.SlideSavedUseCtrlDesired then
      Player.CharacterMovement.bUseControllerDesiredRotation = self.SlideSavedUseCtrlDesired
      self.SlideSavedUseCtrlDesired = nil
    end
  end
  if nil ~= self.SlideSavedUseCtrlYaw then
    Player.bUseControllerRotationYaw = self.SlideSavedUseCtrlYaw
    self.SlideSavedUseCtrlYaw = nil
  end
  if nil ~= self.SlideSavedForbidOrient then
    Player.ForbidOrient = self.SlideSavedForbidOrient
    self.SlideSavedForbidOrient = nil
    if Player.ChangeOrientControll then
      Player:ChangeOrientControll()
    end
  end
  self.SwitchCurrentRotation = nil
end

function BP_SlideSpline_C:GetRootLocalYaw(Player)
  if not IsValid(Player) or not Player.Mesh then
    return 0
  end
  local RootTransform = Player.Mesh:GetSocketTransform("Root", UE4.ERelativeTransformSpace.RTS_Component)
  return RootTransform.Rotation:ToRotator().Yaw
end

function BP_SlideSpline_C:GetTurnAnimDuration(MachineName)
  if not self.CurPlayer then
    return
  end
  return self.CurPlayer:GetSlideMechTurnAimDuration(MachineName, "T")
end

function BP_SlideSpline_C:OnSphereBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    return
  end
  if self.PlayerInSlide then
    return
  end
  if self.NearbyPlayer then
    return
  end
  self.NearbyPlayer = OtherActor
  self:AddTimer(0.02, self.CheckProximity, true, 0, "ProximityCheck")
end

function BP_SlideSpline_C:OnSphereEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    return
  end
  if self.PlayerInSlide then
    return
  end
  if OtherActor.IsFlyingToSlideMech then
    return
  end
  if self:IsPlayerInAnySphere(OtherActor) then
    return
  end
  self:StopProximityCheck()
end

function BP_SlideSpline_C:IsPlayerInAnySphere(Player)
  local Spheres = self:K2_GetComponentsByClass(UE4.USphereComponent)
  if not Spheres then
    return false
  end
  for i = 1, Spheres:Length() do
    if Spheres[i]:IsOverlappingActor(Player) then
      return true
    end
  end
  return false
end

function BP_SlideSpline_C:CheckProximity()
  if not IsValid(self.NearbyPlayer) then
    self:StopProximityCheck()
    return
  end
  if self.PlayerInSlide or self.NearbyPlayer.IsFlyingToSlideMech or self.NearbyPlayer.IsInSlideMech then
    self:HideSlidePrompt()
    return
  end
  if self.CanInteractive == false then
    self:ClearProximityCache()
    self:HideSlidePrompt()
    return
  end
  local Controller = self.NearbyPlayer:GetController()
  if not Controller then
    self:ClearProximityCache()
    self:HideSlidePrompt()
    return
  end
  local PlayerLoc = self.NearbyPlayer:K2_GetActorLocation()
  local ControlRotation = Controller:GetControlRotation()
  local CamForward = UE4.UKismetMathLibrary.GetForwardVector(ControlRotation)
  local InteractDist = DataMgr.MovementParams.CanInteractiveDis.ParamValue or 500
  local InteractAngle = DataMgr.MovementParams.CanInteractiveAngle.ParamValue or 90
  local NearKey = self.Spline:FindInputKeyClosestToWorldLocation(PlayerLoc)
  local NearSplineDist = self.Spline:GetDistanceAlongSplineAtSplineInputKey(NearKey)
  local NearLoc = self.Spline:GetLocationAtDistanceAlongSpline(NearSplineDist, ESplineCoordinateSpace.World)
  local PerpDist = (NearLoc - PlayerLoc):Size()
  if InteractDist < PerpDist then
    self:ClearProximityCache()
    self:HideSlidePrompt()
    return
  end
  local ViewTarget = PlayerLoc + FVector(CamForward.X * PerpDist, CamForward.Y * PerpDist, CamForward.Z * PerpDist)
  local ViewKey = self.Spline:FindInputKeyClosestToWorldLocation(ViewTarget)
  local ViewSplineDist = self.Spline:GetDistanceAlongSplineAtSplineInputKey(ViewKey)
  local ViewLoc = self.Spline:GetLocationAtDistanceAlongSpline(ViewSplineDist, ESplineCoordinateSpace.World)
  local Dist = (ViewLoc - PlayerLoc):Size()
  if InteractDist < Dist then
    self:ClearProximityCache()
    self:HideSlidePrompt()
    return
  end
  local DirToSpline = ViewLoc - PlayerLoc
  DirToSpline:Normalize()
  local AngleDeg = math.deg(math.acos(math.clamp(CamForward:Dot(DirToSpline), -1, 1)))
  if InteractAngle < AngleDeg then
    self:ClearProximityCache()
    self:HideSlidePrompt()
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState then
    local SlideMechMap = GameState.SlideMechanismMap:ToTable()
    for _, OtherMech in pairs(SlideMechMap) do
      if IsValid(OtherMech) and OtherMech ~= self and OtherMech.bProximityPromptShowing then
        if OtherMech.CachedPlayerDist and Dist >= OtherMech.CachedPlayerDist then
          self:ClearProximityCache()
          self:HideSlidePrompt()
          return
        else
          OtherMech:ClearProximityCache()
          OtherMech:HideSlidePrompt()
        end
      end
    end
  end
  local SmoothAlpha = 0.35
  local SmoothedDist = ViewSplineDist
  if self.SmoothedEntryDistance then
    SmoothedDist = self.SmoothedEntryDistance + (ViewSplineDist - self.SmoothedEntryDistance) * SmoothAlpha
  end
  self.SmoothedEntryDistance = SmoothedDist
  local SmoothedLoc = self.Spline:GetLocationAtDistanceAlongSpline(SmoothedDist, ESplineCoordinateSpace.World)
  self.CachedPlayerDist = Dist
  self.CachedEntryDistance = SmoothedDist
  self.CachedEntryProgress = SmoothedDist / self.Length
  self:ShowSlidePrompt(SmoothedLoc)
end

function BP_SlideSpline_C:ClearProximityCache()
  self.CachedEntryDistance = nil
  self.CachedEntryProgress = nil
  self.CachedPlayerDist = nil
  self.SmoothedEntryDistance = nil
end

function BP_SlideSpline_C:ShowSlidePrompt(Location)
  local PromptWorldLoc = Location + FVector(0, 0, 100)
  self:UpdateInteractiveIconFX(Location, self.CachedEntryDistance)
  if not self.bProximityPromptShowing then
    self.bProximityPromptShowing = true
    self:OpenSlidePromptUI(PromptWorldLoc)
    return
  end
  self:UpdateSlidePromptUI(PromptWorldLoc)
end

function BP_SlideSpline_C:HideSlidePrompt()
  if not self.bProximityPromptShowing then
    self:HideInteractiveIconFX()
    return
  end
  self.bProximityPromptShowing = false
  self:HideInteractiveIconFX()
  self:CloseSlidePromptUI()
end

function BP_SlideSpline_C:GetPreviewMoveDirection(Distance)
  if self.AllowTurn == false then
    return self:GetConfiguredMoveDirection()
  end
  if not IsValid(self.NearbyPlayer) or not IsValid(self.Spline) then
    return self:GetConfiguredMoveDirection()
  end
  local Forward
  local Controller = self.NearbyPlayer:GetController()
  if Controller then
    Forward = UKismetMathLibrary.GetForwardVector(Controller:GetControlRotation())
  else
    Forward = self.NearbyPlayer:GetActorForwardVector()
  end
  local Tangent = self.Spline:GetDirectionAtDistanceAlongSpline(Distance or 0, ESplineCoordinateSpace.World)
  return Forward:Dot(Tangent) >= 0 and 1 or -1
end

function BP_SlideSpline_C:GetPreviewSlideFacingRotation(Distance, MoveDir)
  return self:ApplySlideMoveDirection(self.Spline:GetRotationAtDistanceAlongSpline(Distance or 0, ESplineCoordinateSpace.World), MoveDir)
end

function BP_SlideSpline_C:CalcInteractiveFXTransforms(EntryLoc, Distance)
  local IconLoc = EntryLoc
  if IsValid(self.NearbyPlayer) then
    IconLoc = self:GetAdjustLocation(EntryLoc, self.NearbyPlayer, Distance)
  elseif self.GetClosedTransformInSpline then
    IconLoc = self:GetClosedTransformInSpline(EntryLoc)
  end
  IconLoc = IconLoc + FVector(0, 0, SLIDE_INTERACTIVE_FX_Z_OFFSET)
  local MoveDir = self:GetPreviewMoveDirection(Distance)
  local Dist = Distance or 0
  local MoveVec = self.Spline:GetDirectionAtDistanceAlongSpline(Dist, ESplineCoordinateSpace.World)
  MoveVec:Normalize()
  if MoveDir < 0 then
    MoveVec = MoveVec * -1
  end
  local FlatMove = FVector(MoveVec.X, MoveVec.Y, 0)
  if FlatMove:SizeSquared() > 1.0E-4 then
    FlatMove:Normalize()
  else
    FlatMove = MoveVec
  end
  local Facing = UKismetMathLibrary.MakeRotFromX(FlatMove)
  local ArrowLoc = IconLoc + FlatMove * SLIDE_INTERACTIVE_ARROW_OFFSET
  local ArrowFacing = Facing
  if 0 ~= SLIDE_INTERACTIVE_ARROW_YAW_OFFSET then
    ArrowFacing = UKismetMathLibrary.ComposeRotators(UE4.FRotator(0, SLIDE_INTERACTIVE_ARROW_YAW_OFFSET, 0), Facing)
  end
  return IconLoc, Facing, ArrowLoc, ArrowFacing
end

function BP_SlideSpline_C:SetLevelFXWorldTransform(Name, Loc, Rot)
  local FX = self.FXComponent:GetFXByName_LevelInner(Name, nil)
  if IsValid(FX) then
    FX:K2_SetWorldLocationAndRotation(Loc, Rot, false, nil, false)
    return
  end
  self.FXComponent:SetFXRotation_Level(Name, Rot)
end

function BP_SlideSpline_C:UpdateInteractiveIconFX(EntryLoc, Distance)
  if not IsValid(self.FXComponent) then
    return
  end
  local IconLoc, Facing, ArrowLoc, ArrowFacing = self:CalcInteractiveFXTransforms(EntryLoc, Distance)
  if not self.bInteractiveIconFXShowing then
    self.bInteractiveIconFXShowing = true
    self.FXComponent:SpawnFXAtLocation_Level(SLIDE_INTERACTIVE_FX_PATH, SLIDE_INTERACTIVE_FX_NAME, IconLoc, Facing, FVector(1, 1, 1), false)
    self.FXComponent:SpawnFXAtLocation_Level(SLIDE_INTERACTIVE_ARROW_FX_PATH, SLIDE_INTERACTIVE_ARROW_FX_NAME, ArrowLoc, ArrowFacing, FVector(1, 1, 1), false)
    return
  end
  self:SetLevelFXWorldTransform(SLIDE_INTERACTIVE_FX_NAME, IconLoc, Facing)
  self:SetLevelFXWorldTransform(SLIDE_INTERACTIVE_ARROW_FX_NAME, ArrowLoc, ArrowFacing)
end

function BP_SlideSpline_C:HideInteractiveIconFX()
  if not self.bInteractiveIconFXShowing then
    return
  end
  self.bInteractiveIconFXShowing = false
  if IsValid(self.FXComponent) then
    self.FXComponent:StopFX_Level(SLIDE_INTERACTIVE_FX_NAME)
    self.FXComponent:StopFX_Level(SLIDE_INTERACTIVE_ARROW_FX_NAME)
  end
end

function BP_SlideSpline_C:IsSlidePromptUseSystemUI()
  return CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
end

function BP_SlideSpline_C:OpenSlidePromptUI(PromptWorldLoc)
  if not self:IsSlidePromptUseSystemUI() then
    self.Widget:SetHiddenInGame(true)
    EventManager:FireEvent(EventID.OnMobileSlideSplineShow, self, self.NearbyPlayer)
    return
  end
  self.Widget:SetHiddenInGame(true)
  if not IsValid(self.SlideInteractiveUI) then
    self.SlideInteractiveUI = UIManager(self):GetUIObj("SlideSplineInteractive")
    if not IsValid(self.SlideInteractiveUI) then
      self.SlideInteractiveUI = UIManager(self):LoadUINew("SlideSplineInteractive")
      if IsValid(self.SlideInteractiveUI) then
        self.SlideInteractiveUI:Init()
      end
    end
  end
  self:UpdateSlidePromptUI(PromptWorldLoc)
end

function BP_SlideSpline_C:UpdateSlidePromptUI(PromptWorldLoc)
  if not self:IsSlidePromptUseSystemUI() then
    EventManager:FireEvent(EventID.OnMobileSlideSplineShow, self, self.NearbyPlayer)
    return
  end
  if IsValid(self.SlideInteractiveUI) then
    self.SlideInteractiveUI:UpdateOwner(self, nil, self.NearbyPlayer, PromptWorldLoc)
  end
end

function BP_SlideSpline_C:CloseSlidePromptUI()
  if not self:IsSlidePromptUseSystemUI() then
    self.Widget:SetHiddenInGame(true)
    if IsValid(self.SlideInteractiveUI) and self.SlideInteractiveUI.SlideSpline == self then
      self.SlideInteractiveUI:Close(self)
    end
    self.SlideInteractiveUI = nil
    return
  end
  self.Widget:SetHiddenInGame(true)
  if IsValid(self.SlideInteractiveUI) and self.SlideInteractiveUI.SlideSpline == self then
    self.SlideInteractiveUI:Close(self)
  end
  self.SlideInteractiveUI = nil
end

function BP_SlideSpline_C:StopProximityCheck()
  self:RemoveTimer("ProximityCheck")
  self:HideSlidePrompt()
  self:ClearProximityCache()
  self.NearbyPlayer = nil
end

function BP_SlideSpline_C:ReceiveEndPlay(Reason)
  local Spheres = self:K2_GetComponentsByClass(UE4.USphereComponent)
  if Spheres then
    for i = 1, Spheres:Length() do
      Spheres[i].OnComponentBeginOverlap:Clear()
      Spheres[i].OnComponentEndOverlap:Clear()
    end
  end
  self:StopProximityCheck()
  BP_SlideSpline_C.Super.ReceiveEndPlay(self, Reason)
end

function BP_SlideSpline_C:PlayStartEffect()
  if IsValid(self.SplineMeshBuilder) then
    self.SplineMeshBuilder.bDissolveDisappear = false
    self.SplineMeshBuilder:StartRevealTrack()
  end
end

function BP_SlideSpline_C:PlayEndEffect()
  if IsValid(self.SplineMeshBuilder) then
    self.SplineMeshBuilder.bDissolveDisappear = true
    self.SplineMeshBuilder:StartRevealTrack()
  end
end

return BP_SlideSpline_C
