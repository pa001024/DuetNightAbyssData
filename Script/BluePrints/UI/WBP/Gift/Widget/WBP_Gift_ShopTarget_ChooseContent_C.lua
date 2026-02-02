require("UnLua")
local GiftModel = GiftController:GetModel()
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})
M._components = {
  "BluePrints.UI.WBP.Gift.Widget.WBP_Gift_ShopTarget_ChooseContent_GamePadConpoment"
}

function M:InitContent(Content)
  DebugPrintTable(Content)
  self.Content = Content
  self.ShopItemId = Content.ShopItemId
  if self.Owner and self.Owner.ClearAllGamepadShortcutContent then
    self.Owner:ClearAllGamepadShortcutContent()
  end
  self:ShowGamepadCloseBtn(true)
  self:InitGiftInfo()
  self:InitFriends()
  self.Com_Qa:Init({
    OwnerWidget = self,
    TextContent = self:GetQAText(),
    OnMenuOpenChangedCallBack = self.OnDescOpenChanged
  })
  self:AddDispatcher(EventID.UnLoadUI, self, self.OnUIUnLoad)
end

function M:OnUIUnLoad(UIName)
  DebugPrint("yklua OnUIUnLoad" .. UIName)
  if "PersonInfoPageMain" == UIName then
    if not self.Owner:IsVisible() then
      self.Owner:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.IsGamePad then
      self:AddTimer(0.01, function()
        self:InitOriginFocus()
      end)
    end
  end
end

function M:GetQAText()
  local ConsumeGiftQuota, TotalGiftQuota = GiftModel:GetTotalGiftQuota()
  local CurrentMonthSendGiftCount, TotalGiftCount = GiftModel:GetTotalGiftCount()
  return string.format(GText("UI_SendGift_Desc"), ConsumeGiftQuota, TotalGiftQuota, CurrentMonthSendGiftCount, TotalGiftCount)
end

function M:Construct()
  self.Text_Empty:SetText(GText("UI_SendGift_NoFriend"))
  self.Text_ChooseTargetTitle:SetText(GText("UI_SendGift_ChooseFriend"))
  self.MaxPerRow = 3
end

function M:InitFriends()
  local Friends = GiftModel:GetFriends()
  if not Friends or 0 == #Friends then
    self.WS_List:SetActiveWidgetIndex(1)
    self:UpdateEmptyFriendsShortcuts(false)
    return
  end
  self.WS_List:SetActiveWidgetIndex(0)
  self.List_FriendContent:ClearListItems()
  for _, Friend in pairs(Friends) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.HeadFrameId = Friend.Info.HeadFrameId
    Content.Nickname = Friend.Info.Nickname
    Content.HeadIconId = Friend.Info.HeadIconId
    Content.Uid = Friend.Uid
    Content.Parent = self
    Content.ShopItemId = self.ShopItemId
    self.List_FriendContent:AddItem(Content)
  end
  self.List_FriendContent.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.List_FriendContent:RequestFillEmptyContent()
  self:UpdateEmptyFriendsShortcuts(true)
end

function M:InitGiftInfo()
  if not self.ShopItemId then
    return
  end
  local ShopItemData = DataMgr.ShopItem and DataMgr.ShopItem[self.ShopItemId]
  if not ShopItemData then
    return
  end
  local ItemType = ShopItemData.ItemType
  local TypeId = ShopItemData.TypeId
  local ItemData = DataMgr[ItemType] and DataMgr[ItemType][TypeId]
  if not ItemData then
    return
  end
  local Icon = ItemUtils.GetItemIcon(TypeId, ItemType)
  if self.ImageGiftItemBG then
    local DynamicMaterial = self.ImageGiftItemBG:GetDynamicMaterial()
    if IsValid(DynamicMaterial) then
      if Icon then
        DynamicMaterial:SetTextureParameterValue("IconMap", Icon)
      end
      local Rarity = ItemUtils.GetItemRarity(TypeId, ItemType) or 1
      DynamicMaterial:SetScalarParameterValue("Index", Rarity)
      DynamicMaterial:SetScalarParameterValue("IconOpacity", 1)
      if 6 == Rarity then
        DynamicMaterial:SetScalarParameterValue("ColorfulSwitch", 1)
        DynamicMaterial:SetScalarParameterValue("AddOpacity", 1)
        DynamicMaterial:SetScalarParameterValue("IconAddOpacity", 1)
      else
        DynamicMaterial:SetScalarParameterValue("ColorfulSwitch", 0)
        DynamicMaterial:SetScalarParameterValue("AddOpacity", 0)
        DynamicMaterial:SetScalarParameterValue("IconAddOpacity", 0)
      end
    end
  end
  local ItemName = ItemUtils:GetDropName(TypeId, ItemType)
  if self.Text_GiftPackName then
    self.Text_GiftPackName:SetText(GText(ItemName))
  end
  local Rewards = ItemData.RewardId and DataMgr.Reward and DataMgr.Reward[ItemData.RewardId]
  if self.List_Item then
    self.List_Item:ClearListItems()
    if Rewards and Rewards.Id and Rewards.Count and Rewards.Type then
      for i = 1, #Rewards.Id do
        local RewardItemId = Rewards.Id[i]
        local RewardCount = RewardUtils:GetCount(Rewards.Count[i])
        local RewardType = Rewards.Type[i]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = RewardItemId
        Content.Icon = ItemUtils.GetItemIconPath(RewardItemId, RewardType)
        Content.ParentWidget = self
        Content.ItemType = RewardType
        Content.Count = RewardCount
        Content.Rarity = ItemUtils.GetItemRarity(RewardItemId, RewardType) or 1
        Content.IsShowDetails = true
        Content.UIName = "ShopMain"
        Content.bNoJumpPreview = true
        self.List_Item:AddItem(Content)
      end
      local count = #Rewards.Id
      if self.Group_Item and count and count < 3 and self.ItemSize then
        self.Group_Item:SetWidthOverride(self.ItemSize * count)
      end
    else
      local SingleContent = NewObject(UIUtils.GetCommonItemContentClass())
      SingleContent.Id = TypeId
      SingleContent.Icon = ItemUtils.GetItemIconPath(TypeId, ItemType)
      SingleContent.ParentWidget = self
      SingleContent.ItemType = ItemType
      SingleContent.Count = ShopItemData.TypeNum or 1
      SingleContent.Rarity = ItemUtils.GetItemRarity(TypeId, ItemType) or 1
      SingleContent.IsShowDetails = true
      SingleContent.UIName = "ShopMain"
      self.List_Item:AddItem(SingleContent)
      if self.VB_Item then
        self.VB_Item:SetVisibility(ESlateVisibility.Collapsed)
      end
    end
  end
  local Cost = ShopUtils:GetShopItemPrice(self.ShopItemId)
  local isPayGoods = DataMgr.ShopItem2PayGoods and DataMgr.ShopItem2PayGoods[self.ShopItemId] ~= nil
  if isPayGoods then
    local moneySymbol = ShopUtils:GetCurrencyType()
    if self.Text_Price then
      self.Text_Price:SetText(GText(moneySymbol) .. tostring(Cost))
    end
    if self.Img_Currency then
      self.Img_Currency:SetVisibility(ESlateVisibility.Collapsed)
    end
  else
    if self.Text_Price then
      self.Text_Price:SetText(Cost)
    end
    if self.Img_Currency and ShopItemData.PriceType then
      local currencyIcon = ItemUtils.GetItemIcon(ShopItemData.PriceType, "Resource")
      if currencyIcon then
        self.Img_Currency:SetBrushResourceObject(currencyIcon)
        self.Img_Currency:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      end
    end
  end
  if isPayGoods then
    self._TopResourceIdList = nil
  else
    local fundId = ShopItemData.PriceType
    if fundId then
      self._TopResourceIdList = {fundId}
    else
      self._TopResourceIdList = nil
    end
  end
  local CutoffData = ShopUtils:GetShopItemCutoffData(self.ShopItemId)
  self.CutoffData = CutoffData
  if self.Text_Undiscounted_Price then
    self.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Panel_Discount then
    self.Panel_Discount:SetVisibility(ESlateVisibility.Collapsed)
  end
  if CutoffData then
    if self.Text_Discount and CutoffData.CutoffShow then
      self.Text_Discount:SetText(100 - CutoffData.CutoffShow)
    end
    if self.Text_Undiscounted_Price then
      local originalPrice
      if isPayGoods and DataMgr.ShopItem2PayGoods and DataMgr.PayGoods then
        local payId = DataMgr.ShopItem2PayGoods[self.ShopItemId]
        local payData = payId and DataMgr.PayGoods[payId]
        local priceField = ShopUtils:GetCurrencyPrice()
        originalPrice = payData and payData[priceField] or Cost
      else
        originalPrice = ShopItemData.Price or Cost
      end
      self.Text_Undiscounted_Price:SetText(math.ceil(originalPrice))
      self.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if self.Panel_Discount then
      self.Panel_Discount:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  end
  if self.Group_More and self.Text_MoreNum then
    if ShopItemData.ShowBonus then
      self.Group_More:SetVisibility(ESlateVisibility.Visible)
      self.Text_MoreNum:SetText("+" .. ShopItemData.ShowBonus)
    else
      self.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:UpdateEmptyFriendsShortcuts(hasFriends)
  local Owner = self.Owner
  if not Owner then
    return
  end
  local idxCheckPlayer = self.CheckPlayerBtnIdx
  local idxConfirm = self.ConfirmBtnIdx
  if not hasFriends then
    if idxCheckPlayer and Owner.HideGamepadShortcut then
      Owner:HideGamepadShortcut(idxCheckPlayer)
    end
    if idxConfirm and Owner.HideGamepadShortcut then
      Owner:HideGamepadShortcut(idxConfirm)
    end
  else
    if idxCheckPlayer and Owner.ShowGamepadShortcut then
      Owner:ShowGamepadShortcut(idxCheckPlayer)
    end
    if idxConfirm then
      local ConfirmKey = Owner.GetGamepadShortcutByIndex and Owner:GetGamepadShortcutByIndex(idxConfirm) or nil
      if ConfirmKey and ConfirmKey.SetDescription then
        ConfirmKey:SetDescription(GText("UI_CTL_Select"))
      end
      if Owner.ShowGamepadShortcut then
        Owner:ShowGamepadShortcut(idxConfirm)
      end
    end
  end
end

function M:UpdateTileViewJustify()
  local tv = self.List_Item
  if not (tv and tv.GetNumItems) or not tv.SetEntryWidth then
    return
  end
  local count = tv:GetNumItems()
  if not count or count <= 0 then
    return
  end
  local limit = self.MaxPerRow or 3
  if not self._OriginalEntryWidth and tv.GetEntryWidth then
    self._OriginalEntryWidth = tv:GetEntryWidth()
  end
  if count >= limit then
    if self._OriginalEntryWidth then
      tv:SetEntryWidth(self._OriginalEntryWidth)
    end
    return
  end
  local uiMgr = UIManager(tv)
  local parent = tv:GetParent()
  local size = uiMgr and uiMgr:GetWidgetRenderSize(tv) or nil
  size = parent and parent:Cast(UScrollBox) and uiMgr and uiMgr:GetWidgetRenderSize(parent) or size
  local availW = size and size.X or nil
  if not availW or availW <= 0 then
    return
  end
  local spacing = tv.EntrySpacing or 0
  local totalSpacing = spacing * (count - 1)
  local perWidth = (availW - totalSpacing) / count
  tv:SetEntryWidth(math.max(1, perWidth))
end

function M:UpdateItemContainerWidth()
  local tv = self.List_Item
  if not tv or not tv.GetNumItems then
    return
  end
  local count = tv:GetNumItems()
  if not count or count <= 0 then
    return
  end
  local width
  if 1 == count and self.SingleItemWidth then
    width = self.SingleItemWidth
  elseif 2 == count and self.DoubleItemWidth then
    width = self.DoubleItemWidth
  else
    return
  end
  if not self.VB_Item or not self.VB_Item.Slot then
    return
  end
  local slot = self.VB_Item.Slot
  local curSize = slot.GetSize and slot:GetSize() or nil
  local height = curSize and curSize.Y or 0
  slot:SetSize(FVector2D(width, height))
end

function M:PostInitContent(Params, PopupData, Owner)
  if self._TopResourceIdList and #self._TopResourceIdList > 0 then
    self:RefreshTopResourceBar(self._TopResourceIdList)
  else
    self:RefreshTopResourceBar(nil)
  end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self.IsGamePad = true
    IsEventHandled = self:OnGamePadDown(InKeyName)
  else
    self.IsGamePad = false
  end
  if IsEventHandled then
    return true
  else
    return false
  end
end

function M:RefreshTopResourceBar(ResourceIdList)
  local Owner = self.Owner
  if not (Owner and Owner.TopResourcePanel) or not Owner.WBP_Com_Tab_Node_ResourceBar then
    return
  end
  if ResourceIdList and #ResourceIdList > 0 then
    Owner.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Visible)
    Owner.WBP_Com_Tab_Node_ResourceBar:InitResourceBar(ResourceIdList)
    local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
    Owner.WBP_Com_Tab_Node_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
    Owner.WBP_Com_Tab_Node_ResourceBar:SetGetReplyOnBack(function()
      self:InitOriginFocus()
      return nil
    end)
    if self.List_FriendContent then
      Owner.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(self.List_FriendContent)
    else
      Owner.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(Owner)
    end
  else
    Owner.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

AssembleComponents(M)
return M
