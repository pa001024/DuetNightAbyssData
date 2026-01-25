require("UnLua")
local M = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.bAutoBomb = self.UnitParams.bAutoBomb
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self:CheckAutoBomb()
end

return M
