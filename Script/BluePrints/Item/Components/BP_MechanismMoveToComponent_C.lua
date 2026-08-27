require("UnLua")
local M = Class()

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self.Owner = self:GetOwner()
  self.IsMoving = false
end

function M:StartMovingToTarget(Target, Speed, Callback, Offset)
  if not IsValid(Target) or not Speed then
    return
  end
  self.IsMoving = true
  self.Target = Target
  self.Speed = Speed
  self.Callback = Callback
  self.Offset = Offset or FVector(0, 0, 0)
end

function M:StopMoving()
  self.IsMoving = false
  self.Target = nil
  self.Callback = nil
  self.Offset = FVector(0, 0, 0)
end

function M:ReceiveTick(DeltaSeconds)
  if not self.IsMoving then
    return
  end
  if not IsValid(self.Target) then
    self:StopMoving()
    return
  end
  local CurLoc = self.Owner:K2_GetActorLocation()
  local TargetLoc = self.Target:K2_GetActorLocation() + self.Offset
  local NewLoc = UE4.UKismetMathLibrary.VInterpTo_Constant(CurLoc, TargetLoc, DeltaSeconds, self.Speed)
  self.Owner:K2_SetActorLocation(NewLoc, false, nil, true)
  if self.Callback and TargetLoc == NewLoc then
    self.Callback(self.Owner)
  end
end

return M
