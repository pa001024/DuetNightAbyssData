require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:SetVisibility(ESlateVisibility.HitTestInvisible)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("WBP_Com_WaterMark_C:OnLoaded no Avatar")
    return
  end
  local Text = (...)
  Text = Text or GText("UI_Testing_Watermark")
  if self.WBP_Com_WaterMark_Item then
    self.WBP_Com_WaterMark_Item.Num_UID:SetText(tostring(Avatar.Uid))
    self.WBP_Com_WaterMark_Item.Text_Test:SetText(Text)
  end
  for i = 1, 50 do
    local WaterMark = self["WBP_Com_WaterMark_Item_" .. tostring(i)]
    if WaterMark then
      WaterMark.Num_UID:SetText(tostring(Avatar.Uid))
      WaterMark.Text_Test:SetText(Text)
    end
  end
end

return M
