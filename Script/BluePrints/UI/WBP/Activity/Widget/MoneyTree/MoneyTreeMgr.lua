require("UnLua")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local MoneyTreeMgr = {}
MoneyTreeMgr._listeners = MoneyTreeMgr._listeners or {}

function MoneyTreeMgr.GetActiveEventId()
  local ConfigTable = DataMgr.MoneyTree_Config
  if not ConfigTable then
    return nil
  end
  local Now = TimeUtils.NowTime()
  local Fallback
  for EventId in pairs(ConfigTable) do
    Fallback = Fallback or EventId
    local EventInfo = DataMgr.EventMain and DataMgr.EventMain[EventId]
    if EventInfo and (not EventInfo.EventStartTime or Now >= EventInfo.EventStartTime) and (not EventInfo.EventEndTime or Now < EventInfo.EventEndTime) then
      return EventId
    end
  end
  return Fallback
end

function MoneyTreeMgr.GetConfig()
  local EventId = MoneyTreeMgr.GetActiveEventId()
  return EventId and DataMgr.MoneyTree_Config and DataMgr.MoneyTree_Config[EventId] or nil
end

function MoneyTreeMgr.GetRewardRange(ClaimIndex)
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local RewardTable = DataMgr.MoneyTree_DailyReward
  local Row = EventId and RewardTable and RewardTable[EventId] and RewardTable[EventId][ClaimIndex]
  if Row then
    return Row.MinReward, Row.MaxReward
  end
  return 0, 0
end

function MoneyTreeMgr.GetExtraRewardCopies(ClaimIndex)
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local RewardTable = DataMgr.MoneyTree_DailyReward
  local Row = EventId and RewardTable and RewardTable[EventId] and RewardTable[EventId][ClaimIndex]
  return Row and Row.ExtraRewardCopies or 0
end

function MoneyTreeMgr.GetTotalDays()
  local Config = MoneyTreeMgr.GetConfig()
  if Config and Config.TotalDays then
    return Config.TotalDays
  end
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local RewardTable = DataMgr.MoneyTree_DailyReward
  local EventRewards = EventId and RewardTable and RewardTable[EventId]
  if not EventRewards then
    return 0
  end
  local Count = 0
  for _ in pairs(EventRewards) do
    Count = Count + 1
  end
  return Count
end

function MoneyTreeMgr.GetCurrentDay()
  local State = MoneyTreeMgr.GetState()
  local CurrentDay = State.Claimed and State.ClaimIndex - 1 or State.ClaimIndex
  return math.max(1, math.min(CurrentDay, MoneyTreeMgr.GetTotalDays()))
end

function MoneyTreeMgr.GetDailyRewardConfig(ClaimIndex)
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local RewardTable = DataMgr.MoneyTree_DailyReward
  return EventId and RewardTable and RewardTable[EventId] and RewardTable[EventId][ClaimIndex] or nil
end

function MoneyTreeMgr.GetGoodsId(PayType)
  local Config = MoneyTreeMgr.GetConfig()
  if not Config then
    return nil
  end
  return 2 == PayType and Config.AllDoubleGoodsId or Config.SingleDoubleGoodsId
end

function MoneyTreeMgr.GetPriceYuan(PayType)
  local GoodsId = MoneyTreeMgr.GetGoodsId(PayType)
  local PayGoodsData = GoodsId and DataMgr.PayGoods and DataMgr.PayGoods[GoodsId]
  return PayGoodsData and PayGoodsData.PriceCNY or 0
end

function MoneyTreeMgr.GetEndTime()
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local EventInfo = EventId and DataMgr.EventMain and DataMgr.EventMain[EventId]
  return EventInfo and EventInfo.EventEndTime or 0
end

function MoneyTreeMgr.GetLeftSeconds()
  local EndTime = MoneyTreeMgr.GetEndTime()
  if EndTime <= 0 then
    return 0
  end
  return EndTime - TimeUtils.NowTime()
end

function MoneyTreeMgr.GetLeftDays()
  return math.floor(MoneyTreeMgr.GetLeftSeconds() / 86400)
end

function MoneyTreeMgr.IsOpen()
  local EventId = MoneyTreeMgr.GetActiveEventId()
  local EventInfo = EventId and DataMgr.EventMain and DataMgr.EventMain[EventId]
  if not EventInfo then
    return false
  end
  local Now = TimeUtils.NowTime()
  local bStarted = not EventInfo.EventStartTime or Now >= EventInfo.EventStartTime
  local bNotEnded = not EventInfo.EventEndTime or Now < EventInfo.EventEndTime
  return bStarted and bNotEnded
end

function MoneyTreeMgr.IsAllUnlockTimeBlocked()
  return MoneyTreeMgr.GetLeftSeconds() <= 86400
end

function MoneyTreeMgr.GetRemainRewardDoubleDays(State)
  local Config = MoneyTreeMgr.GetConfig()
  local TotalDays = Config and Config.TotalDays or 0
  State = State or MoneyTreeMgr.GetState()
  local bTodayCanStillDouble = State.Claimed and not State.Doubled
  local RemainDoubleDays = TotalDays - (State.ClaimIndex - 1)
  if bTodayCanStillDouble then
    RemainDoubleDays = RemainDoubleDays + 1
  end
  return math.max(RemainDoubleDays, 0)
end

function MoneyTreeMgr.GetRemainActivityDoubleDays(State)
  local EndTime = MoneyTreeMgr.GetEndTime()
  local Now = TimeUtils.NowTime()
  if EndTime <= 0 or EndTime <= Now then
    return 0
  end
  State = State or MoneyTreeMgr.GetState()
  local RemainDays = TimeUtils.GetIntervalDay(Now, EndTime - 1) + 1
  if State.Claimed and State.Doubled then
    RemainDays = RemainDays - 1
  end
  return math.max(RemainDays, 0)
end

function MoneyTreeMgr.GetRemainDoubleDays()
  local State = MoneyTreeMgr.GetState()
  local RewardDays = MoneyTreeMgr.GetRemainRewardDoubleDays(State)
  local ActivityDays = MoneyTreeMgr.GetRemainActivityDoubleDays(State)
  return math.min(RewardDays, ActivityDays)
end

function MoneyTreeMgr.ShouldWarnPrice()
  local SinglePrice = MoneyTreeMgr.GetPriceYuan(1)
  local AllPrice = MoneyTreeMgr.GetPriceYuan(2)
  return AllPrice > SinglePrice * MoneyTreeMgr.GetRemainDoubleDays()
end

local function GetAvatar()
  return GWorld and GWorld:GetAvatar()
end

function MoneyTreeMgr.GetEvent()
  local Avatar = GetAvatar()
  local EventId = MoneyTreeMgr.GetActiveEventId()
  if not (Avatar and EventId) or not Avatar.MoneyTree then
    return nil
  end
  return Avatar.MoneyTree[EventId]
end

function MoneyTreeMgr.GetState()
  local Event = MoneyTreeMgr.GetEvent()
  local Config = MoneyTreeMgr.GetConfig()
  local DailyFreeCount = Config and Config.DailyFreeCount or 1
  if not Event then
    return {
      Claimed = false,
      Doubled = false,
      AllUnlocked = false,
      SingleUsed = false,
      ClaimIndex = 1,
      TodayReward = 0,
      TodayDoubleReward = 0,
      Cumulative = 0,
      TodayClaimCount = 0
    }
  end
  return {
    Claimed = DailyFreeCount <= Event.TodayClaimCount,
    Doubled = Event.TodayDoubleReward > 0,
    AllUnlocked = Event.AllDoubleUnlocked == true,
    SingleUsed = true == Event.SingleDoubleUsed,
    ClaimIndex = Event.ClaimCount + 1,
    TodayReward = Event.TodayReward,
    TodayDoubleReward = Event.TodayDoubleReward,
    Cumulative = Event.TotalReward,
    TodayClaimCount = Event.TodayClaimCount
  }
end

function MoneyTreeMgr.CanClaim()
  local State = MoneyTreeMgr.GetState()
  local Config = MoneyTreeMgr.GetConfig()
  local TotalDays = Config and Config.TotalDays or 0
  return not State.Claimed and MoneyTreeMgr.IsOpen() and TotalDays >= State.ClaimIndex
end

function MoneyTreeMgr.CanSingleDouble()
  local State = MoneyTreeMgr.GetState()
  return State.Claimed and not State.Doubled and not State.AllUnlocked and MoneyTreeMgr.IsOpen()
end

function MoneyTreeMgr.CanAllUnlock()
  local State = MoneyTreeMgr.GetState()
  return not State.AllUnlocked and not State.SingleUsed and not MoneyTreeMgr.IsAllUnlockTimeBlocked() and MoneyTreeMgr.IsOpen() and MoneyTreeMgr.GetRemainDoubleDays() > 0
end

function MoneyTreeMgr.ShouldShowEntryReddot()
  return MoneyTreeMgr.CanClaim()
end

function MoneyTreeMgr.RefreshFromServer(Callback)
  if Callback then
    Callback(0)
  end
end

function MoneyTreeMgr.Claim(Callback)
  local Avatar = GetAvatar()
  local EventId = MoneyTreeMgr.GetActiveEventId()
  if not Avatar or not EventId then
    if Callback then
      Callback(-1)
    end
    return
  end
  Avatar:MoneyTreeClaimFree(EventId, function(ErrCode, RewardCount, DoubleReward, ResourceId)
    if Callback then
      Callback(ErrCode, RewardCount, DoubleReward, ResourceId)
    end
  end)
end

function MoneyTreeMgr.SingleDouble(Callback)
  MoneyTreeMgr._RequestPay(1, Callback)
end

function MoneyTreeMgr.AllUnlock(Callback)
  MoneyTreeMgr._RequestPay(2, Callback)
end

function MoneyTreeMgr._RequestPay(PayType, Callback)
  local Avatar = GetAvatar()
  local EventId = MoneyTreeMgr.GetActiveEventId()
  if not Avatar or not EventId then
    if Callback then
      Callback(-1)
    end
    return
  end
  local Rpc = 2 == PayType and Avatar.MoneyTreeRequestAllDoublePay or Avatar.MoneyTreeRequestSingleDoublePay
  Rpc(Avatar, EventId, function(Ret, OrderId, CallbackUrl, GoodsId)
    if ErrorCode:Check(Ret) then
      MoneyTreeMgr._LaunchPay(OrderId, CallbackUrl, GoodsId, PayType)
    end
    if Callback then
      Callback(Ret)
    end
  end)
end

function MoneyTreeMgr._LaunchPay(OrderId, CallbackUrl, GoodsId, PayType)
  if nil == GoodsId or "" == GoodsId or 0 == GoodsId then
    GoodsId = MoneyTreeMgr.GetGoodsId(PayType)
  end
  if not GoodsId or "" == GoodsId then
    GWorld.logger.error("MoneyTree _LaunchPay: GoodsId 为空,无法拉起支付", OrderId, PayType)
    return
  end
  if not HeroUSDKSubsystem():IsHeroSDKEnable() then
    local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
    GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance, "sgm pgi " .. tostring(GoodsId))
    return
  end
  local PayParams = FHeroUPaymentParameters()
  PayParams.goodsId = GoodsId
  PayParams.cpOrder = OrderId
  PayParams.callbackUrl = CallbackUrl
  local RoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
  local PayGoodsData = DataMgr.PayGoods and DataMgr.PayGoods[GoodsId]
  local ItemName = PayGoodsData and PayGoodsData.Name and GText(PayGoodsData.Name) or ""
  HeroUSDKSubsystem():HeroSDKPay(PayParams, RoleInfo, ItemName)
  HeroUSDKSubsystem():UploadTrackLog_Lua("charge_client", {
    product_id = GoodsId,
    product_type = "MoneyTree",
    game_order_id = OrderId,
    order_create_time = TimeUtils.NowTime()
  })
end

function MoneyTreeMgr.AddListener(Obj, OnStateChanged, OnPaySuccess)
  MoneyTreeMgr._listeners[Obj] = {state = OnStateChanged, pay = OnPaySuccess}
end

function MoneyTreeMgr.RemoveListener(Obj)
  MoneyTreeMgr._listeners[Obj] = nil
end

function MoneyTreeMgr._DispatchStateChanged()
  for Obj, Listener in pairs(MoneyTreeMgr._listeners) do
    if Listener.state then
      Listener.state(Obj)
    end
  end
end

function MoneyTreeMgr._DispatchPaySuccess(PayType, ExtraReward, ResourceId)
  for Obj, Listener in pairs(MoneyTreeMgr._listeners) do
    if Listener.pay then
      Listener.pay(Obj, PayType, ExtraReward, ResourceId)
    end
  end
end

return MoneyTreeMgr
