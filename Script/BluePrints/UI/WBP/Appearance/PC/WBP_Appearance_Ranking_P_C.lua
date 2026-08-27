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
  self.NormalBottomKeyInfo = {
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_CTL_PositionPlayer"),
      bLongPress = false
    },
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_Check"),
      bLongPress = false
    },
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "RH"}
      },
      Desc = GText("UI_CTL_RotatePreview")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
  self.TabConfigData = {
    TitleName = GText("UI_AppearanceScore_RankList"),
    LeftKey = "Q",
    RightKey = "E",
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    BottomKeyInfo = self.NormalBottomKeyInfo
  }
  local TabWidget = self.Com_Tab or self.Tab
  if TabWidget then
    TabWidget:Init(self.TabConfigData, true)
  end
end

function M:UpdateTapBottomKeyInfo(IsMenuOpened)
  if not self.MenuBottomKeyInfo then
    self.MenuBottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  end
  local TabWidget = self.Com_Tab or self.Tab
  if not TabWidget or not TabWidget.UpdateBottomKeyInfo then
    return
  end
  if IsMenuOpened then
    TabWidget:UpdateBottomKeyInfo(self.MenuBottomKeyInfo)
  else
    TabWidget:UpdateBottomKeyInfo(self.NormalBottomKeyInfo)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Right" == InKeyName then
      self:CloseSelf()
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      self:OnMyselfButtonClicked()
    end
  elseif "Escape" == InKeyName then
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
