require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(PaneIndex, Index, FloorId, Map)
  self.PaneIndex = PaneIndex
  self.Index = Index
  self.FloorId = FloorId
  self.Map = Map
  self.Choose:SetRenderOpacity(0)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  self.Map:OnPaneButtonDown(self)
  return UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self.Map:OnPaneButtonUp(self)
  return UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  self.Map:OnPaneButtonEnter(self)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  self.Map:OnPaneButtonLeave(self)
end

return M
