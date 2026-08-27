require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr"
})

function M:InitGuildStructUI()
  self.GameUI = nil
  self.ComponentEdit = nil
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.GuildManager:InitConstructSettings()
  self.GameUI = UIManager(self):LoadUINew("GuildConstructionMain")
end

function M:CancelSelect()
  if self.GuildManager and self.GuildManager.CancelExecuteOperation then
    self.GuildManager:CancelExecuteOperation()
  end
end

function M:OnCancelSelect()
  if self.GameUI then
    self.GameUI:OnCancelSelect()
  end
end

return M
