local M = Class("BluePrints.Common.MVC.Model")
local RefreshTimeType = {
  HOUR = 1,
  DAY = 2,
  WEEK = 3
}

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetRegionFameLevel(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  return Avatar.RegionReputations[RegionId].ReputationLevel
end

function M:GetRegionFameValue(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  return Avatar.RegionReputations[RegionId].ReputationExp
end

function M:GetRegionWeeklyFame(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  return Avatar.RegionReputations[RegionId].ReputationScore
end

function M:GetRegionState(RegionId, bRecurringTaskTab)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  local RegionReputationData = DataMgr.ReputationLevel[RegionId]
  if not RegionReputationData then
    return
  end
  local MaxLevel = RegionReputationData[#RegionReputationData].ReputationLevel
  local CurrentLevel = Avatar.RegionReputations[RegionId].ReputationLevel
  if MaxLevel <= CurrentLevel then
    return CommonConst.RegionFameState.MaxLevel
  end
  RegionReputationData = DataMgr.RegionReputation[RegionId]
  if not RegionReputationData then
    return
  end
  local WeekLimit = RegionReputationData.WeekLimit
  local CurrentWeekFame = Avatar.RegionReputations[RegionId].ReputationScore
  if WeekLimit <= CurrentWeekFame then
    return CommonConst.RegionFameState.WeeklyFameLimit
  end
  local DoingTaskRegionId = Avatar:GetCurrentDoingRecurringQuestId()
  if bRecurringTaskTab and DoingTaskRegionId and DoingTaskRegionId ~= RegionId then
    return CommonConst.RegionFameState.DoingOtherRegionFameTask
  end
  return CommonConst.RegionFameState.Normal
end

function M:CheckTabCondition(Condition)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false
  end
  if not Condition then
    return true
  end
  if ConditionUtils.CheckCondition(Avatar, Condition) == false then
    return false
  end
  return true
end

function M:GetEntrustTaskRefreshTime(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  local TargetRegionRefreshTime = Avatar.RegionReputations[RegionId].LastRefreshTime2
  if not TargetRegionRefreshTime then
    return
  end
  local Cache = DataMgr.RegionReputation
  local RefreshTime = 0
  for DictType, DictValue in pairs(Cache[RegionId].RefreshTime2) do
    if RefreshTimeType[DictType] == RefreshTimeType.HOUR then
      RefreshTime = RefreshTime + DictValue * 60 * 60
    elseif RefreshTimeType[DictType] == RefreshTimeType.DAY then
      RefreshTime = RefreshTime + DictValue * 60 * 60 * 24
    elseif RefreshTimeType[DictType] == RefreshTimeType.WEEK then
      RefreshTime = RefreshTime + DictValue * 60 * 60 * 24 * 7
    end
  end
  TargetRegionRefreshTime = TargetRegionRefreshTime + RefreshTime
  return TargetRegionRefreshTime
end

function M:GetEntrustTasks(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local Quests = Avatar:GetReputationEntrustQuest(RegionId)
  if not Quests then
    return
  end
  local AllEntrustTask = {}
  local Cache = DataMgr.ReputationEntrust
  for TaskId, TaskState in pairs(Quests) do
    local TabData = Cache[TaskId]
    if not TabData then
      break
    end
    local TaskReward = {
      RewardResourceID = TabData.Resource,
      RewardCount = TabData.ExpCount
    }
    local TaskSubmissions = {}
    for i = 1, #TabData.Type do
      local Rarity
      local Type = TabData.Type[i]
      local Id = TabData.Id[i]
      if DataMgr[Type] and DataMgr[Type][Id] then
        Rarity = DataMgr[Type][Id].Rarity
      end
      table.insert(TaskSubmissions, {
        Type = Type,
        Id = Id,
        Count = TabData.Count[i],
        Rarity = Rarity
      })
    end
    local TaskInfo = {
      TaskID = TaskId,
      TaskRegionID = TabData.ReputationID,
      TaskState = TaskState,
      TaskNPCIcon = TabData.Icon,
      TaskTitle = TabData.EntrustTitle,
      TaskContent = TabData.EntrustContent,
      TaskReward = TaskReward,
      TaskSubmissions = TaskSubmissions,
      NPCName = TabData.NPCName
    }
    table.insert(AllEntrustTask, TaskInfo)
  end
  
  local function SortByRarity(Data)
    local TmpSortData = {}
    for key, TaskInfo in pairs(Data) do
      local TaskSubmissions = TaskInfo.TaskSubmissions
      local CanSubmit = true
      for _, TaskSubmission in ipairs(TaskSubmissions) do
        local OwnerCount = 0
        if TaskSubmission.Type == "Mod" then
          if Avatar then
            OwnerCount = self:GetOriginalModCount(TaskSubmission.Id)
          end
        elseif TaskSubmission.Type == "Resource" then
          if Avatar then
            OwnerCount = Avatar:GetResourceNum(TaskSubmission.Id)
          end
        else
          OwnerCount = 0
        end
        CanSubmit = CanSubmit and OwnerCount >= TaskSubmission.Count
        if not CanSubmit then
          break
        end
      end
      local Info = {
        TaskID = TaskInfo.TaskID,
        CanSubmit = CanSubmit,
        TaskState = TaskInfo.TaskState,
        TaskInfo = TaskInfo
      }
      table.insert(TmpSortData, Info)
    end
    table.sort(TmpSortData, function(a, b)
      if a.TaskState ~= b.TaskState then
        if 0 == a.TaskState then
          return true
        elseif 0 == b.TaskState then
          return false
        else
          return a.TaskState < b.TaskState
        end
      end
      if a.CanSubmit ~= b.CanSubmit then
        return a.CanSubmit
      end
      return a.TaskID < b.TaskID
    end)
    local Result = {}
    for _, Task in ipairs(TmpSortData) do
      table.insert(Result, Task)
    end
    return Result
  end
  
  local SortRes = SortByRarity(AllEntrustTask)
  return SortRes
end

function M:ClearOriginalModsData()
  self.OriginalMods = nil
end

function M:GetOriginalModCount(ModId)
  if not rawget(self, "OriginalMods") then
    rawset(self, "OriginalMods", self:GetAllOriginalMods())
  end
  local OwnerOriginalModCount = self.OriginalMods[ModId]
  OwnerOriginalModCount = OwnerOriginalModCount and OwnerOriginalModCount or 0
  return OwnerOriginalModCount
end

function M:ConsumeMod(ModId, Count)
  if not self.OriginalMods then
    return
  end
  if not self.OriginalMods[ModId] then
    return
  end
  local RemainingNum = self.OriginalMods[ModId] - Count
  RemainingNum = RemainingNum >= 0 and RemainingNum or 0
  self.OriginalMods[ModId] = RemainingNum
end

function M:GetAllOriginalMods()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local ModStatistics = {}
  for _, Mod in pairs(Avatar.Mods) do
    if Mod.IsOriginal and not Mod:IsEquipped() then
      if not ModStatistics[Mod.ModId] then
        ModStatistics[Mod.ModId] = 0
      end
      ModStatistics[Mod.ModId] = ModStatistics[Mod.ModId] + Mod.Count
    end
  end
  return ModStatistics
end

function M:GetAlreadyRefreshEntrustTaskCount(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local RegionReputationData = DataMgr.RegionReputation[RegionId]
  if not RegionReputationData then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  local RemainingRefreshCount = Avatar.RegionReputations[RegionId].EntrustQuestRemainRefreshTimes
  local MaxRefreshCount = RegionReputationData.ManualRefreshNumber
  return math.max(0, MaxRefreshCount - RemainingRefreshCount)
end

function M:GetRecurringTaskRefreshTime(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  local TargetRegionRefreshTime = Avatar.RegionReputations[RegionId].LastRefreshTime1
  if not TargetRegionRefreshTime then
    return
  end
  local Cache = DataMgr.RegionReputation
  local RefreshTime = 0
  for DictType, DictValue in pairs(Cache[RegionId].RefreshTime1) do
    if RefreshTimeType[DictType] == RefreshTimeType.HOUR then
      RefreshTime = RefreshTime + DictValue * 60 * 60
    elseif RefreshTimeType[DictType] == RefreshTimeType.DAY then
      RefreshTime = RefreshTime + DictValue * 60 * 60 * 24
    elseif RefreshTimeType[DictType] == RefreshTimeType.WEEK then
      RefreshTime = RefreshTime + DictValue * 60 * 60 * 24 * 7
    end
  end
  TargetRegionRefreshTime = TargetRegionRefreshTime + RefreshTime
  return TargetRegionRefreshTime
end

function M:GetCurrentRecurringTaskLevel(RegionId)
  local FinRarity = 1
  local CurrentDoingRecurringTask
  local Quests = self:GetRecurringTasks(RegionId)
  local AllTaskData = DataMgr.RecurringTask
  for _, QuestInfo in ipairs(Quests) do
    local QuestId = QuestInfo.QuestId
    if not AllTaskData[QuestId] then
      DebugPrint(string.format("未获取到 RecurringTask 中 %d 相关数据，请检查", QuestId))
      return 1, nil
    end
    local State = self:GetTargetRecurringTaskStat(RegionId, QuestId)
    if State == CommonConst.RecurringTaskState.Doing then
      FinRarity = AllTaskData[QuestId].Rarity
      CurrentDoingRecurringTask = QuestId
    elseif State == CommonConst.RecurringTaskState.AlreadyClaimed then
      FinRarity = AllTaskData[QuestId].Rarity + 1
    end
  end
  return FinRarity, CurrentDoingRecurringTask
end

function M:GetTargetRegionAllCanClaimRecurringTasks(RegionId)
  local RegionState = self:GetRegionState(RegionId, true)
  if RegionState == CommonConst.RegionFameState.MaxLevel or RegionState == CommonConst.RegionFameState.WeeklyFameLimit then
    return {}
  end
  local Quests = self:GetRecurringTasks(RegionId)
  if not Quests then
    return {}
  end
  local CanClaimTasks = {}
  for Index, TaskInfo in pairs(Quests) do
    if TaskInfo.Info.State == CommonConst.RecurringTaskState.CanClaim then
      table.insert(CanClaimTasks, {
        TaskId = TaskInfo.QuestId,
        Level = math.floor((Index - 1) / 3) + 1
      })
    end
  end
  return CanClaimTasks
end

function M:GetTargetRegionEntrustTaskCanSubmit(RegionId)
  local RegionState = self:GetRegionState(RegionId, false)
  if RegionState == CommonConst.RegionFameState.MaxLevel or RegionState == CommonConst.RegionFameState.WeeklyFameLimit then
    return false
  end
  local EntrustTasks = self:GetEntrustTasks(RegionId)
  if not EntrustTasks then
    return false
  end
  for _, TaskInfo in pairs(EntrustTasks) do
    if TaskInfo.CanSubmit and TaskInfo.TaskState == CommonConst.EntrustFameTaskState.ReadyClaim then
      return true
    end
  end
  return false
end

function M:GetTargetRecurringTaskStat(RegionId, TaskId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local Quests = Avatar:GetReputationRecurringQuest(RegionId)
  local TaskInfo = Quests[TaskId]
  if not TaskInfo then
    return
  end
  return TaskInfo.State
end

function M:GetRecurringTaskHasAwardReceived(RegionId, TaskId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local Quests = Avatar:GetReputationRecurringQuest(RegionId)
  if not Quests[TaskId] then
    return
  end
  local bTaskHasAwardReceived = Quests[TaskId].State == CommonConst.RecurringTaskState.AlreadyClaimed
  return bTaskHasAwardReceived
end

function M:GetDoingRecurringTaskCompleted()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local DoingRegionId, DoingTaskId = Avatar:GetCurrentDoingRecurringQuestId()
  if not DoingRegionId then
    return
  end
  local TaskData = DataMgr.RecurringTask[DoingTaskId]
  if not TaskData then
    return
  end
  local DoingTaskProgress = self:GetDoingRecurringTaskProgress()
  if DoingTaskProgress >= TaskData.Target then
    return true
  end
  return false
end

function M:GetTargetRecurringTaskProgress(RegionId, TaskId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local AllTasks = Avatar:GetReputationRecurringQuest(RegionId)
  local TaskInfo = AllTasks[TaskId]
  if not TaskInfo then
    return
  end
  return TaskInfo.Progress
end

function M:GetDoingRecurringTaskProgress()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return nil
  end
  local DoingRegionId, DoingTaskId = Avatar:GetCurrentDoingRecurringQuestId()
  if not DoingRegionId then
    return nil
  end
  return self:GetTargetRecurringTaskProgress(DoingRegionId, DoingTaskId)
end

function M:GetCurrentRecurringTaskTimestamp()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return nil
  end
  local DoingRegionId, DoingTaskId = Avatar:GetCurrentDoingRecurringQuestId()
  if not DoingRegionId then
    return nil
  end
  local TaskData = DataMgr.RecurringTask[DoingTaskId]
  if not TaskData then
    return nil
  end
  if TaskData.Countdown then
    local _, _, StartTimestamp = Avatar:GetCurrentDoingRecurringQuestId()
    if not StartTimestamp then
      return nil
    end
    StartTimestamp = StartTimestamp + TaskData.Countdown
    return StartTimestamp
  else
    return nil
  end
end

function M:GetRecurringTasks(RegionId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local Quests = Avatar:GetReputationRecurringQuest(RegionId)
  if not Quests then
    return
  end
  local AllTaskData = DataMgr.RecurringTask
  
  local function SortByRarity(Data)
    local Keys = {}
    for key in pairs(Data) do
      table.insert(Keys, key)
    end
    table.sort(Keys, function(a, b)
      local TaskAData = AllTaskData[a]
      local TaskBData = AllTaskData[b]
      if not TaskAData or not TaskBData then
        return a < b
      end
      local A_Rarity = TaskAData.Rarity
      local B_Rarity = TaskBData.Rarity
      if A_Rarity == B_Rarity then
        return a < b
      else
        return A_Rarity < B_Rarity
      end
    end)
    local Result = {}
    for _, key in ipairs(Keys) do
      local Info = Data[key]
      table.insert(Result, {QuestId = key, Info = Info})
    end
    return Result
  end
  
  local SortRes = SortByRarity(Quests)
  return SortRes
end

function M:GetTaskDesProgress(RegionId, TaskId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local RegionReputationData = DataMgr.RecurringTask[TaskId]
  if not RegionReputationData then
    return
  end
  if not Avatar.RegionReputations[RegionId] then
    return
  end
  local TaskCurrentState = self:GetTargetRecurringTaskStat(RegionId, TaskId)
  local TaskType = RegionReputationData.Type
  local TargetCount = RegionReputationData.Target
  if 1 ~= TaskType or TaskCurrentState == CommonConst.RecurringTaskState.NotAccept then
    return tostring(TargetCount)
  end
  local CurrentProgress = self:GetTargetRecurringTaskProgress(RegionId, TaskId)
  return string.format("%d/%d", CurrentProgress, TargetCount)
end

function M:GetTargetLevelRewardState(RegionId, TargetLevel)
  local CurRegionLevel = self:GetRegionFameLevel(RegionId)
  if not CurRegionLevel then
    return
  end
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local State = CommonConst.FameRewardState.NotClaimable
  if TargetLevel <= CurRegionLevel then
    local bReadyClaim = Avatar:CheckReputationLevelReward(RegionId, TargetLevel)
    State = bReadyClaim and CommonConst.FameRewardState.ReadyClaim or CommonConst.FameRewardState.AlreadyClaimed
  end
  return State
end

return M
