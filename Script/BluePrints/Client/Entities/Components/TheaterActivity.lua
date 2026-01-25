local Component = {}
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

function Component:EnterWorld()
  self:RefreshTheaterEventRewardReddot()
end

function Component:TheaterGetTaskReward(TaskId, InCallBack)
  self.logger.info("TheaterGetTaskReward", TaskId)
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterGetTaskReward", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterGetTaskReward", Cb, TaskId)
end

function Component:TheaterGetAllTaskReward(IsDaily, InCallBack)
  self.logger.info("TheaterGetAllTaskReward", IsDaily)
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterGetAllTaskReward", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterGetAllTaskReward", Cb, IsDaily)
end

function Component:TheaterDonate(StepId, DonateList, InCallBack)
  self.logger.info("TheaterDonate", StepId, DonateList)
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterDonate", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterDonate", Cb, StepId, DonateList)
end

function Component:TheaterJoinPerformGame(InCallBack)
  self.logger.info("TheaterJoinPerformGame")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterJoinPerformGame", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterJoinPerformGame", Cb)
end

function Component:TheaterPerform(PerformId, PerformIdx, InCallBack)
  self.logger.info("TheaterPerform", PerformId, PerformIdx)
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterPerform", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterPerform", Cb, math.tointeger(PerformId), PerformIdx)
end

function Component:TheaterPerformGameStart(EventId, PerformList)
  self.logger.info("TheaterPerformGameStart", EventId, PerformList)
  EventManager:FireEvent(EventID.OnTheaterPerformGameStart, EventId, PerformList)
end

function Component:TheaterPerformGameNotice(EventId)
  self.logger.info("TheaterPerformGameNotice", EventId)
  EventManager:FireEvent(EventID.OnTheaterPerformGameNotice, EventId)
end

function Component:TheaterPerformGameEnd(EventId)
  self.logger.info("TheaterPerformGameEnd", EventId)
end

function Component:TheaterPerformStateGet(InCallBack)
  self.logger.info("TheaterPerformStateGet")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterPerformStateGet", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterPerformStateGet", Cb)
end

function Component:TheaterDonationGet(InCallBack)
  self.logger.info("TheaterDonationGet")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("TheaterDonationGet", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("TheaterDonationGet", Cb)
end

function Component:_OnPropChangeTheaterActivity(key)
  self:RefreshTheaterEventRewardReddot()
end

function Component:RefreshTheaterEventRewardReddot()
  local TabInfo = {false, false}
  local TheaterTaskData = DataMgr.TheaterTask
  local EventId = DataMgr.TheaterConstant.EventId.ConstantValue
  local TheaterData = self.TheaterActivity and self.TheaterActivity[EventId] or nil
  if not TheaterData then
    return
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TheaterEventReward")
  CacheDetail = CacheDetail or {}
  local IsEmpty = true
  local Node = ReddotManager.GetTreeNode("TheaterEventReward")
  for TaskId, TaskInfo in pairs(TheaterData.Tasks) do
    if TaskInfo.Progress >= TaskInfo.Target and not TaskInfo.RewardsGot then
      IsEmpty = false
      if not Node then
        ReddotManager.AddNode("TheaterEventReward")
      end
      local isDaily = TheaterTaskData[TaskId].IsDaily
      local index = isDaily and 1 or 2
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TheaterEventReward")
      CacheDetail[index] = true
      TabInfo[index] = true
    end
  end
  for i = 1, #TabInfo do
    CacheDetail[i] = TabInfo[i]
  end
  if not IsEmpty then
    ActivityReddotHelper.TryAddReddotCount(ActivityUtils, EventId, "Red")
  else
    ActivityReddotHelper.TrySubReddotCount(ActivityUtils, EventId, "Red")
  end
  if Node then
    ReddotManager.IncreaseLeafNodeCount("TheaterEventReward", 1)
  end
end

function Component:TheaterPerformGameReward(TotalRewardsBox)
  self.logger.info("TheaterPerformGameReward")
  local RewardList = {}
  local RewardId
  for Id, State in pairs(TotalRewardsBox.OriginRewardIds) do
    if 1 == State then
      RewardId = Id
      break
    end
  end
  local RewardInfo = DataMgr.Reward[RewardId]
  if RewardInfo then
    local RewardIds = RewardInfo.Id or {}
    local RewardCounts = RewardInfo.Count or {}
    local RewardTypes = RewardInfo.Type or {}
    for i = 1, #RewardIds do
      local ItemId = RewardIds[i]
      local Count = RewardUtils:GetCount(RewardCounts[i])
      local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
      local ItemType = RewardTypes[i]
      local RewardContent = {
        ItemId = ItemId,
        ItemType = ItemType,
        Count = Count,
        Rarity = Rarity
      }
      table.insert(RewardList, RewardContent)
    end
  end
  UIUtils.ShowHudReward(GText("UI_COMMON_REWARD"), RewardList)
end

return Component
