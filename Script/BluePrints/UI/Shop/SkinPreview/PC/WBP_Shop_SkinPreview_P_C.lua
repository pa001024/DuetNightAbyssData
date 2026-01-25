require("UnLua")
local M = Class("BluePrints.UI.Shop.SkinPreview.WBP_Shop_SkinPreview_Base_C")

function M:Construct()
  M.Super.Construct(self)
  self.Btn_Function:SetDefaultGamePadImg("A")
  self.Key_GamePad_L:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Left"}
    }
  })
  self.Key_GamePad_R:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Right"}
    }
  })
  self.Key_Preview:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.Key_Dye_GamePad:CreateSubKeyDesc({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    },
    Type = "Img",
    Desc = GText("UI_SkinPreview_Dye")
  })
  self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
  self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
  self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
end

function M:InitKeySetting()
  M.Super.InitKeySetting(self)
  self.BottomKeyInfo = {}
  table.insert(self.BottomKeyInfo, self.MenuKeyInfoList)
  table.insert(self.BottomKeyInfo, self.ReplayKeyInfoList)
  table.insert(self.BottomKeyInfo, self.HideUI_KeyInfoList)
  table.insert(self.BottomKeyInfo, self.ZoomKeyInfoList)
  table.insert(self.BottomKeyInfo, self.RightThumbstickAnalogBottomKeyInfoList)
  table.insert(self.BottomKeyInfo, self.ESCKeyInfoList)
  self.Tab_Skin:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:UpdateUI()
  M.Super.UpdateUI(self)
end

function M:UpdateReplayTips()
  self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)
  if self.ShopItemData.ItemType == "Resource" then
    self.KeyDownEvents[self.GamePadOpenSuitKey] = self.OnReplayGesture
    self:HideReplayKey(false)
  else
    self.KeyDownEvents[self.GamePadOpenSuitKey] = self.OnClickSuitPreview
    self:HideReplayKey(true)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.ActorController.ArmoryHelper.EnableCameraScrolling == false then
    self:HideZoomKey(true)
  else
    self:HideZoomKey(false)
  end
  if self.ShopItemData.ItemType ~= "Resource" then
    self:HideReplayKey(true)
  else
    self:HideReplayKey(false)
  end
  self.WS_Btn_Dye:SetActiveWidgetIndex(self.IsGamepadInput and 1 or 0)
  if self.IsGamepadInput then
    if self.ShopItemData.SuitRewardId then
      self.Tab_Skin:UpdateSingleBottomKeyInfo(1, self.MenuKeyInfoList)
      self.Key_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Tab_Skin:UpdateSingleBottomKeyInfo(1, {})
    end
    if self.ShopItemData.ItemType == "WeaponSkin" or self.ShopItemData.ItemType == "Skin" then
      self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
    if not self.bFirst and not self.ShopItemData.SinglePreview then
      self.Key_GamePad_L:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if not self.bLast and not self.ShopItemData.SinglePreview then
      self.Key_GamePad_R:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  else
    if self.ShopItemData.SuitRewardId then
      self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
      self.Btn_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:HideZoomKey(IsHidden)
  if IsHidden then
    self.Tab_Skin:UpdateSingleBottomKeyInfo(4, {})
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(4, ESlateVisibility.Collapsed)
  else
    self.Tab_Skin:UpdateSingleBottomKeyInfo(4, self.ZoomKeyInfoList)
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(4, ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:HideReplayKey(IsHidden)
  if IsHidden then
    self.Tab_Skin:UpdateSingleBottomKeyInfo(2, {})
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.Collapsed)
  else
    self.Tab_Skin:UpdateSingleBottomKeyInfo(2, self.ReplayKeyInfoList)
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.SelfHitTestInvisible)
  end
end

return M
