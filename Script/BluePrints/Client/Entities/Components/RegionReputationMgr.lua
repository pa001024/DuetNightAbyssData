local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local Component = {}

function Component:EnterWorld()
  RegionFameController:Init()
  self:AddReddot()
end

function Component:LeaveWorld()
  RegionFameController:Destory()
end

function Component:GetReputationRecurringQuest(ReputationId)
  local Reputation = self.RegionReputations[ReputationId]
  if not Reputation then
    return
  end
  local QuestList = {}
  for QuestId, State in pairs(Reputation.RecurringQuestState) do
    local Progress = 0
    local RecurringQuest = Reputation.RecurringQuestList[QuestId]
    if RecurringQuest then
      Progress = RecurringQuest.Progress
    end
    local StartTime
    if Reputation.RecurringQuestIdAndStartTime[1] == QuestId then
      StartTime = Reputation.RecurringQuestIdAndStartTime[2]
    end
    QuestList[QuestId] = {
      State = State,
      Progress = Progress,
      StartTime = StartTime
    }
  end
  return QuestList
end

function Component:GetReputationEntrustQuest(ReputationId)
  local Reputation = self.RegionReputations[ReputationId]
  if not Reputation then
    return
  end
  local QuestList = {}
  for QuestId, State in pairs(Reputation.EntrustQuestState) do
    QuestList[QuestId] = State
  end
  return QuestList
end

function Component:_OnPropChangeRegionReputations(Keys)
  self:RegionReputationsChange(Keys)
end

function Component:_OnPropChangeResources(Keys, OldValue)
  local FameMainReddot = ReddotManager.GetTreeNode("FameMain")
  if FameMainReddot and FameMainReddot.Count > 0 then
    return
  end
  local RecurringFameTaskReddot = ReddotManager.GetTreeNode("RecurringFameTask")
  if RecurringFameTaskReddot and RecurringFameTaskReddot.Count > 0 then
    return
  end
  local ResourceId = Keys and Keys[1]
  if ResourceId then
    if type(OldValue) == "table" then
      OldValue = OldValue.Count
    end
    local CurrentValue = self.Resources:QueryResourceCount(ResourceId) or 0
    OldValue = OldValue or 0
    if CurrentValue == OldValue then
      return
    end
    local CountOffset = CurrentValue - OldValue
    if not ReddotManager.GetTreeNode("EntrustFameTask") then
      ReddotManager.AddNodeEx("EntrustFameTask")
    end
    local Reddot = ReddotManager.GetTreeNode("EntrustFameTask")
    if CountOffset > 0 then
      if Reddot and Reddot.Count <= 0 then
        self:UpdateEntrustFameTaskReddot()
      end
    elseif Reddot and Reddot.Count > 0 then
      self:UpdateEntrustFameTaskReddot()
    end
  end
end

function Component:RegionReputationsChange(Keys)
  EventManager:FireEvent(EventID.RegionReputationsChange)
  self:AddReddot()
end

function Component:AddReddot()
  local hasReward = false
  for _, RegionCfg in pairs(DataMgr.RegionReputation) do
    local reputation = self.RegionReputations[RegionCfg.ReputationID]
    if reputation then
      for level = 1, reputation.ReputationLevel do
        if self:CheckReputationLevelReward(RegionCfg.ReputationID, level) then
          hasReward = true
          break
        end
      end
    end
    if hasReward then
      break
    end
  end
  if not ReddotManager.GetTreeNode("FameMain") then
    ReddotManager.AddNodeEx("FameMain")
  end
  if hasReward then
    local reddot = ReddotManager.GetTreeNode("FameMain")
    if reddot and reddot.Count <= 0 then
      ReddotManager.IncreaseLeafNodeCount("FameMain", 1)
    end
  else
    ReddotManager.ClearLeafNodeCount("FameMain", false)
  end
  self:UpdateRecurringFameTaskReddot()
  self:UpdateEntrustFameTaskReddot()
end

function Component:UpdateRecurringFameTaskReddot()
  local RegionFameModel = RegionFameController:GetModel()
  local AllRegionReputationData = DataMgr.RegionReputation
  if not AllRegionReputationData then
    return
  end
  local bHasCanClaim = false
  for ReputationId, _ in pairs(AllRegionReputationData) do
    local AllecurringQuest = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(ReputationId)
    if AllecurringQuest and #AllecurringQuest > 0 then
      bHasCanClaim = true
      break
    end
  end
  if bHasCanClaim then
    local Reddot = ReddotManager.GetTreeNode("RecurringFameTask")
    if Reddot and Reddot.Count <= 0 then
      ReddotManager.IncreaseLeafNodeCount("RecurringFameTask", 1)
    end
  else
    local Reddot = ReddotManager.GetTreeNode("RecurringFameTask")
    if Reddot then
      ReddotManager.ClearLeafNodeCount("RecurringFameTask", false)
    end
  end
end

function Component:UpdateEntrustFameTaskReddot()
  local RegionFameModel = RegionFameController:GetModel()
  local AllRegionReputationData = DataMgr.RegionReputation
  if not AllRegionReputationData then
    return
  end
  local bHasCanSubmit = false
  for ReputationId, _ in pairs(AllRegionReputationData) do
    local CanSubmitEntrustTask = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(ReputationId)
    if CanSubmitEntrustTask then
      bHasCanSubmit = true
      break
    end
  end
  if not ReddotManager.GetTreeNode("EntrustFameTask") then
    ReddotManager.AddNodeEx("EntrustFameTask")
  end
  if bHasCanSubmit then
    local Reddot = ReddotManager.GetTreeNode("EntrustFameTask")
    if Reddot and Reddot.Count <= 0 then
      ReddotManager.IncreaseLeafNodeCount("EntrustFameTask", 1)
    end
  else
    local Reddot = ReddotManager.GetTreeNode("EntrustFameTask")
    if Reddot then
      ReddotManager.ClearLeafNodeCount("EntrustFameTask", false)
    end
  end
end

function Component:CheckReputationLevelReward(ReputationId, Level)
  local Reputation = self.RegionReputations[ReputationId]
  if not Reputation then
    return false
  end
  local ReputationLevel = Reputation.ReputationLevel
  if Level > ReputationLevel then
    return false
  end
  local ReputationLevelInfo = DataMgr.ReputationLevel[ReputationId]
  if not ReputationLevelInfo[Level] then
    return false
  end
  local LevelRewardGotList = Reputation.LevelRewardGotList
  if LevelRewardGotList[Level] then
    return false
  end
  return true
end

function Component:HasAnyRewardUpToCurLevel(ReputationId)
  local Reputation = self.RegionReputations and self.RegionReputations[ReputationId]
  if not Reputation then
    return false, 0
  end
  local curLevel = Reputation.ReputationLevel or 0
  for level = 1, curLevel do
    if self:CheckReputationLevelReward(ReputationId, level) == true then
      return true, curLevel
    end
  end
  return false, curLevel
end

function Component:GetCurrentDoingRecurringQuestId()
  for ReputationId, Reputation in pairs(self.RegionReputations) do
    for QuestId, State in pairs(Reputation.RecurringQuestState) do
      if State == CommonConst.RecurringTaskState.Doing then
        local StartTime
        local DoingRecurringQuestId = Reputation.RecurringQuestIdAndStartTime[1]
        if QuestId == DoingRecurringQuestId then
          StartTime = Reputation.RecurringQuestIdAndStartTime[2]
        end
        return ReputationId, QuestId, StartTime
      end
    end
  end
  return nil, nil, nil
end

function Component:TakeRecurringQuest(ReputationId, QuestId, Cb)
  self.logger.debug("TakeRecurringQuest Begin", ReputationId, QuestId)
  
  local function Callback(Ret)
    self.logger.debug("TakeRecurringQuest Callback", Ret, ReputationId, QuestId)
    Cb(Ret, ReputationId, QuestId)
  end
  
  self:CallServer("TakeRecurringQuest", Callback, ReputationId, QuestId)
end

function Component:CancelRecurringQuest(ReputationId, QuestId, Cb)
  self.logger.debug("CancelRecurringQuest Begin", ReputationId, QuestId)
  
  local function Callback(Ret)
    self.logger.debug("CancelRecurringQuest Callback", Ret, ReputationId, QuestId)
    Cb(Ret, ReputationId, QuestId)
  end
  
  self:CallServer("CancelRecurringQuest", Callback, ReputationId, QuestId)
end

function Component:GetRecurringQuestReward(ReputationId, QuestId, Cb)
  self.logger.debug("GetRecurringQuestReward Begin", ReputationId, QuestId)
  
  local function Callback(Ret)
    self.logger.debug("GetRecurringQuestReward Callback", Ret, ReputationId, QuestId)
    Cb(Ret, ReputationId, QuestId)
  end
  
  self:CallServer("GetRecurringQuestReward", Callback, ReputationId, QuestId)
end

function Component:ManualRefreshEntrustQuest(ReputationId, Cb)
  self.logger.debug("ManualRefreshEntrustQuest Begin", ReputationId)
  
  local function Callback(Ret, ReputationId)
    self.logger.debug("ManualRefreshEntrustQuest Callback", Ret, ReputationId)
    if Ret == ErrorCode.RET_SUCCESS then
      self:UpdateEntrustFameTaskReddot()
    end
    Cb(Ret, ReputationId)
  end
  
  self:CallServer("ManualRefreshEntrustQuest", Callback, ReputationId)
end

function Component:CompleteEntrustQuest(ReputationId, QuestId, Callback)
  self.logger.debug("CompleteEntrustQuest Begin", ReputationId, QuestId)
  
  local function cb(Ret)
    self.logger.debug("CompleteEntrustQuest Callback", Ret, ReputationId, QuestId)
    if Callback then
      Callback(Ret, ReputationId, QuestId)
    end
  end
  
  self:CallServer("CompleteEntrustQuest", cb, ReputationId, QuestId)
end

function Component:GetRegionReputationLevelReward(ReputationId, LevelInfo, Cb)
  self.logger.debug("GetRegionReputationLevelReward Begin", ReputationId, LevelInfo)
  
  local function Callback(Ret, RewardReturn)
    self.logger.debug("GetRegionReputationLevelReward Callback", Ret, ReputationId, LevelInfo)
    if Cb then
      Cb(Ret, RewardReturn, ReputationId, LevelInfo)
    end
  end
  
  self:CallServer("GetRegionReputationLevelReward", Callback, ReputationId, LevelInfo)
end

function Component:AutoGetRecurringQuestReward(ReputationId, QuestList, RealScoreGet)
  self.logger.debug("AutoGetRecurringQuestReward ", ReputationId, QuestList, RealScoreGet)
end

function Component:OnRecurringQuestTimeOut(ReputationId, QuestId)
  self.logger.debug("OnRecurringQuestTimeOut ", ReputationId, QuestId)
  EventManager:FireEvent(EventID.RecurringQuestTimeOut, ReputationId)
end

function Component:OnGetReputationExp(ReputationId, OldLevel, OldExp, NewLevel, NewExp)
  self.logger.debug("OnGetReputationExp ", ReputationId, OldLevel, OldExp, NewLevel, NewExp)
  local ReputationExpAddInfo = {
    RegionId = ReputationId,
    OldLevel = OldLevel,
    OldExp = OldExp,
    CurLevel = NewLevel,
    CurExp = NewExp
  }
  EventManager:FireEvent(EventID.GetReputationExp, ReputationExpAddInfo)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local FameTaskUI = UIManager:GetUIObj("FameTask")
  if FameTaskUI then
    return
  end
  local SystemUIConfig = DataMgr.SystemUI.ReputationLevelUp
  if nil ~= SystemUIConfig then
    UIManager:LoadUINew("ReputationLevelUp", ReputationExpAddInfo)
  end
end

return Component
