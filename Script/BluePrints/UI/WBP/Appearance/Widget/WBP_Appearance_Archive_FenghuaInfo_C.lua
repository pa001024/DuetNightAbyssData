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
    if self.Content.NumCur and self.Content.NumMax then
      self.HB_Number:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Number_Now:SetText(self.Content.NumCur)
      self.Number_Max:SetText(self.Content.NumMax)
    else
      self.HB_Number:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

return M
