local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local AppearanceCollectEvent = Class("AppearanceCollectEvent", CustomTypes.CustomAttr)
AppearanceCollectEvent.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  Score = prop.prop("Int", "client save", 0),
  GotRewardId = prop.prop("IntSet", "client save", {}),
  IsUnlockReward = prop.prop("Bool", "client save", false),
  AppearanceIdList = prop.prop("IntList", "client svae", {}),
  AppearanceTypeList = prop.prop("IntList", "client save", {}),
  CompleteSubTaskList = prop.prop("Int2IntListDict", "client save", {})
}

function AppearanceCollectEvent:Init(EventId)
  self.EventId = EventId
end

function AppearanceCollectEvent:SubTaskComplete(EntranceId, Index)
  if self.CompleteSubTaskList:Get(EntranceId) == nil then
    self.CompleteSubTaskList[EntranceId] = self.CompleteSubTaskList:NewIntList()
  end
  if self.CompleteSubTaskList[EntranceId] and self.CompleteSubTaskList[EntranceId]:HasValue(Index) == false then
    self.CompleteSubTaskList[EntranceId]:Append(Index)
  end
end

function AppearanceCollectEvent:IsSubTaskComplete(EntranceId, Index)
  return self.CompleteSubTaskList[EntranceId] and self.CompleteSubTaskList[EntranceId]:HasValue(Index)
end

function AppearanceCollectEvent:IsCollected(AppearanceId, AppearanceTypeStr)
  local AppearanceCollectTypeEnum = CommonConst.AppearanceCollectTypeEnum[AppearanceTypeStr] or -1
  for i = 1, self.AppearanceIdList:Length() do
    if self.AppearanceIdList[i] == AppearanceId and self.AppearanceTypeList[i] == AppearanceCollectTypeEnum then
      return true
    end
  end
  return false
end

function AppearanceCollectEvent:RecordAppearance(AppearanceId, AppearanceTypeStr)
  if self:IsCollected(AppearanceId, AppearanceTypeStr) then
    return
  end
  local AppearanceCollectTypeEnum = CommonConst.AppearanceCollectTypeEnum[AppearanceTypeStr]
  if nil == AppearanceCollectTypeEnum then
    return
  end
  self.AppearanceIdList:Append(AppearanceId)
  self.AppearanceTypeList:Append(AppearanceCollectTypeEnum)
end

FormatProperties(AppearanceCollectEvent)
local AppearanceCollectEventDict = Class("AppearanceCollectEventDict", CustomTypes.CustomDict)
AppearanceCollectEventDict.KeyType = BaseTypes.Int
AppearanceCollectEventDict.ValueType = AppearanceCollectEvent

function AppearanceCollectEventDict:GetApperanceCollectEvent(EventId)
  if nil == self[EventId] then
    self[EventId] = AppearanceCollectEvent(EventId)
  end
  return self[EventId]
end

function AppearanceCollectEventDict:SetApperanceCollect(EventId, AppearanceCollectEventData)
  self[EventId] = AppearanceCollectEventData
end

function AppearanceCollectEventDict:SkinCollectScoreInfo(EventId)
  local CurrentScore = 0
  local MaxScore = 0
  local collectData = self:GetApperanceCollectEvent(EventId)
  if collectData then
    CurrentScore = collectData.Score
  end
  local RewardConfigData = DataMgr.AppearanceCollectReward[EventId]
  if RewardConfigData then
    MaxScore = RewardConfigData.MaxRewardPoint
  end
  return CurrentScore, MaxScore
end

function AppearanceCollectEventDict:IsSkinCollectAppearance(EventId, TypeId)
  for Index, EventData in pairs(DataMgr.AppearanceCollectEvent) do
    if EventData.EventId == EventId then
      local AppId = EventData.AppId
      for AppIdIndex, AppIdTYpeId in pairs(AppId) do
        for ListIndex, ListTYpeId in pairs(AppIdTYpeId) do
          if ListTYpeId == TypeId then
            return true
          end
        end
      end
    end
  end
  return false
end

return {AppearanceCollectEvent = AppearanceCollectEvent, AppearanceCollectEventDict = AppearanceCollectEventDict}
