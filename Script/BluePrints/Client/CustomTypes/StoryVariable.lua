local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local StoryVariableOverrideLayer = Class("StoryVariableOverrideLayer", CustomTypes.CustomAttr)
StoryVariableOverrideLayer.__Props__ = {
  SourceType = prop.prop("Int", "save"),
  Value = prop.prop("Int", "save")
}

function StoryVariableOverrideLayer:Init(SourceType, Value)
  self.SourceType = SourceType
  self.Value = Value
end

function StoryVariableOverrideLayer:IsSourceType(SourceType)
  return self.SourceType == SourceType
end

function StoryVariableOverrideLayer:GetValue()
  return self.Value
end

FormatProperties(StoryVariableOverrideLayer)
local StoryVariableOverrideLayerList = Class("StoryVariableOverrideLayerList", CustomTypes.CustomList)
StoryVariableOverrideLayerList.ValueType = StoryVariableOverrideLayer

function StoryVariableOverrideLayerList:AddLayer(SourceType, Value)
  self:Append(StoryVariableOverrideLayer(SourceType, Value))
end

function StoryVariableOverrideLayerList:RemoveLayer(SourceType)
  for Index = self:Length(), 1, -1 do
    local Layer = self[Index]
    if Layer and Layer:IsSourceType(SourceType) then
      self:RemoveByIndex(Index)
      return Layer
    end
  end
end

function StoryVariableOverrideLayerList:GetTopLayer()
  return self[self:Length()]
end

local StoryVariableOverrideKeyState = Class("StoryVariableOverrideKeyState", CustomTypes.CustomAttr)
StoryVariableOverrideKeyState.__Props__ = {
  BaseValue = prop.prop("Int", "save"),
  Layers = prop.prop("StoryVariableOverrideLayerList", "save", {})
}

function StoryVariableOverrideKeyState:Init(BaseValue)
  self.BaseValue = BaseValue
end

function StoryVariableOverrideKeyState:SetBaseValue(Value)
  self.BaseValue = Value
end

function StoryVariableOverrideKeyState:GetBaseValue()
  return self.BaseValue
end

function StoryVariableOverrideKeyState:AddLayer(SourceType, Value)
  self.Layers:AddLayer(SourceType, Value)
end

function StoryVariableOverrideKeyState:RemoveLayer(SourceType)
  return self.Layers:RemoveLayer(SourceType)
end

function StoryVariableOverrideKeyState:GetTopLayer()
  return self.Layers:GetTopLayer()
end

function StoryVariableOverrideKeyState:GetCurrentValue()
  local TopLayer = self:GetTopLayer()
  if TopLayer then
    return TopLayer:GetValue()
  end
  return self.BaseValue
end

function StoryVariableOverrideKeyState:GetLayerCnt()
  return self.Layers:Length()
end

FormatProperties(StoryVariableOverrideKeyState)
local StoryVariableOverrideKeyStateDict = Class("StoryVariableOverrideKeyStateDict", CustomTypes.CustomDict)
StoryVariableOverrideKeyStateDict.KeyType = BaseTypes.Str
StoryVariableOverrideKeyStateDict.ValueType = StoryVariableOverrideKeyState

function StoryVariableOverrideKeyStateDict:GetKeyState(Key, BaseValue)
  local KeyState = self:Get(Key)
  if KeyState then
    return KeyState
  end
  return self:_NewKeyState(Key, BaseValue)
end

function StoryVariableOverrideKeyStateDict:_NewKeyState(Key, BaseValue)
  local KeyState = StoryVariableOverrideKeyState(BaseValue)
  self:AddValue(Key, KeyState)
  return KeyState
end

local StoryVariableOverrideState = Class("StoryVariableOverrideState", CustomTypes.CustomAttr)
StoryVariableOverrideState.__Props__ = {
  Version = prop.prop("Int", "save", 1),
  KeyStates = prop.prop("StoryVariableOverrideKeyStateDict", "save")
}

function StoryVariableOverrideState:AddLayer(Key, SourceType, Value)
  local KeyState = self.KeyStates:Get(Key)
  if not KeyState then
    return
  end
  KeyState:AddLayer(SourceType, Value)
  return Key
end

function StoryVariableOverrideState:SetBaseValue(Key, Value)
  local KeyState = self.KeyStates:GetKeyState(Key, Value)
  KeyState:SetBaseValue(Value)
  return Key
end

function StoryVariableOverrideState:GetBaseValue(Key)
  local KeyState = self.KeyStates:Get(Key)
  if not KeyState then
    return
  end
  return KeyState:GetBaseValue()
end

function StoryVariableOverrideState:HasLayer(Key)
  return 0 ~= self:GetLayerCnt(Key)
end

function StoryVariableOverrideState:GetLayerCnt(Key)
  local Cnt = 0
  local KeyState = self.KeyStates:Get(Key)
  if not KeyState then
    return Cnt
  end
  return KeyState:GetLayerCnt()
end

function StoryVariableOverrideState:RemoveLayerByKey(Key, SourceType)
  local KeyState = self.KeyStates:Get(Key)
  if not KeyState then
    return
  end
  local Layer = KeyState:RemoveLayer(SourceType)
  if not Layer then
    return
  end
  return Key
end

function StoryVariableOverrideState:RemoveLayer(SourceType)
  local RemoveKeys = {}
  for Key, KeyState in pairs(self.KeyStates) do
    local Layer = KeyState:RemoveLayer(SourceType)
    if Layer then
      RemoveKeys[#RemoveKeys + 1] = Key
    end
  end
  return RemoveKeys
end

function StoryVariableOverrideState:GetCurrentValue(Key)
  local KeyState = self.KeyStates:Get(Key)
  if not KeyState then
    return
  end
  return KeyState:GetCurrentValue()
end

FormatProperties(StoryVariableOverrideState)
return {
  StoryVariableOverrideLayer = StoryVariableOverrideLayer,
  StoryVariableOverrideLayerList = StoryVariableOverrideLayerList,
  StoryVariableOverrideKeyState = StoryVariableOverrideKeyState,
  StoryVariableOverrideKeyStateDict = StoryVariableOverrideKeyStateDict,
  StoryVariableOverrideState = StoryVariableOverrideState
}
