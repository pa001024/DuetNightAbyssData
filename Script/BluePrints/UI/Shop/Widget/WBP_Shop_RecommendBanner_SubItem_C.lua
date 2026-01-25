require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.LastTime = Content.LastTime
  self:ResetItem()
  if Content.NeedStartTick then
    self:StartTick()
  else
    self:ResetItem()
  end
end

function M:Destruct()
  self:CleanTimer()
  self.Super.Destruct(self)
end

function M:StartTick()
  self:PlayAnimation(self.In)
  self.Image_Progress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:ResetItem()
  self.Image_Progress:SetVisibility(ESlateVisibility.Collapsed)
end

return M
