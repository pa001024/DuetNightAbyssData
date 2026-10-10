local Component = {}
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")

function Component:RequestPay(GoodsId, Callback)
  print(_G.LogTag, "RequestPay", GoodsId)
  self:CallServer("RequestPay", Callback, GoodsId)
end

function Component:OnPayFinished(Result, GoodsId, OrderId, ShopItems)
  print(_G.LogTag, "OnPayFinished", Result, GoodsId, OrderId, ShopItems)
  self:NotifyPayFinish(OrderId, Result, GoodsId, ShopItems)
  local bShoppingCartOrder = GoodsId == CommonConst.ShoppingCartPayGoodsId
  local PayGoodsInfo = DataMgr.PayGoods[GoodsId]
  if Result == ErrorCode.RET_SUCCESS then
    if ShopItems and not bShoppingCartOrder and PayGoodsInfo and PayGoodsInfo.ItemId then
      local ShopItemData = DataMgr.ShopItem[PayGoodsInfo.ItemId]
      assert(ShopItemData, "购买成功后读表ShopItemData为空", PayGoodsInfo.ItemId)
      if ShopItemData.ItemType == "DailyPack" then
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, ShopItems, ShopItemData.IsSpPopup, function()
          UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_DailyPack_PurchaseDone"))
        end, nil, true)
      else
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, ShopItems, ShopItemData.IsSpPopup, ShopUtils:GetCloseGetItemPageCallback(), nil, true)
      end
    end
  else
    UIManager(GWorld.GameInstance):ShowError(Result, 1.0, "CommonToastMain")
  end
  EventManager:FireEvent(EventID.OnRechargeFinished, Result, GoodsId, ShopItems, OrderId)
  if bShoppingCartOrder then
    return
  end
  if not PayGoodsInfo then
    self.logger.error("OnPayFinished PayGoodsInfo not exist", GoodsId, OrderId)
    return
  end
  local EMHeroUSDKSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMHeroUSDKSubsystem:StaticClass())
  local Parameters = TMap("", "")
  local FBParameters = TMap("", "")
  local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
  Parameters:Add("content_id", tostring(PayGoodsInfo.ItemId))
  Parameters:Add("currency", "USD")
  Parameters:Add("revenue", tostring(PayGoodsInfo.PriceUSD))
  Parameters:Add("user_id", tostring(GameRoleInfo.roleId))
  Parameters:Add("order_id", tostring(OrderId))
  Parameters:Add("item_id", tostring(GoodsId))
  Parameters:Add("server_id", tostring(GameRoleInfo.serverId))
  FBParameters:Add("fb_content_id", tostring(PayGoodsInfo.ItemId))
  FBParameters:Add("fb_currency", "USD")
  FBParameters:Add("_valueToSum", tostring(PayGoodsInfo.PriceUSD))
  FBParameters:Add("fb_order_id", tostring(OrderId))
  EMHeroUSDKSubsystem:MSDKSendPurchaseWithOrderIdWithChannel(OrderId, PayGoodsInfo.PriceUSD, "USD", Parameters, FBParameters)
end

function Component:ListenPayFinish(OrderId, EventFunc)
  if not OrderId then
    return
  end
  if not EventFunc then
    return
  end
  if not self.WaitPayDict then
    self.WaitPayDict = {}
  end
  self.WaitPayDict[OrderId] = EventFunc
end

function Component:UnListenPayFinish(OrderId)
  if not OrderId then
    return
  end
  if not self.WaitPayDict then
    return
  end
  self.WaitPayDict[OrderId] = nil
end

function Component:NotifyPayFinish(OrderId, Result, GoodsId, ShopItems)
  if not self.WaitPayDict then
    return
  end
  if not OrderId then
    return
  end
  local EventFunc = self.WaitPayDict[OrderId]
  self.WaitPayDict[OrderId] = nil
  if EventFunc then
    EventFunc(Result, OrderId, GoodsId, ShopItems)
  end
end

function Component:LeaveWorld()
  self.WaitPayDict = nil
end

function Component:GetCumulativeRechargeReward(Callback, EventId, Index)
  DebugPrint("GetCumulativeRechargeReward", EventId, Index)
  assert(EventId)
  Index = Index or -1
  
  local function cb(ret, Rewards)
    if Callback then
      Callback(ret, Rewards)
    end
  end
  
  self:CallServer("GetCumulativeRechargeReward", cb, EventId, Index)
end

return Component
