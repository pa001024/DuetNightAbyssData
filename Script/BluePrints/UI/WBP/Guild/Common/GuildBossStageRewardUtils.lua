local M = {}
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")

local function NormalizeInt(Value)
  Value = tonumber(Value)
  if not Value then
    return 0
  end
  return math.floor(Value)
end

function M.MakeGuildStageKey(GuildId, BossId, Stage)
  return table.concat({
    NormalizeInt(GuildId),
    NormalizeInt(BossId),
    NormalizeInt(Stage)
  }, ":")
end

function M.MakeAvatarStageKey(WeekKey, BossId, Stage)
  return table.concat({
    NormalizeInt(WeekKey),
    NormalizeInt(BossId),
    NormalizeInt(Stage)
  }, ":")
end

function M.GetStages()
  local Stages = {}
  for Key, Info in pairs(DataMgr.GuildBossWeekReward or {}) do
    local Stage = NormalizeInt(type(Info) == "table" and Info.Stage or Key)
    if Stage > 0 then
      table.insert(Stages, Stage)
    end
  end
  table.sort(Stages)
  return Stages
end

function M.GetGuildId()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 0
  end
  return NormalizeInt(Avatar.GuildId)
end

function M.GetCurrentBossId()
  local GuildBossData = GuildModel:GetGuildBossData()
  if not GuildBossData then
    return 0
  end
  return NormalizeInt(GuildBossData:GetCurrentBossId())
end

function M.GetWeekKey()
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  if not AvatarBossData then
    return 0
  end
  return NormalizeInt(AvatarBossData:GetWeekKey())
end

function M.IsStageUnlocked(Stage, BossId)
  local GuildBossData = GuildModel:GetGuildBossData()
  if not GuildBossData then
    return false
  end
  BossId = BossId or M.GetCurrentBossId()
  local Key = M.MakeGuildStageKey(M.GetGuildId(), BossId, Stage)
  return GuildBossData:GetStageUnlocked()[Key] ~= nil
end

function M.IsStageRewardGot(Stage, BossId)
  local AvatarBossData = GuildModel:GetAvatarGuildBossData()
  if not AvatarBossData then
    return false
  end
  BossId = BossId or M.GetCurrentBossId()
  local Key = M.MakeAvatarStageKey(M.GetWeekKey(), BossId, Stage)
  return AvatarBossData:GetStageRewardGot()[Key] ~= nil
end

function M.CanClaimStage(Stage, BossId)
  BossId = BossId or M.GetCurrentBossId()
  return M.IsStageUnlocked(Stage, BossId) and not M.IsStageRewardGot(Stage, BossId)
end

function M.GetCanClaimStageCount()
  local BossId = M.GetCurrentBossId()
  if 0 == BossId then
    return 0
  end
  local Count = 0
  for _, Stage in ipairs(M.GetStages()) do
    if M.CanClaimStage(Stage, BossId) then
      Count = Count + 1
    end
  end
  return Count
end

return M
