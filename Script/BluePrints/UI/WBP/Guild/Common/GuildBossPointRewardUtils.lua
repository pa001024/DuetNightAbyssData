local M = {}

function M.GetPointRewardConfig(AvatarBossData)
  if not AvatarBossData then
    return nil
  end
  local PointRewardId = AvatarBossData:GetPointRewardConfigId()
  if not PointRewardId or PointRewardId <= 0 then
    return nil
  end
  return DataMgr.GuildBossPonitReward[PointRewardId]
end

function M.GetPointMax(AvatarBossData)
  local RewardInfo = M.GetPointRewardConfig(AvatarBossData)
  if not (RewardInfo and RewardInfo.Reward) or not RewardInfo.EachGradePoints then
    return 0
  end
  return #RewardInfo.Reward * RewardInfo.EachGradePoints
end

function M.IsPointRewardGot(AvatarBossData, Index)
  if not AvatarBossData then
    return false
  end
  local PointRewardGot = AvatarBossData:GetPointRewardGot()
  return nil ~= PointRewardGot[Index]
end

function M.GetCanClaimRewardCount(AvatarBossData)
  local RewardInfo = M.GetPointRewardConfig(AvatarBossData)
  if not (RewardInfo and RewardInfo.Reward) or not RewardInfo.EachGradePoints then
    return 0
  end
  if not AvatarBossData then
    return 0
  end
  local CurrentPoint = AvatarBossData:GetPoint()
  local Count = 0
  for Index in ipairs(RewardInfo.Reward) do
    local GradePoints = RewardInfo.EachGradePoints * Index
    if CurrentPoint >= GradePoints and not M.IsPointRewardGot(AvatarBossData, Index) then
      Count = Count + 1
    end
  end
  return Count
end

return M
