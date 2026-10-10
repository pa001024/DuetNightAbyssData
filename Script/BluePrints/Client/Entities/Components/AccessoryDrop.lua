local Component = {}
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.CheckReddot)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:CheckReddot(EventId)
  local AccessoryDrops = self.AccessoryDrops
  if not AccessoryDrops then
    return
  end
  if not EventId then
    for AccessoryDropEventId, _ in pairs(AccessoryDrops) do
      self:CheckReddot(AccessoryDropEventId)
    end
    return
  end
  local AccessDropConfig = DataMgr.BoxDrop[EventId]
  local ActivityConfigData = DataMgr.EventMain[EventId]
  if not AccessDropConfig or not ActivityConfigData then
    return
  end
  if not ActivityUtils.CheckEventIsInActiveTime(EventId, ActivityConfigData) then
    return
  end
  local AccessoryDrop = AccessoryDrops[EventId]
  if not AccessoryDrop then
    return
  end
  local BoxCoin = self.Resources and self.Resources[AccessDropConfig.BoxCoinId]
  local OwnBoxCoinAmount = BoxCoin and BoxCoin.Count or 0
  local CoinPerBox = AccessDropConfig.CoinPerBox
  local BoxCount = OwnBoxCoinAmount > 0 and math.floor(OwnBoxCoinAmount / CoinPerBox) or 0
  local TodayCanOpenBoxCount = BoxCount > AccessoryDrop.CurDropBoxNum and AccessoryDrop.CurDropBoxNum or BoxCount
  local RedDotName = ActivityConfigData.ReddotNode
  if not RedDotName then
    return
  end
  if TodayCanOpenBoxCount > 0 then
    ReddotManager.IncreaseLeafNodeCount(RedDotName, 1, {CacheKey = "Red", EventId = EventId})
  else
    ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {CacheKey = "Red", EventId = EventId})
  end
end

function Component:_OnLoginSuccess()
end

function Component:_OnPropChangeAccessoryDrops(keys)
  if CommonUtils.Size(keys) > 0 then
    local EventId = keys[1]
    if DataMgr.BoxDrop[EventId] then
      self:CheckReddot(EventId)
    end
  end
end

function Component:_OnPropChangeResources(keys)
  if CommonUtils.Size(keys) > 0 then
    local ResourceId = keys[1]
    for EventId, _ in pairs(self.AccessoryDrops or {}) do
      local AccessDropConfig = DataMgr.BoxDrop[EventId]
      if AccessDropConfig and AccessDropConfig.BoxCoinId == ResourceId then
        self:CheckReddot(EventId)
      end
    end
  end
end

function Component:OpenAccesorryBox(InCallBack)
  self.logger.info("OpenAccesorryBox")
  
  local function Cb(ErrCode, Reward)
    DebugPrint("OpenAccesorryBox", ErrorCode:Name(ErrCode), Reward)
    if InCallBack then
      InCallBack.Func(InCallBack.Obj, Reward)
    end
  end
  
  self:CallServer("OpenAccesorryBox", Cb)
end

return Component
