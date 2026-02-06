local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local ReddotTreeNode_GuildWar = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_GuildWar:OnRefreshNodeData(EventId)
  self:_Judge(EventId)
end

function ReddotTreeNode_GuildWar:_Judge(EventId)
  local Node = ReddotManager.GetTreeNode(GuildWarUtils.ReddotNodeKey)
  if not Node then
    ReddotManager.AddNodeEx(GuildWarUtils.ReddotNodeKey)
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
  if not CacheDetail then
    return false
  end
  if not CacheDetail[EventId] then
    CacheDetail[EventId] = {}
  end
  GuildWarUtils.RefreshShopReddot()
  GuildWarUtils.RefreshQuestReddot()
  GuildWarUtils.RefreshEntranceReddot()
  GuildWarUtils.RefreshRewardGotReddot()
  if not GuildWarUtils.IsEmptyTable(CacheDetail[EventId]) then
    return true
  end
  return false
end

function ReddotTreeNode_GuildWar:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return true
  end
  local CacheKey = CacheDetailChangedParams.CacheKey
  local EventId = CacheDetailChangedParams.EventId
  if CacheKey and EventId and 1 == AddValue and "Red" == CacheKey then
    return self:_Judge(EventId)
  end
  return false
end

function ReddotTreeNode_GuildWar:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return true
  end
  if CacheDetailChangedParams.bClearAll then
    self.Cache.Detail = {}
    return true
  end
  local CacheKey = CacheDetailChangedParams.CacheKey
  local EventId = CacheDetailChangedParams.EventId
  if 1 == SubValue and CacheKey and EventId and "Red" == CacheKey then
    return not self:_Judge(EventId)
  end
  return false
end

return ReddotTreeNode_GuildWar
