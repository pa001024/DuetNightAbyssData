local BP_SlideSpline_C = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function BP_SlideSpline_C:CommonInitInfo(Info)
  BP_SlideSpline_C.Super.CommonInitInfo(self, Info)
  self.Progress = 0.0
  self.Length = self.Spline:GetSplineLength()
end

function BP_SlideSpline_C:OnActorReady(Info)
  BP_SlideSpline_C.Super.OnActorReady(self, Info)
end

function BP_SlideSpline_C:ReceiveTick(DeltaSeconds)
  self.Overridden.ReceiveTick(self, DeltaSeconds)
  if IsValid(self.CurPlayer) and self.PlayerInSlide then
    self:MoveWithSpline(DeltaSeconds, self.CurPlayer)
  end
end

function BP_SlideSpline_C:ChangeSlideMechanism_Lua(IsChangeLeft)
  if IsChangeLeft then
    self:OnChangeLeft()
  else
    self:OnChangeRight()
  end
end

function BP_SlideSpline_C:LeaveSlideMechanism_Lua()
  if self.CurPlayer then
    local Forward = self.CurPlayer:GetActorForwardVector()
    local Right = self:GetActorRightVector()
    local RotatedVector = UKismetMathLibrary.RotateAngleAxis(Forward, self.LaunchAdjustAngle, Right)
    local Velocity = RotatedVector * self.LaunchVelocity
    self.CurPlayer:LaunchCharacter(Velocity, true, true)
    self.CurPlayer = nil
    self.PlayerInSlide = false
    self.CanChange = false
    self:AddTimer(self.ChangeCD, function()
      self.CanChange = true
    end, false, 0)
    self:OnEndLeave()
  end
end

function BP_SlideSpline_C:MoveWithSpline(DeltaSeconds, Player)
  local MoveDistance = self.Speed * DeltaSeconds
  self.Progress = self.Progress + MoveDistance / self.Length
  if self.Progress >= 1.0 then
    self.Progress = 1.0
  elseif self.Progress < 0.0 then
    self.Progress = 0.0
  end
  local Distance = self.Progress * self.Length
  local NewLocation = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  NewLocation = self:GetAdjustLocation(NewLocation, Player)
  local NewRotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  Player:K2_SetActorLocation(NewLocation, false, nil, false)
  Player:K2_SetActorRotation(NewRotation, false, nil, false)
end

return BP_SlideSpline_C
