require("UnLua")
local M = Class("BluePrints.UI.WBP.MiniGame.WBP_MiniGame_Hammer_Base")

function M:InitPlatform()
  self.Bar.WS_Mode:SetActiveWidgetIndex(0)
  self.Btn_Start.WS_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Btn_Crack.WS_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.MobileComboInputIndex = 1
end

function M:GetHammerStartTextMap()
  return "Hammer_StartClick"
end

function M:GetHammerInputTipTextMap()
  return "Hammer_Click"
end

function M:HandleStartedHammerButton()
  if not self.bHammerInputEnabled or self.bHammerInputLocked then
    return
  end
  local InputKey = self.CurrentComboKeys[self.MobileComboInputIndex or 1]
  if InputKey then
    self:SubmitHammerInput(InputKey)
  end
end

function M:RefreshComboKeyHints()
  self.MobileComboInputIndex = 1
end

function M:UpdateHammerComboInput(InputKey, bPressed)
  M.Super.UpdateHammerComboInput(self, InputKey, bPressed)
  if bPressed then
    self.MobileComboInputIndex = (self.MobileComboInputIndex or 1) + 1
  end
end

return M
