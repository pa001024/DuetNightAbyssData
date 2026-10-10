require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.Widget = self
  self:InitUI()
end

function M:Update(Content)
  self.Content = Content
  self.Content.Widget = self
  self:InitUI()
end

function M:InitUI()
  self.Text_Desc:SetText(self.Content.Text)
  if self.Content.IsFinish then
    self.WS_Type:SetActiveWidgetIndex(1)
  else
    self.WS_Type:SetActiveWidgetIndex(0)
  end
end

return M
