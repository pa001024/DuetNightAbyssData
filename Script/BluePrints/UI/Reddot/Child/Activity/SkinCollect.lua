local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ReddotTreeNode_SkinCollect = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

local function HasGotReward(GotRewardId, Index, RewardIds)
  if not GotRewardId then
    return false
  end
  if GotRewardId.HasElement then
    if GotRewardId:HasElement(Index) then
      return true
    end
    if RewardIds then
      for _, RewardId in ipairs(RewardIds) do
        if GotRewardId:HasElement(RewardId) then
          return true
        end
      end
    end
  elseif GotRewardId[Index] then
    return true
  end
  return false
end

local function GetRewardIdsForIndex(PointsReward, Index)
  if not PointsReward then
    return nil
  end
  local Reward = PointsReward[Index]
  if not Reward then
    return nil
  end
  if type(Reward) == "table" then
    return Reward
  end
  return {Reward}
end

function ReddotTreeNode_SkinCollect:_Judge(EventId)
  if not ActivityUtils.CheckEventIsInActiveTime(EventId) then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AppearanceCollectEvent) or not Avatar.AppearanceCollectEvent.GetApperanceCollectEvent then
    return false
  end
  local RewardConfigData = DataMgr.AppearanceCollectReward and DataMgr.AppearanceCollectReward[EventId]
  if not RewardConfigData or not RewardConfigData.PointsTarget then
    return false
  end
  local CollectData = Avatar.AppearanceCollectEvent:GetApperanceCollectEvent(EventId)
  if not CollectData or CollectData.IsUnlockReward ~= true then
    return false
  end
  local CurrentScore = CollectData.Score or 0
  local PointsReward = RewardConfigData.PointsReward
  for Index, Target in ipairs(RewardConfigData.PointsTarget) do
    if Target <= CurrentScore then
      local RewardIds = GetRewardIdsForIndex(PointsReward, Index)
      if not HasGotReward(CollectData.GotRewardId, Index, RewardIds) then
        return true
      end
    end
  end
  return false
end

return ReddotTreeNode_SkinCollect
