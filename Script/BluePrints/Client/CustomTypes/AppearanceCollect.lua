local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local TimeUtils
if GWorld:IsSkynetServer() then
  TimeUtils = require("src.utils.TimeUtils")
else
  TimeUtils = require("Utils.TimeUtils")
end
local AppearanceCollectItem = Class("AppearanceCollectItem", CustomTypes.CustomAttr)
AppearanceCollectItem.__Props__ = {
  DyeScoreRecord = prop.prop("Int2IntDict", "client save", {}),
  UpgradeSkinLevelRecord = prop.prop("Int", "client save")
}
FormatProperties(AppearanceCollectItem)
local AppearanceCollectItemDict = Class("AppearanceCollectItemDict", CustomTypes.CustomDict)
AppearanceCollectItemDict.KeyType = BaseTypes.Str
AppearanceCollectItemDict.ValueType = AppearanceCollectItem
local AppearanceCollect = Class("AppearanceCollect", CustomTypes.CustomAttr)
AppearanceCollect.__Props__ = {
  EntranceId = prop.prop("Int", "client save"),
  CollectTypeName = prop.prop("Str", "client save", ""),
  AppearanceCollectList = prop.prop("AppearanceCollectItemDict", "client save"),
  AppearanceCollectRewardGot = prop.prop("Int2IntDict", "client save")
}

function AppearanceCollect:Init(EntranceId)
  if not EntranceId or not DataMgr.AppearanceCollect[EntranceId] then
    return
  end
  self.EntranceId = EntranceId
  self.CollectTypeName = DataMgr.AppearanceCollect[EntranceId].Type
end

function AppearanceCollect:GetAppearanceCollectKey(TypeName, TargetId)
  if not TypeName or not TargetId then
    return nil
  end
  return tostring(TypeName) .. "#" .. tostring(TargetId)
end

function AppearanceCollect:UpdateAppearanceCollectList(TypeName, TargetId)
  local AppearanceCollectKey = self:GetAppearanceCollectKey(TypeName, TargetId)
  if not AppearanceCollectKey then
    return
  end
  if not self.AppearanceCollectList[AppearanceCollectKey] then
    self.AppearanceCollectList[AppearanceCollectKey] = AppearanceCollectItem()
  end
end

function AppearanceCollect:GetAppearanceCollectItem(TypeName, TargetId)
  local AppearanceCollectKey = self:GetAppearanceCollectKey(TypeName, TargetId)
  if not AppearanceCollectKey then
    return nil
  end
  return self.AppearanceCollectList[AppearanceCollectKey]
end

function AppearanceCollect:UpdateAppearanceCollectDyeScore(TypeName, TargetId, DyeGroupId, AddScore, MaxDyeScore)
  if not (TypeName and TargetId and DyeGroupId and AddScore) or not MaxDyeScore then
    return 0
  end
  local AppearanceCollectItemInfo = self:GetAppearanceCollectItem(TypeName, TargetId)
  if not AppearanceCollectItemInfo then
    return 0
  end
  local CurrentScore = AppearanceCollectItemInfo.DyeScoreRecord[DyeGroupId] or 0
  local NewScore = math.min(CurrentScore + AddScore, MaxDyeScore)
  local AddedScore = NewScore - CurrentScore
  if CurrentScore < NewScore then
    AppearanceCollectItemInfo.DyeScoreRecord[DyeGroupId] = NewScore
  end
  return AddedScore > 0 and AddedScore or 0
end

function AppearanceCollect:UpdateAppearanceCollectSkinLevel(TypeName, TargetId, UpgradeSkinLevel)
  if not (TypeName and TargetId) or not UpgradeSkinLevel then
    return nil
  end
  local AppearanceCollectItemInfo = self:GetAppearanceCollectItem(TypeName, TargetId)
  if not AppearanceCollectItemInfo then
    return nil
  end
  local OldUpgradeSkinLevel = AppearanceCollectItemInfo.UpgradeSkinLevelRecord or 0
  if UpgradeSkinLevel > OldUpgradeSkinLevel then
    AppearanceCollectItemInfo.UpgradeSkinLevelRecord = UpgradeSkinLevel
    return {OldUpgradeSkinLevel = OldUpgradeSkinLevel, NewUpgradeSkinLevel = UpgradeSkinLevel}
  end
  return nil
end

function AppearanceCollect:GetAppearanceCollectCount()
  local Count = 0
  for key, _ in pairs(self.AppearanceCollectList) do
    local Id = tonumber(string.match(key, "%d+"))
    local Type = string.match(key, "^(.-)#")
    local Data = DataMgr[Type][Id]
    if Data and not Data.ExcludeCollect then
      Count = Count + 1
    end
  end
  return Count
end

function AppearanceCollect:AddAppearanceCollectRewardGot(targetGear)
  if self.AppearanceCollectRewardGot[targetGear] then
    return
  end
  self.AppearanceCollectRewardGot[targetGear] = TimeUtils.NowTime()
end

FormatProperties(AppearanceCollect)
local AppearanceCollectDict = Class("AppearanceCollectDict", CustomTypes.CustomDict)
AppearanceCollectDict.KeyType = BaseTypes.Int
AppearanceCollectDict.ValueType = AppearanceCollect

function AppearanceCollectDict:GetAppearanceCollect(EntranceId)
  if not self[EntranceId] then
    self[EntranceId] = AppearanceCollect(EntranceId)
  end
  return self[EntranceId]
end

return {
  AppearanceCollectItem = AppearanceCollectItem,
  AppearanceCollectItemDict = AppearanceCollectItemDict,
  AppearanceCollect = AppearanceCollect,
  AppearanceCollectDict = AppearanceCollectDict
}
