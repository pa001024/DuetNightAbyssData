local Component = {}
local GuildBossPointRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossPointRewardUtils")
local GUILD_BOSS_PERSON_POINT_REWARD_NODE = "GuildBossPersonPointReward"
local GUILD_BOSS_REWARD_NODE = "GuildBossProgressReward"

function Component:OnInit()
  ReddotManager.AddNode("GuildHub")
  self:RefreshGuildBossPersonPointRewardReddot()
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

function Component:RefreshGuildBossPersonPointRewardReddot()
  if not ReddotManager.GetTreeNode(GUILD_BOSS_PERSON_POINT_REWARD_NODE) then
    ReddotManager.AddNode("GuildHub")
  end
  ReddotManager.ClearLeafNodeCount(GUILD_BOSS_PERSON_POINT_REWARD_NODE)
  if not self:IsInGuild() then
    return
  end
  local Count = GuildBossPointRewardUtils.GetCanClaimRewardCount(self:GetAvatarGuildBossData())
  if Count > 0 then
    ReddotManager.IncreaseLeafNodeCount(GUILD_BOSS_PERSON_POINT_REWARD_NODE, Count)
  end
end

function Component:InvokeGuildTaskReddotUpdate()
  local bAllDailyNotComplete = true
  local bAllWeeklyNotComplete = true
  for QuestId, Quest in pairs(self:GetAvatar().CommonQuestActivity[GuildCommon.GuildDummyEventId]) do
    local QuestConf = DataMgr.CommonQuestDetail[QuestId]
    if not QuestConf then
    elseif QuestConf.QuestType == CommonConst.CommonQuestType.Daily then
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

function Component:InvokeGuildBossRewardReddotUpdate()
  local StageRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossStageRewardUtils")
  if not self:IsInGuild() then
    ReddotManager.ClearNodeCount(GUILD_BOSS_REWARD_NODE, true)
    return
  end
  ReddotManager.ClearNodeCount(GUILD_BOSS_REWARD_NODE, true)
  local BossId = StageRewardUtils.GetCurrentBossId()
  if 0 == BossId then
    return
  end
  for _, Stage in ipairs(StageRewardUtils.GetStages()) do
    if StageRewardUtils.CanClaimStage(Stage, BossId) then
      ReddotManager.IncreaseLeafNodeCount(GUILD_BOSS_REWARD_NODE, 1, {Stage = Stage})
    end
  end
end

return Component
