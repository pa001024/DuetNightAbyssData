local EMCache = require("EMCache.EMCache")
local M = {}
M.CacheKey = "TeamHallRecruitDraft"
M.SchemaVersion = 1
M.MaxSelectedTagCount = 2
M.MaxCustomTagCount = 5
M.MaxTagSlotCount = 15
M.MaxCustomTagCharCount = 4
M.MaxCustomTagTextLength = M.MaxCustomTagCharCount * 2

local function ToInteger(Value)
  if type(Value) == "number" then
    return math.tointeger(Value)
  end
  if type(Value) ~= "string" or not string.match(Value, "^%d+$") then
    return nil
  end
  return math.tointeger(tonumber(Value))
end

local function DeepCopy(Value, Seen)
  if type(Value) ~= "table" then
    return Value
  end
  Seen = Seen or {}
  if Seen[Value] then
    return Seen[Value]
  end
  local Copy = {}
  Seen[Value] = Copy
  for Key, Item in pairs(Value) do
    Copy[DeepCopy(Key, Seen)] = DeepCopy(Item, Seen)
  end
  return Copy
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

local function TrimText(Text)
  return string.gsub(tostring(Text or ""), "^%s*(.-)%s*$", "%1")
end

local function GetEquivalentTextLength(Text)
  local bUtf8Valid, CharCount = pcall(utf8.len, Text)
  if not bUtf8Valid or nil == CharCount then
    return nil
  end
  local Length = 0
  for _, CodePoint in utf8.codes(Text) do
    Length = Length + (CodePoint <= 127 and 1 or 2)
  end
  return Length
end

local function GetVisibleTypeValue(Name)
  return CommonConst and CommonConst.TeamHallVisibleType and CommonConst.TeamHallVisibleType[Name]
end

local function SortByDisplayOrder(Left, Right)
  if Left.DisplayOrder == Right.DisplayOrder then
    return Left.Id < Right.Id
  end
  return Left.DisplayOrder < Right.DisplayOrder
end

function M.IsCustomTagTextValid(Text)
  Text = TrimText(Text)
  if "" == Text or string.find(Text, "[%z\001-\031\127]") then
    return false
  end
  local TextLength = GetEquivalentTextLength(Text)
  if not TextLength or TextLength > M.MaxCustomTagTextLength then
    return false
  end
  return TextLength > 0
end

function M.GetCustomTagTextLength(Text)
  return GetEquivalentTextLength(tostring(Text or ""))
end

function M.TrimCustomTagText(Text)
  return TrimText(Text)
end

function M.GetFirstTypeOptions()
  local Options = {}
  for FirstType, Config in pairs(DataMgr.TeamFirstType or {}) do
    local FirstTypeId = ToInteger(FirstType)
    if FirstTypeId and type(Config.SecondTypes) == "table" and #Config.SecondTypes > 0 then
      Options[#Options + 1] = {
        Id = FirstTypeId,
        DisplayOrder = ToInteger(Config.DisplayOrder) or FirstTypeId,
        TextKey = Config.Name
      }
    end
  end
  table.sort(Options, SortByDisplayOrder)
  return Options
end

function M.GetSecondTypeOptions(FirstType)
  local FirstTypeId = ToInteger(FirstType)
  local FirstTypeConfig = FirstTypeId and DataMgr.TeamFirstType and DataMgr.TeamFirstType[FirstTypeId]
  if not FirstTypeConfig or type(FirstTypeConfig.SecondTypes) ~= "table" then
    return {}
  end
  local Options = {}
  for _, SecondType in ipairs(FirstTypeConfig.SecondTypes) do
    local SecondTypeId = ToInteger(SecondType)
    local SecondTypeConfig = SecondTypeId and DataMgr.TeamSecondType and DataMgr.TeamSecondType[SecondTypeId]
    if SecondTypeId and SecondTypeConfig then
      Options[#Options + 1] = {
        Id = SecondTypeId,
        DisplayOrder = ToInteger(SecondTypeConfig.DisplayOrder) or SecondTypeId,
        TextKey = SecondTypeConfig.Name
      }
    end
  end
  table.sort(Options, SortByDisplayOrder)
  return Options
end

function M.IsValidTarget(FirstType, SecondType)
  local FirstTypeId = ToInteger(FirstType)
  local SecondTypeId = ToInteger(SecondType)
  local FirstTypeConfig = FirstTypeId and DataMgr.TeamFirstType and DataMgr.TeamFirstType[FirstTypeId]
  return nil ~= FirstTypeConfig and type(FirstTypeConfig.SecondTypes) == "table" and nil ~= SecondTypeId and DataMgr.TeamSecondType and nil ~= DataMgr.TeamSecondType[SecondTypeId] and ContainsInteger(FirstTypeConfig.SecondTypes, SecondTypeId)
end

function M.GetDungeonLevelOptions(SecondType)
  local SecondTypeId = ToInteger(SecondType)
  local Config = SecondTypeId and DataMgr.TeamSecondType and DataMgr.TeamSecondType[SecondTypeId]
  if not Config then
    return {}
  end
  if Config.DungeonLevel == nil then
    return {
      {
        Id = 0,
        Value = 0,
        TextKey = "UI_TeamNoLevelLimit"
      }
    }
  end
  if type(Config.DungeonLevel) ~= "table" then
    return {}
  end
  local Options = {}
  for Index, LevelValue in ipairs(Config.DungeonLevel) do
    local Level = ToInteger(LevelValue)
    if Level and Level > 0 then
      Options[#Options + 1] = {
        Id = Index,
        Value = Level,
        Text = "Lv." .. tostring(Level)
      }
    end
  end
  return Options
end

function M.GetHighestDungeonLevel(SecondType)
  local SelectedIndex = 0
  local SelectedValue = 0
  for _, Option in ipairs(M.GetDungeonLevelOptions(SecondType)) do
    if SelectedValue < Option.Value then
      SelectedIndex = Option.Id
      SelectedValue = Option.Value
    end
  end
  return SelectedIndex, SelectedValue
end

function M.FindDungeonLevelIndex(SecondType, DungeonLevelValue)
  local TargetValue = ToInteger(DungeonLevelValue)
  if not TargetValue then
    return nil
  end
  for _, Option in ipairs(M.GetDungeonLevelOptions(SecondType)) do
    if Option.Value == TargetValue then
      return Option.Id
    end
  end
  return nil
end

function M.GetPresetTagOptions(SecondType)
  local SecondTypeId = ToInteger(SecondType)
  local Config = SecondTypeId and DataMgr.TeamSecondType and DataMgr.TeamSecondType[SecondTypeId]
  if not Config or type(Config.Tags) ~= "table" then
    return {}
  end
  local Options = {}
  for _, TagIdValue in ipairs(Config.Tags) do
    local TagId = ToInteger(TagIdValue)
    local TagConfig = TagId and DataMgr.TagText and DataMgr.TagText[TagId]
    if TagId and TagConfig then
      Options[#Options + 1] = {
        Id = TagId,
        TextKey = TagConfig.TagText
      }
    end
  end
  return Options
end

function M.NormalizeVisibleTypes(VisibleTypes)
  local Public = GetVisibleTypeValue("Public")
  local Friend = GetVisibleTypeValue("Friend")
  local Guild = GetVisibleTypeValue("Guild")
  local Selected = {}
  for _, Value in ipairs(VisibleTypes or {}) do
    local TypeValue = ToInteger(Value)
    if TypeValue == Friend or TypeValue == Guild or TypeValue == Public then
      Selected[TypeValue] = true
    end
  end
  if Selected[Friend] or Selected[Guild] then
    local Result = {}
    if Selected[Friend] then
      Result[#Result + 1] = Friend
    end
    if Selected[Guild] then
      Result[#Result + 1] = Guild
    end
    return Result
  end
  return Public and {Public} or {}
end

local function NormalizeCustomTagOptions(CustomTagOptions)
  local Result = {}
  local Seen = {}
  for _, Text in ipairs(CustomTagOptions or {}) do
    Text = TrimText(Text)
    if M.IsCustomTagTextValid(Text) and not Seen[Text] then
      Seen[Text] = true
      Result[#Result + 1] = Text
      if #Result >= M.MaxCustomTagCount then
        break
      end
    end
  end
  return Result
end

function M.NormalizeDraft(Draft)
  if type(Draft) ~= "table" then
    return nil
  end
  local FirstType = ToInteger(Draft.FirstType)
  local SecondType = ToInteger(Draft.SecondType)
  if not M.IsValidTarget(FirstType, SecondType) then
    return nil
  end
  local DungeonLevelIndex = M.FindDungeonLevelIndex(SecondType, Draft.DungeonLevelValue)
  local DungeonLevelValue = ToInteger(Draft.DungeonLevelValue)
  if not DungeonLevelIndex then
    DungeonLevelIndex, DungeonLevelValue = M.GetHighestDungeonLevel(SecondType)
  end
  local CustomTagOptions = NormalizeCustomTagOptions(Draft.CustomTagOptions)
  local CustomTagSet = {}
  for _, Text in ipairs(CustomTagOptions) do
    CustomTagSet[Text] = true
  end
  local ValidPresetTagSet = {}
  for _, Option in ipairs(M.GetPresetTagOptions(SecondType)) do
    ValidPresetTagSet[Option.Id] = true
  end
  local SelectedTags = {}
  local SelectedSet = {}
  for _, Tag in ipairs(Draft.SelectedTags or {}) do
    if #SelectedTags >= M.MaxSelectedTagCount or type(Tag) ~= "table" then
      break
    end
    if Tag.Kind == "Preset" then
      local TagId = ToInteger(Tag.Value)
      local Key = TagId and "P:" .. tostring(TagId) or nil
      if TagId and ValidPresetTagSet[TagId] and not SelectedSet[Key] then
        SelectedSet[Key] = true
        SelectedTags[#SelectedTags + 1] = {Kind = "Preset", Value = TagId}
      end
    elseif Tag.Kind == "Custom" then
      local Text = TrimText(Tag.Value)
      local Key = "C:" .. Text
      if CustomTagSet[Text] and not SelectedSet[Key] then
        SelectedSet[Key] = true
        SelectedTags[#SelectedTags + 1] = {Kind = "Custom", Value = Text}
      end
    end
  end
  return {
    FirstType = FirstType,
    SecondType = SecondType,
    DungeonLevel = DungeonLevelIndex,
    DungeonLevelValue = DungeonLevelValue or 0,
    VisibleTypes = M.NormalizeVisibleTypes(Draft.VisibleTypes),
    CustomTagOptions = CustomTagOptions,
    SelectedTags = SelectedTags
  }
end

function M.BuildDefaultDraft()
  local FirstTypeOptions = M.GetFirstTypeOptions()
  for _, FirstTypeOption in ipairs(FirstTypeOptions) do
    local SecondTypeOptions = M.GetSecondTypeOptions(FirstTypeOption.Id)
    local SecondTypeOption = SecondTypeOptions[1]
    if SecondTypeOption then
      local DungeonLevel, DungeonLevelValue = M.GetHighestDungeonLevel(SecondTypeOption.Id)
      return {
        FirstType = FirstTypeOption.Id,
        SecondType = SecondTypeOption.Id,
        DungeonLevel = DungeonLevel,
        DungeonLevelValue = DungeonLevelValue,
        VisibleTypes = M.NormalizeVisibleTypes(nil),
        CustomTagOptions = {},
        SelectedTags = {}
      }
    end
  end
  return nil
end

function M.LoadDraft()
  local CachedSnapshot = EMCache:Get(M.CacheKey, true)
  if type(CachedSnapshot) == "table" and ToInteger(CachedSnapshot.SchemaVersion) == M.SchemaVersion then
    local Draft = M.NormalizeDraft(DeepCopy(CachedSnapshot))
    if Draft then
      return Draft
    end
  end
  return M.BuildDefaultDraft()
end

function M.BuildPersistedSnapshot(Draft)
  local NormalizedDraft = M.NormalizeDraft(Draft)
  if not NormalizedDraft then
    return nil
  end
  NormalizedDraft.SchemaVersion = M.SchemaVersion
  return DeepCopy(NormalizedDraft)
end

function M.SavePersistedSnapshot(Snapshot)
  local PersistedSnapshot = M.BuildPersistedSnapshot(Snapshot)
  if PersistedSnapshot then
    EMCache:Set(M.CacheKey, PersistedSnapshot, true)
    EMCache:SaveUser(false)
  end
end

function M.BuildRecruitmentInfo(Draft)
  local NormalizedDraft = M.NormalizeDraft(Draft)
  if not NormalizedDraft then
    return nil
  end
  local Tags = {}
  local CustomTags = {}
  for _, Tag in ipairs(NormalizedDraft.SelectedTags) do
    if Tag.Kind == "Preset" then
      Tags[#Tags + 1] = Tag.Value
    elseif Tag.Kind == "Custom" then
      CustomTags[#CustomTags + 1] = Tag.Value
    end
  end
  return {
    FirstType = NormalizedDraft.FirstType,
    SecondType = NormalizedDraft.SecondType,
    DungeonLevel = NormalizedDraft.DungeonLevel,
    VisibleType = DeepCopy(NormalizedDraft.VisibleTypes),
    Tags = Tags,
    CustomTags = CustomTags
  }
end

function M.ChangeTarget(Draft, FirstType, SecondType)
  local NewDraft = DeepCopy(Draft or {})
  FirstType = ToInteger(FirstType)
  SecondType = ToInteger(SecondType)
  if not M.IsValidTarget(FirstType, SecondType) then
    return nil
  end
  local DungeonLevel, DungeonLevelValue = M.GetHighestDungeonLevel(SecondType)
  NewDraft.FirstType = FirstType
  NewDraft.SecondType = SecondType
  NewDraft.DungeonLevel = DungeonLevel
  NewDraft.DungeonLevelValue = DungeonLevelValue
  return M.NormalizeDraft(NewDraft)
end

function M.ChangeDungeonLevel(Draft, DungeonLevelIndex)
  local NewDraft = DeepCopy(Draft or {})
  local TargetIndex = ToInteger(DungeonLevelIndex)
  local Options = M.GetDungeonLevelOptions(NewDraft.SecondType)
  for _, Option in ipairs(Options) do
    if Option.Id == TargetIndex then
      NewDraft.DungeonLevel = Option.Id
      NewDraft.DungeonLevelValue = Option.Value
      return M.NormalizeDraft(NewDraft)
    end
  end
  return nil
end

M.DeepCopy = DeepCopy
return M
