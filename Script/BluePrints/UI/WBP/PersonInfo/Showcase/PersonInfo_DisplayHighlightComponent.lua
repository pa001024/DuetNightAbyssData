require("UnLua")
local M = {}
local FOCUS_STENCIL_VALUE = 16
local DEFAULT_STENCIL_VALUE = 1

local function GetObjectNameSafe(Object)
  if not Object then
    return "None"
  end
  if Object.GetName then
    return Object:GetName()
  end
  return tostring(Object)
end

local function AppendUniqueComponent(Result, AddedMap, Component)
  if not Component then
    return
  end
  local Key = tostring(Component)
  if AddedMap[Key] then
    return
  end
  AddedMap[Key] = true
  table.insert(Result, Component)
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.Controller = Params.Controller
  self.CurrentEntityId = nil
  self.OutlineOpened = false
  self.HighlightedEntityState = {}
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

function M:RefreshFocusHighlight(OldEntityId, NewEntityId)
  self.CurrentEntityId = NewEntityId
  if OldEntityId and OldEntityId ~= NewEntityId then
    self:_SetEntityHighlighted(OldEntityId, false)
  end
end

function M:OpenFocusHighlight()
  if not self.CurrentEntityId then
    return
  end
  self:_OpenOutlinePostProcess()
  self:_SetEntityHighlighted(self.CurrentEntityId, true)
end

function M:CloseFocusHighlight()
  if self.CurrentEntityId then
    self:_SetEntityHighlighted(self.CurrentEntityId, false)
  end
  self:_ClearOutlinePostProcess()
  self.CurrentEntityId = nil
end

function M:ClearAllHighlight()
  if not self.Controller or not self.Controller.EntityHandles then
    self.CurrentEntityId = nil
    self.HighlightedEntityState = {}
    return
  end
  for EntityId, bHighlighted in pairs(self.HighlightedEntityState or {}) do
    if true == bHighlighted then
      self:_SetEntityHighlighted(EntityId, false)
    end
  end
  self.HighlightedEntityState = {}
  self.CurrentEntityId = nil
end

function M:Dispose()
  self:CloseFocusHighlight()
  self:ClearAllHighlight()
end

function M:_SetEntityHighlighted(EntityId, bHighlighted)
  if not (EntityId and self.Controller) or not self.Controller.GetEntityHandle then
    return
  end
  local CurrentState = self.HighlightedEntityState and self.HighlightedEntityState[EntityId] == true
  if CurrentState == (true == bHighlighted) then
    return
  end
  local Handle = self.Controller:GetEntityHandle(EntityId)
  if not Handle then
    return
  end
  local Actor = Handle.GetActor and Handle:GetActor() or nil
  self:_SetActorHighlighted(Actor, bHighlighted)
  local ReflectionActor = Handle.GetReflectionActor and Handle:GetReflectionActor() or nil
  self:_SetActorHighlighted(ReflectionActor, bHighlighted)
  self.HighlightedEntityState[EntityId] = true == bHighlighted
end

function M:_SetActorHighlighted(Actor, bHighlighted)
  if not Actor then
    return
  end
  local MeshComponents = self:_CollectActorMeshComponents(Actor)
  for _, Mesh in pairs(MeshComponents) do
    Mesh:SetRenderCustomDepth(true == bHighlighted)
    if true == bHighlighted then
      Mesh:SetCustomDepthStencilValue(FOCUS_STENCIL_VALUE)
    else
      Mesh:SetCustomDepthStencilValue(DEFAULT_STENCIL_VALUE)
    end
  end
end

function M:_CollectActorMeshComponents(Actor)
  local Result = {}
  local AddedMap = {}
  AppendUniqueComponent(Result, AddedMap, Actor.Mesh)
  AppendUniqueComponent(Result, AddedMap, Actor.PartsMesh)
  AppendUniqueComponent(Result, AddedMap, Actor.TailMesh)
  AppendUniqueComponent(Result, AddedMap, Actor.PoseableMesh)
  if Actor.K2_GetComponentsByClass then
    local Components = Actor:K2_GetComponentsByClass(UMeshComponent:StaticClass())
    local ComponentList = Components and Components.ToTable and Components:ToTable() or Components
    if ComponentList then
      for _, Component in pairs(ComponentList) do
        AppendUniqueComponent(Result, AddedMap, Component)
      end
    end
  end
  return Result
end

function M:_OpenOutlinePostProcess()
  if self.OutlineOpened then
    return
  end
  local Helper = self.Controller and self.Controller.ArmoryHelper or nil
  local CameraComponent = self.Controller and self.Controller.GetOutlineCameraComponent and self.Controller:GetOutlineCameraComponent() or nil
  if Helper and Helper.OpenOutline and CameraComponent then
    Helper:OpenOutline(CameraComponent)
    self.OutlineOpened = true
  end
end

function M:_ClearOutlinePostProcess()
  if not self.OutlineOpened then
    return
  end
  local Helper = self.Controller and self.Controller.ArmoryHelper or nil
  if Helper and Helper.ClearOutline then
    Helper:ClearOutline()
  end
  self.OutlineOpened = false
end

return M
