require("UnLua")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")
local ShareItemDefinitions = {
  {
    ChannelType = ChatCommon.ChannelDef.TeamUp,
    TitleTextKey = "UI_TeamShareToRecruitChannel"
  },
  {
    ChannelType = ChatCommon.ChannelDef.InGuild,
    TitleTextKey = "UI_TeamShareToGuildChannel"
  }
}

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  local ShareParams = Params or {}
  self.Share_Item_1:Init(ShareItemDefinitions[1].ChannelType, ShareItemDefinitions[1].TitleTextKey, ShareParams.RecruitmentData, ShareParams.OnShareRequested)
  self.Share_Item_2:Init(ShareItemDefinitions[2].ChannelType, ShareItemDefinitions[2].TitleTextKey, ShareParams.RecruitmentData, ShareParams.OnShareRequested)
  self:InitNavigation()
end

function M:InitNavigation()
  local RecruitItem = self.Share_Item_1
  local GuildItem = self.Share_Item_2
  RecruitItem:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  RecruitItem:SetNavigationRuleExplicit(UE4.EUINavigation.Down, GuildItem)
  RecruitItem:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  RecruitItem:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  GuildItem:SetNavigationRuleExplicit(UE4.EUINavigation.Up, RecruitItem)
  GuildItem:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
  GuildItem:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  GuildItem:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
end

function M:RefreshShareItemGamepadKeyVisibility(FocusedItem)
  for _, ShareItem in ipairs({
    self.Share_Item_1,
    self.Share_Item_2
  }) do
    if ShareItem and ShareItem.SetGamepadKeyVisible then
      ShareItem:SetGamepadKeyVisible(ShareItem == FocusedItem)
    end
  end
end

function M:InitGamepadView()
  self:ShowGamepadCloseBtn(true)
  self:ChangeCloseShortKeyText(GText("UI_Tips_Close"))
  local FocusedItem = self:HandleDialogFocused()
  if FocusedItem then
    FocusedItem:SetFocus()
  end
  self:RefreshShareItemGamepadKeyVisibility(FocusedItem)
end

function M:InitKeyboardView()
  self:RefreshShareItemGamepadKeyVisibility(nil)
end

function M:HandleDialogFocused()
  return self.Share_Item_1
end

function M:BP_GetDesiredFocusTarget()
  return self:HandleDialogFocused()
end

return M
