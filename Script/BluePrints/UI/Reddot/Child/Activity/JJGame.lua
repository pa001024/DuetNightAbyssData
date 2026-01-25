local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local NormalRewardReddotName = "JJGameTask_Normal_Reddot"
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"
local ReddotTreeNode_JJGame = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_JJGame:_Judge(ActivityID)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local EventEndTime = DataMgr.EventMain[ActivityID].EventEndTime
  local RewardEndTime = DataMgr.EventMain[ActivityID].RewardEndTime
  if RewardEndTime < TimeUtils.NowTime() then
    self:ClearJJGameReddotWhenActivityEnd()
    return false
  end
  if EventEndTime < TimeUtils.NowTime() then
    if CommonUtils.Size(Avatar.MidTermScoresRewards) > 0 then
      return true
    else
      return false
    end
  end
  if CommonUtils.Size(Avatar.MidTermScoresRewards) > 0 then
    return true
  end
  for _, v in pairs(Avatar.MidTermAchvProgressRewarded) do
    if 0 == v then
      return true
    end
  end
  for TaskId, Task in pairs(Avatar.MidTermTasks) do
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if Avatar.MidTermTasksRecord[TaskId] and Avatar.MidTermTasksRecord[TaskId].FinishCount and Avatar.MidTermTasksRecord[TaskId].FinishCount > 0 then
      return true
    end
    if Task.Progress >= Task.Target and Task.RewardsGot == false and TaskData.EnableDay <= self:CalEventDay() then
      return true
    end
  end
  return false
end

function ReddotTreeNode_JJGame:CalEventDay()
  local MidTermGoalEventId = DataMgr.MidTermGoalConstant.MidTermGoalEventId.ConstantValue
  local EventStartTime = DataMgr.EventMain[MidTermGoalEventId].EventStartTime
  local currentTime = TimeUtils.NowTime()
  local intervalDays = TimeUtils.GetIntervalDay(EventStartTime, currentTime)
  local calculatedEventDay = intervalDays + 1
  return calculatedEventDay
end

function ReddotTreeNode_JJGame:OnInitNodeCache(NodeCache)
  ReddotTreeNode_JJGame.Super.OnInitNodeCache(self, NodeCache)
  ReddotManager.AddListenerEx("Acti_JJGame", self, self.OnJJGameReddotChange)
end

function ReddotTreeNode_JJGame:OnDisposeNode()
  ReddotManager.RemoveListener("Acti_JJGame", self)
end

function ReddotTreeNode_JJGame:OnJJGameReddotChange(Count, RdType, RdName)
  if 0 ~= Count then
    return
  end
  self:ClearJJGameReddotWhenActivityEnd()
end

function ReddotTreeNode_JJGame:ClearJJGameReddotWhenActivityEnd()
  self.MidTermGoalEventId = DataMgr.MidTermGoalConstant.MidTermGoalEventId.ConstantValue
  local EventEndTime = DataMgr.EventMain[self.MidTermGoalEventId].RewardEndTime
  if EventEndTime < TimeUtils.NowTime() then
    self:ClearChallengeTaskNewReddot()
    self:ClearChallengeRewardReddot()
    self:ClearNormalTaskNewReddot()
    self:ClearNormalRewardReddot()
  end
end

function ReddotTreeNode_JJGame:ClearChallengeTaskNewReddot()
  if not ReddotManager.GetTreeNode(ChallengeTaskNewReddotName) then
    ReddotManager.AddNodeEx(ChallengeTaskNewReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
  if CacheData then
    for key, _ in pairs(CacheData) do
      CacheData[key] = nil
    end
    ReddotManager.ClearLeafNodeCount(ChallengeTaskNewReddotName)
  end
end

function ReddotTreeNode_JJGame:ClearChallengeRewardReddot()
  if not ReddotManager.GetTreeNode(ChallengeRewardReddotName) then
    ReddotManager.AddNodeEx(ChallengeRewardReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
  if CacheData then
    for key, _ in pairs(CacheData) do
      CacheData[key] = nil
    end
    ReddotManager.ClearLeafNodeCount(ChallengeRewardReddotName)
  end
end

function ReddotTreeNode_JJGame:ClearNormalTaskNewReddot()
  if not ReddotManager.GetTreeNode(NormalTaskNewReddotName) then
    ReddotManager.AddNodeEx(NormalTaskNewReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
  if CacheData then
    for key, _ in pairs(CacheData) do
      CacheData[key] = nil
    end
    ReddotManager.ClearLeafNodeCount(NormalTaskNewReddotName)
  end
end

function ReddotTreeNode_JJGame:ClearNormalRewardReddot()
  if not ReddotManager.GetTreeNode(NormalRewardReddotName) then
    ReddotManager.AddNodeEx(NormalRewardReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
  if CacheData then
    for key, _ in pairs(CacheData) do
      CacheData[key] = nil
    end
    ReddotManager.ClearLeafNodeCount(NormalRewardReddotName)
  end
end

return ReddotTreeNode_JJGame
