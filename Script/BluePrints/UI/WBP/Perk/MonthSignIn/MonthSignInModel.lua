local TimeUtils = require("Utils.TimeUtils")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local MonthCardModel = require("BluePrints.UI.WBP.Perk.MonthCard.MonthCardModel")
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

function M:GetTodayYear()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if 0 == Avatar.MonthlyCheck.Year then
      local Now = TimeUtils.NowTime()
      local GameDayTimestamp = Now - TimeUtils.GetSec(table.unpack(TimeUtils.RefreshHMS))
      local d = TimeUtils.TimestampToDataObj(GameDayTimestamp)
      return d.year
    else
      return Avatar.MonthlyCheck.Year
    end
  end
end

function M:GetTodayMonth()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if 0 == Avatar.MonthlyCheck.Month then
      local Now = TimeUtils.NowTime()
      local GameDayTimestamp = Now - TimeUtils.GetSec(table.unpack(TimeUtils.RefreshHMS))
      local d = TimeUtils.TimestampToDataObj(GameDayTimestamp)
      return d.month
    else
      return Avatar.MonthlyCheck.Month
    end
  end
end

function M:GetTodaySignInDay()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if self:IsTodaySigned() then
      return Avatar.MonthlyCheck.MonthlyCheckCount
    else
      return Avatar.MonthlyCheck.MonthlyCheckCount + 1
    end
  end
end

function M:GetCumulativeSignInDay()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.MonthlyCheck.CheckCount
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

function M:IsPopUpMonthSignInReward()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local LastPopupTime = Avatar.MonthlyCheck.LastPopupTime
  DebugPrint("Yihan@ PlayGetAnimation ", LastPopupTime)
  if not LastPopupTime or 0 == LastPopupTime then
    return true
  else
    local IsSameDay = 0 == TimeUtils.GetIntervalDay(LastPopupTime, TimeUtils.NowTime())
    if not IsSameDay then
      return true
    end
  end
  return false
end

function M:MergeRewardIds(MonthSignInRewardId)
  local MonthCard = MonthCardModel:GetNowMonthCard()
  local MonthCardRewardId = MonthCard.DailyReward
  DebugPrint("Yihan@ MergeRewardIds", MonthCardRewardId, MonthSignInRewardId)
  local IsHasMonthCard = MonthCardModel:HasMonthCard()
  local IsMonthCardSigned = MonthCardModel:HasGetMonthCardDailyReward()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if IsHasMonthCard then
      return RewardUtils:GetRewards({MonthCardRewardId, MonthSignInRewardId}, Avatar)
    else
      return RewardUtils:GetRewards({MonthSignInRewardId}, Avatar)
    end
  end
end

function M:Destory()
  M.Super.Destory(self)
end

return M
