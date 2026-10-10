require("UnLua")
local BP_EscapeBread_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")
local BreadState = {
  Inactive = 1900300,
  Idle = 1900301,
  Escaping = 1900302,
  CurledUp = 1900303,
  Claimed = 1900304
}

function BP_EscapeBread_C:AuthorityInitInfo(Info)
  BP_EscapeBread_C.Super.AuthorityInitInfo(self, Info)
end

function BP_EscapeBread_C:CommonInitInfo(Info)
  BP_EscapeBread_C.Super.CommonInitInfo(self, Info)
  local P = self.UnitParams or {}
  if P.AlertRadius then
    self.AlertRadius = P.AlertRadius
  end
  if P.MoveSpeed then
    self.BreadMoveSpeed = P.MoveSpeed
  end
  if P.PathLoopType then
    self.bLoopPath = P.PathLoopType == "Loop"
  end
  self.StartNodeIndex = P.StartNodeIndex or 0
  self.ObstacleTag = P.ObstacleTag or "BreadObstacle"
  self.ObstacleTraceHeight = P.ObstacleTraceHeight or 50
  self.ObstacleProbeDist = P.ObstacleProbeDist or 120
  if IsValid(self.TrackMove) then
    self.TrackMove.MoveSpeed = self.BreadMoveSpeed
  end
  if IsValid(self.AlertSphere) then
    self.AlertSphere:SetSphereRadius(self.AlertRadius or 600)
  end
  self:ApplyLoopToBoundSpline()
  self:ApplyStartNodeToBoundSpline()
end

function BP_EscapeBread_C:PathLogTag(SplineComponent)
  local groupName = "?"
  if IsValid(SplineComponent) then
    local Owner = SplineComponent:GetOwner()
    if IsValid(Owner) then
      groupName = Owner:GetName()
    end
  elseif IsValid(self.BoundSpline) then
    local Owner = self.BoundSpline:GetOwner()
    if IsValid(Owner) then
      groupName = Owner:GetName()
    end
  end
  return string.format("[EscapeBread] Group=%s CreatorId=%s UnitId=%s", groupName, tostring(self.CreatorId), tostring(self.UnitId))
end

function BP_EscapeBread_C:ApplyLoopToBoundSpline()
  local TM = self.TrackMove
  if not IsValid(TM) or not IsValid(TM.PathSpline) then
    return
  end
  TM.bClosedLoop = self.bLoopPath == true
  TM:ApplyPathTypeToSpline()
  DebugPrint(self:PathLogTag(TM.PathSpline) .. string.format(" ApplyLoop bLoopPath=%s IsClosedLoop=%s", tostring(self.bLoopPath == true), tostring(TM.PathSpline:IsClosedLoop())))
end

function BP_EscapeBread_C:ApplyStartNodeToBoundSpline()
  local TM = self.TrackMove
  if not IsValid(TM) or not IsValid(TM.PathSpline) then
    return
  end
  local num = TM:GetNodeCount()
  if num <= 0 then
    return
  end
  local startIdx = math.floor(tonumber(self.StartNodeIndex) or 0)
  if startIdx < 0 or startIdx > num - 1 then
    print(_G.LogTag, self:PathLogTag(TM.PathSpline) .. string.format(" StartNodeIndex=%d 越界(节点数%d)，已钳制", startIdx, num))
    startIdx = math.clamp(startIdx, 0, num - 1)
  end
  TM:InitAtIndex(startIdx)
  DebugPrint(self:PathLogTag(TM.PathSpline) .. string.format(" ApplyStartNode Index=%d Nodes=%d", startIdx, num))
end

function BP_EscapeBread_C:SetExploreSpline(SplineComponent)
  local tag = self:PathLogTag(SplineComponent)
  if not IsValid(SplineComponent) then
    print(_G.LogTag, tag .. " 绑定失败：路径组件为空")
    return
  end
  if SplineComponent:GetNumberOfSplinePoints() < 2 then
    print(_G.LogTag, tag .. " 绑定失败：路径节点少于2个(" .. SplineComponent:GetNumberOfSplinePoints() .. ")")
    return
  end
  if self.BoundSpline and IsValid(self.BoundSpline) and self.BoundSpline ~= SplineComponent then
    print(_G.LogTag, tag .. " 绑定失败：本面包已绑定路径 " .. self.BoundSpline:GetName() .. "，重复匹配")
    return
  end
  local bExploreSpline = UExploreSplineComponent and SplineComponent:IsA(UExploreSplineComponent)
  if bExploreSpline then
    local Occupant = SplineComponent.MoveActor
    if IsValid(Occupant) and Occupant ~= self then
      print(_G.LogTag, tag .. " 绑定失败：路径已被 " .. Occupant:GetName() .. " 占用，重复匹配")
      return
    end
    SplineComponent.MoveActor = self
  end
  self.BoundSpline = SplineComponent
  local TM = self.TrackMove
  TM.PathSpline = SplineComponent
  self:ApplyLoopToBoundSpline()
  self:ApplyStartNodeToBoundSpline()
  DebugPrint(tag .. string.format(" 绑定路径 %s 成功：节点数=%d", SplineComponent:GetName(), TM:GetNodeCount()))
  self:RemoveTimer("BreadWaitPathCheck")
  if self.StateId == BreadState.Idle then
    self:SetAlertEnabled(true)
    if (IsAuthority(self) or IsStandAlone(self)) and self:IsPlayerInAlertRange() then
      self:ScheduleChangeState(BreadState.Escaping)
    end
  end
end

function BP_EscapeBread_C:HasValidPath()
  return IsValid(self.BoundSpline) and self.BoundSpline:GetNumberOfSplinePoints() >= 2
end

function BP_EscapeBread_C:WarnNoPathOnce(Where)
  if self.bWarnedNoPath then
    return
  end
  self.bWarnedNoPath = true
  print(_G.LogTag, self:PathLogTag(nil) .. " " .. Where .. "：未绑定有效路径，面包不会移动。请检查探索组/任务组是否调用 BindBreadSpline")
end

function BP_EscapeBread_C:OnActorReady(Info)
  BP_EscapeBread_C.Super.OnActorReady(self, Info)
  if IsValid(self.AlertSphere) then
    self.AlertSphere.OnComponentBeginOverlap:Add(self, self.OnAlertBeginOverlap)
  end
  self:SetAlertEnabled(self.StateId == BreadState.Idle)
end

function BP_EscapeBread_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == BreadState.Inactive then
    self:EnterInactive()
  elseif NowStateId == BreadState.Idle then
    self:EnterIdle()
  elseif NowStateId == BreadState.Escaping then
    self:EnterEscaping()
  elseif NowStateId == BreadState.CurledUp then
    self:EnterCurledUp()
  elseif NowStateId == BreadState.Claimed then
    self:EnterClaimed()
  end
end

function BP_EscapeBread_C:OnLeaveState(NowStateId, NextStateId)
  self.Overridden.OnLeaveState(self, NowStateId, NextStateId)
  if NowStateId == BreadState.Escaping then
    self:RemoveTimer("BreadObstacleWatch")
    self:RemoveTimer("BreadStepEscape")
  end
end

function BP_EscapeBread_C:EnterInactive()
  self:SetAlertEnabled(false)
  self:PlayBreadAnim("Idle")
end

function BP_EscapeBread_C:EnterIdle()
  if not self:HasValidPath() then
    self:SetAlertEnabled(false)
    self:PlayBreadAnim("Idle")
    self:AddTimer(1.0, function()
      if IsValid(self) and self.StateId == BreadState.Idle and not self:HasValidPath() then
        self:WarnNoPathOnce("EnterIdle")
      end
    end, false, 0, "BreadWaitPathCheck")
    return
  end
  self:SetAlertEnabled(true)
  self:PlayBreadAnim("Idle")
  if (IsAuthority(self) or IsStandAlone(self)) and self:IsPlayerInAlertRange() then
    self:ScheduleChangeState(BreadState.Escaping)
  end
end

function BP_EscapeBread_C:EnterEscaping()
  self:SetAlertEnabled(false)
  self:PlayBreadAnim("Move")
  if IsAuthority(self) or IsStandAlone(self) then
    self:ScheduleStepEscape()
  end
end

function BP_EscapeBread_C:EnterCurledUp()
  self:SetAlertEnabled(false)
  if IsValid(self.TrackMove) then
    self.TrackMove:StopMove()
  end
  self:RemoveTimer("BreadObstacleWatch")
  self:PlayBreadAnim("Curl")
end

function BP_EscapeBread_C:EnterClaimed()
  self:PlayBreadAnim("Taken")
end

function BP_EscapeBread_C:DecideEscape()
  if not IsValid(self.TrackMove) or not self:HasValidPath() then
    return nil
  end
  local Spline = self.BoundSpline
  local idx = self.TrackMove.CurrentIndex
  local num = self.TrackMove:GetNodeCount()
  local loop = self.TrackMove.bClosedLoop
  if num < 2 then
    return nil
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return nil
  end
  local BreadLoc = Spline:GetLocationAtSplinePoint(idx, ESplineCoordinateSpace.World)
  local PlayerLoc = Player:K2_GetActorLocation()
  local A0 = self:HorizontalDir(PlayerLoc - BreadLoc)
  if nil == A0 then
    return nil
  end
  local Tangent = self:HorizontalDir(Spline:GetTangentAtSplinePoint(idx, ESplineCoordinateSpace.World))
  if nil == Tangent then
    return nil
  end
  local hasForward = loop or idx < num - 1
  local hasBackward = loop or idx > 0
  local df = self:ClampDot(Tangent, A0)
  local dir
  if hasForward and hasBackward then
    if math.abs(df) < 1.0E-4 then
      dir = 1
    else
      dir = df < 0 and 1 or -1
    end
  elseif hasForward then
    if df > 0 then
      return nil
    end
    dir = 1
  elseif hasBackward then
    if -df > 0 then
      return nil
    end
    dir = -1
  else
    return nil
  end
  self.CurMoveDirWorld = dir > 0 and Tangent or Tangent and Tangent * -1
  DebugPrint("yly BP_EscapeBread_C: DecideEscape: dir: " .. dir)
  return dir
end

function BP_EscapeBread_C:StepEscape()
  if not IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  if not self:HasValidPath() then
    self:WarnNoPathOnce("StepEscape")
    self:ScheduleChangeState(BreadState.Idle)
    return
  end
  local dir = self:DecideEscape()
  if nil == dir then
    self:ScheduleChangeState(BreadState.CurledUp)
    return
  end
  if not self.TrackMove:MoveToNeighbor(dir) then
    self:ScheduleChangeState(BreadState.CurledUp)
    return
  end
  self:StartObstacleWatch()
end

function BP_EscapeBread_C:OnMoveEnd(ArrivedIndex)
  DebugPrint("yly BP_EscapeBread_C: OnMoveEnd: ArrivedIndex: " .. ArrivedIndex)
  if self.Overridden and self.Overridden.OnMoveEnd then
    self.Overridden.OnMoveEnd(self, ArrivedIndex)
  end
  self:RemoveTimer("BreadObstacleWatch")
  self:OnReachWaypoint(ArrivedIndex)
  if not IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  if self.StateId == BreadState.CurledUp or self.StateId == BreadState.Claimed or self.StateId == BreadState.Inactive then
    DebugPrint("yly BP_EscapeBread_C: OnMoveEnd: terminal state, skip continue")
    return
  end
  if self:IsPlayerInAlertRange() then
    self:ScheduleStepEscape()
  elseif self.StateId == BreadState.Escaping then
    self:ScheduleChangeState(BreadState.Idle)
  end
end

function BP_EscapeBread_C:OnMoveStart(FromIndex, ToIndex)
  DebugPrint("yly BP_EscapeBread_C: OnMoveStart: FromIndex: " .. FromIndex .. " ToIndex: " .. ToIndex)
  if self.Overridden and self.Overridden.OnMoveStart then
    self.Overridden.OnMoveStart(self, FromIndex, ToIndex)
  end
end

function BP_EscapeBread_C:TraceObstacle(Start, End)
  local Ignore = TArray(AActor)
  Ignore:Add(self)
  local HitResult = UE4.FHitResult()
  local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, Const.FixTraceChannel.TraceScene, false, Ignore, UE4.EDrawDebugTrace.None, HitResult, true, UE4.FLinearColor(1, 0, 0, 1), UE4.FLinearColor(0, 1, 0, 1), 0)
  if not bHit then
    return false
  end
  local HitActor = HitResult.Actor
  if not IsValid(HitActor) then
    return false
  end
  return HitActor:ActorHasTag(self.ObstacleTag or "BreadObstacle")
end

function BP_EscapeBread_C:StartObstacleWatch()
  self:AddTimer(0.05, function()
    if not IsValid(self) then
      return
    end
    if self.StateId ~= BreadState.Escaping then
      return
    end
    if not IsValid(self.TrackMove) or not self.TrackMove.bMoving then
      return
    end
    local Dir = self.CurMoveDirWorld
    if nil == Dir then
      return
    end
    local Up = FVector(0, 0, self.ObstacleTraceHeight or 50)
    local BreadLoc = self.BreadMesh:K2_GetComponentLocation()
    local Ahead = BreadLoc + Dir * self.ObstacleProbeDist
    if self:TraceObstacle(BreadLoc + Up, Ahead + Up) then
      self.TrackMove:StopMove()
      self:RemoveTimer("BreadObstacleWatch")
      self:ScheduleChangeState(BreadState.CurledUp)
    end
  end, true, 0, "BreadObstacleWatch")
end

function BP_EscapeBread_C:OnAlertBeginOverlap(Component, OtherActor, OtherComp, BodyIndex, bFromSweep, SweepResult)
  if not IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  if self.StateId ~= BreadState.Idle then
    return
  end
  if not self:HasValidPath() then
    return
  end
  if not self:IsTargetPlayer(OtherActor) then
    return
  end
  self:ChangeState("Manual", 0, BreadState.Escaping)
end

function BP_EscapeBread_C:ReceiveEndPlay(EndPlayReason)
  if self.Overridden and self.Overridden.ReceiveEndPlay then
    self.Overridden.ReceiveEndPlay(self, EndPlayReason)
  end
  if self.BoundSpline and IsValid(self.BoundSpline) and UExploreSplineComponent and self.BoundSpline:IsA(UExploreSplineComponent) and self.BoundSpline.MoveActor == self then
    self.BoundSpline.MoveActor = nil
  end
  self.BoundSpline = nil
end

function BP_EscapeBread_C:GetCanOpen(PlayerEid)
  self.CanOpen = self.StateId == BreadState.CurledUp
  return self.CanOpen
end

function BP_EscapeBread_C:Activate()
  if not IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  if self.StateId == BreadState.Inactive then
    self:ChangeState("Manual", 0, BreadState.Idle)
  end
end

function BP_EscapeBread_C:HorizontalDir(V)
  local x, y, z = V.X, V.Y, V.Z
  local len = math.sqrt(x * x + y * y)
  if len < 0.001 then
    return nil
  end
  return FVector(x / len, y / len, 0)
end

function BP_EscapeBread_C:ClampDot(a, b)
  local d = a.X * b.X + a.Y * b.Y + a.Z * b.Z
  if d > 1 then
    d = 1
  elseif d < -1 then
    d = -1
  end
  return d
end

function BP_EscapeBread_C:IsPlayerInAlertRange()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return false
  end
  local d = (Player:K2_GetActorLocation() - self.BreadMesh:K2_GetComponentLocation()):Size()
  return d <= (self.AlertRadius or 600)
end

function BP_EscapeBread_C:IsTargetPlayer(OtherActor)
  if not IsValid(OtherActor) then
    return false
  end
  return OtherActor == UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
end

function BP_EscapeBread_C:SetAlertEnabled(bEnabled)
  if not IsValid(self.AlertSphere) then
    return
  end
  self.AlertSphere:SetGenerateOverlapEvents(bEnabled)
  self.AlertSphere:SetCollisionEnabled(bEnabled and ECollisionEnabled.QueryOnly or ECollisionEnabled.NoCollision)
end

function BP_EscapeBread_C:PlayBreadAnim(Key)
  local MontageMap = {
    Idle = self.IdleMontage,
    Move = self.MoveMontage,
    Curl = self.CurlMontage,
    Taken = self.TakenMontage
  }
  local Mont = MontageMap[Key]
  if not Mont or not IsValid(self.BreadMesh) then
    return
  end
  local AnimInst = self.BreadMesh:GetAnimInstance()
  if AnimInst then
    AnimInst:Montage_Play(Mont, 1.0)
  end
end

function BP_EscapeBread_C:ScheduleChangeState(TargetState)
  if not IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  self:AddTimer(0.01, function()
    if IsValid(self) then
      self:ChangeState("Manual", 0, TargetState)
    end
  end, false, 0, "BreadChangeState")
end

function BP_EscapeBread_C:ScheduleStepEscape()
  if not IsAuthority(self) and not IsStandAlone(self) then
    return
  end
  self:AddTimer(0.01, function()
    if not IsValid(self) then
      return
    end
    if self.StateId ~= BreadState.Escaping then
      return
    end
    if IsValid(self.TrackMove) and self.TrackMove.bMoving then
      return
    end
    self:StepEscape()
  end, false, 0, "BreadStepEscape")
end

return BP_EscapeBread_C
