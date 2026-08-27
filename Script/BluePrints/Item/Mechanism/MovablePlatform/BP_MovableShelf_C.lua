require("UnLua")
local BP_MovableShelf_C = Class("BluePrints.Item.BP_CombatItemBase_C")
local ShelfState = {
  Inactive = 1900100,
  Idle = 1900101,
  Moving = 1900102
}

function BP_MovableShelf_C:AuthorityInitInfo(Info)
  BP_MovableShelf_C.Super.AuthorityInitInfo(self, Info)
end

function BP_MovableShelf_C:CommonInitInfo(Info)
  BP_MovableShelf_C.Super.CommonInitInfo(self, Info)
  self.TrackMoveComp = self.TrackMove
  self.SplineComp = self.PathSpline
  self.ShelfMesh = self.PlatformMesh
  self.bMoveForward = true
end

function BP_MovableShelf_C:ClientInitInfo(Info)
  BP_MovableShelf_C.Super.ClientInitInfo(self, Info)
end

function BP_MovableShelf_C:OnActorReady(Info)
  BP_MovableShelf_C.Super.OnActorReady(self, Info)
end

function BP_MovableShelf_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == ShelfState.Inactive then
    self:EnterInactive()
  elseif NowStateId == ShelfState.Idle then
    self:EnterIdle()
  elseif NowStateId == ShelfState.Moving then
    self:EnterMoving()
  end
end

function BP_MovableShelf_C:OnLeaveState(NowStateId, NextStateId)
  self.Overridden.OnLeaveState(self, NowStateId, NextStateId)
end

function BP_MovableShelf_C:EnterInactive()
end

function BP_MovableShelf_C:EnterIdle()
  DebugPrint("yly BP_MovableShelf_C:EnterIdle")
end

function BP_MovableShelf_C:EnterMoving()
  DebugPrint("yly BP_MovableShelf_C:EnterMoving")
  local started = false
  if IsValid(self.TrackMoveComp) then
    if self.bMoveForward then
      started = self:MoveNext()
    else
      started = self:MovePrev()
    end
  end
  if not started then
    self:ScheduleBackToIdle()
  end
end

function BP_MovableShelf_C:ScheduleBackToIdle()
  if not IsAuthority(self) then
    return
  end
  self:AddTimer(0.01, function()
    if IsValid(self) and self.StateId == ShelfState.Moving then
      self:ChangeState("Manual", 0, ShelfState.Idle)
    end
  end, false, 0, "ShelfBackToIdle")
end

function BP_MovableShelf_C:Activate()
  if not IsAuthority(self) then
    return
  end
  if self.StateId == ShelfState.Inactive then
    self:ChangeState("Manual", 0, ShelfState.Idle)
  end
end

function BP_MovableShelf_C:Deactivate()
  if not IsAuthority(self) then
    return
  end
  self:ChangeState("Manual", 0, ShelfState.Inactive)
end

function BP_MovableShelf_C:OnLingQinTrigger(bForward)
  if not IsAuthority(self) then
    return
  end
  if self.StateId ~= ShelfState.Idle then
    return
  end
  if IsValid(self.TrackMoveComp) and self.TrackMoveComp.bMoving then
    return
  end
  self.bMoveForward = true == bForward
  self:ChangeState("Manual", 0, ShelfState.Moving)
end

function BP_MovableShelf_C:OnMoveStart(FromIndex, ToIndex)
  self.Overridden.OnMoveStart(self, FromIndex, ToIndex)
  DebugPrint("yly BP_MovableShelf_C:OnMoveStart lua", FromIndex, ToIndex)
end

function BP_MovableShelf_C:OnMoveEnd(ArrivedIndex)
  self.Overridden.OnMoveEnd(self, ArrivedIndex)
  DebugPrint("yly BP_MovableShelf_C:OnMoveEnd lua", ArrivedIndex)
  self:ScheduleBackToIdle()
end

return BP_MovableShelf_C
