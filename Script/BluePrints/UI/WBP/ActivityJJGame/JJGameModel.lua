local M = Class("BluePrints.Common.MVC.Model")
M.TaskType = {
  Daily = {1, 2},
  Cycle = 3,
  Achievement = 4
}
M.NormalRewardReddotName = "JJGameTask_Normal_Reddot"
M.ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
M.NormalTaskNewReddotName = "JJGameTask_Normal_New"
M.ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"

function M:Init()
  M.Super.Init(self)
  self:Refresh()
end

function M:Refresh()
  self._Avatar = GWorld:GetAvatar()
  self.MidTermConst = DataMgr.MidTermGoalConstant
  self.MidTermGoalEventId = self.MidTermConst.MidTermGoalEventId.ConstantValue
  local EventData = DataMgr.EventMain[self.MidTermGoalEventId] or {}
  self.EventStartTime = EventData.EventStartTime
  self.EventEndTime = EventData.EventEndTime
  self.RewardEndTime = EventData.RewardEndTime
  self.MidTermGoals = {}
  if self._Avatar and self._Avatar.MidTermGoals then
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
  end
  self.MidTermAchvScores = self.MidTermGoals.AchvScores or 0
  self.MidTermTasks = self.MidTermGoals.Tasks or {}
  self.MidTermTasksRecord = self.MidTermGoals.TaskFinishCount or {}
  self.MidTermAchvProgressRewarded = self.MidTermGoals.AchvProgressRewarded or {}
  self.MidTermScores = self.MidTermGoals.Scores or 0
  self.MidTermScoresRewards = self.MidTermGoals.ScoresRewards or {}
  self.EventDay, self.RemainDays, self.RemainHours = self:CalcEventDayAndRemainTime()
end

function M:CalcEventDayAndRemainTime()
  local currentTime = TimeUtils.NowTime()
  local SECOND_IN_DAY = CommonConst.SECOND_IN_DAY
  local SECOND_IN_HOUR = CommonConst.SECOND_IN_HOUR
  local RESET_HOUR = 5
  local intervalDays = TimeUtils.GetIntervalDay(self.EventStartTime, currentTime)
  local calculatedEventDay = intervalDays + 1
  local hasDailyTask = false
  local enableDayEventDay = -1
  for _, Task in pairs(self.MidTermTasks) do
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if not TaskData then
    elseif TaskData.TaskType == self.TaskType.Daily[1] or TaskData.TaskType == self.TaskType.Daily[2] then
      enableDayEventDay = TaskData.EnableDay
      hasDailyTask = true
      break
    end
  end
  if hasDailyTask and calculatedEventDay ~= enableDayEventDay then
    DebugPrint(TXTTag, "Warning: EventDay mismatch", calculatedEventDay, enableDayEventDay)
  end
  if not hasDailyTask then
    return calculatedEventDay, false, false
  end
  local nextEnableDay
  for _, TaskData in pairs(DataMgr.MidTermTask) do
    if TaskData and TaskData.TaskType == self.TaskType.Achievement and TaskData.EnableDay then
      local enableDay = TaskData.EnableDay
      if calculatedEventDay < enableDay and (not nextEnableDay or nextEnableDay > enableDay) then
        nextEnableDay = enableDay
      end
    end
  end
  if not nextEnableDay then
    return calculatedEventDay, false, false
  end
  local nextUnlockTime = self.EventStartTime
  if nextEnableDay > 1 then
    local eventStartData = TimeUtils.TimestampToDataObj(self.EventStartTime)
    nextUnlockTime = TimeUtils.DataToTimestamp(eventStartData.year, eventStartData.month, eventStartData.day + (nextEnableDay - 1), RESET_HOUR, 0, 0)
  end
  local remainTime = nextUnlockTime - currentTime
  if remainTime < 0 then
    remainTime = 0
  end
  local remainDays = math.floor(remainTime / SECOND_IN_DAY)
  local remainHours = math.floor((remainTime - remainDays * SECOND_IN_DAY) / SECOND_IN_HOUR)
  if 0 == remainDays and 0 == remainHours and remainTime > 0 then
    remainHours = 1
  end
  return calculatedEventDay, remainDays, remainHours
end

function M:GetSortedTaskList(TaskList)
  local SortedTaskList = {}
  for k, v in pairs(TaskList or {}) do
    table.insert(SortedTaskList, {
      key = tonumber(k) or 0,
      value = v
    })
  end
  table.sort(SortedTaskList, function(a, b)
    return a.key < b.key
  end)
  local Result = {}
  for _, Pair in ipairs(SortedTaskList) do
    table.insert(Result, Pair.value)
  end
  return Result
end

function M:GetTaskByTaskId(TaskId)
  return self.MidTermTasks and self.MidTermTasks[TaskId]
end

function M:GetTaskDataByUniqueId(UniqueID)
  return DataMgr.MidTermTask[UniqueID]
end

function M:GetRewardPointByTaskType(TaskType)
  if TaskType == self.TaskType.Daily[1] then
    return self.MidTermConst.DailyRewardPoint_1.ConstantValue
  end
  if TaskType == self.TaskType.Daily[2] then
    return self.MidTermConst.DailyRewardPoint_2.ConstantValue
  end
  if TaskType == self.TaskType.Cycle then
    return self.MidTermConst.CycleRewardPoint.ConstantValue
  end
  if TaskType == self.TaskType.Achievement then
    return self.MidTermConst.AchievementRewardPoint.ConstantValue
  end
  return 0
end

function M:BuildNormalTaskEntries(TaskTypeConfig, EventDay, YesterdayRewardGot)
  local Result = {}
  local SortedTaskList = self:GetSortedTaskList(self.MidTermTasks)
  for _, Task in pairs(SortedTaskList) do
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if not TaskData then
    else
      local RewardPoint
      if type(TaskTypeConfig) == "table" then
        if TaskData.EnableDay ~= EventDay then
        else
          if TaskData.TaskType == TaskTypeConfig[1] or TaskData.TaskType == TaskTypeConfig[2] then
            RewardPoint = self:GetRewardPointByTaskType(TaskData.TaskType)
          end
          elseif TaskData.TaskType == TaskTypeConfig then
            RewardPoint = self:GetRewardPointByTaskType(TaskData.TaskType)
          end
          if RewardPoint then
            table.insert(Result, {
              TaskType = TaskData.TaskType,
              Id = TaskData.TaskId,
              Point = RewardPoint,
              Desc = TaskData.TaskDes,
              YesterdayRewardGot = YesterdayRewardGot,
              TaskProp = Task.Props,
              TaskConfig = TaskData,
              RawTask = Task
            })
          end
        end
    end
  end
  return Result
end

function M:BuildChallengeTaskEntries(EventDay)
  local ClaimableTasks = {}
  local OngoingTasks = {}
  local CompletedTasks = {}
  for k, Task in pairs(self.MidTermTasks) do
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if not TaskData or TaskData.TaskType ~= self.TaskType.Achievement then
    elseif EventDay < TaskData.EnableDay then
    else
      local TaskInfo = {
        key = tonumber(k) or 0,
        task = Task,
        taskData = TaskData
      }
      local IsFinished = Task.Progress >= Task.Target
      if Task.RewardsGot then
        table.insert(CompletedTasks, TaskInfo)
      elseif IsFinished then
        table.insert(ClaimableTasks, TaskInfo)
      else
        table.insert(OngoingTasks, TaskInfo)
      end
    end
  end
  
  local function sortTaskList(TaskList)
    table.sort(TaskList, function(a, b)
      return a.key < b.key
    end)
  end
  
  sortTaskList(ClaimableTasks)
  sortTaskList(OngoingTasks)
  sortTaskList(CompletedTasks)
  local Result = {}
  
  local function appendTaskList(TaskList)
    for _, TaskInfo in ipairs(TaskList) do
      table.insert(Result, {
        TaskType = TaskInfo.taskData.TaskType,
        TaskId = TaskInfo.taskData.TaskId,
        Point = self:GetRewardPointByTaskType(TaskInfo.taskData.TaskType),
        Desc = TaskInfo.taskData.TaskDes,
        TaskProp = TaskInfo.task,
        TaskConfig = TaskInfo.taskData
      })
    end
  end
  
  appendTaskList(ClaimableTasks)
  appendTaskList(OngoingTasks)
  appendTaskList(CompletedTasks)
  return Result
end

function M:CanClaimNormalTask(TaskProp)
  if not TaskProp then
    return false
  end
  local Progress = TaskProp.Progress or 0
  return Progress >= (TaskProp.Target or 0) and not TaskProp.RewardsGot
end

function M:CanClaimCycleTask(TaskUniqueID)
  return self.MidTermTasksRecord[TaskUniqueID] and self.MidTermTasksRecord[TaskUniqueID] > 0
end

function M:CanClaimChallengeTask(TaskProp)
  if not TaskProp then
    return false
  end
  return (TaskProp.Progress or 0) >= (TaskProp.Target or 0) and not TaskProp.RewardsGot
end

function M:HasUnclaimedNormalScoreReward()
  return CommonUtils.Size(self.MidTermScoresRewards) > 0
end

function M:CheckIsChallengeRewardAllClaimed()
  local AchievementPrize = DataMgr.AchievementPrize
  local MaxCount = 0
  for Count in pairs(AchievementPrize) do
    if Count > MaxCount then
      MaxCount = Count
    end
  end
  if MaxCount > self.MidTermAchvScores then
    return false
  end
  for Count in pairs(AchievementPrize) do
    if Count <= self.MidTermAchvScores and 1 ~= self.MidTermAchvProgressRewarded[Count] then
      return false
    end
  end
  return true
end

function M:BuildYesterdayRewardPreview()
  local RewardContentList = {}
  for RewardId, Count in pairs(self.MidTermScoresRewards) do
    local RewardConfig = DataMgr.Reward[RewardId]
    if RewardConfig then
      for Index, ResourceId in ipairs(RewardConfig.Id) do
        local ResourceConfig = DataMgr.Resource[ResourceId]
        table.insert(RewardContentList, {
          ItemType = RewardConfig.Type[1],
          ItemId = ResourceId,
          Icon = ItemUtils.GetItemIconPath(ResourceId, CommonConst.ItemType.Resource),
          Rarity = ResourceConfig.Rarity or 1,
          Count = RewardConfig.Count[Index][1] * Count
        })
      end
    end
  end
  return RewardContentList
end

function M:BuildCurrentRewardPreview(TaskScoreToday)
  local RewardContentList = {}
  local BaseRewardCount = self.MidTermConst.BaseRewardCount.ConstantValue
  local OFRewardCount = self.MidTermConst.OFRewardCount.ConstantValue
  local MaxPrizePoint = self.MidTermConst.MaxPrizePoint.ConstantValue
  
  local function appendReward(RewardId, Ratio, Extra)
    local RewardConfig = DataMgr.Reward[RewardId]
    if not RewardConfig then
      return
    end
    for Index, ResourceId in ipairs(RewardConfig.Id) do
      local ResourceConfig = DataMgr.Resource[ResourceId]
      local Item = {
        ItemType = RewardConfig.Type[1],
        ItemId = ResourceId,
        Icon = ItemUtils.GetItemIconPath(ResourceId, CommonConst.ItemType.Resource),
        Rarity = ResourceConfig.Rarity or 1,
        Count = RewardConfig.Count[Index][1] * Ratio
      }
      if Extra then
        for Key, Value in pairs(Extra) do
          Item[Key] = Value
        end
      end
      table.insert(RewardContentList, Item)
    end
  end
  
  if TaskScoreToday <= MaxPrizePoint then
    appendReward(self.MidTermConst.BaseRewardId.ConstantValue, TaskScoreToday / MaxPrizePoint * BaseRewardCount)
  else
    local OverflowScore = TaskScoreToday - MaxPrizePoint
    local OverflowRatio = OverflowScore / MaxPrizePoint
    appendReward(self.MidTermConst.OFRewardId.ConstantValue, OverflowRatio * OFRewardCount, {BonusType = 1})
    appendReward(self.MidTermConst.BaseRewardId.ConstantValue, BaseRewardCount)
  end
  return RewardContentList
end

function M:GetProgressText(TaskProp)
  local Progress = 0
  local Target = 0
  if TaskProp then
    Progress = TaskProp.Progress or 0
    Target = TaskProp.Target or 0
  end
  return tostring(Progress) .. "/" .. tostring(Target)
end

_G.JJGameModel = M
return M
