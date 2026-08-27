require("UnLua")
local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Refresh()
  local State = MoneyTreeMgr.GetState()
  if self.Text_Num then
    self.Text_Num:SetText(tostring(State.Cumulative))
  end
  if self.Text_Hint then
    self.Text_Hint:SetText(GText("UI_Cumulative_Reward"))
  end
end

return M
