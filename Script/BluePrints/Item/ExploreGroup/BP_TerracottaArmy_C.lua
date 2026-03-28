require("UnLua")
local M = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self.bAutoBomb = self.UnitParams.bAutoBomb
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
end

function M:CheckInCamera()
  local bShouldShow = URuntimeCommonFunctionLibrary.WasComponentRecentlyRenderedOnScreen(self.StaticMesh, 0.5)
  return bShouldShow
end

return M
