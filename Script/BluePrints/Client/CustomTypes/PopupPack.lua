local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local PopupPack = Class("PopupPack", CustomTypes.CustomAttr)
PopupPack.__Props__ = {
  PopupPackId = prop.prop("Int", "client save"),
  LastPopTimeStamp = prop.prop("Int", "client save"),
  TriggerNum = prop.prop("Int", "client save", 0)
}

function PopupPack:Init(Id)
  self.PopupPackId = Id
end

function PopupPack:PopOnce(ANSITime)
  self.LastPopTimeStamp = ANSITime
  self.TriggerNum = self.TriggerNum + 1
end

FormatProperties(PopupPack)
local PopupPackDict = Class("PopupPackDict", CustomTypes.CustomDict)
PopupPackDict.KeyType = BaseTypes.Int
PopupPackDict.ValueType = PopupPack

function PopupPackDict:GetPopupData(PopupPackId)
  return self[PopupPackId]
end

function PopupPackDict:NewPopupPack(PopupPackId)
  if nil == self[PopupPackId] then
    self[PopupPackId] = PopupPack(PopupPackId)
  end
  return self[PopupPackId]
end

return {PopupPack = PopupPack, PopupPackDict = PopupPackDict}
