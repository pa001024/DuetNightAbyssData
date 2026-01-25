local BattlePassUtils = {}
local BattlePassController = require("BluePrints.UI.WBP.BattlePass.Controller.BattlePassController")

function BattlePassUtils:GetLevel()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.BattlePassLevel
  end
  return 0
end

function BattlePassUtils:GetMaxLevel()
  local Avatar = GWorld:GetAvatar()
  if Avatar and 0 ~= Avatar.BattlePassVersion then
    local BattlePassReward = self:GetBattlePassReward(Avatar.BattlePassVersion)
    return #(BattlePassReward or {})
  end
  return 0
end

function BattlePassUtils:IsMaxLevel()
  return self:GetLevel() >= self:GetMaxLevel()
end

function BattlePassUtils:GetBattlePassReward(BattlePassVersion)
  local BattlePassData = DataMgr.BattlePassMain[BattlePassVersion]
  if not BattlePassData then
    return nil
  end
  local BPRewardTemplateID = BattlePassData.BPRewardTemplateID
  if not BPRewardTemplateID then
    return nil
  end
  local BattlePassReward = DataMgr.BattlePassReward[BPRewardTemplateID]
  return BattlePassReward
end

function BattlePassUtils:IsIgnoreTaskReddot(Type)
  local IgnoreTypeWhenReachMaxExp = {
    [CommonConst.BattlePassTaskType.Daily] = true,
    [CommonConst.BattlePassTaskType.Weekly] = true,
    [CommonConst.BattlePassTaskType.Version] = false
  }
  if IgnoreTypeWhenReachMaxExp[Type] and self:IsReachWeeklyMaxExp() then
    return true
  end
  return false
end

function BattlePassUtils:IsReachWeeklyMaxExp()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local BattlePassInfo = DataMgr.BattlePassMain[Avatar.BattlePassVersion]
  if not BattlePassInfo then
    return false
  end
  local WeeklyMaxExp = BattlePassInfo.WeeklyMaxExp or 0
  local WeeklyNowExp = Avatar.BattlePassWeeklyExp or 0
  return WeeklyMaxExp <= WeeklyNowExp
end

return BattlePassUtils
