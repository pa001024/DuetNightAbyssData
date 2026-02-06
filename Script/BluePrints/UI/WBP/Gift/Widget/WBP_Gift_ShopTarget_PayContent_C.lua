require("UnLua")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner:GetButtonBar().Btn_Yes:BindEventOnClicked(self, self.OnClickYes)
  self.Owner:GetButtonBar().Btn_Quit:BindEventOnClicked(self, self.OnClickNo)
  self.Owner:GetButtonBar().Btn_Yes:SetIconPanelVisibility(UIConst.VisibilityOp.Collapsed)
  self.Owner:GetButtonBar().Btn_Quit:SetIconPanelVisibility(UIConst.VisibilityOp.Collapsed)
  self.Owner:GetButtonBar().Btn_Yes.bAutoButtonChange = false
  self.Owner:GetButtonBar().Btn_Quit.bAutoButtonChange = false
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.ShopItemId = Params.ShopItemId
  self.Uid = Params.Uid
  self.CallbackInfo = Params.CallbackInfo
  self.BeforeClickNoCallback = Params.BeforeClickNoCallback
  self.CostNum = Params.CostNum or 0
  self.CostType = Params.CostType
  if not self.CostType and not self.ShopItemId then
    return
  end
  self.PriceType = self.CostType
  if self.ShopItemId then
    self.PriceType = DataMgr.ShopItem[self.ShopItemId].PriceType
  end
  local Need = ShopUtils:GetNeedRechargeCount(self.ShopItemId, self.PriceType, self.CostNum)
  self.Text_Price:SetText(Need)
  local CurrencyId = self.PriceType
  local CurrencyConfig = DataMgr.Resource[CurrencyId]
  self.Icon_Currency:Init({
    Id = CurrencyConfig.ResourceId,
    Icon = ItemUtils.GetItemIcon(self.PriceType, "Resource"),
    ItemType = CurrencyConfig.ResourceSType,
    UIName = "GiftGet",
    IsShowDetails = true,
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
  })
  self.NeedShopItemData = ShopUtils:GetRechargeItem(self.ShopItemId, self.PriceType, self.CostNum)
  if not self.NeedShopItemData then
    return
  end
  local PriceType = ShopUtils:GetCurrencyPrice()
  local Price = DataMgr.PayGoods[DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId]][PriceType]
  local Count = DataMgr.ShopItem[self.NeedShopItemData.ItemId].TypeNum
  self.RechargeItem:SetRechargeItemCost(self.NeedShopItemData, Price, Count)
  self.RechargeItem:SetVisibility(ESlateVisibility.HitTestInvisible)
  self.Owner:GetButtonBar().Btn_Yes:SetText(GText(ShopUtils:GetCurrencyType() .. Price))
end

function M:Construct()
  self.Text_GiftTitle_1:SetText(GText("UI_SendGift_Pay1"))
  self.Text_GiftTitle_2:SetText(GText("UI_SendGift_Pay2"))
  self:AddDispatcher(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
end

function M:OnClickYes()
  if DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId] then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return false
    end
    self.IsClickYes = true
    if not HeroUSDKSubsystem():IsHeroSDKEnable() then
      local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
      GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm pgi " .. DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId])
      return
    end
    Avatar:RequestPay(DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
      if not ErrorCode:Check(ret) then
        return
      end
      self.OrderId = OrderId
      local PaymentParameters = FHeroUPaymentParameters()
      PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId]
      PaymentParameters.cpOrder = OrderId
      PaymentParameters.callbackUrl = CallbackUrl
      local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
      HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo)
    end)
  end
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems, OrderId)
  if Result == ErrorCode.RET_SUCCESS and self.CallbackInfo and self.IsClickYes then
    self.CallbackInfo.Func(self.CallbackInfo.Obj, GoodsId, ShopItems, OrderId)
  else
  end
end

function M:OnClickNo()
  if self.BeforeClickNoCallback and self.BeforeClickNoCallback.Func and self.BeforeClickNoCallback.Obj then
    self.BeforeClickNoCallback.Func(self.BeforeClickNoCallback.Obj)
  end
  ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = nil})
  PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
end

function M:Destruct()
  M.Super.Destruct(self)
  self.IsClickYes = nil
end

return M
