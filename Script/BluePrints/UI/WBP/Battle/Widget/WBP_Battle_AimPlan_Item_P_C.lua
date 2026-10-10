require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  local bHasTag = Content.TagKey and Content.TagKey ~= ""
  self.Panel_Tag:SetVisibility(bHasTag and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  if bHasTag then
    self.WS_Tag:SetActiveWidgetIndex(1)
    self.Text_Tag:SetText(GText(Content.TagKey))
  end
  self.Key:CreateCommonKey({
    KeyInfoList = Content.KeyInfoList,
    Desc = GText(Content.KeyTextKey)
  })
end

return M
