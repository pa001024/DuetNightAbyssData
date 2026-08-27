local M = {}
M.PointType = {
  FishingSpot = "FishingSpot",
  PhotoPoint = "PhotoPoint",
  Temple = "Temple"
}
M.JumpFailureReason = {
  NoUnlockedPoint = "NoUnlockedPoint"
}
local TARGET_TYPE_FISHING_SPOT_SUCCESS = 10525
local TARGET_TYPE_PHOTO_POINT = 21002
local TARGET_TYPE_TEMPLE = 10502
local TrackedRecurringQuestId, TrackedPointType, TrackedPointId
local TrackRequestId = 0
local bTrackActivated = false
local bTrackListenerRegistered = false
local PhotoManualItemToRegionPoint
local LOG_PREFIX = "[FameTaskIndex]"

local function BoolText(Value)
  return Value and "true" or "false"
end

local function ListText(Values)
  if type(Values) ~= "table" then
    return tostring(Values)
  end
  local Result = {}
  for _, Value in ipairs(Values) do
    table.insert(Result, tostring(Value))
  end
  return table.concat(Result, ",")
end

local function ClearTrackContext()
  TrackedRecurringQuestId = nil
  TrackedPointType = nil
  TrackedPointId = nil
  bTrackActivated = false
end

local function FireMapTrack(PointType, PointId)
  EventManager:FireEvent(EventID.OnCommonTrack, PointType, PointId, true)
end

local function MakeMapInitWithTrack(PointType, PointId, QuestId, RequestId)
  return function()
    if TrackRequestId ~= RequestId or TrackedPointType ~= PointType or TrackedPointId ~= PointId or TrackedRecurringQuestId ~= QuestId then
      return
    end
    local MainMap = UIManager(GWorld.GameInstance):GetUIObj("LevelMapMain")
    local WildMap = MainMap and MainMap.RealWildMap
    if WildMap then
      if PointType == CommonConst.RegionMapTrackingType.RegionPoint and WildMap.OnRegionPointClick then
        WildMap:OnRegionPointClick(PointId, true)
      elseif PointType == CommonConst.RegionMapTrackingType.TeleportPoint and WildMap.OnTeleportPointClick then
        WildMap:OnTeleportPointClick(PointId)
      end
      if WildMap.SetRecurringTaskConveyMode then
        WildMap:SetRecurringTaskConveyMode(true)
      end
    end
    bTrackActivated = true
    FireMapTrack(PointType, PointId)
  end
end

local function SetTrackContext(PointType, PointId, QuestId)
  TrackRequestId = TrackRequestId + 1
  TrackedPointType = PointType
  TrackedPointId = PointId
  TrackedRecurringQuestId = QuestId and tonumber(QuestId) or nil
  bTrackActivated = false
  return TrackRequestId
end

local function ResolveFishingSpotRegionPoint(FishingSpotId)
  FishingSpotId = tonumber(FishingSpotId)
  if not FishingSpotId then
    GWorld.logger.info(LOG_PREFIX, "ResolveFishingSpot failed: invalid FishingSpotId")
    return nil
  end
  local SpotData = DataMgr.FishingSpot[FishingSpotId]
  if not SpotData or not SpotData.RegionPointId then
    GWorld.logger.info(LOG_PREFIX, "ResolveFishingSpot failed: FishingSpot missing or RegionPointId empty", FishingSpotId)
    return nil
  end
  if not DataMgr.RegionPoint[SpotData.RegionPointId] then
    GWorld.logger.info(LOG_PREFIX, "ResolveFishingSpot failed: RegionPoint missing", FishingSpotId, SpotData.RegionPointId)
    return nil
  end
  GWorld.logger.info(LOG_PREFIX, "ResolveFishingSpot success", FishingSpotId, SpotData.RegionPointId)
  return SpotData.RegionPointId
end

local function EnsurePhotoManualItemMap()
  if PhotoManualItemToRegionPoint then
    return
  end
  PhotoManualItemToRegionPoint = {}
  for PhotoCameraId, PhotoCameraData in pairs(DataMgr.PhotoCamera or {}) do
    local RegionPointId = tonumber(PhotoCameraData.RegionPoint)
    local RegionPointData = RegionPointId and DataMgr.RegionPoint[RegionPointId]
    local ManualItemId = RegionPointData and tonumber(RegionPointData.ManualItemId)
    if ManualItemId then
      PhotoManualItemToRegionPoint[ManualItemId] = RegionPointId
      GWorld.logger.info(LOG_PREFIX, "CachePhotoPoint", "PhotoCameraId", PhotoCameraId, "ManualItemId", ManualItemId, "RegionPointId", RegionPointId)
    end
  end
end

local function ResolvePhotoSpotRegionPoint(PhotoManualItemId)
  PhotoManualItemId = tonumber(PhotoManualItemId)
  if not PhotoManualItemId then
    GWorld.logger.info(LOG_PREFIX, "ResolvePhotoSpot failed: invalid ManualItemId", PhotoManualItemId)
    return nil
  end
  EnsurePhotoManualItemMap()
  local RegionPointId = PhotoManualItemToRegionPoint[PhotoManualItemId]
  local RegionPointData = RegionPointId and DataMgr.RegionPoint[RegionPointId]
  GWorld.logger.info(LOG_PREFIX, "ResolvePhotoSpot", "ManualItemId", PhotoManualItemId, "RegionPointId", RegionPointId, "RegionPointFound", BoolText(nil ~= RegionPointData))
  return RegionPointData and RegionPointId or nil
end

local function IsTeleportPointUnlocked(TeleportPointId)
  local TeleportPointData = TeleportPointId and DataMgr.TeleportPoint[TeleportPointId]
  if not TeleportPointData then
    GWorld.logger.info(LOG_PREFIX, "TeleportPoint unavailable: config missing", TeleportPointId)
    return false
  end
  if Const.UnlockRegionTeleport or 1 == TeleportPointData.IsDefault then
    GWorld.logger.info(LOG_PREFIX, "TeleportPoint unlocked by override/default", TeleportPointId, "StaticId", TeleportPointData.StaticId, "IsDefault", TeleportPointData.IsDefault, "UnlockRegionTeleport", BoolText(Const.UnlockRegionTeleport))
    return true
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  local RegionDataMgr = GameMode and GameMode:GetRegionDataMgrSubSystem()
  local RegionDatas = RegionDataMgr and RegionDataMgr.DataLibrary:GetFullRegionStoreDatas()
  if not (GameMode and RegionDataMgr) or not RegionDatas then
    GWorld.logger.info(LOG_PREFIX, "TeleportPoint unavailable: runtime region data missing", TeleportPointId, "GameMode", BoolText(nil ~= GameMode), "RegionDataMgr", BoolText(nil ~= RegionDataMgr), "RegionDatas", BoolText(nil ~= RegionDatas))
  end
  for _, RegionData in pairs(RegionDatas or {}) do
    if RegionData.CreatorId == TeleportPointData.StaticId then
      local bUnlocked = nil ~= RegionData.State and RegionData.State.OpenState
      GWorld.logger.info(LOG_PREFIX, "TeleportPoint runtime state", TeleportPointId, "StaticId", TeleportPointData.StaticId, "StateFound", BoolText(nil ~= RegionData.State), "OpenState", BoolText(bUnlocked))
      return bUnlocked
    end
  end
  GWorld.logger.info(LOG_PREFIX, "TeleportPoint unavailable: StaticId not found in region store", TeleportPointId, "StaticId", TeleportPointData.StaticId)
  return false
end

local function IsRegionPointAvailable(RegionPointId)
  local RegionPointData = RegionPointId and DataMgr.RegionPoint[RegionPointId]
  local SubRegionData = RegionPointData and DataMgr.SubRegion[RegionPointData.SubRegion]
  if not SubRegionData or not SubRegionData.RegionId then
    GWorld.logger.info(LOG_PREFIX, "RegionPoint unavailable: map config incomplete", RegionPointId, "RegionPointFound", BoolText(nil ~= RegionPointData), "SubRegion", RegionPointData and RegionPointData.SubRegion, "SubRegionFound", BoolText(nil ~= SubRegionData))
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    GWorld.logger.info(LOG_PREFIX, "RegionPoint unavailable: Avatar missing", RegionPointId)
    return false
  end
  local bConditionPassed = ConditionUtils.CheckCondition(Avatar, RegionPointData.UnlockConditionId)
  if not bConditionPassed then
    GWorld.logger.info(LOG_PREFIX, "RegionPoint unavailable: unlock condition failed", RegionPointId, "UnlockConditionId", RegionPointData.UnlockConditionId, "SubRegion", RegionPointData.SubRegion, "RegionId", SubRegionData.RegionId)
    return false
  end
  local bTeleportUnlocked = not RegionPointData.TelepointId or IsTeleportPointUnlocked(RegionPointData.TelepointId)
  GWorld.logger.info(LOG_PREFIX, "RegionPoint availability", RegionPointId, "UnlockConditionId", RegionPointData.UnlockConditionId, "ConditionPassed", BoolText(bConditionPassed), "TelepointId", RegionPointData.TelepointId, "TeleportUnlocked", BoolText(bTeleportUnlocked), "Result", BoolText(bTeleportUnlocked))
  return bTeleportUnlocked
end

local function IsRegionPointConfigured(RegionPointId)
  local RegionPointData = RegionPointId and DataMgr.RegionPoint[RegionPointId]
  local SubRegionData = RegionPointData and DataMgr.SubRegion[RegionPointData.SubRegion]
  local bConfigured = nil ~= SubRegionData and nil ~= SubRegionData.RegionId
  GWorld.logger.info(LOG_PREFIX, "RegionPoint configured check", RegionPointId, "RegionPointFound", BoolText(nil ~= RegionPointData), "SubRegion", RegionPointData and RegionPointData.SubRegion, "SubRegionFound", BoolText(nil ~= SubRegionData), "RegionId", SubRegionData and SubRegionData.RegionId, "Result", BoolText(bConfigured))
  return bConfigured
end

local function ResolveTempleTeleportPoint(TempleId, bRequireUnlocked)
  TempleId = tonumber(TempleId)
  if not TempleId or not DataMgr.Temple[TempleId] then
    GWorld.logger.info(LOG_PREFIX, "ResolveTemple failed: Temple config missing", TempleId)
    return nil
  end
  if nil == bRequireUnlocked then
    bRequireUnlocked = true
  end
  for TeleportPointId, TeleportPointData in pairs(DataMgr.TeleportPoint) do
    for _, ConfigTempleId in ipairs(TeleportPointData.Temples or {}) do
      if tonumber(ConfigTempleId) == TempleId then
        local SubRegionData = DataMgr.SubRegion[TeleportPointData.TeleportPointSubRegion]
        local bUnlocked = not bRequireUnlocked or IsTeleportPointUnlocked(TeleportPointId)
        GWorld.logger.info(LOG_PREFIX, "ResolveTemple candidate", TempleId, "TeleportPointId", TeleportPointId, "SubRegion", TeleportPointData.TeleportPointSubRegion, "RegionId", SubRegionData and SubRegionData.RegionId, "RequireUnlocked", BoolText(bRequireUnlocked), "Unlocked", BoolText(bUnlocked))
        if SubRegionData and SubRegionData.RegionId and bUnlocked then
          return TeleportPointId
        end
      end
    end
  end
  GWorld.logger.info(LOG_PREFIX, "ResolveTemple failed: no valid teleport point", TempleId, "RequireUnlocked", BoolText(bRequireUnlocked))
  return nil
end

local function CheckRegionPointUnlocked(Owner, RegionPointId)
  local RegionPointData = DataMgr.RegionPoint[RegionPointId]
  if not RegionPointData then
    return false
  end
  local ConditionId = RegionPointData.UnlockConditionId
  local Avatar = GWorld:GetAvatar()
  if ConditionId and Avatar and not ConditionUtils.CheckCondition(Avatar, ConditionId) then
    UIManager(Owner):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Fishing_FishingSpotLocked"))
    return false
  end
  return true
end

function M.EnsureTrackListenerRegistered()
  if bTrackListenerRegistered then
    return
  end
  EventManager:AddEvent(EventID.OnCommonTrack, M, M._OnCommonTrack)
  bTrackListenerRegistered = true
end

function M:_OnCommonTrack(TrackingType, Id, IsAdd)
  if not bTrackActivated or not TrackedPointId then
    return
  end
  local TrackId = tonumber(Id)
  if not IsAdd and TrackingType == TrackedPointType and TrackId == TrackedPointId then
    ClearTrackContext()
  elseif IsAdd and TrackId and (TrackingType ~= TrackedPointType or TrackId ~= TrackedPointId) then
    ClearTrackContext()
  end
end

function M.IsRecurringTaskPointTracked(PointType, PointId)
  PointId = tonumber(PointId)
  local GameInstance = GWorld and GWorld.GameInstance
  local TrackingPack = GameInstance and GameInstance.TrackingPack
  return bTrackActivated and nil ~= PointId and TrackedPointType == PointType and TrackedPointId == PointId and nil ~= TrackingPack and TrackingPack[1] == PointType and TrackingPack[2] == PointId
end

function M.StopMapTrack(PointType, PointId)
  PointType = PointType or TrackedPointType
  PointId = PointId and tonumber(PointId) or TrackedPointId
  if not PointType or not PointId then
    return false
  end
  local GameInstance = GWorld and GWorld.GameInstance
  local TrackingPack = GameInstance and GameInstance.TrackingPack
  if bTrackActivated and TrackingPack and TrackingPack[1] == PointType and TrackingPack[2] == PointId then
    EventManager:FireEvent(EventID.OnCommonTrack, PointType, PointId, false)
  end
  if TrackedPointType == PointType and TrackedPointId == PointId then
    ClearTrackContext()
  end
  return true
end

function M.StopRegionPointTrack(RegionPointId)
  return M.StopMapTrack(CommonConst.RegionMapTrackingType.RegionPoint, RegionPointId)
end

function M.TryStopTrackForRecurringQuest(QuestId)
  QuestId = tonumber(QuestId)
  if not QuestId or TrackedRecurringQuestId ~= QuestId then
    return false
  end
  return M.StopMapTrack()
end

function M.CheckRecurringQuestMapTrack()
  if not TrackedRecurringQuestId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local QuestId = TrackedRecurringQuestId
  local TaskData = DataMgr.RecurringTask[QuestId]
  if not TaskData then
    M.StopMapTrack()
    return
  end
  local Reputation = Avatar.RegionReputations[TaskData.ReputationID]
  if not Reputation then
    M.StopMapTrack()
    return
  end
  local State = Reputation.RecurringQuestState[QuestId]
  if State ~= CommonConst.RecurringTaskState.Doing then
    M.StopMapTrack()
  end
end

function M.ParseTargetPointInfo(TargetData, bRequireUnlocked, TargetId)
  local Result = {bHasPoint = false}
  if not TargetData or not TargetData.TargetParam then
    GWorld.logger.info(LOG_PREFIX, "ParseTarget failed: Target or TargetParam missing", TargetId, "TargetFound", BoolText(nil ~= TargetData))
    return Result
  end
  local ParamIndex = TargetData.TargetType == TARGET_TYPE_PHOTO_POINT and 2 or 1
  local ParamList = TargetData.TargetParam[ParamIndex]
  if not ParamList or not ParamList[1] then
    GWorld.logger.info(LOG_PREFIX, "ParseTarget failed: point params empty", TargetId, "TargetType", TargetData.TargetType, "ParamIndex", ParamIndex)
    return Result
  end
  if nil == bRequireUnlocked then
    bRequireUnlocked = true
  end
  GWorld.logger.info(LOG_PREFIX, "ParseTarget begin", TargetId, "TargetType", TargetData.TargetType, "ParamIndex", ParamIndex, "Params", ListText(ParamList), "RequireUnlocked", BoolText(bRequireUnlocked))
  local ValidPointInfos = {}
  if TargetData.TargetType == TARGET_TYPE_FISHING_SPOT_SUCCESS then
    for _, PointIdValue in ipairs(ParamList) do
      local PointId = tonumber(PointIdValue)
      local RegionPointId = PointId and ResolveFishingSpotRegionPoint(PointId)
      if bRequireUnlocked and IsRegionPointAvailable(RegionPointId) or not bRequireUnlocked and IsRegionPointConfigured(RegionPointId) then
        table.insert(ValidPointInfos, {
          bHasPoint = true,
          PointType = M.PointType.FishingSpot,
          FishingSpotId = PointId
        })
      end
    end
  elseif TargetData.TargetType == TARGET_TYPE_PHOTO_POINT then
    for _, PhotoManualItemIdValue in ipairs(ParamList) do
      local PhotoManualItemId = tonumber(PhotoManualItemIdValue)
      local RegionPointId = ResolvePhotoSpotRegionPoint(PhotoManualItemId)
      local bValid = bRequireUnlocked and IsRegionPointAvailable(RegionPointId) or not bRequireUnlocked and IsRegionPointConfigured(RegionPointId)
      if bValid then
        table.insert(ValidPointInfos, {
          bHasPoint = true,
          PointType = M.PointType.PhotoPoint,
          PhotoManualItemId = PhotoManualItemId,
          RegionPointId = RegionPointId
        })
      end
    end
  elseif TargetData.TargetType == TARGET_TYPE_TEMPLE then
    for _, TempleIdValue in ipairs(ParamList) do
      local TempleId = tonumber(TempleIdValue)
      local TeleportPointId = ResolveTempleTeleportPoint(TempleId, bRequireUnlocked)
      if TeleportPointId then
        table.insert(ValidPointInfos, {
          bHasPoint = true,
          PointType = M.PointType.Temple,
          TempleId = TempleId,
          TeleportPointId = TeleportPointId
        })
      end
    end
  end
  if 0 == #ValidPointInfos then
    GWorld.logger.info(LOG_PREFIX, "ParseTarget result: no valid point", TargetId, "TargetType", TargetData.TargetType, "Params", ListText(ParamList), "RequireUnlocked", BoolText(bRequireUnlocked))
    return Result
  end
  local SelectedPointInfo = ValidPointInfos[math.random(1, #ValidPointInfos)]
  GWorld.logger.info(LOG_PREFIX, "ParseTarget result: point selected", TargetId, "PointType", SelectedPointInfo.PointType, "FishingSpotId", SelectedPointInfo.FishingSpotId, "PhotoManualItemId", SelectedPointInfo.PhotoManualItemId, "RegionPointId", SelectedPointInfo.RegionPointId, "TempleId", SelectedPointInfo.TempleId, "TeleportPointId", SelectedPointInfo.TeleportPointId, "ValidCandidateCount", #ValidPointInfos)
  return SelectedPointInfo
end

function M.ParseRecurringTaskPointInfo(TaskData, bRequireUnlocked)
  local Result = {bHasPoint = false}
  if not TaskData or not TaskData.TargetId then
    GWorld.logger.info(LOG_PREFIX, "ParseRecurringTask failed: task or TargetId missing", "TaskFound", BoolText(nil ~= TaskData))
    return Result
  end
  local TargetIds = TaskData.TargetId
  if type(TargetIds) ~= "table" then
    TargetIds = {TargetIds}
  end
  GWorld.logger.info(LOG_PREFIX, "ParseRecurringTask begin", TaskData.QuestId, "TargetIds", ListText(TargetIds), "RequireUnlocked", BoolText(false ~= bRequireUnlocked))
  local ValidPointInfos = {}
  for _, TargetIdValue in ipairs(TargetIds) do
    local TargetId = tonumber(TargetIdValue)
    local PointInfo = TargetId and M.ParseTargetPointInfo(DataMgr.Target[TargetId], bRequireUnlocked, TargetId)
    if PointInfo and PointInfo.bHasPoint then
      table.insert(ValidPointInfos, PointInfo)
    else
      GWorld.logger.info(LOG_PREFIX, "ParseRecurringTask rejected Target", TaskData.QuestId, "TargetId", TargetIdValue, "NumericTargetId", TargetId, "TargetFound", BoolText(nil ~= TargetId and nil ~= DataMgr.Target[TargetId]))
    end
  end
  if 0 == #ValidPointInfos then
    GWorld.logger.info(LOG_PREFIX, "ParseRecurringTask result: no valid point", TaskData.QuestId, "TargetIds", ListText(TargetIds), "RequireUnlocked", BoolText(false ~= bRequireUnlocked))
    return Result
  end
  local SelectedPointInfo = ValidPointInfos[math.random(1, #ValidPointInfos)]
  GWorld.logger.info(LOG_PREFIX, "ParseRecurringTask result: point selected", TaskData.QuestId, "PointType", SelectedPointInfo.PointType, "RegionPointId", SelectedPointInfo.RegionPointId, "TeleportPointId", SelectedPointInfo.TeleportPointId, "ValidTargetCount", #ValidPointInfos)
  return SelectedPointInfo
end

function M.CanTrackRecurringTaskPoint(TaskId)
  TaskId = tonumber(TaskId)
  if not TaskId then
    GWorld.logger.info(LOG_PREFIX, "CanTrack=false: invalid TaskId", TaskId)
    return false
  end
  local TaskData = DataMgr.RecurringTask[TaskId]
  if not TaskData or not TaskData.TargetId then
    GWorld.logger.info(LOG_PREFIX, "CanTrack=false: RecurringTask or TargetId missing", TaskId, "TaskFound", BoolText(nil ~= TaskData))
    return false
  end
  local PointInfo = M.ParseRecurringTaskPointInfo(TaskData, false)
  if not PointInfo.bHasPoint then
    GWorld.logger.info(LOG_PREFIX, "CanTrack=false: no configured map point", TaskId, "TargetIds", ListText(TaskData.TargetId))
    return false
  end
  if PointInfo.PointType == M.PointType.Temple then
    local bCanTrack = nil ~= PointInfo.TeleportPointId
    GWorld.logger.info(LOG_PREFIX, "CanTrack result", TaskId, "PointType", PointInfo.PointType, "TeleportPointId", PointInfo.TeleportPointId, "Result", BoolText(bCanTrack))
    return bCanTrack
  end
  local RegionPointId = PointInfo.RegionPointId
  if PointInfo.PointType == M.PointType.FishingSpot then
    RegionPointId = ResolveFishingSpotRegionPoint(PointInfo.FishingSpotId)
  end
  local RegionPointData = RegionPointId and DataMgr.RegionPoint[RegionPointId]
  local SubRegionData = RegionPointData and DataMgr.SubRegion[RegionPointData.SubRegion]
  local bCanTrack = nil ~= SubRegionData and nil ~= SubRegionData.RegionId
  GWorld.logger.info(LOG_PREFIX, "CanTrack result", TaskId, "PointType", PointInfo.PointType, "FishingSpotId", PointInfo.FishingSpotId, "RegionPointId", RegionPointId, "SubRegion", RegionPointData and RegionPointData.SubRegion, "RegionId", SubRegionData and SubRegionData.RegionId, "Result", BoolText(bCanTrack))
  return bCanTrack
end

local function OpenOrReuseLevelMap(Owner, RegionId, InitCompleteFunc, InitCompleteParam)
  local UIManagerObj = UIManager(Owner)
  local MainMap = UIManagerObj:GetUIObj("LevelMapMain")
  if not MainMap then
    return UIManagerObj:LoadUINew("LevelMapMain", false, RegionId, InitCompleteFunc, InitCompleteParam) ~= nil
  end
  local WildMap = MainMap.RealWildMap
  if not IsValid(WildMap) then
    return false
  end
  UIManagerObj:PlaceUIStateToTop("LevelMapMain")
  if WildMap.RegionID == RegionId then
    InitCompleteFunc()
  else
    WildMap:ChangeRegion(RegionId, InitCompleteFunc)
  end
  return true
end

function M.JumpToRegionPointOnMap(Owner, RegionPointId, bStartTrack, QuestId)
  RegionPointId = tonumber(RegionPointId)
  if not RegionPointId then
    return false
  end
  local RegionPointData = DataMgr.RegionPoint[RegionPointId]
  if not RegionPointData then
    GWorld.logger.error("RegionFameMapUtils.JumpToRegionPointOnMap: RegionPoint not found", RegionPointId)
    return false
  end
  if not CheckRegionPointUnlocked(Owner, RegionPointId) then
    return false
  end
  local SubRegionData = DataMgr.SubRegion[RegionPointData.SubRegion]
  if not SubRegionData or not SubRegionData.RegionId then
    GWorld.logger.error("RegionFameMapUtils.JumpToRegionPointOnMap: SubRegion invalid", RegionPointData.SubRegion)
    return false
  end
  if bStartTrack then
    M.EnsureTrackListenerRegistered()
    local PointType = CommonConst.RegionMapTrackingType.RegionPoint
    if TrackedPointId then
      M.StopMapTrack()
    end
    QuestId = QuestId and tonumber(QuestId) or nil
    local RequestId = SetTrackContext(PointType, RegionPointId, QuestId)
    local bSuccess = OpenOrReuseLevelMap(Owner, SubRegionData.RegionId, MakeMapInitWithTrack(PointType, RegionPointId, QuestId, RequestId), RegionPointId)
    if not bSuccess then
      ClearTrackContext()
    end
    return bSuccess
  else
    UIManager(Owner):LoadUINew("LevelMapMain", false, SubRegionData.RegionId, "RegionPoint", RegionPointId)
  end
  return true
end

function M.JumpToTempleOnMap(Owner, TempleId, bStartTrack, QuestId)
  local TeleportPointId = ResolveTempleTeleportPoint(TempleId)
  local TeleportPointData = TeleportPointId and DataMgr.TeleportPoint[TeleportPointId]
  if not TeleportPointData then
    GWorld.logger.error("RegionFameMapUtils.JumpToTempleOnMap: Temple has no teleport point", TempleId)
    return false
  end
  local SubRegionData = DataMgr.SubRegion[TeleportPointData.TeleportPointSubRegion]
  if not SubRegionData or not SubRegionData.RegionId then
    GWorld.logger.error("RegionFameMapUtils.JumpToTempleOnMap: SubRegion invalid", TeleportPointData.TeleportPointSubRegion)
    return false
  end
  if bStartTrack then
    M.EnsureTrackListenerRegistered()
    local PointType = CommonConst.RegionMapTrackingType.TeleportPoint
    if TrackedPointId then
      M.StopMapTrack()
    end
    QuestId = QuestId and tonumber(QuestId) or nil
    local RequestId = SetTrackContext(PointType, TeleportPointId, QuestId)
    local bSuccess = OpenOrReuseLevelMap(Owner, SubRegionData.RegionId, MakeMapInitWithTrack(PointType, TeleportPointId, QuestId, RequestId), TeleportPointId)
    if not bSuccess then
      ClearTrackContext()
    end
    return bSuccess
  else
    UIManager(Owner):LoadUINew("LevelMapMain", false, SubRegionData.RegionId, "TeleportPoint", TeleportPointId)
  end
  return true
end

function M.JumpToFishingSpotOnMap(Owner, FishingSpotId, bStartTrack, QuestId)
  local RegionPointId = ResolveFishingSpotRegionPoint(FishingSpotId)
  if not RegionPointId then
    GWorld.logger.error("RegionFameMapUtils.JumpToFishingSpotOnMap: FishingSpot invalid", FishingSpotId)
    return false
  end
  return M.JumpToRegionPointOnMap(Owner, RegionPointId, bStartTrack, QuestId)
end

function M.JumpToRecurringTaskPointOnMap(Owner, TaskId, bStartTrack)
  TaskId = tonumber(TaskId)
  if not TaskId then
    GWorld.logger.info(LOG_PREFIX, "Jump failed: invalid TaskId", TaskId)
    return false
  end
  if nil == bStartTrack then
    bStartTrack = true
  end
  local TaskData = DataMgr.RecurringTask[TaskId]
  if not TaskData or not TaskData.TargetId then
    GWorld.logger.error(LOG_PREFIX, "Jump failed: RecurringTask or TargetId missing", TaskId, "TaskFound", BoolText(nil ~= TaskData))
    return false
  end
  GWorld.logger.info(LOG_PREFIX, "Jump begin", TaskId, "TargetIds", ListText(TaskData.TargetId), "StartTrack", BoolText(bStartTrack))
  local ConfiguredPointInfo = M.ParseRecurringTaskPointInfo(TaskData, false)
  if not ConfiguredPointInfo.bHasPoint then
    GWorld.logger.error(LOG_PREFIX, "Jump failed: no configured map point", TaskId, "TargetIds", ListText(TaskData.TargetId))
    return false
  end
  local PointInfo = M.ParseRecurringTaskPointInfo(TaskData, true)
  if not PointInfo.bHasPoint then
    GWorld.logger.info(LOG_PREFIX, "Jump failed: configured points are all locked", TaskId, "TargetIds", ListText(TaskData.TargetId))
    return false, M.JumpFailureReason.NoUnlockedPoint
  end
  GWorld.logger.info(LOG_PREFIX, "Jump dispatch", TaskId, "PointType", PointInfo.PointType, "FishingSpotId", PointInfo.FishingSpotId, "PhotoManualItemId", PointInfo.PhotoManualItemId, "RegionPointId", PointInfo.RegionPointId, "TempleId", PointInfo.TempleId, "TeleportPointId", PointInfo.TeleportPointId)
  if PointInfo.PointType == M.PointType.FishingSpot then
    return M.JumpToFishingSpotOnMap(Owner, PointInfo.FishingSpotId, bStartTrack, TaskId)
  elseif PointInfo.PointType == M.PointType.Temple then
    return M.JumpToTempleOnMap(Owner, PointInfo.TempleId, bStartTrack, TaskId)
  end
  return M.JumpToRegionPointOnMap(Owner, PointInfo.RegionPointId, bStartTrack, TaskId)
end

return M
