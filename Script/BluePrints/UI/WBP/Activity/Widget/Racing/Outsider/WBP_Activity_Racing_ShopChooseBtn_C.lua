require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnMouseEnter(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseEnter: ")
  self.IsHovering = true
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseLeave: ")
  self.IsHovering = false
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseButtonDown: ")
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self:PlayAnimation(self.Click)
end

return M
