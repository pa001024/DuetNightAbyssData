local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local MONEYTREE_REDDOT_CACHEKEY = "Red"
local MONEYTREE_REDDOT_CACHETYPE = 1
local MONEYTREE_REDDOT_MODULE = "Activity.MoneyTree"
local Component = {}

function Component:CheckMoneyTreeReddot()
  if TimeUtils.ServerTimeZone == nil then
    return
  end
  local EventId = MoneyTreeMgr.GetActiveEventId()
  if not EventId then
    return
  end
  local NodeName = ActivityReddotHelper.GetEventMainNodeName(EventId)
  if NodeName and not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNodeEx(NodeName, nil, MONEYTREE_REDDOT_CACHETYPE, nil, MONEYTREE_REDDOT_MODULE)
  end
  if MoneyTreeMgr.ShouldShowEntryReddot() then
    ActivityReddotHelper.TryAddReddotCount(nil, EventId, MONEYTREE_REDDOT_CACHEKEY)
  else
    ActivityReddotHelper.TrySubReddotCount(nil, EventId, MONEYTREE_REDDOT_CACHEKEY)
  end
end

function Component:MoneyTreeClaimFree(EventId, Callback)
  self.logger.info("MoneyTreeClaimFree", EventId)
  Callback = Callback or function()
  end
  self:CallServer("MoneyTreeClaimFree", Callback, EventId or 0)
end

function Component:MoneyTreeRequestSingleDoublePay(EventId, Callback)
  self.logger.info("MoneyTreeRequestSingleDoublePay", EventId)
  Callback = Callback or function()
  end
  self:CallServer("MoneyTreeRequestSingleDoublePay", Callback, EventId or 0)
end

function Component:MoneyTreeRequestAllDoublePay(EventId, Callback)
  self.logger.info("MoneyTreeRequestAllDoublePay", EventId)
  Callback = Callback or function()
  end
  self:CallServer("MoneyTreeRequestAllDoublePay", Callback, EventId or 0)
end

function Component:MoneyTreePaySuccessNotify(EventId, PayType, ExtraReward, RewardResourceId)
  self.logger.info("MoneyTreePaySuccessNotify", EventId, PayType, ExtraReward, RewardResourceId)
  MoneyTreeMgr._DispatchPaySuccess(PayType, ExtraReward, RewardResourceId)
end

function Component:MoneyTreeTestRandomResultNotify(EventId, ClaimIndex, Rewards)
  if nil == Rewards then
    DebugPrint("MoneyTreeTestRandom 随机范围检查失败：没有随机结果")
    return
  end
  local ResultTexts = {}
  for Index, Reward in ipairs(Rewards) do
    ResultTexts[Index] = tostring(Reward)
  end
  local RewardConf = DataMgr.MoneyTree_DailyReward[EventId][ClaimIndex]
  local MinReward = RewardConf.MinReward
  local MaxReward = RewardConf.MaxReward
  local OutOfRangeTexts = {}
  for Index, Reward in ipairs(Rewards) do
    if not Reward or Reward < MinReward or Reward > MaxReward then
      OutOfRangeTexts[#OutOfRangeTexts + 1] = string.format("%s@%s", tostring(Reward), tostring(Index))
    end
  end
  local AnalysisLine
  if #OutOfRangeTexts > 0 then
    AnalysisLine = string.format("MoneyTreeTestRandom 随机范围=[%s,%s] 越界数量=%s %s", tostring(MinReward), tostring(MaxReward), tostring(#OutOfRangeTexts), table.concat(OutOfRangeTexts, " "))
  else
    AnalysisLine = string.format("MoneyTreeTestRandom 随机范围=[%s,%s] 越界数量=0", tostring(MinReward), tostring(MaxReward))
  end
  local ResultsLine = table.concat(ResultTexts, " ")
  DebugPrint(ResultsLine)
  DebugPrint(AnalysisLine)
end

function Component:_OnPropChangeMoneyTree(Keys)
  MoneyTreeMgr._DispatchStateChanged()
  self:CheckMoneyTreeReddot()
end

function Component:EnterWorld()
  self:CheckMoneyTreeReddot()
end

return Component
