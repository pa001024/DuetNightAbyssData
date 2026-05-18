require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(Params)
  rawset(self, "Params", Params)
  self.Text_Entrance:SetText(Params.Text)
end

function M:OnBtnClicked()
  if self.Params.OnBtnClicked then
    self.Params.OnBtnClicked(self.Params.Owner)
  end
end

function M:OnAddedToFocusPath()
  if self.Params.OnAddedToFocusPath then
    self.Params.OnAddedToFocusPath(self)
  end
end

function M:OnRemovedFromFocusPath()
  if self.Params.OnRemovedFromFocusPath then
    self.Params.OnRemovedFromFocusPath(self)
  end
end

function M:SetReddotVisible(bVisible)
  if bVisible then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
