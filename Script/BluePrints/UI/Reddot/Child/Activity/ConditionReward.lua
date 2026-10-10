local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ReddotTreeNode_ConditionReward = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_ConditionReward:_Judge(ActivityID)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local ConditionData = DataMgr.ConditionalRewardEvent[ActivityID]
  if not ConditionData then
    return false
  end
  local ConditionList = ConditionData.RewardClaimCondition
  if not ConditionList or 0 == #ConditionList then
    return false
  end
  local RecordList = Avatar.ClaimActivityConditionRewardRecordList
  if not RecordList then
    return false
  end
  local ActivityClaimRecord = RecordList[ActivityID]
  for Index, ConditionId in ipairs(ConditionList) do
    local IsConditionComplete = ConditionUtils.CheckCondition(Avatar, ConditionId)
    local IsGetReward = ActivityClaimRecord and CommonUtils.HasValue(ActivityClaimRecord, Index) or false
    if IsConditionComplete and not IsGetReward then
      return true
    end
  end
  return false
end

return ReddotTreeNode_ConditionReward
