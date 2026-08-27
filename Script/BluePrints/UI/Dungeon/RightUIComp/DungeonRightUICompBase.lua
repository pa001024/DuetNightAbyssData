require("UnLua")
local M = {}

function M:New(Dependencies)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Dependencies)
  return Obj
end

function M:Init(Dependencies)
  assert(Dependencies and Dependencies.View, "DungeonRightUICompBase: View 不能为空")
  self.View = Dependencies.View
  self.WorldContext = Dependencies.WorldContext
  self.Context = nil
  self._BoundEvents = {}
  self._Active = false
end

function M:GetView()
  return self.View
end

function M:GetWorldContext()
  return self.WorldContext
end

function M:BindEvent(EventName, Handler)
  if not EventName or type(Handler) ~= "function" then
    return
  end
  EventManager:AddEvent(EventName, self, Handler)
  self._BoundEvents[EventName] = true
end

function M:UnbindEvent(EventName)
  if self._BoundEvents[EventName] then
    EventManager:RemoveEvent(EventName, self)
    self._BoundEvents[EventName] = nil
  end
end

function M:Activate(Context)
  if self._Active then
    self:Deactivate()
  end
  self.Context = Context or {}
  self._Active = true
  self.View:Reset()
  if self:OnActivate(self.Context) == false then
    self:Deactivate()
    return false
  end
  return true
end

function M:Deactivate()
  if self._Active then
    self:OnDeactivate()
  end
  if self._BoundEvents then
    for EventName in pairs(self._BoundEvents) do
      EventManager:RemoveEvent(EventName, self)
    end
  end
  self._BoundEvents = {}
  self.Context = nil
  self._Active = false
end

function M:OnActivate(Context)
end

function M:OnDeactivate()
end

function M:OnDestruct()
  self:Deactivate()
  self.View = nil
  self.WorldContext = nil
end

function M:GetCurrentValue()
  return nil
end

return M
