require("UnLua")
local ActivityRaceUtils = {}
ActivityRaceUtils.CostNum = 0
ActivityRaceUtils.RewardRateIndex = 0

function ActivityRaceUtils.SetGuessTempCostNum(CostNum)
  ActivityRaceUtils.CostNum = CostNum or 0
end

function ActivityRaceUtils.GetGuessTempCostNum()
  return ActivityRaceUtils.CostNum
end

function ActivityRaceUtils.SetGuessTempRewardRateIndex(RewardRateIndex)
  ActivityRaceUtils.RewardRateIndex = RewardRateIndex or 0
end

function ActivityRaceUtils.GetGuessTempRewardRateIndex()
  return ActivityRaceUtils.RewardRateIndex
end

return ActivityRaceUtils
