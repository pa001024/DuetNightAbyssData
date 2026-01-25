require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.RaidDungeonBuffData = Content.RaidDungeonBuffData
  self:InitItemContent()
end

function M:InitItemContent()
  local RaidBuffDes = self.RaidDungeonBuffData.RaidBuffDes
  local RaidBuffParameter = self.RaidDungeonBuffData.RaidBuffParameter
  local BuffDes = UIUtils.GenAbyssEntryDesc(GText(RaidBuffDes), RaidBuffParameter, 0)
  self.Text:SetText(GText(BuffDes))
end

return M
