local Component = {}

function Component:OnInit()
  ReddotManager.AddNode("GuildHub")
end

function Component:OnDestory()
end

function Component:TryAddReddotCount(NodeName, ExParam)
  if not self:IsInGuild() then
    return
  end
  ReddotManager.IncreaseLeafNodeCount(NodeName, 1, ExParam)
end

function Component:TrySubReddotCount(NodeName, ExParam)
  if not self:IsInGuild() then
    return
  end
  ReddotManager.DecreaseLeafNodeCount(NodeName, 1, ExParam)
end

function Component:TryClearReddotCount(NodeName, bClearCache, ExParam)
  ReddotManager.ClearNodeCount(NodeName, bClearCache)
end

function Component:ClearAllReddot()
  ReddotManager.ClearNodeCount("GuildHub", true)
end

function Component:InvokeGuildTaskReddotUpdate()
  local bAllDailyNotComplete = true
  local bAllWeeklyNotComplete = true
  for QuestId, Quest in pairs(self:GetAvatar().CommonQuestActivity[GuildCommon.GuildDummyEventId]) do
    local QuestConf = DataMgr.CommonQuestDetail[QuestId]
    if QuestConf.QuestType == CommonConst.CommonQuestType.Daily then
      self:TryAddReddotCount("GuildDailyTask", {QuestId = QuestId})
      self:TrySubReddotCount("GuildDailyTask", {QuestId = QuestId})
      if Quest:IsComplete() then
        bAllDailyNotComplete = false
      end
    elseif QuestConf.QuestType == CommonConst.CommonQuestType.Weekly then
      self:TryAddReddotCount("GuildWeekTask", {QuestId = QuestId})
      self:TrySubReddotCount("GuildWeekTask", {QuestId = QuestId})
      if Quest:IsComplete() then
        bAllWeeklyNotComplete = false
      end
    end
  end
  if bAllDailyNotComplete then
    self:TryClearReddotCount("GuildDailyTask")
  end
  if bAllWeeklyNotComplete then
    self:TryClearReddotCount("GuildWeekTask")
  end
end

return Component
