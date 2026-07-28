local Component = {}
local EntertainmentController = require("BluePrints.UI.WBP.Entertainment.EntertainmentController")
local ECutSceneReviewState = {
  None = 0,
  Running = 1,
  Stopping = 2
}

function Component:_OnLoginSuccess()
  EntertainmentController:Init()
  self:RefreshCutSceneReviewReddot()
  EventManager:AddEvent(EventID.ConditionComplete, self, self.AddCutSceneReviewReddot)
end

function Component:LeaveWorld()
  EntertainmentController:Destory()
  EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

function Component:GetPartyTopic(CharId, Level)
  if not CharId then
    return
  end
  if not Level then
    return
  end
  local Party = self.PartyNpcs[CharId]
  if not Party then
    return
  end
  local PartyTopic = Party.PartyTopics[Level]
  if not PartyTopic then
    return
  end
  return PartyTopic
end

function Component:GetPartyTopicLockState(CharId, Level)
  local PartyTopic = self:GetPartyTopic(CharId, Level)
  if PartyTopic then
    return PartyTopic
  end
  DebugPrint(string.format("GetPartyTopicLockState CharId %d Level %d not found", CharId or -1, Level or -1))
  local PartyTopicClass = require("BluePrints.Client.CustomTypes.PartyTopic").PartyTopic
  local PartyNpcData = DataMgr.PartyNpc[CharId]
  if not PartyNpcData then
    return
  end
  local PartyTopicData = PartyNpcData.PartyTopicList[Level]
  if not PartyTopicData then
    return
  end
  PartyTopic = PartyTopicClass(PartyTopicData)
  PartyTopic.State = 0
  return PartyTopic
end

function Component:TriggerPartyTopicUnLock(CharId, Level, HandleCallback)
  CharId = tonumber(CharId)
  Level = tonumber(Level)
  self.logger.debug("TriggerPartyTopicUnLock Start", CharId, Level)
  
  local function Callback(Ret)
    self.logger.debug("TriggerPartyTopicUnLock callback", Ret, CharId, Level)
    if HandleCallback then
      HandleCallback(Ret)
    end
    EntertainmentController:GetModel():RefreshRedState()
  end
  
  self:CallServer("TriggerPartyTopicUnLock", Callback, CharId, Level)
end

function Component:TriggerPartyTopicComplete(PartyId, Level, HandleCallback)
  PartyId = tonumber(PartyId)
  Level = tonumber(Level)
  self.logger.debug("TriggerPartyTopicComplete Start", PartyId, Level)
  
  local function Callback(Ret)
    self.logger.debug("TriggerPartyTopicComplete callback", Ret, PartyId, Level)
    if HandleCallback then
      HandleCallback(Ret)
    end
    EntertainmentController:GetModel():RefreshRedState()
  end
  
  self:CallServer("TriggerPartyTopicComplete", Callback, PartyId, Level)
end

function Component:StartSojourns(PartyId, Level, HandleCallback)
  local function Callback(Ret)
    if HandleCallback then
      HandleCallback(ErrorCode:Check(Ret), Ret)
    end
  end
  
  self:CallServer("StartSojourns", Callback, PartyId, Level)
end

function Component:ExitSojourns(PartyId, Level, HandleCallback)
  local function Callback(Ret)
    if HandleCallback then
      HandleCallback(ErrorCode:Check(Ret), Ret)
    end
  end
  
  self:CallServer("ExitSojourns", Callback, PartyId, Level)
end

function Component:IsInCutSceneReview()
  return self.CutSceneReviewData ~= nil
end

function Component:IsCutSceneReviewRunning()
  return self:IsInCutSceneReview() and self.CutSceneReviewData.State == ECutSceneReviewState.Running
end

function Component:IsCutSceneReviewStopping()
  return self:IsInCutSceneReview() and self.CutSceneReviewData.State == ECutSceneReviewState.Stopping
end

function Component:GetCutSceneReviewChapterId()
  if not self.CutSceneReviewData then
    return nil
  end
  return self.CutSceneReviewData.ChapterId
end

function Component:GetCutSceneReviewCinematicId()
  if not self.CutSceneReviewData then
    return nil
  end
  return self.CutSceneReviewData.CinematicId
end

function Component:StartCutSceneReview(ChapterId, CinematicId, OnPreStart)
  OnPreStart = OnPreStart or function()
  end
  if self.CutSceneReviewData then
    DebugPrint("StartCutSceneReview failed, already in cut scene review")
    return
  end
  self.CutSceneReviewData = nil
  
  local function Callback(Ret)
    self.logger.debug("StartCutSceneReview Callback", Ret)
    if not ErrorCode:Check(Ret) then
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.CinematicReplay, "开始过场回顾失败", "服务器返回错误码", Ret)
      return
    end
    self.CutSceneReviewData = {
      State = ECutSceneReviewState.Running,
      ChapterId = ChapterId,
      CinematicId = CinematicId
    }
    OnPreStart()
    self:RunCutSceneReviewStoryline()
  end
  
  self:CallServer("StartCutSceneReview", Callback, ChapterId, CinematicId)
end

function Component:ExitCutSceneReview()
  if not self.CutSceneReviewData then
    DebugPrint("ExitCutSceneReview failed, not in cut scene review")
    return
  end
  UIManager(GWorld.GameInstance):LoadUINew("MemoryMain", self.CutSceneReviewData.ChapterId, self.CutSceneReviewData.CinematicId)
  self.CutSceneReviewData = nil
  AudioManager(GWorld.GameInstance):StopCGReview()
  
  local function Callback(Ret)
    self.logger.debug("ExitCutSceneReview Callback", Ret)
    if not ErrorCode:Check(Ret) then
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.CinematicReplay, "结束过场回顾失败", "服务器返回错误码", Ret)
      return
    end
  end
  
  self:CallServer("ExitCutSceneReview", Callback)
end

function Component:RunCutSceneReviewStoryline()
  if not self.CutSceneReviewData then
    DebugPrint("RunCutSceneReviewStoryline failed, not in cut scene review")
    return
  end
  local CinematicId = self.CutSceneReviewData.CinematicId
  local CinematicReviewData = DataMgr.CinematicReview[CinematicId]
  if not CinematicReviewData then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.CinematicReplay, "开始过场回顾失败", "数据表中找不到对应的 CinematicId", CinematicId)
    return
  end
  AudioManager(GWorld.GameInstance):StartCGReview()
  if not CinematicReviewData.DontMuteSceneBGM then
    AudioManager(GWorld.GameInstance):CGReviewPlayMuteSound()
  end
  GWorld.StoryMgr:RunStory(CinematicReviewData.StoryLinePath, nil, nil, function()
    if not self then
      DebugPrint("Run cut scene review storyline failed, component already destroyed")
      return
    end
    self.CutSceneReviewData.State = ECutSceneReviewState.Stopping
    local HomeSubregionId = 210101
    if self:GetCurrentRegionId() == HomeSubregionId then
      self:ExitCutSceneReview()
    else
      self:JumpToSubregion(HomeSubregionId)
    end
  end, nil, {bIsInvitation = true})
end

function Component:JumpToSubregion(SubregionId)
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not IsValid(GameMode) then
    return
  end
  GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, SubregionId, 1, nil, true)
end

function Component:RefreshCutSceneReviewReddot()
  if not ReddotManager.GetTreeNode("CutSceneReview") then
    ReddotManager.AddNodeEx("CutSceneReview")
  end
  ReddotManager.ClearLeafNodeCount("CutSceneReview")
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("CutSceneReview")
  for Key, Value in pairs(CacheDetail) do
    if 1 == Value then
      CacheDetail[Key] = nil
    end
  end
  local IncreaseNum = 0
  for ChapterId, Info in pairs(DataMgr.CinematicChapter) do
    if Info.ConditionId and ConditionUtils.CheckCondition(self, Info.ConditionId) and not CacheDetail[ChapterId] then
      CacheDetail[ChapterId] = 1
      IncreaseNum = IncreaseNum + 1
    end
  end
  if IncreaseNum > 0 then
    ReddotManager.IncreaseLeafNodeCount("CutSceneReview", IncreaseNum)
  end
end

function Component:AddCutSceneReviewReddot(ConditionId)
  if not ReddotManager.GetTreeNode("CutSceneReview") then
    ReddotManager.AddNodeEx("CutSceneReview")
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("CutSceneReview")
  for ChapterId, Info in pairs(DataMgr.CinematicChapter) do
    if Info.ConditionId == ConditionId and not CacheDetail[ChapterId] then
      CacheDetail[ChapterId] = 1
      ReddotManager.IncreaseLeafNodeCount("CutSceneReview")
    end
  end
end

return Component
