require("UnLua")
local EMCache = require("EMCache.EMCache")
local SoloTreasureDataModel = {}

function SoloTreasureDataModel:GetStoryLevelDataByEventId(EventId)
  if not EventId then
    DebugPrint(ErrorTag, "------------[GetStoryLevelDataByEventId]EventId is nil------------")
    return
  end
  local EventTbl = DataMgr.TreasureHuntEvent
  local Result = {}
  if EventTbl then
    local EventStoryDungeonIdList = EventTbl[EventId].EventStoryDungeon
    if EventStoryDungeonIdList then
      for _, EventStoryDungeonId in ipairs(EventStoryDungeonIdList) do
        local EventStoryData = DataMgr.TreasureHuntStoryDungeon[EventStoryDungeonId]
        if EventStoryData then
          table.insert(Result, EventStoryData)
        end
      end
    else
      DebugPrint("----------- [SoloTreasureDataModel] EventStoryDungeonIdList table is nil-----------")
    end
  else
    DebugPrint("----------- [SoloTreasureDataModel] TreasureHuntEvent table is nil-----------")
  end
  return Result
end

function SoloTreasureDataModel:GetRepeatLevelDataByEventId(EventId)
  if not EventId then
    DebugPrint(ErrorTag, "------------ [SoloTreasureDataModel] EventId is nil ------------")
    return
  end
  local EventTbl = DataMgr.TreasureHuntEvent
  local Result = {}
  if EventTbl then
    local EventRepeatDungeonIdList = EventTbl[EventId].EventRepeatDungeon
    if EventRepeatDungeonIdList then
      for _, EventRepeatDungeonId in ipairs(EventRepeatDungeonIdList) do
        local EventRepeatData = DataMgr.TreasureHuntRepeatDungeon[EventRepeatDungeonId]
        if EventRepeatData then
          table.insert(Result, EventRepeatData)
        end
      end
    else
      DebugPrint("----------- [SoloTreasureDataModel] EventRepeatDungeonIdList table is nil -----------")
    end
  else
    DebugPrint("----------- [SoloTreasureDataModel] TreasureHuntEvent table is nil -----------")
  end
  return Result
end

function SoloTreasureDataModel:GetTreasureHuntProgressData(EventId)
  if not EventId then
    DebugPrint(ErrorTag, "------------ [SoloTreasureDataModel] EventId is nil ------------")
    return
  end
  local EventTbl = DataMgr.TreasureHuntEvent
  local Result = {}
  if EventTbl then
    local EventProgressIdList = EventTbl[EventId].EventProgress
    if EventProgressIdList then
      for _, EventProgressId in ipairs(EventProgressIdList) do
        local EventProgressData = DataMgr.TreasureHuntProgress[EventProgressId]
        if EventProgressData then
          table.insert(Result, EventProgressData)
        end
      end
    else
      DebugPrint(ErrorTag, "----------- [SoloTreasureDataModel] EventProgressIdList table is nil -----------")
    end
  else
    DebugPrint(ErrorTag, "----------- [SoloTreasureDataModel] TreasureHuntEvent table is nil -----------")
  end
  return Result
end

function SoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId)
  local SoloTreasureTbl = DataMgr.SoloTreasure
  if not SoloTreasureTbl or not DungeonId then
    return nil
  end
  local row = SoloTreasureTbl[DungeonId]
  if row then
    return row.GameTotalTime
  end
  DebugPrint(ErrorTag, "----------- [SoloTreasureDataModel] 未找到 DungeonId = " .. DungeonId .. " 对应行 -----------")
  return nil
end

function SoloTreasureDataModel:GetEventId()
  local EventId = 103014
  return EventId
end

function SoloTreasureDataModel:GetUserCurrentScore(EventId)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self.Avatar = Avatar
  end
  local TreasureHunt = Avatar.TreasureHunts[EventId]
  local Score = 0
  if TreasureHunt then
    local Score = TreasureHunt:GetScore()
    return Score
  else
    DebugPrint(ErrorTag, "---------- [SoloTreasureDataModel]  请求TreasureHunt数据失败 -----------")
    return 0
  end
end

function SoloTreasureDataModel:GetPermanentEventTime(EventId)
  local PermanenEventTime
  if EventId and DataMgr.EventMain[EventId] and DataMgr.EventMain[EventId].PermanenEventTime then
    PermanenEventTime = DataMgr.EventMain[EventId].PermanenEventTime:GetTime()
  end
  if PermanenEventTime then
    return PermanenEventTime
  end
  DebugPrint(ErrorTag, "---------- [SoloTreasureDataModel] 获取PermanenEventTime数据失败 -----------")
  return nil
end

function SoloTreasureDataModel:IsEventPermanent(EventId)
  local PermanenEventTime = self:GetPermanentEventTime(EventId)
  if not PermanenEventTime then
    return false
  end
  local Now = TimeUtils.NowTime()
  return PermanenEventTime <= Now
end

function SoloTreasureDataModel:GetEventEndTime(EventId)
  local EventEndTime
  if EventId and DataMgr.EventMain[EventId] and DataMgr.EventMain[EventId].EventEndTime then
    EventEndTime = DataMgr.EventMain[EventId].EventEndTime:GetTime()
  end
  if EventEndTime then
    return EventEndTime
  end
  DebugPrint(ErrorTag, "---------- [SoloTreasureDataModel] 获取EventEndTime数据失败 -----------")
  return nil
end

function SoloTreasureDataModel:ActivityIsUnlock(EventId)
  local EventCfg = EventId and DataMgr.EventPortal and DataMgr.EventPortal[EventId]
  if not EventCfg then
    return false
  end
  local JumpUnlockCondition = EventCfg.JumpUnlockCondition
  if JumpUnlockCondition and ConditionUtils and ConditionUtils.CheckCondition and not ConditionUtils.CheckCondition(self.Avatar, JumpUnlockCondition) then
    return false
  end
  return true
end

function SoloTreasureDataModel:GetCurCoinAmount(CoinId)
  local CoinNum = self.Avatar and self.Avatar.Resources and self.Avatar.Resources[CoinId] and self.Avatar.Resources[CoinId].Count or 0
  return CoinNum
end

function SoloTreasureDataModel:GetUserCurrentProgress(UserCurScore, TreasureHuntProgressData)
  local Result = {
    CurStageIndex = 1,
    TotalStageCount = 0,
    CurRow = nil,
    UserCurProgressId = nil,
    BoardState = 1,
    NextNeedScore = 0,
    CurScore = tonumber(UserCurScore) or 0,
    ProgressCondition = 0,
    IsConditionPassed = false
  }
  if not (UserCurScore and TreasureHuntProgressData) or 0 == #TreasureHuntProgressData then
    return
  end
  Result.TotalStageCount = #TreasureHuntProgressData
  local ScoreStageIndex = Result.TotalStageCount
  for Index, Row in ipairs(TreasureHuntProgressData) do
    local NextScore = tonumber(Row.NextProgressScore) or 0
    if NextScore > Result.CurScore then
      ScoreStageIndex = Index
      break
    end
  end
  local CondStageIndex = 1
  for Index, Row in ipairs(TreasureHuntProgressData) do
    local CondId = tonumber(Row.ProgressCondition) or 0
    if not (0 ~= CondId and ConditionUtils.CheckCondition(self.Avatar, CondId)) then
      break
    end
    CondStageIndex = Index
  end
  local CurStageIndex = CondStageIndex
  if ScoreStageIndex < CurStageIndex then
    CurStageIndex = ScoreStageIndex
  end
  Result.CurStageIndex = CurStageIndex
  Result.CurRow = TreasureHuntProgressData[CurStageIndex]
  Result.UserCurProgressId = Result.CurRow and Result.CurRow.EventProgressId or nil
  Result.NextNeedScore = tonumber(Result.CurRow and Result.CurRow.NextProgressScore) or 0
  Result.ProgressCondition = tonumber(Result.CurRow and Result.CurRow.ProgressCondition) or 0
  Result.IsConditionPassed = 0 ~= Result.ProgressCondition and ConditionUtils and ConditionUtils.CheckCondition and ConditionUtils.CheckCondition(self.Avatar, Result.ProgressCondition) or false
  local IsLastStage = Result.CurStageIndex >= Result.TotalStageCount
  if IsLastStage then
    local FinishCondId = DataMgr.GlobalConstant.SoloTreasureAllFinish.ConstantValue
    local IsAllFinished = ConditionUtils and ConditionUtils.CheckCondition and ConditionUtils.CheckCondition(self.Avatar, FinishCondId) or false
    Result.BoardState = IsAllFinished and 4 or 3
  else
    local ScoreEnoughForNext = Result.CurScore >= Result.NextNeedScore
    if not ScoreEnoughForNext then
      Result.BoardState = 1
    else
      local NextRow = TreasureHuntProgressData[Result.CurStageIndex + 1]
      local NextCondId = tonumber(NextRow and NextRow.ProgressCondition) or 0
      local NextCondPass = 0 ~= NextCondId and ConditionUtils and ConditionUtils.CheckCondition and ConditionUtils.CheckCondition(self.Avatar, NextCondId) or false
      Result.BoardState = NextCondPass and 1 or 2
    end
  end
  return Result
end

function SoloTreasureDataModel:IsRepeatLevelUnlocked(Row)
  if not Row then
    return false
  end
  if Row.UnlockDate and TimeUtils.NowTime() < Row.UnlockDate then
    return false
  end
  if Row.UnlockCondition then
    local Ok = ConditionUtils and ConditionUtils.CheckCondition and ConditionUtils.CheckCondition(self.Avatar, Row.UnlockCondition) or false
    if not Ok then
      return false
    end
  end
  return true
end

function SoloTreasureDataModel:IsAnyRepeatLevelUnlocked(EventId)
  local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
  for _, Row in ipairs(Levels) do
    if self:IsRepeatLevelUnlocked(Row) then
      return true
    end
  end
  return false
end

function SoloTreasureDataModel:Init()
  local EventId = self:GetEventId()
  if not EventId then
    return
  end
  self:BindLevelUnlockReddotRefresh()
  local bIsOpen = SoloTreasureDataModel:ActivityIsUnlock(EventId)
  if not bIsOpen then
    return
  end
  self:InitReddotTree()
  self:RefreshAllSoloTreasureNewReddot(EventId)
end

function SoloTreasureDataModel:InitReddotTree()
  if self.bReddotTreeInited then
    return
  end
  self.bReddotTreeInited = true
  ReddotManager.AddNodeEx("Acti_SoloTreasureTab")
end

function SoloTreasureDataModel:GetLevelListDetail(EventId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LevelListView")
  if not Detail then
    return nil
  end
  if not Detail[EventId] then
    Detail[EventId] = {}
  end
  return Detail[EventId]
end

function SoloTreasureDataModel:InitLevelEntryDetailIfNeeded(EventId, LevelCount)
  local EDetail = self:GetLevelListDetail(EventId)
  if not EDetail then
    return
  end
  for i = 1, LevelCount do
    if nil == EDetail[i] then
      EDetail[i] = false
    end
  end
end

function SoloTreasureDataModel:RefreshAllSoloTreasureNewReddot(EventId)
  if not self:IsAnyRepeatLevelUnlocked(EventId) then
    ReddotManager.ClearLeafNodeCount("SoloTreasure_Shop_New")
    ReddotManager.ClearLeafNodeCount("SoloTreasure_LimitReward_New")
    ReddotManager.ClearLeafNodeCount("SoloTreasure_PermanentReward_New")
    ReddotManager.ClearLeafNodeCount("SoloTreasure_LevelListView")
    ReddotManager.ClearLeafNodeCount("Acti_SolotreasureConfirmBtn")
    return
  end
  self:RefreshShopNewReddot(EventId)
  self:RefreshLimitRewardNewReddot(EventId)
  self:RefreshPermanentRewardNewReddot(EventId)
  self:RefreshLevelListNewReddot(EventId)
end

function SoloTreasureDataModel:RefreshShopNewReddot(EventId)
  local Node = "SoloTreasure_Shop_New"
  local bUnlocked = true
  local bRead = self:IsShopEntryRead(EventId)
  ReddotManager.ClearLeafNodeCount(Node)
  if bUnlocked and not bRead then
    ReddotManager.IncreaseLeafNodeCount(Node, 1)
  end
end

function SoloTreasureDataModel:RefreshLimitRewardNewReddot(EventId)
  local Node = "SoloTreasure_LimitReward_New"
  local bUnlocked = not self:IsEventPermanent(EventId)
  local bRead = self:IsLimitRewardEntryRead(EventId)
  ReddotManager.ClearLeafNodeCount(Node)
  if bUnlocked and not bRead then
    ReddotManager.IncreaseLeafNodeCount(Node, 1)
  end
end

function SoloTreasureDataModel:RefreshPermanentRewardNewReddot(EventId)
  local Node = "SoloTreasure_PermanentReward_New"
  local bUnlocked = true
  local bRead = self:IsPermanentRewardEntryRead(EventId)
  ReddotManager.ClearLeafNodeCount(Node)
  if bUnlocked and not bRead then
    ReddotManager.IncreaseLeafNodeCount(Node, 1)
  end
end

function SoloTreasureDataModel:RefreshLevelListNewReddot(EventId)
  local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
  local LevelCount = #Levels
  if LevelCount <= 0 then
    ReddotManager.ClearLeafNodeCount("SoloTreasure_LevelListView")
    return
  end
  self:InitLevelEntryDetailIfNeeded(EventId, LevelCount)
  local UnreadCount = 0
  for Idx = 1, LevelCount do
    local Row = Levels[Idx]
    local bUnlocked = self:IsRepeatLevelUnlocked(Row)
    if bUnlocked then
      local bRead = self:IsLevelEntryRead(EventId, Idx)
      if not bRead then
        UnreadCount = UnreadCount + 1
      end
    end
  end
  ReddotManager.ClearLeafNodeCount("SoloTreasure_LevelListView")
  ReddotManager.ClearLeafNodeCount("Acti_SolotreasureConfirmBtn")
  if UnreadCount > 0 then
    ReddotManager.IncreaseLeafNodeCount("SoloTreasure_LevelListView", UnreadCount)
    ReddotManager.IncreaseLeafNodeCount("Acti_SolotreasureConfirmBtn", UnreadCount)
  end
end

function SoloTreasureDataModel:IsShopEntryRead(EventId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_Shop_New")
  if not Detail then
    return false
  end
  return true == Detail[EventId]
end

function SoloTreasureDataModel:SetShopEntryRead(EventId, bRead)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_Shop_New")
  if not Detail then
    return
  end
  Detail[EventId] = true == bRead
end

function SoloTreasureDataModel:IsLimitRewardEntryRead(EventId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LimitReward_New")
  if not Detail then
    return false
  end
  return true == Detail[EventId]
end

function SoloTreasureDataModel:SetLimitRewardEntryRead(EventId, bRead)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LimitReward_New")
  if not Detail then
    return
  end
  Detail[EventId] = true == bRead
end

function SoloTreasureDataModel:IsPermanentRewardEntryRead(EventId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_PermanentReward_New")
  if not Detail then
    return false
  end
  return true == Detail[EventId]
end

function SoloTreasureDataModel:SetPermanentRewardEntryRead(EventId, bRead)
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_PermanentReward_New")
  if not Detail then
    return
  end
  Detail[EventId] = true == bRead
end

function SoloTreasureDataModel:IsLevelEntryRead(EventId, LevelIndex)
  local EDetail = self:GetLevelListDetail(EventId)
  if not EDetail then
    return false
  end
  return true == EDetail[LevelIndex]
end

function SoloTreasureDataModel:SetLevelEntryRead(EventId, LevelIndex, bRead)
  local EDetail = self:GetLevelListDetail(EventId)
  if not EDetail then
    return
  end
  EDetail[LevelIndex] = true == bRead
end

function SoloTreasureDataModel:MarkShopEntryRead()
  local EventId = self:GetEventId()
  if not EventId then
    return
  end
  self:SetShopEntryRead(EventId, true)
  ReddotManager.ClearLeafNodeCount("SoloTreasure_Shop_New")
end

function SoloTreasureDataModel:MarkLimitRewardEntryRead()
  local EventId = self:GetEventId()
  if not EventId then
    return
  end
  self:SetLimitRewardEntryRead(EventId, true)
  ReddotManager.ClearLeafNodeCount("SoloTreasure_LimitReward_New")
end

function SoloTreasureDataModel:MarkPermanentRewardEntryRead()
  local EventId = self:GetEventId()
  if not EventId then
    return
  end
  self:SetPermanentRewardEntryRead(EventId, true)
  ReddotManager.ClearLeafNodeCount("SoloTreasure_PermanentReward_New")
end

function SoloTreasureDataModel:MarkLevelEntryRead(LevelIndex)
  local EventId = self:GetEventId()
  if not EventId then
    return
  end
  self:SetLevelEntryRead(EventId, LevelIndex, true)
  self:RefreshLevelListNewReddot(EventId)
end

function SoloTreasureDataModel:IsRepeatLevelUnlockCondition(EventId, ConditionId)
  if not EventId or not ConditionId then
    return false
  end
  local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
  for _, Row in ipairs(Levels) do
    local UnlockCondition = tonumber(Row.UnlockCondition)
    if UnlockCondition and UnlockCondition > 0 and UnlockCondition == tonumber(ConditionId) then
      return true
    end
  end
  return false
end

function SoloTreasureDataModel:BindLevelUnlockReddotRefresh()
  if self.bLevelUnlockReddotRefreshBinded then
    return
  end
  self.bLevelUnlockReddotRefreshBinded = true
  EventManager:AddEvent(EventID.ConditionComplete, self, self.RefreshLevelReddotWithConditionUnlock)
end

function SoloTreasureDataModel:RefreshLevelReddotWithConditionUnlock(ConditionId)
  local EventId = self:GetEventId()
  if not EventId then
    return
  end
  local bIsOpen = SoloTreasureDataModel:ActivityIsUnlock(EventId)
  if not bIsOpen then
    return
  end
  if not self:IsRepeatLevelUnlockCondition(EventId, ConditionId) then
    return
  end
  self:RefreshAllSoloTreasureNewReddot(EventId)
end

function SoloTreasureDataModel:UnBindLevelUnlockReddotRefresh()
  if not self.bLevelUnlockReddotRefreshBinded then
    return
  end
  self.bLevelUnlockReddotRefreshBinded = false
  EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

function SoloTreasureDataModel:SoloTreasureDataModelDebugReset(EventId)
  self:DebugResetLevelEntryRead(EventId)
  self:DebugResetUnlockAnimPlayed(EventId)
  self:DebugResetLastForbidden(EventId)
end

function SoloTreasureDataModel:DebugResetLevelEntryRead(EventId)
  EventId = EventId or self:GetEventId()
  if not EventId then
    return
  end
  local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LevelListView")
  if not Detail then
    return
  end
  Detail[EventId] = {}
  self:RefreshLevelListNewReddot(EventId)
end

function SoloTreasureDataModel:DebugResetUnlockAnimPlayed(EventId)
  EventId = EventId or self:GetEventId()
  if not EventId then
    return
  end
  local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
  for _, Row in ipairs(Levels) do
    local EventDungeonId = Row.EventDugeonId or Row.EventDungeonId
    if EventDungeonId then
      local Key = self:_GetUnlockAnimKey(EventId, EventDungeonId)
      EMCache:Remove(Key, true)
    end
  end
  DebugPrint("------ 已重置所有解锁动效播放标记 ------")
end

function SoloTreasureDataModel:DebugResetLastForbidden(EventId)
  EventId = EventId or self:GetEventId()
  if not EventId then
    return
  end
  local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
  for _, Row in ipairs(Levels) do
    local EventDungeonId = Row.EventDugeonId or Row.EventDungeonId
    if EventDungeonId then
      local Key = self:_GetLastForbiddenKey(EventId, EventDungeonId)
      EMCache:Remove(Key, true)
    end
  end
  DebugPrint("------ 已清除 LastForbidden（Repeat Levels）------")
end

function SoloTreasureDataModel:_GetLastStageBirdKey(EventId)
  return string.format("SoloTreasure_LastStageBird_%s", tostring(EventId))
end

function SoloTreasureDataModel:SetLastStageBird(EventId, StageIndex)
  EMCache:Set(self:_GetLastStageBirdKey(EventId), tonumber(StageIndex) or 1, true)
end

function SoloTreasureDataModel:GetLastStageBirdEx(EventId)
  local V = EMCache:Get(self:_GetLastStageBirdKey(EventId), true)
  if nil == V then
    return 1, false
  end
  return tonumber(V) or 1, true
end

function SoloTreasureDataModel:_GetUnlockAnimKey(EventId, EventDungeonId)
  return string.format("SoloTreasure_UnlockAnimPlayed_%s_%s", tostring(EventId), tostring(EventDungeonId))
end

function SoloTreasureDataModel:IsUnlockAnimPlayed(EventId, EventDungeonId)
  local Key = self:_GetUnlockAnimKey(EventId, EventDungeonId)
  return EMCache:Get(Key, true) == true
end

function SoloTreasureDataModel:MarkUnlockAnimPlayed(EventId, EventDungeonId)
  local Key = self:_GetUnlockAnimKey(EventId, EventDungeonId)
  EMCache:Set(Key, true, true)
end

function SoloTreasureDataModel:_GetLastForbiddenKey(EventId, EventDungeonId)
  return string.format("SoloTreasure_LastForbidden_%s_%s", tostring(EventId), tostring(EventDungeonId))
end

function SoloTreasureDataModel:GetLastForbiddenEx(EventId, EventDungeonId)
  local Key = self:_GetLastForbiddenKey(EventId, EventDungeonId)
  local V = EMCache:Get(Key, true)
  if nil == V then
    return true, false
  end
  return true == V, true
end

function SoloTreasureDataModel:SetLastForbidden(EventId, EventDungeonId, bForbidden)
  local Key = self:_GetLastForbiddenKey(EventId, EventDungeonId)
  EMCache:Set(Key, true == bForbidden, true)
end

function SoloTreasureDataModel:_GetLastScoreKey(EventId)
  return string.format("SoloTreasure_LastScore_%s", tostring(EventId))
end

function SoloTreasureDataModel:_GetLastStageKey(EventId)
  return string.format("SoloTreasure_LastStage_%s", tostring(EventId))
end

function SoloTreasureDataModel:GetLastScoreEx(EventId)
  local V = EMCache:Get(self:_GetLastScoreKey(EventId), true)
  if nil == V then
    return 0, false
  end
  return tonumber(V) or 0, true
end

function SoloTreasureDataModel:SetLastScore(EventId, Score)
  EMCache:Set(self:_GetLastScoreKey(EventId), tonumber(Score) or 0, true)
end

function SoloTreasureDataModel:GetLastStageEx(EventId)
  local V = EMCache:Get(self:_GetLastStageKey(EventId), true)
  if nil == V then
    return 1, false
  end
  return tonumber(V) or 1, true
end

function SoloTreasureDataModel:SetLastStage(EventId, StageIndex)
  EMCache:Set(self:_GetLastStageKey(EventId), tonumber(StageIndex) or 1, true)
end

function SoloTreasureDataModel:GetBoardOldNewAndAnim(EventId, NewScore, TreasureHuntProgressData)
  local LastScore, bHasScore = self:GetLastScoreEx(EventId)
  local LastStageBoard, bHasStageBoard = self:GetLastStageEx(EventId)
  local LastStageBird, bHasStageBird = self:GetLastStageBirdEx(EventId)
  local NewResult = self:GetUserCurrentProgress(NewScore, TreasureHuntProgressData)
  local OldResult = self:GetUserCurrentProgress(LastScore, TreasureHuntProgressData)
  local bHasHistoryBoard = bHasScore and bHasStageBoard
  local bHasHistoryBird = bHasStageBird
  local ScoreDelta = (tonumber(NewScore) or 0) - (tonumber(LastScore) or 0)
  local bPlayScore = bHasHistoryBoard and ScoreDelta > 0
  local NewStage = tonumber(NewResult and NewResult.CurStageIndex) or 1
  local bPlayStageBoard = bHasHistoryBoard and NewStage > (tonumber(LastStageBoard) or 1)
  local bPlayStageBird = bHasHistoryBird and NewStage > (tonumber(LastStageBird) or 1)
  return OldResult, NewResult, {
    bPlayScore = bPlayScore,
    bPlayStageBoard = bPlayStageBoard,
    bPlayStageBird = bPlayStageBird,
    ScoreDelta = ScoreDelta,
    LastScore = LastScore,
    NewScore = tonumber(NewScore) or 0,
    LastStageBoard = tonumber(LastStageBoard) or 1,
    LastStageBird = tonumber(LastStageBird) or 1,
    NewStage = NewStage
  }
end

function SoloTreasureDataModel:CommitBoardSnapshotByResult(EventId, Result)
  if not Result then
    return
  end
  self:SetLastScore(EventId, tonumber(Result.CurScore) or 0)
  self:SetLastStage(EventId, tonumber(Result.CurStageIndex) or 1)
end

function SoloTreasureDataModel:CommitBirdSnapshotByResult(EventId, Result)
  if not Result then
    return
  end
  self:SetLastStageBird(EventId, tonumber(Result.CurStageIndex) or 1)
end

function SoloTreasureDataModel:InitBoardSnapshotOnLogin()
  local EventId = self:GetEventId()
  local CurScore = self:GetUserCurrentScore(EventId)
  if nil == CurScore then
    return false
  end
  local _, bHasScore = self:GetLastScoreEx(EventId)
  local _, bHasStage = self:GetLastStageEx(EventId)
  local _, bHasBirdStage = self:GetLastStageBirdEx(EventId)
  if bHasScore and bHasStage then
    if not bHasBirdStage then
      local ProgressData = self:GetTreasureHuntProgressData(EventId) or {}
      local Result = self:GetUserCurrentProgress(CurScore, ProgressData)
      local CurStage = tonumber(Result and Result.CurStageIndex) or 1
      self:SetLastStageBird(EventId, CurStage)
    end
    return true
  end
  local ProgressData = self:GetTreasureHuntProgressData(EventId) or {}
  local Result = self:GetUserCurrentProgress(CurScore, ProgressData)
  local CurStage = tonumber(Result and Result.CurStageIndex) or 1
  self:SetLastScore(EventId, tonumber(CurScore) or 0)
  self:SetLastStage(EventId, CurStage)
  if not bHasBirdStage then
    self:SetLastStageBird(EventId, CurStage)
  end
  return true
end

return SoloTreasureDataModel
