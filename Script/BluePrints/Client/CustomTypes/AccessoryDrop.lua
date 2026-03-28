local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local AccessoryDrop = Class("AccessoryDrop", CustomTypes.CustomAttr)
AccessoryDrop.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  CurDropBoxNum = prop.prop("Int", "client save"),
  LastAccessoryDropRefresh = prop.prop("Int", "client save"),
  BoxRewardRecord = prop.prop("Int2IntDict", "client save"),
  RewardId = prop.getter("Data", "RewardId"),
  RewardCount = prop.getter("Data", "RewardCount"),
  BoxPerDay = prop.getter("Data", "BoxPerDay")
}

function AccessoryDrop:Data()
  return DataMgr.BoxDrop[self.EventId]
end

function AccessoryDrop:Init(EventId)
  self.EventId = EventId
end

function AccessoryDrop:AddDropBoxNum(Num)
  self.CurDropBoxNum = self.CurDropBoxNum + Num
  self.LastAccessoryDropRefresh = TimeUtils.NowTime()
end

function AccessoryDrop:InitDropBoxNum()
  self.CurDropBoxNum = self.BoxPerDay
  self.LastAccessoryDropRefresh = TimeUtils.NowTime()
end

function AccessoryDrop:DelDropBoxNum(Num)
  self.CurDropBoxNum = self.CurDropBoxNum - Num
end

function AccessoryDrop:GetBoxRewardId()
  for idx, r_id in ipairs(self.RewardId) do
    local NumLimit = self.RewardCount[idx]
    if NumLimit then
      local RewardedNum = self.BoxRewardRecord[idx] or 0
      if NumLimit > RewardedNum then
        return r_id, idx
      end
    else
      return r_id, idx
    end
  end
end

function AccessoryDrop:SetRewardRecord(RewardIdx)
  self.BoxRewardRecord[RewardIdx] = (self.BoxRewardRecord[RewardIdx] or 0) + 1
end

FormatProperties(AccessoryDrop)
local AccessoryDropDict = Class("AccessoryDropDict", CustomTypes.CustomDict)
AccessoryDropDict.KeyType = BaseTypes.Int
AccessoryDropDict.ValueType = AccessoryDrop

function AccessoryDropDict:GetNewAccessoryDrop(EventId)
  if not self[EventId] then
    self[EventId] = self:NewAccessoryDrop(EventId)
  end
  return self[EventId]
end

function AccessoryDropDict:GetAccessoryDrop(EventId)
  return self[EventId]
end

function AccessoryDropDict:NewAccessoryDrop(EventId)
  return AccessoryDrop(EventId)
end

return {AccessoryDrop = AccessoryDrop, AccessoryDropDict = AccessoryDropDict}
