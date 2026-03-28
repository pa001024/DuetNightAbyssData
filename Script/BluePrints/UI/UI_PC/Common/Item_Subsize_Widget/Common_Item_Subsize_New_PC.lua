require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self:UpdateLanguageBasedUI()
end

function M:SetEnable(IsOn)
  local Visibility = IsOn and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed
  self:SetVisibility(Visibility)
end

function M:UpdateLanguageBasedUI()
  local Language = self:GetCurrentLanguage()
  local text
  if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.TC then
    text = DataMgr.TextMap_ContentEN.UI_NEW.ContentEN
  else
    text = GText("UI_NEW")
  end
  self.Text_New:SetText(text)
end

function M:GetCurrentLanguage()
  return CommonConst.SystemLanguage
end

return M
