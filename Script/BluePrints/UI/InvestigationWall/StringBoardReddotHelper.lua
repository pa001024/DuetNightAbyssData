local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local CommonConst = require("CommonConst")
local TimeUtils = require("Utils.TimeUtils")
local M = {}
M.NodeName = {
  Root = "StringBoard",
  BoardNew = "StringBoard_BoardNew",
  LineNew = "StringBoard_LineNew",
  ProgressReward = "StringBoard_ProgressReward"
}
local KeyPrefix = {
  Tab = "Tab:",
  Page = "Page:",
  Item = "Item:",
  Content = "Content:",
  Finish = "Finish:",
  Review = "Review:",
  TabUnlockEntrance = "TabUnlock:",
  PageUnlockEntrance = "PageUnlock:"
}
local CacheSchemaVersion = 1
local CacheSchemaVersionKey = "__SchemaVer"
local ContentOwnerMap = {}
local ClueOwnerMap = {}
local PageOwnerMap = {}
local LastClueStructureTable, ResetCacheDetailToCurrentSchemaOnce, RecountBoardNewLeafAndNotify, RecountLineNewLeafAndNotify

local function MakeKey(Prefix, Id)
  if nil == Id then
    return nil
  end
  return Prefix .. tostring(Id)
end

local function KeyHasPrefix(CacheKey, Prefix)
  return type(CacheKey) == "string" and string.sub(CacheKey, 1, #Prefix) == Prefix
end

function M.MakeTabKey(ClueTabType)
  return MakeKey(KeyPrefix.Tab, ClueTabType)
end

function M.MakePageKey(CluePageId)
  return MakeKey(KeyPrefix.Page, CluePageId)
end

function M.MakeItemKey(ClueId)
  return MakeKey(KeyPrefix.Item, ClueId)
end

function M.MakeContentKey(ClueContentId)
  return MakeKey(KeyPrefix.Content, ClueContentId)
end

function M.MakeFinishKey(ClueContentId)
  return MakeKey(KeyPrefix.Finish, ClueContentId)
end

function M.MakeReviewKey(ReviewId)
  return MakeKey(KeyPrefix.Review, ReviewId)
end

function M.MakeTabUnlockEntranceKey(ClueTabType)
  return MakeKey(KeyPrefix.TabUnlockEntrance, ClueTabType)
end

function M.MakePageUnlockEntranceKey(CluePageId)
  return MakeKey(KeyPrefix.PageUnlockEntrance, CluePageId)
end

local QuestNodeName = "Quest"

local function EnsureLeafNodeReady(LeafNodeName, RdType, NodeModuleName)
  local LeafNode = ReddotManager.GetTreeNode(LeafNodeName)
  RdType = RdType or EReddotType.New
  if not LeafNode then
    if DataMgr.ReddotNode and DataMgr.ReddotNode[LeafNodeName] then
      LeafNode = ReddotManager.AddNodeEx(LeafNodeName)
    else
      LeafNode = ReddotManager.AddNodeEx(LeafNodeName, nil, Const.ReddotCacheType.UserCache, RdType, NodeModuleName)
    end
  end
  if LeafNode then
    LeafNode.bInvokeEveryTime = true
    LeafNode.ReddotType = RdType
  end
  return LeafNode
end

local function EnsureProgressRewardLeafReady()
  return EnsureLeafNodeReady(M.NodeName.ProgressReward, EReddotType.Normal, nil)
end

local function EnsureProgressRewardAttachedToRoot()
  EnsureProgressRewardLeafReady()
  local StringBoardNode = ReddotManager.GetTreeNode(M.NodeName.Root)
  if StringBoardNode and (not StringBoardNode.Children or not StringBoardNode.Children[M.NodeName.ProgressReward]) then
    ReddotManager.AddNodeEx(M.NodeName.Root, {
      [M.NodeName.ProgressReward] = {}
    })
  end
end

local function IsStringBoardTreeReady()
  if not ReddotManager or not ReddotManager.GetTreeNode then
    return false
  end
  local BoardNewNode = ReddotManager.GetTreeNode(M.NodeName.BoardNew)
  local LineNewNode = ReddotManager.GetTreeNode(M.NodeName.LineNew)
  local ProgressRewardNode = ReddotManager.GetTreeNode(M.NodeName.ProgressReward)
  local StringBoardNode = ReddotManager.GetTreeNode(M.NodeName.Root)
  local QuestNode = ReddotManager.GetTreeNode(QuestNodeName)
  if not (BoardNewNode and LineNewNode and ProgressRewardNode and StringBoardNode) or not QuestNode then
    return false
  end
  if not QuestNode.Children or not QuestNode.Children[M.NodeName.Root] then
    return false
  end
  return StringBoardNode.Children and StringBoardNode.Children[M.NodeName.ProgressReward] ~= nil
end

function M.EnsureNodes()
  if not ReddotManager or not ReddotManager.AddNodeEx then
    return
  end
  if not IsStringBoardTreeReady() then
    local bHasStringBoardConf = DataMgr.ReddotNode and DataMgr.ReddotNode[M.NodeName.Root] ~= nil
    if not ReddotManager.GetTreeNode(M.NodeName.Root) then
      if bHasStringBoardConf then
        ReddotManager.AddNodeEx(M.NodeName.Root)
      else
        EnsureLeafNodeReady(M.NodeName.BoardNew, EReddotType.New, "StringBoard")
        EnsureLeafNodeReady(M.NodeName.LineNew, EReddotType.New, "StringBoard")
        EnsureProgressRewardLeafReady()
        ReddotManager.AddNodeEx(M.NodeName.Root, {
          [M.NodeName.BoardNew] = {},
          [M.NodeName.LineNew] = {},
          [M.NodeName.ProgressReward] = {}
        })
      end
    end
    EnsureLeafNodeReady(M.NodeName.BoardNew, EReddotType.New, "StringBoard")
    EnsureLeafNodeReady(M.NodeName.LineNew, EReddotType.New, "StringBoard")
    EnsureProgressRewardAttachedToRoot()
    local QuestNode = ReddotManager.GetTreeNode(QuestNodeName)
    if not QuestNode then
      if DataMgr.ReddotNode and DataMgr.ReddotNode[QuestNodeName] then
        ReddotManager.AddNodeEx(QuestNodeName)
      end
      QuestNode = ReddotManager.GetTreeNode(QuestNodeName)
    end
    if QuestNode and not QuestNode.Children[M.NodeName.Root] then
      ReddotManager.AddNodeEx(QuestNodeName, {
        [M.NodeName.Root] = {}
      })
    end
  end
  EnsureProgressRewardAttachedToRoot()
  local StringBoardRoot = ReddotManager.GetTreeNode(M.NodeName.Root)
  if StringBoardRoot then
    StringBoardRoot.bInvokeEveryTime = true
  end
  ResetCacheDetailToCurrentSchemaOnce()
end

function M.LogReddotCounts(Reason)
  local function NodeCountAndType(NodeName)
    local Node = ReddotManager.GetTreeNode(NodeName)
    
    if not Node then
      return -1, nil
    end
    return Node.Count or 0, Node.ReddotType
  end
  
  local BoardCount, BoardType = NodeCountAndType(M.NodeName.BoardNew)
  local LineCount, LineType = NodeCountAndType(M.NodeName.LineNew)
  local RewardCount, RewardType = NodeCountAndType(M.NodeName.ProgressReward)
  local RootCount, RootType = NodeCountAndType(M.NodeName.Root)
  DebugPrint("[StringBoardReddot] Counts", Reason or "", "BoardNew=", BoardCount, BoardType, "LineNew=", LineCount, LineType, "ProgressReward=", RewardCount, RewardType, "Root=", RootCount, RootType)
end

function M.SyncProgressRewardReddot()
  M.EnsureNodes()
  local NodeName = M.NodeName.ProgressReward
  if not ReddotManager.GetTreeNode(NodeName) then
    return
  end
  ReddotManager.ClearLeafNodeCount(NodeName)
  local Count = InvestigationWallUtils.GetProgressRewardCanGetCount()
  if Count > 0 then
    ReddotManager.IncreaseLeafNodeCount(NodeName, Count)
  end
  RecountBoardNewLeafAndNotify()
  RecountLineNewLeafAndNotify()
  M.LogReddotCounts("SyncProgressRewardReddot")
end

function M.SyncAllNews()
  if TimeUtils.ServerTimeZone == nil then
    return
  end
  if not InvestigationWallUtils.GetAvatarSafe() then
    return
  end
  M.EnsureNodes()
  local ClueStructureTable = InvestigationWallUtils.BuildClueStructureTable()
  M.SyncBoardNews(ClueStructureTable)
  M.SyncLineNews(nil)
  M.SyncProgressRewardReddot()
  M.LogReddotCounts("SyncAllNews")
end

function M.RequestSyncAllNews()
  local GameInstance = GWorld and GWorld.GameInstance
  if GameInstance and GameInstance.AddTimer then
    GameInstance:AddTimer(0.01, function()
      M.SyncAllNews()
    end, false, nil, "StringBoardReddotSyncAllNews")
    return
  end
  M.SyncAllNews()
end

local function GetDetail(NodeName)
  if not ReddotManager.GetTreeNode(NodeName) then
    M.EnsureNodes()
  end
  return ReddotManager.GetLeafNodeCacheDetail(NodeName)
end

function M.IsKeyNew(NodeName, CacheKey)
  if not CacheKey then
    return false
  end
  local Detail = GetDetail(NodeName)
  return Detail and true == Detail[CacheKey]
end

function M.TryAddNew(NodeName, CacheKey)
  if not CacheKey then
    return false
  end
  if not ReddotManager.GetTreeNode(NodeName) then
    M.EnsureNodes()
  end
  return ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {CacheKey = CacheKey})
end

function M.TryClearNew(NodeName, CacheKey)
  if not CacheKey then
    return false
  end
  if not ReddotManager.GetTreeNode(NodeName) then
    M.EnsureNodes()
  end
  if not M.IsKeyNew(NodeName, CacheKey) then
    return false
  end
  return ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {CacheKey = CacheKey})
end

function M.GetLeafCount(NodeName)
  if not ReddotManager.GetTreeNode(NodeName) then
    M.EnsureNodes()
  end
  local Node = ReddotManager.GetTreeNode(NodeName)
  return Node and Node.Count or 0
end

function M.HasBoardNews()
  return M.GetLeafCount(M.NodeName.BoardNew) > 0
end

function M.HasLineNewsOnReviewPage(ReviewPageId)
  ReviewPageId = InvestigationWallUtils.ResolveReviewPageId(ReviewPageId)
  if not ReviewPageId then
    return false
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  local TileDataList = InvestigationWallUtils.BuildTilePositionDataFromReviewChain(ReviewPageId, Avatar)
  for _, TileData in ipairs(TileDataList or {}) do
    local ReviewId = TileData.Content and TileData.Content.ReviewId
    if ReviewId and M.IsReviewNew(ReviewId) then
      return true
    end
  end
  return false
end

function M.IsTabNew(ClueTabType)
  return M.IsKeyNew(M.NodeName.BoardNew, M.MakeTabKey(ClueTabType))
end

function M.IsPageNew(CluePageId)
  return M.IsKeyNew(M.NodeName.BoardNew, M.MakePageKey(CluePageId))
end

function M.IsClueItemNew(ClueId)
  return M.IsKeyNew(M.NodeName.BoardNew, M.MakeItemKey(ClueId))
end

function M.IsClueContentNew(ClueContentId)
  return M.IsKeyNew(M.NodeName.BoardNew, M.MakeContentKey(ClueContentId))
end

function M.IsReviewNew(ReviewId)
  return M.IsKeyNew(M.NodeName.LineNew, M.MakeReviewKey(ReviewId))
end

function M.HasSeenFinishEntrance(ClueContentId)
  if not ClueContentId then
    return true
  end
  local Detail = GetDetail(M.NodeName.BoardNew)
  return Detail and Detail[M.MakeFinishKey(ClueContentId)] == false
end

function M.MarkFinishEntranceSeen(ClueContentId)
  if not ClueContentId then
    return
  end
  local Detail = GetDetail(M.NodeName.BoardNew)
  if Detail then
    Detail[M.MakeFinishKey(ClueContentId)] = false
  end
end

function M.HasSeenTabUnlockEntrance(ClueTabType)
  if not ClueTabType then
    return true
  end
  local Detail = GetDetail(M.NodeName.BoardNew)
  return Detail and Detail[M.MakeTabUnlockEntranceKey(ClueTabType)] == false
end

function M.MarkTabUnlockEntranceSeen(ClueTabType)
  if not ClueTabType then
    return
  end
  local Detail = GetDetail(M.NodeName.BoardNew)
  if Detail then
    Detail[M.MakeTabUnlockEntranceKey(ClueTabType)] = false
  end
end

function M.HasSeenPageUnlockEntrance(CluePageId)
  if not CluePageId then
    return true
  end
  local Detail = GetDetail(M.NodeName.BoardNew)
  return Detail and Detail[M.MakePageUnlockEntranceKey(CluePageId)] == false
end

function M.MarkPageUnlockEntranceSeen(CluePageId)
  if not CluePageId then
    return
  end
  local Detail = GetDetail(M.NodeName.BoardNew)
  if Detail then
    Detail[M.MakePageUnlockEntranceKey(CluePageId)] = false
  end
end

local function ResolveClueContentIdList(ClueId)
  local Owner = ClueOwnerMap[ClueId]
  if Owner and Owner.ClueContentIdList then
    return Owner.ClueContentIdList
  end
  local ClueConfig = ClueId and DataMgr.Clue and DataMgr.Clue[ClueId]
  return ClueConfig and (ClueConfig.ClueContent or {}) or {}
end

local function CollectClueIdListOnPage(CluePageId)
  local PageOwner = PageOwnerMap[CluePageId]
  if PageOwner and PageOwner.ClueIdList then
    return PageOwner.ClueIdList
  end
  for _, PageTypeEntry in ipairs(LastClueStructureTable or {}) do
    for _, CluePageEntry in ipairs(PageTypeEntry.CluePageList or {}) do
      if CluePageEntry.CluePageId == CluePageId then
        return CluePageEntry.ClueList or {}
      end
    end
  end
  return {}
end

local function CollectPageIdListOnTab(ClueTabType)
  local PageIdList = {}
  local PageIdSeen = {}
  for CluePageId, PageOwner in pairs(PageOwnerMap) do
    if PageOwner.ClueTabType == ClueTabType and not PageIdSeen[CluePageId] then
      PageIdSeen[CluePageId] = true
      PageIdList[#PageIdList + 1] = CluePageId
    end
  end
  if #PageIdList > 0 then
    return PageIdList
  end
  for _, PageTypeEntry in ipairs(LastClueStructureTable or {}) do
    if PageTypeEntry.PageType == ClueTabType then
      for _, CluePageEntry in ipairs(PageTypeEntry.CluePageList or {}) do
        local CluePageId = CluePageEntry.CluePageId
        if CluePageId and not PageIdSeen[CluePageId] then
          PageIdSeen[CluePageId] = true
          PageIdList[#PageIdList + 1] = CluePageId
        end
      end
    end
  end
  return PageIdList
end

local function IsClueLockedForBoardNew(ClueId)
  if not ClueId then
    return true
  end
  return InvestigationWallUtils.CheckClueState(ClueId, InvestigationWallUtils.GetAvatarSafe()) == CommonConst.ClueState.Locked
end

local function HasAnyContentNewUnderClue(ClueId)
  if IsClueLockedForBoardNew(ClueId) then
    return false
  end
  for _, ClueContentId in ipairs(ResolveClueContentIdList(ClueId)) do
    if M.IsClueContentNew(ClueContentId) then
      return true
    end
  end
  return false
end

local function HasAnyItemNewUnderPage(CluePageId)
  if not InvestigationWallUtils.CheckCluePageUnlockCondition(CluePageId) then
    return false
  end
  for _, ClueId in ipairs(CollectClueIdListOnPage(CluePageId)) do
    if not IsClueLockedForBoardNew(ClueId) and M.IsClueItemNew(ClueId) then
      return true
    end
  end
  return false
end

local function HasAnyPageNewUnderTab(ClueTabType)
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  for _, CluePageId in ipairs(CollectPageIdListOnTab(ClueTabType)) do
    if InvestigationWallUtils.CheckCluePageUnlockCondition(CluePageId, Avatar) and M.IsPageNew(CluePageId) then
      return true
    end
  end
  return false
end

local function FindPageAndTabByClueIdFromStructure(ClueId)
  for _, PageTypeEntry in ipairs(LastClueStructureTable or {}) do
    for _, CluePageEntry in ipairs(PageTypeEntry.CluePageList or {}) do
      for _, StructureClueId in ipairs(CluePageEntry.ClueList or {}) do
        if StructureClueId == ClueId then
          return CluePageEntry.CluePageId, PageTypeEntry.PageType
        end
      end
    end
  end
  return nil, nil
end

local function ParseKeyId(CacheKey, Prefix)
  if not CacheKey or type(CacheKey) ~= "string" then
    return nil
  end
  if not KeyHasPrefix(CacheKey, Prefix) then
    return nil
  end
  local IdText = string.sub(CacheKey, #Prefix + 1)
  if "" == IdText then
    return nil
  end
  local IdNumber = tonumber(IdText)
  if nil ~= IdNumber then
    return IdNumber
  end
  return IdText
end

local function RecountLeafAndNotify(NodeName)
  local Detail = GetDetail(NodeName)
  local Node = ReddotManager.GetTreeNode(NodeName)
  if not Detail or not Node then
    return
  end
  local OldCount = Node.Count or 0
  local NewCount = 0
  for _, Value in pairs(Detail) do
    if true == Value then
      NewCount = NewCount + 1
    end
  end
  DebugPrint("[StringBoardReddot] Recount", NodeName, "OldCount=", OldCount, "DetailTrue=", NewCount)
  if OldCount == NewCount then
    return
  end
  Node.Count = NewCount
  if Node.Cache then
    Node.Cache.Count = NewCount
  end
  if Node.UpdateParentsCount then
    Node:UpdateParentsCount()
  end
  ReddotManager.TryInvokeEvent(Node, OldCount)
end

local function DiscardLeafNewKey(NodeName, CacheKey)
  local Detail = GetDetail(NodeName)
  if not Detail or true ~= Detail[CacheKey] then
    return false
  end
  Detail[CacheKey] = nil
  return true
end

local function DiscardBoardNewKey(CacheKey)
  return DiscardLeafNewKey(M.NodeName.BoardNew, CacheKey)
end

local function DiscardLineNewKey(CacheKey)
  return DiscardLeafNewKey(M.NodeName.LineNew, CacheKey)
end

function RecountBoardNewLeafAndNotify()
  RecountLeafAndNotify(M.NodeName.BoardNew)
end

function RecountLineNewLeafAndNotify()
  RecountLeafAndNotify(M.NodeName.LineNew)
end

local function HasCurrentCacheSchemaVersion(Detail)
  if not Detail then
    return false
  end
  local Version = Detail[CacheSchemaVersionKey]
  return type(Version) == "number" and Version >= CacheSchemaVersion
end

local function ResetDetailToCurrentSchema(Detail)
  if not Detail then
    return false
  end
  if HasCurrentCacheSchemaVersion(Detail) then
    return false
  end
  local PendingRemoveKeyList = {}
  for CacheKey, _ in pairs(Detail) do
    PendingRemoveKeyList[#PendingRemoveKeyList + 1] = CacheKey
  end
  for _, CacheKey in ipairs(PendingRemoveKeyList) do
    Detail[CacheKey] = nil
  end
  Detail[CacheSchemaVersionKey] = CacheSchemaVersion
  return true
end

function ResetCacheDetailToCurrentSchemaOnce()
  if not ReddotManager or not ReddotManager.GetLeafNodeCacheDetail then
    return
  end
  if not ReddotManager.GetTreeNode(M.NodeName.BoardNew) or not ReddotManager.GetTreeNode(M.NodeName.LineNew) then
    return
  end
  local BoardDetail = ReddotManager.GetLeafNodeCacheDetail(M.NodeName.BoardNew)
  local LineDetail = ReddotManager.GetLeafNodeCacheDetail(M.NodeName.LineNew)
  local bBoardChanged = ResetDetailToCurrentSchema(BoardDetail)
  local bLineChanged = ResetDetailToCurrentSchema(LineDetail)
  if bBoardChanged then
    RecountBoardNewLeafAndNotify()
  end
  if bLineChanged then
    RecountLineNewLeafAndNotify()
  end
end

local function DiscardLockedClueBoardNews(ClueId)
  if not ClueId then
    return false
  end
  local bDiscarded = false
  for _, ClueContentId in ipairs(ResolveClueContentIdList(ClueId)) do
    if DiscardBoardNewKey(M.MakeContentKey(ClueContentId)) then
      bDiscarded = true
    end
  end
  if DiscardBoardNewKey(M.MakeItemKey(ClueId)) then
    bDiscarded = true
  end
  return bDiscarded
end

local function IsClueContentUnlockedForNew(ClueContentState)
  return ClueContentState == CommonConst.ClueContentState.Unlocked or ClueContentState == CommonConst.ClueContentState.CrossedOut
end

local function ReconcileBoardAggregationKeys()
  local Detail = GetDetail(M.NodeName.BoardNew)
  if not Detail then
    return
  end
  if not LastClueStructureTable or 0 == #LastClueStructureTable then
    return
  end
  local ItemKeyList = {}
  local PageKeyList = {}
  local TabKeyList = {}
  local ContentKeyList = {}
  local bNeedRecount = false
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  for CacheKey, Value in pairs(Detail) do
    if true == Value and type(CacheKey) == "string" then
      if KeyHasPrefix(CacheKey, KeyPrefix.Content) then
        ContentKeyList[#ContentKeyList + 1] = CacheKey
      elseif KeyHasPrefix(CacheKey, KeyPrefix.Item) then
        ItemKeyList[#ItemKeyList + 1] = CacheKey
      elseif KeyHasPrefix(CacheKey, KeyPrefix.Page) then
        PageKeyList[#PageKeyList + 1] = CacheKey
      elseif KeyHasPrefix(CacheKey, KeyPrefix.Tab) then
        TabKeyList[#TabKeyList + 1] = CacheKey
      end
    end
  end
  for _, CacheKey in ipairs(ContentKeyList) do
    local ClueContentId = ParseKeyId(CacheKey, KeyPrefix.Content)
    local Owner = ClueContentId and ContentOwnerMap[ClueContentId]
    local ClueId = Owner and Owner.ClueId
    local bShouldDiscard = false
    if not Owner or not ClueId then
      bShouldDiscard = true
    elseif IsClueLockedForBoardNew(ClueId) then
      bShouldDiscard = true
    else
      local ClueContentState = InvestigationWallUtils.CheckClueContentState(ClueContentId, Avatar, ClueId)
      if not IsClueContentUnlockedForNew(ClueContentState) then
        bShouldDiscard = true
      end
    end
    if bShouldDiscard and DiscardBoardNewKey(CacheKey) then
      bNeedRecount = true
    end
  end
  for _, CacheKey in ipairs(ItemKeyList) do
    local ClueId = ParseKeyId(CacheKey, KeyPrefix.Item)
    if nil ~= ClueId and (IsClueLockedForBoardNew(ClueId) or not HasAnyContentNewUnderClue(ClueId)) and DiscardBoardNewKey(CacheKey) then
      bNeedRecount = true
    end
  end
  for _, CacheKey in ipairs(PageKeyList) do
    local CluePageId = ParseKeyId(CacheKey, KeyPrefix.Page)
    if nil ~= CluePageId and not HasAnyItemNewUnderPage(CluePageId) and DiscardBoardNewKey(CacheKey) then
      bNeedRecount = true
    end
  end
  for _, CacheKey in ipairs(TabKeyList) do
    local ClueTabType = ParseKeyId(CacheKey, KeyPrefix.Tab)
    if nil ~= ClueTabType and not HasAnyPageNewUnderTab(ClueTabType) and DiscardBoardNewKey(CacheKey) then
      bNeedRecount = true
    end
  end
  if bNeedRecount then
    RecountBoardNewLeafAndNotify()
  end
end

local function ClearClueItemAggregationIfNoContentNew(ClueId)
  if not ClueId then
    return
  end
  if HasAnyContentNewUnderClue(ClueId) then
    return
  end
  local bNeedRecount = false
  if DiscardBoardNewKey(M.MakeItemKey(ClueId)) then
    bNeedRecount = true
  end
  local ClueOwner = ClueOwnerMap[ClueId]
  local CluePageId = ClueOwner and ClueOwner.CluePageId
  local ClueTabType = ClueOwner and ClueOwner.ClueTabType
  if not CluePageId then
    CluePageId, ClueTabType = FindPageAndTabByClueIdFromStructure(ClueId)
  end
  if not CluePageId then
    if bNeedRecount then
      RecountBoardNewLeafAndNotify()
    end
    return
  end
  if not HasAnyItemNewUnderPage(CluePageId) and DiscardBoardNewKey(M.MakePageKey(CluePageId)) then
    bNeedRecount = true
  end
  local PageOwner = PageOwnerMap[CluePageId]
  ClueTabType = PageOwner and PageOwner.ClueTabType or ClueTabType
  if not ClueTabType then
    local _, StructureTabType = FindPageAndTabByClueIdFromStructure(ClueId)
    ClueTabType = StructureTabType
  end
  if ClueTabType and not HasAnyPageNewUnderTab(ClueTabType) and DiscardBoardNewKey(M.MakeTabKey(ClueTabType)) then
    bNeedRecount = true
  end
  if bNeedRecount then
    RecountBoardNewLeafAndNotify()
  end
end

function M.ClearClueItemNews(ClueId)
  if not ClueId then
    return
  end
  local BoardNew = M.NodeName.BoardNew
  for _, ClueContentId in ipairs(ResolveClueContentIdList(ClueId)) do
    M.TryClearNew(BoardNew, M.MakeContentKey(ClueContentId))
  end
  ClearClueItemAggregationIfNoContentNew(ClueId)
  ReconcileBoardAggregationKeys()
  RecountBoardNewLeafAndNotify()
  M.LogReddotCounts("ClearClueItemNews:" .. tostring(ClueId))
end

function M.ClearReviewNew(ReviewId)
  local bCleared = M.TryClearNew(M.NodeName.LineNew, M.MakeReviewKey(ReviewId))
  RecountLineNewLeafAndNotify()
  M.LogReddotCounts("ClearReviewNew:" .. tostring(ReviewId))
  return bCleared
end

function M.SyncBoardNews(ClueStructureTable)
  M.EnsureNodes()
  if not ClueStructureTable or 0 == #ClueStructureTable then
    return
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar then
    return
  end
  ContentOwnerMap = {}
  ClueOwnerMap = {}
  PageOwnerMap = {}
  LastClueStructureTable = ClueStructureTable
  local BoardNew = M.NodeName.BoardNew
  local bNeedRecount = false
  for _, PageTypeEntry in ipairs(ClueStructureTable) do
    local ClueTabType = PageTypeEntry.PageType
    local bTabHasNew = false
    for _, CluePageEntry in ipairs(PageTypeEntry.CluePageList or {}) do
      local CluePageId = CluePageEntry.CluePageId
      local ClueIdList = CluePageEntry.ClueList or {}
      PageOwnerMap[CluePageId] = {ClueTabType = ClueTabType, ClueIdList = ClueIdList}
      local bPageHasNew = false
      local bPageUnlocked = InvestigationWallUtils.CheckCluePageUnlockCondition(CluePageId, Avatar)
      for _, ClueId in ipairs(ClueIdList) do
        local ClueConfig = ClueId and DataMgr.Clue and DataMgr.Clue[ClueId]
        local ClueContentIdList = ClueConfig and (ClueConfig.ClueContent or {}) or {}
        ClueOwnerMap[ClueId] = {
          CluePageId = CluePageId,
          ClueTabType = ClueTabType,
          ClueContentIdList = ClueContentIdList
        }
        for _, ClueContentId in ipairs(ClueContentIdList) do
          ContentOwnerMap[ClueContentId] = {
            ClueId = ClueId,
            CluePageId = CluePageId,
            ClueTabType = ClueTabType
          }
        end
        if bPageUnlocked then
          if IsClueLockedForBoardNew(ClueId) then
            if DiscardLockedClueBoardNews(ClueId) then
              bNeedRecount = true
            end
          else
            local bClueHasNew = false
            for _, ClueContentId in ipairs(ClueContentIdList) do
              local ClueContentState = InvestigationWallUtils.CheckClueContentState(ClueContentId, Avatar, ClueId)
              if IsClueContentUnlockedForNew(ClueContentState) then
                M.TryAddNew(BoardNew, M.MakeContentKey(ClueContentId))
                if M.IsClueContentNew(ClueContentId) then
                  bClueHasNew = true
                end
              elseif DiscardBoardNewKey(M.MakeContentKey(ClueContentId)) then
                bNeedRecount = true
              end
            end
            if bClueHasNew then
              M.TryAddNew(BoardNew, M.MakeItemKey(ClueId))
            elseif DiscardBoardNewKey(M.MakeItemKey(ClueId)) then
              bNeedRecount = true
            end
            if M.IsClueItemNew(ClueId) then
              bPageHasNew = true
            end
          end
        end
      end
      if bPageHasNew then
        M.TryAddNew(BoardNew, M.MakePageKey(CluePageId))
      elseif DiscardBoardNewKey(M.MakePageKey(CluePageId)) then
        bNeedRecount = true
      end
      if M.IsPageNew(CluePageId) then
        bTabHasNew = true
      end
    end
    if bTabHasNew then
      M.TryAddNew(BoardNew, M.MakeTabKey(ClueTabType))
    elseif DiscardBoardNewKey(M.MakeTabKey(ClueTabType)) then
      bNeedRecount = true
    end
  end
  if bNeedRecount then
    RecountBoardNewLeafAndNotify()
  end
  ReconcileBoardAggregationKeys()
  RecountBoardNewLeafAndNotify()
  M.LogReddotCounts("SyncBoardNews")
end

function M.SyncLineNews(ReviewPageId)
  M.EnsureNodes()
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  local LineNew = M.NodeName.LineNew
  local ReviewItemState = InvestigationWallUtils.ReviewItemState
  local bNeedRecount = false
  
  local function SyncOnePage(PageId, SyncedReviewIdSet)
    local TileDataList = InvestigationWallUtils.BuildTilePositionDataFromReviewChain(PageId, Avatar)
    for _, TileData in ipairs(TileDataList or {}) do
      local ReviewId = TileData.Content and TileData.Content.ReviewId
      if ReviewId then
        if SyncedReviewIdSet then
          SyncedReviewIdSet[ReviewId] = true
        end
        local CurrentReviewItemState = InvestigationWallUtils.ResolveReviewItemState(ReviewId, Avatar)
        if CurrentReviewItemState == ReviewItemState.Exploring or CurrentReviewItemState == ReviewItemState.Explored then
          M.TryAddNew(LineNew, M.MakeReviewKey(ReviewId))
        elseif DiscardLineNewKey(M.MakeReviewKey(ReviewId)) then
          bNeedRecount = true
        end
      end
    end
  end
  
  if ReviewPageId then
    SyncOnePage(ReviewPageId, nil)
    RecountLineNewLeafAndNotify()
    M.LogReddotCounts("SyncLineNews:" .. tostring(ReviewPageId))
    return
  end
  local SyncedReviewIdSet = {}
  for PageId, _ in pairs(DataMgr.ReviewPage or {}) do
    SyncOnePage(PageId, SyncedReviewIdSet)
  end
  local Detail = GetDetail(LineNew)
  if Detail then
    local ReviewKeyList = {}
    for CacheKey, Value in pairs(Detail) do
      if true == Value and KeyHasPrefix(CacheKey, KeyPrefix.Review) then
        ReviewKeyList[#ReviewKeyList + 1] = CacheKey
      end
    end
    for _, CacheKey in ipairs(ReviewKeyList) do
      local ReviewId = ParseKeyId(CacheKey, KeyPrefix.Review)
      if nil ~= ReviewId and not SyncedReviewIdSet[ReviewId] and DiscardLineNewKey(CacheKey) then
        bNeedRecount = true
      end
    end
  end
  if bNeedRecount then
    RecountLineNewLeafAndNotify()
  end
  RecountLineNewLeafAndNotify()
  M.LogReddotCounts("SyncLineNews")
end

return M
