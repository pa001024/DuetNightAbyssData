local M = Class("BluePrints.Common.MVC.Model")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local EastSeasonQuestUtils = require("BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
  self.ChoosePetList = {}
  self.ChoosePetContentMap = {}
  self.PlayerRumorContentMap = {}
  self.TodayPlayerList = {}
end

function M:InitCurrentStatus()
  if CommonUtils.IsRaceLotterySelectPlayerTime() then
    self.CurActivityStage = RacingActivityConst.RacingActivityStage.SelectPlayer
  elseif CommonUtils.IsRaceLotteryGetRewardTime() then
    self.CurActivityStage = RacingActivityConst.RacingActivityStage.GetReward
  else
    self.CurActivityStage = RacingActivityConst.RacingActivityStage.WaitingResult
  end
end

function M:CheckActivityIsUnlock(EventId)
  local EventCfg = EventId and DataMgr.EventPortal and DataMgr.EventPortal[EventId]
  if not EventCfg then
    return false
  end
  local JumpUnlockCondition = EventCfg.JumpUnlockCondition
  if JumpUnlockCondition and ConditionUtils and ConditionUtils.CheckCondition and not ConditionUtils.CheckCondition(self._Avatar, JumpUnlockCondition) then
    return false
  end
  return true
end

function M:IsChoosePetEnough()
  return 6 == self:GetChoosePetListCount()
end

function M:IsServerChoosePetEnough()
  return 6 == self:GetServerChoosePetListCount()
end

function M:GetTodayPlayerList()
  return self.TodayPlayerList or {}
end

function M:BuildRumorContentByRumorId(RumorId)
  if not RumorId then
    return nil
  end
  local RumorInfo = DataMgr.RaceLotteryBuffMap[RumorId]
  if not RumorInfo then
    return nil
  end
  return {
    BuffMap = RumorInfo.BuffMap,
    BuffSymbol = RumorInfo.PValueEffect > 1 and "+" or "-",
    MaxStake = RumorInfo.MaxStake,
    BuffCount = #RumorInfo.BuffMap
  }
end

function M:RefreshRumorContentListByPlayerId(PlayerId)
  if not PlayerId then
    return nil
  end
  self.PlayerRumorContentMap = self.PlayerRumorContentMap or {}
  self.PlayerRumorContentMap[PlayerId] = {}
  local RumorIdList = self:GetRumorIdListByPlayerId(PlayerId)
  if not RumorIdList then
    return self.PlayerRumorContentMap[PlayerId]
  end
  for _, RumorId in pairs(RumorIdList) do
    local RumorContent = self:BuildRumorContentByRumorId(RumorId)
    if RumorContent then
      table.insert(self.PlayerRumorContentMap[PlayerId], RumorContent)
    end
  end
  return self.PlayerRumorContentMap[PlayerId]
end

function M:GetRumorContentListByPlayerId(PlayerId)
  if not PlayerId then
    return {}
  end
  self.PlayerRumorContentMap = self.PlayerRumorContentMap or {}
  if not self.PlayerRumorContentMap[PlayerId] then
    self:RefreshRumorContentListByPlayerId(PlayerId)
  end
  return self.PlayerRumorContentMap[PlayerId] or {}
end

function M:GetRumorContentByPlayerIdAndIndex(PlayerId, Index)
  local RumorContentList = self:GetRumorContentListByPlayerId(PlayerId)
  return RumorContentList[Index]
end

function M:GetServerChoosePetList()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.RaceLotteryInfo.RaceLotteryPlayerList or {}
  end
end

function M:GetChoosePetList()
  return self.ChoosePetList or {}
end

function M:GetChoosePetContentMap()
  return self.ChoosePetContentMap or {}
end

function M:GetChoosePetListCount()
  local Count = 0
  if not self.ChoosePetList then
    return Count
  end
  for _, _ in pairs(self.ChoosePetList) do
    Count = Count + 1
  end
  return Count
end

function M:GetServerChoosePetListCount()
  local Count = 0
  for _, _ in pairs(self:GetServerChoosePetList()) do
    Count = Count + 1
  end
  return Count
end

function M:IsChoosePetById(ChoosedPlayerId)
  if not ChoosedPlayerId or not self.ChoosePetList then
    return false
  end
  return self.ChoosePetList[ChoosedPlayerId] == true
end

function M:GetRumorInquireCount()
  return self:GetMaxRumorInquireCount() - self:GetCurrentRumorInquireCount() + 1
end

function M:GetCurrentRumorInquireCount()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local RaceLotteryRumorList = Avatar.RaceLotteryInfo.RaceLotteryRumorList
    local Count = 0
    for PlayerId, RumorList in pairs(RaceLotteryRumorList) do
      if RumorList then
        for _, Rumor in pairs(RumorList) do
          Count = Count + 1
        end
      end
    end
    return Count + 1
  end
  return 1
end

function M:GetRumorIdListByPlayerId(PlayerId)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local RaceLotteryRumorList = Avatar.RaceLotteryInfo.RaceLotteryRumorList
    return RaceLotteryRumorList[PlayerId]
  end
  return nil
end

function M:GetRumorIdByPlayerIdAndIndex(PlayerId, Index)
  local RaceLotteryRumorList = self:GetRumorIdListByPlayerId(PlayerId)
  if RaceLotteryRumorList then
    local CurrIndex = 0
    for _, RumorId in pairs(RaceLotteryRumorList) do
      CurrIndex = CurrIndex + 1
      if CurrIndex == Index then
        return RumorId
      end
    end
  end
  return nil
end

function M:GetMaxRumorInquireCount()
  local RaceLotteryRumorFreeData = DataMgr.RaceLotteryRumorFee
  return #RaceLotteryRumorFreeData
end

function M:GetNowBetCount()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.RaceLotteryInfo.RaceLotteryAnteNum or 0
  end
end

function M:GetMaxBetRewardCount()
  return self:GetNowBetCount() * DataMgr.RaceLotteryRewardRate[6].RewardRate
end

function M:GetIsWatched()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.RaceLotteryInfo.RaceLotteryGotReward or false
  end
end

function M:GetAllPlayerInfo()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:RacceLotteryQueryJoinPlayerTotalCostSecond(function(Ret, List)
      if ErrorCode:Check(Ret) then
        self.JoinPlayerRankInfo = List
      end
    end)
  end
end

function M:GetRankByPlayerId(PlayerId)
  if not self.JoinPlayerRankInfo or not self:GetIsWatched() then
    return nil
  end
  for Rank, Info in pairs(self.JoinPlayerRankInfo) do
    if Info.PlayerId == PlayerId then
      return Rank
    end
  end
  return nil
end

function M:GetGuessSuccessPlayerCount()
  local Count = 0
  if not self.JoinPlayerRankInfo then
    return Count
  end
  local ChoosePetList = self:GetServerChoosePetList()
  for Index = 1, 6 do
    local PlayerId = ChoosePetList and ChoosePetList[Index]
    if PlayerId then
      local Rank = self:GetRankByPlayerId(PlayerId)
      if Rank <= tonumber(DataMgr.RaceLotteryConstant.ShortListedPlayerNum.ConstantValue) then
        Count = Count + 1
      end
    end
  end
  return Count
end

function M:GetAllRumorInfoByPlayerId(PlayerId)
  local RumorContentList = {}
  if not self.JoinPlayerRankInfo then
    return RumorContentList
  end
  for _, Info in pairs(self.JoinPlayerRankInfo) do
    if Info.PlayerId == PlayerId then
      for _, RumorId in pairs(Info.RumorList) do
        local RumorInfo = DataMgr.RaceLotteryBuffMap[RumorId]
        if RumorInfo then
          table.insert(RumorContentList, {
            BuffMap = RumorInfo.BuffMap,
            BuffSymbol = RumorInfo.PValueEffect > 1 and "+" or "-",
            MaxStake = RumorInfo.MaxStake,
            BuffCount = #RumorInfo.BuffMap
          })
        end
      end
    end
  end
  return RumorContentList
end

function M:GenerateHistoryData()
  local Result = {}
  if not self._Avatar then
    return Result
  end
  local RaceLotteryInfo = self._Avatar.RaceLotteryInfo
  if not RaceLotteryInfo then
    return Result
  end
  local HistoryList = RaceLotteryInfo.RaceLotteryHistoryList:Values()
  for Index = #HistoryList, 1, -1 do
    table.insert(Result, HistoryList[Index])
  end
  return Result
end

function M:InitReddotTree()
  if not ActivityUtils.CheckEventIsOpen(RacingActivityConst.ActivityEventId) or not self:CheckActivityIsUnlock(RacingActivityConst.ActivityEventId) then
    self:ClearReddotTreeData()
    return
  end
  if not ReddotManager.GetTreeNode("Acti_Racing") then
    ReddotManager.AddNodeEx("Acti_Racing")
  end
  self:RefreshRacingOutSiderReddot()
  self:RefreshRacingChoosePetReddot()
  self:InitWatchAndGetRewardReddot()
  if self.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward or self.CurActivityStage == RacingActivityConst.RacingActivityStage.WaitingResult then
    ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotChoosePetKey, false)
  end
end

function M:ClearReddotTreeData()
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotRewardKey, true)
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotChoosePetKey, true)
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotWatchAndGetRewardKey, true)
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotActivityKey, true)
end

function M:RefreshRacingOutSiderReddot()
  self:RefreshReddotInfo(true)
end

function M:RefreshRacingChoosePetReddot()
  local ChoosePetReddotDetails = ReddotManager.GetLeafNodeCacheDetail(RacingActivityConst.ReddotChoosePetKey)
  local NowTime = TimeUtils.NowTime()
  if ChoosePetReddotDetails and (not ChoosePetReddotDetails.PreTime or 0 ~= TimeUtils.GetIntervalDay(ChoosePetReddotDetails.PreTime, NowTime)) then
    DebugPrint("RaceLotteryComp OnDailyEightThirtyReached:RefreshRacingChoosePetReddot", ChoosePetReddotDetails.PreTime, NowTime)
    ChoosePetReddotDetails.PreTime = NowTime
    ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotChoosePetKey, false)
    ReddotManager.IncreaseLeafNodeCount(RacingActivityConst.ReddotChoosePetKey)
    local ChoosePetReddot = ReddotManager.GetTreeNode(RacingActivityConst.ReddotWatchAndGetRewardKey)
    if ChoosePetReddot then
      ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotWatchAndGetRewardKey, true)
    end
  end
end

function M:InitWatchAndGetRewardReddot()
  local WatchAndGetRewardReddot = ReddotManager.GetTreeNode(RacingActivityConst.ReddotWatchAndGetRewardKey)
  if WatchAndGetRewardReddot then
    DebugPrint("RaceLotteryComp OnDailyEightThirtyReached:InitWatchAndGetRewardReddot", self:GetIsWatched(), self:IsServerChoosePetEnough(), WatchAndGetRewardReddot.Count)
    if self.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward and not self:GetIsWatched() and self:IsServerChoosePetEnough() and 0 == WatchAndGetRewardReddot.Count then
      ReddotManager.IncreaseLeafNodeCount(RacingActivityConst.ReddotWatchAndGetRewardKey)
    end
  end
end

function M:SetRacingChoosePetReddotCountOne()
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotChoosePetKey, false)
  ReddotManager.IncreaseLeafNodeCount(RacingActivityConst.ReddotChoosePetKey)
  local ChoosePetReddotDetails = ReddotManager.GetLeafNodeCacheDetail(RacingActivityConst.ReddotChoosePetKey)
  local NowTime = TimeUtils.NowTime()
  DebugPrint("RaceLotteryComp OnDailyEightThirtyReached:SetRacingChoosePetReddotCountOne", NowTime)
  if ChoosePetReddotDetails then
    ChoosePetReddotDetails.PreTime = NowTime
  end
end

function M:RefreshWatchAndGetrewardReddot()
  local WatchAndGetRewardReddot = ReddotManager.GetTreeNode(RacingActivityConst.ReddotWatchAndGetRewardKey)
  if WatchAndGetRewardReddot then
    DebugPrint("RaceLotteryComp OnDailyEightThirtyReached:RefreshWatchAndGetrewardReddot", self:GetIsWatched(), self:IsServerChoosePetEnough())
    if not self:GetIsWatched() and self:IsServerChoosePetEnough() and 0 == WatchAndGetRewardReddot.Count then
      ReddotManager.IncreaseLeafNodeCount(RacingActivityConst.ReddotWatchAndGetRewardKey)
    end
  end
end

function M:OpenTaskReward()
  self:RefreshReddotInfo()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local Params = self:MakeRewardData(RacingActivityConst.ActivityEventId)
  UIManager:LoadUINew("ActivityRacingTaskReward", Params)
end

function M:MakeRewardData(EventId)
  local Avatar = self:GetAvatar()
  local Params = {}
  Params.ConfigData = {}
  Params.ConfigData.TabInfo = {}
  Params.ConfigData.Items = {}
  Params.ConfigData.HasTab = true
  Params.ConfigData.Datas = {}
  Params.ConfigData.InSoundPath = "event:/ui/armory/open"
  Params.ConfigData.OutSoundPath = "event:/ui/armory/open"
  
  function Params.ConfigData.RefreshPanleCallBack(Widget)
    if Widget then
      self:RefreshConfigData(RacingActivityConst.ActivityEventId, Widget)
      Widget:RefreshItems()
    end
  end
  
  local SortedInfo = {}
  for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
    if PhaseConfig.EventId == EventId then
      table.insert(SortedInfo, PhaseConfig)
    end
  end
  table.sort(SortedInfo, function(a, b)
    return a.Index < b.Index
  end)
  local EndTime
  if DataMgr.EventMain[RacingActivityConst.ActivityEventId] then
    EndTime = DataMgr.EventMain[RacingActivityConst.ActivityEventId].EventEndTime
  end
  local RemainTimeDict, Count = UIUtils.GetLeftTimeStrStyle2(EndTime)
  Params.ConfigData.RemainTimeDict = RemainTimeDict
  Params.ConfigData.IsExpired = 0 == Count
  for _, PhaseConfig in pairs(SortedInfo) do
    local QuestPhaseId = PhaseConfig.QuestPhaseId
    local TabIndex = 1
    if PhaseConfig.EventId == EventId then
      local TabItem = {}
      TabItem.Index = TabIndex
      TabIndex = TabIndex + 1
      TabItem.Type = QuestPhaseId
      TabItem.Title = PhaseConfig.QuestPhaseName
      TabItem.ReddotName = RacingActivityConst.ReddotRewardKey
      TabItem.IconPath = PhaseConfig.SplineBP
      TabItem.IsShowIcon = true
      DebugPrint("@@@RacingOutsider MakeRewardData TabItem.Title", EventId, TabIndex, TabItem.Title)
      table.insert(Params.ConfigData.TabInfo, TabItem)
      local RewardData = {}
      RewardData.ShowIcon = false
      RewardData.NowNum, RewardData.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, QuestPhaseId)
      RewardData.ReceiveAllCallBack = self.GetAllRewards
      RewardData.ReceiveAllParam = {}
      RewardData.ReceiveAllParam.EventId = EventId
      RewardData.ReceiveAllParam.QuestPhaseId = QuestPhaseId
      RewardData.Type = QuestPhaseId
      RewardData.SortType = 1
      RewardData.Text_Total = string.format(GText("Abyss_RewardList_Title"))
      RewardData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
      local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
      if not CommonQuestActivity then
        DebugPrint("Avatar.CommonQuestActivity is nil, EvantId: ", EventId)
        return
      end
      local Items = {}
      local HasDailyQuest = false
      for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
        if Config.QuestPhaseId == QuestPhaseId then
          local Item = {}
          Item.ItemId = QuestId
          if CommonQuestActivity[QuestId] then
            Item.CanReceive = CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and false == CommonQuestActivity[QuestId].RewardsGot
          end
          Item.Type = QuestPhaseId
          if CommonQuestActivity[QuestId] then
            Item.RewardsGot = CommonQuestActivity[QuestId].RewardsGot
          end
          Item.NotreachText = GText("UI_Archive_CollectionInProgress")
          Item.Hint = GText(Config.StarterQuestDes)
          Item.ReddotName = RacingActivityConst.ReddotRewardKey
          Item.ReceiveButtonText = GText("UI_Archive_CollectionClaim")
          Item.Num = Config.Target
          if CommonQuestActivity[QuestId] then
            Item.TextProgress = "(" .. tostring(CommonQuestActivity[QuestId].Progress) .. "/" .. tostring(CommonQuestActivity[QuestId].Target) .. ")"
          end
          Item.HideProgressAfterGot = true
          Item.ReceiveCallBack = self.GetReward
          Item.ReceiveParm = {}
          Item.ReceiveParm.QuestId = QuestId
          Item.ReceiveParm.EventId = EventId
          if 2 == Config.QuestType then
            HasDailyQuest = true
          end
          local Rewards = {}
          for _, RewardItemId in ipairs(Config.QuestReward) do
            local RewardInfo = DataMgr.Reward[RewardItemId]
            if RewardInfo then
              local Ids = RewardInfo.Id or {}
              local RewardCount = RewardInfo.Count or {}
              local TableName = RewardInfo.Type or {}
              for i = 1, #Ids do
                local ItemId = Ids[i]
                local Count = RewardUtils:GetCount(RewardCount[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                local ItemType = TableName[i]
                local RewardContent = {
                  ItemType = ItemType,
                  ItemId = ItemId,
                  Count = Count,
                  Rarity = Rarity
                }
                table.insert(Rewards, RewardContent)
              end
            end
          end
          Item.Rewards = Rewards
          Item.LeftAligned = true
          table.insert(Items, Item)
        end
      end
      table.sort(Items, function(a, b)
        return a.Num < b.Num
      end)
      RewardData.Items = Items
      Params.ConfigData.Datas[QuestPhaseId] = RewardData
      Params.ConfigData.Datas[QuestPhaseId].HasDailyQuest = true
      if HasDailyQuest then
        function Params.ConfigData.DailyRefreshFunc(Widget, RefreshParam)
          if Widget then
            self:RefreshConfigData(EventId, Widget)
            
            self:RefreshReddotInfo(true)
            Widget:RefreshDaily()
          end
        end
        
        Params.ConfigData.Datas[QuestPhaseId].NeedDailyRefresh = true
      end
    end
  end
  Params.ConfigData.Type = Params.ConfigData.TabInfo[1].Type
  Params.ConfigData.ReddotName = RacingActivityConst.ReddotRewardKey
  return Params
end

function M:RefreshReddotInfo(ClearCache)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  local AutoRacingEventId = RacingActivityConst.ActivityEventId
  local CommonQuestActivity = Avatar.CommonQuestActivity[AutoRacingEventId]
  if not CommonQuestActivity then
    return
  end
  pcall(function()
    local Node = ReddotManager.GetTreeNode(RacingActivityConst.ReddotRewardKey)
    if not Node then
      ReddotManager.AddNodeEx(RacingActivityConst.ReddotRewardKey)
    end
    if ClearCache then
      ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotRewardKey)
      local NodeCache = ReddotManager._GetLeafNodeCache(RacingActivityConst.ReddotRewardKey)
      NodeCache.Detail = {}
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(RacingActivityConst.ReddotRewardKey)
    for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
      if PhaseConfig.EventId == AutoRacingEventId then
        for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
          if Config.QuestPhaseId == QuestPhaseId then
            local QuestData = CommonQuestActivity[QuestId]
            if not (QuestData and QuestData.Progress) or not QuestData.Target then
            else
              local CanReceive = QuestData.Progress >= QuestData.Target
              if CanReceive and not QuestData.RewardsGot then
                if not CacheDetail[QuestPhaseId] then
                  CacheDetail[QuestPhaseId] = {}
                end
                if not CacheDetail[QuestPhaseId][QuestId] then
                  ReddotManager.IncreaseLeafNodeCount(RacingActivityConst.ReddotRewardKey)
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

function M:RefreshConfigData(EventId, Widget)
  if Widget.ConfigData.Datas then
    for _, Data in pairs(Widget.ConfigData.Datas) do
      local Avatar = self:GetAvatar()
      if not Avatar then
        return
      end
      local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
      if not CommonQuestActivity then
        DebugPrint("Avatar.CommonQuestActivity is nil, EvantId: ", EventId)
        return
      end
      for _, Item in pairs(Data.Items) do
        local QuestId = Item.ItemId
        if QuestId and CommonQuestActivity[QuestId] then
          Item.CanReceive = CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and CommonQuestActivity[QuestId].RewardsGot == false
          Item.RewardsGot = CommonQuestActivity[QuestId].RewardsGot
          Item.TextProgress = "(" .. tostring(CommonQuestActivity[QuestId].Progress) .. "/" .. tostring(CommonQuestActivity[QuestId].Target) .. ")"
        end
      end
      Data.NowNum, Data.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, Data.ReceiveAllParam.QuestPhaseId)
    end
  end
end

function M:GetAllRewards(ReceiveAllParm)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function CallBack(Ret, Reward)
      DebugPrint("@@@RacingOutsider GetAllRewards CallBack")
      
      local HaveReWardToGet = false
      local CommonQuestActivity = Avatar.CommonQuestActivity[ReceiveAllParm.EventId]
      for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
        local Item = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
        if Item and not Item.IsEmpty and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId] then
          local CanReceive = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
          local IsGot = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
          if CanReceive and not IsGot then
            HaveReWardToGet = true
          end
          DebugPrint("@@@RacingOutsider GetAllRewards ,Type,ItemId,CanReceive,IsGot", Item.ConfigData.Type, Item.ConfigData.ItemId, CanReceive, IsGot)
          Item.ConfigData.CanReceive = CanReceive
          Item.ConfigData.RewardsGot = IsGot
          if Item.ConfigData.Rewards then
            for _, Reward in pairs(Item.ConfigData.Rewards) do
              Reward.bHasGot = Item.ConfigData.RewardsGot
            end
          end
          if Item.SelfWidget then
            Item.SelfWidget:RefreshBtn(IsGot)
          end
        end
      end
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, function()
        ReceiveAllParm.SelfWidget:ScrollToSelectTab()
      end, ReceiveAllParm.SelfWidget)
      ReceiveAllParm.SelfWidget:RefreshButton(HaveReWardToGet)
      DebugPrint("@@@RacingOutsider GetAllRewards HaveReWardToGet", HaveReWardToGet)
      ReceiveAllParm.SelfWidget:RefreshReddotInfo()
      ReceiveAllParm.SelfWidget:RefreshItems()
    end
    
    Avatar:CommonQuestActivityGetPhaseReward(CallBack, ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId)
  end
end

function M:GetReward(Content)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function Callback(ErrCode, Rewards)
      if not ErrorCode:Check(ErrCode) then
        DebugPrint("@@@RacingOutsider ErrCode is ", ErrCode)
        
        return
      end
      DebugPrint("@@@RacingOutsider GetReward CallBack")
      local HaveReWardToGet = false
      local CommonQuestActivity = Avatar.CommonQuestActivity[Content.ConfigData.ReceiveParm.EventId]
      for i = 0, Content.Owner.List_Item:GetNumItems() - 1 do
        local Item = Content.Owner.List_Item:GetItemAt(i)
        if Item and not Item.IsEmpty and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId] then
          local CanReceive = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
          local IsGot = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
          if CanReceive and not IsGot then
            HaveReWardToGet = true
          end
          DebugPrint("@@@RacingOutsider GetReward ,Type, ItemId, CanReceive,IsGot", Item.ConfigData.Type, Item.ConfigData.ItemId, CanReceive, IsGot)
          Item.ConfigData.CanReceive = CanReceive
          Item.ConfigData.RewardsGot = IsGot
          if Item.SelfWidget then
            Item.SelfWidget:RefreshBtn(IsGot)
          end
          if Item.ConfigData.Rewards then
            for _, Reward in pairs(Item.ConfigData.Rewards) do
              Reward.bHasGot = Item.ConfigData.RewardsGot
            end
          end
        end
      end
      Content.SelfWidget:RefreshReddotInfo()
      Content.Owner:RefreshButton(HaveReWardToGet)
      Content.SelfWidget:RefreshItems()
      DebugPrint("@@@RacingOutsider GetReward HaveReWardToGet", HaveReWardToGet)
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
        Content.Owner.List_Item:SetFocus()
      end, Content.SelfWidget)
    end
    
    Avatar:CommonQuestActivityGetReward(Callback, Content.ConfigData.ReceiveParm.EventId, Content.ConfigData.ReceiveParm.QuestId)
  end
end

function M:Destory()
  M.Super.Destory(self)
end

return M
