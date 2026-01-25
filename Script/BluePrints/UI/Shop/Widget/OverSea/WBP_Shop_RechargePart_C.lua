require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitContent(Params, PopupData, Owner)
  self.ShopItemId = Params.ShopItemId
  local ShopItemData = DataMgr.ShopItem[self.ShopItemId]
  assert(ShopItemData, "未找到商品数据:" .. self.ShopItemId)
  self.Text_RechargeTitle:SetText(string.format(GText("UI_Shop_JP_Phoxene"), ShopItemData.TypeNum))
  local Icon = ItemUtils.GetItemIcon(ShopItemData.TypeId, ShopItemData.ItemType)
  self.Image_Icon:SetBrushResourceObject(Icon)
end

return M
