require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}

function M:Construct()
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
end

function M:OnPressed()
  if self.OwnerLeftBtn and self.OwnerLeftBtn.bPanelOpen then
    return
  end
  local OwnerPanel = self.OwnerPanel
  if not IsValid(OwnerPanel) then
    return
  end
  OwnerPanel:TryToPlayTargetCommand("SwitchCrouch", false)
  OwnerPanel:TryToStopTargetCommand("SwitchCrouch", false)
end

function M:Destruct()
end

AssembleComponents(M)
return M
