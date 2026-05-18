local BP_SlideSpline_C = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function BP_SlideSpline_C:CommonInitInfo(Info)
  BP_SlideSpline_C.Super.CommonInitInfo(self, Info)
  self.Progress = 0.0
  self.Length = self.Spline:GetSplineLength()
  self.Speed = DataMgr.MovementParams.Speed.ParamValue or 400.0
  self.ChangeCD = DataMgr.MovementParams.SideJumpAttachTime.ParamValue or 1.0
  self.bIsTurning = false
  self.MoveDirection = 1
  self.TurnDuration = 0.0
  self.TurnElapsed = 0.0
  self.AccTime = DataMgr.MovementParams.AccTime.ParamValue or 0.1
  self.bProximityPromptShowing = false
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
  if IsValid(self.CurPlayer) and self.PlayerInSlide and not self.PlayerInSwitch then
    if self.bIsTurning then
      self:TickTurn(DeltaSeconds)
    else
      self:UpdatePostTurnAccel(DeltaSeconds)
      self:MoveWithSpline(DeltaSeconds, self.CurPlayer)
    end
  end
end

function BP_SlideSpline_C:ChangeSlideMechanism_Lua(IsChangeLeft)
  if IsChangeLeft then
    self:OnChangeLeft()
  else
    self:OnChangeRight()
  end
end

function BP_SlideSpline_C:LeaveSlideMechanism_Lua(IsPassive)
  if self.CurPlayer and not self:IsExistTimer("SlideLaunchPlayer") then
    if self.bIsTurning then
      return
    end
    local Distance = self.Progress * self.Length
    local Tangent = self.Spline:GetDirectionAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    Tangent:Normalize()
    local PassiveDeattachSpeedPer = DataMgr.MovementParams.PassiveDeattachSpeedPer.ParamValue or 1.0
    local ActiveDeattachSpeedPer = DataMgr.MovementParams.ActiveDeattachSpeedPer.ParamValue or 1.0
    local SpeedPer, PitchAngle
    if IsPassive then
      SpeedPer = PassiveDeattachSpeedPer
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
    self.CurPlayer:ChangeBackToHeroSlideMech()
    self:AddTimer(0.01, function()
      self.CurPlayer.CharacterMovement:SetMovementMode(UE4.EMovementMode.MOVE_Falling)
      self.CurPlayer:LaunchCharacter(FinalVelocity, true, true)
      self.CurPlayer = nil
      self.PlayerInSlide = false
      self.CanChange = false
      self.MoveDirection = 1
      self:OnEndLeave()
    end, false, 0, "SlideLaunchPlayer")
    self:AddTimer(self.ChangeCD, function()
      self.CanChange = true
    end, false, 0)
  end
end

function BP_SlideSpline_C:UpdateLockedCamera(Rotation)
  if not self.LockCamera then
    return
  end
  if not self.CurPlayer then
    return
  end
  local Controller = self.CurPlayer:GetController()
  if Controller then
    Controller:SetControlRotation(Rotation)
  end
end

function BP_SlideSpline_C:GetAdjustLocation(Location, Player, Distance)
  local CapsuleComp = Player.CapsuleComponent
  local AddHeight = CapsuleComp:GetScaledCapsuleHalfHeight()
  if Distance then
    local UpVector = self.Spline:GetUpVectorAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
    return FVector(Location.X + UpVector.X * AddHeight, Location.Y + UpVector.Y * AddHeight, Location.Z + UpVector.Z * AddHeight + self.AddHeight)
  end
  return FVector(Location.X, Location.Y, Location.Z + AddHeight)
end

function BP_SlideSpline_C:MoveWithSpline(DeltaSeconds, Player)
  local MoveDistance = self.Speed * DeltaSeconds * Player.SlideMovingRate * self.MoveDirection
  self.Progress = self.Progress + MoveDistance / self.Length
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
  local Distance = self.Progress * self.Length
  local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  NewLocation = self:GetAdjustLocation(NewLocation, Player, Distance)
  local NewRotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  if self.MoveDirection < 0 then
    NewRotation = UE4.FRotator(NewRotation.Pitch, NewRotation.Yaw + 180.0, NewRotation.Roll)
  end
  Player:K2_SetActorLocation(NewLocation, false, nil, false)
  Player:K2_SetActorRotation(NewRotation, false)
  self:UpdateLockedCamera(NewRotation)
end

function BP_SlideSpline_C:GetAimLocation(DeltaSeconds, Player)
  local MoveDistance = self:CalcAccelAwareDistance(DeltaSeconds, Player)
  self.TargetProgress = self.Progress + MoveDistance / self.Length
  if self.TargetProgress >= 1.0 then
    self.TargetProgress = 1.0
  elseif self.TargetProgress < 0.0 then
    self.TargetProgress = 0.0
  end
  local Distance = self.TargetProgress * self.Length
  local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  NewLocation = self:GetAdjustLocation(NewLocation, Player, Distance)
  local NewRotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  if self.MoveDirection < 0 then
    NewRotation = UE4.FRotator(NewRotation.Pitch, NewRotation.Yaw + 180.0, NewRotation.Roll)
  end
  return NewLocation, NewRotation
end

function BP_SlideSpline_C:CalcAccelAwareDistance(duration, Player)
  local baseSpeed = self.Speed * self.MoveDirection
  if not self.bPostTurnAccel then
    return baseSpeed * duration * Player.SlideMovingRate
  end
  local accelElapsed = self.PostTurnAccelElapsed or 0.0
  local accelTotal = self.AccTime
  local remainAccTime = math.max(accelTotal - accelElapsed, 0.0)
  local currentRate = math.min(accelElapsed / accelTotal, 1.0)
  if remainAccTime <= 0 then
    return baseSpeed * duration * 1.0
  end
  local distance = 0.0
  if duration <= remainAccTime then
    local endRate = math.min(currentRate + duration / accelTotal, 1.0)
    distance = baseSpeed * (currentRate + endRate) * duration / 2.0
  else
    local accelDist = baseSpeed * (currentRate + 1.0) * remainAccTime / 2.0
    local constDist = baseSpeed * 1.0 * (duration - remainAccTime)
    distance = accelDist + constDist
  end
  return distance
end

function BP_SlideSpline_C:MovePlayerSmooth()
  if not self.CurPlayer then
    return
  end
  if self.CurPlayer.PlayerAnimInstance then
    self.CurPlayer.PlayerAnimInstance.IsSwitchingSlideMech = true
  end
  self.SwitchBeginLocation = self.CurPlayer:K2_GetActorLocation()
  self.SwitchBeginRotation = self.CurPlayer:K2_GetActorRotation()
  self.SwitchBeginProgress = self.Progress
  self.SwitchAccelState = nil
  if self.CurPlayer.SlideMovingRate < 1.0 and self.bPostTurnAccel then
    self.SwitchAccelState = {
      bActive = true,
      accelElapsed = self.PostTurnAccelElapsed or 0.0,
      accelTotal = self.AccTime,
      startRate = self.CurPlayer.SlideMovingRate
    }
  end
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
  self.CurSwitchDeltaNum = self.CurSwitchDeltaNum + 1
  if not self.CurPlayer then
    return
  end
  local Alpha = self.CurSwitchDeltaNum / self.SwitchDeltaTotalNum
  if Alpha > 1.0 then
    Alpha = 1.0
  end
  if self.SwitchAccelState and self.SwitchAccelState.bActive then
    local elapsed = self.SwitchAccelState.accelElapsed + self.CurSwitchDeltaNum * 0.01
    local accelTotal = self.SwitchAccelState.accelTotal
    local rate = math.min(elapsed / accelTotal, 1.0)
    self.CurPlayer.SlideMovingRate = rate
    self.PostTurnAccelElapsed = elapsed
    if rate >= 1.0 then
      self.SwitchAccelState.bActive = false
      self.bPostTurnAccel = false
      self.CurPlayer.SlideMovingRate = 1.0
    end
  end
  local ProgressAlpha = self:CalcSwitchProgressAlpha(Alpha)
  local SmoothAlpha = UKismetMathLibrary.Ease(0.0, 1.0, Alpha, EEasingFunc.EaseInOut)
  local NewLocation = UKismetMathLibrary.VLerp(self.SwitchBeginLocation, self.SwitchTargetLocation, SmoothAlpha)
  local NewRotation = UKismetMathLibrary.RLerp(self.SwitchBeginRotation, self.SwitchTargetRotation, SmoothAlpha, true)
  self.Progress = self.SwitchBeginProgress + (self.TargetProgress - self.SwitchBeginProgress) * ProgressAlpha
  self.CurPlayer:K2_SetActorLocation(NewLocation, false, nil, false)
  self.CurPlayer:K2_SetActorRotation(NewRotation, false)
  self:UpdateLockedCamera(NewRotation)
  if self.CurSwitchDeltaNum >= self.SwitchDeltaTotalNum then
    self:RemoveTimer("MovePlayer")
    self.Progress = self.TargetProgress
    self.PlayerInSwitch = false
    self:BeginSlideSplineMove(false)
    if self.CurPlayer.PlayerAnimInstance then
      self.CurPlayer.PlayerAnimInstance.IsSwitchingSlideMech = false
    end
  end
end

function BP_SlideSpline_C:CalcSwitchProgressAlpha(timeAlpha)
  if not self.SwitchAccelState then
    return timeAlpha
  end
  local switchDuration = self.ChangeCD
  local currentTime = timeAlpha * switchDuration
  local totalDist = self:CalcAccelAwareDistanceRaw(switchDuration)
  if math.abs(totalDist) < 0.001 then
    return timeAlpha
  end
  local currentDist = self:CalcAccelAwareDistanceRaw(currentTime)
  return currentDist / totalDist
end

function BP_SlideSpline_C:CalcAccelAwareDistanceRaw(t)
  if not self.SwitchAccelState or not self.SwitchAccelState.bActive then
    return t
  end
  local accelElapsed = self.SwitchAccelState.accelElapsed
  local accelTotal = self.SwitchAccelState.accelTotal
  local remainAccTime = math.max(accelTotal - accelElapsed, 0.0)
  local currentRate = self.SwitchAccelState.startRate
  if remainAccTime <= 0 then
    return t
  end
  if t <= remainAccTime then
    local endRate = math.min(currentRate + t / accelTotal, 1.0)
    return (currentRate + endRate) * t / 2.0
  else
    local accelPart = (currentRate + 1.0) * remainAccTime / 2.0
    local constPart = 1.0 * (t - remainAccTime)
    return accelPart + constPart
  end
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
  self:AddTimer(0.01, self.StartTurn, false, 0)
end

function BP_SlideSpline_C:StartTurn()
  self.bIsTurning = true
  self.TurnElapsed = 0.0
  self.TurnDuration = self:GetTurnAnimDuration("Locomotion")
  DebugPrint("zwk StartTurn TurnDuration ", self.TurnDuration)
  if self.TurnDuration <= 0 then
    self.TurnDuration = 0.5
  end
  self.TurnStartRotation = self.CurPlayer:K2_GetActorRotation()
  self.TurnTargetRotation = UE4.FRotator(self.TurnStartRotation.Pitch, self.TurnStartRotation.Yaw + 180.0, self.TurnStartRotation.Roll)
end

function BP_SlideSpline_C:TickTurn(DeltaSeconds)
  self.TurnElapsed = self.TurnElapsed + DeltaSeconds
  local Alpha = math.min(self.TurnElapsed / self.TurnDuration, 1.0)
  local NewRotation = UKismetMathLibrary.RLerp(self.TurnStartRotation, self.TurnTargetRotation, Alpha, true)
  self.CurPlayer:K2_SetActorRotation(NewRotation, false)
  self:UpdateLockedCamera(NewRotation)
  if Alpha >= 0.95 then
    self:EndTurn()
  end
end

function BP_SlideSpline_C:EndTurn()
  self.bIsTurning = false
  self.MoveDirection = -self.MoveDirection
  if self.CurPlayer.PlayerAnimInstance then
    self.CurPlayer.InSlideMechTurning = false
    self.CurPlayer.PlayerAnimInstance.InSlideMechTurn = false
  end
  self.CurPlayer.SlideMovingRate = 0.0
  self.bPostTurnAccel = true
  self.PostTurnAccelElapsed = 0.0
end

function BP_SlideSpline_C:UpdatePostTurnAccel(DeltaSeconds)
  if not self.bPostTurnAccel then
    return
  end
  self.PostTurnAccelElapsed = self.PostTurnAccelElapsed + DeltaSeconds
  local Alpha = math.min(self.PostTurnAccelElapsed / self.AccTime, 1.0)
  self.CurPlayer.SlideMovingRate = Alpha
  if Alpha >= 1.0 then
    self.bPostTurnAccel = false
    self.CurPlayer.SlideMovingRate = 1.0
  end
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
  if self.PlayerInSlide or self.NearbyPlayer.IsFlyingToSlideMech then
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
  if not self.bProximityPromptShowing then
    self.bProximityPromptShowing = true
    self.Widget:SetHiddenInGame(false)
  end
  self.Widget:K2_SetWorldLocation(Location + FVector(0, 0, 100), false, nil, false)
end

function BP_SlideSpline_C:HideSlidePrompt()
  if not self.bProximityPromptShowing then
    return
  end
  self.bProximityPromptShowing = false
  self.Widget:SetHiddenInGame(true)
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

return BP_SlideSpline_C
