require("UnLua")
local M = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function M:ReceiveBeginPlay()
  DebugPrint("yly BP_Conveyor_C ReceiveBeginPlay")
  M.Super.ReceiveBeginPlay(self)
end

function M:AuthorityInitInfo(Info)
  DebugPrint("yly BP_Conveyor_C AuthorityInitInfo")
  M.Super.AuthorityInitInfo(self, Info)
end

function M:CommonInitInfo(Info)
  DebugPrint("yly BP_Conveyor_C CommonInitInfo")
  M.Super.CommonInitInfo(self, Info)
  if self.Arrow and IsValid(self.Arrow) then
  else
    DebugPrint("yly BP_Conveyor_C CommonInitInfo: Arrow is not valid")
    return
  end
  self.MovingActors = {}
end

function M:ClientInitInfo(Info)
  DebugPrint("yly BP_Conveyor_C ClientInitInfo")
  M.Super.ClientInitInfo(self, Info)
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self.ConveySpline = self.Spline
  if not self.ConveySpline or not IsValid(self.ConveySpline) then
    DebugPrint("yly BP_Conveyor_C OnActorReady: ConveySpline is not valid")
    return
  end
  self.SplineLength = self.ConveySpline:GetSplineLength()
  self.ConveySpeed = self.TargetSpeed
  self.EndQueue = {}
  self.EndQueueSet = {}
  self.EndCheckRadius = self.EndCheckRadius or 300.0
  self.EndProcessInterval = self.EndProcessInterval or 0.5
  self.EndProcessAcc = 0.0
  if not self.Arrow or not IsValid(self.Arrow) then
    DebugPrint("yly BP_Conveyor_C OnActorReady: self.Arrow is not valid")
    return
  end
  self.ArrowLoc = self.Arrow:K2_GetComponentLocation()
  self.CachedConveyorBoxes = self:GetConveyorBoxes()
  if self.EndBox and IsValid(self.EndBox) then
    self.EndBox.OnComponentBeginOverlap:Add(self, self.OnEndBoxComponentBeginOverlap)
  end
  self:BindConveyorBoxesOverlap()
  self:CheckInitialOverlaps()
end

function M:BindConveyorBoxesOverlap()
  local Boxes = self.CachedConveyorBoxes
  if not Boxes then
    return
  end
  for i = 1, Boxes:Length() do
    local Box = Boxes[i]
    if IsValid(Box) then
      Box.OnComponentBeginOverlap:Add(self, self.OnConveyorBoxBeginOverlap)
      Box.OnComponentEndOverlap:Add(self, self.OnConveyorBoxEndOverlap)
    end
  end
end

function M:UnbindConveyorBoxesOverlap()
  local Boxes = self.CachedConveyorBoxes
  if not Boxes then
    return
  end
  for i = 1, Boxes:Length() do
    local Box = Boxes[i]
    if IsValid(Box) then
      Box.OnComponentBeginOverlap:Clear()
      Box.OnComponentEndOverlap:Clear()
    end
  end
end

function M:CheckInitialOverlaps()
  local Boxes = self.CachedConveyorBoxes
  if not Boxes then
    return
  end
  for i = 1, Boxes:Length() do
    local Box = Boxes[i]
    if IsValid(Box) then
      local OverlappingActors = UE4.TArray(AActor)
      Box:GetOverlappingActors(OverlappingActors)
      for j = 1, OverlappingActors:Length() do
        local Actor = OverlappingActors[j]
        if self:ShouldMoveActor(Actor) then
          self:RegisterMoveActor(Actor)
          DebugPrint("yly BP_Conveyor_C CheckInitialOverlaps RegisterMoveActor=", Actor:GetName())
        end
      end
    end
  end
end

function M:GetConveyorBoxes()
  local AllBoxes = self:K2_GetComponentsByClass(UE4.UBoxComponent)
  if not AllBoxes then
    return nil
  end
  local Result = UE4.TArray(UE4.UBoxComponent)
  for i = 1, AllBoxes:Length() do
    local Box = AllBoxes[i]
    if not IsValid(Box) or self.EndBox and Box == self.EndBox then
    elseif Box.ComponentHasTag and Box:ComponentHasTag("ConveyorArea") then
      Result:Add(Box)
    end
  end
  return Result
end

function M:OnConveyorBoxBeginOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if not self:ShouldMoveActor(OtherActor) then
    return
  end
  self:RegisterMoveActor(OtherActor)
end

function M:OnConveyorBoxEndOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex)
  if not self:ShouldMoveActor(OtherActor) then
    return
  end
  if self:IsActorInAnyConveyorBox(OtherActor) then
    return
  end
  self:UnregisterMoveActor(OtherActor)
end

function M:IsActorInAnyConveyorBox(Actor)
  if not Actor or not IsValid(Actor) then
    return false
  end
  local Boxes = self.CachedConveyorBoxes
  if not Boxes then
    return false
  end
  for i = 1, Boxes:Length() do
    local Box = Boxes[i]
    if IsValid(Box) and Box:IsOverlappingActor(Actor) then
      return true
    end
  end
  return false
end

function M:ReceiveTick(DeltaSeconds)
  self.Overridden.ReceiveTick(self, DeltaSeconds)
  if not self.IsConveyActive or not self.ConveySpline then
    return
  end
  local MoveSpeed = (self.ConveySpeed or 0.0) * 100
  local SplineLength = self.SplineLength or self.ConveySpline:GetSplineLength()
  for id, Data in pairs(self.MovingActors) do
    local Actor = Data.mActor
    if IsValid(Actor) then
      local ActorLocation = Actor:K2_GetActorLocation()
      local InputKey = self.ConveySpline:FindInputKeyClosestToWorldLocation(ActorLocation)
      local CurrentDistance = self.ConveySpline:GetDistanceAlongSplineAtSplineInputKey(InputKey)
      local TargetDistance = CurrentDistance + MoveSpeed * DeltaSeconds
      if SplineLength < TargetDistance then
        TargetDistance = SplineLength
      end
      local CurrentSplineLocation = self.ConveySpline:GetLocationAtDistanceAlongSpline(CurrentDistance, UE4.ESplineCoordinateSpace.World)
      local TargetSplineLocation = self.ConveySpline:GetLocationAtDistanceAlongSpline(TargetDistance, UE4.ESplineCoordinateSpace.World)
      local Offset = TargetSplineLocation - CurrentSplineLocation
      Actor:K2_AddActorWorldOffset(Offset, false, nil, true)
    else
      table.remove(self.MovingActors, id)
    end
  end
  self.EndProcessAcc = self.EndProcessAcc + DeltaSeconds
  if self.EndProcessAcc >= self.EndProcessInterval then
    self.EndProcessAcc = 0.0
    self:TryProcessEndQueue()
  end
end

function M:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if 1610011 == NowStateId then
    self.IsConveyActive = false
  elseif 1610012 == NowStateId then
    self.IsConveyActive = true
  end
end

function M:ShouldMoveActor(Actor)
  return self:IsPlayerOrMonster(Actor) or self:ActorHasTargetTag(Actor)
end

function M:IsSelectionActor(Actor)
  return self:ActorHasTargetTag(Actor) and not self:IsPlayerOrMonster(Actor)
end

function M:IsPlayerOrMonster(Actor)
  if not Actor or not IsValid(Actor) then
    return false
  end
  if Actor.IsPlayer and Actor:IsPlayer() then
    return true
  end
  if Actor.IsMonster and Actor:IsMonster() then
    return true
  end
  if Actor.IsCharacter and Actor:IsCharacter() then
    return true
  end
  return false
end

function M:ActorHasTargetTag(Actor)
  if not Actor or not IsValid(Actor) then
    return false
  end
  if not self.TargetTag or self.TargetTag == "" then
    return false
  end
  if Actor.ActorHasTag then
    return Actor:ActorHasTag(self.TargetTag)
  end
  if Actor.Tags and Actor.Tags.Contains then
    return Actor.Tags:Contains(self.TargetTag)
  end
  return false
end

function M:RegisterMoveActor(Actor)
  if not Actor or not IsValid(Actor) then
    return
  end
  for _, MovingActor in pairs(self.MovingActors) do
    if MovingActor.mActor == Actor then
      return
    end
  end
  DebugPrint("yly BP_Conveyor_C RegisterMoveActor=", Actor:GetName())
  table.insert(self.MovingActors, {mActor = Actor})
end

function M:UnregisterMoveActor(Actor)
  if not Actor or not IsValid(Actor) then
    return
  end
  for id, MovingActor in pairs(self.MovingActors) do
    if MovingActor.mActor == Actor then
      DebugPrint("yly BP_Conveyor_C UnRegisterMoveActor=", Actor:GetName())
      table.remove(self.MovingActors, id)
    end
  end
end

function M:ReceiveEndPlay(Reason)
  M.Super.ReceiveEndPlay(self, Reason)
  if self.EndBox and IsValid(self.EndBox) then
    self.EndBox.OnComponentBeginOverlap:Clear()
  end
  self:UnbindConveyorBoxesOverlap()
end

function M:IsActorQueued(Actor)
  return Actor and self.EndQueueSet and self.EndQueueSet[Actor] == true
end

function M:EnqueueEndActor(Actor)
  if not Actor or not IsValid(Actor) then
    return false
  end
  if self:IsActorQueued(Actor) then
    return false
  end
  table.insert(self.EndQueue, Actor)
  self.EndQueueSet[Actor] = true
  return true
end

function M:DequeueEndActor()
  if not self.EndQueue or 0 == #self.EndQueue then
    return nil
  end
  local Actor = table.remove(self.EndQueue, 1)
  if Actor then
    self.EndQueueSet[Actor] = nil
  end
  return Actor
end

function M:IsArrowOccupied()
  if not self.Arrow or not IsValid(self.Arrow) then
    return true
  end
  local Radius = self.EndCheckRadius
  for _, Data in pairs(self.MovingActors or {}) do
    local A = Data.mActor
    if IsValid(A) and self:IsSelectionActor(A) then
      local Loc = A:K2_GetActorLocation()
      if Radius >= (Loc - self.ArrowLoc):Size() then
        return true
      end
    end
  end
  return false
end

function M:TryProcessEndQueue()
  if not self.IsConveyActive then
    return
  end
  if not self.Arrow or not IsValid(self.Arrow) then
    return
  end
  if not self.EndQueue or 0 == #self.EndQueue then
    return
  end
  if self:IsArrowOccupied() then
    return
  end
  local Actor = self:DequeueEndActor()
  if not Actor or not IsValid(Actor) then
    return
  end
  Actor:K2_SetActorLocation(self.ArrowLoc, false, nil, false)
end

function M:OnEndBoxComponentBeginOverlap(Comp, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
  if not self.IsConveyActive or not self:IsSelectionActor(OtherActor) then
    return
  end
  self:EnqueueEndActor(OtherActor)
  self:TryProcessEndQueue()
end

return M
