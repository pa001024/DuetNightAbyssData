require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(Content)
  self.CompleteInfo = Content.Info
  self.Text_Describe:SetText("? ? ?")
end

function M:SetCompleted()
  self.Text_Describe:SetText(GText(self.CompleteInfo))
  self:PlayAnimation(self.CompletionTask)
  self:PlayAnimation(self.Refresh)
end

function M:PlayOut()
  self:PlayAnimation(self.Out)
end

return M
