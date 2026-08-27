require("UnLua")
local M = Class({
  "BluePrints.Item.MonsterSpawn.BP_MonsterNestBase_C"
})

function M:GetCanOpen(PlayerId)
  self.CanOpen = true
end

return M
