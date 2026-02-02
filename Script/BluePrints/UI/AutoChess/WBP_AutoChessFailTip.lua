require("UnLua")
local WBP_Activity_AutoChess_SettlementFailTip_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function WBP_Activity_AutoChess_SettlementFailTip_C:OnListItemObjectSet(Content)
  self.Text_Tip:SetText(Content.Text)
end

return WBP_Activity_AutoChess_SettlementFailTip_C
