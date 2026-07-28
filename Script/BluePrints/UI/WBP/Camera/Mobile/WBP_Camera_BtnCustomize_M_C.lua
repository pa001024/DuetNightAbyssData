require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:RefreshInputStyle()
  if self.WS_Type and self.WS_Type.SetActiveWidgetIndex then
    self.WS_Type:SetActiveWidgetIndex(0)
  end
end

return M
