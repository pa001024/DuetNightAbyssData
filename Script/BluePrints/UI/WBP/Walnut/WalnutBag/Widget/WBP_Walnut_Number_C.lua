require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitWalnutNumber(WalnutId)
  local WalnutData = DataMgr.Walnut[WalnutId]
  assert(WalnutData, "ZDX_核桃信息不存在：" .. WalnutId)
  local WalnutNum = WalnutData.WalnutNumber
  local WalnutIndex = WalnutData.WalnutIndex
  local WalnutType = WalnutData.WalnutType
  self.Num_Type:SetText(GText(WalnutIndex))
  self.Num_Type:SetColorAndOpacity(self["Color_" .. WalnutType])
  if WalnutNum > 99 then
    self.Num_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Num_1:SetVisibility(ESlateVisibility.Collapsed)
  end
  for i = 3, 1, -1 do
    local Num = math.floor(WalnutNum % 10)
    WalnutNum = WalnutNum / 10
    self["Num_" .. i]:SetText(Num)
    self["Num_" .. i]:SetColorAndOpacity(self["Color_" .. WalnutType])
  end
end

return M
