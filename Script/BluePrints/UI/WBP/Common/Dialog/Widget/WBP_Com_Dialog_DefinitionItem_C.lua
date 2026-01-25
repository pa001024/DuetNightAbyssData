require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Bg_List:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:OnListItemObjectSet(Content)
  self.Widget = Content.Widget
  self.Text_Name:SetText(Content.Name)
  self.Text_Definition:SetText(Content.Des)
end

function M:SetHighLight(IsHighLight)
  if IsHighLight then
    self:PlayAnimation(self.Scanline)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:Destruct()
end

return M
