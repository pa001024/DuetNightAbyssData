local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ReddotTreeNode_IActivityBase = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function ReddotTreeNode_IActivityBase:OnRefreshNodeData(EventId)
end

function ReddotTreeNode_IActivityBase:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if CacheDetailChangedParams then
    DebugPrint(DebugTag, "IActivityBase 重写OnDecreaseJudge之后才允许传参")
    return false
  end
  return true
end

function ReddotTreeNode_IActivityBase:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  if CacheDetailChangedParams then
    DebugPrint(DebugTag, "IActivityBase 重写OnIncreaseJudge之后才允许传参")
    return false
  end
  return true
end

function ReddotTreeNode_IActivityBase:InitNodeCache()
  self:OnInitNodeCache(self.Cache)
  if self.Cache.Count > 0 then
    self.bIgnoreJudge = false
    self:IncreaseCount(self.Cache.Count)
  else
    self.Cache.Count = 0
    self.Count = 0
  end
end

return ReddotTreeNode_IActivityBase
