local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local CommonConst = require("CommonConst")
local QuestUtils = require("Utils.QuestUtils")
local Suit = require("BluePrints.Client.CustomTypes.Suit")
local CustomBGM = Class("CustomBGM", CustomTypes.CustomAttr)
CustomBGM.__Props__ = {
  BgmPath = prop.prop("Str", "client save"),
  BgmParam = prop.prop("Str", "client save"),
  BgmParamValue = prop.prop("Int", "client save"),
  BgmSubRegionId = prop.prop("IntList", "client save"),
  SoundUnitKey = prop.prop("Str", "client save"),
  QuestChainId = prop.prop("Int", "client save", CommonConst.DefaultNotExistQuestChainId)
}
FormatProperties(CustomBGM)
local CustomBGMList = Class("CustomBGMList", CustomTypes.CustomList)
CustomBGMList.ValueType = CustomBGM

function CustomBGMList:AppendCustomBGM(Value)
  if not Value then
    return
  end
  local NewCustomBGM = CustomBGM()
  NewCustomBGM.BgmPath = Value.BgmPath or Value[1]
  NewCustomBGM.BgmParam = Value.BgmParam or Value[2]
  NewCustomBGM.BgmParamValue = Value.BgmParamValue or Value[3]
  NewCustomBGM.BgmSubRegionId = Value.BgmSubRegionId or Value[4]
  NewCustomBGM.SoundUnitKey = Value.SoundUnitKey or Value[5]
  NewCustomBGM.QuestChainId = Value.QuestChainId or Value[6] or CommonConst.DefaultNotExistQuestChainId
  self:Append(NewCustomBGM)
end

local CustomBGMDict = Class("CustomBGMDict", CustomTypes.CustomDict)
CustomBGMDict.KeyType = BaseTypes.Int
CustomBGMDict.ValueType = CustomBGMList

function CustomBGMDict:GetCustomBGMList(SoundType)
  if not CommonUtils.HasValue(CommonConst.BGMSoundType, SoundType) then
    return
  end
  if not self[SoundType] then
    self[SoundType] = self:_NewCustomBGMList()
  end
  return self[SoundType]
end

function CustomBGMDict:_NewCustomBGMList()
  return CustomBGMList()
end

local QuestChainSuit = Class("QuestChainSuit", CustomTypes.CustomAttr)
QuestChainSuit.__Props__ = {
  BGM = prop.prop("Suit.BGMDict", "client save"),
  CustomBGM = prop.prop("CustomBGMDict", "client save", {}),
  BGMParams = prop.prop("StrList", "client save"),
  HideUIInScreen = prop.prop("Str2StrSetDict", "client save"),
  ContinuedGuide = prop.prop("Str2StrSetDict", "client save"),
  SwitchStoryMode = prop.prop("Str2StrSetDict", "client save")
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

function QuestChainSuit:HandleCustomBGM(SuitKey, Value)
  if nil == Value then
    self.CustomBGM:RemoveValue(SuitKey)
    return
  end
  local CustomBGMList = self.CustomBGM:GetCustomBGMList(SuitKey)
  if not CustomBGMList then
    return
  end
  CustomBGMList:Clear()
  for _, CustomBGMValue in ipairs(Value) do
    CustomBGMList:AppendCustomBGM(CustomBGMValue)
  end
end

function QuestChainSuit:HandleHideUIInScreen(Key, Value)
  self.HideUIInScreen:RemoveValue(Key)
  for UITag, _ in pairs(Value or {}) do
    self.HideUIInScreen:AddElement(Key, UITag)
  end
end

function QuestChainSuit:HandleContinuedGuide(Key, Value)
  self.ContinuedGuide:RemoveValue(Key)
  for ContinuedGuideValue, _ in pairs(Value or {}) do
    self.ContinuedGuide:AddElement(Key, ContinuedGuideValue)
  end
end

function QuestChainSuit:HandleSwitchStoryMode(Key, Value)
  self.SwitchStoryMode:RemoveValue(Key)
  for SwitchStoryModeValue, _ in pairs(Value or {}) do
    self.SwitchStoryMode:AddElement(Key, SwitchStoryModeValue)
  end
end

function QuestChainSuit:GetBGMSuitBase()
  return self.BGM
end

function QuestChainSuit:GetCustomBGMSuitBase()
  return self.CustomBGM
end

function QuestChainSuit:GetBGMParamsSuitBase()
  return self.BGMParams
end

function QuestChainSuit:GetHideUIInScreenBase()
  return self.HideUIInScreen
end

function QuestChainSuit:GetContinuedGuideBase()
  return self.ContinuedGuide
end

function QuestChainSuit:GetSwitchStoryModeBase()
  return self.SwitchStoryMode
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
return {
  CustomBGM = CustomBGM,
  CustomBGMList = CustomBGMList,
  CustomBGMDict = CustomBGMDict,
  QuestChainSuit = QuestChainSuit
}
