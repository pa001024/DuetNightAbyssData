require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnFocusReceived()
  self.Input:SetIsShowGamePad(true)
  self.Input:UpdateGamePadFocusKey()
  return UIUtils.Handled
end

function M:OnFocusLost()
  self.Input:SetIsShowGamePad(false)
  self.Input:UpdateGamePadFocusKey()
end

function M:HideGamePadIcon()
  self.Input:SetIsShowGamePad(false)
  self.Input:UpdateGamePadFocusKey()
end

return M
