local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
  NodeCache.Count = 0
  NodeCache.Detail = {}
  local Avatar = GWorld:GetAvatar()
  if Avatar.GuildActivityLevel >= GuildCommon.MaxActivityPoint then
    return
  end
  local GuildTasks = Avatar.CommonQuestActivity[GuildCommon.GuildDummyEventId]
  for QuestId, QuestCounter in pairs(GuildTasks or {}) do
    if QuestCounter:IsComplete() then
      if QuestCounter:CanRecvReward() then
        if self:AllowChange(QuestId) then
          NodeCache.Count = NodeCache.Count + 1
          NodeCache.Detail[QuestId] = 1
        end
      else
        NodeCache.Detail[QuestId] = 0
      end
    end
  end
end

function M:AllowChange(QuestId)
  if not QuestId then
    return
  end
  local QuestConf = DataMgr.CommonQuestDetail[QuestId]
  if not QuestConf then
    return
  end
  DebugPrint(GText(QuestConf.StarterQuestDes), self.Name)
  local bDailyTask = QuestConf.QuestType == CommonConst.CommonQuestType.Daily
  local bRdNameDailyTask = self.Name == "GuildDailyTask"
  local bWeeklyTask = QuestConf.QuestType == CommonConst.CommonQuestType.Weekly
  local bRdNameWeeklyTask = self.Name == "GuildWeekTask"
  return bDailyTask and bRdNameDailyTask or bWeeklyTask and bRdNameWeeklyTask
end

function M:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  local QuestId = CacheDetailChangedParams and CacheDetailChangedParams.QuestId
  if QuestId and self:AllowChange(QuestId) and not self.Cache.Detail[QuestId] then
    DebugPrint(self.Name, QuestId)
    local Avatar = GWorld:GetAvatar()
    if Avatar.GuildActivityLevel >= GuildCommon.MaxActivityPoint then
      return false
    end
    local GuildTasks = Avatar.CommonQuestActivity[GuildCommon.GuildDummyEventId]
    local QuestCounter = GuildTasks[QuestId]
    if QuestCounter:IsComplete() then
      if QuestCounter:CanRecvReward() then
        self.Cache.Detail[QuestId] = 1
        return true
      else
        self.Cache.Detail[QuestId] = 0
      end
    end
  end
end

function M:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  local QuestId = CacheDetailChangedParams and CacheDetailChangedParams.QuestId
  if QuestId and self:AllowChange(QuestId) and 1 == self.Cache.Detail[QuestId] then
    local Avatar = GWorld:GetAvatar()
    if Avatar.GuildActivityLevel >= GuildCommon.MaxActivityPoint then
      return false
    end
    local GuildTasks = Avatar.CommonQuestActivity[GuildCommon.GuildDummyEventId]
    local QuestCounter = GuildTasks[QuestId]
    if QuestCounter:IsComplete() then
      if QuestCounter:CanRecvReward() then
        self.Cache.Detail[QuestId] = 1
      else
        self.Cache.Detail[QuestId] = 0
        return true
      end
    end
  end
  if SubValue == self.Count and nil == CacheDetailChangedParams then
    self.Cache.Detail = {}
    return true
  end
end

return M
