require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local DEFAULT_TITLE_TEXT_ID = "UI_AppearanceCollect_AppearanceCollectTask"

function M:SetTitle(TitleText)
  if self.Text_Title then
    self.Text_Title:SetText(TitleText)
  end
end

function M:RefreshTitle(TitleTextId)
  self:SetTitle(GText(TitleTextId or DEFAULT_TITLE_TEXT_ID))
end

return M
