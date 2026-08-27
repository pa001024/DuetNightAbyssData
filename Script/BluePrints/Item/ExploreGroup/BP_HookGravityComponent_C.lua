local M = Class()

function M:ReceiveBeginPlay()
  local Owner = self:GetOwner()
  if Owner and Owner.RegisterOpenMechanismCallback then
    Owner:RegisterOpenMechanismCallback(self, self.OnHookOpenMechanism)
  end
end

function M:ReceiveEndPlay()
  local Owner = self:GetOwner()
  if Owner and Owner.UnregisterOpenMechanismCallback then
    Owner:UnregisterOpenMechanismCallback(self)
  end
end

function M:OnHookOpenMechanism(HookActor)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    local DownVector = self:GetUpVector() * -1
    print(_G.LogTag, "BP_HookGravityComponent SetGlobalGravityDirection", self:GetName(), "DownVector:", DownVector.X, DownVector.Y, DownVector.Z)
    GameMode:SetGlobalGravityDirection(DownVector)
  end
end

return M
