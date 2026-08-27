local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local EMCache = require("EMCache.EMCache")

function M:InitNodeCache()
  self:OnInitNodeCache(self.Cache)
  if self.Name == "AsyncCombatStoppageNew" then
    self.Cache.Count = 0
    self.Cache.Detail = {}
    self.Count = 0
  elseif self.Cache.Count > 0 then
    self.bIgnoreJudge = true
    self:IncreaseCount(self.Cache.Count)
  else
    self.Cache.Count = 0
    self.Count = 0
  end
end

function M:OnInitNodeCache(NodeCache)
  EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnRefreshWithActivityOpen)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
  EventManager:AddEvent(EventID.OnDailyRefresh, self, self.OnWeeklyRefresh)
  EventManager:AddEvent(EventID.OnSystemUnlockEnding, self, self.OnSystemUnlockEnding)
end

function M:OnDisposeNode()
  EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
  EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
  EventManager:RemoveEvent(EventID.OnSystemUnlockEnding, self)
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

function M:OnSystemUnlockEnding(SystemIDs)
  if SystemIDs.Contains and SystemIDs:Contains("GameEvent") then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:RefreshAsyncCombatNew()
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

function M:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  if self.Name ~= "AsyncCombatStoppageNew" then
    return true
  end
  if 0 == AddValue then
    return true
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  if "New" ~= CacheKey then
    return false
  end
  local ParamsType = CacheDetailChangedParams.Type
  if not ParamsType then
    return true
  end
  local StoppageRoom = CacheDetail[ParamsType]
  if not StoppageRoom then
    return true
  end
  local ParamsRoomId = CacheDetailChangedParams.RoomIds
  for _, id in ipairs(ParamsRoomId) do
    if nil ~= StoppageRoom[id] then
      return false
    end
  end
  return true
end

function M:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if self.Name ~= "AsyncCombatStoppageNew" then
    return true
  end
  if 0 == SubValue then
    return true
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  if "New" ~= CacheKey then
    return false
  end
  local ParamsType = CacheDetailChangedParams.Type
  if not ParamsType then
    return false
  end
  if not CacheDetail[ParamsType] then
    return false
  end
  local ParamsRoomId = CacheDetailChangedParams.RoomIds
  if not ParamsRoomId then
    return false
  end
  for _, id in ipairs(ParamsRoomId) do
    if nil ~= CacheDetail[ParamsType][id] then
      return true
    end
  end
  return false
end

function M:OnIncreaseCount(AddValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return
  end
  local CacheDetail = self.Cache.Detail
  local CacheKey = CacheDetailChangedParams.CacheKey
  if "New" == CacheKey then
    if not CacheDetail[CacheKey] then
      CacheDetail[CacheKey] = 0
    end
    CacheDetail[CacheKey] = CacheDetail[CacheKey] + AddValue
    local ParamsType = CacheDetailChangedParams.Type
    if ParamsType then
      if "StoppageRoom" == ParamsType then
        if not CacheDetail[ParamsType] then
          CacheDetail[ParamsType] = {}
        end
        local ParamsRoomIds = CacheDetailChangedParams.RoomIds
        for _, id in ipairs(ParamsRoomIds) do
          CacheDetail[ParamsType][id] = 1
        end
      else
        CacheDetail[ParamsType] = 1
      end
    end
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
  if "New" == CacheKey and CacheDetailChangedParams and CacheDetailChangedParams.Type then
    local ParamsType = CacheDetailChangedParams.Type
    if "StoppageRoom" == ParamsType then
      if not CacheDetail[ParamsType] then
        return
      end
      local ParamsRoomIds = CacheDetailChangedParams.RoomIds
      local ActivityID = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
      local CacheName = "AsynccombatStoppageRoomClickTime" .. ActivityID
      local StoppageRoomCache = EMCache:Get(CacheName, true) or {}
      local CurrentTime = TimeUtils.NowTime()
      for _, id in ipairs(ParamsRoomIds) do
        if CacheDetail[ParamsType][id] then
          CacheDetail[ParamsType][id] = nil
          if StoppageRoomCache and not StoppageRoomCache[id] then
            StoppageRoomCache[id] = 1
          end
        end
      end
      if nil ~= next(StoppageRoomCache) then
        EMCache:Set(CacheName, StoppageRoomCache, true)
      end
    else
      CacheDetail[CacheDetailChangedParams.Type] = nil
    end
  end
  if CacheDetail[CacheKey] and SubValue <= CacheDetail[CacheKey] then
    CacheDetail[CacheKey] = CacheDetail[CacheKey] - SubValue
  end
end

return M
