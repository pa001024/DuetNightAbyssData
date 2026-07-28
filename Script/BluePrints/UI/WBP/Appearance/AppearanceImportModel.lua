require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local AppearanceShareModel = require("BluePrints.UI.WBP.Appearance.AppearanceShareModel")
local M = {}
local DefaultPlanNamePrefix = "UI_Squad_Appearance_TITLE"
local MsgSelectPlanFirst = "请选择导入方案"
local EmptyAccessoryId = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.EmptyCharAccessoryID and DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue or 0
local DefaultPlanCount = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.CharColorPlan and DataMgr.GlobalConstant.CharColorPlan.ConstantValue or 3

local function ImportModelScreenPrint(Message)
  ScreenPrint("[AppearanceImportModel] " .. tostring(Message))
end

local function TrimText(Text)
  if not Text then
    return ""
  end
  return string.gsub(Text, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1")
end

local function TruncateText(Text, MaxLen)
  Text = tostring(Text or "")
  MaxLen = MaxLen or 120
  if MaxLen >= string.len(Text) then
    return Text
  end
  return string.sub(Text, 1, MaxLen) .. "..."
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

local function NormalizeAccessoryFields(AppearanceInfo)
  if type(AppearanceInfo) ~= "table" then
    return {}
  end
  local AccessorySuit = AppearanceInfo.AccessorySuit or AppearanceInfo.Accessory or {}
  AppearanceInfo.AccessorySuit = AccessorySuit
  AppearanceInfo.Accessory = AccessorySuit
  AppearanceInfo.AccessoryCustomParams = AppearanceInfo.AccessoryCustomParams or {}
  return AccessorySuit
end

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

local function SafeOptionalNumber(Value, DefaultValue)
  if nil == Value or "" == Value then
    return DefaultValue
  end
  return SafeNumber(Value, DefaultValue or 0)
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

local AppearanceScoreRuleTable, AppearanceSingleScoreTable

local function EnsureAppearanceScoreRuleTable()
  if AppearanceScoreRuleTable and AppearanceSingleScoreTable then
    return
  end
  AppearanceScoreRuleTable = {}
  for _, Info in pairs(DataMgr.AppearanceScore or {}) do
    if Info and Info.Type then
      AppearanceScoreRuleTable[Info.Type] = AppearanceScoreRuleTable[Info.Type] or {}
      AppearanceScoreRuleTable[Info.Type][Info.Rarity] = Info.Score or 0
    end
  end
  AppearanceSingleScoreTable = {}
  for _, Info in pairs(DataMgr.AppearanceSingleScore or {}) do
    if Info and Info.Type then
      AppearanceSingleScoreTable[Info.Type] = AppearanceSingleScoreTable[Info.Type] or {}
      AppearanceSingleScoreTable[Info.Type][Info.Id] = Info.Score or 0
    end
  end
end

local function GetAppearanceScoreConfig(ItemType, ItemId)
  if "Skin" == ItemType then
    return DataMgr.Skin and DataMgr.Skin[ItemId] or nil, "Skin"
  end
  if "Hair" == ItemType then
    return DataMgr.Hair and DataMgr.Hair[ItemId] or nil, "CharAccessory"
  end
  if "CharAccessory" == ItemType or "CharPartMesh" == ItemType then
    local Config = DataMgr.CharAccessory and DataMgr.CharAccessory[ItemId] or DataMgr.CharPartMesh and DataMgr.CharPartMesh[ItemId] or nil
    return Config, "CharAccessory"
  end
  return nil, nil
end

local function GetPartMeshAccessoryInfoBySkinId(SkinId)
  SkinId = SafeNumber(SkinId, 0)
  if SkinId <= 0 then
    return nil, nil
  end
  for AccessoryId, Info in pairs(DataMgr.CharPartMesh or {}) do
    if Info and Info.PartName == "PartMesh" then
      for _, RelatedSkinId in pairs(Info.Skin or {}) do
        if SafeNumber(RelatedSkinId, 0) == SkinId then
          return SafeNumber(AccessoryId, 0), Info.AccessoryType
        end
      end
    end
  end
  return nil, nil
end

local function IsPartMeshAccessoryId(AccessoryId)
  AccessoryId = SafeNumber(AccessoryId, 0)
  return AccessoryId > 0 and DataMgr.CharPartMesh ~= nil and DataMgr.CharPartMesh[AccessoryId] ~= nil
end

local function HasExplicitEmptyPartMeshSlot(AppearanceInfo, SkinId)
  local _, PartMeshAccessoryType = GetPartMeshAccessoryInfoBySkinId(SkinId)
  if not PartMeshAccessoryType or not CommonConst.NewCharAccessoryTypes then
    return false
  end
  local AccessoryTypeIndex = CommonConst.NewCharAccessoryTypes[PartMeshAccessoryType]
  if not AccessoryTypeIndex then
    return false
  end
  local AccessorySuit = AppearanceInfo and (AppearanceInfo.AccessorySuit or AppearanceInfo.Accessory) or nil
  local AccessoryId = AccessorySuit and AccessorySuit[AccessoryTypeIndex] or nil
  return nil ~= AccessoryId and SafeNumber(AccessoryId, 0) == EmptyAccessoryId
end

local function CalcAppearancePartScore(ItemType, ItemId)
  ItemId = SafeNumber(ItemId, 0)
  if ItemId <= 0 then
    return 0
  end
  EnsureAppearanceScoreRuleTable()
  local Config, ScoreType = GetAppearanceScoreConfig(ItemType, ItemId)
  if not ScoreType then
    return 0
  end
  local SingleScore = AppearanceSingleScoreTable[ScoreType] and AppearanceSingleScoreTable[ScoreType][ItemId] or nil
  if nil ~= SingleScore then
    return SingleScore
  end
  local Rarity = Config and (Config.Rarity or Config.MountRarity) or 0
  return AppearanceScoreRuleTable[ScoreType] and AppearanceScoreRuleTable[ScoreType][Rarity] or 0
end

local function CalcAppearanceBaseScore(AppearanceInfo)
  if type(AppearanceInfo) ~= "table" then
    return 0
  end
  local TotalScore = 0
  TotalScore = TotalScore + CalcAppearancePartScore("Skin", AppearanceInfo.SkinId)
  TotalScore = TotalScore + CalcAppearancePartScore("Hair", AppearanceInfo.HairId)
  local AccessorySuit = AppearanceInfo.AccessorySuit or AppearanceInfo.Accessory or {}
  for _, AccessoryId in pairs(AccessorySuit) do
    TotalScore = TotalScore + CalcAppearancePartScore("CharAccessory", AccessoryId)
  end
  return TotalScore
end

local function FormatAppearanceScoreChange(TextKey, FromScore, ToScore)
  local FormatText = SafeGText(TextKey)
  if "" == FormatText then
    return tostring(FromScore or 0) .. " >> " .. tostring(ToScore or 0)
  end
  return string.format(FormatText, FromScore or 0, ToScore or 0)
end

local function BuildPreviewAppearanceMainModel(OwnerModel)
  local PreviewMainModel = {OwnerModel = OwnerModel}
  
  function PreviewMainModel:GetSelectedChar()
    return self.OwnerModel and self.OwnerModel.DummyChar or nil
  end
  
  function PreviewMainModel:GetSelectedCharAppearanceIndex()
    return 1
  end
  
  return PreviewMainModel
end

local function BuildDefaultAccessoryOwnedMap(CharData)
  local Result = {}
  local DefaultAccessory = CharData and CharData.DefaultAccessory or nil
  if type(DefaultAccessory) ~= "table" then
    return Result
  end
  for _, AccessoryId in pairs(DefaultAccessory) do
    AccessoryId = SafeNumber(AccessoryId, 0)
    if AccessoryId > 0 and AccessoryId ~= EmptyAccessoryId then
      Result[AccessoryId] = true
    end
  end
  return Result
end

local function NormalizeSharerInfo(PlanInfo)
  local SharerInfo = CloneTable(type(PlanInfo) == "table" and PlanInfo.SharerInfo or {})
  SharerInfo.Nickname = TrimText(SharerInfo.Nickname or type(PlanInfo) == "table" and PlanInfo.Nickname or "")
  SharerInfo.Level = SafeNumber(SharerInfo.Level or type(PlanInfo) == "table" and PlanInfo.Level, 0)
  SharerInfo.HeadIconId = SafeNumber(SharerInfo.HeadIconId or type(PlanInfo) == "table" and PlanInfo.HeadIconId, 0)
  SharerInfo.HeadFrameId = SafeNumber(SharerInfo.HeadFrameId or type(PlanInfo) == "table" and PlanInfo.HeadFrameId, 0)
  SharerInfo.TitleBefore = SafeOptionalNumber(SharerInfo.TitleBefore or type(PlanInfo) == "table" and PlanInfo.TitleBefore, nil)
  SharerInfo.TitleAfter = SafeOptionalNumber(SharerInfo.TitleAfter or type(PlanInfo) == "table" and PlanInfo.TitleAfter, nil)
  SharerInfo.TitleFrame = SafeOptionalNumber(SharerInfo.TitleFrame or type(PlanInfo) == "table" and PlanInfo.TitleFrame, nil)
  return SharerInfo
end

local function NormalizeAppearanceInfo(AppearanceInfo, CharId)
  if type(AppearanceInfo) ~= "table" then
    return nil
  end
  local Result = CloneTable(AppearanceInfo)
  Result.CharId = Result.CharId or CharId
  Result.SkinId = Result.SkinId or Result.CharSkinId
  Result.HairId = Result.HairId or Result.CharHairId
  Result.AccessorySuit = Result.AccessorySuit or Result.Accessory or {}
  Result.Accessory = Result.AccessorySuit
  Result.AccessoryCustomParams = Result.AccessoryCustomParams or {}
  Result.Colors = {}
  Result.HairColors = {}
  return Result
end

local function ResolveClipboardAppearancePlanInfo()
  local ClipboardText = TrimText(ULowEntryExtendedStandardLibrary.ClipboardGet())
  local AppearancePlanInfo = AppearanceShareModel.ParseAppearanceShareMsg(ClipboardText)
  if AppearancePlanInfo then
    return AppearancePlanInfo, ClipboardText
  end
  local CachedInfo = AppearanceShareModel.GetAppearancePlanInfoCopied()
  if CachedInfo and CachedInfo.MsgCopyed == ClipboardText and CachedInfo.AppearancePlanInfo then
    return CloneTable(CachedInfo.AppearancePlanInfo), ClipboardText
  end
  return nil, ClipboardText
end

local function ResolveParamAppearancePlanInfo(Params)
  if type(Params) ~= "table" then
    return nil, ""
  end
  local SourceText = TrimText(Params.SourceText)
  if "table" == type(Params.AppearancePlanInfo) then
    return CloneTable(Params.AppearancePlanInfo), SourceText
  end
  if "" == SourceText then
    return nil, SourceText
  end
  local AppearancePlanInfo = AppearanceShareModel.ParseAppearanceShareMsg(SourceText)
  if AppearancePlanInfo then
    return AppearancePlanInfo, SourceText
  end
  return nil, SourceText
end

local function ResolveInitialAppearancePlanInfo(Params)
  local AppearancePlanInfo, SourceText = ResolveParamAppearancePlanInfo(Params)
  if AppearancePlanInfo then
    return AppearancePlanInfo, SourceText
  end
  return ResolveClipboardAppearancePlanInfo()
end

local function BuildAppearanceItemContent(ItemType, ItemId, ParentWidget)
  if not ItemId or ItemId <= 0 then
    return nil
  end
  local Data
  if "CharPartMesh" == ItemType then
    Data = DataMgr.CharPartMesh and DataMgr.CharPartMesh[ItemId] or nil
  else
    Data = DataMgr[ItemType] and DataMgr[ItemType][ItemId] or nil
  end
  if not Data then
    return nil
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Type = ItemType
  Content.ItemType = ItemType
  Content.UnitId = ItemId
  Content.Id = ItemId
  Content.Icon = Data.Icon or Data.LongIcon
  Content.Rarity = Data.Rarity or 0
  Content.Count = 1
  Content.NeedCount = 1
  Content.IsShowDetails = true
  Content.ParentWidget = ParentWidget
  return Content
end

local function AddUniqueText(Result, Text, Mark)
  Text = tostring(Text or "")
  if "" == Text then
    return
  end
  if Mark[Text] then
    return
  end
  Mark[Text] = true
  table.insert(Result, Text)
end

local function HasAnyContent(Source)
  return type(Source) == "table" and #Source > 0
end

function M:New(Owner, Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj.Owner = Owner
  Obj.Params = Params or {}
  Obj.RealAvatar = GWorld:GetAvatar()
  Obj:Init()
  return Obj
end

function M:Init()
  self.SourceText = ""
  self.PlanInfo = nil
  self.PreviewAppearanceInfo = nil
  self.SelectedTargetCharUuid = self.Params.CharUuid
  self.SelectedTargetPlanIndex = nil
  self.TargetPlanItems = {}
  self.WarningText = ""
  self.DummyAvatar = nil
  self.DummyChar = nil
  self.PreviewMainModel = nil
  self.SourceOwnershipItems = {
    ImportableItems = {},
    UnableItems = {}
  }
  self.OwnedSkinMap = {}
  self.OwnedHairMap = {}
  self.OwnedAccessoryMap = {}
  self.DefaultOwnedAccessoryMap = {}
  self:ReloadImportSource()
end

function M:ReloadImportSource()
  self.PlanInfo, self.SourceText = ResolveInitialAppearancePlanInfo(self.Params)
  if not self.PlanInfo then
    self.ErrorText = GText("UI_COMMONPOP_TITLE_100059")
    ImportModelScreenPrint("resolve import source failed, SourceText=" .. TruncateText(self.SourceText))
    return false
  end
  self.ErrorText = nil
  self:BuildState()
  return true
end

function M:BuildState()
  local CharId = not self.PlanInfo.TargetId and self.PlanInfo.AppearanceInfo and self.PlanInfo.AppearanceInfo.CharId
  if not CharId then
    self.ErrorText = GText("UI_COMMONPOP_TITLE_100059")
    ImportModelScreenPrint("build state failed: CharId is nil")
    return
  end
  self.PlanInfo.TargetId = CharId
  self.CharId = CharId
  self.CharData = DataMgr.Char and DataMgr.Char[CharId] or nil
  self.DefaultOwnedAccessoryMap = BuildDefaultAccessoryOwnedMap(self.CharData)
  self.PlanInfo.TargetName = self.PlanInfo.TargetName or self.CharData and SafeGText(self.CharData.CharName) or ""
  self.PlanInfo.PlanName = self.PlanInfo.PlanName or ""
  self.PlanInfo.DisplayText = self.PlanInfo.DisplayText or string.format("%s - %s", self.PlanInfo.TargetName or "", self.PlanInfo.PlanName or "")
  self.PlanInfo.SharerInfo = NormalizeSharerInfo(self.PlanInfo)
  self.PreviewAppearanceInfo = NormalizeAppearanceInfo(self.PlanInfo.AppearanceInfo, CharId)
  if not self.PreviewAppearanceInfo then
    self.ErrorText = GText("UI_COMMONPOP_TITLE_100059")
    ImportModelScreenPrint("build state failed: preview appearance info invalid")
    return
  end
  self.AvatarName = self.PlanInfo.TargetName ~= "" and self.PlanInfo.TargetName or self.CharData and SafeGText(self.CharData.CharName) or ""
  self.LevelText = ""
  self.SharerInfo = self.PlanInfo.SharerInfo or {}
  self.SharerName = self.SharerInfo.Nickname or ""
  self.SharerLevelText = self.SharerInfo.Level and self.SharerInfo.Level > 0 and tostring(self.SharerInfo.Level) or ""
  self.TargetChar = self:ResolveTargetChar()
  if self.TargetChar then
    self.SelectedTargetCharUuid = self.TargetChar.Uuid
  end
  self:ClampSelectedPlanIndex()
  self:BuildPreviewAvatar()
  self:BuildPlanSelectionState()
  self:BuildOwnershipState()
  self:BuildImportConfirmState()
  self:BuildScoreState()
  self:BuildWarnings()
end

function M:ResolveTargetChar()
  if not self.RealAvatar or not self.CharId then
    return nil
  end
  if self.SelectedTargetCharUuid then
    local SelectedChar = self.RealAvatar.Chars and self.RealAvatar.Chars[self.SelectedTargetCharUuid] or nil
    if SelectedChar and SelectedChar.CharId == self.CharId then
      return SelectedChar
    end
  end
  for _, Char in pairs(self.RealAvatar.Chars or {}) do
    if Char.CharId == self.CharId then
      return Char
    end
  end
  return nil
end

function M:GetAvailablePlanCount()
  if self.TargetChar and type(self.TargetChar.AppearanceSuits) == "table" and #self.TargetChar.AppearanceSuits > 0 then
    return #self.TargetChar.AppearanceSuits
  end
  return DefaultPlanCount
end

function M:ClampSelectedPlanIndex()
  local PlanCount = self:GetAvailablePlanCount()
  if self.SelectedTargetPlanIndex == nil or self.SelectedTargetPlanIndex == "" then
    return
  end
  self.SelectedTargetPlanIndex = SafeNumber(self.SelectedTargetPlanIndex, 0)
  if self.SelectedTargetPlanIndex <= 0 then
    self.SelectedTargetPlanIndex = nil
    return
  end
  if PlanCount < self.SelectedTargetPlanIndex then
    self.SelectedTargetPlanIndex = PlanCount
  end
end

function M:BuildPreviewAvatar()
  if not self.PreviewAppearanceInfo or not self.CharId then
    ImportModelScreenPrint("build preview avatar skipped: missing preview appearance or CharId")
    return
  end
  NormalizeAccessoryFields(self.PreviewAppearanceInfo)
  self.DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Custom, {
    CharInfos = {
      {
        RoleId = self.CharId,
        Level = 1,
        Exp = 0,
        GradeLevel = 1,
        EnhanceLevel = 0,
        AppearanceSuit = self.PreviewAppearanceInfo
      }
    }
  })
  if not self.DummyAvatar then
    ImportModelScreenPrint("build preview avatar failed: dummy avatar is nil, CharId=" .. tostring(self.CharId))
    return
  end
  local _, PreviewChar = next(self.DummyAvatar.Chars)
  self.DummyChar = PreviewChar
  if not PreviewChar then
    ImportModelScreenPrint("build preview avatar failed: preview char is nil")
    return
  end
  self.DummyAvatar.CurrentChar = PreviewChar.Uuid
  PreviewChar.AppearanceSuits = PreviewChar.AppearanceSuits or {}
  PreviewChar.AppearanceSuits[1] = CloneTable(self.PreviewAppearanceInfo)
  NormalizeAccessoryFields(PreviewChar.AppearanceSuits[1])
  PreviewChar.CurrentAppearanceIndex = 1
  self.PreviewMainModel = BuildPreviewAppearanceMainModel(self)
end

function M:GetTargetPlanDisplayName(PlanIndex)
  local AppearanceSuit = self.TargetChar and self.TargetChar.AppearanceSuits and self.TargetChar.AppearanceSuits[PlanIndex] or nil
  local AppearanceName = AppearanceSuit and AppearanceSuit.AppearanceName or ""
  if "" == AppearanceName then
    AppearanceName = DefaultPlanNamePrefix .. tostring(PlanIndex)
  end
  return SafeGText(AppearanceName)
end

function M:BuildPlanSelectionState()
  self.TargetPlanItems = {}
  local PlanCount = self:GetAvailablePlanCount()
  for PlanIndex = 1, PlanCount do
    table.insert(self.TargetPlanItems, {
      Key = "Plan_" .. tostring(PlanIndex),
      PlanIndex = PlanIndex,
      Text = self:GetTargetPlanDisplayName(PlanIndex),
      UsageIndex = 0,
      UsageText = "",
      Checked = PlanIndex == self.SelectedTargetPlanIndex,
      AllowUnchecked = false
    })
  end
end

function M:BuildCurrentTargetAppearanceInfo()
  if not (self.TargetChar and self.SelectedTargetPlanIndex) or self.SelectedTargetPlanIndex <= 0 then
    return nil
  end
  local CurrentSuit = self.TargetChar.GetAppearance and self.TargetChar:GetAppearance(self.SelectedTargetPlanIndex) or nil
  if not CurrentSuit then
    return nil
  end
  local SkinId = SafeNumber(CurrentSuit.SkinId, 0)
  local HairId = SafeNumber(CurrentSuit.HairId, 0)
  return {
    CharId = self.CharId,
    SkinId = SkinId,
    HairId = HairId,
    AccessorySuit = CloneTable(CurrentSuit.Accessory or CurrentSuit.AccessorySuit or {}),
    Colors = {},
    HairColors = {}
  }
end

function M:BuildOwnershipState()
  self.SourceOwnershipItems = {
    ImportableItems = {},
    UnableItems = {}
  }
  self.OwnedSkinMap = {}
  self.OwnedHairMap = {}
  self.OwnedAccessoryMap = {}
  self.DefaultOwnedAccessoryMap = self.DefaultOwnedAccessoryMap or BuildDefaultAccessoryOwnedMap(self.CharData)
  local Avatar = self.RealAvatar
  if not (Avatar and self.TargetChar) or not self.PreviewAppearanceInfo then
    self.HasSkin = false
    self.HasHair = false
    self.HasAccessory = false
    self.CanImportPlan = false
    return
  end
  local SkinId = SafeNumber(self.PreviewAppearanceInfo.SkinId, 0)
  local HairId = SafeNumber(self.PreviewAppearanceInfo.HairId, 0)
  local AccessorySuit = NormalizeAccessoryFields(self.PreviewAppearanceInfo)
  local SkinEnough = SkinId <= 0 or Avatar:CheckSkinEnough({
    [SkinId] = 1
  })
  local HairEnough = HairId <= 0 or Avatar:CheckHairEnough({
    [HairId] = 1
  })
  local AccessoryEnough = true
  local AccessoryEnoughMap = {}
  local AccessoryTypeMap = {}
  for _, AccessoryId in pairs(AccessorySuit) do
    AccessoryId = SafeNumber(AccessoryId, 0)
    if AccessoryId > 0 and AccessoryId ~= EmptyAccessoryId then
      local IsPartMeshAccessory = IsPartMeshAccessoryId(AccessoryId)
      local IsEnough = false
      if IsPartMeshAccessory then
        IsEnough = SkinEnough
      else
        IsEnough = self.DefaultOwnedAccessoryMap[AccessoryId] == true or Avatar:CheckCharAccessoryEnough({
          [AccessoryId] = 1
        })
      end
      AccessoryEnoughMap[AccessoryId] = IsEnough
      AccessoryTypeMap[AccessoryId] = IsPartMeshAccessory and "CharPartMesh" or "CharAccessory"
      if not IsEnough then
        AccessoryEnough = false
      end
    end
  end
  local PartMeshAccessoryId = GetPartMeshAccessoryInfoBySkinId(SkinId)
  if PartMeshAccessoryId and PartMeshAccessoryId > 0 and not HasExplicitEmptyPartMeshSlot(self.PreviewAppearanceInfo, SkinId) and nil == AccessoryEnoughMap[PartMeshAccessoryId] then
    local IsEnough = SkinEnough
    AccessoryEnoughMap[PartMeshAccessoryId] = IsEnough
    AccessoryTypeMap[PartMeshAccessoryId] = "CharPartMesh"
    if not IsEnough then
      AccessoryEnough = false
    end
  end
  self.HasSkin = SkinEnough
  self.HasHair = HairEnough
  self.HasAccessory = AccessoryEnough
  self.CanImportPlan = SkinEnough and HairEnough and AccessoryEnough
  if SkinId > 0 then
    self.OwnedSkinMap[SkinId] = SkinEnough
  end
  if HairId > 0 then
    self.OwnedHairMap[HairId] = HairEnough
  end
  if SkinId > 0 then
    local Content = BuildAppearanceItemContent("Skin", SkinId, self.Owner)
    if Content then
      table.insert(SkinEnough and self.SourceOwnershipItems.ImportableItems or self.SourceOwnershipItems.UnableItems, Content)
    end
  end
  if HairId > 0 then
    local Content = BuildAppearanceItemContent("Hair", HairId, self.Owner)
    if Content then
      table.insert(HairEnough and self.SourceOwnershipItems.ImportableItems or self.SourceOwnershipItems.UnableItems, Content)
    end
  end
  for AccessoryId, IsEnough in pairs(AccessoryEnoughMap) do
    AccessoryId = SafeNumber(AccessoryId, 0)
    if AccessoryId > 0 and AccessoryId ~= EmptyAccessoryId then
      self.OwnedAccessoryMap[AccessoryId] = true == IsEnough
      local ItemType = AccessoryTypeMap[AccessoryId] or "CharAccessory"
      local Content = BuildAppearanceItemContent(ItemType, AccessoryId, self.Owner)
      if Content then
        table.insert(true == IsEnough and self.SourceOwnershipItems.ImportableItems or self.SourceOwnershipItems.UnableItems, Content)
      end
    end
  end
end

function M:BuildImportConfirmState()
  local DialogData = {
    ImportableItems = {},
    UnableItems = {}
  }
  if not self.CanImportPlan then
    for _, Content in ipairs(self.SourceOwnershipItems and self.SourceOwnershipItems.UnableItems or {}) do
      if Content then
        table.insert(DialogData.UnableItems, Content)
      end
    end
  end
  self.ImportConfirmDialogData = DialogData
  self.HasImportConfirmImportableItems = HasAnyContent(DialogData.ImportableItems)
  self.HasImportConfirmUnableItems = HasAnyContent(DialogData.UnableItems)
  self.ImportConfirmText = ""
end

function M:BuildWarnings()
  local WarningTexts = {}
  local Mark = {}
  if self.TargetChar == nil then
    AddUniqueText(WarningTexts, SafeGText("UI_AppearanceScore_NotHoldChar"), Mark)
  end
  if not self.CanImportPlan then
    AddUniqueText(WarningTexts, SafeGText("UI_AppearanceScore_ImportLack"), Mark)
  end
  if nil == self.SelectedTargetPlanIndex or self.SelectedTargetPlanIndex <= 0 then
    AddUniqueText(WarningTexts, MsgSelectPlanFirst, Mark)
  end
  self.WarningText = table.concat(WarningTexts, "\n")
end

function M:BuildScoreState()
  local TargetAppearanceInfo = self:BuildCurrentTargetAppearanceInfo()
  self.CurrentAppearanceInfo = TargetAppearanceInfo
  self.CurrentAppearanceBaseScore = CalcAppearanceBaseScore(TargetAppearanceInfo)
  self.CurrentAppearanceTotalScore = self.CurrentAppearanceBaseScore
  self.PreviewAppearanceBaseScore = CalcAppearanceBaseScore(self.PreviewAppearanceInfo)
  self.PreviewAppearanceTotalScore = self.PreviewAppearanceBaseScore
  self.FinalImportAppearanceInfo = CloneTable(self.PreviewAppearanceInfo or {})
  self.FinalImportBaseScore = CalcAppearanceBaseScore(self.FinalImportAppearanceInfo)
  self.FinalImportTotalScore = self.FinalImportBaseScore
  self.AppearanceScoreChangeText = FormatAppearanceScoreChange("UI_AppearanceScore_DyeChange2", self.CurrentAppearanceTotalScore, self.FinalImportTotalScore)
end

function M:IsValid()
  return self.PlanInfo ~= nil and nil ~= self.PreviewAppearanceInfo
end

function M:GetErrorText()
  return self.ErrorText
end

function M:HasTargetChar()
  return self.TargetChar ~= nil
end

function M:CanOpenImportWindow()
  return self:HasTargetChar()
end

function M:GetAvatarDisplayName()
  return self.AvatarName or ""
end

function M:GetAvatarDisplayLevel()
  return self.LevelText or ""
end

function M:GetSharerInfo()
  return self.SharerInfo or {}
end

function M:GetSharerDisplayName()
  return self.SharerName or ""
end

function M:GetSharerDisplayLevel()
  return self.SharerLevelText or ""
end

function M:GetPreviewCharDisplayName()
  return self.AvatarName or ""
end

function M:GetPlanDisplayName()
  return self.PlanInfo and (self.PlanInfo.PlanName or "") or ""
end

function M:GetPreviewAppearanceInfo()
  return self.PreviewAppearanceInfo
end

function M:GetPreviewCharId()
  return self.CharId
end

function M:GetPreviewDummyAvatar()
  return self.DummyAvatar
end

function M:GetPreviewDummyChar()
  return self.DummyChar
end

function M:GetPreviewMainModel()
  return self.PreviewMainModel
end

function M:GetSelectedTargetChar()
  return self.TargetChar
end

function M:GetSelectedTargetPlanIndex()
  return self.SelectedTargetPlanIndex
end

function M:GetSelectedTargetPlanName()
  if not self.SelectedTargetPlanIndex or self.SelectedTargetPlanIndex <= 0 then
    return ""
  end
  return self:GetTargetPlanDisplayName(self:GetSelectedTargetPlanIndex())
end

function M:GetTargetPlanItems()
  return self.TargetPlanItems or {}
end

function M:GetDyeDialogData()
  return self.ImportConfirmDialogData or {
    ImportableItems = {},
    UnableItems = {}
  }
end

function M:GetDyeImportConfirmText()
  return self.ImportConfirmText or ""
end

function M:NeedShowDyeImportConfirm()
  return not self:CanStartImport() or self.HasImportConfirmUnableItems or self.HasImportConfirmImportableItems
end

function M:GetImportLackText()
  return SafeGText("UI_AppearanceScore_ImportLack")
end

function M:GetAppearanceScoreChangeText()
  return self.AppearanceScoreChangeText or ""
end

function M:GetCurrentAppearanceTotalScore()
  return self.CurrentAppearanceTotalScore or 0
end

function M:GetFinalImportAppearanceTotalScore()
  return self.FinalImportTotalScore or 0
end

function M:GetWarningText()
  return self.WarningText or ""
end

function M:ShouldShowWarning()
  return self.WarningText ~= nil and self.WarningText ~= ""
end

function M:GetAvatarSilhouettePath()
  return self.CharData and self.CharData.EscMenuBg or nil
end

function M:IsAppearancePartOwned(TipType, ItemId)
  ItemId = SafeNumber(ItemId, 0)
  if ItemId <= 0 then
    return true
  end
  if "Skin" == TipType then
    if self.OwnedSkinMap[ItemId] ~= nil then
      return self.OwnedSkinMap[ItemId]
    end
    return true
  end
  if "Hair" == TipType then
    if nil ~= self.OwnedHairMap[ItemId] then
      return self.OwnedHairMap[ItemId]
    end
    return true
  end
  if "CharAccessory" == TipType or "CharPartMesh" == TipType then
    if nil ~= self.OwnedAccessoryMap[ItemId] then
      return self.OwnedAccessoryMap[ItemId]
    end
    return true
  end
  return true
end

function M:GetSourceOwnershipItems()
  return self.SourceOwnershipItems or {
    ImportableItems = {},
    UnableItems = {}
  }
end

function M:SetSelectedTarget(CharUuid, AppearanceIndex)
  self.SelectedTargetCharUuid = CharUuid
  self.SelectedTargetPlanIndex = AppearanceIndex
  self.TargetChar = self:ResolveTargetChar()
  self:ClampSelectedPlanIndex()
  self:BuildPlanSelectionState()
  self:BuildOwnershipState()
  self:BuildImportConfirmState()
  self:BuildScoreState()
  self:BuildWarnings()
end

function M:SetSelectedTargetPlanIndex(PlanIndex)
  self.SelectedTargetPlanIndex = PlanIndex
  self:ClampSelectedPlanIndex()
  self:BuildPlanSelectionState()
  self:BuildOwnershipState()
  self:BuildImportConfirmState()
  self:BuildScoreState()
  self:BuildWarnings()
end

function M:CanStartImport()
  return self.TargetChar ~= nil and nil ~= self.SelectedTargetPlanIndex and self.SelectedTargetPlanIndex > 0
end

local function ResolveAccessoryCustomParamsForCompare(AccessoryCustomParams, AccessoryId)
  local Params = AccessoryCustomParams and (AccessoryCustomParams[AccessoryId] or AccessoryCustomParams[tostring(AccessoryId)]) or nil
  if nil == Params or "" == Params then
    return {}
  end
  if type(Params) == "string" then
    local Ok, Parsed = pcall(SerializeUtils.UnSerialize, SerializeUtils, Params)
    Params = Ok and Parsed or {}
  end
  if type(Params) ~= "table" then
    return {}
  end
  return CloneTable(Params)
end

local function SerializeAccessoryCustomParams(AccessoryCustomParams, AccessoryId)
  local Params = ResolveAccessoryCustomParamsForCompare(AccessoryCustomParams, AccessoryId)
  local Ok, Serialized = pcall(SerializeUtils.Serialize, SerializeUtils, Params)
  if not Ok or not Serialized then
    return ""
  end
  return Serialized
end

function M:ClearImportSequenceState()
  if self.bImportSequenceListening then
    EventManager:RemoveEvent(EventID.OnCharAccessorySetted, self)
    EventManager:RemoveEvent(EventID.OnCharAccessoryRemoved, self)
    EventManager:RemoveEvent(EventID.OnCharSkinChanged, self)
    EventManager:RemoveEvent(EventID.OnCharHairChanged, self)
  end
  self.bImportSequenceListening = false
  self.ImportSequenceState = nil
end

function M:BeginImportSequence(CharUuid, AppearanceIndex, Operations, OnFinished)
  self:ClearImportSequenceState()
  self.ImportSequenceState = {
    CharUuid = CharUuid,
    AppearanceIndex = SafeNumber(AppearanceIndex, 0),
    Operations = Operations or {},
    CurrentIndex = 0,
    CurrentOperation = nil,
    OnFinished = OnFinished
  }
  EventManager:AddEvent(EventID.OnCharAccessorySetted, self, self.OnImportAccessorySetFinished)
  EventManager:AddEvent(EventID.OnCharAccessoryRemoved, self, self.OnImportAccessoryRemovedFinished)
  EventManager:AddEvent(EventID.OnCharSkinChanged, self, self.OnImportSkinChangedFinished)
  EventManager:AddEvent(EventID.OnCharHairChanged, self, self.OnImportHairChangedFinished)
  self.bImportSequenceListening = true
end

function M:FinishImportSequence(bSuccess)
  local State = self.ImportSequenceState
  local OnFinished = State and State.OnFinished or nil
  self:ClearImportSequenceState()
  if true == bSuccess then
    self:TryRefreshCurrentBattlePlayer()
  end
  if OnFinished then
    OnFinished(true == bSuccess)
  end
end

function M:RunNextImportOperation()
  local State = self.ImportSequenceState
  if not State then
    return
  end
  State.CurrentIndex = State.CurrentIndex + 1
  local Operation = State.Operations[State.CurrentIndex]
  State.CurrentOperation = Operation
  if not Operation then
    self:FinishImportSequence(true)
    return
  end
  Operation.Invoke()
end

function M:HandleImportOperationFinished(ExpectedKind, Ret, CharUuid, AppearanceIndex)
  local State = self.ImportSequenceState
  if not State then
    return
  end
  if CharUuid ~= State.CharUuid or SafeNumber(AppearanceIndex, 0) ~= State.AppearanceIndex then
    return
  end
  local Operation = State.CurrentOperation
  if not Operation or Operation.Kind ~= ExpectedKind then
    return
  end
  if not ErrorCode:Check(Ret) then
    self:FinishImportSequence(false)
    return
  end
  State.CurrentOperation = nil
  self:RunNextImportOperation()
end

function M:TryRefreshCurrentBattlePlayer()
  local Avatar = self.RealAvatar or GWorld:GetAvatar()
  if not (Avatar and Avatar.GetNeedRefreshPlayer) or not Avatar:GetNeedRefreshPlayer() then
    return
  end
  local TargetChar = self.TargetChar
  local TargetPlanIndex = SafeNumber(self.SelectedTargetPlanIndex, 0)
  if not TargetChar or TargetChar.Uuid ~= Avatar.CurrentChar then
    return
  end
  if SafeNumber(TargetChar.CurrentAppearanceIndex, 0) ~= TargetPlanIndex then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.Owner, 0)
  if not IsValid(Player) then
    ImportModelScreenPrint("刷新大世界角色失败：Player 无效")
    return
  end
  local PlayerController = Player:GetController()
  if not IsValid(PlayerController) then
    ImportModelScreenPrint("刷新大世界角色失败：PlayerController 无效")
    return
  end
  local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
  if not AvatarInfo then
    ImportModelScreenPrint("刷新大世界角色失败：AvatarInfo 为空")
    return
  end
  PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
  Player:ChangeRole(nil, AvatarInfo)
  Player:RecoverBanSkills()
  UE4.UPhantomFunctionLibrary.CancelAllPhantom(Player, EDestroyReason.PhantomChangeRole)
  EventManager:FireEvent(EventID.OnSwitchRole, Avatar.CurrentChar)
end

function M:OnImportAccessorySetFinished(Ret, CharUuid, AppearanceIndex)
  self:HandleImportOperationFinished("AccessorySet", Ret, CharUuid, AppearanceIndex)
end

function M:OnImportAccessoryRemovedFinished(Ret, CharUuid, AppearanceIndex)
  self:HandleImportOperationFinished("AccessoryRemove", Ret, CharUuid, AppearanceIndex)
end

function M:OnImportSkinChangedFinished(Ret, CharUuid, AppearanceIndex)
  self:HandleImportOperationFinished("Skin", Ret, CharUuid, AppearanceIndex)
end

function M:OnImportHairChangedFinished(Ret, CharUuid, AppearanceIndex)
  self:HandleImportOperationFinished("Hair", Ret, CharUuid, AppearanceIndex)
end

function M:CanApplyImport()
  return self:CanStartImport() and self.CanImportPlan == true
end

function M:ApplyImport(OnFinished)
  if not self:CanApplyImport() then
    ImportModelScreenPrint("apply import aborted: current state can not start import")
    if OnFinished then
      OnFinished(false)
    end
    return
  end
  local Avatar = self.RealAvatar
  local Char = self.TargetChar
  local AppearanceIndex = self:GetSelectedTargetPlanIndex()
  local AppearanceInfo = self.PreviewAppearanceInfo
  if not (Avatar and Char) or not AppearanceInfo then
    ImportModelScreenPrint("apply import aborted: missing Avatar, Char or AppearanceInfo")
    if OnFinished then
      OnFinished(false)
    end
    return
  end
  local CharUuid = Char.Uuid
  local SkinId = SafeNumber(AppearanceInfo.SkinId, 0)
  local HairId = SafeNumber(AppearanceInfo.HairId, 0)
  local AccessorySuit = NormalizeAccessoryFields(AppearanceInfo)
  local CurrentSuit = Char.GetAppearance and Char:GetAppearance(AppearanceIndex) or nil
  local CurrentSkinId = SafeNumber(CurrentSuit and CurrentSuit.SkinId, 0)
  local CurrentHairId = SafeNumber(CurrentSuit and CurrentSuit.HairId, 0)
  local CurrentAccessory = CurrentSuit and CurrentSuit.Accessory or {}
  local CurrentAccessoryCustomParams = CurrentSuit and CurrentSuit.AccessoryCustomParams or {}
  local Operations = {}
  if SkinId > 0 and SkinId ~= CurrentSkinId then
    table.insert(Operations, {
      Kind = "Skin",
      Invoke = function()
        Avatar:ChangeCharAppearanceSkin(CharUuid, AppearanceIndex, SkinId)
      end
    })
  end
  if HairId > 0 and HairId ~= CurrentHairId then
    table.insert(Operations, {
      Kind = "Hair",
      Invoke = function()
        Avatar:ChangeCharAppearanceHair(CharUuid, AppearanceIndex, HairId)
      end
    })
  end
  for AccessoryTypeIdx, AccessoryId in pairs(CurrentAccessory or {}) do
    local TargetAccessoryId = SafeNumber(AccessorySuit[AccessoryTypeIdx], 0)
    AccessoryId = SafeNumber(AccessoryId, 0)
    if AccessoryId > 0 and AccessoryId ~= EmptyAccessoryId and (TargetAccessoryId <= 0 or TargetAccessoryId == EmptyAccessoryId) then
      table.insert(Operations, {
        Kind = "AccessoryRemove",
        Invoke = function()
          Avatar:RemoveCharAppearanceAccessory(CharUuid, AppearanceIndex, AccessoryId)
        end
      })
    end
  end
  for AccessoryTypeIdx, AccessoryId in pairs(AccessorySuit) do
    AccessoryId = SafeNumber(AccessoryId, 0)
    if AccessoryId > 0 and AccessoryId ~= EmptyAccessoryId then
      local CurrentAccessoryId = SafeNumber(CurrentAccessory[AccessoryTypeIdx], 0)
      local NeedSetAccessory = CurrentAccessoryId ~= AccessoryId
      if not NeedSetAccessory then
        local CurrentSerializedParams = SerializeAccessoryCustomParams(CurrentAccessoryCustomParams, AccessoryId)
        local TargetSerializedParams = SerializeAccessoryCustomParams(AppearanceInfo.AccessoryCustomParams, AccessoryId)
        NeedSetAccessory = CurrentSerializedParams ~= TargetSerializedParams
      end
      if NeedSetAccessory then
        local CustomParams = ResolveAccessoryCustomParamsForCompare(AppearanceInfo.AccessoryCustomParams, AccessoryId)
        table.insert(Operations, {
          Kind = "AccessorySet",
          Invoke = function()
            Avatar:SetCharAppearanceAccessory(CharUuid, AppearanceIndex, AccessoryId, CustomParams)
          end
        })
      end
    end
  end
  if #Operations <= 0 then
    if OnFinished then
      OnFinished(true)
    end
    return
  end
  self:BeginImportSequence(CharUuid, AppearanceIndex, Operations, OnFinished)
  self:RunNextImportOperation()
end

return M
