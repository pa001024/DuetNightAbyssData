local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")
local LegacyEventIds = {
  [103021] = true,
  [10302101] = true,
  [10302102] = true,
  [10302103] = true
}

function M:OnInitNodeCache(NodeCache)
  self.bImplemented = true
  self.bInvokeEveryTime = true
  local Detail = NodeCache.Detail
  local UserCache = EMCache:Get(ReddotManager.CacheKey, true)
  local bHasIndependentCache = UserCache and UserCache[self.Name] ~= nil
  NodeCache.Count = 0
  NodeCache.Detail = {
    New = 0 == Detail.New and 0 or nil,
    NewCacheMigrated = true == Detail.NewCacheMigrated or bHasIndependentCache or nil ~= Detail.New
  }
end

function M:_MigrateLegacyNew(EventId)
  local Detail = self.Cache.Detail
  if Detail.NewCacheMigrated then
    return
  end
  if Detail.New == nil and LegacyEventIds[EventId] then
    local UserCache = EMCache:Get(ReddotManager.CacheKey, true)
    local LegacyCache = UserCache and UserCache.Acti_LimitedPrize
    if LegacyCache and LegacyCache.Detail and 0 == LegacyCache.Detail.New then
      Detail.New = 0
    end
  end
  Detail.NewCacheMigrated = true
end

function M:_IsEventNode(EventId)
  return EventId and self.Name == "Acti_LimitedPrize_" .. EventId and ActivityReddotHelper.GetEventMainNodeName(EventId) == self.Name
end

function M:_CanShow(EventId)
  local Avatar = GWorld:GetAvatar()
  local EventData = DataMgr.EventMain[EventId]
  if not (TimeUtils.ServerTimeZone ~= nil and Avatar and Avatar:CheckUIUnlocked("GameEvent") and EventData and DataMgr.LimitedPrizePool[EventId]) or not self:_IsEventNode(EventId) then
    return false
  end
  return ActivityUtils.CheckEventIsOpenNoCache(EventId, EventData, true, "GameEvent", TimeUtils.NowTime())
end

function M:_Judge(EventId)
  local Avatar = GWorld:GetAvatar()
  return Avatar and Avatar:HasLimitedPrizeUnselectedReward(EventId) or false
end

function M:OnIncreaseJudge(AddValue, Params)
  if not Params or not self:_CanShow(Params.EventId) then
    return false
  end
  self:_MigrateLegacyNew(Params.EventId)
  return M.Super.OnIncreaseJudge(self, AddValue, Params)
end

function M:OnDecreaseJudge(SubValue, Params)
  if Params and not Params.bClearAll and not self:_IsEventNode(Params.EventId) then
    return false
  end
  return M.Super.OnDecreaseJudge(self, SubValue, Params)
end

function M:_ClearVisibleState()
  local Detail = self.Cache.Detail
  local bViewed = 0 == Detail.New
  if self.Count > 0 then
    ReddotManager.ClearLeafNodeCount(self.Name, false)
  end
  Detail.New = bViewed and 0 or nil
  Detail.Red = nil
  self:JudgeReddotType(Detail)
end

function M:OnRefreshNodeData(EventId)
  if TimeUtils.ServerTimeZone == nil then
    return
  end
  if not self:_IsEventNode(EventId) then
    DebugPrint(ErrorTag, "LimitedPrize: mismatched activity reddot node", EventId, self.Name)
    return
  end
  self:_MigrateLegacyNew(EventId)
  if not self:_CanShow(EventId) then
    self:_ClearVisibleState()
    return
  end
  M.Super.OnRefreshNodeData(self, EventId)
end

return M
