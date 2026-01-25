require("UnLua")
local M = {}

function M:CheckDungeonCondition(DungeonId)
  local RaidDungeon = DataMgr.RaidDungeon[DungeonId]
  local TargetUnixTime = RaidDungeon.UnlockDate
  return nil == TargetUnixTime or TargetUnixTime <= TimeUtils.NowTime()
end

function M:GetRaidSeasons()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
  return Avatar.RaidSeasons[CurrentRaidSeasonId]
end

return M
