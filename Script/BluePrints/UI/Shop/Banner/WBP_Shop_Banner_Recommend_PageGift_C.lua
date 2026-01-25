require("UnLua")
local M = Class({
  "BluePrints.UI.Shop.Banner.WBP_Shop_Banner_Base_C",
  "BluePrints.Common.DelayFrameComponent"
})
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")

function M:Construct()
  M.Super.Construct(self)
  self.Image_Hit:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.BannerTabItem = {
    self.PageGift_SubItem.SubHeadItem_1,
    self.PageGift_SubItem.SubHeadItem_2,
    self.PageGift_SubItem.SubHeadItem_3
  }
  self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.RefreshTimerName = "WBP_Shop_Banner_Recommend_PageGift_RefreshLeftTime"
  self.Btn_Pay:SetGamePadIconVisible(true)
  self.Btn_Pay:UnBindEventOnClicked(self, self.OnBuyBtnClicked)
  self.Btn_Pay:BindEventOnClicked(self, self.OnBuyBtnClicked)
  self.Btn_Pay.Key_ControllerBuy:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.PageGift_SubItem.Key_Left:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Left"}
    }
  })
  self.PageGift_SubItem.Key_Right:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Right"}
    }
  })
  self.Com_BtnExplanation.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
  self.Key_QA:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  self.Btn_Qa:UnBindEventOnClicked(self, self.OnGoToCharDetails)
  self.Btn_Qa:BindEventOnClicked(self, self.OnGoToCharDetails)
  self.Key_Reward.Text_Desc:SetText(GText("UI_Controller_CheckReward"))
  self.Key_Reward:CreateSubKeyDesc({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Type = "Img"
  })
end

function M:Destruct()
  if self.Btn_Qa then
    self.Btn_Qa:UnBindEventOnClicked(self, self.OnGoToCharDetails)
  end
  if self.Btn_Pay then
    self.Btn_Pay:UnBindEventOnClicked(self, self.OnBuyBtnClicked)
  end
  self:CleanTimer()
  M.Super.Destruct(self)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self:UpdateGamePadKeyInfo()
end

function M:InitBannerPage(BannerId, ParentWidget)
  self.BannerData = DataMgr.ShopBannerTab[BannerId]
  if BannerId and self.BannerData.Id and self.BannerData.Id == BannerId and ParentWidget then
    self.BannerId = BannerId
    self.Parent = ParentWidget
  else
    return
  end
  self.Parent.Group_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Parent:SetCameraToPreviewActor()
  self.Parent:SetAllowedToShowHideUI(false)
  for i = 1, #self.BannerTabItem do
    self.BannerTabItem[i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitPageGiftUI()
end

function M:InitPageGiftUI(TabId)
  self.DailyPackShopItemList = ShopUtils:GetDailyPackShopItemInfo(self.BannerId)
  if 0 == #self.DailyPackShopItemList then
    UIManager(self):ShowUITip("CommonToastMain", GText("GACHA_Toast_Nona"), 2)
    self:AddTimer(0.1, function()
    end)
    return
  end
  local currentTabId = self.Parent.BannerTabStates[self.BannerId]
  currentTabId = currentTabId or 1
  if currentTabId > #self.DailyPackShopItemList or currentTabId < 1 then
    currentTabId = 1
  end
  self.Parent.BannerTabStates[self.BannerId] = currentTabId
  self.TabId = currentTabId
  if not self.TabId then
    UIManager(self):ShowUITip("CommonToastMain", GText("GACHA_Toast_Nona"), 2)
    self:AddTimer(0.1, function()
      self:Close()
    end)
  end
  self:PlayAnimation(self.In)
  self:FillPageGiftItem()
end

function M:FillPageGiftItem()
  local ItemCount = #self.DailyPackShopItemList
  if ItemCount <= 1 then
    self.PageGift_SubItem.HB_Head:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:OnPageGiftItemClick(1, nil)
  else
    self.PageGift_SubItem.HB_Head:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    for i = 1, ItemCount do
      local DailyPackShopItemInfo = self.DailyPackShopItemList[i]
      self.BannerTabItem[i]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      local DailyPackData = DataMgr.DailyPack[DailyPackShopItemInfo.TypeId]
      assert(DailyPackData, "分日礼包信息不存在:" .. DailyPackShopItemInfo.TypeId)
      local Content = {}
      Content.TabId = i
      Content.CharId = DailyPackData.BannerCharId
      Content.ClickEvent = {
        Obj = self,
        Callback = self.OnPageGiftItemClick
      }
      if self.TabId == Content.TabId then
        Content.bIsSelected = true
      else
        Content.bIsSelected = false
      end
      self.BannerTabItem[i]:Init(Content, self)
    end
  end
  self:UpdateGamePadKeyInfo()
end

function M:OnPageGiftItemClick(TabId, Content)
  if self.LastWidgetContent and self.LastWidgetContent.TabId ~= TabId then
    self.LastWidgetContent:UnSelect()
  end
  self.LastWidgetContent = Content
  self.TabId = TabId
  self.Parent.BannerTabStates[self.BannerId] = TabId
  local ShopItemInfo = self.DailyPackShopItemList[self.TabId]
  if not ShopItemInfo then
    return
  end
  self.SoldOut = 0 == ShopUtils:GetShopItemPurchaseLimit(ShopItemInfo.ItemId)
  local Avatar = GWorld:GetAvatar()
  self.Effective = Avatar and Avatar:CheckIsEffective(ShopItemInfo.ItemId)
  if not self:IsAnimationPlaying(self.In) then
    self:PlayAnimation(self.Change)
  end
  self:RefreshDailyPackInfo()
end

function M:RefreshDailyPackInfo()
  local ShopItemInfo = self.DailyPackShopItemList[self.TabId]
  if not ShopItemInfo then
    return
  end
  local DailyPackData = DataMgr.DailyPack[ShopItemInfo.TypeId]
  if not DailyPackData then
    return
  end
  assert(DailyPackData, "分日礼包信息不存在:" .. ShopItemInfo.TypeId)
  self:RefreshCharModel(DailyPackData)
  self:RefreshPageGiftInfo(DailyPackData)
  self:RefreshCumulativeReward(DailyPackData)
  self:RefreshPurchaseReward(DailyPackData)
  self:RefreshPayBtn(ShopItemInfo)
  self:RefreshTimeInfo()
  self:AddDelayFrameFunc(function()
    self:UpdateCommonTabInfo()
  end, 1)
end

function M:RefreshCharModel(DailyPackData)
  if not DailyPackData then
    local ShopItemInfo = self.DailyPackShopItemList[self.TabId]
    if not ShopItemInfo then
      return
    end
    DailyPackData = DataMgr.DailyPack[ShopItemInfo.TypeId]
  end
  if not DailyPackData then
    return
  end
  local ItemData = {
    ItemType = CommonConst.DataType.Char,
    TypeId = DailyPackData.BannerCharId
  }
  self.Parent:UpdatePreviewActor(ItemData)
end

function M:RefreshPageGiftInfo(DailyPackData)
  self.WBP_Shop_Recommend_Common_TItle_C_0.Text_MainTitle:SetText(GText(DailyPackData.Name))
  local ConfigData = {
    OwnerWidget = self,
    Desc = "UI_Common_Rule",
    ClickCallback = self.OnBtnExplanationClick
  }
  self.Com_BtnExplanation:Init(ConfigData)
  self.Text_ActivityDesc_White:SetText(GText("UI_DailyPack_CharPreview"))
end

function M:OnBtnExplanationClick()
  if not self then
    return
  end
  local BannerData = self.BannerData
  if not BannerData then
    return
  end
  UIManager(self):ShowCommonPopupUI(100269, {
    LongText = BannerData.Text2,
    Title = BannerData.Text2EntryText
  }, self)
end

function M:RefreshCumulativeReward(DailyPackData)
  local Data = DataMgr.Char[DailyPackData.BannerCharId]
  self.PageGift_SubItem.Text_PieceName:SetText(EnText(Data.CharName))
  local Icon = ItemUtils.GetItemIcon(DailyPackData.MainRewardId, "Resource")
  if Icon then
    self.PageGift_SubItem.Image_PieceIcon:SetBrushFromTexture(Icon)
  end
  local Rarity = ItemUtils.GetItemRarity(DailyPackData.MainRewardId, "Resource")
  local RarityLight = {
    nil,
    nil,
    "Light_Blue",
    "Light_Purple",
    "Light_Gold",
    "Light_Red"
  }
  if RarityLight[Rarity] and self.PageGift_SubItem[RarityLight[Rarity]] then
    local LinearColor = self.PageGift_SubItem[RarityLight[Rarity]]
    self.PageGift_SubItem.Image_TitleBG:SetColorAndOpacity(LinearColor)
    local SlateColor = FSlateColor()
    SlateColor.SpecifiedColor = LinearColor
    self.PageGift_SubItem.Text_PieceName:SetColorAndOpacity(SlateColor)
    local DynamicMaterial = self.PageGift_SubItem.Image_Scanlight:GetDynamicMaterial()
    DynamicMaterial:SetVectorParameterValue("MainColor", LinearColor)
  end
  self.PageGift_SubItem.Text_PriceMoneyNum:SetText(DailyPackData.MainRewardCount)
  self.PageGift_SubItem.Text_Desc:SetText(string.format(GText("UI_DailyPack_MainRewardDes"), DailyPackData.RewardPeriod))
end

function M:RefreshPurchaseReward(DailyPackData)
  local function InitRewardItem(targetItem, rewardData, rewardIndex, bHasGotValue)
    if not (rewardData and rewardData.Id) or not rewardData.Id[rewardIndex] then
      targetItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      
      return
    end
    targetItem:SetVisibility(UIConst.VisibilityOp.Visible)
    local itemType = rewardData.Type[rewardIndex]
    local itemId = rewardData.Id[rewardIndex]
    local itemConfig = DataMgr[itemType] and DataMgr[itemType][itemId]
    if not itemConfig then
      targetItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      return
    end
    local Content = {
      Id = itemId,
      ItemType = itemType,
      Rarity = itemConfig.Rarity,
      Icon = itemConfig.Icon,
      Count = RewardUtils:GetCount(rewardData.Count[rewardIndex]),
      IsShowDetails = true,
      OnMenuOpenChangedEvents = {
        Obj = self,
        Callback = self.ItemMenuAnchorChanged
      },
      bHasGot = bHasGotValue
    }
    targetItem:Init(Content)
  end
  
  self.SubItemLeft.Text_RewardTitle:SetText(GText("UI_DailyPack_BuyReward"))
  self.SubItemRight.Text_RewardTitle:SetText(GText("UI_DailyPack_DailyReward"))
  local BuyReward = DataMgr.Reward[DailyPackData.BuyReward]
  local DailyReward = DataMgr.Reward[DailyPackData.Reward[1]]
  InitRewardItem(self.SubItemLeft.Item01, BuyReward, 1, self.SoldOut)
  InitRewardItem(self.SubItemLeft.Item02, BuyReward, 2, self.SoldOut)
  InitRewardItem(self.SubItemRight.Item01, DailyReward, 1)
  InitRewardItem(self.SubItemRight.Item02, DailyReward, 2)
  local navigationItems = {
    self.SubItemLeft.Item01,
    self.SubItemLeft.Item02,
    self.SubItemRight.Item01,
    self.SubItemRight.Item02
  }
  local visibleItems = {}
  for _, item in ipairs(navigationItems) do
    if item:IsVisible() then
      table.insert(visibleItems, item)
    end
  end
  for i, currentItem in ipairs(visibleItems) do
    local leftTarget, rightTarget
    if i > 1 then
      leftTarget = visibleItems[i - 1]
    end
    if i < #visibleItems then
      rightTarget = visibleItems[i + 1]
    end
    currentItem:SetNavigationRuleExplicit(EUINavigation.Left, leftTarget)
    currentItem:SetNavigationRuleExplicit(EUINavigation.Right, rightTarget)
  end
end

function M:RefreshPayBtn(ShopItemInfo)
  if self.SoldOut then
    self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Pay.WS_Detail:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Pay.Text_BtnEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
    self.Btn_Pay:ForbidBtn(true)
  elseif not self.Effective then
    self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Pay.WS_Detail:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Pay.Text_BtnEmpty:SetText(GText("UI_DailyPack_Soldout"))
    self.Btn_Pay:ForbidBtn(true)
  else
    self.Btn_Pay:ForbidBtn(false)
    self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Pay.WS_Detail:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Pay.Text_PriceMoneySymbol:SetText(GText(ShopUtils:GetCurrencyType()))
    self.Btn_Pay.Text_PriceMoneyNum:SetText(ShopUtils:GetShopItemPrice(ShopItemInfo.ItemId))
    self.Btn_Pay.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
    self.Btn_Pay.Text_BuyNum:SetText(GText("UI_Banner_Remain_Buy") .. ShopUtils:GetShopItemPurchaseLimit(ShopItemInfo.ItemId))
  end
end

function M:OnGoToCharDetails()
  local ShopItemInfo = self.DailyPackShopItemList[self.TabId]
  local DailyPackData = DataMgr.DailyPack[ShopItemInfo.TypeId]
  UIManager(self):LoadUINew("ArmoryDetail", {
    IsPreviewMode = true,
    PreviewCharIds = {
      DailyPackData.BannerCharId
    },
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    bNoEndCamera = true
  })
end

function M:RefreshTimeInfo()
  self.Activity_Time:SetForeverTimeText(GText("UI_DailyPack_BuyEnd"))
  self.Activity_Time_Left:SetForeverTimeText(GText("UI_DailyPack_RewardEnd"))
  self:InitActivity_TimeInfo()
end

function M:InitActivity_TimeInfo()
  self:RemoveTimer("ShopItemCountdown")
  self:RemoveTimer("ShopItemCountdown_Left")
  local ShopItemData = self.DailyPackShopItemList[self.TabId]
  if ShopItemData and ShopUtils:ShouldShowRemainingTime(ShopItemData.ItemId) and ShopItemData.EndTime then
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:UpdateCountdownTick(ShopItemData.EndTime)
    self:AddTimer(1.0, self.UpdateCountdownTick, true, 0, "ShopItemCountdown", true, ShopItemData.EndTime)
  else
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if ShopItemData and ShopUtils:ShouldShowCompletionTime(ShopItemData.TypeId) then
    self.Activity_Time_Left:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:UpdateCountdownTick_Left()
    self:AddTimer(1.0, self.UpdateCountdownTick_Left, true, 0, "ShopItemCountdown_Left", true)
  else
    self.Activity_Time_Left:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:UpdateCountdownTick(ItemEndTime)
  if ItemEndTime <= TimeUtils.NowTime() then
    self:CleanTimer()
    EventManager:FireEvent(EventID.RefreshShop)
    return
  end
  local RemainTimeStr = ShopUtils:UpdateLimitTime(ItemEndTime)
  self.Activity_Time.Text_TimeDesc:SetText(RemainTimeStr)
end

function M:UpdateCountdownTick_Left()
  local ShopItemData = self.DailyPackShopItemList[self.TabId]
  if not ShopItemData then
    self:CleanTimer()
    return
  end
  if not ShopUtils:ShouldShowCompletionTime(ShopItemData.TypeId) then
    self:CleanTimer()
    EventManager:FireEvent(EventID.RefreshShop)
    return
  end
  local RemainTimeStr = ShopUtils:UpdateRewardEndTime(ShopItemData.ExpiredTime)
  self.Activity_Time_Left.Text_TimeDesc:SetText(RemainTimeStr)
end

function M:PlayAnimationIn()
  self:PlayAnimation(self.In)
  self:RefreshCharModel()
  self:UpdateCommonTabInfo()
end

function M:PlayAnimationOut()
  self:PlayAnimation(self.Out)
end

function M:OnGoToInterface()
  self:OnBuyBtnClicked()
end

function M:OnBuyBtnClicked()
  if self.SoldOut or not self.Effective then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
  self:PurchaseDailyPack()
end

function M:PurchaseDailyPack()
  local ShopItemData = setmetatable({}, {
    __index = self.DailyPackShopItemList[self.TabId]
  })
  ShopUtils:CanPurchase(ShopItemData, ShopItemData.PriceType, ShopUtils:GetShopItemPrice(ShopItemData.ItemId))
  if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
    if 0 == ShopItemData.PurchaseFailRes then
      local Avatar = GWorld:GetAvatar()
      if not Avatar then
        return false
      end
      if not HeroUSDKSubsystem():IsHeroSDKEnable() then
        local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
        GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance, "sgm pgi " .. DataMgr.ShopItem2PayGoods[ShopItemData.ItemId])
        return
      end
      Avatar:RequestPay(DataMgr.ShopItem2PayGoods[ShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
        if not ErrorCode:Check(ret) then
          return
        end
        local PaymentParameters = FHeroUPaymentParameters()
        PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
        PaymentParameters.cpOrder = OrderId
        PaymentParameters.callbackUrl = CallbackUrl
        local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
        local ItemName = ""
        ItemName = GText(ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType))
        HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, ItemName)
        local TrackInfo = {}
        TrackInfo.product_id = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
        if ShopItemData.ItemId then
          TrackInfo.item_id = ShopItemData.ItemId
          TrackInfo.product_type = DataMgr.ShopItem[ShopItemData.ItemId].ItemType
        end
        TrackInfo.game_order_id = OrderId
        TrackInfo.order_create_time = TimeUtils.NowTime()
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("charge_client", TrackInfo)
      end)
    else
      UIManager(self):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
    end
    return
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  else
    IsEventHandled = self:OnPCKeyDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnPCKeyDown(InKeyName)
  local IsEventHandled = false
  if "SpaceBar" == InKeyName then
    self:OnGoToInterface()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:ItemMenuAnchorChanged(bIsOpen)
  self.bItemTipsOpen = bIsOpen
  self:UpdateGamePadKeyInfo()
end

function M:UpdateGamePadKeyInfo()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    if self.bFocusOnItem or self.bItemTipsOpen then
      self.Btn_Pay:SetGamePadIconVisible(false)
      self.Com_BtnExplanation:UpdateUIStyleInPlatform(false)
      self.QA:SetActiveWidgetIndex(0)
      self.PageGift_SubItem.Key_Left:SetVisibility(UIConst.VisibilityOp.Hidden)
      self.PageGift_SubItem.Key_Right:SetVisibility(UIConst.VisibilityOp.Hidden)
      if self.bItemTipsOpen then
        self.Parent.Common_Tab:SetBottomKeyInfoVisible(false)
      elseif self.bFocusOnItem then
        self.Parent:UpdateCommonTabInfoByReward()
      end
      self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Btn_Pay:SetGamePadIconVisible(true)
      self.Com_BtnExplanation:UpdateUIStyleInPlatform(true)
      self.QA:SetActiveWidgetIndex(1)
      if #self.DailyPackShopItemList > 1 then
        self.PageGift_SubItem.Key_Left:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.PageGift_SubItem.Key_Right:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
      self.Key_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    self.Btn_Pay:SetGamePadIconVisible(true)
    self.Com_BtnExplanation:UpdateUIStyleInPlatform(false)
    self.QA:SetActiveWidgetIndex(0)
    self.PageGift_SubItem.Key_Left:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.PageGift_SubItem.Key_Right:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.Com_BtnExplanation.Com_BtnQa:OnViewInfoClick()
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
    if not self.bFocusOnItem and not self.bItemTipsOpen then
      self:OnGoToCharDetails()
    end
  elseif InKeyName == UIConst.GamePadKey.DPadLeft then
    if self.TabId - 1 > 0 and self.BannerTabItem[self.TabId - 1] then
      self.BannerTabItem[self.TabId - 1]:OnItemClick()
    end
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    if self.TabId + 1 <= #self.DailyPackShopItemList and self.BannerTabItem[self.TabId + 1] then
      self.BannerTabItem[self.TabId + 1]:OnItemClick()
    end
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    self.SubItemLeft.Item01:SetFocus()
    self.bFocusOnItem = true
    self:UpdateGamePadKeyInfo()
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self.bFocusOnItem = true
    self:UpdateGamePadKeyInfo()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.bFocusOnItem then
      self.Parent:GamePadFocusToSelectBannerItem()
      self:UpdateCommonTabInfo()
      self.bFocusOnItem = false
      IsEventHandled = true
      self:UpdateGamePadKeyInfo()
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnGoToInterface()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:HandleRepeatKeyDown(InKey, InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    self.Parent:OnCameraScrollBackwardKeyDown()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    self.Parent:OnCameraScrollForwardKeyDown()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:UpdateCommonTabInfo()
  local Params = {}
  table.insert(Params, {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("Mouse_Button"),
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Or"},
      GamePadSubKeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "LT",
          Owner = self
        },
        {
          Type = "Img",
          ImgShortPath = "RT",
          Owner = self
        }
      }
    },
    Desc = GText("UI_Dye_Zoom"),
    bLongPress = false
  })
  table.insert(Params, {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "RH"}
    },
    Desc = GText("UI_CTL_RotatePreview")
  })
  if not self.SoldOut and self.Effective then
    table.insert(Params, {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "SpaceBar",
          Owner = self,
          ClickCallback = self.OnBuyBtnClicked
        }
      },
      Desc = GText("UI_SHOP_PURCHASE"),
      bLongPress = false
    })
  end
  table.insert(Params, {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "Escape",
        ClickCallback = self.Parent.CloseSelf,
        Owner = self.Parent
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        Owner = self
      }
    },
    Desc = GText("UI_BACK"),
    bLongPress = false
  })
  if self.Parent and self.Parent.UpdateCommonTabInfo then
    self.Parent:UpdateCommonTabInfo(Params)
  end
end

function M:OnResourceBarRemovedFromFocusPath()
  if self.bFocusOnItem then
    self:UpdateCommonTabInfo()
    self.bFocusOnItem = false
    self:UpdateGamePadKeyInfo()
  end
end

AssembleComponents(M)
return M
