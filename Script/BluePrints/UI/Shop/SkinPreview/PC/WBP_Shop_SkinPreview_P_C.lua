require("UnLua")
local M = Class("BluePrints.UI.Shop.SkinPreview.WBP_Shop_SkinPreview_Base_C")

function M:Construct()
  M.Super.Construct(self)
  self.MenuKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    },
    Desc = GText("UI_CTL_ExplainSet")
  }
  self.ReplayKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(self.RKey),
        ClickCallback = self.OnReplayGesture,
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    },
    Desc = GText("UI_Replay"),
    bLongPress = false
  }
  self.RideKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(self.RKey),
        ClickCallback = self.OnRideMount,
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    },
    Desc = GText("UI_CTL_Ride"),
    bLongPress = false
  }
  self.Btn_Function:SetDefaultGamePadImg("A")
  self.Com_Hint:SetDefaultGamePadImg("A")
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
  self.Key_BtnChoose:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
  self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
  self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
  self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
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
  if self.IsGamepadInput then
    self.Key_GamePad_L:SetVisibility((self.bFirst or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    self.Key_GamePad_R:SetVisibility((self.bLast or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    if self.ShopItemData.SuitRewardId then
      self.Tab_Skin:UpdateSingleBottomKeyInfo(1, self.MenuKeyInfoList)
      self.Tab_Skin:SetSingleBottomKeyInfoVisibility(1, ESlateVisibility.SelfHitTestInvisible)
      self.Key_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Tab_Skin:UpdateSingleBottomKeyInfo(1, {})
      self.Tab_Skin:SetSingleBottomKeyInfoVisibility(1, ESlateVisibility.Collapsed)
      self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.ShopItemData.ItemType == "Skin" or self.ShopItemData.ItemType == "WeaponSkin" then
      self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Key_Dye_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.BtnChooseGiftEnable then
      self.Gift_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.EnableDrag == false then
      self:HideDragKey(true)
    else
      self:HideDragKey(false)
    end
  end
  if false == self.ActorController.ArmoryHelper.EnableCameraScrolling or false == self.EnableMouseWheel then
    self:HideZoomKey(true)
  else
    self:HideZoomKey(false)
  end
end

function M:UpdateReplayTips()
  self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)
  if self.ShopItemData.ItemType == "Resource" or self.ShopItemData.ItemType == "Mount" then
    self.KeyDownEvents[self.GamePadOpenSuitKey] = self.OnRKeyDown
    self:HideReplayKey(false)
  else
    self.KeyDownEvents[self.GamePadOpenSuitKey] = self.OnClickSuitPreview
    self:HideReplayKey(true)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.ActorController.ArmoryHelper.EnableCameraScrolling == false or false == self.EnableMouseWheel then
    self:HideZoomKey(true)
  else
    self:HideZoomKey(false)
  end
  if self.ShopItemData.ItemType ~= "Resource" and self.ShopItemData.ItemType ~= "Mount" then
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
    if self.BtnChooseGiftEnable then
      self.Gift_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
    if false == self.EnableDrag then
      self:HideDragKey(true)
    else
      self:HideDragKey(false)
    end
  else
    if self.ShopItemData.SuitRewardId then
      self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
      self.Btn_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Preview:SetVisibility(ESlateVisibility.Collapsed)
    self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:HideDragKey(IsHidden)
  if IsHidden then
    self.Tab_Skin:UpdateSingleBottomKeyInfo(5, {})
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(5, ESlateVisibility.Collapsed)
  else
    self.Tab_Skin:UpdateSingleBottomKeyInfo(5, self.RightThumbstickAnalogBottomKeyInfoList)
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(5, ESlateVisibility.SelfHitTestInvisible)
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
    self.Tab_Skin:UpdateSingleBottomKeyInfo(2, {})
    if self.ShopItemData.ItemType == "Mount" then
      self.Tab_Skin:UpdateSingleBottomKeyInfo(2, self.RideKeyInfoList)
    elseif self.ShopItemData.TypeId then
      local ResourceData = DataMgr.Resource[self.ShopItemData.TypeId]
      if ResourceData and ResourceData.ResourceSType == "GestureItem" then
        self.Tab_Skin:UpdateSingleBottomKeyInfo(2, self.ReplayKeyInfoList)
      end
    end
    self.Tab_Skin:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.SelfHitTestInvisible)
  end
end

return M
