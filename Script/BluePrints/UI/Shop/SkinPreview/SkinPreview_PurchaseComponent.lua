local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local GiftController = require("BluePrints.UI.WBP.Gift.GiftController")
local GiftCommon = require("BluePrints.UI.WBP.Gift.GiftCommon")
local M = {}

function M:OnClickDiscount()
  if self.bSelfHidden then
    return
  end
  if self.Btn_Discount_Light and self.Btn_Discount_Light:IsVisible() and self.bCanOpenDiscount then
    self.Btn_Discount_Light:OnButtonClicked()
  end
  return UIUtils.Handled, true
end

function M:UpdateLockCondition()
  self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
  self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
  self.WS_Btn:SetActiveWidgetIndex(1)
  self.ConditionDisplay = self.ShopItemData.ItemConditionDisplay and self.ShopItemData.ItemCondition
  if self.ConditionDisplay then
    self.Com_Hint.IsForbidden = true
    self.Com_Hint:SetText(GText(DataMgr.Condition[self.ShopItemData.ItemCondition[1]] and DataMgr.Condition[self.ShopItemData.ItemCondition[1]].ConditionText or ""))
    self.Com_Hint.bAutoButtonChange = false
    self.Com_Hint:SetIconPanelVisibility(ESlateVisibility.Collapsed)
    self.Com_Hint:SetGamepadIconVisibility(false)
    self.Com_Hint:SetGamePadVisibility(ESlateVisibility.Collapsed)
    self.Com_Hint.Button_Area:SetIsEnabled(false)
  else
    self.Com_Hint.IsForbidden = false
    self.Com_Hint:SetText(GText("UI_Shop_ItemUnlock"))
    self.Com_Hint.bAutoButtonChange = true
    self.Com_Hint:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_Hint:SetGamepadIconVisibility(true)
    self.Com_Hint.Button_Area:SetIsEnabled(true)
  end
end

function M:UpdateDiscount()
  self.AutoSelectDiscount = EMCache:Get("AutoSelectDiscount", true)
  self.AvailableDiscounts = ShopUtils:GetValidVouchers(self.ShopItemData)
  self.bCanOpenDiscount = self.AvailableDiscounts and #self.AvailableDiscounts > 0
  local bSelectedVoucherExpired = false
  if self.SelectedDiscount then
    local bIsStillValid = false
    for _, voucher in ipairs(self.AvailableDiscounts) do
      if voucher.VoucherId == self.SelectedDiscount.VoucherId then
        bIsStillValid = true
        break
      end
    end
    if not bIsStillValid then
      bSelectedVoucherExpired = true
    end
  end
  local bIsNewItem = self.LastDiscountItemId ~= self.ShopItemData.ItemId
  if bIsNewItem or bSelectedVoucherExpired then
    if self.AvailableDiscounts and #self.AvailableDiscounts > 0 then
      if self.AutoSelectDiscount then
        self.SelectedDiscount = ShopUtils:GetBestVoucher(self.AvailableDiscounts)
      else
        self.SelectedDiscount = nil
      end
    else
      self.AvailableDiscounts = {}
      self.SelectedDiscount = nil
    end
    self.LastDiscountItemId = self.ShopItemData.ItemId
  end
  self:RemoveTimer("VoucherExpireTimer")
  ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, nil))
  local failReason = self.ShopItemData.PurchaseFailRes
  if ShopUtils:HasAnyVoucherConfig(self.ShopItemData.ItemId) and 1 == self.ShopItemData.PurchaseLimit and not DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] and 1 ~= failReason and 6 ~= failReason and 1 == ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId) then
    self.Btn_Discount_Light:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Discount_Light:Init({
      ParentWidget = self,
      IsInPreview = true,
      ShopItemData = self.ShopItemData,
      AvailableDiscounts = self.AvailableDiscounts,
      SelectedDiscount = self.SelectedDiscount,
      OnDiscountChangedCallback = function(NewDiscount)
        self:OnDiscountChanged(NewDiscount)
      end,
      OnMenuStateChangedCallback = function(bIsOpen)
        self:OnDiscountMenuStateChanged(bIsOpen)
      end,
      TipsStateChangedCallback = function(Data, bIsOpen)
        if self.TipsStateChangedCallback then
          self:TipsStateChangedCallback(Data, bIsOpen)
        end
      end,
      ItemTipsStateChangedCallback = function(Data, bIsOpen)
        if self.ItemTipsStateChangedCallback then
          self:ItemTipsStateChangedCallback(Data, bIsOpen)
        end
      end,
      ItemFocusReceivedCallback = function(Data)
        if self.ItemFocusReceivedCallback then
          self:ItemFocusReceivedCallback(Data)
        end
      end
    })
    self:SetupVoucherExpireTimer()
  else
    self.Btn_Discount_Light:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetupVoucherExpireTimer()
  if not self.AvailableDiscounts or 0 == #self.AvailableDiscounts then
    return
  end
  local NearestExpireTime = math.huge
  local NowTime = TimeUtils.NowTime()
  for _, voucher in ipairs(self.AvailableDiscounts) do
    if voucher.ExpireTime and NowTime < voucher.ExpireTime and NearestExpireTime > voucher.ExpireTime then
      NearestExpireTime = voucher.ExpireTime
    end
  end
  if NearestExpireTime ~= math.huge then
    local RemainTime = NearestExpireTime - NowTime + 1
    self:AddTimer(RemainTime, function()
      if not IsValid(self) then
        return
      end
      if IsValid(self.Btn_Discount_Light) and self.Btn_Discount_Light:IsVisible() and self.Btn_Discount_Light.ForceCloseMenu then
        self.Btn_Discount_Light:ForceCloseMenu()
      end
      self:UpdateDiscount()
      self:UpdatePrice()
      self:UpdateButtonBuy()
    end, false, 0, "VoucherExpireTimer")
  end
end

function M:UpdatePrice()
  self.CurrentCount = 1
  self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
  self.CutoffData = ShopUtils:GetShopItemCutoffData(self.ShopItemData.ItemId)
  self.canPurchase = ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, self.UnitPrice)
  if self.CutoffData ~= nil or self.SelectedDiscount ~= nil then
    self.WBP_Com_Cost:InitContent({
      ResourceId = self.ShopItemData.PriceType,
      bShowDenominator = false,
      Numerator = self.UnitPrice
    })
    self.WBP_Com_Cost:SetGamePadIconVisible(false)
    local Resource = DataMgr.Resource[self.ShopItemData.PriceType]
    local Icon = LoadObject(Resource.Icon)
    self.WBP_Com_Cost.Common_Item_Icon:Init({
      Id = self.ShopItemData.PriceType,
      Icon = Icon,
      ItemType = "Resource",
      UIName = "CommonDialog",
      NotInteractive = false,
      IsShowDetails = true,
      IsCantItemSelection = false,
      MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
      HandleMouseDown = true,
      HandleKeyDown = false
    })
    if self.SelectedDiscount then
      self.Text_Undiscounted_Price:SetText(ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId))
    else
      self.Text_Undiscounted_Price:SetText(self.ShopItemData.Price)
    end
  else
    self.WBP_Com_Cost:InitContent({
      ResourceId = self.ShopItemData.PriceType,
      bShowDenominator = false,
      Numerator = self.UnitPrice
    })
    self.WBP_Com_Cost:SetGamePadIconVisible(false)
    local Resource = DataMgr.Resource[self.ShopItemData.PriceType]
    local Icon = LoadObject(Resource.Icon)
    self.WBP_Com_Cost.Common_Item_Icon:Init({
      Id = self.ShopItemData.PriceType,
      Icon = Icon,
      ItemType = "Resource",
      UIName = "CommonDialog",
      NotInteractive = false,
      IsShowDetails = true,
      IsCantItemSelection = false,
      MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
      HandleMouseDown = true,
      HandleKeyDown = false
    })
    self.Text_Undiscounted_Price:SetText("")
  end
  if self.bInGiftShop then
    self.BtnChooseGiftEnable = false
    self.Group_BtnChoose:SetVisibility(ESlateVisibility.Collapsed)
  elseif self.ShopItemData.CanBeGift and ShopUtils:ShowSendGiftButton(self.ShopItemData) then
    self.BtnChooseGiftEnable = true
    self.Group_BtnChoose:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if GiftController:CheckCanSendGift() then
      self.Btn_Choose:ForbidBtn(false)
    else
      self.Btn_Choose:ForbidBtn(true)
    end
  else
    self.BtnChooseGiftEnable = false
    self.Group_BtnChoose:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdateButtonBuy()
  self.WS_Btn:SetActiveWidgetIndex(0)
  self.Btn_Function:UnBindButtonPerformances()
  local failReason = self.ShopItemData.PurchaseFailRes
  self.WidgetSwitcher_BtnState:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if self.bInGiftShop then
    local shouldSoldOut = ShopUtils:ShouldPlaySoldOutAnimation(self.ShopItemData.ItemId)
    if shouldSoldOut then
      self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(1)
      self.Text_Desc:SetText(GText("UI_SendGift_GiftItemMax"))
      self.bForbiddenButton = true
      return
    else
      self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
      self.WBP_Com_Cost:SetIsEnough(true)
      self.Btn_Function:ForbidBtn(false)
      self.Btn_Function:BindButtonPerformances()
      self.bForbiddenButton = false
      return
    end
  end
  if 1 == failReason or 6 == failReason then
    self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(1)
    self.Text_Desc:SetText(GText("UI_SHOP_ALREADYOWNED"))
    self.bForbiddenButton = true
  elseif 2 == failReason or 3 == failReason then
    local CurrentCount = self.Avatar:GetResourceNum(self.ShopItemData.PriceType)
    local Cost = self.UnitPrice
    self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
    self.WBP_Com_Cost:SetIsEnough(CurrentCount >= Cost)
    self.Btn_Function:ForbidBtn(true)
    self.Btn_Function.Button_Area.OnClicked:Add(self, self.PurChase)
    self.bForbiddenButton = false
  elseif 4 == failReason or 5 == failReason then
    self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
    self.WBP_Com_Cost:SetIsEnough(false)
    self.Btn_Function:ForbidBtn(false)
    self.Btn_Function:BindButtonPerformances()
    self.bForbiddenButton = false
  elseif self.canPurchase then
    self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
    self.WBP_Com_Cost:SetIsEnough(true)
    self.Btn_Function:ForbidBtn(false)
    self.Btn_Function:BindButtonPerformances()
    self.bForbiddenButton = false
  end
  self.BuyButtonState = self.Btn_Function:IsBtnForbidden()
  if self.Btn_Discount_Light and self.Btn_Discount_Light:IsVisible() then
    self.Btn_Discount_Light:SetSelectedDiscount(self.SelectedDiscount)
  end
end

function M:OnDiscountChanged(NewDiscount)
  self.SelectedDiscount = NewDiscount
  self:PlayAnimation(self.Text_Refresh)
  self:UpdatePrice()
  self:UpdateButtonBuy()
end

function M:EnterSelectDiscountMode()
end

function M:ExitSelectDiscountMode()
end

function M:OnDiscountMenuStateChanged(bIsOpen)
  if bIsOpen then
    self.Btn_Function:ForbidBtn(true)
    self:EnterSelectDiscountMode()
  else
    if not self.BuyButtonState then
      self.Btn_Function:ForbidBtn(false)
    end
    self:ExitSelectDiscountMode()
    if UIUtils.IsGamepadInput() then
      self:SetFocus()
    end
  end
end

function M:PurChase()
  if self.bSelfHidden then
    return
  end
  if self.bInGiftShop then
    return self:PurchaseGift()
  end
  if self.bForbiddenButton then
    return
  end
  if self.canPurchase then
    AudioManager(self):PlayUISound(self.Btn_Function, "event:/ui/activity/shop_small_btn_click", nil, nil)
  end
  local TrackInfo = {}
  TrackInfo.product_id = self.ShopItemData.ItemId
  TrackInfo.shop_id = self.ShopItemData.SubTabId
  TrackInfo.status = 2
  if 2 == self.ShopItemData.PurchaseFailRes then
    UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[self.ShopItemData.PriceType].ResourceName)), 1.0)
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
    return
  elseif 3 == self.ShopItemData.PurchaseFailRes then
    UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), self.ShopItemData.UnlockLevel), 1.0)
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
    return
  elseif 4 == self.ShopItemData.PurchaseFailRes then
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
    local PopUpId = 100136
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local ItemName = ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
    local PriceCount = Avatar.Resources[self.ShopItemData.PriceType] and Avatar.Resources[self.ShopItemData.PriceType].Count or 0
    local PopoverText = GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText)
    if string.find(PopoverText, "&ResourceName&") then
      PopoverText = string.gsub(PopoverText, "&ResourceName&", GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
    end
    if string.find(PopoverText, "&ResourceName1&") then
      PopoverText = string.gsub(PopoverText, "&ResourceName1&", GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
    end
    if string.find(PopoverText, "&ResourceName2&") then
      PopoverText = string.gsub(PopoverText, "&ResourceName2&", GText(ItemName))
    end
    if string.find(PopoverText, "&Num1&") then
      PopoverText = string.gsub(PopoverText, "&Num1&", self.CurrentCount * self.UnitPrice - PriceCount)
    end
    if string.find(PopoverText, "&Num2&") then
      PopoverText = string.gsub(PopoverText, "&Num2&", self.CurrentCount)
    end
    
    local function Confirm()
      local Coin4Count = 0
      if Avatar.Resources[CommonConst.Coins.Coin4] then
        Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4].Count
      end
      if Coin4Count < self.CurrentCount * self.UnitPrice - PriceCount then
        local function JumpToShop()
          self:CloseSelf()
          
          local UIName = DataMgr.Shop.Shop.ShopUIName
          local ShopMainPage = UIManager(self):GetUIObj(UIName)
          ShopMainPage:InitShop(110, nil, nil, "Shop", nil, nil)
        end
        
        local Params = {}
        Params.Title = GText("UI_COMMONPOP_TITLE_100137")
        Params.ShortText = GText("UI_COMMONPOP_TEXT_100137")
        Params.LeftCallbackObj = self
        Params.RightCallbackObj = self
        Params.RightCallbackFunction = JumpToShop
        UIManager(self):ShowCommonPopupUI(100137, Params, self)
      else
        ShopUtils:SendExchangeRequest(self.ShopItemData.ItemId, self.CurrentCount)
      end
    end
    
    local ItemList = {}
    local Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0
    table.insert(ItemList, {
      ItemId = CommonConst.Coins.Coin4,
      ItemType = CommonConst.ItemType.Resource,
      ItemNum = Coin4Count,
      ItemNeed = self.CurrentCount * self.UnitPrice - PriceCount
    })
    local Params = {
      RightCallbackFunction = Confirm,
      ItemList = ItemList,
      ShortText = PopoverText
    }
    UIManager(self):ShowCommonPopupUI(PopUpId, Params)
    return
  elseif 5 == self.ShopItemData.PurchaseFailRes then
    HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    
    local function ReOpenPurchase()
      if not IsValid(self) then
        return
      end
      self:UpdatePrice()
      self:UpdateButtonBuy()
      self:PurChase()
    end
    
    ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = ReOpenPurchase})
    local Params = {}
    Params.ShopItemId = self.ShopItemData.ItemId
    Params.VoucherId = self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil
    Params.Uid = Avatar.Uid
    Params.CloseBtnCallback = {
      Func = function()
        ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = nil})
      end
    }
    Params.BeforeClickNoCallback = {
      Obj = self,
      Func = self.Close
    }
    UIManager(self):LoadUINew("ShopTargetPay", Params)
    return
  end
  local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
  local CommonPopupUIID
  if 0 == RemainTimes then
    CommonPopupUIID = 100042
  else
    TrackInfo.status = 1
    CommonPopupUIID = 100041
  end
  if not CommonPopupUIID then
    return
  end
  local Funds = {}
  Funds[1] = {}
  Funds[1].FundId = self.ShopItemData.PriceType
  Funds[1].FundNeed = self.UnitPrice
  HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
  UIManager(self):ShowCommonPopupUI(CommonPopupUIID, {
    ShopItemData = self.ShopItemData,
    ShopType = 0,
    Funds = Funds,
    ShowParentTabCoin = true,
    SingleItemNotInteractive = true,
    SelectedDiscount = self.SelectedDiscount,
    bHasDraftDiscount = true,
    LeftCallbackObj = self,
    LeftCallbackFunction = function()
      local SkinPreview = UIManager(self):GetUIObj("SkinPreview")
      if SkinPreview then
        SkinPreview:SetFocus()
      end
    end,
    RightCallbackObj = self,
    RightCallbackFunction = function(Obj, Data)
      if Obj then
        local count = 1
        if Data and Data.Content_1 and Data.Content_1.CallObj then
          count = Data.Content_1.CallObj.CurrentCount or 1
          Obj.SelectedDiscount = Data.Content_1.CallObj.SelectedDiscount
        end
        Obj:PurchaseShopItem(count)
      end
    end,
    ForbiddenRightCallbackObj = self,
    ForbiddenRightCallbackFunction = function(Obj, PackageData)
      PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
    end,
    DontFocusParentWidget = true,
    CloseBtnCallbackObj = self,
    CloseBtnCallbackFunction = function()
      local SkinPreview = UIManager(self):GetUIObj("SkinPreview")
      if SkinPreview then
        SkinPreview:SetFocus()
      end
    end,
    ForbidRightBtn = not self.canPurchase
  }, self)
end

function M:PurchaseGift()
  if self.canPurchase then
    AudioManager(self):PlayUISound(self.Btn_Function, "event:/ui/activity/shop_small_btn_click", nil, nil)
  end
  local giftMain = UIManager(self):GetUIObj(GiftCommon.GiftShopViewName)
  local OtherUid = giftMain and giftMain.FriendUid or nil
  if OtherUid then
    GiftController:TryToSendGift(OtherUid, self.ShopItemData.ItemId)
  else
    GiftController:OpenSelectFriendPopup(self.ShopItemData.ItemId, self)
  end
end

function M:PurchaseShopItem(Count)
  local FinalCount = Count or self.CurrentCount or 1
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return false
    end
    if not HeroUSDKSubsystem():IsHeroSDKEnable() then
      local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
      GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm pgi " .. DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId])
      return
    end
    Avatar:RequestPay(DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
      if not ErrorCode:Check(ret) then
        return
      end
      local PaymentParameters = FHeroUPaymentParameters()
      PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId]
      PaymentParameters.cpOrder = OrderId
      PaymentParameters.callbackUrl = CallbackUrl
      local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
      local ItemName = GText(DataMgr.PayGoods[PaymentParameters.goodsId].Name)
      HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, ItemName)
      local TrackInfo = {}
      TrackInfo.product_id = DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId]
      if self.ShopItemData.ItemId then
        TrackInfo.item_id = self.ShopItemData.ItemId
        TrackInfo.product_type = DataMgr.ShopItem[self.ShopItemData.ItemId].ItemType
      end
      TrackInfo.game_order_id = OrderId
      TrackInfo.order_create_time = TimeUtils.NowTime()
      HeroUSDKSubsystem(self):UploadTrackLog_Lua("charge_client", TrackInfo)
    end)
    return
  end
  if 0 ~= self.ShopItemData.PurchaseFailRes then
    if 1 == self.ShopItemData.PurchaseFailRes then
      UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
    elseif 2 == self.ShopItemData.PurchaseFailRes then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[self.ShopItemData.PriceType].ResourceName)), 1.0)
    elseif 3 == self.ShopItemData.PurchaseFailRes then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), self.ShopItemData.UnlockLevel), 1.0)
    elseif 6 == self.ShopItemData.PurchaseFailRes then
      UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_UNIQUE_ALREDAY_OWNED, 1.0, "CommonToastMain")
    end
    return
  end
  self:BlockAllUIInput(true)
  Avatar:PurchaseShopItem(self.ShopItemData.ItemId, FinalCount, nil, nil, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
end

function M:RefreshPurchaseState()
  if 0 == ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId) then
    self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(1)
    self.Text_Desc:SetText(GText("UI_SHOP_ALREADYOWNED"))
    self.bForbiddenButton = true
    self.bCanOpenDiscount = false
    self.Btn_Discount_Light:SetVisibility(ESlateVisibility.Collapsed)
  else
    self:UpdateDiscount()
    self:UpdatePrice()
    self:UpdateButtonBuy()
    self.Btn_Discount_Light:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

return M
