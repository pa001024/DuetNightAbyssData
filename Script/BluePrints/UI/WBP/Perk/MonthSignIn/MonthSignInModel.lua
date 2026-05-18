local TimeUtils = require("Utils.TimeUtils")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local ItemUtil = require("Utils.ItemUtils")
local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
  self.NowMonthSignInId = nil
end

function M:IsTodaySigned()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.MonthlyCheck.LastCheckTime and 0 ~= Avatar.MonthlyCheck.LastCheckTime then
    return TimeUtils.GetIntervalDay(Avatar.MonthlyCheck.LastCheckTime, TimeUtils.NowTime()) < 1
  end
  return false
end

function M:GetTodayMonth()
  local Avatar = GWorld:GetAvatar()
  DebugPrint("Yihan@  GetTodayMonth: ", Avatar.MonthlyCheck, Avatar.MonthlyCheck.Month)
  if Avatar then
    return Avatar.MonthlyCheck.Month
  end
end

function M:GetTodaySignInDay()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if self:IsTodaySigned() then
      return Avatar.MonthlyCheck.CheckCount
    else
      return Avatar.MonthlyCheck.CheckCount + 1
    end
  end
end

function M:GetCumulativeSignInDay()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if self:IsTodaySigned() then
      return Avatar.TotalLoginDays
    else
      return Avatar.TotalLoginDays - 1
    end
  end
end

function M:IsGetCumulativeReward(Step)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if Avatar.MonthlyCheck.TotalRewardRecord[Step] then
      return true
    else
      return false
    end
  end
  return false
end

function M:IsGetSignRewardByDay(Day)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if Avatar.MonthlyCheck.DailyRewardRecord[Day] then
      return true
    else
      return false
    end
  end
  return false
end

function M:GetLevel()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.Level
  end
  return 0
end

function M:GetCanReceiveCumulativeRewardCount()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return #Avatar.MonthlyCheck.TotalRewardRecord
  end
  return 0
end

function M:Destory()
  M.Super.Destory(self)
end

function M:SetDailyRewardCache(DailyReward)
  self.DailyRewardCache = DailyReward
end

function M:SetPurchaseRewardCache(PurchaseReward)
  self.PurchaseRewardCache = PurchaseReward
end

function M:ClearPurchaseRewardCache()
  self.PurchaseRewardCache = nil
end

function M:ClearDailyRewardCache()
  self.DailyRewardCache = nil
end

return M
