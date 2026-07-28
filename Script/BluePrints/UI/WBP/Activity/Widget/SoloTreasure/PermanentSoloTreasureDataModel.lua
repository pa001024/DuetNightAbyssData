require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local PermanentSoloTreasureDataModel = {}
PermanentSoloTreasureDataModel.REDDOT_NODE_LEVEL_LIST = "SoloTreasure_Permanent_LevelListView"
PermanentSoloTreasureDataModel.REDDOT_NODE_SHOP_NEW = "SoloTreasure_Permanent_Shop_New"

function PermanentSoloTreasureDataModel:GetSeasonRow(SeasonId)
  return DataMgr.PermanentTreasureHunt and DataMgr.PermanentTreasureHunt[SeasonId]
end

function PermanentSoloTreasureDataModel:GetCurrentSeasonId()
  local Now = TimeUtils.NowTime()
  local Tbl = DataMgr.PermanentTreasureHunt
  if not Tbl then
    return nil
  end
  local BestSeasonId, BestStartTime
  for SeasonId, Row in pairs(Tbl) do
    local StartTime = Row.SeasonStartDate and Row.SeasonStartDate:GetTime()
    if StartTime and Now >= StartTime and (not BestStartTime or BestStartTime < StartTime) then
      BestSeasonId, BestStartTime = SeasonId, StartTime
    end
  end
  return BestSeasonId
end

function PermanentSoloTreasureDataModel:GetRepeatLevelDataBySeasonId(SeasonId)
  local Row = self:GetSeasonRow(SeasonId)
  if not Row then
    return {}
  end
  local Result = {}
  local IdList = Row.SeasonDungeonId
  if IdList then
    for _, DungeonId in ipairs(IdList) do
      local Data = DataMgr.TreasureHuntRepeatDungeon and DataMgr.TreasureHuntRepeatDungeon[DungeonId]
      if Data then
        table.insert(Result, Data)
      end
    end
  end
  return Result
end

function PermanentSoloTreasureDataModel:GetLevelListDetail(EventId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail(self.REDDOT_NODE_LEVEL_LIST)
  if not Detail then
    return nil
  end
  if not Detail[EventId] then
    Detail[EventId] = {}
  end
  return Detail[EventId]
end

function PermanentSoloTreasureDataModel:IsLevelEntryRead(EventId, LevelIndex)
  local EDetail = self:GetLevelListDetail(EventId)
  if not EDetail then
    return false
  end
  return true == EDetail[LevelIndex]
end

function PermanentSoloTreasureDataModel:SetLevelEntryRead(EventId, LevelIndex, bRead)
  local EDetail = self:GetLevelListDetail(EventId)
  if not EDetail then
    return
  end
  EDetail[LevelIndex] = true == bRead
end

function PermanentSoloTreasureDataModel:RefreshLevelListNewReddot(SeasonId)
  local EventId = self:GetSeasonEventId(SeasonId)
  if not EventId then
    ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_LEVEL_LIST)
    return
  end
  local Levels = self:GetRepeatLevelDataBySeasonId(SeasonId) or {}
  local LevelCount = #Levels
  if LevelCount <= 0 then
    ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_LEVEL_LIST)
    return
  end
  local EDetail = self:GetLevelListDetail(EventId)
  if EDetail then
    for i = 1, LevelCount do
      if nil == EDetail[i] then
        EDetail[i] = false
      end
    end
  end
  local Avatar = GWorld:GetAvatar()
  local UnreadCount = 0
  for Idx = 1, LevelCount do
    local Row = Levels[Idx]
    if ConditionUtils.CheckCondition(Avatar, Row.UnlockCondition) and not self:IsLevelEntryRead(EventId, Idx) then
      UnreadCount = UnreadCount + 1
    end
  end
  ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_LEVEL_LIST)
  if UnreadCount > 0 then
    ReddotManager.IncreaseLeafNodeCount(self.REDDOT_NODE_LEVEL_LIST, UnreadCount)
  end
end

function PermanentSoloTreasureDataModel:IsShopEntryRead(EventId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail(self.REDDOT_NODE_SHOP_NEW)
  if not Detail then
    return false
  end
  return true == Detail[EventId]
end

function PermanentSoloTreasureDataModel:SetShopEntryRead(EventId, bRead)
  local Detail = ReddotManager.GetLeafNodeCacheDetail(self.REDDOT_NODE_SHOP_NEW)
  if not Detail then
    return
  end
  Detail[EventId] = true == bRead
end

function PermanentSoloTreasureDataModel:RefreshShopNewReddot(SeasonId)
  local EventId = self:GetSeasonEventId(SeasonId)
  local SeasonRow = self:GetSeasonRow(SeasonId)
  local ShopId = SeasonRow and tonumber(SeasonRow.SeasonShop)
  local bShopAvailable = ShopId and ShopId > 0
  ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_SHOP_NEW)
  if EventId and bShopAvailable and not self:IsShopEntryRead(EventId) then
    ReddotManager.IncreaseLeafNodeCount(self.REDDOT_NODE_SHOP_NEW, 1)
  end
end

function PermanentSoloTreasureDataModel:IsUnlockRelatedCondition(SeasonId, ConditionId)
  ConditionId = tonumber(ConditionId)
  if not ConditionId then
    return false
  end
  local EventId = self:GetSeasonEventId(SeasonId)
  local EventConf = EventId and DataMgr.EventMain[EventId]
  if EventConf and tonumber(EventConf.EventUnlockCondition) == ConditionId then
    return true
  end
  for _, Row in ipairs(self:GetRepeatLevelDataBySeasonId(SeasonId)) do
    if tonumber(Row.UnlockCondition) == ConditionId then
      return true
    end
  end
  return false
end

function PermanentSoloTreasureDataModel:RefreshReddotWithConditionUnlock(ConditionId)
  local SeasonId = self:GetCurrentSeasonId()
  if not SeasonId then
    return
  end
  if not self:IsUnlockRelatedCondition(SeasonId, ConditionId) then
    return
  end
  self:RefreshLevelListNewReddot(SeasonId)
  self:RefreshShopNewReddot(SeasonId)
  local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
  SoloTreasurePermanentDataModel:InitReddotTree()
end

function PermanentSoloTreasureDataModel:BindUnlockReddotRefresh()
  if self.bUnlockReddotRefreshBinded then
    return
  end
  self.bUnlockReddotRefreshBinded = true
  EventManager:AddEvent(EventID.ConditionComplete, self, self.RefreshReddotWithConditionUnlock)
end

function PermanentSoloTreasureDataModel:UnBindUnlockReddotRefresh()
  if not self.bUnlockReddotRefreshBinded then
    return
  end
  self.bUnlockReddotRefreshBinded = false
  EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

function PermanentSoloTreasureDataModel:MarkLevelEntryRead(SeasonId, LevelIndex)
  local EventId = self:GetSeasonEventId(SeasonId)
  if not EventId then
    return
  end
  if self:IsLevelEntryRead(EventId, LevelIndex) then
    return
  end
  self:SetLevelEntryRead(EventId, LevelIndex, true)
  self:RefreshLevelListNewReddot(SeasonId)
  EMCache:SaveUser(false)
end

function PermanentSoloTreasureDataModel:MarkShopEntryRead(SeasonId)
  local EventId = self:GetSeasonEventId(SeasonId)
  if not EventId then
    return
  end
  if self:IsShopEntryRead(EventId) then
    return
  end
  self:SetShopEntryRead(EventId, true)
  ReddotManager.ClearLeafNodeCount(self.REDDOT_NODE_SHOP_NEW)
  EMCache:SaveUser(false)
end

function PermanentSoloTreasureDataModel:PermanentSoloTreasureDataModelDebugReset()
  local SeasonId = self:GetCurrentSeasonId()
  local EventId = self:GetSeasonEventId(SeasonId)
  if not EventId then
    DebugPrint("[PermanentDebugReset] 当前无赛季，无法重置")
    return
  end
  self:RefreshLevelListNewReddot(SeasonId)
  local Detail = ReddotManager.GetLeafNodeCacheDetail(self.REDDOT_NODE_LEVEL_LIST)
  if not Detail then
    DebugPrint("[PermanentDebugReset] cache 仍为 nil，请先打开常驻搜打撤界面再执行此指令")
    return
  end
  Detail[EventId] = nil
  DebugPrint("[PermanentDebugReset] 已清除 EventId:", EventId, "的已读状态")
  self:RefreshLevelListNewReddot(SeasonId)
  DebugPrint("[PermanentDebugReset] 完成，所有关卡红点已重置为未读")
end

function PermanentSoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId)
  local Row = DataMgr.SoloTreasure and DataMgr.SoloTreasure[DungeonId]
  return Row and Row.GameTotalTime
end

function PermanentSoloTreasureDataModel:GetSeasonEventId(SeasonId)
  local Row = self:GetSeasonRow(SeasonId)
  return Row and Row.SeasonEventId
end

function PermanentSoloTreasureDataModel:GetSeasonEndTime(SeasonId)
  local Row = self:GetSeasonRow(SeasonId)
  return Row and Row.SeasonEndDate and Row.SeasonEndDate:GetTime()
end

function PermanentSoloTreasureDataModel:GetSeasonPlayableTime(SeasonId)
  local Row = self:GetSeasonRow(SeasonId)
  return Row and Row.SeasonAvailableDate and Row.SeasonAvailableDate:GetTime()
end

function PermanentSoloTreasureDataModel:IsSeasonPlayable(SeasonId)
  local PlayableTime = self:GetSeasonPlayableTime(SeasonId)
  if not PlayableTime then
    return false
  end
  return PlayableTime >= TimeUtils.NowTime()
end

function PermanentSoloTreasureDataModel:GetSeasonTimeInfo(SeasonId)
  local Now = TimeUtils.NowTime()
  local PlayableTime = self:GetSeasonPlayableTime(SeasonId)
  local EndTime = self:GetSeasonEndTime(SeasonId)
  if PlayableTime and Now <= PlayableTime then
    return math.max(0, math.floor(PlayableTime - Now)), true
  end
  if EndTime and Now <= EndTime then
    return math.max(0, math.floor(EndTime - Now)), false
  end
  return 0, false
end

return PermanentSoloTreasureDataModel
