require("UnLua")
local M = Class({
  "BluePrints.Item.BP_CombatItemBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.SplineLength = self.Spline:GetSplineLength()
  self.MoveDirection = 1
  if self.IsMoving and self.IsMoving == true then
  else
    self.IsMoving = false
  end
  self:InitTrainMeshes()
  self:InitStartDistance()
  self:UpdateTrainPosition()
  self.LoopResetTimerHandle = nil
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
  self.CurrentDistance = 0
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

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self:InitTriggerBoxes()
  self:UpdateFallTriggerCollision()
end

function M:InitTriggerBoxes()
  self.AllTriggerBoxes = {}
  if self.TriggerBox and IsValid(self.TriggerBox) then
    table.insert(self.AllTriggerBoxes, self.TriggerBox)
  end
  for i = 1, 10 do
    local boxName = "TriggerBox" .. i
    if self[boxName] and IsValid(self[boxName]) then
      table.insert(self.AllTriggerBoxes, self[boxName])
    end
  end
  for _, box in ipairs(self.AllTriggerBoxes) do
    box.OnComponentBeginOverlap:Add(self, self.OnFallTriggerOverlap)
  end
end

function M:InitTrainMeshes()
  self.AllTrainMeshes = {}
  if self.Mesh then
    table.insert(self.AllTrainMeshes, self.Mesh)
  end
  for i = 1, 10 do
    local meshName = "Mesh" .. i
    if self[meshName] and IsValid(self[meshName]) then
      table.insert(self.AllTrainMeshes, self[meshName])
    end
  end
  self:UpdateCarriageVisibility()
end

function M:InitStartDistance()
  local spacing = self.Distance or 200.0
  local firstDist = self.FirstDistance or spacing
  local tailOffset = 0
  if self.ActiveMeshCount > 2 then
    tailOffset = firstDist + (self.ActiveMeshCount - 2) * spacing
  elseif 2 == self.ActiveMeshCount then
    tailOffset = firstDist
  end
  self.CurrentDistance = tailOffset
end

function M:UpdateCarriageVisibility()
  self.ActiveMeshCount = #self.AllTrainMeshes
end

function M:ReceiveTick(DeltaSeconds)
  if not self.IsMoving then
    return
  end
  local MoveSpeed = self.speed or 200.0
  local MoveDistance = MoveSpeed * DeltaSeconds * self.MoveDirection
  self.CurrentDistance = self.CurrentDistance + MoveDistance
  if self.CurrentDistance >= self.SplineLength then
    if self.Loop then
      self.MoveDirection = -1
      self.CurrentDistance = self.SplineLength
    else
      self.CurrentDistance = self.SplineLength
      self.IsMoving = false
      self:ClearLoopResetTimer()
      if self.OnDestination then
        self:OnDestination()
      end
      return
    end
  elseif self.CurrentDistance <= 0 then
    if self.Loop then
      self.MoveDirection = 1
      self.CurrentDistance = 0
    else
      self.CurrentDistance = 0
      self.IsMoving = false
      self:ClearLoopResetTimer()
      return
    end
  end
  self:UpdateTrainPosition()
end

function M:UpdateTrainPosition()
  local spacing = self.Distance or 200.0
  local offsetX = self.OffsetX or 0
  local offsetY = self.OffsetY or 0
  local offsetZ = self.OffsetZ or 0
  local offsetYaw = self.OffsetYaw or 0
  for i = 1, self.ActiveMeshCount do
    local mesh = self.AllTrainMeshes[i]
    local firstDist = self.FirstDistance or spacing
    local offset = 0
    if i > 2 then
      offset = -firstDist - (i - 2) * spacing
    elseif 2 == i then
      offset = -firstDist
    end
    local dist = math.max(0, math.min(self.SplineLength, self.CurrentDistance + offset))
    local Location = self.Spline:GetLocationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.Local)
    local Rotation = self.Spline:GetRotationAtDistanceAlongSpline(dist, ESplineCoordinateSpace.Local)
    local LocalOffset = FVector(offsetX, offsetY, offsetZ)
    local RotatedOffset = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(LocalOffset, Rotation)
    if mesh == self.Mesh then
      Rotation = FRotator(Rotation.Pitch, Rotation.Yaw + offsetYaw, Rotation.Roll)
    else
      Location = Location + RotatedOffset
    end
    mesh:K2_SetRelativeLocationAndRotation(Location, Rotation, false, nil, false)
  end
end

function M:ActiveCombat()
  self.IsActive = true
  self:SetActorTickEnabled(true)
  self:StartMove()
  self:UpdateFallTriggerCollision()
end

function M:DeActiveCombat()
  self.IsActive = false
  self:SetActorTickEnabled(false)
  self:StopMove()
  self:UpdateFallTriggerCollision()
end

function M:StartMove()
  DebugPrint("zwkkk StartMove")
  self.IsMoving = true
  self:TryStartLoopResetTimer()
end

function M:StopMove()
  DebugPrint("zwkkk StopMove")
  self.IsMoving = false
  self:ClearLoopResetTimer()
end

function M:UpdateFallTriggerCollision()
  if not self.AllTriggerBoxes then
    return
  end
  local collision = self.FallTriggerEnabled and ECollisionEnabled.QueryOnly or ECollisionEnabled.NoCollision
  for _, box in ipairs(self.AllTriggerBoxes) do
    box:SetCollisionEnabled(collision)
  end
end

function M:GetNearestDefaultTransform(PlayerLoc)
  local RootComp = self:K2_GetRootComponent()
  if not RootComp then
    return nil
  end
  local Children = UE4.TArray(UE4.USceneComponent)
  RootComp:GetChildrenComponents(false, Children)
  local MinDis = 9.9999999E7
  local ResComponent
  for i = 1, Children:Length() do
    local Comp = Children:Get(i)
    if IsValid(Comp) and string.find(Comp:GetName(), "DefaultTransform") then
      local Dis = UE4.UKismetMathLibrary.Vector_Distance(PlayerLoc, Comp:K2_GetComponentLocation())
      if MinDis > Dis then
        MinDis = Dis
        ResComponent = Comp
      end
    end
  end
  return ResComponent
end

function M:OnFallTriggerOverlap(Comp, OtherActor, OtherComp)
  if not self.FallTriggerEnabled then
    return
  end
  if not OtherActor or not IsValid(OtherActor) then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode then
    return
  end
  if OtherActor.IsCharacter and OtherActor:IsCharacter() then
    local DefaultEnable = self.DefaultEnable or false
    local DefaultTransform = Comp:K2_GetComponentToWorld()
    if DefaultEnable then
      local NearestComp = self:GetNearestDefaultTransform(OtherActor:K2_GetActorLocation())
      if NearestComp then
        DefaultTransform = NearestComp:K2_GetComponentToWorld()
      end
    end
    GameMode:TriggerFallingCallable(OtherActor, DefaultTransform, 10000, DefaultEnable, self)
  elseif OtherActor.TriggerFallingCallable then
    OtherActor:TriggerFallingCallable()
  end
end

function M:ReceiveEndPlay(Reason)
  self:ClearLoopResetTimer()
  if self.AllTriggerBoxes then
    for _, box in ipairs(self.AllTriggerBoxes) do
      box.OnComponentBeginOverlap:Clear()
    end
  end
  M.Super.ReceiveEndPlay(self, Reason)
end

function M:StopLoop()
  self:ClearLoopResetTimer()
end

return M
