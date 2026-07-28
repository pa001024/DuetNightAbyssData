local M = {}
local CHARACTER_GROUP_ID = 101
local PET_GROUP_ID = 102
local DEFAULT_CHARACTER_SPAWN_RANGE_X = {-300, 300}
local DEFAULT_CHARACTER_SPAWN_RANGE_Y = {-300, 300}
local DEFAULT_CHARACTER_SPAWN_RANGE_Z = {-100, 150}

local function BuildSymmetricRangeLimit(RawValue)
  if type(RawValue) == "number" then
    local AbsValue = math.abs(RawValue)
    return -AbsValue, AbsValue
  end
  if type(RawValue) ~= "table" then
    return nil, nil
  end
  if nil ~= RawValue[1] and nil ~= RawValue[2] then
    local ValueA = tonumber(RawValue[1]) or 0
    local ValueB = tonumber(RawValue[2]) or 0
    return math.min(ValueA, ValueB), math.max(ValueA, ValueB)
  end
  local SingleValue = tonumber(RawValue[1]) or 0
  local AbsValue = math.abs(SingleValue)
  return -AbsValue, AbsValue
end

local function BuildTransformFromPointConfig(PointConfig)
  if not PointConfig then
    return nil
  end
  local Position = PointConfig.OffsetPosition or {}
  local Rotation = PointConfig.OffsetRotation or {}
  local Rotator = FRotator(Rotation[2] or 0, Rotation[3] or 0, Rotation[1] or 0)
  local Location = FVector(Position[1] or 0, Position[2] or 0, Position[3] or 0)
  return FTransform(Rotator:ToQuat(), Location, FVector(1, 1, 1))
end

local function GetPointId(DisplayGroupId, PointIndex)
  return DisplayGroupId * 100 + PointIndex
end

local function GetDisplayGroupConfig(DisplayGroupId)
  local ConfigTable = DataMgr and DataMgr.CustomDisplayGroup or nil
  return ConfigTable and ConfigTable[DisplayGroupId] or nil
end

local function GetPointConfig(DisplayGroupId, PointIndex)
  local ConfigTable = DataMgr and DataMgr.CustomDisplayPoint or nil
  if not ConfigTable then
    return nil
  end
  local PointId = GetPointId(DisplayGroupId, PointIndex)
  local PointConfig = ConfigTable[PointId]
  if PointConfig then
    return PointConfig
  end
  for _, Config in pairs(ConfigTable) do
    if Config.DisplayGroupId == DisplayGroupId and Config.PointIndex == PointIndex then
      return Config
    end
  end
  return nil
end

function M:GetCharacterGroupId()
  return CHARACTER_GROUP_ID
end

function M:GetPetGroupId()
  return PET_GROUP_ID
end

function M:GetCharacterSlotCount()
  local Config = GetDisplayGroupConfig(CHARACTER_GROUP_ID)
  return Config and Config.MaxCount and Config.MaxCount > 0 and Config.MaxCount or 4
end

function M:GetPetSlotCount()
  local Config = GetDisplayGroupConfig(PET_GROUP_ID)
  return Config and Config.MaxCount and Config.MaxCount > 0 and Config.MaxCount or 1
end

function M:GetDefaultCharacterTransform(SlotIndex, SceneId)
  return BuildTransformFromPointConfig(GetPointConfig(CHARACTER_GROUP_ID, SlotIndex or 1))
end

function M:GetDefaultPetTransform(SlotIndex)
  return BuildTransformFromPointConfig(GetPointConfig(PET_GROUP_ID, SlotIndex or 1))
end

function M:GetCharacterPointConfig(SlotIndex)
  return GetPointConfig(CHARACTER_GROUP_ID, SlotIndex or 1)
end

function M:GetCharacterDefaultTranslation(SlotIndex)
  local PointConfig = self:GetCharacterPointConfig(SlotIndex)
  local Position = PointConfig and PointConfig.OffsetPosition or nil
  return {
    X = Position and Position[1] or 0,
    Y = Position and Position[2] or 0,
    Z = Position and Position[3] or 0
  }
end

function M:GetDefaultSceneId()
  local ConfigTable = DataMgr and DataMgr.CustomScene or nil
  if ConfigTable and ConfigTable[101] then
    return 101
  end
  if ConfigTable then
    local FirstSceneId
    for SceneId, _ in pairs(ConfigTable) do
      if nil == FirstSceneId or SceneId < FirstSceneId then
        FirstSceneId = SceneId
      end
    end
    if nil ~= FirstSceneId then
      return FirstSceneId
    end
  end
  return 101
end

function M:GetSceneConfig(SceneId)
  local ConfigTable = DataMgr and DataMgr.CustomScene or nil
  local ResolvedSceneId = SceneId or self:GetDefaultSceneId()
  return ConfigTable and ConfigTable[ResolvedSceneId] or nil
end

function M:GetScenePath(SceneId)
  local SceneConfig = self:GetSceneConfig(SceneId)
  return SceneConfig and SceneConfig.ScenePath or nil
end

function M:GetSceneColorIndex(SceneId)
  local SceneConfig = self:GetSceneConfig(SceneId)
  return SceneConfig and SceneConfig.SceneColorIndex or 0
end

function M:GetSceneInitialCameraTransform(SceneId)
  local SceneConfig = self:GetSceneConfig(SceneId)
  if not SceneConfig then
    return nil
  end
  local Position = SceneConfig.CameraInitialPosition or SceneConfig.InitialPosition or {}
  local Rotation = SceneConfig.CameraInitialRotation or SceneConfig.InitialRotation or {}
  return {
    Location = FVector(Position[1] or 0, Position[2] or 0, Position[3] or 0),
    Rotation = FRotator(Rotation[2] or 0, Rotation[3] or 0, Rotation[1] or 0)
  }
end

function M:GetSceneCameraLimitConfig(SceneId)
  local SceneConfig = self:GetSceneConfig(SceneId)
  if not SceneConfig then
    return nil
  end
  local DistanceMin, DistanceMax = BuildSymmetricRangeLimit(SceneConfig.CameraLocationX)
  local HorizontalMin, HorizontalMax = BuildSymmetricRangeLimit(SceneConfig.CameraLocationY)
  local VerticalMin, VerticalMax = BuildSymmetricRangeLimit(SceneConfig.CameraLocationZ)
  local PitchMin, PitchMax = BuildSymmetricRangeLimit(SceneConfig.CameraRotationPitch)
  local YawMin, YawMax = BuildSymmetricRangeLimit(SceneConfig.CameraRotationYaw)
  if nil == DistanceMin and nil == DistanceMax and nil == HorizontalMin and nil == HorizontalMax and nil == VerticalMin and nil == VerticalMax and nil == PitchMin and nil == PitchMax and nil == YawMin and nil == YawMax then
    return nil
  end
  return {
    DistanceMin = DistanceMin,
    DistanceMax = DistanceMax,
    HorizontalMin = HorizontalMin,
    HorizontalMax = HorizontalMax,
    VerticalMin = VerticalMin,
    VerticalMax = VerticalMax,
    PitchMin = PitchMin,
    PitchMax = PitchMax,
    YawMin = YawMin,
    YawMax = YawMax
  }
end

function M:GetCharacterTransformEditRange(SlotIndex, SceneId, CurrentTranslation)
  local SceneConfig = self:GetSceneConfig(SceneId)
  local DefaultTranslation = self:GetCharacterDefaultTranslation(SlotIndex)
  local Translation = CurrentTranslation or DefaultTranslation
  local XMin, XMax = BuildSymmetricRangeLimit(SceneConfig and SceneConfig.SpawnLocationX or nil)
  local YMin, YMax = BuildSymmetricRangeLimit(SceneConfig and SceneConfig.SpawnLocationY or nil)
  XMin, XMax = self:_NormalizeAxisRange(XMin, XMax, Translation.X, DefaultTranslation.X, DEFAULT_CHARACTER_SPAWN_RANGE_X)
  YMin, YMax = self:_NormalizeAxisRange(YMin, YMax, Translation.Y, DefaultTranslation.Y, DEFAULT_CHARACTER_SPAWN_RANGE_Y)
  local ZFallback = {
    math.min(DEFAULT_CHARACTER_SPAWN_RANGE_Z[1], (DefaultTranslation.Z or 0) - 100),
    math.max(DEFAULT_CHARACTER_SPAWN_RANGE_Z[2], (DefaultTranslation.Z or 0) + 150)
  }
  local ZMin, ZMax = self:_NormalizeAxisRange(nil, nil, Translation.Z, DefaultTranslation.Z, ZFallback)
  return {
    X = {Min = XMin, Max = XMax},
    Y = {Min = YMin, Max = YMax},
    Z = {Min = ZMin, Max = ZMax},
    Yaw = {Min = -180, Max = 180}
  }
end

function M:ApplySceneDefaults(Draft, ForceRefreshCameraLimit, SceneIdOverride)
  if type(Draft) ~= "table" then
    return
  end
  Draft.Scene = Draft.Scene or {}
  Draft.Camera = Draft.Camera or {}
  if nil ~= SceneIdOverride then
    Draft.Scene.SceneId = SceneIdOverride
  elseif nil == Draft.Scene.SceneId then
    Draft.Scene.SceneId = self:GetDefaultSceneId()
  end
  local SceneCameraTransform = self:GetSceneInitialCameraTransform(Draft.Scene.SceneId)
  if SceneCameraTransform then
    if nil == Draft.Camera.LocalPosition then
      Draft.Camera.LocalPosition = {
        X = SceneCameraTransform.Location.X or 0,
        Y = SceneCameraTransform.Location.Y or 0,
        Z = SceneCameraTransform.Location.Z or 0
      }
    end
    if nil == Draft.Camera.LocalRotation then
      Draft.Camera.LocalRotation = {
        Pitch = SceneCameraTransform.Rotation.Pitch or 0,
        Yaw = SceneCameraTransform.Rotation.Yaw or 0,
        Roll = SceneCameraTransform.Rotation.Roll or 0
      }
    end
    if nil == Draft.Camera.Offset then
      Draft.Camera.Offset = {
        Horizontal = Draft.Camera.LocalPosition.Y or 0,
        Vertical = Draft.Camera.LocalPosition.Z or 0
      }
    end
    if nil == Draft.Camera.Distance then
      Draft.Camera.Distance = Draft.Camera.LocalPosition.X or 0
    end
    if nil == Draft.Camera.Rotation then
      Draft.Camera.Rotation = {
        Pitch = Draft.Camera.LocalRotation.Pitch or 0,
        Yaw = Draft.Camera.LocalRotation.Yaw or 0
      }
    end
  end
  if ForceRefreshCameraLimit or nil == Draft.Camera.LimitConfig then
    Draft.Camera.LimitConfig = self:GetSceneCameraLimitConfig(Draft.Scene.SceneId)
  end
end

function M:_NormalizeAxisRange(MinValue, MaxValue, CurrentValue, DefaultValue, FallbackRange)
  local FinalMin = MinValue
  local FinalMax = MaxValue
  if nil == FinalMin or nil == FinalMax then
    FinalMin = FallbackRange[1]
    FinalMax = FallbackRange[2]
  end
  if FinalMin > FinalMax then
    FinalMin, FinalMax = FinalMax, FinalMin
  end
  if nil ~= DefaultValue then
    FinalMin = math.min(FinalMin, DefaultValue)
    FinalMax = math.max(FinalMax, DefaultValue)
  end
  if nil ~= CurrentValue then
    FinalMin = math.min(FinalMin, CurrentValue)
    FinalMax = math.max(FinalMax, CurrentValue)
  end
  if FinalMin == FinalMax then
    FinalMin = FinalMin - 1
    FinalMax = FinalMax + 1
  end
  return FinalMin, FinalMax
end

return M
