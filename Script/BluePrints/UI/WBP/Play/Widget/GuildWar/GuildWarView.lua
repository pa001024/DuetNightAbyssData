require("UnLua")
local M = {}

function M:CheckDungeonCondition(DungeonId)
  if CommonConst.RaidSeasonType.Floor == self.RaidSeasonType then
    return self:IsUnlockedFloor(self.CurSelectedFloorNum)
  end
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

function M:GetBubbleDisplayMaxFloor()
  local curRaidSeason = self:GetRaidSeasons()
  if curRaidSeason and DataMgr.RaidSeason then
    local raidSeasonTableData = DataMgr.RaidSeason[curRaidSeason.RaidSeasonId]
    if raidSeasonTableData and raidSeasonTableData.BubbleDisplayMaxFloor then
      return raidSeasonTableData.BubbleDisplayMaxFloor
    end
  end
  return 0
end

function M:IsKeyFloor(InFloor)
  local result = false
  local curRaidSeason = self:GetRaidSeasons()
  if curRaidSeason and DataMgr.RaidSeason then
    local raidSeasonTableData = DataMgr.RaidSeason[curRaidSeason.RaidSeasonId]
    local keyFloorData = curRaidSeason:IsPreRaidTime() and raidSeasonTableData.PreKeyFloor or curRaidSeason:IsRaidTime() and raidSeasonTableData.KeyFloor or nil
    for _, v in pairs(keyFloorData) do
      if InFloor == v then
        result = true
        break
      end
    end
  end
  return result
end

function M:GetPassedFloor()
  local result = false
  local curRaidSeason = self:GetRaidSeasons()
  if curRaidSeason then
    result = curRaidSeason:IsPreRaidTime() and curRaidSeason.PreRaidFloor or curRaidSeason:IsRaidTime() and curRaidSeason.RaidFloor or 0
  end
  return result
end

function M:IsPassedFloor(InFloor)
  return InFloor <= self:GetPassedFloor()
end

function M:GetHighestUnlockedFloor()
  local curRaidSeason = self:GetRaidSeasons()
  if curRaidSeason then
    return curRaidSeason:IsPreRaidTime() and curRaidSeason.PreRaidUnlockFloor or curRaidSeason:IsRaidTime() and curRaidSeason.RaidUnlockFloor or 0
  end
  return 0
end

function M:GetHighestFloor()
  local highestFloor = 0
  local curRaidSeason = self:GetRaidSeasons()
  local raidDungeonType = CommonConst.RaidState.PreRaid
  if curRaidSeason then
    raidDungeonType = curRaidSeason:IsPreRaidTime() and CommonConst.RaidState.PreRaid or curRaidSeason:IsRaidTime() and CommonConst.RaidState.Raid or nil
  end
  for _, v in pairs(DataMgr.RaidFloor) do
    if raidDungeonType == v.FloorType and curRaidSeason.RaidSeasonId == v.RaidSeason and highestFloor < v.Floor then
      highestFloor = v.Floor
    end
  end
  return highestFloor
end

function M:IsUnlockedFloor(InFloor)
  return InFloor <= self:GetHighestUnlockedFloor()
end

function M:IsHighestFloorDisplayed(ListWidget)
  local minIndex, maxIndex = UIUtils.GetMinAndMaxDisplayedItemIndex(ListWidget)
  local highestFloor = self:GetHighestUnlockedFloor()
  return minIndex <= highestFloor and maxIndex >= highestFloor
end

function M:ScrollToHighestUnlockedFloor(ListWidget)
  local highestFloor = self:GetHighestUnlockedFloor()
  if highestFloor > 0 then
    ListWidget:ScrollIndexIntoView(highestFloor - 1)
  end
end

return M
