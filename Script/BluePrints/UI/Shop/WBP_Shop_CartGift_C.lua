require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local ShopUtils = require("Utils.ShopUtils")
local RewardUtils = require("Utils.RewardUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self.CartItem = nil
  self.ShopItemId = nil
  self.ShopItemData = nil
  self.bPending = false
  self.Text_BuyLeftTimes:SetText(GText("UI_SHOP_SHOPITEMLIMIT"))
  if self.Com_Time and self.Com_Time.Text_TimeTitle then
    self.Com_Time.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Controller_Check then
    self.Controller_Check:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb
        }
      },
      Desc = ""
    })
    self.Controller_Check:SetVisibility(ESlateVisibility.Collapsed)
  end
  EventManager:AddEvent(EventID.OnShoppingCartChanged, self, self.OnShoppingCartChanged)
end

function M:InitCartGiftInfo(CartItem, bPending, Content)
  self.Content = Content
  self.CartItem = CartItem
  self.bPending = bPending or false
  if not self.CartItem then
    return
  end
  self.ShopItemId = self.CartItem.ShopItemId
  self.ShopItemData = self.ShopItemId and DataMgr.ShopItem[self.ShopItemId]
  if not self.ShopItemData then
    return
  end
  self:InitGiftInfo()
end

function M:InitGiftInfo()
  if not self.ShopItemData then
    return
  end
  self:CleanTimer()
  local ShopItemData = self.ShopItemData
  local CartItem = self.CartItem
  local Icon = ItemUtils.GetItemIcon(ShopItemData.TypeId, ShopItemData.ItemType)
  if Icon and self.Image_Icon then
    self.Image_Icon:SetBrushFromTexture(Icon)
  end
  local ItemName = ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType)
  if self.Text_GiftTitle then
    self.Text_GiftTitle:SetText(GText(ItemName))
  end
  if self.Text_PriceSign then
    self.Text_PriceSign:SetText(GText(ShopUtils:GetCurrencyType()))
  end
  self:UpdatePriceDisplay()
  self:UpdateLimitInfo()
  self:UpdateRewardList()
  if self.CheckBox_Select then
    self.CheckBox_Select:SetIsChecked(CartItem.Selected == true)
    self.CheckBox_Select:SetIsEnabled(not self.bPending)
    if not self.CheckBoxBound then
      self.CheckBoxBound = true
      self.CheckBox_Select:BindEventOnClicked({
        Inst = self,
        Func = self.OnClickSelect
      })
    end
  end
  self:UpdateRequireWarning()
  self:InitNumInput()
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
  if self.Controller_Check then
    self.Controller_Check:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdatePriceDisplay()
  if not self.Text_PriceNum or not self.ShopItemId then
    return
  end
  local UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemId)
  local Count = self.CartItem and self.CartItem.Count or 1
  self.Text_PriceNum:SetText(tostring(UnitPrice * Count))
end

function M:InitNumInput()
  if not self.NumInput then
    return
  end
  local MaxCount = math.max(1, self:GetMaxCount())
  if not self.NumInputInitialized then
    local SliderConfigData = {
      InitValue = self.CartItem.Count,
      MinValue = 0,
      MaxValue = MaxCount,
      ClickInterval = 1,
      MinBtnCallback = self.OnCountChanged,
      MaxBtnCallback = self.OnCountChanged,
      bEnableAddSpecificBtn = false,
      bDisableLongPress = true,
      IsNotAllowTextFieldInput = true,
      MinusBtnCallback = self.OnCountChanged,
      AddBtnCallback = self.OnCountChanged,
      SliderChangeCallback = self.OnCountChanged,
      OwnerPanel = self,
      PlatformName = "PC"
    }
    self.NumInput:Init(SliderConfigData)
    self.NumInputInitialized = true
  else
    self.NumInput:OverrideValueLimit(self.CartItem.Count, MaxCount, 0, true)
  end
end

function M:UpdateLimitInfo()
  if self.Group_LimitTime then
    self.Group_LimitTime:SetVisibility(ESlateVisibility.Collapsed)
  elseif self.Com_Time then
    self.Com_Time:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Text_BuyLeftTimes then
    local LimitText = ShopUtils:GetUnifiedLimitText(self.ShopItemData.ItemId)
    if "" ~= LimitText then
      self.Text_BuyLeftTimes:SetText(GText("UI_SHOP_SHOPITEMLIMIT") .. ": " .. LimitText)
    else
      self.Text_BuyLeftTimes:SetText("")
    end
  end
  if not self.Com_Time then
    return
  end
  if self.ShopItemData.RefreshTime then
    if self.Group_LimitTime then
      self.Group_LimitTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Com_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if self.Com_Time.Image_ClockIcon and self.Com_Time.Img_Refresh then
      self.Com_Time.Image_ClockIcon:SetBrush(self.Com_Time.Img_Refresh)
    end
    self:UpdateShopItemRefreshTime(self.ShopItemData.RefreshTime)
  elseif self.ShopItemData.StartTime and self.ShopItemData.EndTime then
    if self.Group_LimitTime then
      self.Group_LimitTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Com_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if self.Com_Time.Image_ClockIcon and self.Com_Time.Img_Time then
      self.Com_Time.Image_ClockIcon:SetBrush(self.Com_Time.Img_Time)
    end
    self:UpdateLimitTime(self.ShopItemData.EndTime, self.Com_Time.Text_TimeDesc)
    self:AddTimer(1, self.UpdateLimitTime, true, 0, "RefreshEndTimer", true, self.ShopItemData.EndTime, self.Com_Time.Text_TimeDesc)
  end
end

function M:UpdateRewardList()
  if not self.List_Item then
    return
  end
  self.List_Item:ClearListItems()
  local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
  if not ItemData then
    return
  end
  local Rewards = DataMgr.Reward[ItemData.RewardId]
  if not Rewards then
    return
  end
  local RewardIds = Rewards.Id
  local RewardCounts = Rewards.Count
  local RewardTypes = Rewards.Type
  for i = 1, #RewardIds do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = RewardIds[i]
    Content.Icon = ItemUtils.GetItemIconPath(RewardIds[i], RewardTypes[i])
    Content.ParentWidget = self
    Content.ItemType = RewardTypes[i]
    Content.Count = RewardUtils:GetCount(RewardCounts[i])
    Content.Rarity = ItemUtils.GetItemRarity(RewardIds[i], RewardTypes[i]) or 1
    Content.IsShowDetails = true
    Content.UIName = "ShopMain"
    self.List_Item:AddItem(Content)
  end
  self.List_Item:RequestFillEmptyContent()
end

function M:UpdateRequireWarning()
  if not self.Text_RequireWarning or not self.CheckBox_Select then
    return
  end
  if ShopUtils:IsShoppingCartItemRequireWarning(self.ShopItemData.ItemId) then
    local RequireItemId = self.ShopItemData.Require
    local RequireItemData = DataMgr.ShopItem[RequireItemId]
    local RequireName = ""
    if RequireItemData then
      RequireName = GText(ItemUtils:GetDropName(RequireItemData.TypeId, RequireItemData.ItemType))
    end
    self.Text_RequireWarning:SetText(string.format(GText("UI_Shop_ShoppingCart_Front"), RequireName))
    self.Text_RequireWarning:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.CheckBox_Select:SetIsChecked(false)
    self.CheckBox_Select:SetIsEnabled(false)
  else
    self.Text_RequireWarning:SetText("")
    self.Text_RequireWarning:SetVisibility(ESlateVisibility.Collapsed)
    self.CheckBox_Select:SetIsEnabled(not self.bPending)
  end
end

function M:UpdateShopItemRefreshTime(RefreshTime)
  if not RefreshTime then
    if self.Group_LimitTime then
      self.Group_LimitTime:SetVisibility(ESlateVisibility.Collapsed)
    elseif self.Com_Time then
      self.Com_Time:SetVisibility(ESlateVisibility.Collapsed)
    end
    return
  end
  if self.Group_LimitTime then
    self.Group_LimitTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  elseif self.Com_Time then
    self.Com_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  ShopUtils:RefreshShopRefreshTime(RefreshTime, self.Com_Time.Text_TimeDesc, self.ShopItemData.ItemId)
  self:AddTimer(1, ShopUtils.RefreshShopRefreshTime, true, 0, "RefreshTimeTimer", true, RefreshTime, self.Com_Time.Text_TimeDesc, self.ShopItemData.ItemId)
end

function M:UpdateLimitTime(ItemEndTime, TimeWidget)
  local EndTime = ItemEndTime
  if EndTime <= TimeUtils.NowTime() then
    self:CleanTimer()
    EventManager:FireEvent(EventID.RefreshShop)
    return
  end
  local RemainTimeStr = ShopUtils:UpdateLimitTime(EndTime)
  TimeWidget:SetText(string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr))
end

function M:OnGamepadConfirm()
  if self.bPending then
    return
  end
  if self.Click then
    self:PlayAnimation(self.Click)
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and self.CartItem and self.ShopItemId) or not self.CheckBox_Select then
    return
  end
  if self.CheckBox_Select.IsForbidden then
    return
  end
  local bSelected = self.CartItem.Selected ~= true
  local ExpectedRevision = Avatar.ShoppingCart.Revision
  Avatar:SetShoppingCartItemSelected(self.ShopItemId, bSelected, ExpectedRevision)
end

function M:OnClickSelect()
  if self.bPending then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and self.CartItem) or not self.ShopItemId then
    return
  end
  if not self.CheckBox_Select then
    return
  end
  local bSelected = self.CheckBox_Select:IsChecked()
  if bSelected == (self.CartItem.Selected == true) then
    return
  end
  local ExpectedRevision = Avatar.ShoppingCart.Revision
  Avatar:SetShoppingCartItemSelected(self.ShopItemId, bSelected, ExpectedRevision)
end

function M:OnCountChanged(NewCount)
  if self.bPending then
    self:InitNumInput()
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and self.CartItem) or not self.ShopItemId then
    self:InitNumInput()
    return
  end
  if 0 == NewCount then
    self:InitNumInput()
    self:ShowRemoveConfirm(function()
      local ExpectedRevision = Avatar.ShoppingCart.Revision
      Avatar:SetShoppingCartItemCount(self.ShopItemId, 0, ExpectedRevision)
    end)
    return
  end
  local ExpectedRevision = Avatar.ShoppingCart.Revision
  Avatar:SetShoppingCartItemCount(self.ShopItemId, NewCount, ExpectedRevision)
  self:InitNumInput()
end

function M:ShowRemoveConfirm(OnConfirm)
  local Params = {}
  local ToastText = GText("UI_Shop_ShoppingCart_ClearToast1")
  if self.ShopItemData then
    local GiftName = GText(ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType))
    ToastText = string.format(ToastText, GiftName)
  end
  Params.ShortText = ToastText
  Params.LeftCallbackObj = self
  Params.RightCallbackObj = self
  Params.RightCallbackFunction = OnConfirm
  UIManager(self):ShowCommonPopupUI(100010, Params, self)
end

function M:OnShoppingCartChanged()
  if not self.CartItem or not self.ShopItemId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.ShoppingCart) or not Avatar.ShoppingCart.Items then
    return
  end
  local CartItem = Avatar.ShoppingCart.Items[self.ShopItemId]
  if not CartItem then
    return
  end
  self.CartItem = CartItem
  self.bPending = self.Content and self.Content.bPending or false
  if self.CheckBox_Select then
    self.CheckBox_Select:SetIsChecked(CartItem.Selected == true)
  end
  if self.NumInput and self.NumInput.CurInputNumber ~= CartItem.Count then
    self:InitNumInput()
  end
  self:UpdatePriceDisplay()
  self:UpdateRequireWarning()
end

function M:GetMaxCount()
  local Remain, Total = ShopUtils:GetContextRemainAndTotal(self.ShopItemId)
  if -1 == Remain or -1 == Total then
    return CommonConst.ShopOncePurchaseLimit
  end
  return math.max(1, Remain)
end

function M:Destruct()
  self:CleanTimer()
  if self.CheckBox_Select then
    self.CheckBox_Select:UnBindEventOnClickedByObj(self)
  end
  EventManager:RemoveEvent(EventID.OnShoppingCartChanged, self)
end

return M
