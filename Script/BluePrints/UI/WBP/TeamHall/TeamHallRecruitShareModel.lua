local TeamHallDatas = require("BluePrints.UI.WBP.TeamHall.TeamHallData")
local M = {}
M.Header = "TeamInfo:"
local ProtocolVersionV1 = 1
local ProtocolVersionV2 = 2
local ProtocolVersionV3 = 3
local DefaultChatMessageMaxLength = 80
local DefaultMaxTeamMember = 4
local MaxCustomTagTextLength = 8
local Base36Chars = "0123456789abcdefghijklmnopqrstuvwxyz"

local function ToInteger(Value)
  if type(Value) == "number" then
    return math.tointeger(Value)
  end
  if type(Value) ~= "string" or not string.match(Value, "^%d+$") then
    return nil
  end
  return math.tointeger(tonumber(Value))
end

local function IsSameInteger(Left, Right)
  local LeftInteger = ToInteger(Left)
  local RightInteger = ToInteger(Right)
  return nil ~= LeftInteger and LeftInteger == RightInteger
end

local function ContainsInteger(Values, Target)
  if type(Values) ~= "table" then
    return false
  end
  for _, Value in ipairs(Values) do
    if ToInteger(Value) == Target then
      return true
    end
  end
  return false
end

local function GetMaxTeamMember()
  local Config = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.MaxTeamMember
  return ToInteger(Config and Config.ConstantValue) or DefaultMaxTeamMember
end

local function GetChatMessageMaxLength()
  local Config = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.ChatMsgMaxLen
  return ToInteger(Config and Config.ConstantValue) or DefaultChatMessageMaxLength
end

local function SafeGText(TextKey)
  if not TextKey or "" == TextKey or type(GText) ~= "function" then
    return ""
  end
  local bSuccess, Text = pcall(GText, TextKey)
  return bSuccess and Text or ""
end

local function TrimText(Text)
  return string.gsub(tostring(Text or ""), "^%s*(.-)%s*$", "%1")
end

local function IsValidCustomTag(Text)
  Text = TrimText(Text)
  if "" == Text or string.find(Text, "[%z\001-\031\127]") then
    return false
  end
  local bValid, CharCount = pcall(utf8.len, Text)
  if not bValid or nil == CharCount then
    return false
  end
  local TextLength = 0
  for _, CodePoint in utf8.codes(Text) do
    TextLength = TextLength + (CodePoint <= 127 and 1 or 2)
  end
  return TextLength > 0 and TextLength <= MaxCustomTagTextLength
end

local function EncodeBase36(Number)
  Number = ToInteger(Number)
  if not Number or Number < 0 then
    return nil
  end
  if 0 == Number then
    return "0"
  end
  local Chars = {}
  while Number > 0 do
    local Remainder = Number % 36
    Chars[#Chars + 1] = string.sub(Base36Chars, Remainder + 1, Remainder + 1)
    Number = Number // 36
  end
  local Left = 1
  local Right = #Chars
  while Left < Right do
    Chars[Left], Chars[Right] = Chars[Right], Chars[Left]
    Left = Left + 1
    Right = Right - 1
  end
  return table.concat(Chars)
end

local function DecodeBase36(Code)
  if type(Code) ~= "string" or "" == Code or not string.match(Code, "^[0-9a-z]+$") then
    return nil
  end
  local Number = 0
  for Index = 1, #Code do
    local Char = string.sub(Code, Index, Index)
    local Position = string.find(Base36Chars, Char, 1, true)
    local Digit = Position and Position - 1 or nil
    if not Digit or Number > (math.maxinteger - Digit) // 36 then
      return nil
    end
    Number = Number * 36 + Digit
  end
  return Number
end

local function SplitPayload(Text)
  local Parts = {}
  local StartIndex = 1
  while true do
    local SeparatorIndex = string.find(Text, "|", StartIndex, true)
    if not SeparatorIndex then
      Parts[#Parts + 1] = string.sub(Text, StartIndex)
      return Parts
    end
    Parts[#Parts + 1] = string.sub(Text, StartIndex, SeparatorIndex - 1)
    StartIndex = SeparatorIndex + 1
  end
end

local function ReadDelimited(Text, StartIndex)
  local SeparatorIndex = string.find(Text, "|", StartIndex, true)
  if not SeparatorIndex then
    return string.sub(Text, StartIndex), #Text + 1, false
  end
  return string.sub(Text, StartIndex, SeparatorIndex - 1), SeparatorIndex + 1, true
end

local function ValidateSnapshot(Snapshot)
  if type(Snapshot) ~= "table" then
    return nil, "invalid_snapshot"
  end
  local Version = ToInteger(Snapshot.Version) or ProtocolVersionV1
  if Version ~= ProtocolVersionV1 and Version ~= ProtocolVersionV2 and Version ~= ProtocolVersionV3 then
    return nil, "invalid_version"
  end
  local RecruitmentId = ToInteger(Snapshot.RecruitmentId)
  local RecruitmentOwnerUid = ToInteger(Snapshot.RecruitmentOwnerUid)
  local MemberCount = ToInteger(Snapshot.MemberCount)
  local FirstType = ToInteger(Snapshot.FirstType)
  local SecondType = ToInteger(Snapshot.SecondType)
  local DungeonLevel = Snapshot.DungeonLevel == nil and 0 or ToInteger(Snapshot.DungeonLevel)
  local MaxTeamMember = GetMaxTeamMember()
  if not RecruitmentId or RecruitmentId <= 0 then
    return nil, "invalid_recruitment_id"
  end
  if not RecruitmentOwnerUid or RecruitmentOwnerUid <= 0 then
    return nil, "invalid_owner_uid"
  end
  if not MemberCount or MemberCount <= 0 or MemberCount > MaxTeamMember then
    return nil, "invalid_member_count"
  end
  if not (FirstType and SecondType and DungeonLevel) or FirstType <= 0 or SecondType <= 0 or DungeonLevel < 0 then
    return nil, "invalid_recruitment_config"
  end
  local FirstTypeConfig = DataMgr and DataMgr.TeamFirstType and DataMgr.TeamFirstType[FirstType]
  local SecondTypeConfig = DataMgr and DataMgr.TeamSecondType and DataMgr.TeamSecondType[SecondType]
  if not (FirstTypeConfig and SecondTypeConfig) or "table" ~= type(FirstTypeConfig.SecondTypes) or not ContainsInteger(FirstTypeConfig.SecondTypes, SecondType) then
    return nil, "invalid_recruitment_config"
  end
  local DungeonLevels = SecondTypeConfig.DungeonLevel
  if nil ~= DungeonLevels and (type(DungeonLevels) ~= "table" or DungeonLevel <= 0 or not ContainsInteger(DungeonLevels, DungeonLevel)) then
    return nil, "invalid_dungeon_level"
  end
  if nil == DungeonLevels and 0 ~= DungeonLevel then
    return nil, "invalid_dungeon_level"
  end
  if nil ~= Snapshot.Tags and "table" ~= type(Snapshot.Tags) then
    return nil, "invalid_tag"
  end
  if nil ~= Snapshot.CustomTags and "table" ~= type(Snapshot.CustomTags) then
    return nil, "invalid_tag"
  end
  local Tags = {}
  local CustomTags = {}
  local TagEntries = {}
  for _, Value in ipairs(Snapshot.Tags or {}) do
    local TagId = ToInteger(Value)
    local TagConfig = TagId and DataMgr and DataMgr.TagText and DataMgr.TagText[TagId]
    if not (TagId and not (TagId <= 0) and TagConfig) or not ContainsInteger(SecondTypeConfig.Tags, TagId) then
      return nil, "invalid_tag"
    end
    if #TagEntries >= 2 then
      return nil, "invalid_tag"
    end
    Tags[#Tags + 1] = TagId
    TagEntries[#TagEntries + 1] = {Kind = "Preset", Value = TagId}
  end
  for _, Value in ipairs(Snapshot.CustomTags or {}) do
    local Text = TrimText(Value)
    if not IsValidCustomTag(Text) then
      return nil, "invalid_tag"
    end
    if #TagEntries >= 2 then
      return nil, "invalid_tag"
    end
    CustomTags[#CustomTags + 1] = Text
    TagEntries[#TagEntries + 1] = {Kind = "Custom", Value = Text}
  end
  return {
    Version = Version,
    RecruitmentId = RecruitmentId,
    RecruitmentOwnerUid = RecruitmentOwnerUid,
    MemberCount = MemberCount,
    FirstType = FirstType,
    SecondType = SecondType,
    DungeonLevel = DungeonLevel,
    Tags = Tags,
    CustomTags = CustomTags,
    TagEntries = TagEntries
  }
end

local function EncodeTagToken(TagEntry)
  if not TagEntry then
    return "0"
  end
  if TagEntry.Kind == "Preset" then
    local TagId = EncodeBase36(TagEntry.Value)
    return TagId and "p" .. TagId or nil
  end
  if TagEntry.Kind == "Custom" and IsValidCustomTag(TagEntry.Value) then
    local Text = TrimText(TagEntry.Value)
    return "c" .. EncodeBase36(#Text) .. ":" .. Text
  end
  return nil
end

function M.Encode(Snapshot, SenderUid)
  local NormalizedSnapshot, ErrorMessage = ValidateSnapshot(Snapshot)
  if not NormalizedSnapshot then
    return nil, ErrorMessage
  end
  local NormalizedSenderUid
  if nil ~= SenderUid then
    NormalizedSenderUid = ToInteger(SenderUid)
    if not NormalizedSenderUid or NormalizedSenderUid <= 0 then
      return nil, "invalid_sender_uid"
    end
  end
  local bMemberShare = nil ~= NormalizedSenderUid and not IsSameInteger(NormalizedSenderUid, NormalizedSnapshot.RecruitmentOwnerUid)
  local Version = bMemberShare and ProtocolVersionV3 or #NormalizedSnapshot.CustomTags > 0 and ProtocolVersionV2 or ProtocolVersionV1
  local Parts
  if Version == ProtocolVersionV1 then
    local Tags = NormalizedSnapshot.Tags
    Parts = {
      tostring(ProtocolVersionV1),
      EncodeBase36(NormalizedSnapshot.RecruitmentId),
      EncodeBase36(NormalizedSnapshot.RecruitmentOwnerUid),
      EncodeBase36(NormalizedSnapshot.MemberCount),
      EncodeBase36(NormalizedSnapshot.FirstType),
      EncodeBase36(NormalizedSnapshot.SecondType),
      EncodeBase36(NormalizedSnapshot.DungeonLevel),
      EncodeBase36(Tags[1] or 0),
      EncodeBase36(Tags[2] or 0)
    }
  elseif Version == ProtocolVersionV2 then
    local Tag1 = EncodeTagToken(NormalizedSnapshot.TagEntries[1])
    local Tag2 = EncodeTagToken(NormalizedSnapshot.TagEntries[2])
    if not Tag1 or not Tag2 then
      return nil, "invalid_tag"
    end
    Parts = {
      tostring(ProtocolVersionV2),
      EncodeBase36(NormalizedSnapshot.RecruitmentId),
      EncodeBase36(NormalizedSnapshot.MemberCount),
      EncodeBase36(NormalizedSnapshot.FirstType),
      EncodeBase36(NormalizedSnapshot.SecondType),
      EncodeBase36(NormalizedSnapshot.DungeonLevel),
      Tag1,
      Tag2
    }
  else
    local Tag1 = EncodeTagToken(NormalizedSnapshot.TagEntries[1])
    local Tag2 = EncodeTagToken(NormalizedSnapshot.TagEntries[2])
    if not Tag1 or not Tag2 then
      return nil, "invalid_tag"
    end
    Parts = {
      tostring(ProtocolVersionV3),
      EncodeBase36(NormalizedSnapshot.RecruitmentId),
      EncodeBase36(NormalizedSnapshot.RecruitmentOwnerUid),
      EncodeBase36(NormalizedSnapshot.MemberCount),
      EncodeBase36(NormalizedSnapshot.FirstType),
      EncodeBase36(NormalizedSnapshot.SecondType),
      EncodeBase36(NormalizedSnapshot.DungeonLevel),
      Tag1,
      Tag2
    }
  end
  local Content = M.Header .. table.concat(Parts, "|")
  if #Content > GetChatMessageMaxLength() then
    return nil, "message_too_long"
  end
  return Content
end

local function DecodeV1(Payload, SenderUid)
  local Parts = SplitPayload(Payload)
  if 9 ~= #Parts or Parts[1] ~= tostring(ProtocolVersionV1) then
    return nil
  end
  local Snapshot = {
    Version = ProtocolVersionV1,
    RecruitmentId = DecodeBase36(Parts[2]),
    RecruitmentOwnerUid = DecodeBase36(Parts[3]),
    MemberCount = DecodeBase36(Parts[4]),
    FirstType = DecodeBase36(Parts[5]),
    SecondType = DecodeBase36(Parts[6]),
    DungeonLevel = DecodeBase36(Parts[7]),
    Tags = {},
    CustomTags = {}
  }
  if "0" ~= Parts[8] then
    local TagId = DecodeBase36(Parts[8])
    if not TagId then
      return nil
    end
    Snapshot.Tags[#Snapshot.Tags + 1] = TagId
  end
  if "0" ~= Parts[9] then
    local TagId = DecodeBase36(Parts[9])
    if not TagId then
      return nil
    end
    Snapshot.Tags[#Snapshot.Tags + 1] = TagId
  end
  if not (Snapshot.RecruitmentId and Snapshot.RecruitmentOwnerUid and Snapshot.MemberCount and Snapshot.FirstType and Snapshot.SecondType) or Snapshot.DungeonLevel == nil then
    return nil
  end
  if nil ~= SenderUid and not IsSameInteger(SenderUid, Snapshot.RecruitmentOwnerUid) then
    return nil
  end
  return ValidateSnapshot(Snapshot)
end

local function DecodeTagToken(Payload, StartIndex)
  local Prefix = string.sub(Payload, StartIndex, StartIndex)
  if "0" == Prefix then
    return {Kind = "None"}, StartIndex + 1
  end
  if "p" == Prefix then
    local SeparatorIndex = string.find(Payload, "|", StartIndex + 1, true)
    local Code = SeparatorIndex and string.sub(Payload, StartIndex + 1, SeparatorIndex - 1) or string.sub(Payload, StartIndex + 1)
    local TagId = DecodeBase36(Code)
    if not TagId or TagId <= 0 then
      return nil
    end
    return {Kind = "Preset", Value = TagId}, SeparatorIndex or #Payload + 1
  end
  if "c" ~= Prefix then
    return nil
  end
  local ColonIndex = string.find(Payload, ":", StartIndex + 1, true)
  if not ColonIndex then
    return nil
  end
  local ByteLength = DecodeBase36(string.sub(Payload, StartIndex + 1, ColonIndex - 1))
  if not ByteLength or ByteLength <= 0 or ByteLength > GetChatMessageMaxLength() then
    return nil
  end
  local TextStartIndex = ColonIndex + 1
  local TextEndIndex = TextStartIndex + ByteLength - 1
  if TextEndIndex > #Payload then
    return nil
  end
  local Text = string.sub(Payload, TextStartIndex, TextEndIndex)
  if not IsValidCustomTag(Text) then
    return nil
  end
  return {Kind = "Custom", Value = Text}, TextEndIndex + 1
end

local function DecodeV2(Payload, SenderUid)
  local RecruitmentOwnerUid = ToInteger(SenderUid)
  if not RecruitmentOwnerUid or RecruitmentOwnerUid <= 0 then
    return nil
  end
  local Fields = {}
  local Cursor = 1
  for Index = 1, 6 do
    local Field, NextIndex, bHasSeparator = ReadDelimited(Payload, Cursor)
    if not bHasSeparator then
      return nil
    end
    Fields[Index] = Field
    Cursor = NextIndex
  end
  if Fields[1] ~= tostring(ProtocolVersionV2) then
    return nil
  end
  local Tag1, NextIndex = DecodeTagToken(Payload, Cursor)
  if not Tag1 or string.sub(Payload, NextIndex, NextIndex) ~= "|" then
    return nil
  end
  local Tag2, EndIndex = DecodeTagToken(Payload, NextIndex + 1)
  if not Tag2 or EndIndex ~= #Payload + 1 then
    return nil
  end
  local Snapshot = {
    Version = ProtocolVersionV2,
    RecruitmentId = DecodeBase36(Fields[2]),
    RecruitmentOwnerUid = RecruitmentOwnerUid,
    MemberCount = DecodeBase36(Fields[3]),
    FirstType = DecodeBase36(Fields[4]),
    SecondType = DecodeBase36(Fields[5]),
    DungeonLevel = DecodeBase36(Fields[6]),
    Tags = {},
    CustomTags = {}
  }
  for _, Tag in ipairs({Tag1, Tag2}) do
    if Tag.Kind == "Preset" then
      Snapshot.Tags[#Snapshot.Tags + 1] = Tag.Value
    elseif Tag.Kind == "Custom" then
      Snapshot.CustomTags[#Snapshot.CustomTags + 1] = Tag.Value
    end
  end
  if not (Snapshot.RecruitmentId and Snapshot.MemberCount and Snapshot.FirstType and Snapshot.SecondType) or Snapshot.DungeonLevel == nil then
    return nil
  end
  return ValidateSnapshot(Snapshot)
end

local function DecodeV3(Payload, SenderUid)
  local MessageSenderUid = ToInteger(SenderUid)
  if not MessageSenderUid or MessageSenderUid <= 0 then
    return nil
  end
  local Fields = {}
  local Cursor = 1
  for Index = 1, 7 do
    local Field, NextIndex, bHasSeparator = ReadDelimited(Payload, Cursor)
    if not bHasSeparator then
      return nil
    end
    Fields[Index] = Field
    Cursor = NextIndex
  end
  if Fields[1] ~= tostring(ProtocolVersionV3) then
    return nil
  end
  local Tag1, NextIndex = DecodeTagToken(Payload, Cursor)
  if not Tag1 or string.sub(Payload, NextIndex, NextIndex) ~= "|" then
    return nil
  end
  local Tag2, EndIndex = DecodeTagToken(Payload, NextIndex + 1)
  if not Tag2 or EndIndex ~= #Payload + 1 then
    return nil
  end
  local Snapshot = {
    Version = ProtocolVersionV3,
    RecruitmentId = DecodeBase36(Fields[2]),
    RecruitmentOwnerUid = DecodeBase36(Fields[3]),
    MemberCount = DecodeBase36(Fields[4]),
    FirstType = DecodeBase36(Fields[5]),
    SecondType = DecodeBase36(Fields[6]),
    DungeonLevel = DecodeBase36(Fields[7]),
    Tags = {},
    CustomTags = {}
  }
  for _, Tag in ipairs({Tag1, Tag2}) do
    if Tag.Kind == "Preset" then
      Snapshot.Tags[#Snapshot.Tags + 1] = Tag.Value
    elseif Tag.Kind == "Custom" then
      Snapshot.CustomTags[#Snapshot.CustomTags + 1] = Tag.Value
    end
  end
  if not (Snapshot.RecruitmentId and Snapshot.RecruitmentOwnerUid and Snapshot.MemberCount and Snapshot.FirstType and Snapshot.SecondType) or Snapshot.DungeonLevel == nil then
    return nil
  end
  return ValidateSnapshot(Snapshot)
end

function M.Decode(Content, SenderUid)
  if type(Content) ~= "string" or string.sub(Content, 1, #M.Header) ~= M.Header then
    return nil, false
  end
  if #Content > GetChatMessageMaxLength() then
    return nil, true
  end
  local Payload = string.sub(Content, #M.Header + 1)
  local Version = string.match(Payload, "^(%d+)|")
  local Snapshot
  if Version == tostring(ProtocolVersionV1) then
    Snapshot = DecodeV1(Payload, SenderUid)
  elseif Version == tostring(ProtocolVersionV2) then
    Snapshot = DecodeV2(Payload, SenderUid)
  elseif Version == tostring(ProtocolVersionV3) then
    Snapshot = DecodeV3(Payload, SenderUid)
  end
  if Snapshot then
    Snapshot.MessageSenderUid = ToInteger(SenderUid)
  end
  return Snapshot, true
end

function M.FindRecruitment(RawData, RecruitmentId)
  local ExpectedId = ToInteger(RecruitmentId)
  if type(RawData) ~= "table" or not ExpectedId then
    return nil
  end
  local HallData = TeamHallDatas.TeamHallData.New(RawData)
  for _, RecruitmentData in ipairs(HallData:GetRecruitmentList()) do
    if ToInteger(RecruitmentData.RecruitmentId) == ExpectedId then
      return RecruitmentData
    end
  end
  return nil
end

function M.BuildSnapshot(RecruitmentData, RecruitmentOwnerUid, MemberCount)
  if type(RecruitmentData) ~= "table" then
    return nil, "invalid_recruitment_data"
  end
  return ValidateSnapshot({
    RecruitmentId = RecruitmentData.RecruitmentId,
    RecruitmentOwnerUid = RecruitmentOwnerUid,
    MemberCount = MemberCount,
    FirstType = RecruitmentData.FirstType,
    SecondType = RecruitmentData.SecondType,
    DungeonLevel = RecruitmentData.DungeonLevel,
    Tags = RecruitmentData.Tags,
    CustomTags = RecruitmentData.CustomTags
  })
end

function M.BuildDisplayData(Snapshot)
  local NormalizedSnapshot = ValidateSnapshot(Snapshot)
  local EmptyData = {
    FirstTypeText = "",
    SecondTypeText = "",
    DungeonLevelText = "",
    MemberCountText = "",
    IconPath = nil,
    TagTexts = {}
  }
  if not NormalizedSnapshot then
    return EmptyData
  end
  local FirstTypeConfig = DataMgr.TeamFirstType[NormalizedSnapshot.FirstType]
  local SecondTypeConfig = DataMgr.TeamSecondType[NormalizedSnapshot.SecondType]
  local FirstTypeText = SafeGText(FirstTypeConfig.Name)
  local SecondTypeText = SafeGText(SecondTypeConfig.Name)
  local TagTexts = {}
  for _, TagEntry in ipairs(NormalizedSnapshot.TagEntries) do
    local TagText = ""
    if TagEntry.Kind == "Preset" then
      local TagConfig = DataMgr.TagText[TagEntry.Value]
      TagText = SafeGText(TagConfig and TagConfig.TagText)
    elseif TagEntry.Kind == "Custom" then
      TagText = TagEntry.Value
    end
    if "" ~= TagText then
      TagTexts[#TagTexts + 1] = TagText
    end
  end
  return {
    FirstTypeText = FirstTypeText,
    SecondTypeText = "" ~= SecondTypeText and "·" .. SecondTypeText or "",
    DungeonLevelText = NormalizedSnapshot.DungeonLevel > 0 and "Lv." .. tostring(NormalizedSnapshot.DungeonLevel) or "",
    MemberCountText = string.format("%d/%d", NormalizedSnapshot.MemberCount, GetMaxTeamMember()),
    IconPath = SecondTypeConfig.Icon,
    TagTexts = TagTexts
  }
end

function M.BuildCompactText(Snapshot)
  local DisplayData = M.BuildDisplayData(Snapshot)
  local Prefix = SafeGText("UI_RecruitMembers")
  local DetailText = (DisplayData.FirstTypeText or "") .. (DisplayData.SecondTypeText or "")
  if "" == DetailText then
    return Prefix
  end
  return string.format("%s：%s", Prefix, DetailText)
end

M.EncodeBase36 = EncodeBase36
M.DecodeBase36 = DecodeBase36
return M
