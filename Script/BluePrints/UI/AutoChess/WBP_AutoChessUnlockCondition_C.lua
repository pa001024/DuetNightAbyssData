require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local LevelState = {
  Pass = 0,
  UnPass = 1,
  UnLock = 2
}

function M:OnListItemObjectSet(Content)
  Content.UI = self
  if Content.success then
    self.WS_Icon:SetActiveWidgetIndex(1)
  else
    self.WS_Icon:SetActiveWidgetIndex(0)
  end
  self.Text_Condition:SetText(Content.Text)
end

return M
