local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ReddotTreeNode_AccessoryDrop = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_AccessoryDrop:_Judge(EventId)
  local PlayerAvatar = GWorld:GetAvatar()
  local AccessoryDrop = PlayerAvatar.AccessoryDrops[EventId]
  if not AccessoryDrop then
    return
  end
  local TryOutServerData = PlayerAvatar.CharTrial[EventId]
  local AccessDropConfig = DataMgr.BoxDrop[EventId]
  local BoxCoin = GWorld:GetAvatar().Resources[AccessDropConfig.BoxCoinId]
  local OwnBoxCoinAmount = BoxCoin and BoxCoin.Count or 0
  local CoinPerBox = AccessDropConfig.CoinPerBox
  local BoxCount = OwnBoxCoinAmount > 0 and math.floor(OwnBoxCoinAmount / CoinPerBox) or 0
  local TodayCanOpenBoxCount = BoxCount > AccessoryDrop.CurDropBoxNum and AccessoryDrop.CurDropBoxNum or BoxCount
  if TodayCanOpenBoxCount > 0 then
    if self.Cache.Detail.Red == nil or 0 == self.Cache.Detail.Red then
      return true
    else
      return false
    end
  elseif self.Cache.Detail.Red ~= nil and 1 == self.Cache.Detail.Red then
    return false
  else
    return true
  end
end

function ReddotTreeNode_AccessoryDrop:OnRefreshNodeData(EventId)
  ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey = "New", EventId = EventId})
end

return ReddotTreeNode_AccessoryDrop
