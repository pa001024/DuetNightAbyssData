local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local ReddotTreeNode_Racing = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_Racing:OnInitNodeCache(NodeCache)
  ReddotTreeNode_Racing.Super.OnInitNodeCache(self, NodeCache)
  ReddotManager.AddListenerEx("RacingChoosePet", self, self.OnChildReddotChange)
  ReddotManager.AddListenerEx("RacingWatchAndGetReward", self, self.OnChildReddotChange)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnClearWithActivityClose)
end

function ReddotTreeNode_Racing:OnDisposeNode()
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
end

function ReddotTreeNode_Racing:_Judge(ActivityID)
  local PlayerAvatar = GWorld:GetAvatar()
  local WatchAndGetRewardReddot = ReddotManager.GetTreeNode("RacingWatchAndGetReward")
  if WatchAndGetRewardReddot and WatchAndGetRewardReddot.Count > 0 then
    return true
  end
  return false
end

function ReddotTreeNode_Racing:_IsNeedShowNew(ActivityID)
  if ActivityID == RacingActivityConst.ActivityEventId then
    local ChoosePetReddot = ReddotManager.GetTreeNode("RacingChoosePet")
    if ChoosePetReddot and ChoosePetReddot.Count > 0 then
      return true
    else
      return false
    end
  end
  return false
end

function ReddotTreeNode_Racing:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return true
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  local EventId = CacheDetailChangedParams.EventId
  if CacheKey and EventId and 1 == AddValue then
    if "New" == CacheKey and (not CacheDetail[CacheKey] or 0 == CacheDetail[CacheKey]) then
      return self:_IsNeedShowNew(EventId)
    elseif "Red" == CacheKey and 1 ~= CacheDetail[CacheKey] then
      return self:_Judge(EventId)
    end
  end
  return false
end

function ReddotTreeNode_Racing:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return true
  end
  if CacheDetailChangedParams.bClearAll then
    return true
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  local EventId = CacheDetailChangedParams.EventId
  if 1 == SubValue and CacheKey and EventId and 1 == CacheDetail[CacheKey] then
    if "New" == CacheKey then
      return not self:_IsNeedShowNew(EventId)
    elseif "Red" == CacheKey then
      return not self:_Judge(EventId)
    end
  end
  return false
end

function ReddotTreeNode_Racing:OnRefreshNodeData(EventId)
  if self:_IsNeedShowNew(EventId) then
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey = "New", EventId = EventId})
  else
    ReddotManager.DecreaseLeafNodeCount(self.Name, 1, {CacheKey = "New", EventId = EventId})
  end
  if self:_Judge(EventId) then
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey = "Red", EventId = EventId})
  else
    ReddotManager.DecreaseLeafNodeCount(self.Name, 1, {CacheKey = "Red", EventId = EventId})
  end
end

function ReddotTreeNode_Racing:OnChildReddotChange(Count, RdType, RdName)
  self:OnRefreshNodeData(RacingActivityConst.ActivityEventId)
end

function ReddotTreeNode_Racing:OnClearWithActivityClose(ActivityID)
  if ActivityID == RacingActivityConst.ActivityEventId then
    ReddotManager.ClearLeafNodeCount(self.Name, true)
  end
end

return ReddotTreeNode_Racing
