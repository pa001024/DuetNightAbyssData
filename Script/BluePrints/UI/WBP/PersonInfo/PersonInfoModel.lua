local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local PersonalInfoCustomTypes = require("BluePrints.Client.CustomTypes.PersonalInfo")
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
  self._ModelInfo = {}
  self._PersonID = nil
  self._DisplayPlan = {}
  self.OtherPersonInfo = nil
  self.OtherBattleDumpInfo = nil
end

function M:InitData(PlayerInfo)
  if self._Avatar == nil then
    self._Avatar = GWorld:GetAvatar()
  end
  if nil ~= PlayerInfo then
    self._PersonID = PlayerInfo.Uuid
    self.OtherPersonInfo = PlayerInfo
  else
    self._PersonID = nil
    self.OtherPersonInfo = nil
  end
  self.OtherRaidSeasonRankRecord = nil
  self._DisplayPlan = {}
  self._DisplayPlan.CharDisplayPlans = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  self._DisplayPlan.WeaponDisplayPlans = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  if nil ~= self._PersonID then
    local CharInfo = self:ChangeToCharBattleDumpInfo(PlayerInfo.Char)
    local WeaponInfo = self:ChangeToWeaponBattleDumpInfo(PlayerInfo.Weapon)
    self.OtherBattleDumpInfo = {
      Char = CharInfo,
      Weapon = WeaponInfo,
      WeaponForgeLevel = PlayerInfo.WeaponForgeLevel or 0
    }
    self.OtherPersonInfo = PlayerInfo
    local CustomDisplay = PlayerInfo.CustomDisplay or {}
    local CustomCharParams = CustomDisplay.CharParamGroup or {}
    for i = 1, 3 do
      if self.OtherPersonInfo.Char[i] then
        self.OtherPersonInfo.Char[i].RoleId = self.OtherPersonInfo.Char[i].CharId
        local CustomParam = CustomCharParams[i]
        self._DisplayPlan.CharDisplayPlans[i] = {
          CharId = self.OtherPersonInfo.Char[i].CharId,
          AppearancePlan = CustomParam and CustomParam.AppearancePlan or nil,
          ModPlan = CustomParam and CustomParam.ModPlan or nil
        }
      end
      if self.OtherPersonInfo.Weapon[i] then
        self.OtherPersonInfo.Weapon[i].RoleId = self.OtherPersonInfo.Weapon[i].WeaponId
        self._DisplayPlan.WeaponDisplayPlans[i] = {
          WeaponId = self.OtherPersonInfo.Weapon[i].WeaponId
        }
      end
    end
  else
    for i = 1, 3 do
      if nil ~= self._Avatar.PersonalInfo.CharDisplay[i] then
        if nil == self._Avatar.Chars[self._Avatar.PersonalInfo.CharDisplay[i].Id] then
          self._Avatar.PersonalInfo.CharDisplay[i].Id = -1
        end
        self._DisplayPlan.CharDisplayPlans[i] = {
          CharId = self._Avatar.PersonalInfo.CharDisplay[i].Id,
          AppearancePlan = self._Avatar.PersonalInfo.CharDisplay[i].AppearancePlan,
          ModPlan = self._Avatar.PersonalInfo.CharDisplay[i].ModPlan
        }
      end
      if nil ~= self._Avatar.PersonalInfo.WeaponDisplay[i] then
        if nil == self._Avatar.Weapons[self._Avatar.PersonalInfo.WeaponDisplay[i].Id] then
          self._Avatar.PersonalInfo.WeaponDisplay[i].Id = -1
        end
        self._DisplayPlan.WeaponDisplayPlans[i] = {
          WeaponId = self._Avatar.PersonalInfo.WeaponDisplay[i].Id,
          ModPlan = self._Avatar.PersonalInfo.WeaponDisplay[i].ModPlan
        }
      end
    end
  end
  for i = 1, 3 do
    local Plan = self._DisplayPlan.CharDisplayPlans[i]
    if nil == Plan then
      self._DisplayPlan.CharDisplayPlans[i] = {CharId = -1}
    elseif nil == Plan.CharId then
      Plan.CharId = -1
    end
    Plan = self._DisplayPlan.WeaponDisplayPlans[i]
    if nil == Plan then
      self._DisplayPlan.WeaponDisplayPlans[i] = {WeaponId = -1}
    elseif nil == Plan.WeaponId then
      Plan.WeaponId = -1
    end
  end
end

function M:fakaini()
  local i = 1
  for __, char in pairs(self._Avatar.Chars) do
    if i > 3 then
      break
    end
    self._DisplayPlan.CharDisplayPlans[i] = {
      CharId = char.Uuid,
      AppearancePlan = 1,
      ModPlan = 2
    }
    i = i + 1
  end
  i = 1
  for __, weapon in pairs(self._Avatar.Weapons) do
    if i > 3 then
      break
    end
    self._DisplayPlan.WeaponDisplayPlans[i] = {
      WeaponId = weapon.Uuid,
      ModPlan = 2
    }
    i = i + 1
  end
end

function M:SetPersonID(PersonID)
  self._PersonID = PersonID
end

function M:GetDisplayContent()
  local DisplayContent = {
    CharContent = {},
    WeaponContent = {}
  }
  if self:IsOwener() then
    for index, Plan in ipairs(self._DisplayPlan.CharDisplayPlans) do
      local uuid = Plan.CharId
      local CharData = {}
      if -1 ~= uuid then
        local id = self._Avatar.Chars[uuid].CharId
        CharData.Id = id
        local IconPath = DataMgr.Char[id].Icon
        CharData.Icon = IconPath
        local Rarity = DataMgr.Char[id].CharRarity
        CharData.Rarity = Rarity
        CharData.ItemType = "Char"
        CharData.Level = self._Avatar.Chars[uuid].Level
      else
        CharData.Id = uuid
      end
      DisplayContent.CharContent[index] = CharData
    end
    for index, Plan in ipairs(self._DisplayPlan.WeaponDisplayPlans) do
      local WeaponData = {}
      local uuid = Plan.WeaponId
      if -1 ~= uuid then
        local id = self._Avatar.Weapons[uuid].WeaponId
        WeaponData.Id = id
        local IconPath = DataMgr.Weapon[id].Icon
        WeaponData.Icon = IconPath
        local Rarity = DataMgr.Weapon[id].WeaponRarity
        WeaponData.Rarity = Rarity
        WeaponData.Level = self._Avatar.Weapons[uuid].Level
      else
        WeaponData.Id = -1
      end
      DisplayContent.WeaponContent[index] = WeaponData
    end
  else
    for i = 1, 3 do
      local CharData = {}
      if self.OtherPersonInfo and self.OtherPersonInfo.Char and self.OtherPersonInfo.Char[i] then
        local id = self.OtherPersonInfo.Char[i].CharId
        CharData.Id = id
        local IconPath = DataMgr.Char[id].Icon
        CharData.Icon = IconPath
        local Rarity = DataMgr.Char[id].CharRarity
        CharData.Rarity = Rarity
        CharData.ItemType = "Char"
        CharData.Level = self.OtherPersonInfo.Char[i].Level
      else
        CharData.Id = -1
      end
      DisplayContent.CharContent[i] = CharData
    end
    for i = 1, 3 do
      local WeaponData = {}
      if self.OtherPersonInfo and self.OtherPersonInfo.Weapon and self.OtherPersonInfo.Weapon[i] then
        local id = self.OtherPersonInfo.Weapon[i].WeaponId
        WeaponData.Id = id
        local IconPath = DataMgr.Weapon[id].Icon
        WeaponData.Icon = IconPath
        WeaponData.ItemType = "Weapon"
        local Rarity = DataMgr.Weapon[id].WeaponRarity
        WeaponData.Rarity = Rarity
        WeaponData.Level = self.OtherPersonInfo.Weapon[i].Level
      else
        WeaponData.Id = -1
      end
      DisplayContent.WeaponContent[i] = WeaponData
    end
    DisplayContent.Birthday = self.OtherPersonInfo.Birthday
  end
  return DisplayContent
end

function M:GetCharSuitIndex(index)
  if -1 == index or nil == index then
    DebugPrint("index 不能为-1或0")
    return
  end
  local Uuid = self._DisplayPlan.CharDisplayPlans[index].CharId
  local suitindex = self._DisplayPlan.CharDisplayPlans[index].AppearancePlan
  if -1 == suitindex or 0 == suitindex then
    DebugPrint("外观方案为-1或0")
  end
  return Uuid, suitindex
end

function M:GetShowCharBaseInfo(index)
  if -1 == index then
    return nil
  end
  local CharId
  if self:IsOwener() then
    CharId = self._Avatar.Chars[self._DisplayPlan.CharDisplayPlans[index].CharId].CharId
  elseif self.OtherPersonInfo and self.OtherPersonInfo.Char[index] and self.OtherPersonInfo.Char[index].CharId then
    CharId = self.OtherPersonInfo.Char[index].CharId
  else
    return nil
  end
  local ElmtType = DataMgr.BattleChar[CharId].Attribute
  local IconName = "Armory_" .. ElmtType
  local AttributeIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
  local Rarity = DataMgr.Char[CharId].CharRarity
  local Name = DataMgr.Char[CharId].CharName
  if not self:IsOwener() and (160101 == CharId or 1601 == CharId) and self.OtherPersonInfo and self.OtherPersonInfo.Nickname then
    Name = self.OtherPersonInfo.Nickname
  end
  local CharData = {
    AttributeIcon = AttributeIcon,
    Rarity = Rarity,
    Name = Name
  }
  return CharData
end

function M:GetShowCharData(index)
  if self:IsOwener() then
    local CharData = self._Avatar.Chars[self._DisplayPlan.CharDisplayPlans[index].CharId]
    return CharData
  else
    for i, Char in pairs(self._fakeAvatar.Chars) do
      if Char.CharId == self.OtherBattleDumpInfo.Char[index].RoleId then
        return Char
      end
    end
    ScreenPrint("未找到对应的武器数据" .. debug.traceback())
    return self._fakeAvatar.Chars[index]
  end
end

function M:GetShowWeaponData(index)
  if -1 == index then
    return nil
  end
  if self:IsOwener() then
    local WeaponData = self._Avatar.Weapons[self._DisplayPlan.WeaponDisplayPlans[index].WeaponId]
    return WeaponData
  else
    for i, weapon in pairs(self._fakeAvatar.Weapons) do
      if weapon.WeaponId == self.OtherBattleDumpInfo.Weapon[index].WeaponId then
        return weapon
      end
    end
    ScreenPrint("未找到对应的武器数据" .. debug.traceback())
  end
end

function M:IsOwener()
  if self._PersonID ~= nil then
    return false
  else
    return true
  end
end

function M:GetPersonalBaseInfo()
  local _ModelInfo = {}
  if self:IsOwener() then
    _ModelInfo.PlayerName = self._Avatar.Nickname
    _ModelInfo.PlayerSignature = self._Avatar.Signature
    _ModelInfo.CurrentLevel = self._Avatar.Level
    _ModelInfo.HeadIconId = self._Avatar.HeadIconId
    _ModelInfo.HeadFrameId = self._Avatar.HeadFrameId
    _ModelInfo.Uid = self._Avatar.Uid
    _ModelInfo.IsOwner = true
    _ModelInfo.TitleFrame = self._Avatar.TitleFrame
    _ModelInfo.TitleAfter = self._Avatar.TitleAfter
    _ModelInfo.TitleBefore = self._Avatar.TitleBefore
    self:FillOwnerGuildBaseInfo(_ModelInfo, self._Avatar)
  else
    _ModelInfo.PlayerName = self.OtherPersonInfo.Nickname
    _ModelInfo.PlayerSignature = self.OtherPersonInfo.Signature
    _ModelInfo.CurrentLevel = self.OtherPersonInfo.Level
    _ModelInfo.HeadIconId = self.OtherPersonInfo.HeadIconId
    _ModelInfo.HeadFrameId = self.OtherPersonInfo.HeadFrameId
    _ModelInfo.Uid = self.OtherPersonInfo.Uuid
    _ModelInfo.TitleFrame = self.OtherPersonInfo.TitleFrame
    _ModelInfo.TitleAfter = self.OtherPersonInfo.TitleAfter
    _ModelInfo.TitleBefore = self.OtherPersonInfo.TitleBefore
    self:FillGuildBaseInfo(_ModelInfo, self.OtherPersonInfo)
  end
  return _ModelInfo
end

function M:GetPersonalInfoBackground()
  local BackgroundId
  if self:IsOwener() then
    BackgroundId = self._Avatar.PersonalInfo.BackgroundIds and self._Avatar.PersonalInfo.BackgroundIds[CommonConst.PersonalInfoBgType.PersonalInfo] or nil
  else
    BackgroundId = self.OtherPersonInfo.BackgroundIds and self.OtherPersonInfo.BackgroundIds[CommonConst.PersonalInfoBgType.PersonalInfo] or nil
  end
  if BackgroundId and -1 ~= BackgroundId then
    local BgConfig = DataMgr.Background[BackgroundId]
    if BgConfig then
      return BgConfig.PersonalInfoWidget or nil
    end
  end
  return nil
end

function M:GetCustomDisplaySceneId()
  local DefaultSceneId = 101
  if self:IsOwener() then
    local PersonalInfo = self._Avatar and self._Avatar.PersonalInfo or nil
    local CustomDisplay = PersonalInfo and PersonalInfo.CustomDisplay or nil
    return CustomDisplay and CustomDisplay.SceneId or DefaultSceneId
  end
  local CustomDisplay = self.OtherPersonInfo and self.OtherPersonInfo.CustomDisplay or nil
  return CustomDisplay and CustomDisplay.SceneId or DefaultSceneId
end

function M:GetOwnedCustomDisplaySceneIdList()
  if not self:IsOwener() then
    return {}
  end
  local Avatar = self._Avatar or GWorld:GetAvatar()
  local SceneIdList = Avatar and Avatar.PersonalInfoSceneList or nil
  local Result = {}
  for _, SceneId in ipairs(SceneIdList or {}) do
    if type(SceneId) == "number" then
      Result[#Result + 1] = SceneId
    end
  end
  return Result
end

function M:GetOwnedCustomDisplayGestureIdList()
  if not self:IsOwener() then
    return {}
  end
  local Avatar = self._Avatar or GWorld:GetAvatar()
  local GestureIdList = Avatar and Avatar.PersonalInfoGestureList or nil
  local Result = {}
  for _, PoseId in ipairs(GestureIdList or {}) do
    if type(PoseId) == "number" then
      Result[#Result + 1] = PoseId
    end
  end
  return Result
end

function M:HasOwnedCustomDisplayScene(SceneId)
  if not self:IsOwener() then
    return true
  end
  if type(SceneId) ~= "number" then
    return false
  end
  for _, OwnedSceneId in ipairs(self:GetOwnedCustomDisplaySceneIdList()) do
    if OwnedSceneId == SceneId then
      return true
    end
  end
  return false
end

function M:HasOwnedCustomDisplayGesture(PoseId)
  if not self:IsOwener() then
    return true
  end
  if type(PoseId) ~= "number" then
    return false
  end
  for _, OwnedPoseId in ipairs(self:GetOwnedCustomDisplayGestureIdList()) do
    if OwnedPoseId == PoseId then
      return true
    end
  end
  return false
end

function M:GetFirstOwnedCustomDisplaySceneId(FallbackSceneId)
  if not self:IsOwener() then
    return FallbackSceneId or self:GetCustomDisplaySceneId()
  end
  if type(FallbackSceneId) == "number" and self:HasOwnedCustomDisplayScene(FallbackSceneId) then
    return FallbackSceneId
  end
  local CurrentSceneId = self:GetCustomDisplaySceneId()
  if self:HasOwnedCustomDisplayScene(CurrentSceneId) then
    return CurrentSceneId
  end
  local SceneIdList = self:GetOwnedCustomDisplaySceneIdList()
  if #SceneIdList > 0 then
    return SceneIdList[1]
  end
  return FallbackSceneId or CurrentSceneId or 101
end

local function BuildTransformFromServerParam(ParamInfo)
  if not ParamInfo then
    return nil
  end
  local Position = ParamInfo.Position
  local Rotation = ParamInfo.Rotation
  if type(Position) ~= "table" and type(Rotation) ~= "table" then
    return nil
  end
  local Location = FVector(Position and Position[1] or 0, Position and Position[2] or 0, Position and Position[3] or 0)
  local Rotator = FRotator(Rotation and Rotation[2] or 0, Rotation and Rotation[3] or 0, Rotation and Rotation[1] or 0)
  return FTransform(Rotator:ToQuat(), Location, FVector(1, 1, 1))
end

local function BuildTransformRotationFromServerParam(ParamInfo)
  local Rotation = ParamInfo and ParamInfo.Rotation or nil
  if type(Rotation) ~= "table" then
    return nil
  end
  return {
    Roll = Rotation[1] or 0,
    Pitch = Rotation[2] or 0,
    Yaw = Rotation[3] or 0
  }
end

local function BuildCameraDataFromServerParam(CameraParam)
  if not CameraParam then
    return nil
  end
  local Position = CameraParam.Position
  local Rotation = CameraParam.Rotation
  if type(Position) ~= "table" or type(Rotation) ~= "table" then
    return nil
  end
  if nil == Position[1] or nil == Position[2] or nil == Position[3] or nil == Rotation[1] or nil == Rotation[2] or nil == Rotation[3] then
    return nil
  end
  local PositionX = Position and Position[1] or 0
  local PositionY = Position and Position[2] or 0
  local PositionZ = Position and Position[3] or 0
  local RotationRoll = Rotation and Rotation[1] or 0
  local RotationPitch = Rotation and Rotation[2] or 0
  local RotationYaw = Rotation and Rotation[3] or 0
  if 0 == PositionX and 0 == PositionY and 0 == PositionZ and 0 == RotationRoll and 0 == RotationPitch and 0 == RotationYaw then
    DebugPrint("PersonInfoModel: ignore zero camera param from server")
    return nil
  end
  local LocalPosition = {
    X = PositionX,
    Y = PositionY,
    Z = PositionZ
  }
  local LocalRotation = {
    Roll = RotationRoll,
    Pitch = RotationPitch,
    Yaw = RotationYaw
  }
  return {
    LocalPosition = LocalPosition,
    LocalRotation = LocalRotation,
    Offset = {
      Horizontal = LocalPosition.Y or 0,
      Vertical = LocalPosition.Z or 0
    },
    Distance = LocalPosition.X or 0,
    Rotation = {
      Pitch = LocalRotation.Pitch or 0,
      Yaw = LocalRotation.Yaw or 0
    },
    HasCustomCamera = true
  }
end

local function BuildCharacterActionFromServerParam(CharParam)
  if not CharParam then
    return nil
  end
  local PoseId = CharParam.PoseId
  if nil == PoseId then
    return nil
  end
  local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if not GestureConfig then
    return nil
  end
  local ReleaseWheel = GestureConfig.ReleaseWheel
  if ReleaseWheel and 0 ~= ReleaseWheel then
    local Resource = DataMgr.Resource and DataMgr.Resource[ReleaseWheel] or nil
    return {
      PoseId = PoseId,
      Mode = DisplayTypes.AnimMode.Montage,
      GestureTag = GestureConfig.GestureTag or "Gesture",
      ReleaseWheel = ReleaseWheel,
      ResourceId = ReleaseWheel,
      MontagePath = Resource and Resource.PlayAnim or nil
    }
  end
  return {
    PoseId = PoseId,
    Mode = DisplayTypes.AnimMode.Sequence,
    GestureTag = GestureConfig.GestureTag or "Pose",
    Document = GestureConfig.Document,
    PoseName = GestureConfig.PoseName
  }
end

local function BuildDefaultWeaponActionFromWeaponData(WeaponData)
  if not WeaponData then
    return nil
  end
  local PoseTag = "Melee"
  if WeaponData.HasTag and WeaponData:HasTag("Ranged") then
    PoseTag = "Ranged"
  end
  return {PoseTag = PoseTag}
end

local function NormalizeCustomDisplayInfo(CustomDisplayInfo)
  if type(CustomDisplayInfo) ~= "table" then
    return CustomDisplayInfo
  end
  local CharParamGroup = CustomDisplayInfo.CharParamGroup
  if type(CharParamGroup) == "table" then
    for _, CharParam in ipairs(CharParamGroup) do
      if type(CharParam) == "table" then
        local PoseId = CharParam.PoseId
        local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
        if not GestureConfig then
          CharParam.PoseId = nil
        end
      end
    end
  end
  return CustomDisplayInfo
end

function M:_FindOwnerCharByCharId(CharId)
  if not self._Avatar or not CharId then
    return nil, nil
  end
  CharId = tonumber(CharId)
  for Uuid, CharData in pairs(self._Avatar.Chars or {}) do
    if CharData and tonumber(CharData.CharId) == CharId then
      return CharData, Uuid
    end
  end
  return nil, nil
end

function M:_FindOwnerWeaponByWeaponId(WeaponId)
  if not self._Avatar or not WeaponId then
    return nil
  end
  WeaponId = tonumber(WeaponId)
  for _, WeaponData in pairs(self._Avatar.Weapons or {}) do
    if WeaponData and tonumber(WeaponData.WeaponId) == WeaponId then
      return WeaponData
    end
  end
  return nil
end

function M:_FindFakeCharByCharId(CharId)
  if not CharId then
    return nil
  end
  CharId = tonumber(CharId)
  local Avatar = self:GetFakeAvatar()
  for _, CharData in pairs(Avatar and Avatar.Chars or {}) do
    if CharData and tonumber(CharData.CharId) == CharId then
      return CharData
    end
  end
  return nil
end

function M:_FindFakeWeaponByWeaponId(WeaponId)
  if not WeaponId then
    return nil
  end
  WeaponId = tonumber(WeaponId)
  local Avatar = self:GetFakeAvatar()
  for _, WeaponData in pairs(Avatar and Avatar.Weapons or {}) do
    if WeaponData and tonumber(WeaponData.WeaponId) == WeaponId then
      return WeaponData
    end
  end
  return nil
end

function M:_GetOwnerAppearanceByDisplay(CharUuid, DisplayUnit)
  if not CharUuid or not self._Avatar then
    return nil
  end
  local CharData = self._Avatar.Chars and self._Avatar.Chars[CharUuid] or nil
  if not CharData then
    return nil
  end
  local ResolvedDisplayUnit = DisplayUnit
  if not ResolvedDisplayUnit then
    local PersonalInfo = self._Avatar.PersonalInfo
    local CharDisplayList = PersonalInfo and PersonalInfo.CharDisplay or nil
    local DisplayCount = CharDisplayList and CharDisplayList.Length and CharDisplayList:Length() or 0
    for Index = 1, DisplayCount do
      local Candidate = CharDisplayList:Get(Index)
      if Candidate and Candidate.Id == CharUuid then
        ResolvedDisplayUnit = Candidate
        break
      end
    end
  end
  local AppearancePlan = ResolvedDisplayUnit and ResolvedDisplayUnit.AppearancePlan or nil
  if AppearancePlan and AppearancePlan > 0 then
    return CharData:DumpAppearanceSuit(self._Avatar, AppearancePlan)
  end
  return nil
end

function M:_GetOtherCustomDisplayAppearance(CharId, SlotIndex)
  local CustomDisplay = self.OtherPersonInfo and self.OtherPersonInfo.CustomDisplay or nil
  local CharParamGroup = CustomDisplay and CustomDisplay.CharParamGroup or nil
  if not CharParamGroup then
    return nil
  end
  local CharParam = CharParamGroup[SlotIndex]
  if CharParam and CharParam.CharId == CharId then
    return CharParam.Appearance
  end
  return nil
end

function M:_ConvertServerAppearanceToSuit(ServerAppearance)
  if not ServerAppearance then
    return nil
  end
  local CurrentPlanIndex = ServerAppearance.CurrentPlanIndex or 1
  local CurrentHairPlanIndex = ServerAppearance.CurrentHairPlanIndex or 1
  local SkinColors = ServerAppearance.SkinColors or {}
  local HairColors = ServerAppearance.HairColors or {}
  local AccessorySuit = {}
  for AccessoryTypeIndex, AccessoryId in pairs(ServerAppearance.Accessory or {}) do
    local NumericAccessoryId = tonumber(AccessoryId)
    if NumericAccessoryId and NumericAccessoryId > 0 then
      AccessorySuit[AccessoryTypeIndex] = NumericAccessoryId
    end
  end
  
  local function ResolveColorPlan(Colors, PlanIndex)
    local PlanColors = Colors[PlanIndex]
    if type(PlanColors) == "table" then
      return PlanColors
    end
    return Colors
  end
  
  return {
    SkinId = ServerAppearance.SkinId,
    SkinLevel = ServerAppearance.SkinSelectedLevel or ServerAppearance.SkinLevel or 1,
    HairId = ServerAppearance.HairId,
    Colors = ResolveColorPlan(SkinColors, CurrentPlanIndex),
    HairColors = ResolveColorPlan(HairColors, CurrentHairPlanIndex),
    AccessorySuit = AccessorySuit,
    AccessoryCustomParams = ServerAppearance.AccessoryCustomParams or {},
    IsShowPartMesh = ServerAppearance.IsShowPartMesh,
    IsCornerVisible = ServerAppearance.IsCornerVisible,
    CurrentPlanIndex = CurrentPlanIndex,
    CharId = ServerAppearance.CharId
  }
end

function M:GetDisplayPreviewSourceSlots()
  local Slots = {}
  if self:IsOwener() then
    local PersonalInfo = self._Avatar and self._Avatar.PersonalInfo or nil
    local CharDisplayList = PersonalInfo and PersonalInfo.CharDisplay or nil
    local WeaponDisplayList = PersonalInfo and PersonalInfo.WeaponDisplay or nil
    for SlotIndex = 1, 3 do
      local CharDisplay = CharDisplayList and CharDisplayList.Get and CharDisplayList:Get(SlotIndex) or nil
      local CharUuid = CharDisplay and CharDisplay.Id or nil
      local CharData = CharUuid and self._Avatar and self._Avatar.Chars and self._Avatar.Chars[CharUuid] or nil
      if CharData then
        local WeaponDisplay = WeaponDisplayList and WeaponDisplayList.Get and WeaponDisplayList:Get(SlotIndex) or nil
        local WeaponUuid = WeaponDisplay and WeaponDisplay.Id or nil
        Slots[SlotIndex] = {
          CharData = CharData,
          Avatar = self._Avatar,
          WeaponData = WeaponUuid and self._Avatar.Weapons and self._Avatar.Weapons[WeaponUuid] or nil,
          Appearance = self:_GetOwnerAppearanceByDisplay(CharUuid, CharDisplay)
        }
      end
    end
    return Slots
  end
  for SlotIndex = 1, 3 do
    local CharInfo = self.OtherPersonInfo and self.OtherPersonInfo.Char and self.OtherPersonInfo.Char[SlotIndex] or nil
    if CharInfo and CharInfo.CharId then
      local WeaponInfo = self.OtherPersonInfo and self.OtherPersonInfo.Weapon and self.OtherPersonInfo.Weapon[SlotIndex] or nil
      local ServerAppearance = self:_GetOtherCustomDisplayAppearance(CharInfo.CharId, SlotIndex) or CharInfo.Appearance
      Slots[SlotIndex] = {
        CharData = self:_FindFakeCharByCharId(CharInfo.CharId),
        Avatar = self:GetFakeAvatar(),
        WeaponData = WeaponInfo and WeaponInfo.WeaponId and self:_FindFakeWeaponByWeaponId(WeaponInfo.WeaponId) or nil,
        Appearance = ServerAppearance and self:_ConvertServerAppearanceToSuit(ServerAppearance) or nil
      }
    end
  end
  return Slots
end

function M:GetCustomDisplayDraft()
  local PersonalInfo
  if self:IsOwener() then
    PersonalInfo = self._Avatar and self._Avatar.PersonalInfo or nil
  else
    PersonalInfo = self.OtherPersonInfo
  end
  local CustomDisplay = PersonalInfo and PersonalInfo.CustomDisplay or nil
  if not CustomDisplay then
    return nil
  end
  CustomDisplay = NormalizeCustomDisplayInfo(CustomDisplay)
  local Draft = DisplayDraft:CreateEmpty(CustomDisplay.SceneId)
  local Avatar = self:IsOwener() and self._Avatar or self:GetFakeAvatar()
  for SlotIndex, CharParam in ipairs(CustomDisplay.CharParamGroup or {}) do
    local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
    local CharData, CharUuid
    if CharParam and CharParam.CharId then
      if self:IsOwener() then
        CharData, CharUuid = self:_FindOwnerCharByCharId(CharParam.CharId)
      else
        CharData = self:_FindFakeCharByCharId(CharParam.CharId)
      end
    end
    if CharData then
      Slot.CharData = CharData
      Slot.Avatar = Avatar
      Slot.Transform = BuildTransformFromServerParam(CharParam)
      Slot.TransformRotation = BuildTransformRotationFromServerParam(CharParam)
      Slot.Action = BuildCharacterActionFromServerParam(CharParam)
      if self:IsOwener() then
        local DisplayUnit
        if (CharParam.AppearancePlan or 0) > 0 then
          DisplayUnit = {
            AppearancePlan = CharParam.AppearancePlan
          }
        end
        Slot.Appearance = self:_GetOwnerAppearanceByDisplay(CharUuid, DisplayUnit)
      elseif CharParam.Appearance then
        Slot.Appearance = self:_ConvertServerAppearanceToSuit(CharParam.Appearance)
      end
      local CharParamWeaponId = tonumber(CharParam.WeaponId)
      if CharParamWeaponId and 0 ~= CharParamWeaponId then
        if self:IsOwener() then
          Slot.WeaponData = self:_FindOwnerWeaponByWeaponId(CharParamWeaponId)
        else
          Slot.WeaponData = self:_FindFakeWeaponByWeaponId(CharParamWeaponId)
        end
      end
      if Slot.WeaponData and Slot.Action == nil then
        Slot.Action = BuildDefaultWeaponActionFromWeaponData(Slot.WeaponData)
      end
    end
  end
  Draft.Camera = BuildCameraDataFromServerParam(CustomDisplay.CameraParam) or Draft.Camera
  return Draft
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetWeaponUuid()
  return self._Avatar.WeaponUuid
end

function M:GetHeadIcon()
  local HeadFrameId = self._ModelInfo.HeadIconId
  if HeadFrameId then
    if -1 == HeadFrameId then
      return nil
    else
      local Path = DataMgr.HeadFrame[HeadFrameId].SmallIcon
      local ImageResource = LoadObject(Path)
      return ImageResource
    end
  end
end

function M:GetDisplayItemsUuid(bisweapon, index)
  local str
  if true == bisweapon then
    str = "Weapon"
  else
    str = "Char"
  end
  local uuid = self._DisplayPlan[str .. "DisplayPlans"][index][str .. "Id"]
  return uuid
end

function M:GetTemporModelPlan(bisweapon, index, Plans)
  local str, tempplans
  if true == bisweapon then
    str = "Weapon"
    tempplans = Plans.TempWeaponShowPlan
  else
    str = "Char"
    tempplans = Plans.TempCharShowPlan
  end
  if nil ~= tempplans and tempplans[index] then
    local plan = tempplans[index]
    return plan
  else
    return self._DisplayPlan[str .. "DisplayPlans"][index]
  end
end

function M:GetTemporModelBoxItemData(bisweapon, index, Plans)
  local data = self:GetTempEditBoxItemData(bisweapon, index, Plans)
  if -1 == data then
    return nil
  end
  if nil == data then
    return self:GetEditBoxItemData(bisweapon, index)
  end
  return data
end

function M:GetEditBoxItemData(bisweapon, index)
  local str
  if true == bisweapon then
    str = "Weapon"
  else
    str = "Char"
  end
  local uuid = self._DisplayPlan[str .. "DisplayPlans"][index][str .. "Id"]
  if -1 == uuid then
    return nil
  end
  local id = self._Avatar[str .. "s"][uuid][str .. "Id"]
  local data = {}
  local IconPath = DataMgr[str][id].GachaIcon
  data.image = LoadObject(IconPath)
  data.name = DataMgr[str][id][str .. "Name"]
  data.lv = self._Avatar[str .. "s"][uuid].Level
  local Rarity = DataMgr[str][id][str .. "Rarity"]
  data.Rarity = Rarity
  if bisweapon then
    data.Tag = self._Avatar[str .. "s"][uuid].WeaponTag
  end
  data.Uuid = uuid
  return data
end

function M:GetTempEditBoxItemData(bisweapon, index, Plans)
  local str, tempplan
  if true == bisweapon then
    str = "Weapon"
    tempplan = Plans.TempWeaponShowPlan
  else
    str = "Char"
    tempplan = Plans.TempCharShowPlan
  end
  local uuid
  if nil ~= tempplan and tempplan[index] then
    uuid = tempplan[index][str .. "Id"]
  end
  if -1 == uuid then
    return -1
  elseif nil == uuid then
    return nil
  end
  local id = self._Avatar[str .. "s"][uuid][str .. "Id"]
  local data = {}
  local IconPath = DataMgr[str][id].GachaIcon
  data.image = LoadObject(IconPath)
  data.name = DataMgr[str][id][str .. "Name"]
  data.lv = self._Avatar[str .. "s"][uuid].Level
  local Rarity = DataMgr[str][id][str .. "Rarity"]
  data.Rarity = Rarity
  if bisweapon then
    data.Tag = self._Avatar[str .. "s"][uuid].WeaponTag
  end
  data.Uuid = uuid
  return data
end

function M:GetItemName(bisweapon, content)
  local str
  if bisweapon then
    str = "Weapon"
  else
    str = "Char"
  end
  local id = content.UnitId
  return DataMgr[str][id][str .. "Name"]
end

function M:GetItemUuid(content)
  local id = content.Uuid
  return id
end

function M:SaveShowPlan(TempCharShowPlan, TempWeaponShowPlan)
  local strs = {"Char", "Weaqpon"}
  if nil ~= TempCharShowPlan then
    for i = 1, 3 do
      if nil ~= TempCharShowPlan[i] then
        local Plan = TempCharShowPlan[i]
        self:LocalUpdateCharDisplay(i, Plan.CharId, Plan.AppearancePlan, Plan.ModPlan)
      end
    end
    self:SortCharDisplay()
    for i = 1, 3 do
      if nil ~= self._DisplayPlan.CharDisplayPlans[i] then
        local Plan = self._DisplayPlan.CharDisplayPlans[i]
        if -1 ~= Plan.CharId and self._Avatar.PersonalInfo.CharDisplay[i] then
          self._Avatar:UpdateCharDisplay(self.ReallyUpdate, i, Plan.CharId, Plan.AppearancePlan, Plan.ModPlan)
        elseif -1 ~= Plan.CharId and not self._Avatar.PersonalInfo.CharDisplay[i] then
          self._Avatar:AddCharDisplay(self.ReallyUpdate, Plan.CharId, Plan.AppearancePlan, Plan.ModPlan)
        end
      end
    end
    for i = 3, 1, -1 do
      if nil ~= self._DisplayPlan.CharDisplayPlans[i] then
        local Plan = self._DisplayPlan.CharDisplayPlans[i]
        if -1 == Plan.CharId and self._Avatar.PersonalInfo.CharDisplay[i] then
          self._Avatar:RemoveCharDisplay(self.ReallyUpdate, i)
        end
      end
    end
  end
  if nil ~= TempWeaponShowPlan then
    for i = 1, 3 do
      if nil ~= TempWeaponShowPlan[i] then
        local Plan = TempWeaponShowPlan[i]
        self:LocalUpdateWeaponDisplay(i, Plan.WeaponId, Plan.ModPlan)
      end
    end
    self:SortWeaponDisplay()
    for i = 1, 3 do
      if nil ~= self._DisplayPlan.WeaponDisplayPlans[i] then
        local Plan = self._DisplayPlan.WeaponDisplayPlans[i]
        if -1 ~= Plan.WeaponId and self._Avatar.PersonalInfo.WeaponDisplay[i] then
          self._Avatar:UpdateWeaponDisplay(self.ReallyUpdate, i, Plan.WeaponId, Plan.ModPlan)
        elseif -1 ~= Plan.WeaponId and not self._Avatar.PersonalInfo.WeaponDisplay[i] then
          self._Avatar:AddWeaponDisplay(self.ReallyUpdate, Plan.WeaponId, Plan.ModPlan)
        end
      end
    end
    for i = 3, 1, -1 do
      if nil ~= self._DisplayPlan.WeaponDisplayPlans[i] then
        local Plan = self._DisplayPlan.WeaponDisplayPlans[i]
        if -1 == Plan.WeaponId and self._Avatar.PersonalInfo.WeaponDisplay[i] then
          self._Avatar:RemoveWeaponDisplay(self.ReallyUpdate, i)
        end
      end
    end
  end
end

function M:SaveCustomDisplay(CustomDisplayInfo, Callback)
  if not self:IsOwener() then
    DebugPrint("SaveCustomDisplay only owner can save")
    return false
  end
  if not self._Avatar or not CustomDisplayInfo then
    DebugPrint("SaveCustomDisplay Invalid arguments")
    return false
  end
  CustomDisplayInfo = NormalizeCustomDisplayInfo(CustomDisplayInfo)
  
  local function OnSaveCallback(ret)
    local bSuccess = ErrorCode:Check(ret)
    if bSuccess and self._Avatar and self._Avatar.PersonalInfo then
      self._Avatar.PersonalInfo.CustomDisplay = PersonalInfoCustomTypes.PersonalInfoCustomDisplay(CustomDisplayInfo)
    end
    if Callback then
      Callback(ret)
    end
  end
  
  self._Avatar:SetCustomDisplay(OnSaveCallback, CustomDisplayInfo)
  return true
end

function M:SaveCustomDisplayDraft(DisplayEditor, Callback)
  local SaveData = DisplayEditor and DisplayEditor.ExportSaveData and DisplayEditor:ExportSaveData() or nil
  if not SaveData then
    DebugPrint("SaveCustomDisplayDraft Invalid arguments")
    return false
  end
  local CharParamGroup = SaveData.CharParamGroup or {}
  DebugPrint(string.format("PersonInfoSaveCustomDisplay: SceneId=%s CharCount=%s", tostring(SaveData.SceneId), tostring(#CharParamGroup)))
  for Index, CharParam in ipairs(CharParamGroup) do
    local Position = CharParam.Position or {}
    local Rotation = CharParam.Rotation or {}
    DebugPrint(string.format("PersonInfoSaveCustomDisplay: slot=%s CharId=%s AppearancePlan=%s WeaponId=%s PoseId=%s Pos=(%s,%s,%s) Rot=(%s,%s,%s)", tostring(Index), tostring(CharParam.CharId), tostring(CharParam.AppearancePlan), tostring(CharParam.WeaponId), tostring(CharParam.PoseId), tostring(Position[1]), tostring(Position[2]), tostring(Position[3]), tostring(Rotation[1]), tostring(Rotation[2]), tostring(Rotation[3])))
  end
  return self:SaveCustomDisplay(SaveData, Callback)
end

function M:GetDisplayCharInfos()
  local CharInfos = {}
  if self:IsOwener() then
    local Avatar = GWorld:GetAvatar()
    for index = 1, 3 do
      if -1 == self._DisplayPlan.CharDisplayPlans[index].CharId then
        return CharInfos
      end
      local Char = self._Avatar.Chars[self._DisplayPlan.CharDisplayPlans[index].CharId]
      local ExtraModSuitIndex = self._DisplayPlan.CharDisplayPlans[index].ModPlan
      local AppearanceIndex = self._DisplayPlan.CharDisplayPlans[index].AppearancePlan
      local CharInfo = AvatarUtils:GetCharBattleInfo(Avatar, Char, ExtraModSuitIndex).RoleInfo
      CharInfo.AppearanceSuit = Char:DumpAppearanceSuit(Avatar, AppearanceIndex)
      table.insert(CharInfos, CharInfo)
    end
  else
    CharInfos = self.OtherBattleDumpInfo.Char
  end
  return CharInfos
end

function M:GetDisplayWeaponInfos()
  local WeaponInfos = {}
  if self:IsOwener() then
    local Avatar = GWorld:GetAvatar()
    for index = 1, 3 do
      if -1 == self._DisplayPlan.WeaponDisplayPlans[index].WeaponId then
        return WeaponInfos
      end
      local Weapon = self._Avatar.Weapons[self._DisplayPlan.WeaponDisplayPlans[index].WeaponId]
      local ExtraModSuitIndex = self._DisplayPlan.WeaponDisplayPlans[index].ModPlan
      local AvatarInfo = AvatarUtils:GetWeaponBattleInfo(Avatar, Weapon, ExtraModSuitIndex)
      local WeaponInfo
      if Weapon:IsMelee() then
        WeaponInfo = AvatarInfo.MeleeWeapon
      else
        WeaponInfo = AvatarInfo.RangedWeapon
      end
      table.insert(WeaponInfos, WeaponInfo)
    end
  else
    WeaponInfos = self.OtherBattleDumpInfo.Weapon
  end
  return WeaponInfos
end

function M:GetAvatarForgeLevel()
  local WeaponForgeLevel = 0
  if self:IsOwener() then
    local Avatar = GWorld:GetAvatar()
    WeaponForgeLevel = Avatar.WeaponForgeLevel
  else
    WeaponForgeLevel = self.OtherBattleDumpInfo.WeaponForgeLevel
  end
  return WeaponForgeLevel
end

function M:ChangeToCharBattleDumpInfo(CharInfos)
  local Chars = {}
  for i, CharInfo in ipairs(CharInfos) do
    local Appearance = CharInfo.Appearance or {}
    local CurrentPlanIndex = Appearance.CurrentPlanIndex or 1
    local AppearanceSuit = {
      Colors = Appearance.SkinColors and Appearance.SkinColors[CurrentPlanIndex],
      SkinId = Appearance.SkinId,
      SkinLevel = Appearance.SkinSelectedLevel or Appearance.SkinLevel or 1,
      AccessorySuit = Appearance.Accessory or {},
      AccessoryCustomParams = Appearance.AccessoryCustomParams or {},
      HairId = Appearance.HairId,
      HairColors = Appearance.HairColors,
      IsShowPartMesh = Appearance.IsShowPartMesh,
      IsCornerVisible = Appearance.IsCornerVisible,
      CharId = CharInfo.CharId
    }
    local SkillInfos = {}
    for _, Skill in ipairs(CharInfo.Skills) do
      if 1 ~= Skill.LockState then
        local bOnlyPhantom = false
        local SkillData = DataMgr.Skill[Skill.SkillId][Skill.Level][CharInfo.GradeLevel]
        if SkillData then
          bOnlyPhantom = SkillData.OnlyPhantom
        end
        if bOnlyPhantom then
        else
          local SkillInfo = {}
          SkillInfo.Level = Skill.Level
          SkillInfo.ExtraLevel = Skill.ExtraLevel
          if 0 ~= CharInfo.GradeLevel then
            SkillInfo.Grade = CharInfo.GradeLevel
          end
          table.insert(SkillInfos, {
            SkillId = Skill.SkillId,
            SkillInfo = SkillInfo
          })
        end
      end
    end
    local SlotData = {}
    local ModData = {}
    for Index, ModSuit in ipairs(CharInfo.ModSuit) do
      table.insert(SlotData, {
        ModEid = ModSuit.Mod and ModSuit.Mod.ModId or nil,
        SlotId = Index,
        Polarity = ModSuit.Polarity
      })
      if ModSuit.Mod then
        table.insert(ModData, {
          Uuid = ModSuit.Mod.ModId,
          ModId = ModSuit.Mod.ModId,
          Level = ModSuit.Mod.Level,
          CurrentModCardLevel = ModSuit.Mod.CurrentModCardLevel
        })
      end
    end
    local Char = {
      AppearanceSuit = AppearanceSuit,
      RoleId = CharInfo.CharId,
      Level = CharInfo.Level,
      GradeLevel = CharInfo.GradeLevel,
      EnhanceLevel = CharInfo.EnhanceLevel,
      SkillInfos = SkillInfos,
      SlotData = SlotData,
      ModData = ModData,
      SkillTreeInfos = CharInfo.SkillTree,
      ModSuitIndex = 1
    }
    table.insert(Chars, Char)
  end
  return Chars
end

function M:ChangeToWeaponBattleDumpInfo(WeaponInfos)
  local Weapons = {}
  for i, WeaponInfo in ipairs(WeaponInfos) do
    local AppearanceInfo = {
      SkinId = WeaponInfo.Appearance.SkinId,
      AccessoryId = WeaponInfo.Appearance.Accessory[1],
      Colors = {
        Colors = WeaponInfo.Appearance.SkinColors[WeaponInfo.Appearance.CurrentPlanIndex],
        SpecialColor = WeaponInfo.Appearance.SpecialColor[WeaponInfo.Appearance.CurrentPlanIndex]
      }
    }
    local SlotData = {}
    local ModData = {}
    for Index, ModSuit in ipairs(WeaponInfo.ModSuit) do
      table.insert(SlotData, {
        ModEid = ModSuit.Mod and ModSuit.Mod.ModId or nil,
        SlotId = Index,
        Polarity = ModSuit.Polarity
      })
      if ModSuit.Mod then
        table.insert(ModData, {
          Uuid = ModSuit.Mod.ModId,
          ModId = ModSuit.Mod.ModId,
          Level = ModSuit.Mod.Level,
          CurrentModCardLevel = ModSuit.Mod.CurrentModCardLevel
        })
      end
    end
    local Weapon = {
      AppearanceInfo = AppearanceInfo,
      WeaponId = WeaponInfo.WeaponId,
      Level = WeaponInfo.Level,
      GradeLevel = WeaponInfo.GradeLevel,
      HyperCardLevel = WeaponInfo.HyperCardLevel,
      EnhanceLevel = WeaponInfo.EnhanceLevel,
      SlotData = SlotData,
      ModData = ModData,
      ModSuitIndex = 1,
      HyperTalent = WeaponInfo.HyperTalent
    }
    table.insert(Weapons, Weapon)
  end
  return Weapons
end

function M:LocalUpdateCharDisplay(index, CharId, AppearancePlan, ModPlan)
  self._DisplayPlan.CharDisplayPlans[index] = {
    CharId = CharId or -1,
    AppearancePlan = AppearancePlan or 1,
    ModPlan = ModPlan or 1
  }
end

function M:LocalUpdateWeaponDisplay(index, WeaponId, ModId)
  self._DisplayPlan.WeaponDisplayPlans[index] = {
    WeaponId = WeaponId or -1,
    ModPlan = ModId or 1
  }
end

function M:ReallyUpdate()
  DebugPrint("yklua66 SuccessCallback")
end

function M:SortCharDisplay()
  local j = 1
  for i = 1, #self._DisplayPlan.CharDisplayPlans do
    local temp = self._DisplayPlan.CharDisplayPlans[i]
    if nil ~= temp and -1 ~= temp.CharId then
      if i ~= j then
        self._DisplayPlan.CharDisplayPlans[j] = self._DisplayPlan.CharDisplayPlans[i]
        self._DisplayPlan.CharDisplayPlans[i] = {CharId = -1}
      end
      j = j + 1
    end
  end
  for k = j, #self._DisplayPlan.CharDisplayPlans do
    self._DisplayPlan.CharDisplayPlans[k] = {CharId = -1}
  end
end

function M:SortWeaponDisplay()
  local j = 1
  for i = 1, #self._DisplayPlan.WeaponDisplayPlans do
    local temp = self._DisplayPlan.WeaponDisplayPlans[i]
    if nil ~= temp and -1 ~= temp.WeaponId then
      if i ~= j then
        self._DisplayPlan.WeaponDisplayPlans[j] = self._DisplayPlan.WeaponDisplayPlans[i]
        self._DisplayPlan.WeaponDisplayPlans[i] = {WeaponId = -1}
      end
      j = j + 1
    end
  end
  for k = j, #self._DisplayPlan.WeaponDisplayPlans do
    self._DisplayPlan.WeaponDisplayPlans[k] = {WeaponId = -1}
  end
end

function M:GetAppearanceAndModPlan(bisweapon, index)
  local str, plan = "Char", self._DisplayPlan.CharDisplayPlans[index]
  if true == bisweapon then
    str = "Weapon"
    plan = self._DisplayPlan.WeaponDisplayPlans[index]
  end
  if nil ~= plan then
    if bisweapon then
      return 1, plan.ModPlan
    else
      return plan.AppearancePlan, plan.ModPlan
    end
  else
    return 1, 1
  end
end

function M:GetFakeAvatar()
  if self._fakeAvatar == nil then
    local CharInfos = {}
    local AddedCharIds = {}
    for i = 1, 3 do
      local DumpChar = self.OtherBattleDumpInfo.Char[i]
      if DumpChar then
        AddedCharIds[DumpChar.RoleId] = true
        CharInfos[#CharInfos + 1] = DumpChar
      end
    end
    local CustomDisplay = self.OtherPersonInfo and self.OtherPersonInfo.CustomDisplay or nil
    local CharParamGroup = CustomDisplay and CustomDisplay.CharParamGroup or nil
    local ExtraWeaponIds = {}
    if CharParamGroup then
      for _, CharParam in ipairs(CharParamGroup) do
        local CharId = CharParam and CharParam.CharId
        if CharId and not AddedCharIds[CharId] then
          AddedCharIds[CharId] = true
          CharInfos[#CharInfos + 1] = {
            RoleId = CharId,
            Level = 1,
            ModSuitIndex = 1
          }
        end
        local WeaponId = CharParam and tonumber(CharParam.WeaponId)
        if WeaponId and WeaponId > 0 then
          ExtraWeaponIds[WeaponId] = true
        end
      end
    end
    local WeaponInfos = {}
    local AddedWeaponIds = {}
    for i = 1, 3 do
      local DumpWeapon = self.OtherBattleDumpInfo.Weapon[i]
      if DumpWeapon then
        WeaponInfos[#WeaponInfos + 1] = DumpWeapon
        AddedWeaponIds[tonumber(DumpWeapon.WeaponId)] = true
      end
    end
    for WeaponId in pairs(ExtraWeaponIds) do
      if not AddedWeaponIds[WeaponId] then
        WeaponInfos[#WeaponInfos + 1] = {
          WeaponId = WeaponId,
          Level = 1,
          ModSuitIndex = 1,
          AppearanceInfo = {
            Colors = {},
            AccessoryId = -1
          }
        }
      end
    end
    ArmoryUtils:CreateDummyAvatar({
      CharInfos = CharInfos,
      WeaponInfos = WeaponInfos,
      WeaponForgeLevel = self.OtherBattleDumpInfo.WeaponForgeLevel
    })
    ArmoryUtils:SwitchPreviewTargetState(ArmoryUtils.PreviewTargetStates.Custom)
    local Avatar = ArmoryUtils:GetAvatar()
    self._fakeAvatar = Avatar
    return Avatar
  else
    return self._fakeAvatar
  end
end

function M:DeleteFakeAvatar()
  if self._fakeAvatar ~= nil then
    ArmoryUtils:DestroyDummyAvatar()
    self._fakeAvatar = nil
  end
end

function M:GetDataPageVisibility()
  if self:IsOwener() then
    ScreenPrint("不应该获取自己界面的可见性")
  else
    return self.OtherPersonInfo.Visible
  end
end

function M:ClearModel()
  self._ModelInfo = {}
  self._PersonID = nil
  self._DisplayPlan = {}
  self.OtherPersonInfo = nil
  self.OtherBattleDumpInfo = nil
end

function M:GetGuildWarHistoryBaseInfo()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return {}
  end
  if self:IsOwener() then
    return {
      Uid = Avatar.Uid,
      Nickname = Avatar.Nickname,
      Level = Avatar.Level,
      HeadIconId = Avatar.HeadIconId,
      HeadFrameId = Avatar.HeadFrameId,
      TitleBefore = Avatar.TitleBefore,
      TitleAfter = Avatar.TitleAfter,
      TitleFrame = Avatar.TitleFrame
    }
  end
  local Other = self.OtherPersonInfo or {}
  return {
    Uid = Other.Uuid,
    Nickname = Other.Nickname,
    Level = Other.Level,
    HeadIconId = Other.HeadIconId,
    HeadFrameId = Other.HeadFrameId,
    TitleBefore = Other.TitleBefore,
    TitleAfter = Other.TitleAfter,
    TitleFrame = Other.TitleFrame
  }
end

function M:BuildGuildWarHistoryTopN(BaseInfo, RankRecord)
  local List = {}
  for SeasonId, Record in pairs(RankRecord or {}) do
    local RankInfo = {}
    RankInfo.Uid = BaseInfo.Uid
    RankInfo.Nickname = BaseInfo.Nickname
    RankInfo.Level = BaseInfo.Level
    RankInfo.HeadFrameId = BaseInfo.HeadFrameId
    RankInfo.HeadIconId = BaseInfo.HeadIconId
    RankInfo.TitleBefore = BaseInfo.TitleBefore
    RankInfo.TitleAfter = BaseInfo.TitleAfter
    RankInfo.TitleFrame = BaseInfo.TitleFrame
    RankInfo.Score = Record.Score
    RankInfo.Rank = Record.Rank
    RankInfo.DisplayRank = Record.Rank
    RankInfo.MaxSquad = Record.Squad
    RankInfo.SeasonId = Record.SeasonId or SeasonId
    RankInfo.UpdateTime = Record.UpdateTime
    RankInfo.PreRaidGroupId = Record.PreRaidGroupId
    table.insert(List, RankInfo)
  end
  table.sort(List, function(a, b)
    local A = a.SeasonId or 0
    local B = b.SeasonId or 0
    if A == B then
      return (a.UpdateTime or 0) > (b.UpdateTime or 0)
    end
    return A > B
  end)
  return List
end

function M:BuildGuildWarHistorySelfRank(TopNInfo)
  if not TopNInfo or 0 == #TopNInfo then
    return {}
  end
  local First = TopNInfo[1]
  return {
    Rank = First.Rank,
    Score = First.Score,
    MaxSquad = First.MaxSquad,
    SeasonId = First.SeasonId,
    UpdateTime = First.UpdateTime,
    PreRaidGroupId = First.PreRaidGroupId
  }
end

function M:FillGuildBaseInfo(TargetInfo, SourceInfo)
  if type(TargetInfo) ~= "table" or type(SourceInfo) ~= "table" then
    return
  end
  TargetInfo.GuildId = tonumber(SourceInfo.GuildId or 0) or 0
  TargetInfo.GuildSimpleInfo = SourceInfo.GuildSimpleInfo
  TargetInfo.GuildName = SourceInfo.GuildName
  TargetInfo.GuildLogoInfo = SourceInfo.GuildLogoInfo
  TargetInfo.GuildLogo = SourceInfo.GuildLogo
end

function M:FillOwnerGuildBaseInfo(TargetInfo, Avatar)
  if type(TargetInfo) ~= "table" or type(Avatar) ~= "table" then
    return
  end
  TargetInfo.GuildId = tonumber(Avatar.GuildId or 0) or 0
  if TargetInfo.GuildId <= 0 then
    return
  end
  local CurrGuild = GuildController:GetModel():GetCurrGuild()
  if type(CurrGuild) ~= "table" then
    return
  end
  TargetInfo.GuildSimpleInfo = CurrGuild
  TargetInfo.GuildName = CurrGuild.Name
  TargetInfo.GuildLogoInfo = CurrGuild.LogoInfo
  TargetInfo.GuildLogo = CurrGuild.LogoInfo
end

local function GetGuildDisplayData(SourceInfo)
  if type(SourceInfo) ~= "table" then
    return 0, "", nil, nil
  end
  local GuildSimpleInfo = "table" == type(SourceInfo.GuildSimpleInfo) and SourceInfo.GuildSimpleInfo or nil
  local GuildId = tonumber(GuildSimpleInfo and (GuildSimpleInfo.GuildId or GuildSimpleInfo.GuildID or GuildSimpleInfo.Id) or SourceInfo.GuildId or SourceInfo.GuildID or 0) or 0
  local GuildName = GuildSimpleInfo and (GuildSimpleInfo.Name or GuildSimpleInfo.GuildName) or SourceInfo.GuildName or ""
  local GuildLogo = GuildSimpleInfo and (GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo or GuildSimpleInfo.GuildLogoInfo or GuildSimpleInfo.GuildLogo) or SourceInfo.GuildLogoInfo or SourceInfo.GuildLogo
  return GuildId, GuildName, GuildLogo, GuildSimpleInfo
end

function M:GetOtherPersonGuildId()
  if self:IsOwener() or type(self.OtherPersonInfo) ~= "table" then
    return 0
  end
  local GuildId = select(1, GetGuildDisplayData(self.OtherPersonInfo))
  return GuildId
end

function M:HasOtherPersonGuildDisplayInfo()
  if self:IsOwener() or type(self.OtherPersonInfo) ~= "table" then
    return false
  end
  local GuildId, GuildName, GuildLogo = GetGuildDisplayData(self.OtherPersonInfo)
  if GuildId <= 0 then
    return true
  end
  if "" == GuildName then
    return false
  end
  return GuildLogoInfo.Parse(GuildLogo) ~= nil
end

function M:ShouldRequestOtherGuildSimpleInfo()
  if self:IsOwener() then
    return false
  end
  local GuildId = self:GetOtherPersonGuildId()
  if GuildId <= 0 then
    return false
  end
  return not self:HasOtherPersonGuildDisplayInfo()
end

function M:ApplyOtherGuildSimpleInfo(GuildSimpleInfo)
  if self:IsOwener() or type(self.OtherPersonInfo) ~= "table" or type(GuildSimpleInfo) ~= "table" then
    return false
  end
  local CurrentGuildId = self:GetOtherPersonGuildId()
  local NewGuildId = tonumber(GuildSimpleInfo.GuildId or 0) or 0
  if CurrentGuildId <= 0 or NewGuildId <= 0 or CurrentGuildId ~= NewGuildId then
    return false
  end
  self.OtherPersonInfo.GuildId = NewGuildId
  self.OtherPersonInfo.GuildSimpleInfo = GuildSimpleInfo
  self.OtherPersonInfo.GuildName = GuildSimpleInfo.Name or self.OtherPersonInfo.GuildName
  self.OtherPersonInfo.GuildLogoInfo = GuildSimpleInfo.LogoInfo or self.OtherPersonInfo.GuildLogoInfo
  self.OtherPersonInfo.GuildLogo = GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo or self.OtherPersonInfo.GuildLogo
  return true
end

return M
