local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local LimitedResource = Class("LimitedResource", CustomTypes.CustomAttr)
LimitedResource.__Props__ = {
  Type = prop.prop("Str", "client save"),
  LimitedResourceId = prop.prop("Int", "client save"),
  LimitedTimeId = prop.prop("Int", "client save"),
  CreateTime = prop.prop("Int", "client save"),
  IsSendTwoMail = prop.prop("Bool", "client save"),
  IsSendOneMail = prop.prop("Bool", "client save"),
  EndTime = prop.getter("LimitedResourceData", "EndTime"),
  MailRemindId = prop.getter("LimitedResourceData", "MailRemindId"),
  TransResourceId = prop.getter("LimitedResourceData", "TransResourceId"),
  TransType = prop.getter("LimitedResourceData", "TransType"),
  TransCount = prop.getter("LimitedResourceData", "TransCount")
}

function LimitedResource:Init(Type, LimitedResourceId, LimitedTimeId)
  self.Type = Type
  self.LimitedResourceId = LimitedResourceId
  self.LimitedTimeId = LimitedTimeId
  self.CreateTime = TimeUtils.NowTime()
end

function LimitedResource:GetSendTwoMail()
  return self.IsSendTwoMail
end

function LimitedResource:GetSendOneMail()
  return self.IsSendOneMail
end

function LimitedResource:SetSendOneMail()
  self.IsSendOneMail = true
end

function LimitedResource:SetSendTwoMail()
  self.IsSendTwoMail = true
end

function LimitedResource:Data()
  return DataMgr.LimitedTimeResource[self.Type][self.LimitedResourceId]
end

function LimitedResource:LimitedResourceData()
  local LimitedResourceData = self:Data()
  return LimitedResourceData[self.LimitedTimeId]
end

FormatProperties(LimitedResource)
local LimitedResourceDict = Class("LimitedResourceDict", CustomTypes.CustomDict)
LimitedResourceDict.KeyType = BaseTypes.Int
LimitedResourceDict.ValueType = LimitedResource

function LimitedResourceDict:GetNewLimitedResource(Type, LimitedResourceId, EndTimeIndex)
  if not self[LimitedResourceId] then
    self[LimitedResourceId] = self:NewLimitedResource(Type, LimitedResourceId, EndTimeIndex)
  end
  return self[LimitedResourceId]
end

function LimitedResourceDict:GetLimitedResource(LimitedResourceId)
  return self[LimitedResourceId]
end

function LimitedResourceDict:NewLimitedResource(Type, LimitedResourceId, EndTimeIndex)
  return LimitedResource(Type, LimitedResourceId, EndTimeIndex)
end

local LimitedItemDict = Class("LimitedItemDict", CustomTypes.CustomDict)
LimitedItemDict.KeyType = BaseTypes.Str
LimitedItemDict.ValueType = LimitedResourceDict

function LimitedItemDict:_SetCollectionValueOwnerInfo(Type, TypeItems)
  CustomTypes.CustomDict.SetOwnerInfo(TypeItems, self, Type)
end

function LimitedItemDict:_OnPropChange()
  self:_OnCollectionChange()
end

function LimitedItemDict:_OnPropSet()
  self:_OnCollectionChange()
end

function LimitedItemDict:_OnPropDictChange()
  self:_OnCollectionChange()
end

function LimitedItemDict:_OnAttrPropChange()
  self:_OnCollectionChange()
end

function LimitedItemDict:NewLimitedResourceDict()
  return LimitedResourceDict()
end

function LimitedItemDict:GetNewLimitedItem(Type, LimitedResourceId, EndTimeIndex)
  local TypeItems = self[Type]
  TypeItems = TypeItems or self:NewLimitedResourceDict()
  local LimitedItem = TypeItems:GetNewLimitedResource(Type, LimitedResourceId, EndTimeIndex)
  self:AddValue(Type, TypeItems)
  return LimitedItem
end

function LimitedItemDict:GetLimitedItem(Type, LimitedResourceId)
  local TypeItems = self[Type]
  if not TypeItems then
    return
  end
  return TypeItems:GetLimitedResource(LimitedResourceId)
end

function LimitedItemDict:RemoveLimitedItem(Type, LimitedResourceId)
  local TypeItems = self[Type]
  if not TypeItems then
    return
  end
  TypeItems:RemoveValue(LimitedResourceId)
  if TypeItems:IsEmpty() then
    self:RemoveValue(Type)
  else
    self:AddValue(Type, TypeItems)
  end
end

return {
  LimitedResource = LimitedResource,
  LimitedResourceDict = LimitedResourceDict,
  LimitedItemDict = LimitedItemDict
}
