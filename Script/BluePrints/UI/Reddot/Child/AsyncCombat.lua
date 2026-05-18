require("UnLua")
local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
  EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnRefreshWithActivityOpen)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
end

function M:OnDisposeNode()
  EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
end

function M:OnRefreshWithActivityOpen(ActivityID)
  if DataMgr.AsyncCombat[ActivityID] then
    if self.Name == "AsyncCombatReward" then
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:RefreshAsyncCombatRewardRedDot()
      end
    elseif self.Name == "AsyncCombatNew" then
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:RefreshAsyncCombatNew()
      end
    end
  end
end

function M:OnRefreshWithActivityClose(ActivityID)
  if DataMgr.AsyncCombat[ActivityID] then
    ReddotManager.ClearLeafNodeCount(self.Name, true)
  end
end

function M:OnIncreaseCount(AddValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  if "New" == CacheKey then
    CacheDetail[CacheKey] = 1
  elseif "Red" == CacheKey then
    if not CacheDetail[CacheKey] then
      CacheDetail[CacheKey] = 0
    end
    CacheDetail[CacheKey] = CacheDetail[CacheKey] + AddValue
  end
end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  if CacheDetail[CacheKey] and SubValue <= CacheDetail[CacheKey] then
    CacheDetail[CacheKey] = CacheDetail[CacheKey] - SubValue
  end
end

return M
