local BattlePassUtils = {}
local BattlePassController = require("BluePrints.UI.WBP.BattlePass.Controller.BattlePassController")

function BattlePassUtils:GetLevel()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return Avatar.BattlePassLevel
  end
  return 0
end

function BattlePassUtils:GetMaxLevelReal()
  local Avatar = GWorld:GetAvatar()
  if Avatar and 0 ~= Avatar.BattlePassVersion then
    local BattlePassData = DataMgr.BattlePassMain[Avatar.BattlePassVersion]
    if BattlePassData and BattlePassData.LoopRewardPeriod and BattlePassData.LevelLimit then
      return BattlePassData.LevelLimit
    end
  end
  return self:GetMaxLevel()
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
  local MaxLevel = self:GetLoopMaxLevel()
  if MaxLevel <= 0 then
    MaxLevel = self:GetMaxLevel()
  end
  return MaxLevel <= self:GetLevel()
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

function BattlePassUtils:GetCurLoopMaxLevel()
  local Avatar = GWorld:GetAvatar()
  local NormalMaxLevel = self:GetMaxLevel()
  local CurLevel = self:GetLevel()
  if NormalMaxLevel > CurLevel then
    return NormalMaxLevel
  end
  local BattlePassMain = Avatar and DataMgr.BattlePassMain[Avatar.BattlePassVersion] or nil
  local LoopMaxLevel = BattlePassMain.LevelLimit or 0
  local LoopRewardPeriod = BattlePassMain.LoopRewardPeriod or 0
  local CurLoopMaxLevel = NormalMaxLevel
  if CurLevel > 0 and NormalMaxLevel > 0 and LoopRewardPeriod > 0 and LoopMaxLevel > 0 then
    local delta = CurLevel - NormalMaxLevel
    local loopIndex = math.floor(delta / LoopRewardPeriod)
    CurLoopMaxLevel = NormalMaxLevel + (loopIndex + 1) * LoopRewardPeriod
    if LoopMaxLevel < CurLoopMaxLevel then
      CurLoopMaxLevel = LoopMaxLevel
    end
  end
  return CurLoopMaxLevel or 0
end

function BattlePassUtils:GetLoopMaxLevel()
  local Avatar = GWorld:GetAvatar()
  local BattlePassMain = Avatar and DataMgr.BattlePassMain[Avatar.BattlePassVersion] or nil
  local LoopMaxLevel = BattlePassMain and BattlePassMain.LevelLimit or 0
  return LoopMaxLevel
end

function BattlePassUtils:IsIgnoreTaskReddot(TaskId)
  local IgnoreResourceIds = {
    [0] = false,
    [2002] = true
  }
  local TaskData = DataMgr.BattlePassTask[TaskId]
  if not (TaskData and TaskData.QuestReward) or not next(TaskData.QuestReward) then
    return false
  end
  local TaskRewardDataList = {}
  for _, QuestReward in pairs(TaskData.QuestReward) do
    local TaskRewardData = DataMgr.Reward[QuestReward]
    if TaskRewardData and next(TaskRewardData) then
      table.insert(TaskRewardDataList, TaskRewardData)
    end
  end
  if not TaskRewardDataList or not next(TaskRewardDataList) then
    return false
  end
  local bHasIgnoreResource = false
  local bHasOtherReward = false
  for _, TaskRewardData in ipairs(TaskRewardDataList) do
    local RewardIds = TaskRewardData.Id
    local RewardCounts = TaskRewardData.Count
    local RewardTypes = TaskRewardData.Type
    for i, RewardType in ipairs(RewardIds) do
      local RewardId = RewardIds[i] or 0
      local RewardCount = RewardCounts[i] and RewardCounts[i][1] or 0
      local RewardType = RewardTypes[i] or ""
      if "Resource" == RewardType and IgnoreResourceIds[RewardId] and RewardCount > 0 then
        bHasIgnoreResource = true
      else
        bHasOtherReward = true
      end
    end
  end
  if bHasIgnoreResource and not bHasOtherReward and self:IsReachWeeklyMaxExp() then
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
