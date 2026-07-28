local EastSeasonQuestUtils = require("BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils")
local SoloTreasureUtils = require("Utils.SoloTreasureUtils")
local EMCache = require("EMCache.EMCache")
local M = {}
M.REDDOT_NODE_ILLUSTRATED_REWARD = "SoloTreasure_Permanent_Illustrated"
M.REDDOT_NODE_LIMIT_REWARD = "SoloTreasure_Permanent_Reward"
M.REDDOT_NODE_PLAYSUBTAB_NEW = "SoloTreasurePlaySubtabNew"
M.PLAYSUBTAB_UNLOCK_RULE = "SoloTreasurePerm"
M.ALL_TAB_ID = -1

function M:GetManualInfo()
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar or nil == Avatar.TreasureHuntManualInfo then
    return nil
  end
  return Avatar.TreasureHuntManualInfo
end

function M:GetTreasureIllustratedUnlockedCount()
  local ManualInfo = self:GetManualInfo()
  if nil == ManualInfo or nil == ManualInfo.Manual then
    return 0
  end
  return ManualInfo.Manual:Length()
end

function M:GetTreasureIllustratedTotalCount()
  local TotalCount = 0
  for _, Info in pairs(DataMgr.ExtractionTreasure) do
    if Info.TreasurePlayModeType then
      TotalCount = TotalCount + 1
    end
  end
  return TotalCount
end

function M:GetTreasureIllustratedRewardedCount()
  local ManualInfo = self:GetManualInfo()
  if nil == ManualInfo or nil == ManualInfo.ManualReward then
    return 0
  end
  return ManualInfo.ManualReward:Length()
end

function M:IsRewardClaimed(RewardProgress, ManualInfo)
  ManualInfo = ManualInfo or self:GetManualInfo()
  if nil == ManualInfo or nil == ManualInfo.ManualReward then
    return false
  end
  return ManualInfo.ManualReward:HasElement(RewardProgress)
end

function M:GetClaimableRewardCount()
  local ManualInfo = self:GetManualInfo()
  local UnlockedCount = self:GetTreasureIllustratedUnlockedCount()
  local ClaimableCount = 0
  for RewardProgress, _ in pairs(DataMgr.TreasureArchiveReward) do
    if RewardProgress <= UnlockedCount and not self:IsRewardClaimed(RewardProgress, ManualInfo) then
      ClaimableCount = ClaimableCount + 1
    end
  end
  return ClaimableCount
end

function M:IsFirstShowNewTreasureIllustrated(TreasureId)
  local ManualInfo = self:GetManualInfo()
  if nil == ManualInfo or nil == ManualInfo.NewManual then
    return true
  end
  return ManualInfo.NewManual:HasElement(TreasureId)
end

function M:GetSeasonConfigData()
  local SeasonId = SoloTreasureUtils:GetSoloTreasureSeasonId()
  local SeasonConfig = DataMgr.PermanentTreasureHunt[SeasonId]
  return SeasonConfig
end

function M:InitReddotTree()
  if not ReddotManager.GetTreeNode("Permanent_SoloTreasureMain") then
    ReddotManager.AddNodeEx("Permanent_SoloTreasureMain")
  end
  if not ReddotManager.GetTreeNode("SoloTreasurePlaySubtabMain") then
    ReddotManager.AddNodeEx("SoloTreasurePlaySubtabMain")
  end
  self:RefreshManualArchiveRewardReddot()
  self:RefreshLimitRewardReddot(true)
  self:RefreshPlaySubtabNewReddot()
end

function M:IsPlaySubtabUnlocked()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local RuleInfo = DataMgr.UIUnlockRule[self.PLAYSUBTAB_UNLOCK_RULE]
  if not RuleInfo or not RuleInfo.UIUnlockRuleId then
    return true
  end
  return Avatar:CheckUIUnlocked(RuleInfo.UIUnlockRuleId)
end

function M:IsPlaySubtabNewRead()
  local Detail = ReddotManager.GetLeafNodeCacheDetail(self.REDDOT_NODE_PLAYSUBTAB_NEW)
  if not Detail then
    return false
  end
  return Detail.bRead == true
end

function M:RefreshPlaySubtabNewReddot()
  ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_PLAYSUBTAB_NEW)
  if self:IsPlaySubtabUnlocked() and not self:IsPlaySubtabNewRead() then
    ReddotManager.IncreaseLeafNodeCount(self.REDDOT_NODE_PLAYSUBTAB_NEW, 1)
  end
end

function M:MarkPlaySubtabNewRead()
  local Detail = ReddotManager.GetLeafNodeCacheDetail(self.REDDOT_NODE_PLAYSUBTAB_NEW)
  if Detail then
    Detail.bRead = true
  end
  ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_PLAYSUBTAB_NEW)
  EMCache:SaveUser(false)
end

function M:RefreshManualArchiveRewardReddot()
  local Node = ReddotManager.GetTreeNode(self.REDDOT_NODE_ILLUSTRATED_REWARD)
  if not Node then
    ReddotManager.AddNodeEx(self.REDDOT_NODE_ILLUSTRATED_REWARD)
  end
  local ClaimableCount = self:GetClaimableRewardCount()
  ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_ILLUSTRATED_REWARD)
  if ClaimableCount > 0 then
    ReddotManager.IncreaseLeafNodeCount(self.REDDOT_NODE_ILLUSTRATED_REWARD, ClaimableCount)
  end
end

function M:RefreshLimitRewardReddot(ClearCache)
  ClearCache = ClearCache or false
  local SeasonConfig = self:GetSeasonConfigData()
  local EventId = SeasonConfig and SeasonConfig.SeasonEventId or -1
  self:RefreshReddotInfoInternal(self.REDDOT_NODE_LIMIT_REWARD, EventId, ClearCache)
end

function M:RefreshReddotInfoInternal(ReddotKey, EventId, ClearCache)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
  if not CommonQuestActivity then
    return
  end
  pcall(function()
    local Node = ReddotManager.GetTreeNode(ReddotKey)
    if not Node then
      ReddotManager.AddNodeEx(ReddotKey)
    end
    if ClearCache then
      ReddotManager.ClearLeafNodeCount(ReddotKey)
      local NodeCache = ReddotManager._GetLeafNodeCache(ReddotKey)
      NodeCache.Detail = {}
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotKey)
    for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
      if PhaseConfig.EventId == EventId then
        for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
          if Config.QuestPhaseId == QuestPhaseId then
            local QuestData = CommonQuestActivity[QuestId]
            if not (QuestData and QuestData.Progress) or not QuestData.Target then
            else
              local CanReceive = QuestData:IsComplete()
              if CanReceive and not QuestData.RewardsGot then
                if not CacheDetail[QuestPhaseId] then
                  CacheDetail[QuestPhaseId] = {}
                end
                if not CacheDetail[QuestPhaseId][QuestId] then
                  ReddotManager.IncreaseLeafNodeCount(ReddotKey)
                  CacheDetail[QuestPhaseId][QuestId] = 1
                end
              end
            end
          end
        end
      end
    end
  end)
end

function M:OpenReward()
  if self:SetRewardParams() then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:LoadUINew("ActivityRewardNoraml", self.Params)
  end
end

function M:GetQuestTextProgress(QuestData)
  if not QuestData then
    return nil
  end
  return "(" .. tostring(QuestData.Progress) .. "/" .. tostring(QuestData.Target) .. ")"
end

local function ApplyRewardStateToItem(DataModel, Item, EventId, QuestId, CommonQuestActivity)
  local QuestData = QuestId and CommonQuestActivity[QuestId]
  if not QuestData then
    return
  end
  local RewardState = DataModel:GetRewardItemState(EventId, QuestId)
  Item.CanReceive = RewardState.CanReceive
  Item.RewardsGot = RewardState.RewardsGot
  Item.InProgress = RewardState.InProgress
  Item.TextProgress = DataModel:GetQuestTextProgress(QuestData)
  if Item.Rewards then
    for _, Reward in pairs(Item.Rewards) do
      Reward.bHasGot = Item.RewardsGot
    end
  end
end

function M:RefreshConfigData(EventId, Widget)
  if not (Widget and Widget.ConfigData) or not Widget.ConfigData.Datas then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
  if not CommonQuestActivity then
    return
  end
  for _, Data in pairs(Widget.ConfigData.Datas) do
    for _, Item in pairs(Data.Items) do
      local QuestId = Item.ReceiveParm and Item.ReceiveParm.QuestId
      if QuestId then
        ApplyRewardStateToItem(self, Item, EventId, QuestId, CommonQuestActivity)
      end
    end
    if Data.ReceiveAllParam then
      Data.NowNum, Data.NumMax = self:GetTabQuestProgress(Data.ReceiveAllParam.QuestPhaseId)
    end
  end
end

function M:RefreshVisibleRewardListUI(Widget)
  if not Widget or not Widget.List_Item then
    return false
  end
  local HaveRewardToGet = false
  for i = 0, Widget.List_Item:GetNumItems() - 1 do
    local Item = Widget.List_Item:GetItemAt(i)
    if Item and not Item.IsEmpty and Item.ConfigData then
      local ConfigData = Item.ConfigData
      if ConfigData.CanReceive and not ConfigData.RewardsGot then
        HaveRewardToGet = true
      end
      if Item.SelfWidget then
        Item.SelfWidget:RefreshBtn(ConfigData.RewardsGot, ConfigData.CanReceive)
      end
    end
  end
  return HaveRewardToGet
end

function M:GetAllRewards(ReceiveAllParam)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local EventId = ReceiveAllParam.EventId
  local Widget = ReceiveAllParam.SelfWidget
  
  local function Callback(ErrCode, Reward)
    if not ErrorCode:Check(ErrCode) then
      return
    end
    M:RefreshConfigData(EventId, Widget)
    local HaveRewardToGet = M:RefreshVisibleRewardListUI(Widget)
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, function()
    end, Widget, true)
    Widget:RefreshButton(HaveRewardToGet)
    Widget:RefreshReddotInfo()
    Widget:RefreshItems()
  end
  
  Avatar:CommonQuestActivityGetPhaseReward(Callback, EventId, ReceiveAllParam.QuestPhaseId)
end

function M:GetRewards(Content)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ReceiveParm = Content.ConfigData.ReceiveParm
  local EventId = ReceiveParm.EventId
  local Widget = Content.Owner
  
  local function Callback(ErrCode, Rewards)
    if not ErrorCode:Check(ErrCode) then
      return
    end
    M:RefreshConfigData(EventId, Widget)
    local HaveRewardToGet = M:RefreshVisibleRewardListUI(Widget)
    Content.SelfWidget:RefreshReddotInfo()
    Widget:RefreshButton(HaveRewardToGet)
    Widget:RefreshItems()
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      if Widget and Widget.List_Item then
        Widget.List_Item:SetFocus()
      end
    end, Content.SelfWidget, true)
  end
  
  Avatar:CommonQuestActivityGetReward(Callback, EventId, ReceiveParm.QuestId)
end

function M:GetTabQuestProgress(TabId)
  local PhaseConfig = DataMgr.CommonQuestPhase[TabId]
  if nil == PhaseConfig then
    return 0, 0
  end
  local CompletedCount, TotalCount = EastSeasonQuestUtils:GetQuestPhaseInfo(PhaseConfig.EventId, TabId)
  return CompletedCount or 0, TotalCount or 0
end

function M:GetRewardItemState(EventId, QuestId)
  local Avatar = GWorld:GetAvatar()
  local CommonQuestActivity = Avatar and Avatar.CommonQuestActivity
  local QuestData = CommonQuestActivity and CommonQuestActivity[EventId] and CommonQuestActivity[EventId][QuestId]
  local RewardState = {
    CanReceive = false,
    RewardsGot = false,
    InProgress = true
  }
  if nil == QuestData then
    return RewardState
  end
  local IsRewardCanReceive = QuestData:IsComplete()
  local IsRewardHasGot = QuestData.RewardsGot
  RewardState.CanReceive = IsRewardCanReceive and not IsRewardHasGot
  RewardState.RewardsGot = IsRewardHasGot
  RewardState.InProgress = not IsRewardCanReceive and not IsRewardHasGot
  return RewardState
end

function M:BuildRewardItemsByTab(TabId, EventId)
  local Items = {}
  local QuestPhaseId = TabId
  local QuestIds = DataMgr.QuestPhaseId2QuestId[QuestPhaseId]
  for _, QuestId in pairs(QuestIds) do
    local QuestDetail = DataMgr.CommonQuestDetail[QuestId]
    local Avatar = GWorld:GetAvatar()
    local QuestData = Avatar and Avatar.CommonQuestActivity[EventId] and Avatar.CommonQuestActivity[EventId][QuestId]
    local RewardState = self:GetRewardItemState(EventId, QuestId)
    local Item = {
      Text = GText("UI_GameEvent_ClaimReward"),
      ItemId = QuestId,
      Type = TabId,
      ReddotName = self.REDDOT_NODE_LIMIT_REWARD,
      CanReceive = RewardState.CanReceive,
      InProgress = RewardState.InProgress,
      RewardsGot = RewardState.RewardsGot,
      Rewards = {},
      NotreachText = "UI_GameEvent_ToBeFinished",
      Hint = QuestDetail.StarterQuestDes,
      ReceiveCallBack = self.GetRewards,
      ReceiveParm = {EventId = EventId, QuestId = QuestId},
      LeftAligned = true,
      TextProgress = self:GetQuestTextProgress(QuestData),
      HideProgressAfterGot = true
    }
    local Rewards = {}
    for _, RewardId in pairs(QuestDetail.QuestReward) do
      local RewardInfo = DataMgr.Reward[RewardId]
      if RewardInfo then
        local Ids = RewardInfo.Id or {}
        local RewardCount = RewardInfo.Count or {}
        local TableName = RewardInfo.Type or {}
        for i = 1, #Ids do
          local ItemId = Ids[i]
          local Count = RewardUtils:GetCount(RewardCount[i])
          local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
          table.insert(Rewards, {
            ItemType = TableName[i],
            ItemId = ItemId,
            Count = Count,
            Rarity = Rarity
          })
        end
      end
    end
    Item.Rewards = Rewards
    table.insert(Items, Item)
  end
  table.sort(Items, function(a, b)
    return a.ItemId < b.ItemId
  end)
  return Items
end

function M:SetRewardParams()
  local SeasonConfig = self:GetSeasonConfigData()
  if not SeasonConfig then
    return false
  end
  local EventId = SeasonConfig.SeasonEventId
  local EndTime
  if EventId and DataMgr.EventMain[EventId] then
    EndTime = DataMgr.EventMain[EventId].EventEndTime
  end
  local RemainTimeDict, _ = UIUtils.GetLeftTimeStrStyle2(EndTime)
  self.Params = {}
  local ConfigData = {
    IsPacking = false,
    TopText = "UI_Play_TreasureHunt_Quest",
    TimeText = "UI_GameEvent_EventTimeRemain",
    IsExpired = false,
    HasTab = true,
    Type = -1,
    ReddotName = self.REDDOT_NODE_LIMIT_REWARD,
    RemainTimeDict = RemainTimeDict,
    InSoundPath = "event:/ui/armory/open",
    TabInfo = {},
    Datas = {}
  }
  local TabInfo = {}
  for _, QuestPhaseId in pairs(SeasonConfig.SeasonLimitTaskId) do
    local QuestPhaseName = DataMgr.CommonQuestPhase[QuestPhaseId].QuestPhaseName or "empty"
    local TabId = QuestPhaseId
    local TabItemInfo = {
      Title = QuestPhaseName,
      ReddotName = self.REDDOT_NODE_LIMIT_REWARD,
      Type = TabId,
      IsShowIcon = false
    }
    table.insert(TabInfo, TabItemInfo)
    local NowNum, NumMax = self:GetTabQuestProgress(TabId)
    local RewardData = {
      ShowIcon = false,
      NowNum = NowNum,
      NumMax = NumMax,
      Type = TabId,
      ReceiveButtonText = GText("UI_GameEvent_ClaimAll"),
      ReceiveAllCallBack = self.GetAllRewards,
      ReceiveAllParam = {EventId = EventId, QuestPhaseId = QuestPhaseId},
      SortType = 1,
      Text_Total = GText("UI_TempleEvent_RewardProgress"),
      Items = self:BuildRewardItemsByTab(TabId, EventId)
    }
    ConfigData.Datas[TabId] = RewardData
  end
  ConfigData.TabInfo = TabInfo
  ConfigData.Type = ConfigData.TabInfo[1].Type
  
  function ConfigData.RefreshPanleCallBack(Widget)
    if Widget then
      self:RefreshConfigData(EventId, Widget)
      Widget:RefreshItems()
    end
  end
  
  self.Params.ConfigData = ConfigData
  return true
end

return M
