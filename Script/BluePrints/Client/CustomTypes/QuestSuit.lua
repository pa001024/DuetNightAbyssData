local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local QuestUtils = require("Utils.QuestUtils")
local Suit = require("BluePrints.Client.CustomTypes.Suit")
local QuestChainSuit = Class("QuestChainSuit", CustomTypes.CustomAttr)
QuestChainSuit.__Props__ = {
  BGM = prop.prop("Suit.BGMDict", "client save"),
  BGMParams = prop.prop("StrList", "client save")
}

function QuestChainSuit:HandleBGMParams(SuitKey, Values)
  self.BGMParams:Clear()
  if Values then
    for _, Value in ipairs(Values) do
      self.BGMParams:Append(Value)
    end
  end
end

function QuestChainSuit:HandleBGM(SuitKey, Value)
  if nil ~= Value then
    local NewBgm = self.BGM:GetNewBGM(SuitKey)
    NewBgm.BgmPath = Value[1]
    NewBgm.BgmParam = Value[2]
    NewBgm.BgmParamValue = Value[3]
    NewBgm.BgmSubRegionId = Value[4]
  else
    self.BGM:RemoveValue(SuitKey)
  end
end

function QuestChainSuit:GetBGMSuitBase()
  return self.BGM
end

function QuestChainSuit:GetBGMParamsSuitBase()
  return self.BGMParams
end

function QuestChainSuit:UpdateSuitBase(SuitSubType, SuitKey, Value)
  local HandleSuitSubTypeFunName = "Handle" .. SuitSubType
  if not self[HandleSuitSubTypeFunName] then
    return false
  end
  self[HandleSuitSubTypeFunName](self, SuitKey, Value)
  return true
end

FormatProperties(QuestChainSuit)
return {QuestChainSuit = QuestChainSuit}
