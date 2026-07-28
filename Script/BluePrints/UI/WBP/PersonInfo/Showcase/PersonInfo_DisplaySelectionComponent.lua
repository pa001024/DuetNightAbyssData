require("UnLua")
local M = {}
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local TRACE_DISTANCE = 100000.0
local TRACE_TYPE = UE4.ETraceTypeQuery.TraceExceptChar
local TRACE_LABEL = "TraceExceptChar"
local TRACE_DEBUG_DURATION = 5.0

local function GetActorNameSafe(Actor)
  if not Actor then
    return "None"
  end
  if Actor.GetName then
    return Actor:GetName()
  end
  return tostring(Actor)
end

local function GetComponentNameSafe(Component)
  if not Component then
    return "None"
  end
  if Component.GetName then
    return Component:GetName()
  end
  return tostring(Component)
end

local function DrawTraceSegment(ContextObject, StartPos, EndPos)
  if PersonInfoCommon.EnableSelectionDebugDraw ~= true then
    return
  end
  UE4.UKismetSystemLibrary.DrawDebugLine(ContextObject, StartPos, EndPos, UE4.FLinearColor(1, 0, 0, 1), TRACE_DEBUG_DURATION, 2.0)
end

local function DrawTraceHitPoint(ContextObject, Position)
  if PersonInfoCommon.EnableSelectionDebugDraw ~= true then
    return
  end
  if not Position then
    return
  end
  UE4.UKismetSystemLibrary.DrawDebugSphere(ContextObject, Position, 8.0, 8, UE4.FLinearColor(1, 1, 0, 1), TRACE_DEBUG_DURATION, 1.5)
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.Controller = Params.Controller
  self.PendingGeometry = nil
  self.PendingScreenPosition = nil
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

function M:BeginPointerPress(MyGeometry, PointerEvent)
  self.PendingGeometry = MyGeometry
  self.PendingScreenPosition = PointerEvent and UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent) or nil
end

function M:ClearPendingPointerPress()
  self.PendingGeometry = nil
  self.PendingScreenPosition = nil
end

function M:CommitPointerSelection()
  local MyGeometry = self.PendingGeometry
  local ScreenPosition = self.PendingScreenPosition
  self:ClearPendingPointerPress()
  if not ScreenPosition or not MyGeometry then
    return nil
  end
  return self:TrySelectByScreenPosition(MyGeometry, ScreenPosition)
end

function M:TrySelectByScreenPosition(MyGeometry, ScreenPosition)
  local HitActor = self:_HitTestPreviewActor(MyGeometry, ScreenPosition)
  if not HitActor then
    DebugPrint("TrySelectByScreenPosition" .. "No HitActor")
    return nil
  end
  local EntityId = self:_FindEntityIdByActor(HitActor)
  if not EntityId then
    return nil
  end
  DebugPrint("TrySelectByScreenPosition", EntityId)
  return EntityId
end

function M:_HitTestPreviewActor(MyGeometry, ScreenPosition)
  local PlayerController = self:_GetPlayerController()
  if not PlayerController then
    return nil
  end
  return self:_HitTestByDeproject(MyGeometry, PlayerController, ScreenPosition)
end

function M:_HitTestByDeproject(MyGeometry, PlayerController, ScreenPosition)
  if not PlayerController or not ScreenPosition then
    return nil
  end
  local PixelPos = FVector2D()
  local ViewportPos = FVector2D()
  UE4.USlateBlueprintLibrary.AbsoluteToViewport(self.ViewUI, ScreenPosition, PixelPos, ViewportPos)
  local WorldOrigin = FVector()
  local WorldDir = FVector()
  local bOK = UE4.UGameplayStatics.DeprojectScreenToWorld(PlayerController, PixelPos, WorldOrigin, WorldDir)
  if not bOK then
    return nil
  end
  local TraceEnd = WorldOrigin + WorldDir * TRACE_DISTANCE
  local ContextObject = self.ViewUI or self.Controller
  local Hit = UE4.FHitResult()
  local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(ContextObject, WorldOrigin, TraceEnd, TRACE_TYPE, true, {}, UE4.EDrawDebugTrace.None, Hit, true)
  local TraceStop = bHit and Hit.ImpactPoint or TraceEnd
  DrawTraceSegment(ContextObject, WorldOrigin, TraceStop)
  if bHit then
    DrawTraceHitPoint(ContextObject, Hit.ImpactPoint)
  end
  DebugPrint(string.format("DisplaySelection %s Hit=%s Actor=%s Component=%s", TRACE_LABEL, tostring(bHit), GetActorNameSafe(Hit.Actor), GetComponentNameSafe(Hit.Component)))
  if not bHit then
    return nil
  end
  return Hit.Actor or nil
end

function M:_FindEntityIdByActor(HitActor)
  if not (HitActor and self.Controller) or not self.Controller.EntityHandles then
    return nil
  end
  for EntityId, Handle in pairs(self.Controller.EntityHandles) do
    local PreviewActor = Handle and Handle.GetActor and Handle:GetActor() or nil
    if PreviewActor and self:_IsSameActorOrParent(HitActor, PreviewActor) then
      return EntityId
    end
  end
  return nil
end

function M:_IsSameActorOrParent(HitActor, TargetActor)
  if not HitActor or not TargetActor then
    return false
  end
  if HitActor == TargetActor then
    return true
  end
  local ParentActor = HitActor
  local Guard = 0
  while ParentActor and Guard < 8 do
    if ParentActor == TargetActor then
      return true
    end
    ParentActor = ParentActor.GetAttachParentActor and ParentActor:GetAttachParentActor() or nil
    Guard = Guard + 1
  end
  return false
end

function M:_GetPlayerController()
  if self.ViewUI and self.ViewUI.GetOwningPlayer then
    local Player = self.ViewUI:GetOwningPlayer()
    if Player then
      return Player
    end
  end
  return self.ViewUI and UE4.UGameplayStatics.GetPlayerController(self.ViewUI, 0) or nil
end

return M
