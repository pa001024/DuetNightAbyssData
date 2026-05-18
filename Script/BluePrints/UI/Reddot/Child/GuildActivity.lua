local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:OnInitNodeCache(NodeCache)
  NodeCache.Count = 0
  NodeCache.Detail = {}
  local Avatar = GWorld:GetAvatar()
  local ActivityVal = Avatar.GuildActivityLevel
  if ActivityVal and ActivityVal <= 0 then
    return false
  end
  for Val, Conf in pairs(DataMgr.GuildWeekReward) do
    if Val <= ActivityVal and not Avatar.GuildActivityLevelRewardRecord[Val] then
      NodeCache.Count = NodeCache.Count + 1
      NodeCache.Detail[Val] = 1
    end
  end
end

function M:OnIncreaseJudge(AddValue)
  local Avatar = GWorld:GetAvatar()
  local ActivityVal = Avatar.GuildActivityLevel
  if ActivityVal and ActivityVal <= 0 then
    return false
  end
  for Val, Conf in pairs(DataMgr.GuildWeekReward) do
    if Val <= ActivityVal and not Avatar.GuildActivityLevelRewardRecord[Val] and not self.Cache.Detail[Val] then
      self.Cache.Detail[Val] = 1
      return true
    end
  end
end

function M:OnDecreasJudge(SubValue)
  if SubValue == self.Count and self.Count > 1 then
    for Key, _ in pairs(self.Cache.Detail) do
      self.Cache.Detail[Key] = 0
    end
    return true
  end
  local Avatar = GWorld:GetAvatar()
  local ActivityVal = Avatar.GuildActivityLevel
  if ActivityVal and ActivityVal <= 0 then
    return false
  end
  for Val, Conf in pairs(DataMgr.GuildWeekReward) do
    if Val <= ActivityVal and Avatar.GuildActivityLevelRewardRecord[Val] and 1 == self.Cache.Detail[Val] then
      self.Cache.Detail[Val] = 0
      return true
    end
  end
end

return M
