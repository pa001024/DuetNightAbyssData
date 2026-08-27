local SettingUtils = require("Utils.SettingUtils")
require("UnLua")

local function BuildPrefixedInstanceId(Name, Guid)
  return tostring(Name) .. "_" .. tostring(UE4.UKismetGuidLibrary.Conv_GuidToString(Guid))
end

local function ParseGuidFromPrefixedInstanceId(PrefixedId)
  if not PrefixedId or "" == PrefixedId or "nil_nil" == PrefixedId then
    return FGuid()
  end
  local LastUnderscoreIndex = PrefixedId:reverse():find("_", 1, true)
  if not LastUnderscoreIndex then
    return FGuid()
  end
  local GuidStr = PrefixedId:sub(#PrefixedId - LastUnderscoreIndex + 2)
  if not GuidStr or "" == GuidStr or "nil" == GuidStr then
    return FGuid()
  end
  local OutGuid = FGuid()
  if UE4.UKismetGuidLibrary.Parse_StringToGuid(GuidStr, OutGuid) then
    return OutGuid
  end
  return FGuid()
end

local GuildEntranceSettingsCacheName = "GuildEntranceSettings"
local ConstructSettingDefaults = {
  {ID = "bShowGrid", State = 1},
  {
    ID = "bShowParticle",
    State = 1
  },
  {
    ID = "CameraMoveMode",
    State = 0
  },
  {
    ID = "ComponentMoveMode",
    State = 1
  }
}
local M = Class()

function M:InitConstructSettings()
  for _, Option in ipairs(ConstructSettingDefaults) do
    local Value = SettingUtils.GetEMCache(GuildEntranceSettingsCacheName, Option.ID, Option.State or 0)
    self:ApplyConstructSetting(Option.ID, Value)
  end
end

function M:SaveEMSettingCache(SettingID, Value)
  Value = self:ApplyConstructSetting(SettingID, Value)
  SettingUtils.SaveEMCache(GuildEntranceSettingsCacheName, SettingID, Value)
end

function M:OnCloseEditMode()
  if self.GuildLandManager then
    self.GuildLandManager:SetPlaneGridDrawMode(false)
  end
  self.CameraActor:K2_SetActorTransform(self.CameraActorSavedParam.CameraSavedTransform, false, nil, false)
  self.CameraActor.SpringArm.TargetArmLength = self.CameraActorSavedParam.CameraSavedTargetArmLength
end

function M:ApplyConstructSetting(SettingID, Value)
  local Ret
  if "bShowGrid" == SettingID then
    Ret = Value or ConstructSettingDefaults[SettingID]
    self.Settings.bShowGrid = 1 == Ret
    if self.GuildLandManager then
      self.GuildLandManager:SetPlaneGridDrawMode(self.Settings.bShowGrid)
    end
  elseif "bShowParticle" == SettingID then
    Ret = Value or ConstructSettingDefaults[SettingID]
    self.Settings.bShowParticle = 1 == Ret
  elseif "CameraMoveMode" == SettingID then
    Ret = Value or ConstructSettingDefaults[SettingID]
    self.Settings.CameraMoveMode = 1 == Ret and UE4.EGuildCameraMoveMode.TopDownView or UE4.EGuildCameraMoveMode.FreeMode
    if self.CameraActor then
      self.CameraActor:OnChangedCameraMode()
    end
  elseif "ComponentMoveMode" == SettingID then
    Ret = Value or ConstructSettingDefaults[SettingID]
    self.Settings.ComponentMoveMode = 1 == Ret and UE4.EGuildComponentMoveMode.PixelMove or UE4.EGuildComponentMoveMode.GridMove
  end
  return Ret
end

function M:EnsureGuildItemCountEntry(UnitId)
  if not self.GuildItemCount then
    self.GuildItemCount = {}
  end
  if not self.GuildItemCount[UnitId] then
    self.GuildItemCount[UnitId] = {PlacedCount = 0, TotalCount = 0}
  end
  return self.GuildItemCount[UnitId]
end

function M:InitGuildItemCount()
  local Avatar = GWorld:GetAvatar()
  local ComponentInventory = Avatar and Avatar.GuildInfo and Avatar.GuildInfo.GuildHomeData and Avatar.GuildInfo.GuildHomeData.ComponentInventory or {}
  local PlacedCountMap = {}
  local PlacedActorStates = self:GetSceneActors()
  if PlacedActorStates then
    for _, ActorState in pairs(PlacedActorStates) do
      local UnitId = ActorState.UnitId
      if UnitId and UnitId >= 0 and DataMgr.GuildItem[UnitId] then
        PlacedCountMap[UnitId] = (PlacedCountMap[UnitId] or 0) + 1
      end
    end
  end
  local GuildItems = DataMgr.GuildItem or {}
  for ItemId, _ in pairs(GuildItems) do
    self.GuildItemCount[ItemId] = {
      PlacedCount = PlacedCountMap[ItemId] or 0,
      TotalCount = ComponentInventory[ItemId] or 0
    }
  end
end

function M:RestoreSceneToInitialStateLua(Callback)
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.GuildInfo) or not Avatar.GuildInfo.GuildHomeData then
    if Callback then
      Callback(false)
    end
    return
  end
  local GuildHomeData = Avatar.GuildInfo.GuildHomeData
  local PublishedLayout = GuildHomeData.PublishedLayout or {}
  local LayoutVersion = PublishedLayout.LayoutVersion or 0
  local EmptyLayout = {
    LayoutVersion = LayoutVersion,
    Performance = 0,
    CategoryCounts = {},
    InstanceList = {},
    UpdateTime = TimeUtils.NowTime(),
    OperatorUid = Avatar.Uid
  }
  
  local function PublishCallback(...)
    local ErrCode, Result = ...
    DebugPrint("lxc: RestoreSceneToInitialStateLua ErrorCode:" .. tostring(ErrCode))
    if not ErrorCode:Check(ErrCode) then
      if Callback then
        Callback(false, ErrCode, Result)
      end
      return
    end
    Result = Result or {}
    GuildHomeData.PublishedLayout = Result.PublishedLayout or EmptyLayout
    GuildHomeData.ComponentInventory = Result.ComponentInventory or GuildHomeData.ComponentInventory
    local EmptyStates = TArray(FGuildConstructActorState)
    self:LoadScene(EmptyStates)
    self:ClearHistory()
    if Callback then
      Callback(true, ErrCode, Result)
    end
  end
  
  Avatar:GuildHomePublishLayout(PublishCallback, LayoutVersion, EmptyLayout)
end

function M:SaveSceneLua()
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.GuildInfo) or not Avatar.GuildInfo.GuildHomeData then
    return
  end
  local GuildHomeData = Avatar.GuildInfo.GuildHomeData
  local LayoutVersion = GuildHomeData.PublishedLayout.LayoutVersion
  local SceneData = self:SaveScene()
  local LayoutInstance
  local LayoutInstanceList = {}
  for _, ActorState in pairs(SceneData) do
    LayoutInstance = self:SerializeActorStateToServerData(ActorState)
    table.insert(LayoutInstanceList, LayoutInstance)
  end
  local CategoryCounts = {}
  for Index, LayoutInstance in pairs(LayoutInstanceList) do
    if LayoutInstance.ComponentId then
      CategoryCounts[LayoutInstance.ComponentId] = CategoryCounts[LayoutInstance.ComponentId] or 0
      CategoryCounts[LayoutInstance.ComponentId] = CategoryCounts[LayoutInstance.ComponentId] + 1
    end
  end
  local PublishedLayout = {}
  PublishedLayout.LayoutVersion = LayoutVersion
  PublishedLayout.Performance = 0
  PublishedLayout.CategoryCounts = CategoryCounts
  PublishedLayout.InstanceList = LayoutInstanceList
  PublishedLayout.UpdateTime = TimeUtils.NowTime()
  PublishedLayout.OperatorUid = Avatar.Uid
  
  local function Callback(...)
    DebugPrint("lxc: GuildHomePublishLayout callback")
    local ErrCode, Table = ...
    DebugPrint("lxc: GuildHomePublishLayout ErrorCode:" .. tostring(ErrCode))
    ErrorCode:Check(ErrCode)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_PublishSuccess")
  end
  
  Avatar:GuildHomePublishLayout(Callback, LayoutVersion, PublishedLayout)
end

function M:LoadSceneFromLua()
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.GuildInfo) or not Avatar.GuildInfo.GuildHomeData then
    return false
  end
  self.GuildLandManager = UE4.UGameplayStatics.GetActorOfClass(self, UE4.AGuildLandManager)
  self.CameraActor = UE4.UGameplayStatics.GetActorOfClass(self, UE4.AGuildConstructCameraBase)
  self.CameraActor:Init(self)
  self.CameraActorSavedParam = {
    CameraSavedTransform = self.CameraActor:GetTransform(),
    CameraSavedTargetArmLength = self.CameraActor.SpringArm.TargetArmLength
  }
  local InstanceList = Avatar.GuildInfo.GuildHomeData.PublishedLayout.InstanceList
  local ServerSceneData = TArray(FGuildConstructActorState)
  if InstanceList then
    for _, InstanceState in ipairs(InstanceList) do
      local State = self:DeserializeActorStateFromServerData(InstanceState)
      if State and UE4.UKismetGuidLibrary.IsValid_Guid(State.Id) then
        ServerSceneData:Add(State)
      end
    end
  end
  local Ret = self:LoadScene(ServerSceneData)
  self.GuildItemCount = {}
  self:InitGuildItemCount()
  self.CostTotal = DataMgr.GlobalConstant.GuildPerformanceMax.ConstantValue
  return Ret
end

function M:NotifyLuaActorStatesChanged(AddedItems, DeletedItems)
  if AddedItems then
    for _, ActorState in pairs(AddedItems) do
      local UnitId = ActorState.UnitId
      if UnitId and UnitId >= 0 and DataMgr.GuildItem[UnitId] then
        local ItemCount = self:EnsureGuildItemCountEntry(UnitId)
        ItemCount.PlacedCount = (ItemCount.PlacedCount or 0) + 1
      end
    end
  end
  if DeletedItems then
    for _, ActorState in pairs(DeletedItems) do
      local UnitId = ActorState.UnitId
      if UnitId and UnitId >= 0 and self.GuildItemCount and self.GuildItemCount[UnitId] then
        local ItemCount = self.GuildItemCount[UnitId]
        ItemCount.PlacedCount = math.max((ItemCount.PlacedCount or 0) - 1, 0)
      end
    end
  end
  self.OnPlacedItemChanged:Broadcast(AddedItems, DeletedItems)
end

function M:UpdateGuildItemInventory(Msg)
  if not Msg or not Msg.ComponentInventory then
    return
  end
  local ComponentInventory = Msg.ComponentInventory
  local ChangedItemIds = TArray(0)
  for ItemId, NewTotalCount in pairs(ComponentInventory) do
    local ItemCount = self:EnsureGuildItemCountEntry(ItemId)
    ItemCount.TotalCount = NewTotalCount or 0
    ChangedItemIds:Add(ItemId)
  end
  if ChangedItemIds:Num() > 0 then
    self.OnBuyItemChanged:Broadcast(ChangedItemIds)
  end
end

function M:SerializeActorStateToServerData(InActorState)
  local LayoutInstance = {}
  if not InActorState then
    return nil
  end
  if -1 == InActorState.UnitId or not DataMgr.GuildItem[InActorState.UnitId] then
    return nil
  end
  local Name = DataMgr.GuildItem[InActorState.UnitId].Name
  LayoutInstance.InstanceId = BuildPrefixedInstanceId(Name, InActorState.Id)
  LayoutInstance.ComponentId = InActorState.UnitId
  LayoutInstance.Position = {}
  LayoutInstance.Position.X = InActorState.LocalLocation.X
  LayoutInstance.Position.Y = InActorState.LocalLocation.Y
  LayoutInstance.Position.Z = InActorState.LocalLocation.Z
  LayoutInstance.Rotation = {}
  LayoutInstance.Rotation.X = InActorState.LocalRotation.Roll
  LayoutInstance.Rotation.Y = InActorState.LocalRotation.Pitch
  LayoutInstance.Rotation.Z = InActorState.LocalRotation.Yaw
  LayoutInstance.Scale = {}
  LayoutInstance.Scale.X = InActorState.LocalScale
  LayoutInstance.Scale.Y = InActorState.LocalScale
  LayoutInstance.Scale.Z = InActorState.LocalScale
  LayoutInstance.Height = InActorState.LocalHeight
  local ParentState, bOk = self:GetActorState(InActorState.ParentId)
  if bOk and ParentState then
    local ParentName
    if DataMgr.GuildItem[ParentState.UnitId] then
      ParentName = DataMgr.GuildItem[ParentState.UnitId].Name
    end
    LayoutInstance.ParentId = BuildPrefixedInstanceId(ParentName, ParentState.Id)
  else
    LayoutInstance.ParentId = "nil_nil"
  end
  return LayoutInstance
end

function M:DeserializeActorStateFromServerData(InstanceState)
  local Ret = FGuildConstructActorState()
  if not InstanceState then
    return Ret
  end
  Ret.Id = ParseGuidFromPrefixedInstanceId(InstanceState.InstanceId)
  Ret.UnitId = InstanceState.ComponentId or -1
  Ret.ParentId = ParseGuidFromPrefixedInstanceId(InstanceState.ParentId)
  local Position = InstanceState.Position
  if Position then
    Ret.LocalLocation = FVector(Position.X or 0, Position.Y or 0, Position.Z or 0)
  end
  local Rotation = InstanceState.Rotation
  if Rotation then
    Ret.LocalRotation = FRotator(Rotation.Y or 0, Rotation.Z or 0, Rotation.X or 0)
  end
  local Scale = InstanceState.Scale
  if Scale then
    Ret.LocalScale = Scale.X or Scale.Y or Scale.Z or 1
  end
  Ret.LocalHeight = InstanceState.Height or 0
  return Ret
end

return M
