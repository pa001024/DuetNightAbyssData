local json = require("rapidjson")
local crypt = require("crypt")
local SerializeUtils = require("Utils.SerializeUtils")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}
local CachedAppearancePlanInfo
local AppearanceVersion = 3
local CompactMarker = "S"
local CompactNoCustomMarker = "N"
local CommunityPrefix = "A2"
local DefaultPlanNameKey = "UI_Squad_Appearance_TITLE"
local PlaceholderFormatKey = "UI_AppearanceScore_SolutionShare"
local EmptyAccessoryId = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.EmptyCharAccessoryID and DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue or 0
local Base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
local ChatMessageMaxLen = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.ChatMsgMaxLen and DataMgr.GlobalConstant.ChatMsgMaxLen.ConstantValue or 80

local function SafeNumber(Value, DefaultValue)
  if type(Value) == "number" then
    return Value
  end
  local Num = tonumber(Value)
  if nil ~= Num then
    return Num
  end
  return DefaultValue or 0
end

local AccessoryTypeOrder = {
  CommonConst.NewCharAccessoryTypes.Back,
  CommonConst.NewCharAccessoryTypes.Head,
  CommonConst.NewCharAccessoryTypes.Waist,
  CommonConst.NewCharAccessoryTypes.Face,
  CommonConst.NewCharAccessoryTypes.Fx,
  CommonConst.NewCharAccessoryTypes.FX_Footprint,
  CommonConst.NewCharAccessoryTypes.FX_Body,
  CommonConst.NewCharAccessoryTypes.FX_Teleport,
  CommonConst.NewCharAccessoryTypes.FX_Dead,
  CommonConst.NewCharAccessoryTypes.FX_PlungingATK,
  CommonConst.NewCharAccessoryTypes.FX_HelixLeap,
  CommonConst.NewCharAccessoryTypes.Hat,
  CommonConst.NewCharAccessoryTypes.Tail,
  CommonConst.NewCharAccessoryTypes.MVP
}
local AccessoryTypeSet = {}
for _, AccessoryTypeIndex in ipairs(AccessoryTypeOrder) do
  AccessoryTypeSet[AccessoryTypeIndex] = true
end
local AccessoryTypeNameByIndex = {}
for AccessoryTypeName, AccessoryTypeIndex in pairs(CommonConst.NewCharAccessoryTypes or {}) do
  AccessoryTypeNameByIndex[AccessoryTypeIndex] = AccessoryTypeName
end
local AccessoryIdsByTypeIndex = {}
local AccessoryIdToLocalIndex = {}
for AccessoryId, AccessoryData in pairs(DataMgr.CharAccessory or {}) do
  local AccessoryTypeIndex = CommonConst.NewCharAccessoryTypes[AccessoryData.AccessoryType]
  if AccessoryTypeIndex then
    AccessoryIdsByTypeIndex[AccessoryTypeIndex] = AccessoryIdsByTypeIndex[AccessoryTypeIndex] or {}
    AccessoryIdsByTypeIndex[AccessoryTypeIndex][#AccessoryIdsByTypeIndex[AccessoryTypeIndex] + 1] = SafeNumber(AccessoryId, 0)
  end
end
for AccessoryTypeIndex, AccessoryIds in pairs(AccessoryIdsByTypeIndex) do
  table.sort(AccessoryIds)
  AccessoryIdToLocalIndex[AccessoryTypeIndex] = {}
  for LocalIndex, AccessoryId in ipairs(AccessoryIds) do
    AccessoryIdToLocalIndex[AccessoryTypeIndex][AccessoryId] = LocalIndex
  end
end

local function TrimText(Text)
  if not Text then
    return ""
  end
  return string.gsub(Text, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1")
end

local function CloneTable(Value)
  if type(Value) ~= "table" then
    return Value
  end
  local Result = {}
  for Key, Child in pairs(Value) do
    Result[Key] = CloneTable(Child)
  end
  return Result
end

local function SafeGText(TextKey)
  if not TextKey or "" == TextKey then
    return ""
  end
  local Ok, Result = pcall(GText, TextKey)
  if Ok and Result then
    return Result
  end
  return TextKey
end

local function SafeOptionalNumber(Value, DefaultValue)
  if nil == Value or "" == Value then
    return DefaultValue
  end
  return SafeNumber(Value, DefaultValue or 0)
end

local function TryBlockAppearanceShareOpenInDungeon(Owner)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
  if Avatar and Avatar.IsInDungeon and Avatar:IsInDungeon() then
    UIManager(Owner):ShowUITip("CommonToastMain", GText("UI_Toast_Armory_Forbid"))
    return true
  end
  return false
end

local function NormalizeSharerInfo(SharerInfo)
  SharerInfo = CloneTable(SharerInfo or {})
  SharerInfo.Nickname = TrimText(SharerInfo.Nickname)
  SharerInfo.Level = SafeNumber(SharerInfo.Level, 0)
  SharerInfo.HeadIconId = SafeNumber(SharerInfo.HeadIconId, 0)
  SharerInfo.HeadFrameId = SafeNumber(SharerInfo.HeadFrameId, 0)
  SharerInfo.TitleBefore = SafeOptionalNumber(SharerInfo.TitleBefore, nil)
  SharerInfo.TitleAfter = SafeOptionalNumber(SharerInfo.TitleAfter, nil)
  SharerInfo.TitleFrame = SafeOptionalNumber(SharerInfo.TitleFrame, nil)
  return SharerInfo
end

local function HasMeaningfulSharerInfo(SharerInfo)
  if type(SharerInfo) ~= "table" then
    return false
  end
  return (SharerInfo.Nickname or "") ~= "" or SafeNumber(SharerInfo.Level, 0) > 0 or SafeNumber(SharerInfo.HeadIconId, 0) > 0 or SafeNumber(SharerInfo.HeadFrameId, 0) > 0 or SharerInfo.TitleBefore ~= nil or nil ~= SharerInfo.TitleAfter or nil ~= SharerInfo.TitleFrame
end

local function Pow2(Exp)
  return 2 ^ SafeNumber(Exp, 0)
end

local function HasBitFlag(Value, BitIndex)
  return 1 == math.floor(SafeNumber(Value, 0) / Pow2(BitIndex)) % 2
end

local function NumberToFixedBase64(Num, Length)
  Num = SafeNumber(Num, 0)
  if Num < 0 then
    Num = 0
  end
  local Result = {}
  for Index = Length, 1, -1 do
    local CharIndex = Num % 64 + 1
    Result[Index] = string.sub(Base64Chars, CharIndex, CharIndex)
    Num = math.floor(Num / 64)
  end
  return table.concat(Result)
end

local function FixedBase64ToNumber(Code)
  if not Code or "" == Code then
    return 0
  end
  local Result = 0
  for Index = 1, string.len(Code) do
    local Char = string.sub(Code, Index, Index)
    local CharPos = string.find(Base64Chars, Char, 1, true)
    if not CharPos then
      return nil
    end
    Result = Result * 64 + (CharPos - 1)
  end
  return Result
end

local function BuildCharLocalIndexes(CharId)
  local SkinIds = {}
  local HairIds = {}
  for SkinId, SkinData in pairs(DataMgr.Skin or {}) do
    if SkinData and SafeNumber(SkinData.CharId, 0) == CharId then
      SkinIds[#SkinIds + 1] = SafeNumber(SkinId, 0)
    end
  end
  for HairId, HairData in pairs(DataMgr.Hair or {}) do
    if HairData and SafeNumber(HairData.CharId, 0) == CharId then
      HairIds[#HairIds + 1] = SafeNumber(HairId, 0)
    end
  end
  table.sort(SkinIds)
  table.sort(HairIds)
  local SkinIdToIndex = {}
  for Index, SkinId in ipairs(SkinIds) do
    SkinIdToIndex[SkinId] = Index
  end
  local HairIdToIndex = {}
  for Index, HairId in ipairs(HairIds) do
    HairIdToIndex[HairId] = Index
  end
  return SkinIds, SkinIdToIndex, HairIds, HairIdToIndex
end

local function EncodeAccessorySuit(CharId, AccessorySuit)
  local Mask = 0
  local Body = {}
  for Offset, AccessoryTypeIndex in ipairs(AccessoryTypeOrder) do
    local AccessoryId = SafeNumber(AccessorySuit and AccessorySuit[AccessoryTypeIndex], 0)
    if AccessoryId > 0 and AccessoryId ~= EmptyAccessoryId then
      local LocalIndex = AccessoryIdToLocalIndex[AccessoryTypeIndex] and AccessoryIdToLocalIndex[AccessoryTypeIndex][AccessoryId]
      if not LocalIndex then
        return nil
      end
      Mask = Mask + Pow2(Offset - 1)
      Body[#Body + 1] = NumberToFixedBase64(LocalIndex, 2)
    end
  end
  return NumberToFixedBase64(Mask, 3) .. table.concat(Body)
end

local function DecodeAccessorySuit(Code)
  if not Code or string.len(Code) < 3 then
    return nil
  end
  local Mask = FixedBase64ToNumber(string.sub(Code, 1, 3))
  if nil == Mask then
    return nil
  end
  local Result = {}
  local Pos = 4
  for Offset, AccessoryTypeIndex in ipairs(AccessoryTypeOrder) do
    if HasBitFlag(Mask, Offset - 1) then
      local LocalIndex = FixedBase64ToNumber(string.sub(Code, Pos, Pos + 1))
      local AccessoryId = LocalIndex and AccessoryIdsByTypeIndex[AccessoryTypeIndex] and AccessoryIdsByTypeIndex[AccessoryTypeIndex][LocalIndex] or nil
      if not (AccessoryId and DataMgr.CharAccessory) or not DataMgr.CharAccessory[AccessoryId] then
        return nil
      end
      Result[AccessoryTypeIndex] = AccessoryId
      Pos = Pos + 2
    end
  end
  if Pos <= string.len(Code) then
    return nil
  end
  return Result
end

local function EncodeAccessoryCustomParam(AccessoryId, CustomParams)
  if not (AccessoryId and not (AccessoryId <= 0) and CustomParams) or "" == CustomParams then
    return nil
  end
  if type(CustomParams) == "string" then
    local Ok, Parsed = pcall(SerializeUtils.UnSerialize, SerializeUtils, CustomParams)
    if not Ok then
      return nil
    end
    CustomParams = Parsed
  end
  if type(CustomParams) ~= "table" then
    return nil
  end
  local AccessoryData = DataMgr.CharAccessory and DataMgr.CharAccessory[AccessoryId]
  local OffsetData = AccessoryData and DataMgr.CustomOffset and DataMgr.CustomOffset[AccessoryData.AccessoryType]
  if not OffsetData then
    return nil
  end
  
  local function EncodeRange(Value, MinValue, Step, Length)
    local Quantized = math.floor((SafeNumber(Value, MinValue) - MinValue) / Step + 0.5)
    if Quantized < 0 then
      Quantized = 0
    end
    return NumberToFixedBase64(Quantized, Length)
  end
  
  local Position = CustomParams.Position or {}
  local Rotation = CustomParams.Rotation or {}
  local Scale = SafeNumber(CustomParams.Scale, 1)
  return table.concat({
    NumberToFixedBase64(AccessoryId, 3),
    EncodeRange(Position.X, OffsetData.LocationLimit[1], OffsetData.LocationUnit, 1),
    EncodeRange(Position.Y, OffsetData.LocationLimit[1], OffsetData.LocationUnit, 1),
    EncodeRange(Position.Z, OffsetData.LocationLimit[1], OffsetData.LocationUnit, 1),
    EncodeRange(Rotation.Pitch, OffsetData.RotationLimit[1], OffsetData.RotationUnit, 2),
    EncodeRange(Rotation.Yaw, OffsetData.RotationLimit[1], OffsetData.RotationUnit, 2),
    EncodeRange(Rotation.Roll, OffsetData.RotationLimit[1], OffsetData.RotationUnit, 2),
    EncodeRange(Scale, OffsetData.ScaleLimit[1], OffsetData.ScaleUnit, 1)
  })
end

local function EncodeAccessoryCustomParams(AccessorySuit, AccessoryCustomParams)
  local Parts = {}
  for _, AccessoryTypeIndex in ipairs(AccessoryTypeOrder) do
    local AccessoryId = SafeNumber(AccessorySuit and AccessorySuit[AccessoryTypeIndex], 0)
    local Encoded = EncodeAccessoryCustomParam(AccessoryId, AccessoryCustomParams and (AccessoryCustomParams[AccessoryId] or AccessoryCustomParams[tostring(AccessoryId)]))
    if Encoded then
      Parts[#Parts + 1] = Encoded
    end
  end
  return table.concat(Parts)
end

local function DecodeAccessoryCustomParam(Code)
  if not Code or 13 ~= string.len(Code) then
    return nil, nil
  end
  local AccessoryId = FixedBase64ToNumber(string.sub(Code, 1, 3))
  local AccessoryData = AccessoryId and DataMgr.CharAccessory and DataMgr.CharAccessory[AccessoryId] or nil
  local OffsetData = AccessoryData and DataMgr.CustomOffset and DataMgr.CustomOffset[AccessoryData.AccessoryType]
  if not AccessoryId or not OffsetData then
    return nil, nil
  end
  
  local function DecodeRange(ValueCode, MinValue, Step)
    local Quantized = FixedBase64ToNumber(ValueCode)
    if nil == Quantized then
      return nil
    end
    return MinValue + Quantized * Step
  end
  
  local PositionX = DecodeRange(string.sub(Code, 4, 4), OffsetData.LocationLimit[1], OffsetData.LocationUnit)
  local PositionY = DecodeRange(string.sub(Code, 5, 5), OffsetData.LocationLimit[1], OffsetData.LocationUnit)
  local PositionZ = DecodeRange(string.sub(Code, 6, 6), OffsetData.LocationLimit[1], OffsetData.LocationUnit)
  local RotationPitch = DecodeRange(string.sub(Code, 7, 8), OffsetData.RotationLimit[1], OffsetData.RotationUnit)
  local RotationYaw = DecodeRange(string.sub(Code, 9, 10), OffsetData.RotationLimit[1], OffsetData.RotationUnit)
  local RotationRoll = DecodeRange(string.sub(Code, 11, 12), OffsetData.RotationLimit[1], OffsetData.RotationUnit)
  local Scale = DecodeRange(string.sub(Code, 13, 13), OffsetData.ScaleLimit[1], OffsetData.ScaleUnit)
  if nil == PositionX or nil == PositionY or nil == PositionZ or nil == RotationPitch or nil == RotationYaw or nil == RotationRoll or nil == Scale then
    return nil, nil
  end
  local Serialized = SerializeUtils:Serialize({
    Position = {
      X = PositionX,
      Y = PositionY,
      Z = PositionZ
    },
    Rotation = {
      Pitch = RotationPitch,
      Yaw = RotationYaw,
      Roll = RotationRoll
    },
    Scale = Scale
  })
  return AccessoryId, Serialized
end

local function DecodeAccessoryCustomParams(Code)
  local Result = {}
  if not Code or "" == Code then
    return Result
  end
  if 0 ~= string.len(Code) % 13 then
    return nil
  end
  local Pos = 1
  while Pos <= string.len(Code) do
    local AccessoryId, Serialized = DecodeAccessoryCustomParam(string.sub(Code, Pos, Pos + 12))
    if not AccessoryId or not Serialized then
      return nil
    end
    Result[AccessoryId] = Serialized
    Pos = Pos + 13
  end
  return Result
end

local function NormalizeAppearancePlanInfo(AppearancePlanInfo)
  AppearancePlanInfo = CloneTable(AppearancePlanInfo or {})
  local AppearanceInfo = CloneTable(AppearancePlanInfo.AppearanceInfo or {})
  AppearancePlanInfo.AppearanceInfo = AppearanceInfo
  AppearancePlanInfo.SharerInfo = NormalizeSharerInfo(AppearancePlanInfo.SharerInfo or {
    Nickname = AppearancePlanInfo.Nickname,
    Level = AppearancePlanInfo.Level,
    HeadIconId = AppearancePlanInfo.HeadIconId,
    HeadFrameId = AppearancePlanInfo.HeadFrameId,
    TitleBefore = AppearancePlanInfo.TitleBefore,
    TitleAfter = AppearancePlanInfo.TitleAfter,
    TitleFrame = AppearancePlanInfo.TitleFrame
  })
  local TargetId = SafeNumber(AppearancePlanInfo.TargetId or AppearanceInfo.CharId, 0)
  local CharData = DataMgr.Char and DataMgr.Char[TargetId] or nil
  local DefaultTargetName = CharData and SafeGText(CharData.CharName) or ""
  local PlanIndex = SafeNumber(AppearancePlanInfo.PlanIndex, 1)
  local DefaultPlanName = SafeGText(DefaultPlanNameKey .. tostring(PlanIndex))
  AppearanceInfo.CharId = SafeNumber(AppearanceInfo.CharId or TargetId, 0)
  AppearanceInfo.SkinId = SafeNumber(AppearanceInfo.SkinId, 0)
  AppearanceInfo.HairId = SafeNumber(AppearanceInfo.HairId, 0)
  AppearanceInfo.SkinLevel = SafeNumber(AppearanceInfo.SkinLevel, 1)
  AppearanceInfo.IsShowPartMesh = not not AppearanceInfo.IsShowPartMesh
  AppearanceInfo.IsCornerVisible = not not AppearanceInfo.IsCornerVisible
  AppearanceInfo.AccessorySuit = CloneTable(AppearanceInfo.AccessorySuit or {})
  AppearanceInfo.AccessoryCustomParams = CloneTable(AppearanceInfo.AccessoryCustomParams or {})
  AppearanceInfo.Colors = {}
  AppearanceInfo.HairColors = {}
  AppearancePlanInfo.Version = SafeNumber(AppearancePlanInfo.Version, AppearanceVersion)
  AppearancePlanInfo.ShareType = AppearancePlanInfo.ShareType or "CharAppearancePlan"
  AppearancePlanInfo.TargetType = AppearancePlanInfo.TargetType or "Char"
  AppearancePlanInfo.TargetId = TargetId
  AppearancePlanInfo.TargetName = AppearancePlanInfo.TargetName or DefaultTargetName
  AppearancePlanInfo.PlanIndex = PlanIndex
  AppearancePlanInfo.PlanName = AppearancePlanInfo.PlanName or DefaultPlanName
  AppearancePlanInfo.DisplayText = AppearancePlanInfo.DisplayText or string.format("%s - %s", AppearancePlanInfo.TargetName or "", AppearancePlanInfo.PlanName or "")
  return AppearancePlanInfo
end

local function BuildPlaceholderText(AppearancePlanInfo)
  local TargetName = AppearancePlanInfo and AppearancePlanInfo.TargetName or ""
  local PlaceholderTemplate = SafeGText(PlaceholderFormatKey)
  return string.format(PlaceholderTemplate, TargetName)
end

local function EncodeAppearanceInfoCompact(AppearanceInfo, PlanIndex, IncludeCustomParams)
  local NormalizedInfo = NormalizeAppearancePlanInfo({AppearanceInfo = AppearanceInfo}).AppearanceInfo
  local CharId = SafeNumber(NormalizedInfo.CharId, 0)
  local _, SkinIdToIndex, _, HairIdToIndex = BuildCharLocalIndexes(CharId)
  local SkinIndex = SkinIdToIndex[SafeNumber(NormalizedInfo.SkinId, 0)]
  local HairIndex = HairIdToIndex[SafeNumber(NormalizedInfo.HairId, 0)]
  if not SkinIndex or not HairIndex then
    return nil
  end
  local AccessoryCode = EncodeAccessorySuit(CharId, NormalizedInfo.AccessorySuit)
  if not AccessoryCode then
    return nil
  end
  local Flags = 0
  if NormalizedInfo.IsShowPartMesh then
    Flags = Flags + 1
  end
  if NormalizedInfo.IsCornerVisible then
    Flags = Flags + 2
  end
  local Parts = {
    NumberToFixedBase64(CharId, 3),
    NumberToFixedBase64(SkinIndex, 1),
    NumberToFixedBase64(HairIndex, 1),
    NumberToFixedBase64(SafeNumber(NormalizedInfo.SkinLevel, 1), 1),
    NumberToFixedBase64(SafeNumber(PlanIndex, 1), 1),
    NumberToFixedBase64(Flags, 1),
    AccessoryCode
  }
  if IncludeCustomParams then
    local CustomCode = EncodeAccessoryCustomParams(NormalizedInfo.AccessorySuit, NormalizedInfo.AccessoryCustomParams)
    Parts[#Parts + 1] = NumberToFixedBase64(string.len(CustomCode) / 13, 1)
    Parts[#Parts + 1] = CustomCode
  end
  return table.concat(Parts)
end

local function DecodeAppearanceInfoCompact(Code, HasCustomParams)
  if not Code or "" == Code then
    return nil
  end
  local Pos = 1
  
  local function ReadChunk(Length)
    local Chunk = string.sub(Code, Pos, Pos + Length - 1)
    if string.len(Chunk) ~= Length then
      return nil
    end
    Pos = Pos + Length
    return Chunk
  end
  
  local CharId = FixedBase64ToNumber(ReadChunk(3))
  local SkinIndex = FixedBase64ToNumber(ReadChunk(1))
  local HairIndex = FixedBase64ToNumber(ReadChunk(1))
  local SkinLevel = FixedBase64ToNumber(ReadChunk(1))
  local PlanIndex = FixedBase64ToNumber(ReadChunk(1))
  local Flags = FixedBase64ToNumber(ReadChunk(1))
  if not (CharId and SkinIndex and HairIndex and SkinLevel and PlanIndex) or nil == Flags then
    return nil, nil
  end
  local SkinIds, _, HairIds = BuildCharLocalIndexes(CharId)
  local SkinId = SkinIds[SkinIndex]
  local HairId = HairIds[HairIndex]
  if not SkinId or not HairId then
    return nil
  end
  local AccessoryCodeLength = 3
  local AccessoryMask = FixedBase64ToNumber(string.sub(Code, Pos, Pos + 2))
  if nil == AccessoryMask then
    return nil, nil
  end
  for Offset = 1, #AccessoryTypeOrder do
    if HasBitFlag(AccessoryMask, Offset - 1) then
      AccessoryCodeLength = AccessoryCodeLength + 2
    end
  end
  local AccessorySuit = DecodeAccessorySuit(ReadChunk(AccessoryCodeLength))
  if not AccessorySuit then
    return nil, nil
  end
  local AccessoryCustomParams = {}
  if HasCustomParams then
    local CustomCount = FixedBase64ToNumber(ReadChunk(1))
    if nil == CustomCount then
      return nil, nil
    end
    AccessoryCustomParams = DecodeAccessoryCustomParams(ReadChunk(CustomCount * 13))
    if not AccessoryCustomParams then
      return nil, nil
    end
  end
  if Pos <= string.len(Code) then
    return nil, nil
  end
  return {
    CharId = CharId,
    SkinId = SkinId,
    HairId = HairId,
    SkinLevel = SkinLevel,
    IsShowPartMesh = 1 == Flags % 2,
    IsCornerVisible = 1 == math.floor(Flags / 2),
    Colors = {},
    HairColors = {},
    AccessorySuit = AccessorySuit,
    AccessoryCustomParams = AccessoryCustomParams
  }, PlanIndex
end

local function EncodeShareText(Text)
  if not Text or "" == Text then
    return ""
  end
  local Encoded = crypt.base64encode(Text)
  Encoded = string.gsub(Encoded, "%+", "-")
  Encoded = string.gsub(Encoded, "/", "_")
  Encoded = string.gsub(Encoded, "=", ".")
  return Encoded
end

local function DecodeShareText(Text)
  if not Text or "" == Text then
    return ""
  end
  Text = string.gsub(Text, "-", "+")
  Text = string.gsub(Text, "_", "/")
  Text = string.gsub(Text, "%.", "=")
  local Ok, Result = pcall(crypt.base64decode, Text)
  if not Ok then
    return nil
  end
  return Result
end

local function EncodeSharerInfo(SharerInfo)
  SharerInfo = NormalizeSharerInfo(SharerInfo)
  if not HasMeaningfulSharerInfo(SharerInfo) then
    return ""
  end
  local Ok, Encoded = pcall(json.encode, SharerInfo)
  if not (Ok and Encoded) or "" == Encoded then
    return ""
  end
  return EncodeShareText(Encoded)
end

local function DecodeSharerInfo(Text)
  if not Text or "" == Text then
    return nil
  end
  local DecodedText = DecodeShareText(Text)
  if not DecodedText or "" == DecodedText then
    return nil
  end
  local Ok, Decoded = pcall(json.decode, DecodedText)
  if not Ok or type(Decoded) ~= "table" then
    return nil
  end
  return NormalizeSharerInfo(Decoded)
end

local function BuildChatSharePayload(AppearancePlanInfo)
  local NormalizedInfo = NormalizeAppearancePlanInfo(AppearancePlanInfo)
  local BaseCode = EncodeAppearanceInfoCompact(NormalizedInfo.AppearanceInfo, NormalizedInfo.PlanIndex, true)
  if BaseCode then
    local Payload = ChatCommon.AppearancePlanCopyHeader .. CompactMarker .. BaseCode
    if string.len(Payload) <= ChatMessageMaxLen then
      return Payload
    end
  end
  BaseCode = EncodeAppearanceInfoCompact(NormalizedInfo.AppearanceInfo, NormalizedInfo.PlanIndex, false)
  if BaseCode then
    local Payload = ChatCommon.AppearancePlanCopyHeader .. CompactNoCustomMarker .. BaseCode
    if string.len(Payload) <= ChatMessageMaxLen then
      return Payload
    end
  end
  return nil
end

local function BuildCommunityShareCode(AppearancePlanInfo)
  local NormalizedInfo = NormalizeAppearancePlanInfo(AppearancePlanInfo)
  local BaseCode = EncodeAppearanceInfoCompact(NormalizedInfo.AppearanceInfo, NormalizedInfo.PlanIndex, true)
  if not BaseCode then
    return ""
  end
  local Parts = {
    CommunityPrefix,
    NumberToFixedBase64(NormalizedInfo.TargetId, 3),
    NumberToFixedBase64(NormalizedInfo.PlanIndex, 1),
    EncodeShareText(NormalizedInfo.PlanName or ""),
    EncodeShareText(NormalizedInfo.TargetName or ""),
    BaseCode
  }
  local SharerCode = EncodeSharerInfo(NormalizedInfo.SharerInfo)
  if "" ~= SharerCode then
    Parts[#Parts + 1] = SharerCode
  end
  return table.concat(Parts, "|")
end

local function ParseCompactChatPayload(Code, HasCustomParams)
  local AppearanceInfo, PlanIndex = DecodeAppearanceInfoCompact(Code, HasCustomParams)
  if not AppearanceInfo then
    return nil
  end
  local TargetId = AppearanceInfo.CharId
  local CharData = DataMgr.Char and DataMgr.Char[TargetId] or nil
  local TargetName = CharData and SafeGText(CharData.CharName) or ""
  return NormalizeAppearancePlanInfo({
    Version = AppearanceVersion,
    ShareType = "CharAppearancePlan",
    TargetType = "Char",
    TargetId = TargetId,
    TargetName = TargetName,
    PlanIndex = PlanIndex,
    AppearanceInfo = AppearanceInfo
  })
end

local function ParseCommunityShareCode(Code)
  local Parts = string.split(Code or "", "|")
  if 6 ~= #Parts and 7 ~= #Parts or Parts[1] ~= CommunityPrefix then
    return nil
  end
  local TargetId = FixedBase64ToNumber(Parts[2])
  local PlanIndex = FixedBase64ToNumber(Parts[3])
  local PlanName = DecodeShareText(Parts[4])
  local TargetName = DecodeShareText(Parts[5])
  local AppearanceInfo, PlanIndexFromPayload = DecodeAppearanceInfoCompact(Parts[6], true)
  local SharerInfo = DecodeSharerInfo(Parts[7])
  if Parts[7] and "" ~= Parts[7] and not SharerInfo then
    return nil
  end
  if not (TargetId and PlanIndex and PlanName and TargetName) or not AppearanceInfo then
    return nil
  end
  return NormalizeAppearancePlanInfo({
    Version = AppearanceVersion,
    ShareType = "CharAppearancePlan",
    TargetType = "Char",
    TargetId = TargetId,
    TargetName = TargetName,
    PlanIndex = PlanIndexFromPayload or PlanIndex,
    PlanName = PlanName,
    AppearanceInfo = AppearanceInfo,
    SharerInfo = SharerInfo
  })
end

function M.CacheAppearancePlanInfoCopied(AppearancePlanInfo)
  if not AppearancePlanInfo then
    return nil
  end
  local NormalizedInfo = NormalizeAppearancePlanInfo(AppearancePlanInfo)
  local PlaceholderText = BuildPlaceholderText(NormalizedInfo)
  CachedAppearancePlanInfo = {MsgCopyed = PlaceholderText, AppearancePlanInfo = NormalizedInfo}
  ULowEntryExtendedStandardLibrary.ClipboardSet(PlaceholderText)
  return CachedAppearancePlanInfo
end

function M.GetAppearancePlanInfoCopied()
  return CachedAppearancePlanInfo
end

function M.IsAppearanceShareInfoMsg(InMsgStr)
  local CachedInfo = M.GetAppearancePlanInfoCopied()
  if not CachedInfo then
    return false
  end
  return InMsgStr == CachedInfo.MsgCopyed
end

function M.GenerateAppearanceShareMsg()
  local CachedInfo = M.GetAppearancePlanInfoCopied()
  if not CachedInfo or not CachedInfo.AppearancePlanInfo then
    return nil
  end
  return BuildChatSharePayload(CachedInfo.AppearancePlanInfo)
end

function M.GenerateAppearanceCommunityCode(AppearancePlanInfo)
  if not AppearancePlanInfo then
    return ""
  end
  return BuildCommunityShareCode(AppearancePlanInfo)
end

function M.ParseAppearanceShareMsg(RawText)
  local Content = TrimText(RawText)
  if "" == Content then
    return nil
  end
  if string.startswith(Content, ChatCommon.AppearancePlanCopyHeader) then
    local Payload = string.sub(Content, #ChatCommon.AppearancePlanCopyHeader + 1)
    local Marker = string.sub(Payload, 1, 1)
    local Body = string.sub(Payload, 2)
    if Marker == CompactMarker then
      return ParseCompactChatPayload(Body, true)
    elseif Marker == CompactNoCustomMarker then
      return ParseCompactChatPayload(Body, false)
    end
    return nil
  end
  if string.startswith(Content, CommunityPrefix .. "|") then
    return ParseCommunityShareCode(Content)
  end
  return nil
end

function M.BuildAppearancePlanDisplayText(AppearancePlanInfo)
  AppearancePlanInfo = AppearancePlanInfo and NormalizeAppearancePlanInfo(AppearancePlanInfo) or nil
  if not AppearancePlanInfo then
    return nil
  end
  if AppearancePlanInfo.DisplayText and AppearancePlanInfo.DisplayText ~= "" then
    return AppearancePlanInfo.DisplayText
  end
  local TargetName = AppearancePlanInfo.TargetName or ""
  local PlanName = AppearancePlanInfo.PlanName or ""
  if "" == TargetName and "" == PlanName then
    return nil
  end
  return string.format("%s - %s", TargetName, PlanName)
end

function M.OpenAppearanceImport(Owner, AppearancePlanInfo, ExtraParams)
  if not (Owner and AppearancePlanInfo) or not AppearancePlanInfo.AppearanceInfo then
    return false
  end
  if TryBlockAppearanceShareOpenInDungeon(Owner) then
    return false
  end
  local NormalizedInfo = NormalizeAppearancePlanInfo(AppearancePlanInfo)
  local Params = ExtraParams or {}
  UIManager(Owner):LoadUINew("AppearanceImport", {
    Parent = Params.Parent or Owner,
    CharUuid = Params.CharUuid,
    AppearanceIndex = Params.AppearanceIndex or NormalizedInfo.PlanIndex or 1,
    AppearancePlanInfo = NormalizedInfo,
    SourceText = Params.SourceText,
    OnCloseCallback = Params.OnCloseCallback
  })
  return true
end

function M.OpenAppearancePreview(Owner, AppearancePlanInfo, ExtraParams)
  if not (Owner and AppearancePlanInfo) or not AppearancePlanInfo.AppearanceInfo then
    return nil
  end
  if TryBlockAppearanceShareOpenInDungeon(Owner) then
    return nil
  end
  local NormalizedInfo = NormalizeAppearancePlanInfo(AppearancePlanInfo)
  local AppearanceInfo = NormalizedInfo.AppearanceInfo
  local TargetId = NormalizedInfo.TargetId or AppearanceInfo.CharId
  if not TargetId then
    return nil
  end
  local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Custom, {
    CharInfos = {
      {
        RoleId = TargetId,
        Level = 1,
        Exp = 0,
        GradeLevel = 1,
        EnhanceLevel = 0,
        AppearanceSuit = AppearanceInfo
      }
    }
  })
  local _, PreviewChar = next(DummyAvatar.Chars)
  if not PreviewChar then
    return nil
  end
  DummyAvatar.CurrentChar = PreviewChar.Uuid
  local Params = ExtraParams or {}
  local UIConfig = DataMgr.SystemUI.AppearanceMain
  local ZOrder = Owner.GetZOrder and Owner:GetZOrder() or UIConfig.ZOrder
  UIManager(Owner):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, ZOrder, {
    Parent = Owner,
    IsPreviewMode = true,
    DoNotSort = true,
    CharUuids = {
      PreviewChar.Uuid
    },
    InitialOrderCharUuids = {
      PreviewChar.Uuid
    },
    CharUuid = PreviewChar.Uuid,
    CharId = PreviewChar.CharId,
    MainTabName = "Char",
    TemporaryAvatar = DummyAvatar,
    UseTemporaryAvatar = true,
    ChatAppearancePreviewInfo = NormalizedInfo,
    OnCloseCallback = Params.OnCloseCallback
  })
  return DummyAvatar
end

return M
