local Component = {}

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.CheckReddot)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:CheckReddot()
  local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
  local EventIds = ActivityCommon.AccessoryDropActivityIds
  local PlayerAvatar = self
  local AccessoryDrop, CurEventId
  for _, EventId in pairs(EventIds) do
    AccessoryDrop = PlayerAvatar.AccessoryDrops[EventId]
    if AccessoryDrop then
      CurEventId = EventId
    end
  end
  if not AccessoryDrop then
    return
  end
  local AccessDropConfig = DataMgr.BoxDrop[CurEventId]
  local BoxCoin = GWorld:GetAvatar().Resources[AccessDropConfig.BoxCoinId]
  local OwnBoxCoinAmount = BoxCoin and BoxCoin.Count or 0
  local CoinPerBox = AccessDropConfig.CoinPerBox
  local BoxCount = OwnBoxCoinAmount > 0 and math.floor(OwnBoxCoinAmount / CoinPerBox) or 0
  local TodayCanOpenBoxCount = BoxCount > AccessoryDrop.CurDropBoxNum and AccessoryDrop.CurDropBoxNum or BoxCount
  local RedDotName = DataMgr.EventMain[CurEventId].ReddotNode
  if TodayCanOpenBoxCount > 0 then
    ReddotManager.IncreaseLeafNodeCount(RedDotName, 1, {CacheKey = "Red", EventId = CurEventId})
  else
    ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {CacheKey = "Red", EventId = CurEventId})
  end
end

function Component:_OnLoginSuccess()
end

function Component:_OnPropChangeAccessoryDrops(keys)
  if CommonUtils.Size(keys) > 0 then
    local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
    local EventIds = ActivityCommon.AccessoryDropActivityIds
    for _, EventId in pairs(EventIds) do
      if keys[1] == EventId then
        self:CheckReddot()
        break
      end
    end
  end
end

function Component:_OnPropChangeResources(keys)
  if CommonUtils.Size(keys) > 0 then
    local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
    local Resources = ActivityCommon.AccessoryDropResources
    for _, ResourceId in pairs(Resources) do
      if keys[1] == ResourceId then
        self:CheckReddot()
        break
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
