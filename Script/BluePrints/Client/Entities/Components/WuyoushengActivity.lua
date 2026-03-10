local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local Component = {}
local WuyoushengLevelReddotName = "WuyoushengLevel"
local WuyoushengId = {110001}

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.RefreshWuyoushengReddot)
  EventManager:AddEvent(EventID.RefreshWuyoushengLevelReddot, self, self.RefreshWuyoushengReddot)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
  EventManager:RemoveEvent(EventID.RefreshWuyoushengLevelReddot, self)
end

function Component:RefreshWuyoushengReddot()
  self:RefreshWuyoushengNewLevelReddot()
  self:RefreshWuyoushengRewardReddot()
end

function Component:WuyoushengGetReward(EventId, RewardKeyId, CallBack)
  self.logger.info("WuyoushengGetReward", EventId, RewardKeyId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("WuyoushengGetReward", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WuyoushengGetReward", Cb, EventId, RewardKeyId)
end

function Component:WuyoushengGetAllReward(EventId, CallBack)
  self.logger.info("WuyoushengGetAllReward", EventId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("WuyoushengGetAllReward", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WuyoushengGetAllReward", Cb, EventId)
end

function Component:WuyoushengSetSquad(EventId, DungeonId, Squad, CallBack)
  self.logger.info("WuyoushengSetSquad", EventId, DungeonId, Squad)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("WuyoushengSetSquad", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WuyoushengSetSquad", Cb, EventId, DungeonId, Squad)
end

function Component:RefreshWuyoushengNewLevelReddot()
  local ReddotNode = ReddotManager.GetTreeNode(WuyoushengLevelReddotName)
  ReddotNode = ReddotNode or ReddotManager.AddNodeEx(WuyoushengLevelReddotName)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
  if not CacheDetail then
    return
  end
  for DungeonId, _ in pairs(DataMgr.WuyoushengEventLevel or {}) do
    if true == CacheDetail[DungeonId] then
      CacheDetail[DungeonId] = nil
    end
  end
  ReddotManager.ClearLeafNodeCount(WuyoushengLevelReddotName)
  for _, EventId in ipairs(WuyoushengId) do
    self:_TryAddWuyoushengNewLevelReddot(EventId)
  end
end

function Component:_TryAddWuyoushengNewLevelReddot(EventId)
  local ReddotNode = ReddotManager.GetTreeNode(WuyoushengLevelReddotName)
  ReddotNode = ReddotNode or ReddotManager.AddNodeEx(WuyoushengLevelReddotName)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
  if not CacheDetail then
    return
  end
  if CacheDetail.EventId ~= EventId then
    ReddotManager.ClearLeafNodeCount(WuyoushengLevelReddotName, true)
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
  end
  CacheDetail.EventId = EventId
  local WuyoushengEventLevelData = DataMgr.WuyoushengEventLevel
  if not WuyoushengEventLevelData then
    return
  end
  local PageConfigData = DataMgr.EventPortal[EventId]
  if PageConfigData and ActivityUtils.CheckIsActivityLock(PageConfigData) then
    return
  end
  if not ActivityUtils.CheckEventIsOpen(EventId, nil, false, nil) then
    ReddotManager.ClearLeafNodeCount(WuyoushengLevelReddotName, true)
    return
  end
  local CurrentTime = TimeUtils.NowTime()
  local IncreaseNum = 0
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
  for DungeonId, LevelCfg in pairs(WuyoushengEventLevelData) do
    if false == CacheDetail[DungeonId] then
    else
      local UnlockDate = LevelCfg.UnlockDate
      UnlockDate = UnlockDate:GetTime()
      if UnlockDate and CurrentTime < UnlockDate then
      else
        local PerviousDungeon = LevelCfg.PerviousDungeon
        if PerviousDungeon then
          local FinishStars = 0
          if WuyoushengData then
            FinishStars = WuyoushengData:GetFinishStars(PerviousDungeon) or 0
          end
          if 0 == FinishStars then
        end
        elseif nil == CacheDetail[DungeonId] then
          CacheDetail[DungeonId] = true
          IncreaseNum = IncreaseNum + 1
        end
      end
    end
  end
  if IncreaseNum > 0 then
    ReddotManager.IncreaseLeafNodeCount(WuyoushengLevelReddotName, IncreaseNum)
  end
end

function Component:RefreshWuyoushengRewardReddot()
  local ReddotNode = ReddotManager.GetTreeNode("WuyoushengReward")
  ReddotNode = ReddotNode or ReddotManager.AddNodeEx("WuyoushengReward")
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
  if not CacheDetail then
    return
  end
  local WuyoushengTaskData = DataMgr.WuyoushengEventReward
  if WuyoushengTaskData then
    for RewardKeyId, _ in pairs(WuyoushengTaskData) do
      if true == CacheDetail[RewardKeyId] then
        CacheDetail[RewardKeyId] = nil
      end
    end
  end
  ReddotManager.ClearLeafNodeCount("WuyoushengReward")
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not ActivityUtils.CheckEventIsOpen(WuyoushengId[1], nil, false, nil) then
    return
  end
  for _, EventId in ipairs(WuyoushengId) do
    self:_TryAddWuyoushengRewardReddot(EventId)
  end
end

function Component:_TryAddWuyoushengRewardReddot(EventId)
  local ReddotNode = ReddotManager.GetTreeNode("WuyoushengReward")
  ReddotNode = ReddotNode or ReddotManager.AddNodeEx("WuyoushengReward")
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
  if not CacheDetail then
    return
  end
  if ActivityUtils.CheckIsPermanentEvent(EventId) then
    local WuyoushengTaskData = DataMgr.WuyoushengEventReward
    if WuyoushengTaskData then
      local DecreaseCount = 0
      for RewardKeyId, TaskInfo in pairs(WuyoushengTaskData) do
        if TaskInfo.EventId == EventId and true == CacheDetail[RewardKeyId] then
          CacheDetail[RewardKeyId] = false
          DecreaseCount = DecreaseCount + 1
        end
      end
      if DecreaseCount > 0 then
        ReddotManager.DecreaseLeafNodeCount("WuyoushengReward", DecreaseCount)
      end
    end
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
  if not WuyoushengData then
    return
  end
  local WuyoushengTaskData = DataMgr.WuyoushengEventReward
  if not WuyoushengTaskData then
    return
  end
  local IncreaseNum = 0
  for RewardKeyId, TaskInfo in pairs(WuyoushengTaskData) do
    if TaskInfo.EventId == EventId then
      local CanReceive = WuyoushengData:IsCompleted(RewardKeyId, TaskInfo.RequiredStar) and not WuyoushengData:IsRewarded(RewardKeyId)
      if CanReceive then
        CacheDetail[RewardKeyId] = true
        IncreaseNum = IncreaseNum + 1
      else
        CacheDetail[RewardKeyId] = false
      end
    end
  end
  if IncreaseNum > 0 then
    ReddotManager.IncreaseLeafNodeCount("WuyoushengReward", IncreaseNum)
  end
end

return Component
