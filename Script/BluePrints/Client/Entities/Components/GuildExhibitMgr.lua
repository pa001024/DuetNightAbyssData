local Component = {}

local function GetGuildExhibitSubsystem()
  local GameInstance = GWorld and GWorld.GameInstance
  if not GameInstance then
    return nil
  end
  return UE4.UGuildExhibitSubsystem.GetInstance(GameInstance)
end

local function ToVector(Location)
  if not Location then
    return Const.ZeroVector
  end
  return FVector(Location.X or 0, Location.Y or 0, Location.Z or 0)
end

local function ToRotator(Rotation)
  if not Rotation then
    return Const.ZeroRotator
  end
  return FRotator(Rotation.Pitch or 0, Rotation.Yaw or 0, Rotation.Roll or 0)
end

local function AddValueToList(List, Value)
  if Value and Value > 0 then
    table.insert(List, Value)
  end
end

local function AddModelDefaultPartIds(PartIds, ModelId)
  local ModelData = ModelId and DataMgr.Model[ModelId]
  if not ModelData then
    return
  end
  local ModelPartIds = ModelData.PartModelsId or ModelData.PartModels or {}
  for _, PartId in pairs(ModelPartIds) do
    AddValueToList(PartIds, PartId)
  end
end

local function GetOwnerPartMeshInfo(CharInfo)
  local SkinId = CharInfo and (CharInfo.SkinId or CharInfo.CharId)
  if not SkinId then
    return nil
  end
  for AccessoryId, Value in pairs(DataMgr.CharPartMesh or {}) do
    if Value.PartName == "PartMesh" then
      for _, Id in pairs(Value.Skin or {}) do
        if Id == SkinId then
          return AccessoryId, Value.AccessoryType
        end
      end
    end
  end
  return nil
end

local function CollectCharacterIds(CharInfo)
  local AccessoryIds = {}
  local PartIds = {}
  if not CharInfo then
    return AccessoryIds, PartIds
  end
  local PartMeshAccessoryId = GetOwnerPartMeshInfo(CharInfo)
  AddValueToList(AccessoryIds, PartMeshAccessoryId)
  local AccessorySuit = CharInfo.AccessorySuit or {}
  for Type, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes or {}) do
    local AccessoryId = AccessorySuit[AccessoryTypeIdx]
    if not DataMgr.CharPartType[Type] and AccessoryId and AccessoryId ~= PartMeshAccessoryId then
      AddValueToList(AccessoryIds, AccessoryId)
    elseif DataMgr.CharPartType[Type] then
      AddValueToList(PartIds, AccessoryId)
    end
  end
  if CharInfo.HairId then
    local HairData = DataMgr.Hair[CharInfo.HairId]
    AddValueToList(PartIds, HairData and HairData.CharPartId)
  end
  local CharData = CharInfo.CharId and DataMgr.BattleChar[CharInfo.CharId]
  AddModelDefaultPartIds(PartIds, CharData and CharData.ModelId)
  return AccessoryIds, PartIds
end

local function CollectWeaponAccessoryIds(WeaponInfo)
  local AccessoryIds = {}
  local AppearanceInfo = WeaponInfo and WeaponInfo.AppearanceInfo or WeaponInfo
  if AppearanceInfo and AppearanceInfo.AccessorySuit then
    for _, Id in pairs(AppearanceInfo.AccessorySuit) do
      AddValueToList(AccessoryIds, Id)
    end
  end
  return AccessoryIds
end

local function GetAccessoryIds(ItemInfo)
  if not ItemInfo then
    return {}
  end
  if ItemInfo.CharId then
    local AccessoryIds = CollectCharacterIds(ItemInfo)
    return AccessoryIds
  end
  if ItemInfo.WeaponId then
    return CollectWeaponAccessoryIds(ItemInfo)
  end
  return {}
end

local function GetPartIds(ItemInfo)
  if not ItemInfo then
    return {}
  end
  if ItemInfo.CharId then
    local _, PartIds = CollectCharacterIds(ItemInfo)
    return PartIds
  end
  return {}
end

local function GetExhibitUnitId(ItemInfo)
  if not ItemInfo then
    return 0
  end
  return ItemInfo.CharId or ItemInfo.WeaponId or ItemInfo.MountId or 0
end

local function GenerateUuid()
  return URuntimeCommonFunctionLibrary.GenerateGUID()
end

local function GetExhibitSkinId(ItemInfo)
  if not ItemInfo then
    return 0
  end
  if ItemInfo.CharId then
    return ItemInfo.SkinId or 0
  end
  if ItemInfo.WeaponId then
    local AppearanceInfo = ItemInfo.AppearanceInfo or ItemInfo
    return AppearanceInfo.SkinId or 0
  end
  return 0
end

function Component:InitGuildExhibitMgr()
  self.GuildExhibitItemInfoMap = {}
end

function Component:GuildExhibitSystemValid(ObjId)
  if not ObjId then
    self.logger.error("[GuildExhibit] ObjectId is nil")
    return false
  end
  if not GetGuildExhibitSubsystem() then
    self.logger.error("[GuildExhibit] UGuildExhibitSubsystem is nil")
    return false
  end
  return true
end

function Component:AddGuildExhibitActor(ObjId, ItemInfo)
  DebugPrint("[GuildExhibit] AddGuildExhibitActor", ObjId, ItemInfo)
  if not self:GuildExhibitSystemValid(ObjId) then
    return
  end
  local Subsystem = GetGuildExhibitSubsystem()
  if not Subsystem then
    self.logger.error("[GuildExhibit] UGuildExhibitSubsystem is nil")
    return
  end
  local Type = ItemInfo and ItemInfo.Type
  local UnitId = GetExhibitUnitId(ItemInfo)
  if not Type or UnitId <= 0 then
    self.logger.error("[GuildExhibit] ItemInfo is invalid", ObjId)
    return
  end
  local Uuid = ItemInfo and ItemInfo.Uuid
  if not Uuid then
    Uuid = GenerateUuid()
    ItemInfo.Uuid = Uuid
    self.logger.info("[GuildExhibit] Auto-generated Uuid for ObjId", ObjId, Uuid)
  end
  local SkinId = GetExhibitSkinId(ItemInfo)
  self.GuildExhibitItemInfoMap = self.GuildExhibitItemInfoMap or {}
  self.GuildExhibitItemInfoMap[Uuid] = ItemInfo
  Subsystem:AddOrUpdateExhibitInfo(Uuid, Type, UnitId, SkinId, GetAccessoryIds(ItemInfo), GetPartIds(ItemInfo), ToVector(ItemInfo.Location), ToRotator(ItemInfo.Rotation))
end

function Component:RemoveGuildExhibitActor(ObjId, ItemInfo)
  if not self:GuildExhibitSystemValid(ObjId) then
    return
  end
  local Subsystem = GetGuildExhibitSubsystem()
  if not Subsystem then
    self.logger.error("[GuildExhibit] UGuildExhibitSubsystem is nil")
    return
  end
  if ItemInfo and ItemInfo.Uuid then
    Subsystem:RemoveExhibitInfo(ItemInfo.Uuid)
    if self.GuildExhibitItemInfoMap then
      self.GuildExhibitItemInfoMap[ItemInfo.Uuid] = nil
    end
    return
  end
  if not self.GuildExhibitItemInfoMap then
    return
  end
  for Uuid, _ in pairs(self.GuildExhibitItemInfoMap) do
    Subsystem:RemoveExhibitInfo(Uuid)
  end
  self.GuildExhibitItemInfoMap = {}
end

function Component:GetGuildExhibitItemInfo(Uuid)
  return self.GuildExhibitItemInfoMap and self.GuildExhibitItemInfoMap[Uuid]
end

return Component
