local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

function M:OnInitNodeCache(NodeCache)
  EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnRefreshWithActivityOpen)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
  EventManager:AddEvent(EventID.OnWeeklyRefresh, self, self.OnWeeklyRefresh)
end

function M:OnDisposeNode()
  EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
  EventManager:RemoveEvent(EventID.OnWeeklyRefresh, self)
end

function M:OnWeeklyRefresh()
  DebugPrint("AsyncCombat Weekly Refresh")
  if self.Name == "AsyncCombatNew" then
    local ActivityID = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
    if ActivityUtils.CheckEventIsExpired(ActivityID) then
      ReddotManager.ClearLeafNodeCount(self.Name, true)
    else
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:RefreshAsyncCombatNew()
      end
    end
  end
end

function M:OnRefreshWithActivityOpen(ActivityID)
  if ActivityID == DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue then
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
  if ActivityID == DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue then
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
