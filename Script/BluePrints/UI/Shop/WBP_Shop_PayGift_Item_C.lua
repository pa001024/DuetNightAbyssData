require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.Shop.WBP_ShopItem_ReddotComp"
})

function M:Construct()
  self.WS_Item:SetActiveWidgetIndex(0)
  self.Text_SoldOut:SetText(GText("UI_SHOP_SOLDOUT"))
  self.bQuickAddOpen = false
  if self.Btn_Add then
    self.Btn_Add:BindEventOnClicked(self, self.OnClickQuickAdd)
  end
  EventManager:AddEvent(EventID.OnShoppingCartChanged, self, self.OnShoppingCartChanged)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.ItemData = Content.ItemData
  self.Content.SelfWidget = self
  self.bQuickAddOpen = Content.bQuickAddOpen or false
  self:InitPayGiftItemInfo(self.ItemData)
end

function M:InitPayGiftItemInfo(ShopItemData)
  if not ShopItemData then
    self.WS_Item:SetActiveWidgetIndex(1)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.WS_Item:SetActiveWidgetIndex(0)
  self.NowPayGiftItem = nil
  self:UpdateLockState(ShopItemData)
  self.bNewShopItem = Avatar:CheckShopItemEnhanceRedDot(ShopItemData.ItemId)
  if self.bNewShopItem then
    self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.New:SetVisibility(ESlateVisibility.Collapsed)
  end
  local Cost = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
  if 0 == Cost then
    self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.New:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
  end
  if 1 == ShopItemData.Bg then
    self.NowPayGiftItem = self.PayGift_YellowItem
    self.PayGift_YellowItem:SetVisibility(ESlateVisibility.Visible)
    self.PayGift_PurpleItem:SetVisibility(ESlateVisibility.Collapsed)
    self.PayGift_YellowItem:InitItemInfo(ShopItemData)
  else
    self.NowPayGiftItem = self.PayGift_PurpleItem
    self.PayGift_YellowItem:SetVisibility(ESlateVisibility.Collapsed)
    self.PayGift_PurpleItem:SetVisibility(ESlateVisibility.Visible)
    self.PayGift_PurpleItem:InitItemInfo(ShopItemData)
  end
  self.NowPayGiftItem:SetCallbacks(self, {
    OnClickCb = self.OnSubItemClick,
    ClearRdCb = self.OnClearReddot,
    BeforeShowDetailCb = self.OnBeforeShowItemDetail
  })
  self.ShopId = ShopItemData.ItemId
  self:UpdateReddotCommon(ShopItemData)
  self:InitShoppingCartBtn(ShopItemData)
end

function M:GetRequireLockText(ShopItemData)
  local RequireItemData = DataMgr.ShopItem[ShopItemData.Require]
  local RequireName = ""
  if RequireItemData then
    RequireName = GText(ItemUtils:GetDropName(RequireItemData.TypeId, RequireItemData.ItemType))
  end
  return string.format(GText("UI_Shop_ShoppingCart_Front"), RequireName)
end

function M:OnBeforeShowItemDetail()
  if not self.bQuickAddOpen or not self.ItemData then
    return true
  end
  if not ShopUtils:HasUnsatisfiedRequire(self.ItemData.ItemId) then
    return true
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, self:GetRequireLockText(self.ItemData))
  return false
end

function M:UpdateLockState(ShopItemData)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Lock:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_SoldOut:SetVisibility(ESlateVisibility.Collapsed)
  self.IsLockState = ShopUtils:CheckShopItemCondition(ShopItemData)
  local bHasRequire = ShopUtils:HasUnsatisfiedRequire(ShopItemData.ItemId)
  if self.IsLockState or bHasRequire then
    if bHasRequire then
      self.Lock.Text_Lock:SetText(self:GetRequireLockText(ShopItemData))
    elseif ShopItemData.ItemConditionDisplay and ShopItemData.ItemCondition then
      self.Lock.Text_Lock:SetText(GText(DataMgr.Condition[ShopItemData.ItemCondition[1]] and DataMgr.Condition[ShopItemData.ItemCondition[1]].ConditionText or ""))
    else
      self.Lock.Text_Lock:SetText(GText("UI_Shop_ItemUnlock"))
    end
    self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  elseif ShopItemData.UnlockLevel and Avatar.Level < ShopItemData.UnlockLevel then
    self.Lock.Text_Lock:SetText(GText("UI_Player_Level") .. ShopItemData.UnlockLevel)
    self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  elseif GiftController:IsInGiftShop() then
    local giftMain = GiftController:GetGiftMainPage()
    local Uid = giftMain and giftMain.FriendUid or nil
    local PurchaseLimit = ShopUtils:GetGiftItemPurchaseLimit(ShopItemData.ItemId, Uid)
    if PurchaseLimit and PurchaseLimit > -1 and 0 == PurchaseLimit then
      self.PayGift_PurpleItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
      self.PayGift_YellowItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
      self.Text_SoldOut:SetText(GText("UI_SendGift_GiftItemMax"))
      self.Group_SoldOut:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  elseif Avatar:CheckShopItemSoldOutDisplay(ShopItemData.ItemId) then
    self.PayGift_PurpleItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    self.PayGift_YellowItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_SoldOut:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:InitShoppingCartBtn(ShopItemData)
  local bSupported = ShopUtils:IsShoppingCartSupported(ShopItemData.ItemId)
  local bHasRequire = ShopUtils:HasUnsatisfiedRequire(ShopItemData.ItemId)
  local bVisible = bSupported and self.bQuickAddOpen and not bHasRequire
  if self.NumSelect then
    self.NumSelect:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if self.Btn_Add then
    self.Btn_Add:SetVisibility(bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if not (bSupported and self.bQuickAddOpen) or bHasRequire then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self:UpdateQuickAddState(ShopItemData.ItemId)
  if self.Btn_Add then
    local bPending = ShopUtils:IsShoppingCartPending()
    self.Btn_Add:ForbidBtn(bPending)
  end
end

function M:UpdateNumSelect(CurrentCount, MaxCount)
  self.NumSelect.Text_Now:SetText(tostring(CurrentCount))
  self.NumSelect.Text_Total:SetText(tostring(MaxCount))
end

function M:GetQuickAddDisplayMax(ShopItemId)
  local Remain, Total = ShopUtils:GetContextRemainAndTotal(ShopItemId)
  if -1 ~= Remain then
    return Remain
  end
  return -1 ~= Total and Total or 0
end

function M:UpdateQuickAddState(ShopItemId)
  if not self.NumSelect then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.ShoppingCart) or not Avatar.ShoppingCart.Items then
    self:UpdateNumSelect(0, 0)
    return
  end
  local CartItem = Avatar.ShoppingCart.Items[ShopItemId]
  local CurrentCount = CartItem and CartItem.Count or 0
  self:UpdateNumSelect(CurrentCount, self:GetQuickAddDisplayMax(ShopItemId))
end

function M:SetQuickAddMode(bOpen)
  self.bQuickAddOpen = bOpen
  if self.ItemData then
    self:InitShoppingCartBtn(self.ItemData)
  end
end

function M:OnClickQuickAdd()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.ItemData then
    return
  end
  local ShopItemId = self.ItemData.ItemId
  if not ShopUtils:IsShoppingCartSupported(ShopItemId) then
    return
  end
  if ShopUtils:HasUnsatisfiedRequire(ShopItemId) then
    return
  end
  if ShopUtils:IsShoppingCartPending() then
    UIManager(self):ShowError(ErrorCode.PAY_ORDER_IN_PROCESS, 1.0, "CommonToastMain")
    return
  end
  local Remain = ShopUtils:GetContextRemainAndTotal(ShopItemId)
  local CartItem = Avatar.ShoppingCart.Items[ShopItemId]
  local CurrentCount = CartItem and CartItem.Count or 0
  if -1 ~= Remain and Remain < CurrentCount + 1 then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_SHOP_SHOPPINGCART_COUNT_LIMIT"), 1.0)
    return
  end
  local ExpectedRevision = Avatar.ShoppingCart.Revision
  Avatar:AddShoppingCartItem(ShopItemId, 1, ExpectedRevision)
  self:UpdateNumSelect(CurrentCount + 1, self:GetQuickAddDisplayMax(ShopItemId))
  self:PlayAddToCartEffect()
end

function M:PlayAddToCartEffect()
  local ShopMain = UIManager(self):GetUIObj("ShopMain")
  if ShopMain and ShopMain.PlayShoppingCartAddEffect and self.Btn_Add then
    ShopMain:PlayShoppingCartAddEffect(self.Btn_Add)
  end
end

function M:OnShoppingCartChanged()
  if not self.ItemData then
    return
  end
  if self.bQuickAddOpen then
    self:UpdateLockState(self.ItemData)
    self:InitShoppingCartBtn(self.ItemData)
  end
end

function M:OnClearReddot()
  self:EMShowReddot(false, EReddotType.New)
end

function M:OnSubItemClick()
  self:DecreaseReddotCommon(self.ItemData)
end

function M:Destruct()
  if self.Btn_Add then
    self.Btn_Add:UnBindEventOnClickedByObj(self)
  end
  EventManager:RemoveEvent(EventID.OnShoppingCartChanged, self)
end

return M
