require("UnLua")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local ItemTypeEnum = ComRankingUtils.ItemType

function M:OnListItemObjectSet(Content)
  Content = Content or {}
  self.Content = Content
  self.ParentWidget = Content.ParentWidget
  self.ItemType = Content.ItemType
  self.Switcher:SetActiveWidgetIndex(self.ItemType)
  if self.ItemType == ItemTypeEnum.Squad then
    self.ActiveWidget = self.Player_1 or self.Myself_1
  else
    self.ActiveWidget = self.Player_2 or self.Myself_2
  end
  self.ActiveWidget:OnListItemObjectSet(Content)
  if not Content.Empty then
    self:InitNavigation()
  end
end

function M:InitNavigation()
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function M:HandleNavigationUp()
  local Content = self.Content
  local ParentWidget = Content and Content.ParentWidget
  local RankInfo = Content and Content.RankInfo
  if not (RankInfo and RankInfo.RankNum and ParentWidget) or not ParentWidget.List_Ranking then
    return nil
  end
  local CurIndex = RankInfo.RankNum - 1
  if CurIndex > 0 then
    local NewIndex = CurIndex - 1
    ParentWidget.List_Ranking:NavigateToIndex(NewIndex)
    if ParentWidget.OnListRankItemClicked then
      local NewContent = ParentWidget:GetRankItemContentByIndex(NewIndex)
      if NewContent and not NewContent.Empty then
        ParentWidget:OnListRankItemClicked(NewContent, true)
      end
    end
    return UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ParentWidget.List_Ranking, NewIndex)
  end
  return self
end

function M:HandleNavigationDown()
  local Content = self.Content
  local ParentWidget = Content and Content.ParentWidget
  local RankInfo = Content and Content.RankInfo
  if not (RankInfo and RankInfo.RankNum and ParentWidget) or not ParentWidget.List_Ranking then
    return nil
  end
  local CurIndex = RankInfo.RankNum - 1
  local MaxIndex = ParentWidget.ValidItemNum - 1
  if CurIndex < MaxIndex then
    local NewIndex = CurIndex + 1
    ParentWidget.List_Ranking:NavigateToIndex(NewIndex)
    if ParentWidget.OnListRankItemClicked then
      local NewContent = ParentWidget:GetRankItemContentByIndex(NewIndex)
      if NewContent and not NewContent.Empty then
        ParentWidget:OnListRankItemClicked(NewContent, true)
      end
    end
    return UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ParentWidget.List_Ranking, NewIndex)
  end
  return self
end

function M:BP_OnEntryReleased()
  if self.ActiveWidget then
    self.ActiveWidget:BP_OnEntryReleased()
  end
  self.ItemType = nil
  self.ActiveWidget = nil
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Parent = self.Content and self.Content.ParentWidget
  if Parent and Parent.IsGamePad then
    Parent:OnListRankItemClicked(self.Content, true)
  end
  return UIUtils.Handled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.ActiveWidget and self.ActiveWidget.OnPreviewKeyDown then
    return self.ActiveWidget:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
