local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local NormalRewardReddotName = "JJGameTask_Normal_Reddot"
local ChallengeRewardReddotName = "JJGameTask_Challenge_Reddot"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local ChallengeTaskNewReddotName = "JJGameTask_Challenge_New"
local JJGameReddotName = "Acti_JJGame"
local ReddotTreeNode_JJGame = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_JJGame:OnRefreshNodeData(EventId)
  local HasRed = self:_Judge(EventId)
  if HasRed then
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey = "Red", EventId = EventId})
  else
    ReddotManager.DecreaseLeafNodeCount(self.Name, 1, {CacheKey = "Red", EventId = EventId})
  end
  local HasNew = self:HasTaskNewReddot()
  if HasNew then
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey = "New", EventId = EventId})
  else
    ReddotManager.DecreaseLeafNodeCount(self.Name, 1, {CacheKey = "New", EventId = EventId})
  end
  if not HasRed and not HasNew then
    self:ClearJJGameReddot()
  end
end

function ReddotTreeNode_JJGame:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return ReddotTreeNode_JJGame.Super.OnIncreaseJudge(self, AddValue, CacheDetailChangedParams)
  end
  local CacheKey = CacheDetailChangedParams.CacheKey
  local EventId = CacheDetailChangedParams.EventId
  if "Red" == CacheKey and 1 == AddValue then
    local CacheDetail = self.Cache.Detail
    return self:_Judge(EventId) and 1 ~= CacheDetail[CacheKey]
  end
  if "New" == CacheKey and 1 == AddValue then
    local CacheDetail = self.Cache.Detail
    return self:HasTaskNewReddot() and 1 ~= CacheDetail[CacheKey]
  end
  return ReddotTreeNode_JJGame.Super.OnIncreaseJudge(self, AddValue, CacheDetailChangedParams)
end

function ReddotTreeNode_JJGame:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return ReddotTreeNode_JJGame.Super.OnDecreaseJudge(self, SubValue, CacheDetailChangedParams)
  end
  if CacheDetailChangedParams.bClearAll then
    return ReddotTreeNode_JJGame.Super.OnDecreaseJudge(self, SubValue, CacheDetailChangedParams)
  end
  local CacheKey = CacheDetailChangedParams.CacheKey
  local EventId = CacheDetailChangedParams.EventId
  if "Red" == CacheKey and 1 == SubValue then
    local CacheDetail = self.Cache.Detail
    if 1 == CacheDetail[CacheKey] then
      return not self:_Judge(EventId)
    end
  end
  return ReddotTreeNode_JJGame.Super.OnDecreaseJudge(self, SubValue, CacheDetailChangedParams)
end

function ReddotTreeNode_JJGame:_Judge(ActivityID)
  local EventData = DataMgr.EventMain[ActivityID]
  if EventData and TimeUtils.NowTime() > EventData.RewardEndTime then
    self:ClearJJGameReddotWhenActivityEnd()
    return false
  end
  return JJGameController:HasActivityTabRewardReddot()
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
  ReddotManager.AddListenerEx(NormalRewardReddotName, self, self.OnChildReddotChange)
  ReddotManager.AddListenerEx(ChallengeRewardReddotName, self, self.OnChildReddotChange)
  ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.OnChildReddotChange)
  ReddotManager.AddListenerEx(ChallengeTaskNewReddotName, self, self.OnChildReddotChange)
  if self:IsAllChildrenEmpty() and self.Count and self.Count > 0 then
    self:ClearJJGameReddot()
  end
end

function ReddotTreeNode_JJGame:OnDisposeNode()
  ReddotManager.RemoveListener(NormalRewardReddotName, self)
  ReddotManager.RemoveListener(ChallengeRewardReddotName, self)
  ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
  ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
end

function ReddotTreeNode_JJGame:IsAllChildrenEmpty()
  local nodeNames = {
    NormalRewardReddotName,
    ChallengeRewardReddotName,
    NormalTaskNewReddotName,
    ChallengeTaskNewReddotName
  }
  for _, name in ipairs(nodeNames) do
    if self:IsNodeCountActive(name) then
      return false
    end
  end
  return true
end

function ReddotTreeNode_JJGame:IsNodeCountActive(NodeName)
  local Node = ReddotManager.GetTreeNode(NodeName)
  return Node and Node.Count and Node.Count > 0
end

function ReddotTreeNode_JJGame:HasTaskNewReddot()
  return self:IsNodeCountActive(NormalTaskNewReddotName) or self:IsNodeCountActive(ChallengeTaskNewReddotName)
end

function ReddotTreeNode_JJGame:OnChildReddotChange(Count, RdType, RdName)
  if ReddotManager.GetTreeNode(self.Name) ~= self then
    return
  end
  if self:IsAllChildrenEmpty() then
    if self.Count and self.Count > 0 then
      self:ClearJJGameReddot()
    end
  else
    local MidTermGoalEventId = DataMgr.MidTermGoalConstant.MidTermGoalEventId.ConstantValue
    self:OnRefreshNodeData(MidTermGoalEventId)
  end
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

function ReddotTreeNode_JJGame:ClearJJGameReddot()
  if not ReddotManager.GetTreeNode(JJGameReddotName) then
    ReddotManager.AddNodeEx(JJGameReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(JJGameReddotName)
  if CacheData then
    for key, _ in pairs(CacheData) do
      CacheData[key] = nil
    end
    CacheData.New = 0
    CacheData.Red = 0
    ReddotManager.ClearLeafNodeCount(JJGameReddotName)
  end
end

return ReddotTreeNode_JJGame
