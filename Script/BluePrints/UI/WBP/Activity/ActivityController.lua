local ActivityModel = require("BluePrints.UI.WBP.Activity.ActivityModel")
local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
  EventManager:AddEvent(EventID.OnDailyRefresh, self, self.OnRefreshInNextDay)
  EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.OnRefreshWithActivityOpen)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
  EventManager:AddEvent(EventID.OnActivityComplete, self, self.OnRefreshWithActivityClose)
  EventManager:AddEvent(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
  self:RefreshDoubleModDropEventID()
end

function M:GetEventName()
  return EventID.ActivityControllerEvent
end

function M:Destory()
  M.Super.Destory(self)
  EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
  EventManager:RemoveEvent(EventID.OnActivityComplete, self)
  EventManager:RemoveEvent(EventID.OnRechargeFinished, self)
end

function M:OnRefreshInNextDay()
  self:NotifyEvent(ActivityCommon.EventId.OnRefreshInNextDay)
  for key, ActivityId in pairs(ActivityCommon.NeedRefreshInNextDay) do
    ActivityUtils.TryAddActivityReddotCommon("Red", ActivityId)
  end
  if DataMgr.EventMain then
    for ActivityId, EventData in pairs(DataMgr.EventMain) do
      if EventData.EventTypeId == ActivityCommon.EventAllTypeId.DailyLogin then
        ActivityUtils.TryAddActivityReddotCommon("Red", ActivityId)
      end
    end
  end
end

function M:OnRefreshWithActivityOpen(ActivityId)
  ActivityUtils.TryAddActivityReddotCommon("Red", ActivityId)
  self:RefreshDoubleModDropEventID()
end

function M:OnRefreshWithActivityClose(ActivityId)
  ActivityUtils.TryClearActivityReddotCommon(ActivityId)
  self:RefreshDoubleModDropEventID()
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems)
  if Result == ErrorCode.RET_SUCCESS and DataMgr.PayGoods[GoodsId] then
    for ActivityId, _ in pairs(DataMgr.CumulativeTopUpEvent) do
      ActivityUtils.TryClearActivityReddotCommon(ActivityId)
    end
  end
end

function M:GetModel()
  return ActivityModel
end

function M:RefreshDoubleModDropEventID()
  self.DoubleModDropEventID = 0
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return self.DoubleModDropEventID, false
  end
  for EventId, _ in pairs(DataMgr.DoubleModDrop) do
    if Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventId] then
      self.DoubleModDropEventID = EventId
      return self.DoubleModDropEventID, true
    end
  end
  return self.DoubleModDropEventID, false
end

function M:GetDoubleModDropEventID()
  return self.DoubleModDropEventID
end

_G.ActivityController = M
return M
