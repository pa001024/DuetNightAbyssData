require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local MonthCardModel = require("BluePrints.UI.WBP.Perk.MonthCard.MonthCardModel")
local M = {}

function M:IsCanOpenPay(bOpen)
  return true
end

function M:GetSDKRegisterRegionCode()
  local DefaultRegion = "CN"
  if UE.AHotUpdateGameMode.IsGlobalPak() then
    DefaultRegion = "US"
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return DefaultRegion
  end
  local RegionCode = Avatar.SdkRegisterRegionCode
  if not RegionCode or "" == RegionCode or not DataMgr.CountryRegionCode[RegionCode] then
    RegionCode = DefaultRegion
  end
  return RegionCode
end

function M:GetRegionCode()
  local DefaultRegion = "CN"
  if UE.AHotUpdateGameMode.IsGlobalPak() then
    DefaultRegion = "US"
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return DefaultRegion
  end
  local RegionCode = Avatar.SdkLoginRegionCode
  if not RegionCode or "" == RegionCode or not DataMgr.CountryRegionCode[RegionCode] then
    RegionCode = DefaultRegion
  end
  return RegionCode
end

function M:GetCurrencyType()
  local DefaultRegion = "CN"
  if UE.AHotUpdateGameMode.IsGlobalPak() then
    DefaultRegion = "US"
  end
  local RegionCode = self:GetRegionCode()
  if not DataMgr.CountryRegionCode[RegionCode] then
    return DataMgr.CountryRegionCode[DefaultRegion].MoneySymbol
  end
  return DataMgr.CountryRegionCode[RegionCode].MoneySymbol
end

function M:GetCurrencyPrice()
  local DefaultRegion = "CN"
  if UE.AHotUpdateGameMode.IsGlobalPak() then
    DefaultRegion = "US"
  end
  local RegionCode = self:GetRegionCode()
  if not DataMgr.CountryRegionCode[RegionCode] then
    return DataMgr.CountryRegionCode[DefaultRegion].MoneyCode
  end
  return "Price" .. DataMgr.CountryRegionCode[RegionCode].MoneyCode
end

function M:HasFreeShop(ShopType)
  local ItemIds = {}
  for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
    local Data = DataMgr.ShopItem2ShopTab[MainTabId]
    assert(Data, "未找到对应商城主页签:" .. MainTabId)
    for _, ShopItemData in pairs(Data) do
      for _, ItemId in pairs(ShopItemData) do
        if self:IsFree(ItemId) then
          table.insert(ItemIds, ItemId)
        end
      end
    end
  end
  return #ItemIds > 0, ItemIds
end

function M:HasNewShop(ShopType)
  local ItemIds = {}
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false, ItemIds
  end
  for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
    local Data = DataMgr.ShopItem2ShopTab[MainTabId]
    assert(Data, "未找到对应商城主页签:" .. MainTabId)
    for _, ShopItemData in pairs(Data) do
      for _, ItemId in pairs(ShopItemData) do
        if Avatar:CheckShopItemEnhanceRedDot(ItemId) then
          table.insert(ItemIds, ItemId)
        end
      end
    end
  end
  return #ItemIds > 0, ItemIds
end

function M:IsFree(ShopItemId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  if 0 == self:GetShopItemPrice(ShopItemId) and Avatar:CheckShopItemCanPurchase(ShopItemId) then
    return true
  end
  return false
end

function M:GetShopItemCutoffData(ShopItemId)
  if not DataMgr.ShopItem2Cutoff[ShopItemId] then
    return
  end
  for _, CutoffId in pairs(DataMgr.ShopItem2Cutoff[ShopItemId]) do
    local CutoffData = DataMgr.Cutoff[CutoffId]
    local NowTime = TimeUtils.NowTime()
    if NowTime > CutoffData.CutoffStartTime and (not CutoffData.CutoffEndTime or NowTime < CutoffData.CutoffEndTime) then
      return CutoffData
    end
  end
end

function M:GetShopItemPrice(ShopItemId, VoucherId)
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  assert(ShopItemData, "商品不存在：" .. ShopItemId)
  if DataMgr.ShopItem2PayGoods[ShopItemId] then
    local PayGoodData = DataMgr.PayGoods[DataMgr.ShopItem2PayGoods[ShopItemId]]
    assert(PayGoodData, "充值商品对应信息不存在:" .. DataMgr.ShopItem2PayGoods[ShopItemId])
    local PriceType = self:GetCurrencyPrice()
    local Price = PayGoodData[PriceType]
    return Price
  end
  local CutoffData = self:GetShopItemCutoffData(ShopItemId)
  local ShopItemPrice = ShopItemData.Price or 0
  if CutoffData then
    ShopItemPrice = CutoffData.CutoffPrice or ShopItemData.Price
  end
  ShopItemPrice = self:GetPriceAfterDiscount(ShopItemId, ShopItemPrice, VoucherId)
  return ShopItemPrice
end

function M:GetShopItemPurchaseLimit(ShopItemId)
  if not ShopItemId then
    return 0
  end
  local Avatar = GWorld:GetAvatar()
  local ShopData = DataMgr.ShopItem[ShopItemId]
  local ShopNetData = Avatar.ShopItems[ShopItemId]
  local PurchaseLimit
  if not ShopNetData or not ShopNetData.RemainPurchaseTimes then
    if ShopData then
      PurchaseLimit = ShopData.PurchaseLimit
    end
  else
    PurchaseLimit = ShopNetData.RemainPurchaseTimes
  end
  return PurchaseLimit or -1
end

function M:GetGiftItemPurchaseLimit(ShopItemId, Uid)
  if not ShopItemId then
    ScreenPrint("没有传入商品:" .. ShopItemId)
    return -1
  end
  local ShopData = DataMgr.ShopItem[ShopItemId]
  if not ShopData then
    ScreenPrint("商品不存在 SendGiftLimit:" .. ShopItemId)
    return -1
  end
  local MaxTimes = ShopData.SendGiftLimit
  if not MaxTimes then
    return -1
  end
  local SentTimes = GiftModel:GetGiftHadSendCount(ShopItemId, Uid)
  local remain = MaxTimes - (SentTimes or 0)
  if remain < 0 then
    remain = 0
  end
  return remain
end

function M:GetGiftItemPurchaseTotalLimit(ShopItemId)
  if not ShopItemId then
    ScreenPrint("没有传入商品:" .. ShopItemId)
    return -1
  end
  local MaxTimes = DataMgr.ShopItem[ShopItemId].SendGiftLimit
  if not MaxTimes then
    return -1
  end
  return MaxTimes
end

function M:GetContextRemainAndTotal(ShopItemId)
  local InGift = GiftController and GiftController:IsInGiftShop()
  if InGift then
    local GiftMain = GiftController and GiftController:GetGiftMainPage() or nil
    local Uid = GiftMain and GiftMain.FriendUid or nil
    local Remain = self:GetGiftItemPurchaseLimit(ShopItemId, Uid)
    local Total = self:GetGiftItemPurchaseTotalLimit(ShopItemId)
    return Remain, Total
  else
    local Remain = self:GetShopItemPurchaseLimit(ShopItemId)
    local ShopData = DataMgr.ShopItem[ShopItemId]
    local Total = ShopData and ShopData.PurchaseLimit or -1
    return Remain, Total
  end
end

function M:GetUnifiedLimitText(ShopItemId, InCludeText)
  local Remain, Total = self:GetContextRemainAndTotal(ShopItemId)
  if -1 == Remain or -1 == Total or Remain < 0 or Total < 0 then
    return ""
  end
  if InCludeText then
    local InGift = GiftController and GiftController:IsInGiftShop()
    local Key = InGift and "UI_SendGift_GiftItemMax" or "UI_SHOP_SHOPITEMLIMIT"
    return GText(Key) .. Remain .. "/" .. Total
  end
  return Remain .. "/" .. Total
end

function M:ShouldShowDiscount(ShopItemId, ShopItemData)
  if not ShopItemData or not ShopItemData.ShowBonus then
    return false
  end
  local InGift = GiftController and GiftController:IsInGiftShop()
  if InGift then
    local Remain, Total = self:GetContextRemainAndTotal(ShopItemId)
    return -1 == Remain or -1 == Total or Remain > 0
  else
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return false
    end
    return not Avatar:CheckShopItemSoldOutDisplay(ShopItemId)
  end
end

function M:ShouldPlaySoldOutAnimation(ShopItemId)
  local Remain, Total = self:GetContextRemainAndTotal(ShopItemId)
  local Unlimited = -1 == Remain or -1 == Total
  return not Unlimited and not (Remain > 0)
end

function M:GetGiftItemCanShow(ShopItemId, Uid)
  assert(DataMgr.ShopItem[ShopItemId], "商品不存在:" .. ShopItemId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar:CheckIsEffective(ShopItemId) then
    return false
  end
  if 0 == self:GetGiftItemPurchaseLimit(ShopItemId, Uid) and not DataMgr.ShopItem[ShopItemId].RefreshTime and not DataMgr.ShopItem[ShopItemId].SoldOutDisplay then
    return false
  end
  if Avatar:CheckShopItemHasRequire(ShopItemId) then
    return false
  end
  if Avatar:CheckShopItemHasRexclusionGroup(ShopItemId) then
    return false
  end
  return true
end

function M:GetImprShopItemPurchaseLimit(ShopItemId)
  local AvailableTime = 0
  local ShopItemData = DataMgr.ImpressionShop[ShopItemId]
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local Info = Avatar.ImpressionShops[ShopItemData.ImpressionShopId]
    if ShopItemData.PurchaseLimit and Info then
      local LimitTime = ShopItemData.PurchaseLimit
      AvailableTime = LimitTime - Info.AlreadyPurchaseTimes
    else
      AvailableTime = -1
    end
  end
  return AvailableTime
end

function M:GetShopItemCanShow(ShopItemId)
  assert(DataMgr.ShopItem[ShopItemId], "商品不存在：" .. ShopItemId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar:CheckIsEffective(ShopItemId) then
    return false
  end
  if 0 == self:GetShopItemPurchaseLimit(ShopItemId) and not DataMgr.ShopItem[ShopItemId].RefreshTime and not DataMgr.ShopItem[ShopItemId].SoldOutDisplay then
    return false
  end
  if Avatar:CheckShopItemHasRequire(ShopItemId) then
    return false
  end
  if Avatar:CheckShopItemHasRexclusionGroup(ShopItemId) then
    return false
  end
  if Avatar:CheckShopItemUnique(ShopItemId) and not DataMgr.ShopItem[ShopItemId].SoldOutDisplay then
    return false
  end
  return true
end

function M:GetRefreshTime(ItemId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ShopNetData = Avatar.ShopItems[ItemId]
  if ShopNetData and ShopNetData.LastRefreshTime then
    return ShopNetData.LastRefreshTime
  end
  local ShopItemRefreshTimeType = {
    NOREFRESH = 0,
    HOUR = 1,
    DAY = 2,
    WEEK = 3,
    MONTH = 4
  }
  local ShopItemInfo = DataMgr.ShopItem[ItemId]
  local RefreshTime = ShopItemInfo.RefreshTime
  local RefreshTimeType = ShopItemRefreshTimeType.NOREFRESH
  if RefreshTime then
    for key, value in pairs(RefreshTime) do
      if ShopItemRefreshTimeType[key] then
        RefreshTimeType = ShopItemRefreshTimeType[key]
      end
    end
  end
  local StartTime, LastRefreshTime
  if ShopItemInfo.NewRefreshBeginTime then
    StartTime = ShopItemInfo.NewRefreshBeginTime
  else
    StartTime = TimeUtils.DataToTimestamp(CommonConst.ShopRefreshBeginTime[1], CommonConst.ShopRefreshBeginTime[2], CommonConst.ShopRefreshBeginTime[3], CommonConst.ShopRefreshBeginTime[4], CommonConst.ShopRefreshBeginTime[5], CommonConst.ShopRefreshBeginTime[6])
  end
  if RefreshTimeType == ShopItemRefreshTimeType.HOUR then
    local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
    LastRefreshTime = TimeUtils.DataToTimestamp(year, month, day, hour, 0, 0)
  elseif RefreshTimeType == ShopItemRefreshTimeType.DAY then
    local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
    local refresh_hms = CommonConst.GAME_REFRESH_HMS
    LastRefreshTime = TimeUtils.DataToTimestamp(year, month, day, table.unpack(refresh_hms))
  elseif RefreshTimeType == ShopItemRefreshTimeType.WEEK then
    StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
    local refresh_hms = CommonConst.GAME_REFRESH_HMS
    LastRefreshTime = TimeUtils.NextWeeklyRefreshTime(StartTime, refresh_hms)
  elseif RefreshTimeType == ShopItemRefreshTimeType.MONTH then
    local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
    local refresh_hms = CommonConst.GAME_REFRESH_HMS
    LastRefreshTime = TimeUtils.DataToTimestamp(year, month, 1, table.unpack(refresh_hms))
  else
    LastRefreshTime = StartTime
  end
  return LastRefreshTime
end

function M:RefreshShopRefreshTime(RefreshTime, Widget, ShopItemId)
  local ShopRefreshBeginTime = CommonConst.ShopRefreshBeginTime
  local StartTime = os.time({
    year = ShopRefreshBeginTime[1],
    month = ShopRefreshBeginTime[2],
    day = ShopRefreshBeginTime[3],
    hour = ShopRefreshBeginTime[4],
    min = ShopRefreshBeginTime[5],
    sec = ShopRefreshBeginTime[6]
  })
  if ShopItemId then
    local LastRefreshTime = M:GetRefreshTime(ShopItemId)
    if not LastRefreshTime then
      if self and self.RemoveTimer then
        self:RemoveTimer("RefreshTimeTimer")
      end
      return
    end
    StartTime = LastRefreshTime
  end
  local NextRefreshTimeTable = os.date("*t", StartTime)
  local CurrentTime = TimeUtils.NowTime()
  local Interval = 0
  local timeDifference = 0
  local RemainRefreshTime = 0
  if RefreshTime.HOUR then
    Interval = RefreshTime.HOUR * 60 * 60
    timeDifference = CurrentTime - StartTime
    RemainRefreshTime = Interval - timeDifference % Interval
  elseif RefreshTime.DAY then
    Interval = RefreshTime.DAY * 60 * 60 * 24
    timeDifference = CurrentTime - StartTime
    RemainRefreshTime = Interval - timeDifference % Interval
  elseif RefreshTime.WEEK then
    StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
    local refresh_hms = CommonConst.GAME_REFRESH_HMS
    local LastRefreshTime = TimeUtils.NextWeeklyRefreshTime(StartTime, refresh_hms)
    Interval = RefreshTime.WEEK * 7 * 60 * 60 * 24
    timeDifference = CurrentTime - LastRefreshTime
    RemainRefreshTime = Interval - timeDifference % Interval
  elseif RefreshTime.MONTH then
    local NowRealTime = os.date("*t", TimeUtils.NowTime())
    while M:IsLaterThanNow(NextRefreshTimeTable, NowRealTime) == false do
      if NextRefreshTimeTable.month + RefreshTime.MONTH > 12 then
        NextRefreshTimeTable.year = NextRefreshTimeTable.year + 1
        NextRefreshTimeTable.month = NextRefreshTimeTable.month + RefreshTime.MONTH - 12
      else
        NextRefreshTimeTable.month = NextRefreshTimeTable.month + RefreshTime.MONTH
      end
    end
    local NextRefreshTime = os.time(NextRefreshTimeTable)
    RemainRefreshTime = os.difftime(NextRefreshTime, TimeUtils.NowTime())
  end
  local RemainTimeStr = M:GetRefreshTimeStr(RemainRefreshTime)
  Widget:SetText(RemainTimeStr)
end

function M:GetRefreshTimeStr(RefreshTime)
  local RemainTimeStr = ""
  local TimeCount = 0
  if RefreshTime > 86400 then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), math.floor(RefreshTime / 86400))
    RefreshTime = RefreshTime % 86400
  end
  if RefreshTime > 3600 or 1 == TimeCount then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), math.floor(RefreshTime / 3600))
    RefreshTime = RefreshTime % 3600
  end
  if RefreshTime > 60 and TimeCount < 2 or 1 == TimeCount then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), math.floor(RefreshTime / 60))
    RefreshTime = RefreshTime % 60
  end
  if RefreshTime > 0 and TimeCount < 2 or 1 == TimeCount then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), math.floor(RefreshTime))
  end
  return RemainTimeStr
end

function M:UpdateLimitTime(ShopItemEndTime)
  local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
  local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(ShopItemEndTime and ShopItemEndTime.GetTime())
  local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTiem)
  local RemainTimeStr = ""
  local TimeCount = 0
  if UKismetMathLibrary.GetDays(RemainTime) > 0 then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
  end
  if UKismetMathLibrary.GetHours(RemainTime) > 0 or 1 == TimeCount then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), UKismetMathLibrary.GetHours(RemainTime))
  end
  if UKismetMathLibrary.GetMinutes(RemainTime) > 0 and TimeCount < 2 or 1 == TimeCount then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), UKismetMathLibrary.GetMinutes(RemainTime))
  end
  if UKismetMathLibrary.GetSeconds(RemainTime) > 0 and TimeCount < 2 or 1 == TimeCount then
    TimeCount = TimeCount + 1
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), UKismetMathLibrary.GetSeconds(RemainTime))
  end
  return string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr)
end

function M:IsLaterThanNow(Time, NowRealTime)
  local CurrentYear = NowRealTime.year
  local CurrentMonth = NowRealTime.month
  local CurrentDay = NowRealTime.day
  local CurrentHour = NowRealTime.hour
  if CurrentYear > Time.year then
    return false
  elseif CurrentYear == Time.year then
    if CurrentMonth > Time.month then
      return false
    elseif CurrentMonth == Time.month then
      if CurrentDay > Time.day then
        return false
      elseif CurrentDay == Time.day and CurrentHour >= Time.hour then
        return false
      end
    end
  end
  return true
end

function M:CanPurchase(ShopItemData, PriceType, Price)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  ShopItemData.PurchaseFailRes = 0
  local ShopItemRemainTimes = self:GetShopItemPurchaseLimit(ShopItemData.ItemId)
  if 0 == ShopItemRemainTimes then
    ShopItemData.PurchaseFailRes = 1
    return false
  end
  if Avatar:CheckShopItemUnique(ShopItemData.ItemId) then
    ShopItemData.PurchaseFailRes = 6
    return false
  end
  if ShopItemData.UnlockLevel and Avatar.Level < ShopItemData.UnlockLevel then
    ShopItemData.PurchaseFailRes = 3
    return false
  end
  if not Avatar:CheckShopItemUnlockRaidPoint(ShopItemData.ItemId) then
    ShopItemData.PurchaseFailRes = 7
    return false
  end
  if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
    return true
  end
  local PriceCount = Avatar.Resources[PriceType] and Avatar.Resources[PriceType].Count or 0
  if Price > PriceCount then
    if ShopItemData.PriceType == CommonConst.Coins.Coin1 then
      local totalCount = PriceCount + (Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0)
      if Price <= totalCount then
        ShopItemData.PurchaseFailRes = 4
      else
        ShopItemData.PurchaseFailRes = 5
      end
      return true
    elseif ShopItemData.PriceType == CommonConst.Coins.Coin4 then
      ShopItemData.PurchaseFailRes = 5
      return true
    end
    ShopItemData.PurchaseFailRes = 2
    return false
  end
  return true
end

function M:Purchase(ShopItemData, ParentWidget)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
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
  if 0 ~= ShopItemData.PurchaseFailRes then
    if 1 == ShopItemData.PurchaseFailRes then
      UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
    elseif 2 == ShopItemData.PurchaseFailRes then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[ShopItemData.PriceType].ResourceName)), 1.0)
    elseif 3 == ShopItemData.PurchaseFailRes then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), ShopItemData.UnlockLevel), 1.0)
    elseif 7 == ShopItemData.PurchaseFailRes then
      UIManager(self):ShowUITip("CommonToastMain", string.format(GText("RaidDungeon_Shop_Locked"), ShopItemData.UnlockRaidPoint), 1.0)
    elseif 6 == ShopItemData.PurchaseFailRes then
      UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_UNIQUE_ALREDAY_OWNED, 1.0, "CommonToastMain")
    elseif 4 == ShopItemData.PurchaseFailRes then
      local PopUpId = 100136
      local Avatar = GWorld:GetAvatar()
      if not Avatar then
        return
      end
      local ItemName = ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType)
      local PriceCount = Avatar.Resources[ShopItemData.PriceType] and Avatar.Resources[ShopItemData.PriceType].Count or 0
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
        PopoverText = string.gsub(PopoverText, "&Num1&", ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount)
      end
      if string.find(PopoverText, "&Num2&") then
        PopoverText = string.gsub(PopoverText, "&Num2&", ParentWidget.CurrentCount)
      end
      
      local function Confirm()
        local Coin4Count = 0
        if Avatar.Resources[CommonConst.Coins.Coin4] then
          Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4].Count
        end
        if Coin4Count < ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount then
          local function JumpToShop()
            PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
          end
          
          local Params = {}
          Params.Title = GText("UI_COMMONPOP_TITLE_100137")
          Params.ShortText = GText("UI_COMMONPOP_TEXT_100137")
          Params.LeftCallbackObj = self
          Params.RightCallbackObj = self
          Params.RightCallbackFunction = JumpToShop
          UIManager(self):ShowCommonPopupUI(100137, Params, self)
        else
          self:SendExchangeRequest(ShopItemData.ItemId, ParentWidget.CurrentCount)
        end
      end
      
      local ItemList = {}
      local Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0
      table.insert(ItemList, {
        ItemId = CommonConst.Coins.Coin4,
        ItemType = CommonConst.ItemType.Resource,
        ItemNum = Coin4Count,
        ItemNeed = ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount
      })
      local Params = {
        RightCallbackFunction = Confirm,
        ItemList = ItemList,
        ShortText = PopoverText
      }
      UIManager(self):ShowCommonPopupUI(PopUpId, Params)
    elseif 5 == ShopItemData.PurchaseFailRes then
      local function JumpToShop()
        PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
      end
      
      local Params = {}
      Params.Title = GText("UI_COMMONPOP_TITLE_100138")
      Params.ShortText = GText("UI_COMMONPOP_TEXT_100198")
      Params.LeftCallbackObj = ParentWidget
      Params.RightCallbackObj = ParentWidget
      Params.RightCallbackFunction = JumpToShop
      UIManager(self):ShowCommonPopupUI(100137, Params, ParentWidget.ParentWidget)
    end
    return
  end
  local ShopMain = UIManager(self):GetUIObj("ShopMain")
  ShopMain:BlockAllUIInput(true)
  Avatar:PurchaseShopItem(ShopItemData.ItemId, 1)
end

function M:SendPurchaseRequest(ShopItemId, CurrentCount, VoucherId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:PurchaseShopItem(ShopItemId, CurrentCount, nil, nil, VoucherId)
  local ShopMain = UIManager(self):GetUIObj("ShopMain")
  local ShopActivity = UIManager(self):GetUIObj("ActivityShop")
  local CommonShopActivity = UIManager(self):GetUIObj("ShopActivity")
  if ShopMain then
    ShopMain:BlockAllUIInput(true)
  end
  if ShopActivity then
    ShopActivity:BlockAllUIInput(true)
  end
  if CommonShopActivity then
    CommonShopActivity:BlockAllUIInput(true)
  end
end

function M:SendExchangeRequest(ShopItemId, CurrentCount, NotShow)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Callback(Ret, ShopItemId, Count, PackRewards)
    EventManager:FireEvent(EventID.OnPurchaseShopItem, Ret, ShopItemId, CurrentCount)
    local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
    if ShopMain then
      ShopMain:BlockAllUIInput(false)
    end
    local SkinPreview = UIManager(GWorld.GameInstance):GetUIObj("SkinPreview")
    if SkinPreview then
      SkinPreview:BlockAllUIInput(false)
    end
    if Ret == ErrorCode.RET_SUCCESS then
      local ShopItemData = DataMgr.ShopItem[ShopItemId]
      if not NotShow then
        UIManager(GWorld.GameInstance):UnLoadUI("ShopItemSingle")
        UIManager(GWorld.GameInstance):UnLoadUI("ShopItemPackage")
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(ShopItemData.ItemType, ShopItemData.TypeId, ShopItemData.TypeNum * Count, PackRewards, ShopItemData.IsSpPopup)
      end
      EventManager:FireEvent(EventID.OnPurchaseShopItemSuccess, Ret, ShopItemData.TypeId, CurrentCount, PackRewards)
    elseif Ret == ErrorCode.RET_SHOPITEM_IS_NOT_VALID then
      UIManager(GWorld.GameInstance):UnLoadUI("ShopItemSingle")
      UIManager(GWorld.GameInstance):UnLoadUI("ShopItemPackage")
      UIManager(GWorld.GameInstance):ShowError(Ret, 1.0, "CommonToastMain")
    elseif Ret == ErrorCode.RET_SHOPITEM_MONEY_NEEDED_NOT_ENOUGH then
      UIManager(GWorld.GameInstance):ShowError(Ret, 1.0, "CommonToastMain")
    elseif Ret == ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO then
      UIManager(GWorld.GameInstance):ShowError(Ret, 1.0, "CommonToastMain")
    end
    if ShopMain then
      ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap, true, true)
    end
    if SkinPreview then
      SkinPreview:RefreshPurchaseState()
    end
  end
  
  Avatar:PurchaseShopItemUseCoin1(ShopItemId, CurrentCount, Callback)
end

function M:ShowPurchaseDialog(ItemType, ItemId, ShopType, UIName)
  if not ItemType or not ItemId then
    return
  end
  ShopType = ShopType or "Shop"
  if (not (DataMgr.ShopItem2ShopSubId[ItemType] and DataMgr.ShopItem2ShopSubId[ItemType][ShopType]) or not DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId]) and DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId].ShopItemId then
    return false
  end
  local SelectShopItemId
  for _, ShopItemData in ipairs(DataMgr.ShopItem2ShopSubId[ItemType][ShopType][ItemId]) do
    if ShopUtils:GetShopItemCanShow(ShopItemData.ShopItemId) and 0 ~= ShopUtils:GetShopItemPurchaseLimit(ShopItemData.ShopItemId) then
      SelectShopItemId = ShopItemData.ShopItemId
      break
    end
  end
  if not SelectShopItemId then
    return false
  end
  local ShopItemData = setmetatable({}, {
    __index = DataMgr.ShopItem[SelectShopItemId]
  })
  local FundId = ShopItemData.PriceType
  local FundNeed = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
  ShopUtils:CanPurchase(ShopItemData, FundId, FundNeed)
  if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return false
    end
    if not HeroUSDKSubsystem():IsHeroSDKEnable() then
      local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
      GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(), "sgm pgi " .. DataMgr.ShopItem2PayGoods[ShopItemData.ItemId])
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
      HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo)
    end)
  else
    AudioManager(self):PlayItemSound(self, ShopItemData.TypeId, "Click", ShopItemData.ItemType)
    local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(ShopItemData.ItemId)
    local ItemData = DataMgr[ShopItemData.ItemType][ShopItemData.TypeId]
    local bForbidden = not ShopUtils:CanPurchase(ShopItemData, ShopItemData.PriceType, ShopUtils:GetShopItemPrice(ShopItemData.ItemId))
    local CommonPopupUIID
    if UIUtils.CanOpenSkinPreview(ShopItemData.ItemType, ShopItemData.TypeId) then
      UIManager(self):LoadUINew("SkinPreview", ShopItemData, self)
    elseif ShopItemData.ItemType == "Reward" and (DataMgr.Reward[ItemData.RewardId].Mode == "Fixed" or DataMgr.Reward[ItemData.RewardId].Mode == "Once") then
      if 1 == ShopItemData.Bg then
        UIManager(self):LoadUINew("PayGiftPopup_Yellow", ShopItemData, self)
      elseif 2 == ShopItemData.Bg then
        UIManager(self):LoadUINew("PayGiftPopup_Purple", ShopItemData, self)
      else
        UIManager(self):LoadUINew("PayGiftPopup_Purple", ShopItemData, self)
      end
    elseif 0 == RemainTimes or 6 == ShopItemData.PurchaseFailRes then
      CommonPopupUIID = 100042
    else
      CommonPopupUIID = 100041
    end
    if not CommonPopupUIID then
      return
    end
    local Funds = {}
    Funds[1] = {}
    Funds[1].FundId = ShopItemData.PriceType
    Funds[1].FundNeed = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
    local ShopUIName = DataMgr.Shop[ShopType].ShopUIName
    local CommonDialog = UIManager(self):ShowCommonPopupUI(CommonPopupUIID, {
      ShopItemData = ShopItemData,
      ShopType = 0,
      Funds = Funds,
      ShowParentTabCoin = true,
      UIName = UIName,
      LeftCallbackObj = self,
      LeftCallbackFunction = function(Obj, PackageData)
        local Shop = UIManager(self):GetUIObj(ShopUIName)
        if Shop then
          Shop:SetFocus()
        end
      end,
      RightCallbackObj = self,
      RightCallbackFunction = function(Obj, PackageData)
        PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
      end,
      ForbiddenRightCallbackObj = self,
      ForbiddenRightCallbackFunction = function(Obj, PackageData)
        PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
      end,
      DontFocusParentWidget = true,
      CloseBtnCallbackObj = self,
      CloseBtnCallbackFunction = function(Obj, PackageData)
        local Shop = UIManager(self):GetUIObj(ShopUIName)
        if Shop then
          Shop:SetFocus()
        end
      end,
      ForbidRightBtn = not ShopUtils:CanPurchase(ShopItemData, Funds[1].FundId, Funds[1].FundNeed)
    }, UIManager(self):GetUIObj(ShopUIName))
  end
end

function M:GetNeedRechargeCount(ShopItemId, PriceType, CostNum, VoucherId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local OwnedResource = Avatar.Resources[PriceType]
  local OwnedCurrencyAmount = OwnedResource and OwnedResource.Count or 0
  local Cost = 0
  if CostNum and 0 ~= CostNum then
    Cost = CostNum
  end
  if ShopItemId then
    Cost = ShopUtils:GetShopItemPrice(ShopItemId, VoucherId) or 0
  end
  if CommonConst.Coins.Coin1 == PriceType then
    local Coin4Data = Avatar.Resources[CommonConst.Coins.Coin4]
    local Coin4Count = Coin4Data and Coin4Data.Count or 0
    OwnedCurrencyAmount = OwnedCurrencyAmount + Coin4Count
  end
  local NeedCount = Cost - OwnedCurrencyAmount
  if NeedCount <= 0 then
    return 0
  end
  return NeedCount
end

function M:GetRechargeItem(ShopItemId, PriceType, CostNum, VoucherId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local OwnedResource = Avatar.Resources[PriceType]
  local OwnedCurrencyAmount = OwnedResource and OwnedResource.Count or 0
  if CommonConst.Coins.Coin1 == PriceType then
    local Coin4Data = Avatar.Resources[CommonConst.Coins.Coin4]
    local Coin4Count = Coin4Data and Coin4Data.Count or 0
    OwnedCurrencyAmount = OwnedCurrencyAmount + Coin4Count
  end
  local Cost = 0
  if CostNum and 0 ~= CostNum then
    Cost = CostNum
  end
  if ShopItemId then
    Cost = ShopUtils:GetShopItemPrice(ShopItemId, VoucherId) or 0
  end
  local NeedCount = Cost - OwnedCurrencyAmount
  if NeedCount <= 0 then
    return
  end
  local NeedShopItemData
  for i, Id in ipairs(Const.ReChargeLst) do
    if DataMgr.ShopItem[Id] then
      local Count = DataMgr.ShopItem[Id].TypeNum
      if Avatar:CheckIsFirstBonus(Id) then
        Count = Count + DataMgr.FirstBonusNum[Id].FirstBonusNum
      else
        Count = Count + DataMgr.FirstBonusNum[Id].BonusNum
      end
      NeedShopItemData = DataMgr.ShopItem[Id]
      if NeedCount <= Count then
        break
      end
    end
  end
  return NeedShopItemData
end

function M:SetCloseGetItemPageCallback(Params)
  self.CloseGetItemPageCallback = Params.CloseGetItemPageCallback
end

function M:GetCloseGetItemPageCallback()
  local Callback = self.CloseGetItemPageCallback
  self.CloseGetItemPageCallback = nil
  return Callback
end

function M:GetCharWeaponHasLevelMax(ShopItemId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if ShopItemData.ItemType == "Walnut" then
    local WalnutData = DataMgr.Walnut[ShopItemData.TypeId]
    local GradeLevel = 0
    if WalnutData.MainRewardType == "Char" then
      for CharUid, Data in pairs(Avatar.Chars) do
        if Data.CharId == WalnutData.MainRewardId then
          if DataMgr.UltraCharCardLevelUp[Data.CharId] and Data.ExtraGradeLevel > 0 then
            return true
          end
          GradeLevel = Data.GradeLevel
          break
        end
      end
      if not DataMgr.UltraCharCardLevelUp[WalnutData.MainRewardId] and GradeLevel == DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue then
        return true
      end
    elseif WalnutData.MainRewardType == "Weapon" then
      for WeaponUid, Data in pairs(Avatar.Weapons) do
        if Data.WeaponId == WalnutData.MainRewardId and Data.GradeLevel >= DataMgr.WeaponCardLevel[Data.WeaponId].CardLevelMax then
          return true
        end
      end
    end
  end
  return false
end

local ForbiddenBannerBp = {WBP_Shop_Banner_MonthCard = true}

function M:GetBannerInfo(bSwitchTab)
  local BannerIdDict = {}
  local BannerData = {}
  local SmallBannerData = {}
  local SoldOutBannerData = {}
  local Time = TimeUtils.NowTime()
  local bForbiddenPurchase = not self:IsCanOpenPay(true)
  for _, v in pairs(DataMgr.ShopBannerTab) do
    if v.IsSwitchTab == bSwitchTab and (not bForbiddenPurchase or not ForbiddenBannerBp[v.Bp]) and Time >= v.StartTime then
      local isExpired = v.EndTime and Time > v.EndTime
      if not isExpired then
        if v.ShortTabSequence then
          table.insert(SmallBannerData, v)
        else
          if v.BannerType == UIConst.ShopBannerType.DailyPack then
            local DisplayableItems = self:GetDailyPackShopItemInfo(v.Id)
            if 0 == #DisplayableItems then
          end
          else
            local DailyPackSoldOut = v.BannerType == UIConst.ShopBannerType.DailyPack and self:ShouldSinkDailyPackTab(v)
            local MonthCardSoldOut = v.BannerType == UIConst.ShopBannerType.MonthCard and MonthCardModel:IsMonthCardPurchased()
            if v.SoldOutSinkBanner and v.ItemId and 0 == self:GetShopItemPurchaseLimit(v.ItemId) or MonthCardSoldOut or DailyPackSoldOut then
              table.insert(SoldOutBannerData, v)
            else
              table.insert(BannerData, v)
            end
            BannerIdDict[v.Id] = true
          end
        end
      elseif v.BannerType == UIConst.ShopBannerType.DailyPack and not self:ShouldHideDailyPackTab(v) then
        table.insert(SoldOutBannerData, v)
        BannerIdDict[v.Id] = true
      end
    end
  end
  if #SmallBannerData > 4 then
    local SmallBannerDataSort = {}
    local MonthBanner
    for index, data in ipairs(SmallBannerData) do
      if data.BannerType == UIConst.ShopBannerType.MonthCard then
        MonthBanner = data
      elseif #SmallBannerDataSort < 4 then
        table.insert(SmallBannerDataSort, data)
      end
    end
    table.insert(SmallBannerDataSort, MonthBanner)
    SmallBannerData = SmallBannerDataSort
  end
  table.sort(SmallBannerData, function(a, b)
    return a.ShortTabSequence < b.ShortTabSequence
  end)
  table.sort(BannerData, function(a, b)
    return a.Sequence < b.Sequence
  end)
  table.sort(SoldOutBannerData, function(a, b)
    return a.Sequence < b.Sequence
  end)
  local Res = {}
  for _, ShopData in ipairs(BannerData) do
    table.insert(Res, ShopData)
  end
  for _, ShopData in ipairs(SoldOutBannerData) do
    table.insert(Res, ShopData)
  end
  return Res, BannerIdDict, SmallBannerData
end

function M:GetComplexInfo(SubTabId)
  local ComplexData = {}
  for _, v in pairs(DataMgr.ComplexTab) do
    if v.SubTabId == SubTabId then
      table.insert(ComplexData, v)
    end
  end
  table.sort(ComplexData, function(a, b)
    return a.EntrySort > b.EntrySort
  end)
  return ComplexData
end

function M:GetShopSkinList()
  local Shop = UIManager(self):GetLastJumpPage()
  if Shop then
    return Shop.Index2ShopSkin, Shop.ShopSkin2Index, Shop.SkinCount
  end
  local ShopMain = UIManager(self):GetUIObj("ShopMain")
  if ShopMain then
    return ShopMain.Index2ShopSkin, ShopMain.ShopSkin2Index, ShopMain.SkinCount
  end
  local ShopActivity = UIManager(self):GetUIObj("ActivityShop")
  if ShopActivity then
    return ShopActivity.Index2ShopSkin, ShopActivity.ShopSkin2Index, ShopActivity.SkinCount
  end
  local CommonShopActivity = UIManager(self):GetUIObj("ShopActivity")
  if CommonShopActivity then
    return CommonShopActivity.Index2ShopSkin, CommonShopActivity.ShopSkin2Index, CommonShopActivity.SkinCount
  end
  return nil
end

function M:GetShopItemDataById(Id, ShopItemType, bCheck)
  local TypeId2ShopItems = DataMgr.TypeId2ShopItem[ShopItemType]
  TypeId2ShopItems = TypeId2ShopItems and TypeId2ShopItems[Id]
  local ShopItemId, ShopItemData
  if TypeId2ShopItems then
    local Priority
    for _, value in pairs(TypeId2ShopItems) do
      local Data = DataMgr.ShopItem[value]
      if Data and (nil == Priority or Priority < (Data.IsAccessItem or Priority)) then
        local bChecked
        if bCheck then
          Data = setmetatable({}, {__index = Data})
          bChecked = self:GetShopItemCanShow(value) and self:CanPurchase(Data, nil, 0)
        else
          bChecked = true
        end
        if bChecked then
          Priority = Data.IsAccessItem
          ShopItemId = value
          ShopItemData = Data
        end
      end
    end
  end
  return ShopItemId, ShopItemData
end

function M:GetDailyPackShopItemInfo(BannerId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return {}
  end
  local DailyPackShopItemInfo = {}
  for _, DailyPackData in pairs(DataMgr.DailyPack) do
    if DailyPackData.BannerId == BannerId then
      local ShopItemId = DataMgr.PayGoods[DailyPackData.GoodsId].ItemId
      if not ShopItemId then
        DebugPrint("请检查一下分日礼包对应的PayGoods:[" .. tostring(DailyPackData.GoodsId) .. "] 是否填写了商店商品ID")
      else
        local ShopData = DataMgr.ShopItem[ShopItemId]
        if not ShopData then
          DebugPrint("请检查一下分日礼包对应的商店商品ID:[" .. tostring(ShopItemId) .. "] 是否存在")
        else
          local ShouldShow = false
          if Avatar:CheckIsEffective(ShopItemId) then
            ShouldShow = true
          elseif self:ShouldShowCompletionTime(ShopData.TypeId) then
            ShouldShow = true
          else
            DebugPrint("请检查一下分日礼包对应的商店商品ID:[" .. tostring(ShopItemId) .. "] 是否在上架时间内")
          end
          if ShouldShow then
            local PlayerDailyPack = Avatar.DailyPacks[ShopData.TypeId]
            local AugmentedData = setmetatable({}, {__index = ShopData})
            AugmentedData.Reward = DailyPackData.Reward
            if PlayerDailyPack then
              AugmentedData.ExpiredTime = PlayerDailyPack.ExpiredTime
              AugmentedData.State = PlayerDailyPack.State
              AugmentedData.Count = PlayerDailyPack.Count
              AugmentedData.RewardGot = PlayerDailyPack.RewardGot
            end
            table.insert(DailyPackShopItemInfo, AugmentedData)
          end
        end
      end
    end
  end
  table.sort(DailyPackShopItemInfo, function(A, B)
    local SequenceA = A.Sequence
    local SequenceB = B.Sequence
    return SequenceA < SequenceB
  end)
  return DailyPackShopItemInfo
end

function M:ShouldShowRemainingTime(ShopItemId)
  if not ShopItemId then
    return false
  end
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  if not Avatar:CheckIsEffective(ShopItemId) then
    return false
  end
  if not ShopItemData.PurchaseLimit or ShopItemData.PurchaseLimit <= 0 then
    return true
  end
  local PlayerShopItem = Avatar.ShopItems[ShopItemId]
  if not PlayerShopItem then
    return true
  end
  return PlayerShopItem.RemainPurchaseTimes > 0
end

function M:ShouldShowCompletionTime(DailyPackId)
  if not DailyPackId then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local PlayerDailyPack = Avatar.DailyPacks[DailyPackId]
  if not PlayerDailyPack then
    return false
  end
  local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
  local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(PlayerDailyPack.ExpiredTime)
  local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTiem)
  return 1 == PlayerDailyPack.State and UKismetMathLibrary.GetDays(RemainTime) > 0
end

function M:GetDailyPackItemsForBanner(BannerId)
  local DailyPackItems = {}
  for _, DailyPackData in pairs(DataMgr.DailyPack) do
    if DailyPackData.BannerId == BannerId and DataMgr.PayGoods[DailyPackData.GoodsId] then
      local ShopItemId = DataMgr.PayGoods[DailyPackData.GoodsId].ItemId
      if DataMgr.ShopItem[ShopItemId] then
        table.insert(DailyPackItems, DataMgr.ShopItem[ShopItemId])
      end
    end
  end
  return DailyPackItems
end

function M:ShouldSinkDailyPackTab(BannerData)
  if not BannerData then
    return false
  end
  local DailyPackItems = self:GetDailyPackItemsForBanner(BannerData.Id)
  if 0 == #DailyPackItems then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  for _, itemData in ipairs(DailyPackItems) do
    local PlayerShopItem = Avatar.ShopItems[itemData.ItemId]
    if not PlayerShopItem or PlayerShopItem.RemainPurchaseTimes > 0 then
      return false
    end
  end
  return true
end

function M:ShouldHideDailyPackTab(BannerData)
  if not BannerData then
    return false
  end
  local DailyPackItems = self:GetDailyPackItemsForBanner(BannerData.Id)
  if 0 == #DailyPackItems then
    return true
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local NowTime = TimeUtils.NowTime()
  for _, itemData in ipairs(DailyPackItems) do
    local DailyPackId = itemData.TypeId
    local isStillActive = self:ShouldShowCompletionTime(DailyPackId)
    if isStillActive then
      return false
    end
  end
  return true
end

function M:UpdateRewardEndTime(ShopItemExpiredTime)
  local StartTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
  local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(ShopItemExpiredTime)
  local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTime)
  local RemainTimeStr = ""
  if UKismetMathLibrary.GetDays(RemainTime) > 0 then
    RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
  end
  return string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr)
end

function M:CanSendGift()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local PlayerLevel = Avatar.Level or 0
  if DataMgr.GiftConstant.GiftLimitLevel and PlayerLevel < DataMgr.GiftConstant.GiftLimitLevel.ConstantValue1 then
    return false
  end
  local SendGiftCount = Avatar.CurrentMonthSendGiftCount or 0
  if DataMgr.GiftConstant.GiftCountPerMonth_S and SendGiftCount >= DataMgr.GiftConstant.GiftCountPerMonth_S.ConstantValue1 then
    return false
  end
  local ConsumeGiftQuota, TotalGiftQuota = Avatar.ConsumeGiftQuota, Avatar.TotalGiftQuota
  if ConsumeGiftQuota >= TotalGiftQuota then
    return false
  end
  return true
end

function M:ShowSendGiftButton(ShopItemData)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  if Avatar.BanGiftSend then
    return false
  end
  if not ShopItemData then
    return false
  end
  if 0 == ShopItemData.PurchaseFailRes then
    return true
  elseif 1 == ShopItemData.PurchaseFailRes then
    return true
  elseif 2 == ShopItemData.PurchaseFailRes then
    return true
  elseif 3 == ShopItemData.PurchaseFailRes then
    return false
  elseif 4 == ShopItemData.PurchaseFailRes then
    return true
  elseif 5 == ShopItemData.PurchaseFailRes then
    return true
  elseif 6 == ShopItemData.PurchaseFailRes then
    return false
  elseif 7 == ShopItemData.PurchaseFailRes then
    return true
  end
  return false
end

function M:OpenChooseGiftTarget(ShopItemId, ParentWidget)
  if not ShopItemId then
    return
  end
  GiftController:OpenSelectFriendPopup(ShopItemId, ParentWidget)
end

function M:OpenForbidGiftChooseTip()
  GiftController:OpenCanNotSendPopup()
end

function M:CheckShopItemCondition(ShopItemData)
  if not ShopItemData then
    return true
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return true
  end
  return ShopItemData.ItemCondition and not Avatar:CheckCondition(ShopItemData.ItemCondition)
end

function M:OpenLockConditionPopup(ShopItemData)
  if not ShopItemData then
    return
  end
  local Params = {}
  Params.ItemConditions = ShopItemData.ItemCondition
  UIManager(self):ShowCommonPopupUI(100292, Params)
end

function M:GetValidVouchers(ShopItemData)
  local ValidVouchers = {}
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return ValidVouchers
  end
  if DataMgr.ShopItem2PayGoods and DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
    return ValidVouchers
  end
  if 1 ~= ShopItemData.PurchaseLimit then
    return ValidVouchers
  end
  local RealPrice = self:GetShopItemPrice(ShopItemData.ItemId)
  for VoucherId, VoucherInfo in pairs(DataMgr.Voucher) do
    local ResId = VoucherInfo.ResourceId
    local PlayerRes = Avatar.Resources[ResId]
    local LimitedInfo = ItemUtils.GetItemLimitedInfo(ResId)
    if PlayerRes and PlayerRes.Count > 0 then
      local bIsValidItem = false
      if VoucherInfo.ItemId and #VoucherInfo.ItemId > 0 then
        for _, TargetId in ipairs(VoucherInfo.ItemId) do
          if TargetId == ShopItemData.ItemId then
            bIsValidItem = true
            break
          end
        end
      elseif VoucherInfo.CoinResourceId == ShopItemData.PriceType then
        bIsValidItem = true
      end
      if bIsValidItem then
        local Threshold = VoucherInfo.ThresholdPrice or 0
        if RealPrice >= Threshold then
          local MergedData = {}
          local ResConfig = DataMgr.Resource[ResId]
          if ResConfig then
            for k, v in pairs(ResConfig) do
              MergedData[k] = v
            end
          end
          for k, v in pairs(VoucherInfo) do
            MergedData[k] = v
          end
          MergedData.VoucherNum = PlayerRes.Count
          MergedData.ActualDiscount = math.min(VoucherInfo.DiscountPrice or 0, RealPrice)
          MergedData.ExpireTime = LimitedInfo and LimitedInfo.EndTime or math.huge
          table.insert(ValidVouchers, MergedData)
        end
      end
    end
  end
  table.sort(ValidVouchers, function(a, b)
    local isSpecificA = a.ItemId ~= nil and #a.ItemId > 0
    local isSpecificB = b.ItemId ~= nil and #b.ItemId > 0
    if isSpecificA ~= isSpecificB then
      return isSpecificA
    end
    local actualA = a.ActualDiscount or 0
    local actualB = b.ActualDiscount or 0
    if actualA ~= actualB then
      return actualA > actualB
    end
    local discountA = a.DiscountPrice or 0
    local discountB = b.DiscountPrice or 0
    if discountA ~= discountB then
      return discountA < discountB
    end
    local timeA = a.ExpireTime
    local timeB = b.ExpireTime
    if timeA ~= timeB then
      return timeA < timeB
    end
    return (a.VoucherId or 0) < (b.VoucherId or 0)
  end)
  return ValidVouchers
end

function M:GetBestVoucher(ValidVouchers)
  if ValidVouchers and #ValidVouchers > 0 then
    return ValidVouchers[1]
  end
  return nil
end

function M:GetPriceAfterDiscount(ShopItemId, ShopItemPrice, VoucherId)
  if not VoucherId or VoucherId <= 0 then
    return ShopItemPrice
  end
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return ShopItemPrice
  end
  if DataMgr.ShopItem2PayGoods[ShopItemId] or 1 ~= ShopItemData.PurchaseLimit then
    DebugPrint(string.format("[Warning] GetPriceAfterDiscount: Item %d is NOT allowed to use vouchers!", ShopItemId))
    return ShopItemPrice
  end
  local VoucherInfo = DataMgr.Voucher[VoucherId]
  if VoucherInfo then
    local Threshold = VoucherInfo.ThresholdPrice or 0
    if ShopItemPrice >= Threshold then
      local Discount = VoucherInfo.DiscountPrice or 0
      ShopItemPrice = math.max(ShopItemPrice - Discount, 0)
    else
      DebugPrint(string.format("[Warning] GetPriceAfterDiscount: Voucher %d threshold (%d) not met for Item %d (Price: %d)", VoucherId, Threshold, ShopItemId, ShopItemPrice))
    end
  else
    DebugPrint("[Error] GetPriceAfterDiscount: Invalid VoucherId passed: " .. tostring(VoucherId))
  end
  return ShopItemPrice
end

function M:HasAnyVoucherConfig(ShopItemId)
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return false
  end
  if DataMgr.ShopItem2PayGoods[ShopItemId] or 1 ~= ShopItemData.PurchaseLimit then
    return false
  end
  for _, VoucherInfo in pairs(DataMgr.Voucher or {}) do
    if VoucherInfo.ItemId and #VoucherInfo.ItemId > 0 then
      for _, TargetId in ipairs(VoucherInfo.ItemId) do
        if TargetId == ShopItemId then
          return true
        end
      end
    end
  end
  return false
end

return M
