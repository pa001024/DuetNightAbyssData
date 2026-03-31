local M = Class("BluePrints/Item/BP_CombatItemBase_C")

function M:ReceiveBeginPlay()
  self.Super.ReceiveBeginPlay(self)
  self.InitRotate = self:K2_GetActorRotation()
  self.HasFireEvent1 = false
  self.HasFireEvent2 = false
  self.IsRotating = false
  self.IsReturning = false
  self.ToTheEnd = false
end

function M:ReceiveTick(DeltaSeconds)
  self.Overridden.ReceiveTick(self, DeltaSeconds)
  local CurYaw = self.CurRotate.Yaw
  local TargetYaw = self.InitRotate.Yaw
  local NewYaw = UE4.UKismetMathLibrary.FixedTurn(CurYaw, TargetYaw, self.ReturnSpeed * DeltaSeconds)
  self.CurRotate.Yaw = NewYaw
  self:K2_SetActorRotation(self.CurRotate, false, nil, false)
  if self.IsReturning and math.abs(NewYaw - TargetYaw) < 0.1 then
    self.IsReturning = false
    if self.OnReturnEndEvent then
      self:OnReturnEndEvent()
    end
  end
end

function M:CheckAngle(RotateFactor)
  local CurYaw = self:K2_GetActorRotation().Yaw
  local InitYaw = self.InitRotate.Yaw
  local YawDifference = InitYaw - CurYaw
  YawDifference = (YawDifference + 180) % 360 - 180
  if not self.HasFireEvent1 and YawDifference <= -self.MaxAngle then
    self.HasFireEvent1 = true
    self:FireCustomEvent(self.EventName1)
  end
  if not self.HasFireEvent2 and YawDifference >= self.MaxAngle then
    self.HasFireEvent2 = true
    self:FireCustomEvent(self.EventName2)
  end
  if math.abs(YawDifference) <= self.MaxAngle or self.RotateFactor ~= RotateFactor then
    self.RotateFactor = RotateFactor
    return true
  end
  self.RotateFactor = RotateFactor
  return false
end

function M:AddRot(DeltaRot)
  local CurRot = self:K2_GetActorRotation()
  local FinalYaw = CurRot.Yaw + DeltaRot.Yaw
  if FinalYaw > self.MaxAngle then
    self:NotifyStopRotate()
    self.ToTheEnd = true
    FinalYaw = self.MaxAngle - 0.001
    if not self.HasFireEvent1 then
      self.HasFireEvent1 = true
      self:FireCustomEvent(self.EventName1)
    end
  elseif FinalYaw < -self.MaxAngle then
    self:NotifyStopRotate()
    self.ToTheEnd = true
    FinalYaw = -self.MaxAngle + 0.001
    if not self.HasFireEvent2 then
      self.HasFireEvent2 = true
      self:FireCustomEvent(self.EventName2)
    end
  else
    self.ToTheEnd = false
  end
  local FinalRot = UE.FRotator(CurRot.Pitch, FinalYaw, CurRot.Roll)
  self:K2_SetActorRotation(FinalRot, false, nil, false)
end

function M:NotifyStartRotate()
  if not self.IsRotating and not self.ToTheEnd then
    self.IsRotating = true
    if self.OnStartRotateEvent then
      self:OnStartRotateEvent()
    end
  end
end

function M:NotifyStopRotate()
  if self.IsRotating then
    self.IsRotating = false
    if self.OnEndRotateEvent then
      self:OnEndRotateEvent()
    end
  end
end

function M:ActiveCombat()
  self.Super.ActiveCombat(self)
  self.IsReturning = false
  self:SetActorTickEnabled(false)
end

function M:DeActiveCombat()
  self.Super.DeActiveCombat(self)
  self.CurRotate = self:K2_GetActorRotation()
  local CurYaw = self.CurRotate.Yaw
  local TargetYaw = self.InitRotate.Yaw
  local YawDiff = math.abs((CurYaw - TargetYaw + 180) % 360 - 180)
  if YawDiff > 0.01 then
    self.IsReturning = true
    if self.OnReturnStartEvent then
      self:OnReturnStartEvent()
    end
  end
  self:SetActorTickEnabled(true)
end

function M:FireCustomEvent(EventName)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode then
    return
  end
  DebugPrint("RotateWall FireCustomEvent", EventName)
  GameMode:PostCustomEvent(EventName)
end

return M
