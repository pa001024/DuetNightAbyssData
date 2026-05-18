local M = {}
local AvatarUtils = require("BluePrints.Client.AvatarUtils")
local BUTTON_STATE_GET = 0
local BUTTON_STATE_NOT_DONE = 1
local BUTTON_STATE_GOT = 2

local function IsNonEmptyString(Value)
  return type(Value) == "string" and "" ~= Value
end

local function CloneArray(SourceList)
  local Result = {}
  for Index, Value in ipairs(SourceList) do
    Result[Index] = Value
  end
  return Result
end

local function NormalizeItemIdList(ItemIdValue)
  if type(ItemIdValue) == "table" then
    local ItemIdList = {}
    for _, ItemId in ipairs(ItemIdValue) do
      if nil ~= ItemId then
        ItemIdList[#ItemIdList + 1] = ItemId
      end
    end
    return ItemIdList
  end
  if nil == ItemIdValue then
    return {}
  end
  return {ItemIdValue}
end

local function GetDisplayItemId(ItemIdValue)
  local ItemIdList = NormalizeItemIdList(ItemIdValue)
  return ItemIdList[1], ItemIdList
end

local function GetItemConfig(ItemType, ItemId)
  if not ItemType or not ItemId then
    return nil
  end
  local ConfigTable = DataMgr[ItemType]
  if type(ConfigTable) ~= "table" then
    return nil
  end
  return ConfigTable[ItemId]
end

local function GetHairFallbackName(HairConfig)
  if type(HairConfig) ~= "table" or not HairConfig.CharId then
    return nil
  end
  local CharConfig = DataMgr.CharacterData and DataMgr.CharacterData[HairConfig.CharId]
  return CharConfig and (CharConfig.CharName or CharConfig.Name)
end

local function GetItemDisplayInfo(ItemType, ItemId)
  local ItemConfig = GetItemConfig(ItemType, ItemId)
  if not ItemConfig then
    return {
      ItemName = tostring(ItemId),
      Icon = "",
      Rarity = 1
    }
  end
  local ItemName = ItemConfig.ResourceName or ItemConfig.Name or ItemConfig.SkinName or ItemConfig.MountName or ItemConfig.HairName or ItemConfig.ItemName or GetHairFallbackName(ItemConfig) or tostring(ItemId)
  local Icon = ItemConfig.Icon or ItemConfig.ItemIcon or ItemConfig.ResourceIcon or ItemConfig.MountIcon or ItemConfig.BigIcon or ItemConfig.LongIcon or ""
  return {
    ItemName = ItemName,
    Icon = Icon,
    Rarity = ItemConfig.Rarity or ItemConfig.Quality or ItemConfig.MountRarity or 1
  }
end

local function NormalizeSubTaskScoreValue(ScoreValue)
  if type(ScoreValue) == "table" then
    ScoreValue = ScoreValue.ScoreValue or ScoreValue.Points or ScoreValue.RewardPoints
  end
  ScoreValue = tonumber(ScoreValue)
  if not ScoreValue then
    return nil
  end
  return math.max(0, ScoreValue)
end

local function GetAvatar()
  if not GWorld or not GWorld.GetAvatar then
    return nil
  end
  return GWorld:GetAvatar()
end

local function GetAppearanceCollectEventData(EventId)
  local RealEventId = tonumber(EventId)
  if not RealEventId then
    return nil
  end
  local Avatar = GetAvatar()
  local AppearanceCollectEventDict = Avatar and Avatar.AppearanceCollectEvent
  if not AppearanceCollectEventDict or not AppearanceCollectEventDict.GetApperanceCollectEvent then
    return nil
  end
  return AppearanceCollectEventDict:GetApperanceCollectEvent(RealEventId)
end

local function IsSameId(IdA, IdB)
  return IdA == IdB or tostring(IdA) == tostring(IdB)
end

local function IsValueInDict(Dict, Key)
  if not Dict or nil == Key then
    return false
  end
  if nil ~= Dict[Key] or nil ~= Dict[tostring(Key)] then
    return true
  end
  if Dict.HasValue and Dict:HasValue(Key) then
    return true
  end
  if Dict.Length then
    for Index = 1, Dict:Length() do
      if IsSameId(Dict[Index], Key) then
        return true
      end
    end
  end
  if Dict.ToTable then
    local TableList = Dict:ToTable()
    for MapKey, Value in pairs(TableList or {}) do
      if IsSameId(MapKey, Key) or IsSameId(Value, Key) then
        return true
      end
    end
  end
  if type(Dict) == "table" then
    for MapKey, Value in pairs(Dict) do
      if IsSameId(MapKey, Key) or IsSameId(Value, Key) then
        return true
      end
    end
  end
  return false
end

local function IsCommonCharOwnsItem(CommonChar, ItemType, ItemId)
  if not CommonChar or not ItemId then
    return false
  end
  if ItemType == CommonConst.AppearanceCollectType.Skin then
    return IsValueInDict(CommonChar.OwnedSkins, ItemId)
  elseif ItemType == CommonConst.AppearanceCollectType.Hair then
    return IsValueInDict(CommonChar.OwnedHairs, ItemId)
  end
  return false
end

local function IsAvatarArchiveCollectsAppearance(Avatar, ItemType, ItemId)
  if not (Avatar and ItemType and ItemId) or not Avatar.AppearanceCollects then
    return false
  end
  if not Avatar.CheckAppearanceCollectType then
    return false
  end
  local EntranceInfo = Avatar:CheckAppearanceCollectType(ItemId, ItemType)
  local AppearanceCollect = EntranceInfo and EntranceInfo.EntranceId and Avatar.AppearanceCollects[EntranceInfo.EntranceId]
  if not AppearanceCollect or not AppearanceCollect.GetAppearanceCollectItem then
    return false
  end
  return AppearanceCollect:GetAppearanceCollectItem(ItemType, ItemId) ~= nil
end

local function IsAvatarOwnsAppearance(ItemType, ItemId)
  if not ItemType or not ItemId then
    return false
  end
  local Avatar = GetAvatar()
  if not Avatar then
    return false
  end
  if AvatarUtils and AvatarUtils.GetTargetDataStatistics then
    local DataStatisticsCount = AvatarUtils:GetTargetDataStatistics(Avatar, ItemType, ItemId) or 0
    if type(DataStatisticsCount) == "number" and DataStatisticsCount > 0 then
      return true
    end
  end
  if IsAvatarArchiveCollectsAppearance(Avatar, ItemType, ItemId) then
    return true
  end
  local bOwns = false
  if ItemType == CommonConst.AppearanceCollectType.WeaponSkin then
    bOwns = IsValueInDict(Avatar.OwnedWeaponSkins, ItemId)
  elseif ItemType == CommonConst.AppearanceCollectType.WeaponAccessory then
    bOwns = IsValueInDict(Avatar.WeaponAccessorys, ItemId)
  elseif ItemType == CommonConst.AppearanceCollectType.CharAccessory then
    bOwns = IsValueInDict(Avatar.CharAccessorys, ItemId)
  elseif ItemType == CommonConst.AppearanceCollectType.Mount then
    bOwns = IsValueInDict(Avatar.OwnedMountSkins, ItemId)
  elseif ItemType == CommonConst.AppearanceCollectType.Skin or ItemType == CommonConst.AppearanceCollectType.Hair then
    for _, CommonChar in pairs(Avatar.CommonChars or {}) do
      if IsCommonCharOwnsItem(CommonChar, ItemType, ItemId) then
        bOwns = true
        break
      end
    end
  elseif ItemType == CommonConst.AppearanceCollectType.Resource and Avatar.GetResourceCount then
    bOwns = (Avatar:GetResourceCount(ItemId) or 0) > 0
  end
  return bOwns
end

local function ResolveOwnedAppearanceId(ItemType, ItemIdList)
  if not ItemType or type(ItemIdList) ~= "table" or 0 == #ItemIdList then
    return nil
  end
  for _, ItemId in ipairs(ItemIdList) do
    if IsAvatarOwnsAppearance(ItemType, ItemId) then
      return ItemId
    end
  end
  return nil
end

local function GetEventTokenIcon(EventId)
  local RealEventId = tonumber(EventId)
  local RewardConfigData = RealEventId and DataMgr.AppearanceCollectReward and DataMgr.AppearanceCollectReward[RealEventId]
  return RewardConfigData and RewardConfigData.TokenIcon
end

local function ResolveCollectedAppearanceId(EventId, ItemType, ItemIdList)
  if not ItemType or type(ItemIdList) ~= "table" or 0 == #ItemIdList then
    return nil
  end
  local AppearanceCollectEventData = GetAppearanceCollectEventData(EventId)
  if not AppearanceCollectEventData or not AppearanceCollectEventData.IsCollected then
    return nil
  end
  for _, ItemId in ipairs(ItemIdList) do
    if nil ~= ItemId and AppearanceCollectEventData:IsCollected(ItemId, ItemType) then
      return ItemId
    end
  end
  return nil
end

local function IsSubTaskCompleteFromServer(EntranceId, EventId, SubTaskIndex, SubTaskId)
  if nil == EntranceId or nil == SubTaskIndex and nil == SubTaskId then
    return false
  end
  local AppearanceCollectEventData = GetAppearanceCollectEventData(EventId)
  if not AppearanceCollectEventData or not AppearanceCollectEventData.IsSubTaskComplete then
    return false
  end
  if nil ~= SubTaskIndex and AppearanceCollectEventData:IsSubTaskComplete(EntranceId, SubTaskIndex) == true then
    return true
  end
  if nil ~= SubTaskId and SubTaskId ~= SubTaskIndex then
    return AppearanceCollectEventData:IsSubTaskComplete(EntranceId, SubTaskId) == true
  end
  return false
end

function M.GetSubTaskFinishStateFromServer(EntranceId, EventId, SubTaskIndex, SubTaskId, ItemType, ItemIdList)
  local bSubTaskComplete = IsSubTaskCompleteFromServer(EntranceId, EventId, SubTaskIndex, SubTaskId)
  if bSubTaskComplete then
    return true
  end
  local CollectedAppearanceId = ResolveCollectedAppearanceId(EventId, ItemType, ItemIdList)
  local OwnedAppearanceId = CollectedAppearanceId or ResolveOwnedAppearanceId(ItemType, ItemIdList)
  return nil ~= OwnedAppearanceId
end

function M.GetSubTaskScoreFromServer(EntranceId, EventId, ItemType, ItemIdList)
  local Avatar = GetAvatar()
  if not Avatar or not Avatar.GetAppearanceCollectEvent_ApperanceScore then
    return 0
  end
  local ScoreAppearanceId = ResolveCollectedAppearanceId(EventId, ItemType, ItemIdList) or ResolveOwnedAppearanceId(ItemType, ItemIdList) or type(ItemIdList) == "table" and ItemIdList[1] or nil
  if not ScoreAppearanceId or not ItemType then
    return 0
  end
  return NormalizeSubTaskScoreValue(Avatar:GetAppearanceCollectEvent_ApperanceScore(EntranceId, ItemType, ScoreAppearanceId)) or 0
end

function M.GetTaskIdListByEventId(EventId)
  local RealEventId = tonumber(EventId)
  if not RealEventId then
    return nil
  end
  local EventTaskIdList = DataMgr.EventId2AppearanceCollectEntranceId and DataMgr.EventId2AppearanceCollectEntranceId[RealEventId]
  if type(EventTaskIdList) == "table" and #EventTaskIdList > 0 then
    return CloneArray(EventTaskIdList)
  end
  local TaskIdList = {}
  if "table" ~= type(DataMgr.AppearanceCollectEvent) then
    return TaskIdList
  end
  for TaskId, TaskConfig in pairs(DataMgr.AppearanceCollectEvent) do
    if type(TaskId) == "number" and TaskConfig and TaskConfig.EventId == RealEventId then
      TaskIdList[#TaskIdList + 1] = TaskId
    end
  end
  table.sort(TaskIdList)
  return TaskIdList
end

local function GetSubTaskButtonState(SubTaskConfig)
  if M.GetSubTaskFinishStateFromServer(SubTaskConfig.EntranceId, SubTaskConfig.EventId, SubTaskConfig.SubTaskIndex, SubTaskConfig.SubTaskId, SubTaskConfig.ItemType, SubTaskConfig.ItemIdList) then
    return BUTTON_STATE_GOT
  end
  if IsNonEmptyString(SubTaskConfig.JumpLink) then
    return BUTTON_STATE_GET
  end
  return BUTTON_STATE_NOT_DONE
end

local function BuildSubTaskInfo(SubTaskConfig)
  local ItemId = SubTaskConfig.ItemId
  local ItemType = SubTaskConfig.ItemType
  local DisplayInfo = GetItemDisplayInfo(ItemType, ItemId)
  local ButtonState = GetSubTaskButtonState(SubTaskConfig)
  local RewardPoints = SubTaskConfig.RewardPoints or 0
  return {
    Id = SubTaskConfig.SubTaskId,
    ItemId = ItemId,
    ItemIdList = SubTaskConfig.ItemIdList,
    ItemType = ItemType,
    ItemName = DisplayInfo.ItemName,
    Icon = DisplayInfo.Icon,
    Rarity = DisplayInfo.Rarity,
    IsShowDetails = true,
    ScoreValue = RewardPoints,
    ScoreIcon = SubTaskConfig.ScoreIcon,
    ButtonState = ButtonState,
    CanJump = ButtonState == BUTTON_STATE_GET,
    IsGot = ButtonState == BUTTON_STATE_GOT,
    JumpLink = SubTaskConfig.JumpLink,
    GetText = "UI_AppearanceCollect_GoToObtain",
    NotDoneText = "UI_AppearanceCollect_StatusPending",
    GotText = "UI_AppearanceCollect_StatusObtained"
  }
end

local function IsSubTaskCompleted(SubTaskInfo)
  return SubTaskInfo and (SubTaskInfo.ButtonState == BUTTON_STATE_GOT or SubTaskInfo.IsGot == true)
end

local function IsTaskTypeCompleted(TaskTypeInfo)
  local SubTaskList = TaskTypeInfo and TaskTypeInfo.SubTaskList
  if type(SubTaskList) ~= "table" or 0 == #SubTaskList then
    return false
  end
  for _, SubTaskInfo in ipairs(SubTaskList) do
    if not IsSubTaskCompleted(SubTaskInfo) then
      return false
    end
  end
  return true
end

local function GetSubTaskSortId(SubTaskInfo)
  local SortId = SubTaskInfo and (SubTaskInfo.Id or SubTaskInfo.SubTaskId or SubTaskInfo.ItemId)
  SortId = tonumber(SortId)
  if nil == SortId then
    return math.huge
  end
  return SortId
end

local function SortSubTaskList(SubTaskList)
  if type(SubTaskList) ~= "table" or #SubTaskList <= 1 then
    return SubTaskList
  end
  local OriginalIndexMap = {}
  for Index, SubTaskInfo in ipairs(SubTaskList) do
    OriginalIndexMap[SubTaskInfo] = Index
  end
  table.sort(SubTaskList, function(SubTaskInfoA, SubTaskInfoB)
    local IsCompletedA = IsSubTaskCompleted(SubTaskInfoA)
    local IsCompletedB = IsSubTaskCompleted(SubTaskInfoB)
    if IsCompletedA ~= IsCompletedB then
      return not IsCompletedA
    end
    local SortIdA = GetSubTaskSortId(SubTaskInfoA)
    local SortIdB = GetSubTaskSortId(SubTaskInfoB)
    if SortIdA ~= SortIdB then
      return SortIdA < SortIdB
    end
    return (OriginalIndexMap[SubTaskInfoA] or 0) < (OriginalIndexMap[SubTaskInfoB] or 0)
  end)
  return SubTaskList
end

local function GetTaskTypeSortId(TaskTypeInfo)
  local SortId = TaskTypeInfo and (TaskTypeInfo.Id or TaskTypeInfo.TaskId or TaskTypeInfo.EntranceId)
  SortId = tonumber(SortId)
  if nil == SortId then
    return math.huge
  end
  return SortId
end

local function SortTaskTypeList(TaskTypeList)
  if type(TaskTypeList) ~= "table" or #TaskTypeList <= 1 then
    return TaskTypeList
  end
  table.sort(TaskTypeList, function(TaskTypeInfoA, TaskTypeInfoB)
    local IsCompletedA = IsTaskTypeCompleted(TaskTypeInfoA)
    local IsCompletedB = IsTaskTypeCompleted(TaskTypeInfoB)
    if IsCompletedA ~= IsCompletedB then
      return not IsCompletedA
    end
    local SortIdA = GetTaskTypeSortId(TaskTypeInfoA)
    local SortIdB = GetTaskTypeSortId(TaskTypeInfoB)
    if SortIdA ~= SortIdB then
      return SortIdA < SortIdB
    end
    return false
  end)
  return TaskTypeList
end

local function IsTaskHighlighted(TaskConfig)
  return TaskConfig.Highlight == true or 1 == TaskConfig.Highlight or true == TaskConfig.IsHighlight or 1 == TaskConfig.IsHighlight
end

local function BuildSubTaskConfig(TaskConfig, SubTaskOrder)
  local ItemType = TaskConfig.AppTarget and TaskConfig.AppTarget[SubTaskOrder]
  local DisplayItemId, ItemIdList = GetDisplayItemId(TaskConfig.AppId and TaskConfig.AppId[SubTaskOrder])
  if not ItemType and nil == DisplayItemId then
    return nil
  end
  local SubTaskId = (TaskConfig.EntranceId or 0) * 100 + SubTaskOrder
  return {
    SubTaskId = SubTaskId,
    SubTaskIndex = SubTaskOrder,
    EntranceId = TaskConfig.EntranceId,
    EventId = TaskConfig.EventId,
    ItemId = DisplayItemId,
    ItemIdList = ItemIdList,
    ItemType = ItemType,
    JumpLink = TaskConfig.JumpLink and TaskConfig.JumpLink[SubTaskOrder],
    RewardPoints = M.GetSubTaskScoreFromServer(TaskConfig.EntranceId, TaskConfig.EventId, ItemType, ItemIdList),
    ScoreIcon = GetEventTokenIcon(TaskConfig.EventId)
  }
end

local function BuildTaskTypeInfo(TaskConfig)
  local TaskTypeInfo = {
    Id = TaskConfig.EntranceId,
    Title = TaskConfig.TaskName or "",
    IconPath = TaskConfig.IconPath or "",
    ScoreIcon = GetEventTokenIcon(TaskConfig.EventId),
    Highlight = IsTaskHighlighted(TaskConfig),
    CurrentScore = 0,
    TotalScore = 0,
    SubTaskList = {}
  }
  local SubTaskCount = math.max(#(TaskConfig.AppTarget or {}), #(TaskConfig.AppId or {}))
  for SubTaskOrder = 1, SubTaskCount do
    local SubTaskConfig = BuildSubTaskConfig(TaskConfig, SubTaskOrder)
    if SubTaskConfig then
      local SubTaskInfo = BuildSubTaskInfo(SubTaskConfig)
      TaskTypeInfo.SubTaskList[#TaskTypeInfo.SubTaskList + 1] = SubTaskInfo
      TaskTypeInfo.TotalScore = TaskTypeInfo.TotalScore + (SubTaskInfo.ScoreValue or 0)
      if SubTaskInfo.ButtonState == BUTTON_STATE_GOT then
        TaskTypeInfo.CurrentScore = TaskTypeInfo.CurrentScore + (SubTaskInfo.ScoreValue or 0)
      end
    end
  end
  SortSubTaskList(TaskTypeInfo.SubTaskList)
  TaskTypeInfo.IsCompleted = IsTaskTypeCompleted(TaskTypeInfo)
  return TaskTypeInfo
end

function M.GetTaskTypeListByEventId(EventId)
  if type(DataMgr.AppearanceCollectEvent) ~= "table" then
    return {}
  end
  local TaskIdList = M.GetTaskIdListByEventId(EventId) or {}
  local TaskTypeList = {}
  for _, TaskId in ipairs(TaskIdList) do
    local TaskConfig = DataMgr.AppearanceCollectEvent[TaskId]
    if TaskConfig then
      TaskTypeList[#TaskTypeList + 1] = BuildTaskTypeInfo(TaskConfig)
    end
  end
  return SortTaskTypeList(TaskTypeList)
end

return M
