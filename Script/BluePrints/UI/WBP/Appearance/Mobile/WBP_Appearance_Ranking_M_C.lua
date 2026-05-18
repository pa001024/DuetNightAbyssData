require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Appearance.Widget.WBP_Appearance_RankingBase"
})

function M:Construct()
  self.Super.Construct(self)
end

function M:Destruct()
  self.Super.Destruct(self)
end

function M:InitCommonTab()
  self.TabConfigData = {
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    TitleName = GText("UI_AppearanceScore_RankList"),
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  }
  local TabWidget = self.Com_Tab or self.Tab
  if TabWidget then
    TabWidget:Init(self.TabConfigData, true)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName then
    self:CloseSelf()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived()
  local LastItem = self.LastClickedItem
  if LastItem and LastItem.SelfWidget then
    self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
  elseif self.IsGamePad and self.ValidItemNum and self.ValidItemNum > 0 then
    self.List_Ranking:NavigateToIndex(0)
  end
  return UIUtils.Handled
end

return M
