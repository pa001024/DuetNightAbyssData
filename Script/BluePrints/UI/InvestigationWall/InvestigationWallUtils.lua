local M = {}
local CommonUtils = require("Utils.CommonUtils")
local CommonConst = require("CommonConst")
local ConditionUtils = require("BluePrints.Common.ConditionUtils")
local RewardUtils = require("Utils.RewardUtils")
local ItemUtils = require("Utils.ItemUtils")
local StringBoardConfig = require("BluePrints.UI.InvestigationWall.StringBoardConfig")

function M.GetAvatarSafe()
  return GWorld and GWorld:GetAvatar() or nil
end

M.ProgressRewardState = {
  NotReach = 1,
  CanGet = 2,
  Got = 3
}
local ProgressRewardDataMgrTableName = "ClueReward"

function M.ResolveTileOffsetFromContent(DataContent, TileContentSize, DataOffset)
  local OffsetX = 0
  local OffsetY = 0
  if DataOffset then
    OffsetX = DataOffset.X or 0
    OffsetY = DataOffset.Y or 0
  end
  if not DataContent or not TileContentSize then
    return OffsetX, OffsetY
  end
  local ContentSizeX = TileContentSize.X or 0
  local ContentSizeY = TileContentSize.Y or 0
  if DataContent.OffsetXInTileSteps then
    OffsetX = OffsetX + DataContent.OffsetXInTileSteps * ContentSizeX
  end
  if DataContent.OffsetYInTileSteps then
    OffsetY = OffsetY + DataContent.OffsetYInTileSteps * ContentSizeY
  end
  return OffsetX, OffsetY
end

local _CollectVisibleReviewChainSequences, _BuildTileDataList

function M.ResolveReviewPageId(ReviewPageId)
  if ReviewPageId and DataMgr.ReviewPage and DataMgr.ReviewPage[ReviewPageId] then
    return ReviewPageId
  end
  local DefaultReviewPageId = StringBoardConfig.DefaultReviewPageId
  if DefaultReviewPageId and DataMgr.ReviewPage and DataMgr.ReviewPage[DefaultReviewPageId] then
    return DefaultReviewPageId
  end
  return nil
end

function M.BuildTilePositionDataFromReviewChain(ReviewPageId, Avatar)
  ReviewPageId = M.ResolveReviewPageId(ReviewPageId)
  local SequenceList = _CollectVisibleReviewChainSequences(ReviewPageId, Avatar)
  return _BuildTileDataList(SequenceList)
end

function M.ResolveClueItemWidgetClassPath(ClueType)
  local ClueItemWidgetClassPath = StringBoardConfig.ClueItemWidgetClassPath
  return ClueItemWidgetClassPath and ClueItemWidgetClassPath[ClueType] or ClueItemWidgetClassPath and ClueItemWidgetClassPath[1]
end

function M.BuildClueStructureTable()
  local table_insert = table.insert
  local table_sort = table.sort
  local PageTypeMap = {}
  for CluePageId, CluePageData in pairs(DataMgr.CluePage or {}) do
    local PageType = CluePageData.ClueTabType
    if PageType then
      if not PageTypeMap[PageType] then
        PageTypeMap[PageType] = {}
      end
      table_insert(PageTypeMap[PageType], {CluePageId = CluePageId, CluePageData = CluePageData})
    end
  end
  local SortedPageTypeList = {}
  for PageType, CluePageEntryList in pairs(PageTypeMap) do
    local TypeData = DataMgr.CluePageType and DataMgr.CluePageType[PageType]
    if TypeData then
      table_insert(SortedPageTypeList, {
        PageType = PageType,
        TypeData = TypeData,
        CluePageEntryList = CluePageEntryList
      })
    end
  end
  table_sort(SortedPageTypeList, function(PageTypeEntryA, PageTypeEntryB)
    return (PageTypeEntryA.TypeData.Priority or 0) > (PageTypeEntryB.TypeData.Priority or 0)
  end)
  local ClueStructureTable = {}
  for PageTypeIndex, PageTypeEntry in ipairs(SortedPageTypeList) do
    local CluePageEntryList = PageTypeEntry.CluePageEntryList
    table_sort(CluePageEntryList, function(CluePageEntryA, CluePageEntryB)
      local ClueTabNumA = CluePageEntryA.CluePageData.ClueTabNum or 0
      local ClueTabNumB = CluePageEntryB.CluePageData.ClueTabNum or 0
      if ClueTabNumA ~= ClueTabNumB then
        return ClueTabNumA < ClueTabNumB
      end
      return tostring(CluePageEntryA.CluePageId) < tostring(CluePageEntryB.CluePageId)
    end)
    local CluePageList = {}
    for CluePageIndex, CluePageEntry in ipairs(CluePageEntryList) do
      local CluePageData = CluePageEntry.CluePageData
      local SortedClueIdList = {}
      local ClueIdList = CluePageData.ClueList or {}
      for _, ClueId in ipairs(ClueIdList) do
        if ClueId and DataMgr.Clue and DataMgr.Clue[ClueId] then
          table_insert(SortedClueIdList, ClueId)
        end
      end
      table_sort(SortedClueIdList, function(ClueIdA, ClueIdB)
        return (ClueIdA or 0) < (ClueIdB or 0)
      end)
      local ClueList = {}
      for ClueIndex, ClueId in ipairs(SortedClueIdList) do
        ClueList[ClueIndex] = ClueId
      end
      CluePageList[CluePageIndex] = {
        CluePageId = CluePageEntry.CluePageId,
        ClueList = ClueList
      }
    end
    ClueStructureTable[PageTypeIndex] = {
      PageType = PageTypeEntry.PageType,
      CluePageList = CluePageList
    }
  end
  return ClueStructureTable
end

function M.CheckCluePageUnlockCondition(CluePageId, Avatar)
  if not CluePageId then
    return false
  end
  local CluePageData = DataMgr.CluePage and DataMgr.CluePage[CluePageId]
  if not CluePageData then
    return false
  end
  local UnlockConditionId = CluePageData.UnlockConditionID
  if not UnlockConditionId then
    return true
  end
  Avatar = Avatar or M.GetAvatarSafe()
  if not Avatar then
    return false
  end
  return ConditionUtils.CheckCondition(Avatar, UnlockConditionId)
end

function M.GetClueBoardPositionConfig(ItemCount, MaxItemCount)
  MaxItemCount = MaxItemCount or 0
  if MaxItemCount < 1 then
    return {}
  end
  local ClampedItemCount = math.max(1, math.min(ItemCount or 1, MaxItemCount))
  local PositionConfig = StringBoardConfig.ClueBoardPositionConfig
  return PositionConfig and PositionConfig[ClampedItemCount] or {}
end

function M.BuildTilePositionDataFromClueList(ClueList, MaxItemCount)
  MaxItemCount = MaxItemCount or 0
  if MaxItemCount < 1 then
    return {}
  end
  local ValidClueList = {}
  for _, ClueId in ipairs(ClueList or {}) do
    local ClueConfig = ClueId and DataMgr.Clue and DataMgr.Clue[ClueId]
    if ClueConfig then
      table.insert(ValidClueList, {ClueId = ClueId, ClueConfig = ClueConfig})
      if MaxItemCount <= #ValidClueList then
        break
      end
    end
  end
  local ItemCount = #ValidClueList
  if ItemCount <= 0 then
    return {}
  end
  local PositionConfigList = M.GetClueBoardPositionConfig(ItemCount, MaxItemCount)
  local TileDataList = {}
  for Index, ClueData in ipairs(ValidClueList) do
    local PositionEntry = PositionConfigList[Index]
    if PositionEntry then
      ClueData.ClueIndex = Index
      table.insert(TileDataList, {
        Position = PositionEntry.Position or {X = 0, Y = 0},
        Offset = PositionEntry.Offset or {X = 0, Y = 0},
        Angle = PositionEntry.Angle or 0,
        Content = ClueData,
        WidgetClass = M.ResolveClueItemWidgetClassPath(ClueData.ClueConfig.ClueType)
      })
    end
  end
  return TileDataList
end

local ClueContentTriggerType = {
  Dialogue = "Dialogue",
  MechState = "MechState",
  Resource = "Resource"
}
local _FindClueIdByClueContentId, _HasClueContentCrossOutCondition, _CollectClueContentTriggerList, _CheckClueContentDialogueTrigger, _CheckClueContentMechStateTrigger, _CheckClueContentResourceTrigger, _IsClueContentTriggerSatisfied, _CalculateClueContentState, _CalculateClueState

function _FindClueIdByClueContentId(ClueContentId)
  for ClueId, ClueConfig in pairs(DataMgr.Clue or {}) do
    for _, ContentId in ipairs(ClueConfig.ClueContent or {}) do
      if ContentId == ClueContentId then
        return ClueId
      end
    end
  end
  return nil
end

function _HasClueContentCrossOutCondition(ClueContentConfig)
  if not ClueContentConfig then
    return false
  end
  return ClueContentConfig.FinalState == CommonConst.ClueContentState.CrossedOut
end

function _CollectClueContentTriggerList(ClueContentId)
  local TriggerList = {}
  if not ClueContentId then
    return TriggerList
  end
  local TriggerData = DataMgr.ClueContentTrigger
  if not TriggerData then
    return TriggerList
  end
  for DialogueId, TriggerGroup in pairs(TriggerData.Dialogue or {}) do
    for _, TriggerEntry in pairs(TriggerGroup) do
      if TriggerEntry.ClueContentId == ClueContentId then
        table.insert(TriggerList, {
          TriggerType = ClueContentTriggerType.Dialogue,
          TargetState = TriggerEntry.State,
          DialogueId = DialogueId
        })
      end
    end
  end
  for MechPointId, MechStateGroup in pairs(TriggerData.MechState or {}) do
    for MechState, TriggerGroup in pairs(MechStateGroup) do
      for _, TriggerEntry in pairs(TriggerGroup) do
        if TriggerEntry.ClueContentId == ClueContentId then
          table.insert(TriggerList, {
            TriggerType = ClueContentTriggerType.MechState,
            TargetState = TriggerEntry.State,
            MechPointId = MechPointId,
            MechState = MechState
          })
        end
      end
    end
  end
  for ResourceId, TriggerGroup in pairs(TriggerData.Resource or {}) do
    for _, TriggerEntry in pairs(TriggerGroup) do
      if TriggerEntry.ClueContentId == ClueContentId then
        table.insert(TriggerList, {
          TriggerType = ClueContentTriggerType.Resource,
          TargetState = TriggerEntry.State,
          ResourceId = ResourceId
        })
      end
    end
  end
  return TriggerList
end

function _CheckClueContentDialogueTrigger(DialogueId, Avatar)
  if not DialogueId or not Avatar then
    return false
  end
  return ConditionUtils:JudgeDialogueHasRead(Avatar, DialogueId)
end

function _CheckClueContentMechStateTrigger(MechPointId, MechState, Avatar)
  if not (MechPointId and MechState) or not Avatar then
    return false
  end
  return ConditionUtils:JudgeMechanismState(Avatar, {
    MechPointId,
    0,
    MechState
  })
end

function _CheckClueContentResourceTrigger(ResourceId, Avatar)
  if not ResourceId or not Avatar then
    return false
  end
  return ConditionUtils:JudgeHaveResource(Avatar, {ResourceId, 1})
end

function _IsClueContentTriggerSatisfied(TriggerEntry, Avatar)
  if not TriggerEntry then
    return false
  end
  if TriggerEntry.TriggerType == ClueContentTriggerType.Dialogue then
    return _CheckClueContentDialogueTrigger(TriggerEntry.DialogueId, Avatar)
  end
  if TriggerEntry.TriggerType == ClueContentTriggerType.MechState then
    return _CheckClueContentMechStateTrigger(TriggerEntry.MechPointId, TriggerEntry.MechState, Avatar)
  end
  if TriggerEntry.TriggerType == ClueContentTriggerType.Resource then
    return _CheckClueContentResourceTrigger(TriggerEntry.ResourceId, Avatar)
  end
  return false
end

function M.IsClueContentVisibleInDetail(ClueContentState)
  return ClueContentState ~= CommonConst.ClueContentState.Locked
end

M.DetailDescItemVisualState = {
  IdleNormal = 1,
  IdleFinish = 2,
  PlayingNormal = 3,
  PlayingIn = 4,
  PlayingFinishIn = 5,
  PlayingFinish = 6
}
M.DetailDescItemPhase1 = {
  None = 0,
  PlayNormal = 1,
  PlayFinishIn = 2,
  PlayFinish = 3
}
M.DetailDescItemPhase2 = {None = 0, PlayUnlockIn = 1}
M.DetailDescItemRestState = {Normal = 1, Finish = 2}

function M.CheckClueContentHasSeenFinishEntranceInDetail(ClueId, ClueContentId)
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  return StringBoardReddotHelper.HasSeenFinishEntrance(ClueContentId)
end

function M.MarkClueContentFinishEntranceSeenInDetail(ClueId, ClueContentId)
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  StringBoardReddotHelper.MarkFinishEntranceSeen(ClueContentId)
end

function M.CheckClueContentIsFirstTimeUnlockedInDetail(ClueId, ClueContentId)
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  return StringBoardReddotHelper.IsClueContentNew(ClueContentId)
end

function M.ResolveDetailDescItemPlayPlan(ClueContentState, ClueId, ClueContentId)
  local Phase1 = M.DetailDescItemPhase1
  local Phase2 = M.DetailDescItemPhase2
  local RestState = M.DetailDescItemRestState
  local Plan = {
    Phase1 = Phase1.None,
    Phase2 = Phase2.None,
    RestState = RestState.Normal,
    bPhase1Done = false,
    bPhase2Done = false
  }
  if ClueContentState == CommonConst.ClueContentState.CrossedOut then
    Plan.RestState = RestState.Finish
    if M.CheckClueContentHasSeenFinishEntranceInDetail(ClueId, ClueContentId) then
      Plan.Phase1 = Phase1.PlayFinish
    else
      Plan.Phase1 = Phase1.PlayFinishIn
    end
    return Plan
  end
  if ClueContentState == CommonConst.ClueContentState.Unlocked then
    if M.CheckClueContentIsFirstTimeUnlockedInDetail(ClueId, ClueContentId) then
      Plan.Phase2 = Phase2.PlayUnlockIn
    else
      Plan.Phase1 = Phase1.PlayNormal
    end
    return Plan
  end
  return Plan
end

function M.CheckClueContentState(ClueContentId, Avatar, ClueId)
  if not ClueContentId then
    return CommonConst.ClueContentState.Locked
  end
  Avatar = Avatar or M.GetAvatarSafe()
  if Avatar and Avatar.Clues then
    if nil == ClueId then
      ClueId = _FindClueIdByClueContentId(ClueContentId)
    end
    if ClueId then
      local ClueContent = Avatar.Clues:GetClueContent(ClueId, ClueContentId)
      if ClueContent then
        return ClueContent:GetState()
      end
    end
  end
  return _CalculateClueContentState(ClueContentId, Avatar)
end

function M.CheckClueState(ClueId, Avatar)
  if not ClueId then
    return CommonConst.ClueState.Locked
  end
  Avatar = Avatar or M.GetAvatarSafe()
  if Avatar and Avatar.Clues then
    local Clue = Avatar.Clues:GetClue(ClueId)
    if Clue then
      return Clue.State
    end
  end
  return _CalculateClueState(ClueId, Avatar)
end

function _CalculateClueContentState(ClueContentId, Avatar)
  local CurrentState = CommonConst.ClueContentState.Locked
  local TriggerList = _CollectClueContentTriggerList(ClueContentId)
  for _, TriggerEntry in ipairs(TriggerList) do
    if _IsClueContentTriggerSatisfied(TriggerEntry, Avatar) and TriggerEntry.TargetState == CommonConst.ClueContentState.Unlocked then
      CurrentState = CommonConst.ClueContentState.Unlocked
      break
    end
  end
  for _, TriggerEntry in ipairs(TriggerList) do
    if _IsClueContentTriggerSatisfied(TriggerEntry, Avatar) and TriggerEntry.TargetState == CommonConst.ClueContentState.CrossedOut then
      CurrentState = CommonConst.ClueContentState.CrossedOut
      break
    end
  end
  return CurrentState
end

function _CalculateClueState(ClueId, Avatar)
  local ClueConfig = ClueId and DataMgr.Clue and DataMgr.Clue[ClueId]
  if not ClueConfig or not ClueConfig.ClueContent then
    return CommonConst.ClueState.Locked
  end
  local ClueContentIds = ClueConfig.ClueContent
  if #ClueContentIds <= 0 then
    return CommonConst.ClueState.Locked
  end
  local HasVisibleContent = false
  local AllSatisfied = true
  for _, ClueContentId in ipairs(ClueContentIds) do
    local ClueContentState = _CalculateClueContentState(ClueContentId, Avatar)
    if ClueContentState ~= CommonConst.ClueContentState.Locked then
      HasVisibleContent = true
    end
    local ClueContentConfig = DataMgr.ClueContent and DataMgr.ClueContent[ClueContentId]
    if _HasClueContentCrossOutCondition(ClueContentConfig) then
      if ClueContentState ~= CommonConst.ClueContentState.CrossedOut then
        AllSatisfied = false
      end
    elseif ClueContentState ~= CommonConst.ClueContentState.Unlocked then
      AllSatisfied = false
    end
  end
  if not HasVisibleContent then
    return CommonConst.ClueState.Locked
  end
  if AllSatisfied then
    return CommonConst.ClueState.Finished
  end
  return CommonConst.ClueState.Exploring
end

local function _ParseReviewChainSide(ReviewChainSide)
  if type(ReviewChainSide) == "table" then
    return ReviewChainSide
  end
  if type(ReviewChainSide) == "number" then
    if 0 == ReviewChainSide then
      return {}
    end
    return {ReviewChainSide}
  end
  if type(ReviewChainSide) == "string" then
    if "" == ReviewChainSide or "0" == ReviewChainSide then
      return {}
    end
    local ReviewIds = {}
    for _, Part in ipairs(CommonUtils.Split(ReviewChainSide, ",")) do
      local ReviewId = tonumber(Part)
      if ReviewId and 0 ~= ReviewId then
        table.insert(ReviewIds, ReviewId)
      end
    end
    return ReviewIds
  end
  return {}
end

local function _SortReviewIds(ReviewIds)
  local SortedReviewIds = {}
  for _, ReviewId in ipairs(ReviewIds or {}) do
    table.insert(SortedReviewIds, ReviewId)
  end
  table.sort(SortedReviewIds)
  return SortedReviewIds
end

local function _IsOccupied(OccupiedMap, ColumnX, TileY)
  return nil ~= OccupiedMap[ColumnX] and true == OccupiedMap[ColumnX][TileY]
end

local function _MarkOccupied(OccupiedMap, ColumnX, TileY)
  if not OccupiedMap[ColumnX] then
    OccupiedMap[ColumnX] = {}
  end
  OccupiedMap[ColumnX][TileY] = true
end

local function _FindBelowY(OccupiedMap, ColumnX, StartY)
  local TileY = StartY
  while _IsOccupied(OccupiedMap, ColumnX, TileY) do
    TileY = TileY - 1
  end
  return TileY
end

local function _ResolveLineItemWidgetClassPath(ReviewId, bIsMainLine)
  local LineItemWidgetClassPath = StringBoardConfig.LineItemWidgetClassPath or {}
  local ReviewConfig = ReviewId and DataMgr.Review and DataMgr.Review[ReviewId]
  local ReviewType = ReviewConfig and ReviewConfig.ReviewType
  if 1 == ReviewType or nil == ReviewType and bIsMainLine then
    return LineItemWidgetClassPath[1]
  end
  if 3 == ReviewType then
    return LineItemWidgetClassPath[3]
  end
  return LineItemWidgetClassPath[2]
end

local function _AppendTile(TileDataList, ColumnX, TileY, ReviewId, SequenceId, SequenceData, bIsMainLine, OffsetYInTileSteps)
  local Content = {
    ReviewId = ReviewId,
    ReviewChainSequence = SequenceId,
    bIsMainLine = bIsMainLine
  }
  if OffsetYInTileSteps and 0 ~= OffsetYInTileSteps then
    Content.OffsetYInTileSteps = OffsetYInTileSteps
  end
  table.insert(TileDataList, {
    Position = {X = ColumnX, Y = TileY},
    Content = Content,
    WidgetClass = _ResolveLineItemWidgetClassPath(ReviewId, bIsMainLine)
  })
end

local function _BuildColumnTiles(TileDataList, OccupiedMap, ColumnX, SequenceId, SequenceData)
  local MainReviewIds = _SortReviewIds(SequenceData.ReviewChainMain)
  local MainLineCount = #MainReviewIds
  if MainLineCount <= 0 then
    return
  end
  local TopTileY = math.floor((MainLineCount - 1) * 0.5)
  local OffsetYInTileSteps = 0 == MainLineCount % 2 and 0.5 or nil
  for Index, ReviewId in ipairs(MainReviewIds) do
    local TileY = TopTileY - (Index - 1)
    _MarkOccupied(OccupiedMap, ColumnX, TileY)
    _AppendTile(TileDataList, ColumnX, TileY, ReviewId, SequenceId, SequenceData, true, OffsetYInTileSteps)
  end
  local SideReviewIds = _SortReviewIds(_ParseReviewChainSide(SequenceData.ReviewChainSide))
  for _, ReviewId in ipairs(SideReviewIds) do
    local TileY = _FindBelowY(OccupiedMap, ColumnX, -1)
    _MarkOccupied(OccupiedMap, ColumnX, TileY)
    _AppendTile(TileDataList, ColumnX, TileY, ReviewId, SequenceId, SequenceData, false, nil)
  end
end

local function _ApplyMainLineArrowVisibility(TileDataList)
  local ColumnMap = {}
  for _, Data in ipairs(TileDataList) do
    local ColumnX = Data.Position.X
    if not ColumnMap[ColumnX] then
      ColumnMap[ColumnX] = {MainLineCount = 0, TotalCount = 0}
    end
    local ColumnInfo = ColumnMap[ColumnX]
    ColumnInfo.TotalCount = ColumnInfo.TotalCount + 1
    if Data.Content and Data.Content.bIsMainLine then
      ColumnInfo.MainLineCount = ColumnInfo.MainLineCount + 1
    end
  end
  for _, Data in ipairs(TileDataList) do
    local Content = Data.Content
    if not Content then
      local Position = Data.Position
      DebugPrint("[StringBoard] _ApplyMainLineArrowVisibility: TileData missing Content, Position=", Position and Position.X, Position and Position.Y)
    elseif not Content.bIsMainLine then
      Content.bShowFrontArrow = false
      Content.bShowBackArrow = false
    else
      local ColumnX = Data.Position.X
      local ColumnInfo = ColumnMap[ColumnX]
      if ColumnInfo.MainLineCount > 1 then
        Content.bShowFrontArrow = false
        Content.bShowBackArrow = false
      else
        local LeftColumnCount = ColumnMap[ColumnX - 1] and ColumnMap[ColumnX - 1].TotalCount or 0
        Content.bShowFrontArrow = LeftColumnCount > 1
        Content.bShowBackArrow = nil ~= ColumnMap[ColumnX + 1]
      end
    end
  end
end

function _CollectVisibleReviewChainSequences(ReviewPageId, Avatar)
  local SequenceIds = {}
  local PageData = ReviewPageId and DataMgr.ReviewPage and DataMgr.ReviewPage[ReviewPageId]
  if PageData and PageData.ReviewChainSequence then
    for _, SequenceId in ipairs(PageData.ReviewChainSequence) do
      if SequenceId and DataMgr.ReviewChain and DataMgr.ReviewChain[SequenceId] then
        table.insert(SequenceIds, SequenceId)
      end
    end
  else
    for SequenceId, _ in pairs(DataMgr.ReviewChain or {}) do
      table.insert(SequenceIds, SequenceId)
    end
    table.sort(SequenceIds)
  end
  local SequenceList = {}
  for _, SequenceId in ipairs(SequenceIds) do
    local bIsVisible = not Avatar or not Avatar.IsReviewChainSequenceShow or Avatar:IsReviewChainSequenceShow(SequenceId)
    if bIsVisible then
      table.insert(SequenceList, {
        SequenceId = SequenceId,
        SequenceData = DataMgr.ReviewChain and DataMgr.ReviewChain[SequenceId]
      })
    end
  end
  return SequenceList
end

function _BuildTileDataList(SequenceList)
  local TileDataList = {}
  local OccupiedMap = {}
  for ColumnIndex, SequenceEntry in ipairs(SequenceList) do
    _BuildColumnTiles(TileDataList, OccupiedMap, ColumnIndex - 1, SequenceEntry.SequenceId, SequenceEntry.SequenceData)
  end
  _ApplyMainLineArrowVisibility(TileDataList)
  return TileDataList
end

M.ReviewItemState = {
  Pending = "Pending",
  Exploring = "Exploring",
  Explored = "Explored"
}

local function _CheckReviewUnlockCondition(ReviewId, Avatar)
  local ReviewConfig = ReviewId and DataMgr.Review and DataMgr.Review[ReviewId]
  if not ReviewConfig or not ReviewConfig.UnlockCondition then
    return false
  end
  Avatar = Avatar or M.GetAvatarSafe()
  return ConditionUtils.CheckCondition(Avatar, ReviewConfig.UnlockCondition)
end

local function _CheckReviewFinishCondition(ReviewId, Avatar)
  local ReviewConfig = ReviewId and DataMgr.Review and DataMgr.Review[ReviewId]
  if not ReviewConfig or not ReviewConfig.FinishCondition then
    return false
  end
  Avatar = Avatar or M.GetAvatarSafe()
  return ConditionUtils.CheckCondition(Avatar, ReviewConfig.FinishCondition)
end

function M.ResolveReviewItemState(ReviewId, Avatar)
  if not ReviewId then
    return M.ReviewItemState.Pending
  end
  Avatar = Avatar or M.GetAvatarSafe()
  if _CheckReviewFinishCondition(ReviewId, Avatar) then
    return M.ReviewItemState.Explored
  end
  if _CheckReviewUnlockCondition(ReviewId, Avatar) then
    return M.ReviewItemState.Exploring
  end
  return M.ReviewItemState.Pending
end

function M.CanAcceptReviewQuest(ReviewId, Avatar)
  if not ReviewId then
    return false
  end
  local ReviewConfig = DataMgr.Review and DataMgr.Review[ReviewId]
  local QuestChainId = ReviewConfig and ReviewConfig.QuestChainId
  if not QuestChainId or 0 == QuestChainId then
    return false
  end
  Avatar = Avatar or M.GetAvatarSafe()
  if not Avatar then
    return false
  end
  local QuestChain = Avatar.QuestChains and Avatar.QuestChains[QuestChainId]
  if not QuestChain or not QuestChain.IsUnlock then
    return false
  end
  return QuestChain:IsUnlock() == true
end

local function _GetTileEffectiveY(Position, Content)
  local TileY = Position and Position.Y or 0
  local OffsetYInTileSteps = Content and Content.OffsetYInTileSteps
  if OffsetYInTileSteps then
    TileY = TileY + OffsetYInTileSteps
  end
  return TileY
end

local function _IsReviewItemClickable(ReviewItemState)
  return ReviewItemState == M.ReviewItemState.Exploring or ReviewItemState == M.ReviewItemState.Explored
end

local function _GetColumnMainLineInfo(TileDataList, ColumnX)
  local MainLineCount = 0
  local bHasHalfOffset = false
  for _, TileData in ipairs(TileDataList) do
    local Position = TileData.Position
    local Content = TileData.Content
    if Position and Position.X == ColumnX and Content and Content.bIsMainLine then
      MainLineCount = MainLineCount + 1
      if Content.OffsetYInTileSteps == 0.5 then
        bHasHalfOffset = true
      end
    end
  end
  return MainLineCount, bHasHalfOffset
end

local function _IsEvenMainLineColumnWithHalfOffset(TileDataList, ColumnX)
  local MainLineCount, bHasHalfOffset = _GetColumnMainLineInfo(TileDataList, ColumnX)
  return MainLineCount > 0 and 0 == MainLineCount % 2 and bHasHalfOffset
end

local function _PickMaxTileYPosition(CandidateList)
  local BestEntry
  for _, Entry in ipairs(CandidateList) do
    local Position = Entry.Position
    if not BestEntry then
      BestEntry = Entry
    else
      local CandidateY = Position and Position.Y or 0
      local BestY = BestEntry.Position and BestEntry.Position.Y or 0
      if CandidateY > BestY then
        BestEntry = Entry
      end
    end
  end
  return BestEntry and BestEntry.Position
end

local function _ResolveEvenColumnTieBreak(QualifiedAtMinDistance, AllColumnEntriesAtMinDistance)
  local ClickableQualifiedList = {}
  for _, Entry in ipairs(QualifiedAtMinDistance) do
    if _IsReviewItemClickable(Entry.ReviewItemState) then
      table.insert(ClickableQualifiedList, Entry)
    end
  end
  local bHasClickableAtDistance = false
  local bHasPendingAtDistance = false
  for _, Entry in ipairs(AllColumnEntriesAtMinDistance) do
    if _IsReviewItemClickable(Entry.ReviewItemState) then
      bHasClickableAtDistance = true
    elseif Entry.ReviewItemState == M.ReviewItemState.Pending then
      bHasPendingAtDistance = true
    end
  end
  if bHasClickableAtDistance and bHasPendingAtDistance and #ClickableQualifiedList > 0 then
    return _PickMaxTileYPosition(ClickableQualifiedList)
  end
  return _PickMaxTileYPosition(QualifiedAtMinDistance)
end

local EffectiveYDistanceEpsilon = 1.0E-6

local function _IsSameAbsEffectiveY(AbsEffectiveY, MinAbsEffectiveY)
  return math.abs(AbsEffectiveY - MinAbsEffectiveY) < EffectiveYDistanceEpsilon
end

local function _ResolveInitialLocateInColumn(TileDataList, ColumnX, Avatar)
  local QualifiedList = {}
  local AllColumnEntries = {}
  for _, TileData in ipairs(TileDataList) do
    local Position = TileData.Position
    local Content = TileData.Content
    local ReviewId = Content and Content.ReviewId
    if Position and Position.X == ColumnX and ReviewId then
      local ReviewItemState = M.ResolveReviewItemState(ReviewId, Avatar)
      local Entry = {
        Position = Position,
        Content = Content,
        ReviewItemState = ReviewItemState
      }
      table.insert(AllColumnEntries, Entry)
      if _IsReviewItemClickable(ReviewItemState) then
        table.insert(QualifiedList, Entry)
      end
    end
  end
  if #QualifiedList <= 0 then
    return nil
  end
  local MinAbsEffectiveY
  for _, Entry in ipairs(QualifiedList) do
    local AbsEffectiveY = math.abs(_GetTileEffectiveY(Entry.Position, Entry.Content))
    if nil == MinAbsEffectiveY or MinAbsEffectiveY > AbsEffectiveY then
      MinAbsEffectiveY = AbsEffectiveY
    end
  end
  local QualifiedAtMinDistance = {}
  local AllColumnEntriesAtMinDistance = {}
  for _, Entry in ipairs(QualifiedList) do
    local AbsEffectiveY = math.abs(_GetTileEffectiveY(Entry.Position, Entry.Content))
    if _IsSameAbsEffectiveY(AbsEffectiveY, MinAbsEffectiveY) then
      table.insert(QualifiedAtMinDistance, Entry)
    end
  end
  for _, Entry in ipairs(AllColumnEntries) do
    local AbsEffectiveY = math.abs(_GetTileEffectiveY(Entry.Position, Entry.Content))
    if _IsSameAbsEffectiveY(AbsEffectiveY, MinAbsEffectiveY) then
      table.insert(AllColumnEntriesAtMinDistance, Entry)
    end
  end
  if #QualifiedAtMinDistance <= 1 then
    return QualifiedAtMinDistance[1] and QualifiedAtMinDistance[1].Position
  end
  if _IsEvenMainLineColumnWithHalfOffset(TileDataList, ColumnX) then
    return _ResolveEvenColumnTieBreak(QualifiedAtMinDistance, AllColumnEntriesAtMinDistance)
  end
  return _PickMaxTileYPosition(QualifiedAtMinDistance)
end

local function _ResolveTargetColumnXFromClickableEntries(ClickableEntryList)
  local TargetColumnX
  for _, Entry in ipairs(ClickableEntryList) do
    local ColumnX = Entry.Position and Entry.Position.X or 0
    if nil == TargetColumnX or TargetColumnX < ColumnX then
      TargetColumnX = ColumnX
    end
  end
  return TargetColumnX
end

function M.ResolveInitialLineLocatePosition(TileDataList, Avatar)
  if not TileDataList or #TileDataList <= 0 then
    return nil, nil
  end
  Avatar = Avatar or M.GetAvatarSafe()
  local ClickableEntryList = {}
  for _, TileData in ipairs(TileDataList) do
    local Position = TileData.Position
    local Content = TileData.Content
    local ReviewId = Content and Content.ReviewId
    if Position and ReviewId then
      local ReviewItemState = M.ResolveReviewItemState(ReviewId, Avatar)
      if _IsReviewItemClickable(ReviewItemState) then
        table.insert(ClickableEntryList, {
          Position = Position,
          Content = Content,
          ReviewItemState = ReviewItemState
        })
      end
    end
  end
  if #ClickableEntryList <= 0 then
    return nil, nil
  end
  local TargetColumnX = _ResolveTargetColumnXFromClickableEntries(ClickableEntryList)
  if nil == TargetColumnX then
    return nil, nil
  end
  local TargetPosition = _ResolveInitialLocateInColumn(TileDataList, TargetColumnX, Avatar)
  if not TargetPosition then
    return nil, nil
  end
  return TargetPosition.X, TargetPosition.Y
end

local function NormalizeProgressRewardConfig(RawConfig)
  if not RawConfig then
    return nil
  end
  local RewardId = RawConfig.RewardID or RawConfig.RewardId
  if not RewardId then
    return nil
  end
  return {
    SortId = RawConfig.SortID or RawConfig.SortId or 0,
    ClueTargetNum = RawConfig.ClueTargetNum or 0,
    RewardId = RewardId
  }
end

function M.CollectAllStringBoardClueIds()
  local ClueIdSeen = {}
  local ClueIdList = {}
  
  local function AppendClueList(ClueList)
    for _, ClueId in ipairs(ClueList or {}) do
      if ClueId and not ClueIdSeen[ClueId] and DataMgr.Clue and DataMgr.Clue[ClueId] then
        ClueIdSeen[ClueId] = true
        table.insert(ClueIdList, ClueId)
      end
    end
  end
  
  for _, CluePageData in pairs(DataMgr.CluePage or {}) do
    AppendClueList(CluePageData.ClueList)
  end
  return ClueIdList
end

function M.GetFinishedClueCount(Avatar)
  Avatar = Avatar or M.GetAvatarSafe()
  local FinishedCount = 0
  for _, ClueId in ipairs(M.CollectAllStringBoardClueIds()) do
    if M.CheckClueState(ClueId, Avatar) == CommonConst.ClueState.Finished then
      FinishedCount = FinishedCount + 1
    end
  end
  return FinishedCount
end

local LocalClaimedProgressRewardSortIds = {}

function M.IsProgressRewardClaimed(Avatar, SortId)
  if not SortId then
    return false
  end
  if true == LocalClaimedProgressRewardSortIds[SortId] then
    return true
  end
  Avatar = Avatar or M.GetAvatarSafe()
  local ClueRewards = Avatar and Avatar.ClueRewards
  if not ClueRewards then
    return false
  end
  return true == ClueRewards[SortId]
end

function M.MarkProgressRewardClaimedLocally(SortId)
  if not SortId then
    return
  end
  LocalClaimedProgressRewardSortIds[SortId] = true
end

function M.MarkAllClaimableProgressRewardsLocally(Avatar)
  Avatar = Avatar or M.GetAvatarSafe()
  local FinishedCount = M.GetFinishedClueCount(Avatar)
  for _, ProgressRewardConfig in ipairs(M.GetProgressRewardConfigList()) do
    local SortId = ProgressRewardConfig.SortId
    if SortId and not M.IsProgressRewardClaimed(Avatar, SortId) and FinishedCount >= (ProgressRewardConfig.ClueTargetNum or 0) then
      LocalClaimedProgressRewardSortIds[SortId] = true
    end
  end
end

function M.ClearLocalProgressRewardClaimOverrides()
  LocalClaimedProgressRewardSortIds = {}
end

function M.NotifyProgressRewardEntranceReddotRefresh()
  local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
  StringBoardReddotHelper.SyncProgressRewardReddot()
  local GameInstance = GWorld and GWorld.GameInstance
  local UIMgr = GameInstance and GameInstance.GetGameUIManager and GameInstance:GetGameUIManager()
  if not UIMgr or not UIMgr.GetUIObj then
    return
  end
  local StringBoard = UIMgr:GetUIObj("StringBoardMain")
  if StringBoard and IsValid(StringBoard) and StringBoard.RefreshBtnProgressReward then
    StringBoard:RefreshBtnProgressReward()
  end
end

function M.GetProgressRewardConfigList()
  local bLoadOk, RawTable = pcall(function()
    return DataMgr[ProgressRewardDataMgrTableName]
  end)
  local ConfigList = {}
  local SourceRows
  if bLoadOk and nil ~= RawTable then
    SourceRows = RawTable
  end
  if SourceRows then
    for _, RawConfig in pairs(SourceRows) do
      local NormalizedConfig = NormalizeProgressRewardConfig(RawConfig)
      if NormalizedConfig then
        table.insert(ConfigList, NormalizedConfig)
      end
    end
  end
  table.sort(ConfigList, function(LeftConfig, RightConfig)
    if LeftConfig.SortId == RightConfig.SortId then
      return LeftConfig.RewardId < RightConfig.RewardId
    end
    return LeftConfig.SortId < RightConfig.SortId
  end)
  return ConfigList
end

function M.GetProgressRewardState(Avatar, ProgressRewardConfig, FinishedCount)
  local RewardState = M.ProgressRewardState
  if not ProgressRewardConfig or not ProgressRewardConfig.RewardId then
    return RewardState.NotReach
  end
  if M.IsProgressRewardClaimed(Avatar, ProgressRewardConfig.SortId) then
    return RewardState.Got
  end
  if nil == FinishedCount then
    FinishedCount = M.GetFinishedClueCount(Avatar)
  end
  if FinishedCount >= (ProgressRewardConfig.ClueTargetNum or 0) then
    return RewardState.CanGet
  end
  return RewardState.NotReach
end

function M.GetProgressRewardCanGetCount(Avatar)
  Avatar = Avatar or M.GetAvatarSafe()
  local ConfigList = M.GetProgressRewardConfigList()
  if #ConfigList <= 0 then
    return 0
  end
  local FinishedCount = M.GetFinishedClueCount(Avatar)
  local CanGetCount = 0
  for _, ProgressRewardConfig in ipairs(ConfigList) do
    if M.GetProgressRewardState(Avatar, ProgressRewardConfig, FinishedCount) == M.ProgressRewardState.CanGet then
      CanGetCount = CanGetCount + 1
    end
  end
  return CanGetCount
end

function M.HasProgressRewardCanGet(Avatar)
  return M.GetProgressRewardCanGetCount(Avatar) > 0
end

function M.GetProgressRewardProgressNums(Avatar)
  Avatar = Avatar or M.GetAvatarSafe()
  local FinishedCount = M.GetFinishedClueCount(Avatar)
  local MaxClueTargetNum = 0
  for _, ProgressRewardConfig in ipairs(M.GetProgressRewardConfigList()) do
    MaxClueTargetNum = math.max(MaxClueTargetNum, ProgressRewardConfig.ClueTargetNum or 0)
  end
  if MaxClueTargetNum <= 0 then
    MaxClueTargetNum = 1
  end
  return FinishedCount, MaxClueTargetNum
end

function M.BuildProgressRewards(RewardId)
  local Rewards = {}
  local RewardInfo = DataMgr.Reward and DataMgr.Reward[RewardId]
  if not RewardInfo then
    return Rewards
  end
  local Ids = RewardInfo.Id or {}
  local Counts = RewardInfo.Count or {}
  local Types = RewardInfo.Type or {}
  for Index = 1, #Ids do
    table.insert(Rewards, {
      ItemType = Types[Index],
      ItemId = Ids[Index],
      Count = RewardUtils:GetCount(Counts[Index]),
      Rarity = ItemUtils.GetItemRarity(Ids[Index], Types[Index])
    })
  end
  return Rewards
end

function M.BuildProgressRewardPopupConfigData(Avatar, OwnerWidget)
  Avatar = Avatar or M.GetAvatarSafe()
  local ConfigList = M.GetProgressRewardConfigList()
  local FinishedCount, MaxClueTargetNum = M.GetProgressRewardProgressNums(Avatar)
  local RewardState = M.ProgressRewardState
  local Items = {}
  local OnReceive, OnReceiveAll
  if OwnerWidget then
    function OnReceive(_, Content)
      if not IsValid(OwnerWidget) then
        return
      end
      if OwnerWidget.OnProgressRewardReceive then
        OwnerWidget:OnProgressRewardReceive(Content)
      end
    end
    
    function OnReceiveAll(DialogWidget, ReceiveAllParam)
      if not IsValid(OwnerWidget) then
        return
      end
      if OwnerWidget.OnProgressRewardReceiveAll then
        OwnerWidget:OnProgressRewardReceiveAll(DialogWidget, ReceiveAllParam)
      end
    end
  end
  for _, ProgressRewardConfig in ipairs(ConfigList) do
    local State = M.GetProgressRewardState(Avatar, ProgressRewardConfig, FinishedCount)
    table.insert(Items, {
      ItemId = ProgressRewardConfig.RewardId,
      CanReceive = State == RewardState.CanGet,
      RewardsGot = State == RewardState.Got,
      SourceNum = ProgressRewardConfig.ClueTargetNum,
      Hint = GText("UI_TempleEvent_RewardTarget"),
      NotreachText = GText("UI_Archive_CollectionInProgress"),
      Rewards = M.BuildProgressRewards(ProgressRewardConfig.RewardId),
      ReceiveCallBack = OnReceive,
      ReceiveParm = {
        SortId = ProgressRewardConfig.SortId,
        RewardId = ProgressRewardConfig.RewardId
      }
    })
  end
  local ConfigData = {
    HasTab = false,
    Items = Items,
    NowNum = FinishedCount,
    NumMax = MaxClueTargetNum,
    Text_Total = "UI_StringBoard_Total",
    ReceiveButtonText = GText("UI_Archive_CollectionClaimAll"),
    ReceiveAllCallBack = OnReceiveAll,
    ReceiveAllParam = {},
    SortType = 1
  }
  return ConfigData, FinishedCount, MaxClueTargetNum
end

M.QuestTrackRegionAction = {
  SameRegion = "SameRegion",
  CrossRegion = "CrossRegion"
}

function M.CheckIsInSameRegionForQuestTrack(AvatarRegionId, TaskSubRegionId)
  local HomeBaseRegionId = CommonConst.HomeBaseSubRegionId
  if 0 == TaskSubRegionId then
    return false
  end
  if AvatarRegionId == TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
    return false
  end
  if AvatarRegionId ~= TaskSubRegionId and TaskSubRegionId == HomeBaseRegionId then
    return true
  end
  return true
end

function M.ResolveQuestTrackRegionAction(Avatar, QuestChainId, TargetSubRegionId)
  if not (Avatar and QuestChainId) or QuestChainId <= 0 then
    return nil
  end
  local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
  local TrackingQuestData = TaskUtils:GetTrackingQuestDetailInfo()
  if TrackingQuestData and TrackingQuestData.IsFairyLand then
    return nil
  end
  if nil == TargetSubRegionId or TargetSubRegionId <= 0 then
    local QuestChain = Avatar.QuestChains and Avatar.QuestChains[QuestChainId]
    local DoingQuestId = QuestChain and QuestChain.DoingQuestId
    if not DoingQuestId or DoingQuestId <= 0 then
      return nil
    end
    if not MissionIndicatorManager or not MissionIndicatorManager.GetTargetTaskSubRegionId then
      return nil
    end
    TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, DoingQuestId) or 0
  end
  if not M.CheckIsInSameRegionForQuestTrack(Avatar.CurrentRegionId, TargetSubRegionId) then
    return nil
  end
  local _, RegionMapId = TaskUtils:GetQuestMapInfo(QuestChainId)
  if not (RegionMapId and DataMgr.RegionMap[RegionMapId]) or not DataMgr.RegionMap[RegionMapId].RegionId then
    return nil
  end
  local IsInRegion = not TaskUtils:CheckIsNeedLoadLevelMap(TargetSubRegionId, Avatar.CurrentRegionId)
  if IsInRegion then
    return M.QuestTrackRegionAction.SameRegion
  end
  return M.QuestTrackRegionAction.CrossRegion
end

function M.TryRecoverBattleHUDIfUIStackEmpty(Widget)
  if not Widget or not IsValid(Widget) then
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(Widget)
  local UIManager = GameInstance and GameInstance:GetGameUIManager()
  if not (UIManager and UIManager.States) or 0 ~= UIManager.States:Num() then
    return
  end
  local UIUtils = require("Utils.UIUtils")
  local ConfigUIName = Widget.GetUIConfigName and Widget:GetUIConfigName() or nil
  local BattleMain = UIManager:GetUIObj("BattleMain")
  if BattleMain and BattleMain.RemovePlayInOutSystems and ConfigUIName then
    BattleMain:RemovePlayInOutSystems(ConfigUIName)
  end
  UIUtils.PlayBattleMainInAnim()
end

return M
