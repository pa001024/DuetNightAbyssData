require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self:InitData(Content)
end

function M:InitData(Content)
  self.Content = Content
  self.CurrGuildInfo = Content.CurrGuildInfo
  self.WS_Type:SetActiveWidgetIndex(Content.Type)
  if 0 == Content.Type then
    self.Text_LevelTitle:SetText(GText("UI_GuildLevel"))
    self.Text_Level:SetText(tostring(Content.CurrGuildInfo.Level or 0))
    self.Text_LevelDesc:SetText(GText("UI_GuildLvSuggestionDes"))
    self.Text_PreviewTitle:SetText(GText("UI_NextLevelPreview"))
    self.Text_PreviewDesc:SetText(GText(DataMgr.GuildLevel[self.CurrGuildInfo.Level].GuildDes))
    self.Logo:Init(self.CurrGuildInfo.LogoInfo)
    local SystemLanguage = EMCache:Get("SystemLanguage") or "CN"
    if "CN" == SystemLanguage or "TC" == SystemLanguage then
      self.Text_Lv:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Text_Lv:SetVisibility(ESlateVisibility.Collapsed)
    end
  else
    self.Text_InfoTitle:SetText(GText(Content.ItemTitle or ""))
    self.Text_InfoDesc:SetText(GText(Content.Describe or ""))
  end
end

return M
