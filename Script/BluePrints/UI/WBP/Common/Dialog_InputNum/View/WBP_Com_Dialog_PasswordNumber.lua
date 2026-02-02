require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:SetState(Mode, Char)
  if not self.WS_Type then
    return
  end
  if "Empty" == Mode then
    self.WS_Type:SetActiveWidgetIndex(0)
    if self.Text_Input then
      self.Text_Input:SetText("")
    end
  elseif "Masked" == Mode then
    self.WS_Type:SetActiveWidgetIndex(1)
  elseif "Visible" == Mode then
    self.WS_Type:SetActiveWidgetIndex(0)
    if self.Text_Input then
      self.Text_Input:SetText(Char or "")
    end
  end
end

return M
