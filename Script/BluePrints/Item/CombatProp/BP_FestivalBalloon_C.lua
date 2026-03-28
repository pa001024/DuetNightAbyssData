local BP_FestivalBalloon_C = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function BP_FestivalBalloon_C:CommonInitInfo(Info)
  BP_FestivalBalloon_C.Super.CommonInitInfo(self, Info)
  self.IsActive = true
  self.Direction = 1
  self.Progress = 0
  self.TimeLength = tonumber(self.TimeLength) or 5
  self:IsNeedDestroy()
end

function BP_FestivalBalloon_C:ReceiveTick(DeltaSeconds)
  if not self.IsActive then
    return
  end
  if not self.Spline then
    return
  end
  self:MoveWithSpline(DeltaSeconds)
end

function BP_FestivalBalloon_C:MoveWithSpline(DeltaSeconds)
  if not self.Spline then
    return
  end
  DeltaSeconds = DeltaSeconds or 0
  self.TimeLength = tonumber(self.TimeLength) or 1
  if self.TimeLength <= 0 then
    return
  end
  self.Direction = self.Direction or 1
  self.Progress = self.Progress or 0
  self.Progress = self.Progress + self.Direction * DeltaSeconds
  if 0 == self.MotionType then
    if self.Progress >= self.TimeLength then
      self.Progress = self.TimeLength
      self.Direction = -1
    elseif self.Progress <= 0 then
      self.Progress = 0
      self.Direction = 1
    end
  elseif 1 == self.MotionType then
    if self.Progress >= self.TimeLength then
      self.Progress = 0
    elseif self.Progress < 0 then
      self.Progress = 0
      self.Direction = 1
    end
  end
  local Alpha = math.max(0, math.min(1, self.Progress / self.TimeLength))
  local SplineLen = self.Spline:GetSplineLength()
  local Distance = Alpha * SplineLen
  local Location = self.Spline:GetLocationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  local Rotation = self.Spline:GetRotationAtDistanceAlongSpline(Distance, ESplineCoordinateSpace.World)
  self.Target:K2_SetWorldLocation(Location, false, nil, false)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
end

function BP_FestivalBalloon_C:OnBreakCountDown(SourceEid)
  BP_FestivalBalloon_C.Super.OnBreakCountDown(self, SourceEid)
  self.Overridden.OnBreakCountDown(self, SourceEid)
  self:ChangeState("Hit", SourceEid)
end

function BP_FestivalBalloon_C:ReceiveBeginPlay()
  BP_FestivalBalloon_C.Super.ReceiveBeginPlay(self)
end

function BP_FestivalBalloon_C:IsNeedDestroy()
  if self.StateId == 1330012 then
    self:K2_DestroyActor()
  end
end

return BP_FestivalBalloon_C
