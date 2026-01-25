require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClickShop)
end

function M:OnClickShop()
  UIManager(self):LoadUINew("ShopActivity", nil, nil, nil, "HuaxuEventShop")
end

return M
