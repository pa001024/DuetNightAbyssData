require("UnLua")
local M = Class()

function M:GetNiagaraIslandExtents()
  local smallExtent = FVector(3000.0, 3000.0, 1800.0)
  return {
    ["/Game/Asset/Effect/Niagara/Scene/Common/NS_ElectricGrid_Batch"] = smallExtent,
    ["/Game/Asset/Effect/Niagara/GamePlay/JiGuan/NS_SteamGrid_Loop_Batch"] = smallExtent
  }
end

return M
