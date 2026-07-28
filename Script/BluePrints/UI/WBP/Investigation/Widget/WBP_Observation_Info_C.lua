require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(Content)
  self.CompleteInfo = Content.Info
  self.WS_State:SetActiveWidgetIndex(0)
  self.Text_Info:SetText("? ? ?")
end

function M:SetCompleted()
  self.WS_State:SetActiveWidgetIndex(1)
  self.Text_Info:SetText(self.CompleteInfo)
end

return M
