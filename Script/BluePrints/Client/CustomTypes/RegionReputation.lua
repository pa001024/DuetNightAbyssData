local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local TargetCounter = require("BluePrints.Client.CustomTypes.TargetCounter")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local TimeUtils
if GWorld:IsSkynetServer() then
  TimeUtils = require("src.utils.TimeUtils")
else
  TimeUtils = require("Utils.TimeUtils")
end
local RegionReputation = Class("RegionReputation", CustomTypes.CustomAttr)
RegionReputation.__Props__ = {
  ReputationId = prop.prop("Int", "client save"),
  ReputationScore = prop.prop("Int", "client save"),
  RecurringQuestList = prop.prop("TargetCounter.TargetCounterDict", "client save"),
  RecurringQuestState = prop.prop("Int2IntDict", "client save"),
  RecurringQuestPool = prop.prop("Int2IntListDict", "save"),
  RecurringQuestIdAndStartTime = prop.prop("IntList", "client save", {-1, 0}),
  EntrustQuestState = prop.prop("Int2IntDict", "client save"),
  ReputationLevel = prop.prop("Int", "client save", 0),
  ReputationExp = prop.prop("Int", "client save", 0),
  LevelRewardGotList = prop.prop("Int2IntDict", "client save", {}),
  LastRefreshTime1 = prop.prop("Int", "client save", 0),
  LastRefreshTime2 = prop.prop("Int", "client save", 0),
  EntrustQuestRemainRefreshTimes = prop.prop("Int", "client save", 0),
  WeekLimit = prop.getter("Data", "WeekLimit")
}

function RegionReputation:Init(ReputationId)
  if not ReputationId then
    return
  end
  if not DataMgr.RegionReputation[ReputationId] then
    return
  end
  self.ReputationId = ReputationId
  self:SetRefreshTime(ReputationId)
  self:ResetEntrustQuestRemainRefreshTimes()
end

function RegionReputation:Data()
  return DataMgr.RegionReputation[self.ReputationId]
end

function RegionReputation:SetRefreshTime(ReputationId)
  local ReputationInfo = DataMgr.RegionReputation[ReputationId]
  local RefreshTime1 = ReputationInfo.RefreshTime1
  local RefreshTime2 = ReputationInfo.RefreshTime2
  local RefreshBeginTime = TimeUtils.EastEightToLocalTimestamp(ReputationInfo.RefreshBeginTime)
  
  local function GetRefreshStartTime(Type, StartTime)
    if "DAY" == Type then
      local year, month, day, hour, min, sec = TimeUtils.TimestampToData(StartTime)
      local refresh_hms = CommonConst.GAME_REFRESH_HMS
      return TimeUtils.DataToTimestamp(year, month, day, table.unpack(refresh_hms))
    elseif "WEEK" == Type then
      StartTime = StartTime - CommonConst.SECOND_IN_WEEKDAY
      local refresh_hms = CommonConst.GAME_REFRESH_HMS
      return TimeUtils.NextWeeklyRefreshTime(StartTime, refresh_hms)
    else
      return StartTime
    end
  end
  
  if RefreshTime1 then
    for key, value in pairs(RefreshTime1) do
      self.LastRefreshTime1 = GetRefreshStartTime(key, RefreshBeginTime)
    end
  end
  if RefreshTime2 then
    for key, value in pairs(RefreshTime2) do
      self.LastRefreshTime2 = GetRefreshStartTime(key, RefreshBeginTime)
    end
  end
end

function RegionReputation:ResetEntrustQuestRemainRefreshTimes()
  local Data = self:Data()
  if Data and Data.ManualRefreshNumber then
    self.EntrustQuestRemainRefreshTimes = Data.ManualRefreshNumber
  else
    self.EntrustQuestRemainRefreshTimes = 0
  end
end

function RegionReputation:SetRecurringQuestIdAndStartTime(QuestId, StartTime)
  self.RecurringQuestIdAndStartTime[1] = QuestId
  self.RecurringQuestIdAndStartTime[2] = StartTime
end

function RegionReputation:ClearRecurringQuestIdAndStartTime()
  self.RecurringQuestIdAndStartTime[1] = -1
  self.RecurringQuestIdAndStartTime[2] = 0
end

FormatProperties(RegionReputation)
local RegionReputationDict = Class("RegionReputationDict", CustomTypes.CustomDict)
RegionReputationDict.KeyType = BaseTypes.Int
RegionReputationDict.ValueType = RegionReputation

function RegionReputationDict:NewRegionReputation(ReputationId)
  return RegionReputation(ReputationId)
end

function RegionReputationDict:GetRegionReputation(ReputationId)
  if nil == self[ReputationId] then
    self[ReputationId] = self:NewRegionReputation(ReputationId)
  end
  return self[ReputationId]
end

return {RegionReputation = RegionReputation, RegionReputationDict = RegionReputationDict}
