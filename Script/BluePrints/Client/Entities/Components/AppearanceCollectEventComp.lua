local Component = {}

function Component:AppearanceCollectEventUnlockReward(Callback, EventId)
  self:CallServer("AppearanceCollectEventUnlockReward", Callback, EventId)
end

function Component:AppearanceCollectEventGetReward(Callback, EventId, RewardIndex)
  self:CallServer("AppearanceCollectEventGetReward", Callback, EventId, RewardIndex)
end

function Component:_OnPropChangeAppearanceCollectEvent(Keys)
  if EventManager and EventID and EventID.OnAppearanceCollectEventChanged then
    EventManager:FireEvent(EventID.OnAppearanceCollectEventChanged, Keys)
  end
end

function Component:GMAppearanceCollectEventUnlockReward(EventId)
  local function CallBack(RetCode)
    self.logger.info(string.format("GMAppearanceCollectEventUnlockReward EventId(%s), RetCode(%s)", tostring(EventId), tostring(RetCode)))
  end
  
  self:AppearanceCollectEventUnlockReward(CallBack, EventId)
end

function Component:GMApperanceCollectEventGetReward(EventId, RewardIndex)
  local AppearanceCollectEventData = self.AppearanceCollectEvent:GetApperanceCollectEvent(EventId)
  self.logger.info(string.format("GMAppearanceCollectEventGetReward Cur Score = %s", AppearanceCollectEventData.Score))
  
  local function CallBack(RetCode)
    self.logger.info(string.format("GMAppearanceCollectEventGetReward EventId(%s), RewardIndex(%s), RetCode(%s)", tostring(EventId), tostring(RewardIndex), tostring(RetCode)))
  end
  
  self:AppearanceCollectEventGetReward(CallBack, EventId, RewardIndex)
end

function Component:GetAppearanceScore(type, id)
  if not type or not id then
    return 0
  end
  local EntranceInfo = self:CheckAppearanceCollectType(id, type)
  if not EntranceInfo then
    return 0
  end
  local AppearanceScoreInfo = DataMgr.Appearance2Score[type]
  if not AppearanceScoreInfo then
    return 0
  end
  local Score = AppearanceScoreInfo.Id2Score and AppearanceScoreInfo.Id2Score[id]
  if nil ~= Score then
    return Score
  end
  local TargetInfo = DataMgr[type] and DataMgr[type][id]
  if not TargetInfo then
    return 0
  end
  local Rarity = TargetInfo.Rarity
  if type == CommonConst.AppearanceCollectType.Mount then
    Rarity = TargetInfo.MountRarity
  end
  if nil == Rarity then
    return 0
  end
  Score = AppearanceScoreInfo.Rarity2Score and AppearanceScoreInfo.Rarity2Score[Rarity]
  return Score or 0
end

function Component:GetAppearanceCollectEvent_ApperanceScore(EntranceId, AppearanceType, AppearanceId)
  local tabAppearanceCollectEvent = DataMgr.AppearanceCollectEvent[EntranceId]
  if nil == tabAppearanceCollectEvent then
    return 0
  end
  local AppearanceScore = self:GetAppearanceScore(AppearanceType, AppearanceId)
  if AppearanceScore <= 0 then
    ScreenPrint(string.format("外观收集活动：获取外观分数失败，请检查对应物品是否ExcludeCollect 置为了true，AppearanceType=%s, AppearanceId=%s", tostring(AppearanceType), tostring(AppearanceId)))
  end
  return AppearanceScore * tabAppearanceCollectEvent.PointsPerTarget
end

return Component
