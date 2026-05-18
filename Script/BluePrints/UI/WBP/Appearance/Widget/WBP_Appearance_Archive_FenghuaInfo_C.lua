require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.Entry = self
  if self.Content.IsSum then
    self.WS_State:SetActiveWidgetIndex(0)
    self.Text_Score:SetText(GText(self.Content.Text))
    self.Num_Now:SetText(self.Content.ScoreCur)
    self.Num_Max:SetText(self.Content.ScoreMax)
  else
    self.WS_State:SetActiveWidgetIndex(1)
    self.Text_Type:SetText(GText(self.Content.Text))
    self.Num_Now_1:SetText(self.Content.ScoreCur)
    self.Num_Max_1:SetText(self.Content.ScoreMax)
  end
end

return M
