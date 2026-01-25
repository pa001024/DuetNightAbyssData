local TimeUtils = require("Utils.TimeUtils")
local MonthCardCommon = require("BluePrints.UI.WBP.Perk.MonthCard.MonthCardCommon")
local ItemUtil = require("Utils.ItemUtils")
local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
  self.NowMonthCardId = nil
end

function M:IsMonthCardPurchased()
  local Avatar = self:GetAvatar()
  if Avatar then
    return Avatar.MonthlyCardExpireTime > TimeUtils.NowTime()
  else
    return false
  end
end

function M:IsMonthCardCanPurchase()
  local Avatar = self:GetAvatar()
  local MonthCardHoldMax = DataMgr.GlobalConstant.MonthlyCardHoldMax
  MonthCardHoldMax = MonthCardHoldMax and MonthCardHoldMax.ConstantValue or 0
  if Avatar then
    local NowTime = TimeUtils.NowTime()
    local LastTime = Avatar.MonthlyCardExpireTime - NowTime
    return MonthCardHoldMax >= math.ceil(LastTime / CommonConst.DayTime) + CommonConst.MonthlyCardValidDay
  else
    return false
  end
end

function M:GetMonthCardLeftDays()
  local Avatar = self:GetAvatar()
  if Avatar then
    return Avatar.MonthlyCardExpireTime
  else
    return false
  end
end

function M:GetMonthCardLeftTimes()
  local Avatar = self:GetAvatar()
  if Avatar then
    local NowTime = TimeUtils.NowTime()
    local LastTime = Avatar.MonthlyCardExpireTime - NowTime
    return math.floor(LastTime / CommonConst.DayTime)
  else
    return 0
  end
end

function M:GetMonthCardCanPurchaseTime()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    return MonthCard.EndTime
  else
    return 0
  end
end

function M:GetRewardHeadIconInfo()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    return self:GetRewardInfo(MonthCard.UniqueReward)
  else
    return nil
  end
end

function M:GetRewardItemIcon()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    return MonthCard.BuyRewardIcon
  else
    return nil
  end
end

function M:GetRewardItem()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    return self:GetRewardInfo(MonthCard.BuyReward)
  else
    return nil
  end
end

function M:GetRewardNameAndIcon(RewardInfos)
  if not RewardInfos then
    return
  end
  local Results = {}
  for _, Reward in ipairs(RewardInfos) do
    table.insert(Results, GText(ItemUtil.GetItemName(Reward.ItemId, Reward.ItemType)))
    table.insert(Results, "*")
    table.insert(Results, Reward.Count)
    table.insert(Results, "\n")
  end
  if #Results > 0 then
    Results[#Results] = nil
  end
  local Result = table.concat(Results)
  local Icon
  if #RewardInfos > 0 then
    local Reward = RewardInfos[1]
    Icon = ItemUtils.GetItemIcon(Reward.ItemId, Reward.ItemType)
  end
  return Result, Icon
end

function M:GetRewardEveryDayItemIcon()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    return MonthCard.DailyRewardIcon
  else
    return nil
  end
end

function M:GetRewardEveryDayItem()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    return self:GetRewardInfo(MonthCard.DailyReward)
  else
    return nil
  end
end

function M:GetMonthCardPrice()
  local MonthCard = self:GetNowMonthCard()
  if MonthCard then
    local Goods = DataMgr.PayGoods[MonthCard.GoodsId]
    local PriceType = ShopUtils:GetCurrencyPrice()
    local Price = Goods[PriceType]
    return Price or 0
  else
    return 30
  end
end

function M:GetPriceSymbol()
  local CurrencySymbol = ShopUtils:GetCurrencyType()
  return CurrencySymbol
end

function M:GetNowMonthCard()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return nil
  end
  local MonthlyCards = DataMgr.MonthlyCard
  local NowMonthCard = MonthlyCards[Avatar.NowMonthCardId]
  local Time = TimeUtils.NowTime()
  if NowMonthCard and Time >= NowMonthCard.BeginTime and Time < NowMonthCard.EndTime then
    return NowMonthCard
  else
    local CurrentCard
    for k, v in pairs(MonthlyCards) do
      if Time >= v.BeginTime and Time < v.EndTime then
        CurrentCard = v
        self.NowMonthCardId = CurrentCard.CardId
        break
      end
    end
    return CurrentCard
  end
  return nil
end

function M:GetRewardInfo(RewardId)
  local Reward = DataMgr.Reward[RewardId]
  if not Reward then
    return
  end
  local Result = {}
  local RewardTypes = Reward.Type
  local RewardItemIds = Reward.Id
  local RewardCounts = Reward.Count
  local Count = Reward.Type and #Reward.Type or 0
  for i = 1, Count do
    local Type = RewardTypes and RewardTypes[i]
    local ItemId = RewardItemIds and RewardItemIds[i]
    local Count = RewardCounts and RewardCounts[i]
    local Item = {
      ItemType = Type,
      ItemId = ItemId,
      Count = Count[1]
    }
    table.insert(Result, Item)
  end
  return Result
end

function M:Destory()
  M.Super.Destory(self)
end

function M:SetDailyRewardCache(DailyReward)
  self.DailyRewardCache = DailyReward
end

function M:ClearDailyRewardCache()
  self.DailyRewardCache = nil
end

return M
