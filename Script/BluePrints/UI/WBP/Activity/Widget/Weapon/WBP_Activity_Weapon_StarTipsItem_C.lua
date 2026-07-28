require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    return
  end
  self.Ws_Star:SetActiveWidgetIndex(Content.IsReached and 0 or 1)
  self.TextTips:SetText(Content.CondText or "")
end

return M
