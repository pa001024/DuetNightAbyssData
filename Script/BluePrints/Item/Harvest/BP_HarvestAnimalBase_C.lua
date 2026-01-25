require("UnLua")
local M = Class("BluePrints.Item.Harvest.BP_HarvestBase_C")

function M:GetCanOpen(PlayerEid)
  self.Overridden.GetCanOpen(self, PlayerEid)
end

return M
