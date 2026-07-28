require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
end

function M:OnPressed()
  if self.OwnerLeftBtn and self.OwnerLeftBtn.bPanelOpen then
    return
  end
  self.bWalkPressed = true
  local OwnerPanel = self.OwnerPanel
  if not IsValid(OwnerPanel) then
    return
  end
  OwnerPanel:TryToPlayTargetCommand("SwitchWalk", false)
end

function M:OnReleased()
  if not self.bWalkPressed then
    return
  end
  self.bWalkPressed = false
  local OwnerPanel = self.OwnerPanel
  if not IsValid(OwnerPanel) then
    return
  end
  OwnerPanel:TryToStopTargetCommand("SwitchWalk", false)
end

function M:Destruct()
end

AssembleComponents(M)
return M
