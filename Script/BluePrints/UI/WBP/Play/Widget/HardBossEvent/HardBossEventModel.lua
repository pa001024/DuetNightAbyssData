local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetCurrentEventId(EventId)
  if EventId then
    return EventId
  end
  local Avatar = self:GetAvatar()
  local HardBossEvent = Avatar and Avatar.HardBossEvent
  local CurrentEventId = HardBossEvent and HardBossEvent.CurrentEventId
  return CurrentEventId and CurrentEventId > 0 and CurrentEventId or nil
end

function M:GetEventConfig(EventId)
  local ConfigTable = DataMgr and DataMgr.HardBossEventMain
  return ConfigTable and ConfigTable[EventId] or nil
end

function M:GetActivityConfig(EventId)
  local ConfigTable = DataMgr and DataMgr.EventMain
  return ConfigTable and ConfigTable[EventId] or nil
end

function M:GetBossConfigList(EventId)
  local Result = {}
  local EventConfig = self:GetEventConfig(EventId)
  local SelectTable = DataMgr and DataMgr.HardBossEventDungeonSelect
  if not EventConfig or not SelectTable then
    return Result
  end
  for _, HardBossDungeonId in ipairs(EventConfig.HardBossId or {}) do
    local BossConfig = SelectTable[HardBossDungeonId]
    if BossConfig then
      table.insert(Result, BossConfig)
    end
  end
  return Result
end

function M:GetRewardViewConfig(BossConfig)
  local RewardViewTable = DataMgr and DataMgr.RewardView
  local RewardViewId = BossConfig and BossConfig.HardBossRewardView
  return RewardViewTable and RewardViewId and RewardViewTable[RewardViewId] or nil
end

function M:GetRewardTimes(EventId)
  local EventConfig = self:GetEventConfig(EventId)
  local Avatar = GWorld:GetAvatar()
  local HardBossEvent = Avatar and Avatar.HardBossEvent
  local RemainTimes = HardBossEvent and HardBossEvent.RewardTimesLeft or 0
  local TotalTimes = EventConfig and EventConfig.PeriodRewardTime or 0
  return RemainTimes, TotalTimes
end

return M
