require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr"
})

function M:InitGuildStructUI()
  self.UIManager = nil
  self.GameUI = nil
  self.UIManager = UIManager(self)
  self.GameUI = self.UIManager:LoadUINew("GuildMainTest", "GuildMainTest")
end

function M:OnCancelSelect()
  self.GameUI:OnCancelSelect()
end

return M
