require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local AvatarUtils = require("BluePrints.Client.AvatarUtils")
local CommonUtils = require("Utils.CommonUtils")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local M = {}
local TAG = "[AccessoryRank]"

local function BuildTableKeySummary(Value)
  if type(Value) ~= "table" then
    return tostring(Value)
  end
  local Keys = {}
  for Key, _ in pairs(Value) do
    table.insert(Keys, tostring(Key))
  end
  table.sort(Keys)
  return table.concat(Keys, ",")
end

local function BuildRankPreviewTargetSummary(RankInfo)
  if type(RankInfo) ~= "table" then
    return tostring(RankInfo)
  end
  return string.format("Uid=%s Rank=%s Nickname=%s Score=%s", tostring(RankInfo.Uid), tostring(RankInfo.RankNum), tostring(RankInfo.Nickname), tostring(RankInfo.Score))
end

local RANK_WEAPON_TYPE_TAGS = {
  "Bow",
  "Cannon",
  "Claymore",
  "Crossbow",
  "Dualblade",
  "Katana",
  "Machinegun",
  "Pistol",
  "Polearm",
  "Shotgun",
  "Sword",
  "Swordwhip"
}

local function ResolveWeaponCameraTag(WeaponData)
  if not WeaponData then
    return nil
  end
  if WeaponData.HasTag and type(WeaponData.HasTag) == "function" then
    for _, Tag in ipairs(RANK_WEAPON_TYPE_TAGS) do
      if WeaponData:HasTag(Tag) then
        return Tag
      end
    end
  end
  return nil
end

local function ResolveBodyTypeByCharId(CharId)
  local BattleCharData = DataMgr.BattleChar and DataMgr.BattleChar[CharId] or nil
  local BattleCharTags = BattleCharData and BattleCharData.BattleCharTag or nil
  if BattleCharTags then
    local BodyTypes = {
      "Girl",
      "Boy",
      "Loli",
      "Woman",
      "Man"
    }
    for _, Tag in ipairs(BattleCharTags) do
      for _, BodyType in ipairs(BodyTypes) do
        if Tag == BodyType then
          return BodyType
        end
      end
    end
  end
  return "Girl"
end

local function BuildRelativeCharacterCamera(WeaponTag, BodyType)
  local CameraData = DataMgr.GuildWarRankCameraData
  if not (CameraData and WeaponTag) or not BodyType then
    return nil
  end
  local Tag = "Weapon_" .. WeaponTag .. "_" .. BodyType
  local Data = CameraData[Tag]
  Data = Data or CameraData.Default
  if not Data then
    return nil
  end
  return {
    Location = Data.Location,
    Rotation = Data.Rotation,
    CameraFocal = Data.CameraFocal,
    Time = Data.Time or 0,
    RelativeCharacter = true,
    HasCustomCamera = true
  }
end

local function NormalizeSlotData(Info)
  if type(Info) ~= "table" then
    return Info
  end
  local SlotData = Info.SlotData
  if type(SlotData) ~= "table" then
    return Info
  end
  local NeedConvert = false
  for _, Value in pairs(SlotData) do
    if type(Value) ~= "table" then
      NeedConvert = true
      break
    end
  end
  if not NeedConvert then
    return Info
  end
  local NewInfo = {}
  for Key, Value in pairs(Info) do
    NewInfo[Key] = Value
  end
  local NewSlotData = {}
  for Key, Value in pairs(SlotData) do
    if type(Value) == "table" then
      NewSlotData[Key] = Value
    elseif type(Value) == "number" then
      NewSlotData[Key] = {
        SlotId = Key,
        Polarity = Value,
        ModEid = -1
      }
    end
  end
  NewInfo.SlotData = NewSlotData
  return NewInfo
end

local function NormalizeRankPreviewInfoList(Info)
  if type(Info) ~= "table" then
    return {}
  end
  if nil ~= Info[1] then
    return Info
  end
  return {Info}
end

local function ConvertRankPreviewCharInfos(CharInfos)
  local Chars = {}
  for _, CharInfo in ipairs(NormalizeRankPreviewInfoList(CharInfos)) do
    local Appearance = CharInfo.Appearance or {}
    local CurrentPlanIndex = Appearance.CurrentPlanIndex or 1
    local HairColors = Appearance.HairColors
    local CurrentHairPlanIndex = Appearance.CurrentHairPlanIndex or 1
    if type(HairColors) == "table" and type(HairColors[CurrentHairPlanIndex]) == "table" then
      HairColors = HairColors[CurrentHairPlanIndex]
    end
    local AccessorySuit = {}
    for AccessoryTypeIndex, AccessoryId in pairs(Appearance.Accessory or {}) do
      local NumericAccessoryId = tonumber(AccessoryId)
      if NumericAccessoryId and NumericAccessoryId > 0 then
        AccessorySuit[AccessoryTypeIndex] = NumericAccessoryId
      end
    end
    local AppearanceSuit = {
      Colors = Appearance.SkinColors and Appearance.SkinColors[CurrentPlanIndex],
      SkinId = Appearance.SkinId,
      SkinLevel = Appearance.SkinSelectedLevel or Appearance.SkinLevel or 1,
      AccessorySuit = AccessorySuit,
      AccessoryCustomParams = Appearance.AccessoryCustomParams or {},
      HairId = Appearance.HairId,
      HairColors = HairColors,
      IsShowPartMesh = Appearance.IsShowPartMesh,
      IsCornerVisible = Appearance.IsCornerVisible,
      CharId = CharInfo.CharId
    }
    local SkillInfos = {}
    for _, Skill in ipairs(CharInfo.Skills or {}) do
      if 1 ~= Skill.LockState then
        local bOnlyPhantom = false
        local SkillData = DataMgr.Skill[Skill.SkillId] and DataMgr.Skill[Skill.SkillId][Skill.Level] and DataMgr.Skill[Skill.SkillId][Skill.Level][CharInfo.GradeLevel]
        if SkillData then
          bOnlyPhantom = SkillData.OnlyPhantom
        end
        if not bOnlyPhantom then
          local SkillInfo = {
            Level = Skill.Level,
            ExtraLevel = Skill.ExtraLevel
          }
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
    for Index, ModSuit in ipairs(CharInfo.ModSuit or {}) do
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
    table.insert(Chars, {
      AppearanceSuit = AppearanceSuit,
      RoleId = CharInfo.CharId,
      Level = CharInfo.Level or 1,
      GradeLevel = CharInfo.GradeLevel or 0,
      EnhanceLevel = CharInfo.EnhanceLevel or 0,
      SkillInfos = SkillInfos,
      SlotData = SlotData,
      ModData = ModData,
      SkillTreeInfos = CharInfo.SkillTree,
      ModSuitIndex = 1
    })
  end
  return Chars
end

local function ConvertRankPreviewWeaponInfos(WeaponInfos)
  local Weapons = {}
  for _, WeaponInfo in ipairs(NormalizeRankPreviewInfoList(WeaponInfos)) do
    local Appearance = WeaponInfo.Appearance or {}
    local CurrentPlanIndex = Appearance.CurrentPlanIndex or 1
    local AppearanceInfo = {
      SkinId = Appearance.SkinId,
      AccessoryId = Appearance.Accessory and Appearance.Accessory[1],
      Colors = {
        Colors = Appearance.SkinColors and Appearance.SkinColors[CurrentPlanIndex],
        SpecialColor = Appearance.SpecialColor and Appearance.SpecialColor[CurrentPlanIndex]
      }
    }
    local SlotData = {}
    local ModData = {}
    for Index, ModSuit in ipairs(WeaponInfo.ModSuit or {}) do
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
    table.insert(Weapons, {
      AppearanceInfo = AppearanceInfo,
      WeaponId = WeaponInfo.WeaponId,
      Level = WeaponInfo.Level or 1,
      GradeLevel = WeaponInfo.GradeLevel or 0,
      HyperCardLevel = WeaponInfo.HyperCardLevel or 0,
      EnhanceLevel = WeaponInfo.EnhanceLevel or 0,
      SlotData = SlotData,
      ModData = ModData,
      ModSuitIndex = 1
    })
  end
  return Weapons
end

local function ExtractRankPreviewInfo(Ret)
  if type(Ret) ~= "table" then
    return nil, nil
  end
  local Candidates = {
    Ret,
    Ret.RankAccessoryInfo,
    Ret.PlayerInfo
  }
  local DumpRet = CommonUtils.BinaryDump(Ret)
  if type(DumpRet) == "table" then
    table.insert(Candidates, DumpRet)
    table.insert(Candidates, DumpRet.RankAccessoryInfo)
    table.insert(Candidates, DumpRet.PlayerInfo)
  end
  for _, Candidate in ipairs(Candidates) do
    if type(Candidate) == "table" then
      local CharInfo = not Candidate.char and not Candidate.Char and not Candidate.CharInfos and Candidate.PlayerInfo and Candidate.PlayerInfo.Char
      local WeaponInfo = not Candidate.weapon and not Candidate.Weapon and not Candidate.WeaponInfos and Candidate.PlayerInfo and Candidate.PlayerInfo.Weapon
      if type(CharInfo) == "table" or type(WeaponInfo) == "table" then
        return CharInfo, WeaponInfo
      end
    end
  end
  return nil, nil
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

local function ResolveCustomDisplaySlotIndex(CharParam, FallbackIndex)
  local SlotIndex = tonumber(CharParam and CharParam.SlotIndex or nil) or FallbackIndex
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return FallbackIndex
  end
  return SlotIndex
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
  local PositionX = Position[1] or 0
  local PositionY = Position[2] or 0
  local PositionZ = Position[3] or 0
  local RotationRoll = Rotation[1] or 0
  local RotationPitch = Rotation[2] or 0
  local RotationYaw = Rotation[3] or 0
  if 0 == PositionX and 0 == PositionY and 0 == PositionZ and 0 == RotationRoll and 0 == RotationPitch and 0 == RotationYaw then
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

local function ConvertServerAppearanceToSuit(ServerAppearance)
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

local function FindCharInDummyAvatar(DummyAvatar, CharId)
  if not DummyAvatar or not CharId then
    return nil
  end
  CharId = tonumber(CharId)
  for _, CharData in pairs(DummyAvatar.Chars or {}) do
    if CharData and tonumber(CharData.CharId) == CharId then
      return CharData
    end
  end
  return nil
end

local function FindWeaponInDummyAvatar(DummyAvatar, WeaponId)
  if not DummyAvatar or not WeaponId then
    return nil
  end
  WeaponId = tonumber(WeaponId)
  for _, WeaponData in pairs(DummyAvatar.Weapons or {}) do
    if WeaponData and tonumber(WeaponData.WeaponId) == WeaponId then
      return WeaponData
    end
  end
  return nil
end

local function BuildDummyAvatarFromSimpleInfos(CharInfos, WeaponInfos)
  local DummyAvatar = {}
  ArmoryUtils._CreateDummyAvatarCustom(DummyAvatar, {CharInfos = CharInfos, WeaponInfos = WeaponInfos})
  return DummyAvatar
end

local function BuildDraftFromCustomDisplay(CustomDisplay)
  if type(CustomDisplay) ~= "table" then
    DebugPrint(TAG .. " V2 custom draft input invalid type=" .. type(CustomDisplay))
    return DisplayDraft:CreateEmpty(nil), BuildDummyAvatarFromSimpleInfos({}, {})
  end
  CustomDisplay = NormalizeCustomDisplayInfo(CustomDisplay)
  local CharParamGroup = CustomDisplay.CharParamGroup or {}
  local SimpleCharInfos = {}
  local SimpleWeaponInfos = {}
  local AddedCharIds = {}
  local AddedWeaponIds = {}
  for _, CharParam in ipairs(CharParamGroup) do
    local CharId = tonumber(CharParam and CharParam.CharId or nil)
    if CharId and CharId > 0 and not AddedCharIds[CharId] then
      AddedCharIds[CharId] = true
      local AppearanceSuit
      if CharParam.Appearance then
        AppearanceSuit = ConvertServerAppearanceToSuit(CharParam.Appearance)
      end
      SimpleCharInfos[#SimpleCharInfos + 1] = {
        RoleId = CharId,
        Level = 1,
        ModSuitIndex = 1,
        AppearanceSuit = AppearanceSuit
      }
    end
    local WeaponId = tonumber(CharParam and CharParam.WeaponId or nil)
    if WeaponId and WeaponId > 0 and not AddedWeaponIds[WeaponId] then
      AddedWeaponIds[WeaponId] = true
      SimpleWeaponInfos[#SimpleWeaponInfos + 1] = {
        WeaponId = WeaponId,
        Level = 1,
        ModSuitIndex = 1,
        AppearanceInfo = {
          SkinId = tonumber(CharParam.WeaponSkinId),
          Colors = {},
          AccessoryId = -1
        }
      }
    end
  end
  local DummyAvatar = BuildDummyAvatarFromSimpleInfos(SimpleCharInfos, SimpleWeaponInfos)
  local Draft = DisplayDraft:CreateEmpty(nil)
  for Index, CharParam in ipairs(CharParamGroup) do
    local CharId = tonumber(CharParam and CharParam.CharId or nil)
    if CharId and CharId > 0 then
      local SlotIndex = ResolveCustomDisplaySlotIndex(CharParam, Index)
      local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
      local CharData = FindCharInDummyAvatar(DummyAvatar, CharId)
      if CharData then
        Slot.CharData = CharData
        Slot.Avatar = DummyAvatar
        Slot.Transform = BuildTransformFromServerParam(CharParam)
        Slot.TransformRotation = BuildTransformRotationFromServerParam(CharParam)
        Slot.Action = BuildCharacterActionFromServerParam(CharParam)
        if CharParam.Appearance then
          Slot.Appearance = ConvertServerAppearanceToSuit(CharParam.Appearance)
        end
        local WeaponId = tonumber(CharParam.WeaponId)
        if WeaponId and 0 ~= WeaponId then
          Slot.WeaponData = FindWeaponInDummyAvatar(DummyAvatar, WeaponId)
        end
      end
    end
  end
  Draft.Camera = BuildCameraDataFromServerParam(CustomDisplay.CameraParam) or Draft.Camera
  return Draft, DummyAvatar
end

local function BuildDraftFromConvertedCharInfos(CharInfos, WeaponInfos)
  if type(CharInfos) ~= "table" or 0 == #CharInfos then
    return DisplayDraft:CreateEmpty(nil), BuildDummyAvatarFromSimpleInfos({}, {}), nil
  end
  local NormalizedChar = NormalizeSlotData(CharInfos[1])
  local NormalizedWeapon = WeaponInfos and WeaponInfos[1] and NormalizeSlotData(WeaponInfos[1]) or nil
  if NormalizedWeapon then
    local WeaponId = tonumber(NormalizedWeapon.WeaponId)
    if not WeaponId or WeaponId <= 0 then
      DebugPrint("[PreviewLevelData@hlb] ChangeDisplayWeapon", "weaponId", NormalizedWeapon.WeaponId, "ultra", false)
      NormalizedWeapon = nil
    end
  end
  local DummyAvatar = {}
  ArmoryUtils._CreateDummyAvatarCustom(DummyAvatar, {
    CharInfos = {NormalizedChar},
    WeaponInfos = NormalizedWeapon and {NormalizedWeapon} or {}
  })
  local Draft = DisplayDraft:CreateEmpty(nil)
  local Slot = DisplayDraft:GetCharacterSlot(Draft, 1)
  local _, CharData = next(DummyAvatar.Chars or {})
  if CharData then
    Slot.CharData = CharData
    Slot.Avatar = DummyAvatar
    Slot.Appearance = CharInfos[1].AppearanceSuit
  end
  local _, WeaponData = next(DummyAvatar.Weapons or {})
  local WeaponTag = "Sword"
  if WeaponData then
    Slot.WeaponData = WeaponData
    WeaponTag = ResolveWeaponCameraTag(WeaponData) or WeaponTag
  end
  local PreviewCharId = CharInfos[1] and CharInfos[1].RoleId or nil
  local BodyType = ResolveBodyTypeByCharId(PreviewCharId)
  Draft.Camera = BuildRelativeCharacterCamera(WeaponTag, BodyType) or Draft.Camera
  return Draft, DummyAvatar, WeaponTag
end

local function BuildDraftFromArmoryData(RankAccessoryInfo)
  local CharInfo, WeaponInfo = ExtractRankPreviewInfo(RankAccessoryInfo)
  if type(CharInfo) ~= "table" then
    DebugPrint(TAG .. " V2 armory draft missing char payload keys=" .. BuildTableKeySummary(RankAccessoryInfo))
    return DisplayDraft:CreateEmpty(nil), BuildDummyAvatarFromSimpleInfos({}, {}), nil
  end
  local CharInfos = ConvertRankPreviewCharInfos(CharInfo)
  local WeaponInfos = type(WeaponInfo) == "table" and ConvertRankPreviewWeaponInfos(WeaponInfo) or {}
  return BuildDraftFromConvertedCharInfos(CharInfos, WeaponInfos)
end

local function ExtractPreviewPayloadUid(Ret)
  if type(Ret) ~= "table" then
    return nil
  end
  local Uid = Ret.Uid or Ret.uid or Ret.PlayerUid
  if nil == Uid and "table" == type(Ret.RankAccessoryInfo) then
    Uid = Ret.RankAccessoryInfo.Uid or Ret.RankAccessoryInfo.uid or Ret.RankAccessoryInfo.PlayerUid
  end
  return Uid
end

function M:HandlePreviewPayload(Context, Ret, Source)
  if not (Context and Context.PendingPreviewUid) or type(Ret) ~= "table" then
    return false
  end
  local PayloadUid = ExtractPreviewPayloadUid(Ret)
  if nil ~= PayloadUid and not ComRankingUtils.IsSameUid(PayloadUid, Context.PendingPreviewUid) then
    DebugPrint(TAG .. " HandlePreviewPayload uid mismatch pending=" .. tostring(Context.PendingPreviewUid) .. " payload=" .. tostring(PayloadUid) .. " source=" .. tostring(Source))
    return false
  end
  local RankAccessoryInfo = Ret.RankAccessoryInfo or Ret
  local NestedSourceType = type(RankAccessoryInfo) == "table" and RankAccessoryInfo.SourceType or nil
  local SourceType = Ret.SourceType or NestedSourceType or CommonConst.DisplayAppearanceSourceType.Default
  local CustomDisplay = Ret.CustomDisplay
  if type(CustomDisplay) ~= "table" and type(RankAccessoryInfo) == "table" then
    CustomDisplay = RankAccessoryInfo.CustomDisplay
  end
  if type(CustomDisplay) == "table" then
    RankAccessoryInfo = CustomDisplay
  end
  local bHasCustomDisplay = type(RankAccessoryInfo) == "table" and "table" == type(RankAccessoryInfo.CharParamGroup)
  local Draft, WeaponTag
  if SourceType == CommonConst.DisplayAppearanceSourceType.PersonalInfoCustom or bHasCustomDisplay then
    Draft = BuildDraftFromCustomDisplay(RankAccessoryInfo)
    WeaponTag = nil
  else
    Draft, WeaponTag = BuildDraftFromArmoryData(RankAccessoryInfo)
  end
  if not Draft then
    DebugPrint(TAG .. " V2 build draft failed")
    return false
  end
  Context.PendingPreviewUid = nil
  Context.PendingPreviewRankInfo = nil
  Context.Scene:Show(Draft)
  Context.UI._LastWeaponTag = WeaponTag or Context.UI._LastWeaponTag
  return true
end

function M:BuildDraftFromLocalAvatar(Context)
  local Avatar = Context and Context.Avatar
  if not (Avatar and Avatar.Chars) or not Avatar.CurrentChar then
    DebugPrint(TAG .. " BuildDraftFromLocalAvatar invalid avatar, fallback to RPC")
    return false
  end
  local CustomDisplay = Avatar.PersonalInfo and Avatar.PersonalInfo.CustomDisplay or nil
  local CustomCharCount = 0
  for _, CharParam in ipairs(CustomDisplay and CustomDisplay.CharParamGroup or {}) do
    if tonumber(CharParam and CharParam.CharId) and tonumber(CharParam.CharId) > 0 then
      CustomCharCount = CustomCharCount + 1
    end
  end
  local HasCustomDisplay = CustomCharCount > 0
  local RankAccessoryInfo, SourceType
  if HasCustomDisplay then
    RankAccessoryInfo = AvatarUtils:GetPersonalInfoCustomDisplay(Avatar, true)
    SourceType = CommonConst.DisplayAppearanceSourceType.PersonalInfoCustom
  else
    RankAccessoryInfo = AvatarUtils:GetPlayerDisplayAppearanceInfo(Avatar, true)
    SourceType = CommonConst.DisplayAppearanceSourceType.Default
  end
  return self:HandlePreviewPayload(Context, {
    RankAccessoryInfo = RankAccessoryInfo,
    SourceType = SourceType,
    Uid = Avatar.Uid
  }, "LocalAvatar")
end

function M:RequestPreview(Context, Uid)
  if not (Context and Context.Avatar) or not Uid then
    return
  end
  Context.PreviewRequestId = (Context.PreviewRequestId or 0) + 1
  Context.PendingPreviewUid = Uid
  local RequestId = Context.PreviewRequestId
  if ComRankingUtils.IsSameUid(Uid, Context.Avatar.Uid) then
    if self:BuildDraftFromLocalAvatar(Context) then
      return
    end
    DebugPrint(TAG .. " RequestRankTargetPreview V2 local build failed, fallback to RPC")
  end
  Context.Avatar:GetPlayerRankAccessoryInfo_V2(function(ErrCode, Ret)
    if not IsValid(Context.UI) then
      return
    end
    if RequestId ~= Context.PreviewRequestId or Context.PendingPreviewUid ~= Uid then
      return
    end
    if not ErrorCode:Check(ErrCode) then
      DebugPrint(TAG .. " RequestRankTargetPreview V2 failed", ErrorCode:Name(ErrCode), BuildRankPreviewTargetSummary(Context.PendingPreviewRankInfo))
      Context.PendingPreviewUid = nil
      Context.PendingPreviewRankInfo = nil
      return
    end
    if type(Ret) == "table" then
      self:HandlePreviewPayload(Context, Ret, "Callback")
    else
      DebugPrint(TAG .. " RequestRankTargetPreview V2 invalid payload type=" .. type(Ret))
      Context.PendingPreviewUid = nil
      Context.PendingPreviewRankInfo = nil
    end
  end, Uid)
end

function M:HandleEventPayload(Context, Ret)
  self:HandlePreviewPayload(Context, Ret, "Event")
end

M.BuildRankPreviewTargetSummary = BuildRankPreviewTargetSummary
return M
