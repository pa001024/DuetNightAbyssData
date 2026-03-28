require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  if Content.Data then
    if Content.Data.SoloTreasureIconType then
      self.Icon_Location:SetBrushFromTexture(LoadObject(Content.Data.SoloTreasureIconType))
    end
    self.Text_Name:SetText(GText(Content.Data.SoloTreasureIconText))
  end
end

return M
