local StageRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossStageRewardUtils")
local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
  NodeCache.Count = 0
  NodeCache.Detail = {}
  local BossId = StageRewardUtils.GetCurrentBossId()
  if 0 == BossId then
    return
  end
  for _, Stage in ipairs(StageRewardUtils.GetStages()) do
    if StageRewardUtils.CanClaimStage(Stage, BossId) then
      NodeCache.Count = NodeCache.Count + 1
      NodeCache.Detail[Stage] = 1
    else
      NodeCache.Detail[Stage] = 0
    end
  end
end

function M:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  local Stage = CacheDetailChangedParams and CacheDetailChangedParams.Stage
  if not Stage then
    return false
  end
  if 1 == self.Cache.Detail[Stage] then
    return false
  end
  if StageRewardUtils.CanClaimStage(Stage) then
    self.Cache.Detail[Stage] = 1
    return true
  end
  return false
end

function M:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if SubValue == self.Count and nil == CacheDetailChangedParams then
    self.Cache.Detail = {}
    return true
  end
  local Stage = CacheDetailChangedParams and CacheDetailChangedParams.Stage
  if Stage and 1 == self.Cache.Detail[Stage] then
    self.Cache.Detail[Stage] = 0
    return true
  end
  return false
end

return M
