require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(Index, Hour, bInDay)
  self.Index = Index
  self.Night = bInDay
  self.Text_Before:SetText(Hour .. ":00")
  self.Text_Now:SetText(Hour .. ":00")
  self.Text_After:SetText(Hour .. ":00")
  self:SetDayAndNight(bInDay)
end

return M
