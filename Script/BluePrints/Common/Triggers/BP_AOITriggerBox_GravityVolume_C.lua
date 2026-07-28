require("UnLua")
local M = Class("BluePrints.Common.Triggers.BP_AOITriggerBox_C")

function M:Initialize(Initializer)
  M.Super.Initialize(self, Initializer)
  self.GravityOverlapCount = 0
  self.PreviousGravityDirection = nil
end

function M:BeginOverlapExecLogic()
  self.GravityOverlapCount = (self.GravityOverlapCount or 0) + 1
  if 1 == self.GravityOverlapCount then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
      self.PreviousGravityDirection = GameMode:GetGlobalGravityDirection()
      local DownVector = self:GetActorUpVector() * -1
      print(_G.LogTag, "GravityVolume SetGlobalGravityDirection", self:GetName(), "Old:", self.PreviousGravityDirection.X, self.PreviousGravityDirection.Y, self.PreviousGravityDirection.Z, "New(Down):", DownVector.X, DownVector.Y, DownVector.Z)
      GameMode:SetGlobalGravityDirection(DownVector)
    end
  end
end

function M:EndOverlapExecLogic()
end

return M
