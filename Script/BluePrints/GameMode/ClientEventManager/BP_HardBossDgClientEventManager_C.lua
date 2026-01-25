require("UnLua")
local M = Class({
  "BluePrints.GameMode.ClientEventManager.BP_BaseClientEventManager_C"
})

function M:OnClientInit()
  local DungeonInfo = DataMgr.HardBossDg[GameState(self).DungeonId]
  if DungeonInfo then
    self.HardBossId = DungeonInfo.HardBossId or 0
  end
  self.Overridden.OnClientInit(self)
end

return M
