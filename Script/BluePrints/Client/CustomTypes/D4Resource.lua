local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local D4ResourceSlot = Class("D4ResourceSlot", CustomTypes.CustomAttr)
D4ResourceSlot.__Props__ = {
  SlotId = prop.prop("Int", "client"),
  ResourceId = prop.prop("Int", "client"),
  Count = prop.prop("Int", "client"),
  MaxStack = prop.getter("Data", "MaxStack"),
  AutoUse = prop.getter("Data", "AutoUse"),
  UseEffectType = prop.getter("Data", "UseEffectType"),
  UseParam = prop.getter("Data", "UseParam")
}

function D4ResourceSlot:Init(SlotId, ResourceId, Count)
  self.SlotId = SlotId
  self.ResourceId = ResourceId
  self.Count = Count
end

function D4ResourceSlot:Data()
  return DataMgr.D4Resource[self.ResourceId]
end

FormatProperties(D4ResourceSlot)
local D4ResourceSlotDict = Class("D4ResourceSlotDict", CustomTypes.CustomDict)
D4ResourceSlotDict.KeyType = BaseTypes.Int
D4ResourceSlotDict.ValueType = D4ResourceSlot

function D4ResourceSlotDict:NewD4ResourceSlot(SlotId, ResourceId, Count)
  return D4ResourceSlot(SlotId, ResourceId, Count)
end

function D4ResourceSlotDict:GetD4ResourceSlot(SlotId)
  return self[SlotId]
end

return {D4ResourceSlot = D4ResourceSlot, D4ResourceSlotDict = D4ResourceSlotDict}
