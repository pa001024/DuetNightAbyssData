local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local Component = {}

function Component:GMPhaseQuestComplete(EventId, StarterQuestID)
  self:CallServerMethod("GMPhaseQuestComplete", EventId, StarterQuestID)
end

function Component:StarterQuestGetReward(StarterQuestId)
  self.logger.info("StarterQuestGetReward", StarterQuestId)
  
  local function Cb(ErrCode)
    DebugPrint("StarterQuestGetReward", ErrorCode:Name(ErrCode))
    if ErrorCode:Check(ErrCode, UIConst.Tip_CommonToast) then
      EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestGetReward", StarterQuestId)
      local RewardIds = DataMgr.StarterQuestDetail[StarterQuestId].QuestReward
      if nil ~= RewardIds then
        local AllRewards = RewardUtils:GetRewards(RewardIds, nil)
        UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", nil, nil, nil, AllRewards)
      end
      local ActivityId = DataMgr.StarterQuestDetail[StarterQuestId].EventId
      ActivityUtils.ChangeStarterQuestReddot()
      EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestRefreshReddot", ActivityId)
    end
  end
  
  self:CallServer("RpcStarterQuestGetReward", Cb, StarterQuestId)
end

function Component:NotifyPhaseQuestComplete(EventId, QuestId)
  DebugPrint("NotifyPhaseQuestComplete <EventId,QuestId>", EventId, QuestId)
  if DataMgr.EventMain[EventId].SubExcel == "StarterQuestDetail" then
    self:NotifyStarterQuestComplete(EventId, QuestId)
  end
end

function Component:NotifyStarterQuestComplete(EventId, StarterQuestId)
  StarterQuestId = StarterQuestId or EventId
  DebugPrint("NotifyStarterQuestComplete StarterQuestId:", StarterQuestId)
  if not StarterQuestId then
    DebugPrint("NotifyStarterQuestComplete Error Empty StarterQuestId:")
    return
  end
  local CurQuestPhaseId = DataMgr.StarterQuestDetail[StarterQuestId].QuestPhaseId
  EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestComplete", StarterQuestId)
end

function Component:GetAllStarterQuest(PhaseId, Cb)
  Cb = Cb or function(Rewards)
    if nil ~= Rewards and #Rewards > 0 then
      local RewardIds = {}
      for _, RewardInfo in ipairs(Rewards) do
        if type(RewardInfo) == "table" then
          for _, v in ipairs(RewardInfo) do
            table.insert(RewardIds, v)
          end
        else
          table.insert(RewardIds, RewardInfo)
        end
      end
      local AllRewards = RewardUtils:GetRewards(RewardIds, nil)
      UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", nil, nil, nil, AllRewards)
    end
    EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestGetAllReward", PhaseId)
    local ActivityId = DataMgr.StarterQuestPhase[PhaseId].EventId
    ActivityUtils.ChangeStarterQuestReddot()
    EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestRefreshReddot", ActivityId)
  end
  local PrepareSend = {}
  for _, StarterQuestId in ipairs(DataMgr.StarterQuestPhaseMap[PhaseId]) do
    if self.StarterQuests[StarterQuestId]:IsComplete() == true then
      table.insert(PrepareSend, StarterQuestId)
    end
  end
  if 0 == CommonUtils.Size(PrepareSend) then
    Cb(nil)
    return
  end
  local Rewards = {}
  local Count = CommonUtils.Size(PrepareSend)
  for _, StarterQuestId in ipairs(PrepareSend) do
    self:CallServer("RpcStarterQuestGetReward", function(errcode)
      Count = Count - 1
      if errcode == ErrorCode.RET_SUCCESS then
        table.insert(Rewards, DataMgr.StarterQuestDetail[StarterQuestId].QuestReward)
      end
      if 0 == Count then
        Cb(Rewards)
      end
    end, StarterQuestId)
  end
end

function Component:_OnPropChangeStarterQuests()
  ActivityUtils.ChangeStarterQuestReddot()
end

function Component:TestCondition()
  self.logger.info("TestCondition", self:CheckCondition(465456))
end

return Component
