require("UnLua")
local BP_EntangleComponent_C = Class()

function BP_EntangleComponent_C:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self.Owner = self:GetOwner()
end

function BP_EntangleComponent_C:InitComponent()
  self.Owner:RegisterCheckForbidEvent(self, self.CheckForbidden)
  if self.Owner.UnitParams then
    self.EntangleStateId = self.Owner.UnitParams.EntangleStateId
  end
  if self.Owner.CombatStateChangeComponent then
    self.Owner.CombatStateChangeComponent.OnStateEventEnter:Add(self, self.OnEnterState)
  end
end

function BP_EntangleComponent_C:CheckForbidden(PlayerActor)
  return self.Owner.StateId == self.EntangleStateId
end

function BP_EntangleComponent_C:OnEnterState(StateId)
  if StateId ~= self.EntangleStateId then
    return
  end
  DebugPrint("BP_EntangleComponent_C: Enter Entangle State!")
  if self.Owner.ChestInteractiveComponent then
    self.Owner.ChestInteractiveComponent:InitInteractiveComponent(self.Owner.Data.InteractiveId)
  end
  if self.OnEnterEntangleState:IsBound() then
    self.OnEnterEntangleState:Broadcast()
  end
end

function BP_EntangleComponent_C:ReceiveEndPlay(...)
  self.Overridden.ReceiveEndPlay(self, ...)
  if self.Owner.CombatStateChangeComponent then
    self.Owner.CombatStateChangeComponent.OnStateEventEnter:Remove(self, self.OnEnterState)
  end
  self.Owner:UnRegisterCheckForbidEvent(self)
end

return BP_EntangleComponent_C
