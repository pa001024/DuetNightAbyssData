require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Announcement.NewView.WBP_Announcement_CatelogBtn_C"
})

function M:InitData(SubTitleInfo)
  self.SubTitleInfo = SubTitleInfo
  self.Text_Content:SetText(SubTitleInfo.Name)
end

return M
