local Component = {}

function Component:EnterWorld()
  self:RefreshModArchiveReddot()
end

function Component:GetModGuideBookArchiveReward(ArchiveId, CallBack)
  local function Callback(Ret, Reward)
    self.logger.debug("ZJT_ GetModGuideBookArchiveReward ServerCallClient ", Ret, Reward)
    
    if CallBack then
      CallBack(Ret, Reward)
    end
  end
  
  self:CallServer("GetModGuideBookArchiveReward", Callback, ArchiveId)
end

function Component:GetAllModGuideBookArchiveReward(ArchiveIds, CallBack)
  local function Callback(Ret, Reward)
    self.logger.debug("ZJT_ GetAllModGuideBookArchiveReward ServerCallClient ", Ret, Reward)
    
    if CallBack then
      CallBack(Ret, Reward)
    end
  end
  
  self:CallServer("GetAllModGuideBookArchiveReward", Callback, ArchiveIds)
end

function Component:GetModArchiveStar(ModArchiveId)
  local StarCount = 0
  if not ModArchiveId or not DataMgr.ModArchiveInfo[ModArchiveId] then
    return StarCount
  end
  local ModArchiveInfo = DataMgr.ModArchiveInfo[ModArchiveId]
  local ApplicationTypeIdList = ModArchiveInfo.ApplicationTypeIdList
  for ModId, _ in pairs(self.HoldMods) do
    local ModInfo = DataMgr.Mod[ModId]
    if ModInfo and ModInfo.ApplicationType and 1 ~= ModInfo.NotShowInArchive and CommonUtils.HasValue(ApplicationTypeIdList, ModInfo.ApplicationType) then
      StarCount = StarCount + 1
    end
  end
  return StarCount
end

function Component:CheckModArchiveCanGetReward(ArchiveId, ArchiveCount)
  local ArchiveInfo = DataMgr.ModArchiveInfo[ArchiveId]
  if not ArchiveInfo then
    return false
  end
  local AllCount = self:GetModArchiveStar(ArchiveId)
  if ArchiveCount > AllCount or ArchiveCount <= 0 then
    return false
  end
  if 0 ~= ArchiveCount % ArchiveInfo.ArchiveStep then
    return false
  end
  if not self.ModArchiveRewards[ArchiveId] then
    return true
  end
  if not CommonUtils.HasValue(self.ModArchiveRewards[ArchiveId], ArchiveCount) then
    return true
  end
  return false
end

function Component:GetModArchiveReward(ArchiveId, ArchiveCount, CallBack)
  self.logger.debug("GetModArchiveReward Begin", ArchiveId, ArchiveCount)
  
  local function Callback(Ret, RewardReturn)
    self.logger.debug("GetArchiveReward Callback", Ret, ArchiveId, ArchiveCount, RewardReturn)
    if CallBack then
      CallBack(Ret, RewardReturn)
    end
  end
  
  self:CallServer("GetModArchiveReward", Callback, ArchiveId, ArchiveCount)
end

function Component:GetAllModArchiveReward(ArchiveId, CallBack)
  self.logger.debug("GetAllModArchiveReward Begin", ArchiveId)
  
  local function Callback(Ret, RewardReturn)
    self.logger.debug("GetAllModArchiveReward Callback", Ret, ArchiveId, RewardReturn)
    if CallBack then
      CallBack(Ret, RewardReturn)
    end
  end
  
  self:CallServer("GetAllModArchiveReward", Callback, ArchiveId)
end

function Component:RefreshModArchiveReddot()
  if not ReddotManager.GetTreeNode("ModArchive_Archive_Reward") then
    ReddotManager.AddNode("ModArchive_Archive_Reward")
  end
  ReddotManager.ClearLeafNodeCount("ModArchive_Archive_Reward", true)
  self:_CheckModArchiveRewardReddot()
end

function Component:_CheckModArchiveRewardReddot()
  local IncreaceNum = 0
  for ArchiveId, ArchiveInfo in pairs(DataMgr.ModArchiveInfo) do
    local StarCount = self:GetModArchiveStar(ArchiveId)
    local CanGetRewardNum = math.floor(StarCount / ArchiveInfo.ArchiveStep)
    local GotRewardNum = CommonUtils.TableLength(self.ModArchiveRewards and self.ModArchiveRewards[ArchiveId])
    if CanGetRewardNum > GotRewardNum then
      IncreaceNum = IncreaceNum + (CanGetRewardNum - GotRewardNum)
    end
  end
  if IncreaceNum > 0 then
    ReddotManager.IncreaseLeafNodeCount("ModArchive_Archive_Reward", IncreaceNum)
    DebugPrint("增加Mod图鉴奖励红点数量", IncreaceNum)
  end
end

return Component
