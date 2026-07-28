local M = {}

function M.BuildSnapshot(RewardInfo, CurrentScore, IsRewardGot, TokenIcon)
  if not (RewardInfo and RewardInfo.Reward) or not RewardInfo.EachGradePoints then
    return nil
  end
  local MaxScore = #RewardInfo.Reward * RewardInfo.EachGradePoints
  local Score = CurrentScore or 0
  if MaxScore < Score then
    Score = MaxScore
  end
  return {
    EachGradePoints = RewardInfo.EachGradePoints,
    RewardIds = RewardInfo.Reward,
    CurrentScore = Score,
    MaxScore = MaxScore,
    IsRewardGot = IsRewardGot,
    TokenIcon = TokenIcon
  }
end

function M.HasAnyRewardCanGet(Snapshot)
  if not (Snapshot and Snapshot.RewardIds) or not Snapshot.EachGradePoints then
    return false
  end
  local CurrentScore = Snapshot.CurrentScore or 0
  for Index in ipairs(Snapshot.RewardIds) do
    local GradePoints = Snapshot.EachGradePoints * Index
    if CurrentScore >= GradePoints and Snapshot.IsRewardGot and not Snapshot.IsRewardGot(Index) then
      return true
    end
  end
  return false
end

return M
