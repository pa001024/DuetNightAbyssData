local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local TimeUtils = require("Utils.TimeUtils")
local pairs = _ENV.pairs
local Component = {}
local DrawType = {Single = 0, Round = 1}

function Component:DrawLimitPrizeForSingle(Callback, EventId)
  self:DrawLimitPrizeByType(Callback, EventId, DrawType.Single)
end

function Component:DrawLimitPrizeForRound(Callback, EventId)
  self:DrawLimitPrizeByType(Callback, EventId, DrawType.Round)
end

function Component:DrawLimitPrizeByType(Callback, EventId, Type)
  assert(EventId)
  assert(Type)
  
  local function cb(Ret, ...)
    if Ret == ErrorCode.RET_SUCCESS then
      self:RefreshLimitedPrizeRewardSelectReddot(EventId)
    end
    if Callback then
      Callback(Ret, ...)
    end
  end
  
  self:CallServer("DrawLimitPrize", cb, EventId, Type)
end

function Component:SetLimitPrizeSelfSelect(Callback, EventId, PrizeIdx, SelectId)
  assert(EventId)
  assert(PrizeIdx)
  assert(SelectId)
  
  local function cb(Ret)
    if Ret == ErrorCode.RET_SUCCESS then
      self:RefreshLimitedPrizeRewardSelectReddot(EventId)
    end
    if Callback then
      Callback(Ret)
    end
  end
  
  self:CallServer("SetLimitPrizeSelfSelect", cb, EventId, PrizeIdx, SelectId)
end

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
  EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnLimitedPrizeActivityTimeOpen)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
end

function Component:OnLoginSuccess()
  self:RefreshLimitedPrizeRewardSelectReddot()
end

function Component:OnLimitedPrizeActivityTimeOpen(EventId)
  if DataMgr.LimitedPrizePool[EventId] then
    self:RefreshLimitedPrizeRewardSelectReddot(EventId)
  end
end

function Component:HasLimitedPrizeUnselectedReward(EventId)
  if TimeUtils.ServerTimeZone == nil or not self:CheckUIUnlocked("GameEvent") then
    return false
  end
  local EventData = DataMgr.EventMain[EventId]
  local PoolData = DataMgr.LimitedPrizePool[EventId]
  if not (EventData and PoolData) or not PoolData.LimitedPrizePoolId then
    return false
  end
  if not ActivityUtils.CheckEventIsOpenNoCache(EventId, EventData, true, "GameEvent", TimeUtils.NowTime()) then
    return false
  end
  local LimitPrizeData = self.LimitPrize and self.LimitPrize[EventId] or {}
  if (LimitPrizeData.DrawCounts or 0) > 0 then
    return false
  end
  local Round = LimitPrizeData.Round or 1
  if Round <= 0 or Round > #PoolData.LimitedPrizePoolId then
    return false
  end
  local RoundData = DataMgr.LimitedPrizeItem[PoolData.LimitedPrizePoolId[Round]]
  if not RoundData or not RoundData.Id then
    return false
  end
  local SelfSelectData = LimitPrizeData.SelfSelect or {}
  for Index, Rewards in pairs(RoundData.Id) do
    if #Rewards > 1 and not SelfSelectData[Index] then
      return true
    end
  end
  return false
end

function Component:RefreshLimitedPrizeRewardSelectReddot(EventId)
  if TimeUtils.ServerTimeZone == nil then
    return
  end
  if not EventId then
    for PoolEventId, _ in pairs(DataMgr.LimitedPrizePool) do
      self:RefreshLimitedPrizeRewardSelectReddot(PoolEventId)
    end
    return
  end
  if not DataMgr.LimitedPrizePool[EventId] then
    return
  end
  local NodeName = ActivityReddotHelper.GetEventMainNodeName(EventId)
  local NodeData = NodeName and DataMgr.ReddotNode[NodeName]
  if not (NodeName == "Acti_LimitedPrize_" .. EventId and NodeData and NodeData.IsLeaf) or NodeData.CacheType ~= Const.ReddotCacheType.UserCache or NodeData.NodeModuleName ~= "Activity.LimitedPrize" then
    DebugPrint(ErrorTag, "LimitedPrize: invalid activity reddot config", EventId, NodeName)
    return
  end
  local Node = ReddotManager.GetTreeNode(NodeName) or ReddotManager.AddNodeEx(NodeName)
  if Node and Node.OnRefreshNodeData then
    Node:OnRefreshNodeData(EventId)
  else
    DebugPrint(ErrorTag, "LimitedPrize: activity reddot module is unavailable", EventId, NodeName)
  end
end

return Component
