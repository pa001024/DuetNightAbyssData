require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitView(AccessDropConfig, AccessoryDrop)
  local OwnBoxCoinAmount = self:GetBoxCoinCount(AccessDropConfig.BoxCoinId)
  local RecourceConfig = DataMgr.Resource[AccessDropConfig.BoxCoinId]
  self.Text_Num:SetText(OwnBoxCoinAmount)
  self.Text_Coin:SetText(GText(RecourceConfig.ResourceName))
  self.Icon_Coin:SetBrushResourceObject(LoadObject(RecourceConfig.Icon))
end

function M:GetBoxCoinCount(BoxCoinId)
  local BoxCoin = GWorld:GetAvatar().Resources[BoxCoinId]
  return BoxCoin and BoxCoin.Count or 0
end

return M
