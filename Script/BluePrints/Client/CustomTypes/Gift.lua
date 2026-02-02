local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local TimeUtils = require("Utils.TimeUtils")
local GiftOrder = Class("GiftOrder", CustomTypes.CustomAttr)
GiftOrder.__Props__ = {
  OrderId = prop.prop("Str", "client save", ""),
  Uid = prop.prop("Int", "client save", 0),
  GoodsId = prop.prop("Str", "client save", 0),
  PaySucc = prop.prop("Bool", "client save", false),
  Sent = prop.prop("Bool", "client save", false),
  Content = prop.prop("Str", "client save", ""),
  NeedGiftQuota = prop.prop("Int", "client save", 0)
}
FormatProperties(GiftOrder)
local GiftOrderDict = Class("GiftOrderDict", CustomTypes.CustomDict)
GiftOrderDict.KeyType = BaseTypes.Str
GiftOrderDict.ValueType = GiftOrder

function GiftOrderDict:FindOrAdd(OrderId)
  if not self[OrderId] then
    self[OrderId] = GiftOrder()
    self[OrderId].OrderId = OrderId
  end
  return self[OrderId]
end

local GiftRecord = Class("GiftRecord", CustomTypes.CustomAttr)
GiftRecord.__Props__ = {
  Uid = prop.prop("Int", "client save"),
  Time = prop.prop("Int", "client save"),
  GoodsId = prop.prop("Str", "client save"),
  ShopItemId = prop.prop("Int", "client save"),
  Count = prop.prop("Int", "client save"),
  Content = prop.prop("Str", "client save"),
  MailUniqueId = prop.prop("Int", "client save"),
  RewardGot = prop.prop("Int", "client save"),
  SaLogId = prop.prop("Int", "client save")
}
FormatProperties(GiftRecord)
local GiftRecordList = Class("GiftRecordList", CustomTypes.CustomList)
GiftRecordList.ValueType = GiftRecord

function GiftRecordList.NewRecord()
  return GiftRecord()
end

return {
  GiftOrder = GiftOrder,
  GiftOrderDict = GiftOrderDict,
  GiftRecord = GiftRecord,
  GiftRecordList = GiftRecordList
}
