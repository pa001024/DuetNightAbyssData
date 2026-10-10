require("UnLua")
local ShopUtils = require("Utils.ShopUtils")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  if self.Title then
    self.Title.Text_Title:SetText(GText("UI_Shop_ShoppingCart_Title"))
    if self.Title.BtnClose and self.Title.BtnClose.Btn_Close then
      self.Title.BtnClose.Btn_Close.OnClicked:Add(self, self.CloseSelf)
    end
  end
  self.Text_TotalPrice:SetText(GText("UI_Shop_ShoppingCart_TotalPrice"))
  self.Text_SelectAll:SetText(GText("UI_Shop_ShoppingCart_SelectAll"))
  self.Btn_Clear.Text_Button:SetText(GText("UI_Shop_ShoppingCart_Clear"))
  self.Btn_Buy.Text_BtnBuy:SetText(GText("UI_Shop_ShoppingCart_Purchase"))
  self.Btn_Clear:BindEventOnClicked(self, self.OnClickClear)
  if self.Btn_Clear.SetGamePadImg then
    self.Btn_Clear:SetGamePadImg("X")
  end
  if self.Btn_Buy and self.Btn_Buy.Btn_Buy then
    self.Btn_Buy.Btn_Buy.OnClicked:Add(self, self.OnClickBuy)
  end
  if self.Btn_Buy and self.Btn_Buy.Key_ControllerBuy then
    self.Btn_Buy.Key_ControllerBuy:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
        }
      }
    })
    local bIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    self.Btn_Buy.Key_ControllerBuy:SetVisibility(bIsGamepad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  self.CheckBox_SelectAll:BindEventOnClicked({
    Inst = self,
    Func = self.OnClickSelectAll
  })
  if self.CheckBox_SelectAll.InitGamepadKey then
    self.CheckBox_SelectAll:InitGamepadKey("LS")
  end
  self.List_Gift.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.CartItem = nil
    return Content
  end)
  self:AddDispatcher(EventID.OnShoppingCartChanged, self, self.OnShoppingCartChanged)
  self:AddDispatcher(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
  self.CurrentFocusedEntry = nil
  self:InitGamePadHint()
  self:AddInputMethodChangedListen()
end

function M:InitGamePadHint()
  if not self.WBox_Controller then
    return
  end
  self.WBox_Controller:ClearChildren()
  local HintList = {
    {
      Img = UIConst.GamePadImgKey.FaceButtonBottom,
      Desc = GText("UI_CTL_Select")
    },
    {
      Img = UIConst.GamePadImgKey.FaceButtonRight,
      Desc = GText("UI_BACK")
    }
  }
  for _, Hint in ipairs(HintList) do
    local KeyWidget = self:CreateWidgetNew("ComKeyTextDesc")
    if KeyWidget then
      KeyWidget:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = Hint.Img
          }
        },
        Desc = Hint.Desc
      })
      self.WBox_Controller:AddChild(KeyWidget)
    end
  end
  self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  local bGamepad = CurInputDevice == ECommonInputType.Gamepad
  if self.WBox_Controller then
    self.WBox_Controller:SetVisibility(bGamepad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if self.Btn_Buy and self.Btn_Buy.Key_ControllerBuy then
    self.Btn_Buy.Key_ControllerBuy:SetVisibility(bGamepad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if bGamepad then
    self:ApplyGamepadPanelSettings()
  end
end

function M:OnCartEntryFocusChanged(Entry, bFocus)
  if bFocus then
    self.CurrentFocusedEntry = Entry
  elseif self.CurrentFocusedEntry == Entry then
    self.CurrentFocusedEntry = nil
  end
end

function M:IsFocusInRewardList()
  local Entry = self.CurrentFocusedEntry
  if not Entry or not Entry.ActiveItemWidget then
    return false
  end
  local ListItem = Entry.ActiveItemWidget.List_Item
  if not ListItem then
    return false
  end
  return ListItem:HasAnyUserFocus() or ListItem:HasFocusedDescendants()
end

function M:FocusFirstCartEntry()
  if not self.List_Gift then
    self:SetFocus()
    return
  end
  local Entries = self.List_Gift:GetDisplayedEntryWidgets()
  if Entries and Entries:Length() > 0 then
    local Entry = Entries:GetRef(1)
    if Entry then
      Entry:SetFocus()
      return
    end
  end
  self:SetFocus()
end

function M:ApplyGamepadPanelSettings()
  self.bIsFocusable = true
  if self.SetIsFocusable then
    self:SetIsFocusable(true)
  end
  self.bIsShowNavigateGuide = false
  if self.SetIsShowNavigateGuide then
    self:SetIsShowNavigateGuide(false)
  end
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    if GameInputModeSubsystem.SetShowFocusedWidget then
      GameInputModeSubsystem:SetShowFocusedWidget(nil)
    end
    if GameInputModeSubsystem.SetNavigateWidgetVisibility then
      GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    end
  end
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self)
  self:RefreshCartUI()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:ApplyGamepadPanelSettings()
    self:AddTimer(0.1, self.FocusFirstCartEntry, false, 0, "FocusFirstCartEntry")
  else
    self:SetFocus()
  end
  self:PlayAnimation(self.In)
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  if not self.In then
    self:BlockAllUIInput(false)
  end
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(false)
  end
  self.Btn_Clear:UnBindEventOnClickedByObj(self)
  if self.Btn_Buy and self.Btn_Buy.Btn_Buy then
    self.Btn_Buy.Btn_Buy.OnClicked:Remove(self, self.OnClickBuy)
  end
  self.CheckBox_SelectAll:UnBindEventOnClicked({
    Inst = self,
    Func = self.OnClickSelectAll
  })
  if self.Title and self.Title.BtnClose and self.Title.BtnClose.Btn_Close then
    self.Title.BtnClose.Btn_Close.OnClicked:Remove(self, self.CloseSelf)
  end
  self.Super.Destruct(self)
end

function M:OnShoppingCartChanged()
  self:RefreshCartUI()
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems, OrderId)
  if GoodsId == CommonConst.ShoppingCartPayGoodsId then
    if Result == ErrorCode.RET_SUCCESS then
      self:ShowShoppingCartRewards(ShopItems)
    else
      UIManager(self):ShowError(Result, 1.0, "CommonToastMain")
    end
  end
end

function M:ShowShoppingCartRewards(ShopItems)
  if not ShopItems then
    return
  end
  UIUtils.ShowGetItemPage(nil, nil, nil, ShopItems, false, function()
  end, nil, true)
end

function M:RefreshCartUI()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CartItemList = ShopUtils:GetShoppingCartItemList()
  local TotalCount = ShopUtils:GetShoppingCartTotalCount()
  local SelectedCount = ShopUtils:GetShoppingCartSelectedCount()
  local TotalPrice = ShopUtils:GetShoppingCartSelectedTotalPrice()
  local bPending = ShopUtils:IsShoppingCartPending()
  self.bSuppressSelectAllCallback = true
  if TotalCount <= 0 then
    self.DisplayedShopItemIds = nil
    if self.WS_List then
      self.WS_List:SetActiveWidgetIndex(1)
      if self.Text_Empty then
        self.Text_Empty:SetText(GText("UI_Shop_ShoppingCart_Empty"))
      end
    else
      self.List_Gift:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.CheckBox_SelectAll:SetIsChecked(false)
    self.CheckBox_SelectAll:SetIsEnabled(false)
    self.Btn_Clear:ForbidBtn(true)
    self:SetBuyBtnEnabled(false)
  else
    if self.WS_List then
      self.WS_List:SetActiveWidgetIndex(0)
    end
    self.List_Gift:SetVisibility(ESlateVisibility.Visible)
    self.CheckBox_SelectAll:SetIsEnabled(not bPending)
    self.Btn_Clear:ForbidBtn(bPending)
    local AllSelected = SelectedCount > 0 and SelectedCount == TotalCount
    self.CheckBox_SelectAll:SetIsChecked(AllSelected)
    if not self:IsSameDisplayedItems(CartItemList) or bPending ~= self.CartListPending then
      self:RefreshCartItemList(CartItemList, bPending)
    end
  end
  self.bSuppressSelectAllCallback = false
  local HasSelected = SelectedCount > 0
  self.Text_PriceSign:SetText(GText(ShopUtils:GetCurrencyType()))
  self.Text_PriceNum:SetText(tostring(TotalPrice))
  self:SetBuyBtnEnabled(HasSelected and not bPending)
end

function M:SetBuyBtnEnabled(bEnabled)
  if not self.Btn_Buy then
    return
  end
  if self.Btn_Buy.Key_ControllerBuy and self.Btn_Buy.Key_ControllerBuy.SetForbidKey then
    self.Btn_Buy.Key_ControllerBuy:SetForbidKey(not bEnabled)
  end
  if self.Btn_Buy.ForbidBtn then
    self.Btn_Buy:ForbidBtn(not bEnabled)
    return
  end
  if self.Btn_Buy.Btn_Buy then
    self.Btn_Buy.Btn_Buy:SetIsEnabled(bEnabled)
    return
  end
  if self.Btn_Buy.Button_Area then
    self.Btn_Buy.Button_Area:SetIsEnabled(bEnabled)
  end
end

function M:IsSameDisplayedItems(CartItemList)
  if not self.DisplayedShopItemIds or #self.DisplayedShopItemIds ~= #CartItemList then
    return false
  end
  for i, CartItem in ipairs(CartItemList) do
    if CartItem.ShopItemId ~= self.DisplayedShopItemIds[i] then
      return false
    end
  end
  return true
end

function M:RefreshCartItemList(CartItemList, bPending)
  bPending = bPending or ShopUtils:IsShoppingCartPending()
  self.CartListPending = bPending
  self.DisplayedShopItemIds = {}
  local LastFocusedShopItemId = self.CurrentFocusedEntry and self.CurrentFocusedEntry.ShopItemId or nil
  self.List_Gift:ClearListItems()
  for i, CartItem in ipairs(CartItemList) do
    self.DisplayedShopItemIds[i] = CartItem.ShopItemId
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.CartItem = CartItem
    Content.ParentWidget = self
    Content.bPending = bPending
    self.List_Gift:AddItem(Content)
  end
  if LastFocusedShopItemId and UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:RemoveTimer("RestoreCartFocus")
    self:AddTimer(0.1, function()
      if not self:RestoreFocusToEntry(LastFocusedShopItemId) then
        self:FocusFirstCartEntry()
      end
    end, false, 0, "RestoreCartFocus")
  end
end

function M:RestoreFocusToEntry(ShopItemId)
  local Entries = self.List_Gift:GetDisplayedEntryWidgets()
  if not Entries then
    return false
  end
  for i = 1, Entries:Length() do
    local Entry = Entries:GetRef(i)
    if Entry and Entry.ShopItemId == ShopItemId then
      Entry:SetFocus()
      return true
    end
  end
  return false
end

function M:OnClickSelectAll(bForceState)
  if self.bSuppressSelectAllCallback then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if ShopUtils:IsShoppingCartPending() then
    return
  end
  local bChecked = bForceState
  if nil == bChecked then
    bChecked = self.CheckBox_SelectAll:IsChecked()
  end
  local ExpectedRevision = Avatar.ShoppingCart.Revision
  local Items = Avatar.ShoppingCart.Items
  if not Items then
    return
  end
  local ShopItemIds = {}
  for ShopItemId, CartItem in pairs(Items) do
    if CartItem.Selected ~= bChecked then
      table.insert(ShopItemIds, ShopItemId)
    end
  end
  if #ShopItemIds > 0 then
    Avatar:BatchSetShoppingCartItemSelected(ShopItemIds, bChecked, ExpectedRevision)
  end
end

function M:OnClickClear()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if ShopUtils:IsShoppingCartPending() then
    return
  end
  local Params = {}
  Params.ShortText = GText("UI_Shop_ShoppingCart_ClearToast2")
  Params.LeftCallbackObj = self
  Params.RightCallbackObj = self
  
  function Params.RightCallbackFunction()
    local ExpectedRevision = Avatar.ShoppingCart.Revision
    Avatar:ClearShoppingCart(ExpectedRevision)
  end
  
  UIManager(self):ShowCommonPopupUI(100010, Params, self)
end

function M:OnClickBuy()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if ShopUtils:IsShoppingCartPending() then
    UIManager(self):ShowError(ErrorCode.PAY_ORDER_IN_PROCESS, 1.0, "CommonToastMain")
    return
  end
  local ExpectedRevision = Avatar.ShoppingCart.Revision
  Avatar:RequestShoppingCartPay(ExpectedRevision, function(Ret, PayInfo, RemovedShopItemIds)
    if Ret == ErrorCode.RET_SUCCESS then
      self:StartShoppingCartPay(PayInfo)
    elseif Ret == ErrorCode.PAY_ITEM_CANNOT_PURCHASE then
      self:RefreshCartUI()
      UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
    elseif Ret == ErrorCode.RET_SHOPPING_CART_EMPTY then
      self:RefreshCartUI()
      UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
    elseif Ret == ErrorCode.RET_SHOPPING_CART_VERSION_MISMATCH then
      self:RefreshCartUI()
      UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
    else
      UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
    end
  end)
end

function M:StartShoppingCartPay(PayInfo)
  if not PayInfo then
    return
  end
  if not HeroUSDKSubsystem():IsHeroSDKEnable() then
    local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
    GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance, "sgm ShoppingCartPayHandlePaymentOrder " .. PayInfo.cpOrder)
    return
  end
  local PaymentParameters = FHeroUPaymentParameters()
  PaymentParameters.goodsId = PayInfo.goodsId
  PaymentParameters.cpOrder = PayInfo.cpOrder
  PaymentParameters.customMsg = PayInfo.customMsg or ""
  PaymentParameters.callbackUrl = PayInfo.callbackUrl
  PaymentParameters.propAmount = PayInfo.propAmount
  if PayInfo.propCurrency and "" ~= PayInfo.propCurrency then
    PaymentParameters.propCurrency = PayInfo.propCurrency
  end
  local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
  local ItemName = GText("UI_SHOP_SHOPPINGCART_PAYNAME")
  HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, ItemName)
end

function M:CloseSelf(bForce)
  if bForce then
    self:Close()
    return
  end
  if not self.Out then
    self:Close()
    return
  end
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnim)
  if InAnim == self.Out then
    self:Close()
  elseif InAnim == self.In then
    self:BlockAllUIInput(false)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == Const.GamepadLeftThumbstick then
      local TotalCount = ShopUtils:GetShoppingCartTotalCount()
      local SelectedCount = ShopUtils:GetShoppingCartSelectedCount()
      local bSelectAll = not (SelectedCount > 0) or SelectedCount ~= TotalCount
      self:OnClickSelectAll(bSelectAll)
      IsEventHandled = true
    elseif InKeyName == Const.GamepadFaceButtonLeft then
      self:OnClickClear()
      IsEventHandled = true
    elseif InKeyName == Const.GamepadFaceButtonUp then
      self:OnClickBuy()
      IsEventHandled = true
    elseif InKeyName == Const.GamepadFaceButtonRight then
      if self:IsFocusInRewardList() then
        if self.CurrentFocusedEntry then
          self.CurrentFocusedEntry:SetFocus()
        end
      else
        self:CloseSelf()
      end
      IsEventHandled = true
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:CloseSelf()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

return M
