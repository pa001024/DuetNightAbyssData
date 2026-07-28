require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
  self.GuildName = nil
end

function M:Construct()
end

function M:InitializeGuildInfo(GuildName, GuildFlag)
  self.GuildName = GuildName
  self.Text_Name:SetText(GuildName)
  self.GuildFlag = GuildFlag
  self.Logo:Init(GuildFlag)
end

return M
