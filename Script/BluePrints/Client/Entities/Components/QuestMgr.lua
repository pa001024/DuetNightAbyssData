require("UnLua")
local EMCache = require("EMCache.EMCache")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
local WBP_Task_Main_C = require("BluePrints.UI.TaskPanel.WBP_Task_Main_C")
local ChapMutexUtils = require("Utils.ChapMutexUtils")
local ChapMutexQueueMgr = require("BluePrints.Story.ChapMutexQueueMgr")
local GMVariable = require("BluePrints.UI.GMInterface.GMVariable")
local FClientQuestChain = require("BluePrints.Client.Quest.ClientQuestChain")
local FQuestDetails = require("StoryCreator.StoryLogic.QuestDetails")
local Component = {}

function Component:NotifyAvatarRegionAllReady()
  if TaskUtils and TaskUtils.RemoveAllQuestExtraInfo then
    TaskUtils:RemoveAllQuestExtraInfo()
  end
  if MissionIndicatorManager and MissionIndicatorManager.MissionNpcSideBubbles then
    MissionIndicatorManager.MissionNpcSideBubbles = {}
  end
  self:TriggerQuestChain()
  EventManager:FireEvent(EventID.OnRegionLoaded)
  local QuestChainId = self.TrackingQuestChainId
  if QuestChainId and QuestChainId > 0 then
    self:PlayTrackingQuestChainBGM(QuestChainId)
  else
    self:StopTrackingQuestChainBGM(QuestChainId, true)
  end
end

function Component:EnterWorld()
  DebugPrint("QuestMgr EnterWorld")
  self.DoingQuestChainIds = {}
  self.DoingQuestIds = {}
  self.ClientQuestChains = {}
  self.QuestChainsNeedRestart = {}
  self.IsChapMutexChecked = false
  self.IsChapMutexChoosing = false
  self.ChapMutexQueueMgr = ChapMutexQueueMgr.New(self, self.OnChapMutexQueueDrained)
  for QuestChainId, QuestChain in pairs(self.QuestChains) do
    self.ClientQuestChains[QuestChainId] = FClientQuestChain(QuestChainId)
  end
end

function Component:OnLoginSuccess()
  self:RefreshTaskRedDot()
end

function Component:GetOrCreateClientQuestChain(QuestChainId)
  if not QuestChainId then
    return
  end
  if not self.ClientQuestChains[QuestChainId] then
    local QuestChain = self.QuestChains[QuestChainId]
    if not QuestChain then
      return
    end
    self.ClientQuestChains[QuestChainId] = FClientQuestChain(QuestChainId)
  end
  return self.ClientQuestChains[QuestChainId]
end

function Component:GetClientQuestChain(QuestChainId)
  if not QuestChainId then
    return
  end
  return self.ClientQuestChains[QuestChainId]
end

function Component:RemoveClientQuestChain(QuestChainId)
  local ClientQuestChain = self.ClientQuestChains[QuestChainId]
  if ClientQuestChain then
    ClientQuestChain:StopStoryline()
    self.ClientQuestChains[QuestChainId] = nil
  end
end

function Component:CheckQuestIdIsInStoryByQuest(QuestChainId, TargetQuestId)
  local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
  if ClientQuestChain then
    return ClientQuestChain:CheckQuestIdIsInStory(TargetQuestId)
  end
  return false
end

function Component:TryStartClientQuestChainStoryline(QuestChainId, QuestId, NodeId)
  local ClientQuestChain = self:GetOrCreateClientQuestChain(QuestChainId)
  if not ClientQuestChain then
    return
  end
  if ClientQuestChain:StartStoryline(QuestId, NodeId) then
    ClientQuestChain:AddStartQuestCallback(self, self.HandleQuestStart)
    ClientQuestChain:AddFinishQuestCallback(self, self.HandleQuestFinish)
  end
end

function Component:TryRestartClientQuestChainStoryline(QuestChainId, QuestId, NodeId)
  local ClientQuestChain = self:GetOrCreateClientQuestChain(QuestChainId)
  if not ClientQuestChain then
    return
  end
  if ClientQuestChain:RestartStoryline(QuestId, NodeId) then
    ClientQuestChain:AddStartQuestCallback(self, self.HandleQuestStart)
    ClientQuestChain:AddFinishQuestCallback(self, self.HandleQuestFinish)
  end
end

function Component:StopClientQuestChainStoryline(QuestChainId)
  local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
  if not ClientQuestChain then
    return
  end
  ClientQuestChain:StopStoryline()
end

function Component:StopAllClientQuestChainStoryline()
  for _, ClientQuestChain in pairs(self.ClientQuestChains) do
    ClientQuestChain:StopStoryline()
  end
end

function Component:RefreshTaskRedDot()
  for QuestChainId, Info in pairs(DataMgr.QuestChain) do
    local Quest = self.QuestChains[QuestChainId]
    if Quest and Quest.State == CommonConst.QuestChainState.finish then
      local Type = DataMgr.QuestChain[QuestChainId].QuestChainType
      local TypeName = CommonConst.QuestTypeName[Type]
      local NodeName = DataMgr.ReddotNode[TypeName].Name
      if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNode(NodeName, nil, 1)
      end
      if ReddotManager.GetLeafNodeCacheDetail(NodeName)[QuestChainId] ~= nil then
        ReddotManager.GetLeafNodeCacheDetail(NodeName)[QuestChainId] = nil
        ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {QuestId = QuestChainId})
      end
    end
  end
end

function Component:GetCurrentDoingQuest()
  local DoingQuestChainIds = {}
  local DoingQuestIds = {}
  for QuestChainId, QuestChain in pairs(self.QuestChains) do
    if QuestChain:IsDoing() then
      table.insert(DoingQuestChainIds, QuestChainId)
      local id = QuestChain.DoingQuestId
      if id and id > 0 then
        table.insert(DoingQuestIds, id)
      end
    end
  end
  return DoingQuestChainIds, DoingQuestIds
end

function Component:GetCurrenCanReciveQuest()
  local CanReciveQuestChainIds = {}
  local CanReciveQuestIds = {}
  for QuestChainId, QuestChain in pairs(self.QuestChains) do
    if QuestChain:IsUnlock() then
      table.insert(CanReciveQuestChainIds, QuestChainId)
      local id = QuestChain.DoingQuestId
      if id and id > 0 then
        table.insert(CanReciveQuestIds, id)
      end
    end
    if QuestChain:IsDoing() then
      table.insert(CanReciveQuestChainIds, QuestChainId)
      local id = QuestChain.DoingQuestId
      if id and id > 0 then
        table.insert(CanReciveQuestIds, id)
      end
    end
  end
  return CanReciveQuestChainIds, CanReciveQuestIds
end

function Component:CheckQuestCanStart()
  local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not GameMode then
    return false, GameMode
  end
  if not GameMode.IsInRegion then
    return false, GameMode
  end
  if not GameMode:IsInRegion() then
    return false, GameMode
  end
  if not GameMode.IsRegionAllReady or not GameMode:IsRegionAllReady() then
    return false, GameMode
  end
  return true, GameMode
end

function Component:OnPrintToFeiShu_Quest(ClientErrorCode, ServerErrorCode, FunctionName, QuestChainId, QuestId, ...)
end

function Component:OnChapMutexQueueDrained(bNeedTrigger)
  self.IsChapMutexChoosing = false
  if true == bNeedTrigger then
    self.IsChapMutexChecked = false
    self:TriggerQuestChain()
    return
  end
  self.IsChapMutexChecked = true
end

function Component:TryHandleChapMutexUnlockOnTrigger()
  if self.ChapMutexQueueMgr and self.ChapMutexQueueMgr:IsBusy() then
    self.IsChapMutexChoosing = true
    return true
  end
  self.IsChapMutexChoosing = false
  if self.IsChapMutexChecked then
    return false
  end
  local Group = ChapMutexUtils.BuildUnlockGroup(self)
  self.logger.debug("TryHandleChapMutexUnlockOnTrigger GroupSize", Group and #Group or 0)
  if not Group or #Group <= 0 then
    self.IsChapMutexChecked = true
    return false
  end
  self.ChapMutexQueueMgr:Enqueue(Group, "local_trigger")
  self.IsChapMutexChoosing = true
  self.ChapMutexQueueMgr:SetNeedTriggerAfterDrain(true)
  self.ChapMutexQueueMgr:Process()
  return true
end

function Component:TriggerQuestChain()
  if not self:CheckQuestCanStart() then
    return
  end
  if self:TryHandleChapMutexUnlockOnTrigger() then
    return
  end
  local Chain
  self.CanReciveQuestChainIds, self.CanReciveQuestIds = self:GetCurrenCanReciveQuest()
  self.CanReciveQuestId2QuestChainId = {}
  for index, id in ipairs(self.CanReciveQuestChainIds) do
    Chain = self.QuestChains[id]
    if Chain and Chain:IsUnlock() then
      if Chain.DoingQuestId and Chain.DoingQuestId > 0 then
        self.CanReciveQuestId2QuestChainId[Chain.DoingQuestId] = id
      end
      self:TryStartClientQuestChainStoryline(id)
    end
    if Chain and Chain:IsDoing() then
      if Chain.DoingQuestId and Chain.DoingQuestId > 0 then
        self.CanReciveQuestId2QuestChainId[Chain.DoingQuestId] = id
      end
      self:TryStartClientQuestChainStoryline(id)
      EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "Quest", Chain.DoingQuestId)
      EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "Quest", Chain.DoingQuestId)
      EventManager:FireEvent(EventID.TriggerFlexibleActive, "Quest")
    end
  end
end

function Component:CheckQuestIdIsInStory(InPath, TargetQuestId)
  local FileData = StorylineUtils.GetFileData(InPath)
  if nil == FileData then
    DebugPrint("Warning: QuestMgr.CheckQuestIdIsInStory: FileData is Empty")
    return false
  end
  local IsIn = false
  for _, Node in pairs(FileData.storyNodeData) do
    if Node and nil ~= Node.propsData.QuestId and Node.propsData.QuestId == TargetQuestId then
      IsIn = true
      break
    end
  end
  return IsIn
end

function Component:ServerStartQuest(Ret, QuestChainId, ClientVarParams)
  DebugPrint("ZJT_ ServerStartQuest ", Ret, QuestChainId, ClientVarParams)
  local CheckRet, GameMode, QuestChain = self:IsCanRunQuestConditionCheck(Ret, QuestChainId)
  if not self:CheckRegionErrorCode(CheckRet) then
    self:OnPrintToFeiShu_Quest(CheckRet, Ret, " ServerStartQuest_服务器告知客户端开始任务 ", QuestChainId)
    return
  end
  table.insert(self.DoingQuestIds, QuestChain.DoingQuestId)
  EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "Quest", QuestChain.DoingQuestId)
  EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "Quest", QuestChain.DoingQuestId)
  EventManager:FireEvent(EventID.TriggerFlexibleActive, "Quest")
  EventManager:FireEvent(EventID.OnMissionGroupStart, QuestChain.DoingQuestId)
  GameMode:TriggerQuestArtLevelChange(ClientVarParams)
  local RegionDataMgr = GameMode:GetRegionDataMgrSubSystem()
  if RegionDataMgr then
    RegionDataMgr:RecoverQuestLockedDatas(QuestChainId)
  end
  local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
  if ClientQuestChain and ClientQuestChain:IsStorylineRunning() then
    ClientQuestChain:StartQuest(ClientQuestChain:GetDoingQuestId())
  else
    self:TryStartClientQuestChainStoryline(QuestChainId)
  end
end

function Component:_OnPropChangeTrackingQuestChainId(key)
  local Avatar = GWorld:GetAvatar()
  local ServerTrackingQuestChainId = Avatar.TrackingQuestChainId
  if ServerTrackingQuestChainId and 0 ~= ServerTrackingQuestChainId then
    self:SetQuestTracking(ServerTrackingQuestChainId)
  end
  self.LastTrackingQuestChainId = self.TrackingQuestChainId
end

function Component:RealUpdateQuestChain(QuestChainId)
  if DataMgr.QuestChain[QuestChainId] == nil then
    DebugPrint("lkk_ RealUpdateQuestChain QuestChainId is nil ", QuestChainId)
    return
  end
  local QuestChain = self.QuestChains[QuestChainId]
  local Type = DataMgr.QuestChain[QuestChainId].QuestChainType
  local TypeName = CommonConst.QuestTypeName[Type]
  local NodeName = DataMgr.ReddotNode[TypeName].Name
  if ReddotManager.GetTreeNode(NodeName) and nil == ReddotManager.GetLeafNodeCacheDetail(NodeName)[QuestChainId] then
    ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {QuestId = QuestChainId})
  end
  if not self:CheckQuestCanStart() then
    return
  end
  if not QuestChain or not QuestChain:IsDoing() then
    return
  end
  DebugPrint("ZJT_ RealUpdateQuestChain ", QuestChainId)
  self:TryStartClientQuestChainStoryline(QuestChainId)
end

function Component:IsCanRunQuestConditionCheck(Ret, QuestChainId)
  local QuestChain, GameMode, Result
  Result, GameMode = self:CheckQuestCanStart()
  if not Result then
    return ErrorCode.RET_QUEST_REGION_NOT_ALLREADY, GameMode, QuestChain
  end
  QuestChain = self.QuestChains[QuestChainId]
  if not QuestChain then
    return ErrorCode.RET_QUESTCHAIN_NOT_EXIST, GameMode, QuestChain
  end
  if not self:CheckRegionErrorCode(Ret or ErrorCode.RET_SUCCESS) then
    return Ret, GameMode, QuestChain
  end
  return ErrorCode.RET_SUCCESS, GameMode, QuestChain
end

function Component:CheckQuestIdIsDoing(QuestId)
  if not self.DoingQuestId2QuestChainId then
    return false
  end
  if self.DoingQuestId2QuestChainId[QuestId] then
    return true
  end
  return false
end

function Component:QuestChainFinish(Ret, QuestChainId, RewardBox, TargetCompleteQuestIds, TargetClientVarParams)
  self.logger.info("QuestChainFinish", QuestChainId, Ret)
  PrintTable({TargetClientVarParams = TargetClientVarParams}, 10)
  local CheckRet, GameMode, QuestChain = self:IsCanRunQuestConditionCheck(Ret, QuestChainId)
  self:UpdateAllQuestChainReddotSetByFinishedQuestChain(QuestChainId)
  if not self:CheckRegionErrorCode(CheckRet) then
    self:OnPrintToFeiShu_Quest(CheckRet, Ret, " QuestChainFinish_任务链完成失败 ", QuestChainId, nil, RewardBox)
    return
  end
  self:HandleNotifyQuestComplete(nil, QuestChainId, TargetCompleteQuestIds)
  EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "QuestChain", QuestChainId)
  EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "QuestChain", QuestChainId)
  EventManager:FireEvent(EventID.TriggerFlexibleActive, "QuestChain")
  local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
  if ClientQuestChain then
    ClientQuestChain:FinishStoryline()
  end
  self:StopTrackingQuestChainBGM(QuestChainId, true)
  GWorld.UploadQuestChainData = true
  GameMode:HandleQuestChainFinish(QuestChainId)
  GWorld.UploadQuestChainData = false
  CommonUtils.RemoveValue(self.CanReciveQuestChainIds, QuestChainId)
  EventManager:FireEvent(EventID.QuestChainFinished, QuestChainId)
  GameMode:TriggerQuestArtLevelChange(TargetClientVarParams)
  if TaskUtils and TaskUtils.ShowQuestChainFinishCommonHudReward then
    TaskUtils:ShowQuestChainFinishCommonHudReward(QuestChainId, RewardBox)
  end
end

function Component:GetQuestDoing()
  return self.DoingQuestIds
end

function Component:IsQuestChainDoing(QuestChainId)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:IsDoing() then
    return true
  end
  return false
end

function Component:IsQuestDoing(QuestId)
  for QuestChainId, QuestChain in pairs(self.QuestChains) do
    if QuestChain:CheckQuestIdDoing(QuestId) then
      return true
    end
  end
  return false
end

function Component:UpdateAllQuestChainReddotSetByFinishedQuestChain(InQuestChainId)
  local Type = DataMgr.QuestChain[InQuestChainId].QuestChainType
  local TypeName = CommonConst.QuestTypeName[Type]
  local NodeName = DataMgr.ReddotNode[TypeName].Name
  if ReddotManager.GetLeafNodeCacheDetail(NodeName) and 1 == ReddotManager.GetLeafNodeCacheDetail(NodeName)[InQuestChainId] then
    ReddotManager.DecreaseLeafNodeCount(NodeName, 1, {QuestId = InQuestChainId})
  end
end

function Component:IsQuestChainFinished(QuestChainId)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:IsFinish() then
    return true
  end
  return false
end

function Component:IsQuestChainAssumeFinished(QuestChainId)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:GetAssumeFinish() then
    return true
  end
  return false
end

function Component:IsQuestFinished(QuestId)
  local length = CommonUtils:GetIntNumLength(QuestId)
  assert(length >= 6, "QuestId:" .. QuestId .. "无效")
  local QuestChainId = CommonUtils:GetFrontNum(QuestId, 6)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and (QuestChain:IsFinish() or QuestChain:CheckQuestIdComplete(QuestId)) then
    return true
  end
  return false
end

function Component:IsQuestAssumeFinished(QuestId)
  local length = CommonUtils:GetIntNumLength(QuestId)
  assert(length >= 6, "QuestId:" .. QuestId .. "无效")
  local QuestChainId = CommonUtils:GetFrontNum(QuestId, 6)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:GetAssumeFinish() then
    return true
  end
  return false
end

function Component:IsQuestChainLock(QuestChainId)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:IsLock() then
    return true
  end
  return false
end

function Component:IsQuestChainUnlock(QuestChainId)
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:IsUnlock() then
    return true
  end
  return false
end

function Component:StartQuest(QuestChainId, QuestId, ManualTrigger, TargetId, Count)
end

function Component:GMStartQuest(QuestChainId, QuestId)
  self:CallServerMethod("GMStartQuest", QuestChainId, QuestId)
end

function Component:CompleteQuestSuccess(ServerParamTable)
  local QuestChain = self.QuestChains[ServerParamTable.QuestChainId]
  if QuestChain then
    if QuestChain:IsFinish() then
      local Message = "任务链已经完成" .. [[

QuestChainId:]] .. ServerParamTable.QuestChainId .. [[

QuestId:]] .. ServerParamTable.QuestId
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务链已经完成", Message)
      return
    elseif QuestChain:CheckQuestIdComplete(ServerParamTable.QuestId) then
      local Message = "任务已经完成" .. [[

QuestChainId:]] .. ServerParamTable.QuestChainId .. [[

QuestId:]] .. ServerParamTable.QuestId
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务已经完成", Message)
      return
    end
  end
  self:OnQuestTrigger(ServerParamTable, ServerParamTable.ManualTrigger)
end

function Component:HandleClientQuestCompleteEvent(Ret, ManualTrigger, QuestId, QuestChainId, TargetCompleteQuestIds, ClientVarParams)
  if not ErrorCode:Check(Ret) then
    return
  end
  PrintTable({
    ClientVarParams = ClientVarParams,
    Ret = Ret,
    QuestChainId = QuestChainId,
    QuestId = QuestId,
    TargetCompleteQuestIds = TargetCompleteQuestIds
  }, 10)
  DebugPrint("ZJT_ 1111111 HandleClientQuestCompleteEvent ", Ret, ManualTrigger, QuestId, QuestChainId, TargetCompleteQuestIds, ClientVarParams)
  EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "Quest", QuestId)
  EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "Quest", QuestId)
  EventManager:FireEvent(EventID.QuestFinished, QuestId)
  EventManager:FireEvent(EventID.TriggerFlexibleActive, "Quest")
  CommonUtils.RemoveValue(self.DoingQuestIds, QuestId)
  self:HandleNotifyQuestComplete(QuestId, QuestChainId, TargetCompleteQuestIds)
  local GameMode = GWorld.GameInstance:GetCurrentGameMode()
  GameMode:TriggerQuestArtLevelChange(ClientVarParams)
  if ManualTrigger then
    self:TriggerQuestChain()
  end
end

function Component:HandleNotifyQuestComplete(CompleteQuestId, QuestChainId, TargetCompleteQuestIds)
  if not TargetCompleteQuestIds or next(TargetCompleteQuestIds) == nil then
    if CompleteQuestId then
      self:OnQuestComplete(QuestChainId, CompleteQuestId)
    else
      PrintTable({
        CompleteQuestId = CompleteQuestId or 0,
        QuestChainId = QuestChainId or 0,
        TargetCompleteQuestIds = TargetCompleteQuestIds,
        Reason = "ZJT_FailedCompleteQuestId"
      }, 10)
    end
  elseif type(TargetCompleteQuestIds) == "table" then
    for _, QuestId in ipairs(TargetCompleteQuestIds) do
      self:OnQuestComplete(QuestChainId, QuestId)
    end
  else
    PrintTable({
      CompleteQuestId = CompleteQuestId or 0,
      QuestChainId = QuestChainId or 0,
      TargetCompleteQuestIds = TargetCompleteQuestIds,
      Reason = "ZJT_FailedTargetCompleteQuestIds"
    }, 10)
  end
end

function Component:OnQuestTrigger(ServerParamTable, ManualTrigger)
  local Avatar = GWorld:GetAvatar()
  if GMVariable.BlockAllQuestTrigger or Avatar and Avatar.bGMBlockAllQuestTriggerOnce then
    DebugPrint("ZJT_ OnQuestTrigger blocked by GM", ServerParamTable and ServerParamTable.TriggerType, ServerParamTable and ServerParamTable.QuestChainId, ServerParamTable and ServerParamTable.QuestId)
    if Avatar then
      Avatar.bGMBlockAllQuestTriggerOnce = nil
    end
    return
  end
  DebugPrint("ZJT_ OnQuestTrigger  ", os.time(), ServerParamTable.TriggerType, ServerParamTable.QuestChainId, ServerParamTable.QuestId, ManualTrigger, ServerParamTable.TargetId, ServerParamTable.TargetCount, ServerParamTable.STLData, ServerParamTable.QuestDatas)
  PrintTable({
    QuestDatas = ServerParamTable.RegionQuestDatas,
    ServerParamTable.STLData,
    ServerParamTable = ServerParamTable
  }, 10)
  
  local function callback(Ret, Reward, ClientVarParams)
    self:HandleServerQuestComplete(Ret, Reward, ServerParamTable, ManualTrigger, ClientVarParams)
  end
  
  if ServerParamTable.QuestChainId > 0 and ServerParamTable.QuestId > 0 then
    self:HandleAddBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
    self:CallServer("OnQuestTrigger", callback, ServerParamTable)
  end
end

function Component:HandleServerQuestComplete(Ret, Reward, ServerParamTable, ManualTrigger, ClientVarParams)
  local TaskChainConfig = DataMgr.QuestChain[ServerParamTable.QuestChainId]
  if next(Reward) and TaskChainConfig.QuestReward and TaskChainConfig.QuestReward[ServerParamTable.QuestId] and nil ~= Reward and next(Reward) ~= nil and not Reward.bEmpty then
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward)
  end
  self:HandleRemoveBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
  self.logger.debug("ZJT_ OnQuestTrigger ServerCallClient ", ServerParamTable.TriggerType, ServerParamTable.QuestChainId, ServerParamTable.QuestId, Ret, ClientVarParams)
  self:HandleClientQuestCompleteEvent(Ret, ManualTrigger, ServerParamTable.QuestId, ServerParamTable.QuestChainId, nil, ClientVarParams)
  local EventNames = DataMgr.MSDKUploadConvert.QuestSuccessInfo[ServerParamTable.QuestId]
  if EventNames then
    for i, EventName in ipairs(EventNames) do
      local EMHeroUSDKSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMHeroUSDKSubsystem:StaticClass())
      EMHeroUSDKSubsystem:MSDKUploadCommonEventByEventName(EventName)
    end
  end
  self:HandleClientQuestFakeComplete(Ret, ServerParamTable.SelectRes)
end

function Component:HandleClientQuestFakeComplete(Ret, SelectRes)
  if not ErrorCode:Check(Ret) then
    return
  end
  if SelectRes then
    GWorld.NetworkMgr:OnDisconnectAndLoginAgain()
  end
end

function Component:OnQuestStart(QuestChainId, QuestId)
end

function Component:OnQuestComplete(QuestChainId, QuestId)
  local GameMode = GWorld.GameInstance:GetCurrentGameMode()
  DebugPrint("ZJT_ OnQuestComplete ", QuestChainId, QuestId, GameMode:GetName(), GameMode:IsSubGameMode())
  if not IsValid(GameMode) then
    return
  end
  GameMode:TriggerOnQuestComplete(QuestChainId, QuestId)
  EventManager:FireEvent(EventID.OnCompleteQuestChain, QuestChainId, QuestId)
end

function Component:UpdateQuestChain(QuestChainId)
  EventManager:FireEvent(EventID.OnUpdateQuestChain, QuestChainId)
  self:RealUpdateQuestChain(QuestChainId)
end

function Component:GMStartQuestChain(QuestChainId)
  self.logger.debug("GMStartQuestChain", QuestChainId, type(QuestChainId))
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain then
    if QuestChain:IsFinish() then
      DebugPrint("ZJT_ 任务链已经完成 ", QuestChainId)
      return
    end
    if QuestChain:IsDoing() then
      DebugPrint("任务链正在进行 ", QuestChainId)
      return
    end
    if QuestChain:IsUnlock() then
      DebugPrint("正在进行前置任务 ", QuestChainId)
      return
    end
  end
  
  local function callback(Ret)
    self.logger.debug("ServerCallClient GMStartQuestChain callback", Ret)
    local CheckRet, GameMode, QuestChain = self:IsCanRunQuestConditionCheck(Ret, QuestChainId)
    if not self:CheckRegionErrorCode(CheckRet) then
      self:OnPrintToFeiShu_Quest(CheckRet, Ret, " GMStartQuestChain_GM开始任务链失败 ", QuestChainId)
      return
    end
    table.insert(self.CanReciveQuestChainIds, QuestChainId)
    self:TriggerQuestChain()
  end
  
  self:CallServer("GMStartQuestChain", callback, QuestChainId)
end

function Component:GMSuccQuestChain(QuestChainId, bIsTriggerQuestChain)
  self.logger.debug("GMSuccQuestChain", QuestChainId, type(QuestChainId), bIsTriggerQuestChain, type(bIsTriggerQuestChain))
  local QuestChain = self.QuestChains[QuestChainId]
  if QuestChain and QuestChain:IsFinish() then
    DebugPrint("ZJT_ 任务链已经完成 ", QuestChainId)
    return
  end
  self:CallServerMethod("GMSuccQuestChain", QuestChainId)
end

function Component:GMCleanQuestChain(QuestChainId)
  print(_G.LogTag, "GMCleanQuestChain", QuestChainId)
  
  local function callback(ret)
    self.logger.debug("GMCleanQuestChain callback", ret)
  end
  
  self:CallServer("GMCleanQuestChain", callback, QuestChainId)
end

function Component:GMCleanAllQuest()
  self.QuestChains:Clear()
  
  local function callback(Ret)
    if ErrorCode:Check(Ret) then
    end
  end
  
  self:CallServer("GMCleanAllQuest", callback)
end

function Component:SaveQuestPopUIIdState(QuestId, PopUIId)
  local function Callback(Ret)
    self.logger.debug("ZJT_ SaveQuestPopUIIdState ", Ret, QuestId, PopUIId)
  end
  
  self:CallServer("SaveQuestPopUIIdState", Callback, QuestId, PopUIId)
end

function Component:DoRefreshTaskItemUIInfo(OpType, TaskInfo, TaskExtraInfo)
  local GameInstance = GWorld.GameInstance
  local UIManager = GameInstance:GetGameUIManager()
  if nil == UIManager then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local BattleMain = UIManager:GetUIObj("BattleMain")
  if BattleMain and BattleMain.Pos_TaskBar:GetChildAt(0) and BattleMain.Pos_TaskBar.Visibility == UE4.ESlateVisibility.Collapsed and Avatar.TrackingQuestChainId > 0 and nil ~= Avatar.TrackingQuestChainId then
    BattleMain.Pos_TaskBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  elseif BattleMain and BattleMain.Pos_TaskBar:GetChildAt(0) and BattleMain.Pos_TaskBar.Visibility == UE4.ESlateVisibility.Collapsed and TaskUtils:GetUnlockMainStory() then
    BattleMain.Pos_TaskBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    BattleMain.Pos_TaskBar:GetChildAt(0).VBox_TaskBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if TaskInfo and "Add" == OpType then
    local QuestChainData = DataMgr.QuestChain[TaskInfo.TaskChainId]
    local STLExportInfo = DataMgr.STLExportQuestChain[TaskInfo.TaskChainId]
    if QuestChainData and QuestChainData.QuestChainType and nil ~= STLExportInfo and nil ~= STLExportInfo.Quests and nil ~= STLExportInfo.Quests[TaskInfo.TaskId] and nil == STLExportInfo.Quests[TaskInfo.TaskId].IsPreQuest then
      local TypeName = CommonConst.QuestTypeName[QuestChainData.QuestChainType]
      local NodeName = DataMgr.ReddotNode[TypeName].Name
      if ReddotManager.GetTreeNode(NodeName) then
        local NodeDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        if nil == ReddotManager.GetLeafNodeCacheDetail(NodeName)[TaskInfo.TaskChainId] then
          ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {
            QuestId = TaskInfo.TaskChainId
          })
        end
      end
    end
  end
  local TaskPanel
  local BattleMainUI = UIManager:GetUIObj("BattleMain")
  if nil ~= BattleMainUI then
    if TaskInfo and TaskInfo.IsDynamicEvent then
      TaskPanel = BattleMainUI:GetOrAddDynamicEventWidget()
    else
      TaskPanel = BattleMainUI.Pos_TaskBar:GetChildAt(0)
    end
  end
  if nil == TaskPanel then
    return
  end
  if TaskInfo and TaskInfo.IsDynamicEvent then
    TaskPanel:UpdateTaskInfo(TaskInfo, OpType)
  elseif nil ~= TaskExtraInfo then
    TaskPanel:UpdateTaskExtraInfo(OpType, TaskExtraInfo)
  else
    local TrackingQuestId = Avatar.TrackingQuestChainId
    local RefreshTaskChainId = TaskInfo.TaskChainId
    if TrackingQuestId == RefreshTaskChainId then
      TaskPanel:UpdateTaskInfo(TaskInfo, OpType)
    end
  end
end

function Component:SetQuestTracking(QuestChainId, SubRegionId)
  local function Callback(Ret)
    if not self:CheckRegionErrorCode(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " SetQuestTracking_设置追踪任务链失败 ", QuestChainId)
      
      return
    end
    self:PlayTrackingQuestChainBGM(QuestChainId)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMain = UIManager:GetUIObj("BattleMain")
    if BattleMain and BattleMain.Pos_TaskBar:GetChildAt(0) then
      BattleMain.Pos_TaskBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      BattleMain.Pos_TaskBar:GetChildAt(0):SwitchTaskBarContentByTracking(true, true)
    end
    EventManager:FireEvent(EventID.UpdateMiniMap, nil, "Task", "Clear")
    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Task")
    local TargetSubRegionId = 0
    if not IsEmptyTable(UIObjs) then
      for k, UI in pairs(UIObjs) do
        if UI.CurGuideChainId == self.TrackingQuestChainId then
          local TargetKey = UI.GuideInfoCache.PointOrStaticCreatorName
          if TargetKey and GuidePointLocData[TargetKey] then
            TargetSubRegionId = GuidePointLocData[TargetKey].SubRegionId
          end
          local NpcUnitId = UI:GetTaskGuideNpcUnitIdFromCache()
          if nil ~= NpcUnitId and TaskUtils and TaskUtils.UpdateAllMissionNpcGuideMaps then
            TaskUtils:UpdateAllMissionNpcGuideMaps(true, k, NpcUnitId)
          end
          UI:Show("TrackQuest")
          UI:UpdateTaskIndicator()
          UI.PlayerRegionId = self.CurrentRegionId
          EventManager:FireEvent(EventID.UpdateMiniMap, UI:GetName(), "Task", "Add")
        else
          UI:Hide("TrackQuest")
        end
      end
    end
    EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    if nil ~= MissionIndicatorManager.TrackingSpecialSideQuestChainId then
      local UnSpecialUIObjs = MissionIndicatorManager:GetSpecialSideIndicatorUIObj()
      if not IsEmptyTable(UnSpecialUIObjs) then
        for _, UI in pairs(UnSpecialUIObjs) do
          if IsValid(UI) and UI.OwenrQuestNpcId then
            EventManager:FireEvent(EventID.UpdateMiniMap, UI.OwenrQuestNpcId, "SpecialSide", "Add")
          end
        end
      end
    end
    TaskUtils:UpdatePlayerSubRegionIdInfo(self.CurrentRegionId)
    if SubRegionId and SubRegionId > 0 then
      EventManager:FireEvent(EventID.CheckShowMap, QuestChainId)
    end
  end
  
  if QuestChainId ~= self.TrackingQuestChainId or self.LastTrackingQuestChainId ~= self.TrackingQuestChainId then
    self:CallServer("SetQuestTracking", Callback, QuestChainId)
  elseif SubRegionId and SubRegionId > 0 then
    EventManager:FireEvent(EventID.CheckShowMap, QuestChainId)
  end
end

function Component:CancelQuestTracking(QuestChainId)
  local function Callback(Ret)
    if not self:CheckRegionErrorCode(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " CancelQuestTracking_取消追踪任务链失败 ", QuestChainId)
      
      return
    end
    self:StopTrackingQuestChainBGM(QuestChainId, true)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattleMain = UIManager:GetUIObj("BattleMain")
    if BattleMain then
      BattleMain.Pos_TaskBar:GetChildAt(0):SwitchTaskBarContentByTracking(false, false)
    end
    local UI = UIManager:GetUIObj("TaskIndicator")
    if UI then
      UI.CurGuideChainId = 0
    end
    EventManager:FireEvent(EventID.OnCancelQuestTracking, QuestChainId)
    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(QuestChainId, "Task")
    if not IsEmptyTable(UIObjs) then
      for k, UI in pairs(UIObjs) do
        if TaskUtils and TaskUtils.UpdateAllMissionNpcGuideMaps then
          TaskUtils:UpdateAllMissionNpcGuideMaps(false, k, nil)
        end
      end
    end
    EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
    EventManager:FireEvent(EventID.UpdateMiniMap, nil, "Task", "Clear")
  end
  
  self:CallServer("CancelQuestTracking", Callback, QuestChainId)
end

function Component:OnQuestTargetFinish(Ret)
  DebugPrint("ZJT_ OnQuestTargetFinish ", Ret)
  if not self:CheckRegionErrorCode(Ret) then
    self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " OnQuestTargetUpdate_更新完成进度错误 ")
    return
  end
  EventManager:FireEvent(EventID.OnGameModeComplete)
end

function Component:OnQuestTargetUpdate(Ret)
  DebugPrint("ZJT_ OnQuestTargetUpdate ", Ret)
  if not self:CheckRegionErrorCode(Ret) then
    self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " OnQuestTargetUpdate_更新进度错误 ")
    return
  end
  EventManager:FireEvent(EventID.OnGameModeComplete)
end

function Component:ShowQuestChainRewardUI(RewardBox)
  if not RewardBox then
    return
  end
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local BattleMain = UIManager:GetUIObj("BattleMain")
  if not BattleMain then
    print(WarningTag, "当前在据点中，目前据点主UI与野外主UI不统一，据点暂时不显示任务链完成奖励")
    return
  end
  self:AddRewardsToCache(RewardBox)
  for _, DataType in pairs(CommonConst.DataType) do
    local RewardProps = RewardBox[DataType .. "s"]
    if not RewardProps then
    else
      self:ShowRewardUI(RewardProps, DataType, CommonConst.RewardReason.Quest)
    end
  end
end

function Component:ShowRewardUI(RewardProps, DataType, RewardReason)
  UIUtils.ShowDungeonRewardUI(RewardProps, RewardReason, DataType)
end

function Component:FailerSpecialQuest(SpecialQuestId, infos, NodeCallback)
  local function Callback(Ret)
    DebugPrint("ZJT_ FailerSpecialQuest ", Ret, SpecialQuestId)
    
    if not ErrorCode:Check(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " FailerSpecialQuest_特殊任务失败错误 ", SpecialQuestId)
    end
    NodeCallback(Ret)
  end
  
  self:CallServer("FailerSpecialQuest", Callback, SpecialQuestId, infos)
end

function Component:SuccessSpecialQuest(SpecialQuestId, infos, NodeCallback)
  local function Callback(Ret)
    DebugPrint("ZJT_ SuccessSpecialQuest ", Ret, SpecialQuestId)
    
    if not ErrorCode:Check(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " SuccessSpecialQuest_成功特殊任务失败 ", SpecialQuestId)
    end
    NodeCallback(Ret)
  end
  
  self:CallServer("SuccessSpecialQuest", Callback, SpecialQuestId, infos)
end

function Component:StartSpecialQuest(SpecialQuestId, infos, NodeCallback)
  local function Callback(Ret)
    DebugPrint("ZJT_ StartSpecialQuest ServerCallBack ", Ret, SpecialQuestId)
    
    if not ErrorCode:Check(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " StartSpecialQuest_开始特殊任务错误 ", SpecialQuestId)
    end
    NodeCallback(Ret)
  end
  
  self:CallServer("StartSpecialQuest", Callback, SpecialQuestId, infos)
end

function Component:StopQuestChainExcept(ChainId)
  local chain
  for index, id in ipairs(self.CanReciveQuestChainIds) do
    chain = self.QuestChains[id]
    if chain and id ~= ChainId and (chain:IsDoing() or chain:IsUnlock()) then
      local ClientQuestChain = self:GetClientQuestChain(id)
      if ClientQuestChain then
        ClientQuestChain:StopStoryline()
      end
    end
  end
end

function Component:HandleQuestChainDoing(QuestChainId, cb)
  local function Callback(Ret)
    self.logger.debug("ZJT_ HandleQuestChainDoing ", Ret, QuestChainId)
    
    if cb then
      cb(Ret)
    end
    if not self:CheckRegionErrorCode(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " HandleQuestChainDoing_手动开始任务错误 ", QuestChainId)
      return
    end
  end
  
  self:CallServer("HandleQuestChainDoing", Callback, QuestChainId)
end

function Component:NotifyQuestDeliver(DeliverId, DeliverStartIndex, IsWhite)
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  DebugPrint("ZJT_ NotifyQuestDeliver ", DeliverId, DeliverStartIndex, self.CurrentRegionId, IsWhite)
  if IsValid(GameMode) then
    local bIsInvitation, bIsFromMap
    local bShouldReturnAndDownloadPatch = true
    GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, DeliverId, DeliverStartIndex, IsWhite, bIsInvitation, bIsFromMap, bShouldReturnAndDownloadPatch)
  end
end

function Component:RegisterQuestPickId(QuestPickId, CallbackFunc)
  local function Callback(Ret)
    if not self:CheckRegionErrorCode(Ret) then
      self:OnPrintToFeiShu_Quest(ErrorCode.RET_SUCCESS, Ret, " RegisterQuestPickId_注册拾取掉落物错误 ", QuestPickId)
      
      return
    end
    if ErrorCode:Check(Ret) then
      CallbackFunc()
    end
  end
  
  self:CallServer("RegisterQuestPickId", Callback, QuestPickId)
end

function Component:QuestPickComplete(CompleteTable)
  for _, QuestPickupId in pairs(CompleteTable) do
    local QuestPickupId2Callback = GWorld.StoryMgr.QuestPickupId2Callback
    if QuestPickupId2Callback and QuestPickupId2Callback[QuestPickupId] then
      QuestPickupId2Callback[QuestPickupId]()
      GWorld.StoryMgr.QuestPickupId2Callback[QuestPickupId] = nil
    end
  end
end

function Component:UpdateStoryVariable(StoryVariableName, StoryVariableValue)
  local function Callback(Ret)
    if ErrorCode:Check(Ret) then
      EventManager:FireEvent(EventID.OnStoryVarUpdated, StoryVariableName, StoryVariableValue)
    end
    self.logger.debug("ZJT_ UpdateStoryVariable ", Ret, StoryVariableName, StoryVariableValue)
  end
  
  self:CallServer("UpdateStoryVariable", Callback, StoryVariableName, StoryVariableValue)
end

function Component:RemoveStoryVariable(StoryVariableName)
  local function Callback(Ret)
    self.logger.debug("ZJT_ RemoveStoryVariable ", Ret, StoryVariableName)
  end
  
  self:CallServer("RemoveStoryVariable", Callback, StoryVariableName)
end

function Component:S2C_SwitchGuide_QuestChain()
  EventManager:FireEvent(EventID.OnChangeTaskIndicator, TaskUtils.MissionNpcGuideMaps)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local TrackQuestChainId = Avatar.TrackingQuestChainId
  if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
    TrackQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
  end
  local QuestChain = Avatar.QuestChains[TrackQuestChainId]
  if not QuestChain then
    return
  end
  local DoingQuestId = QuestChain.DoingQuestId
  AudioManager(GWorld):UpdateQuestChainIdAndQuestId(TrackQuestChainId, DoingQuestId)
  self:PlayTrackingQuestChainBGM(TrackQuestChainId)
  local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Task")
  local TargetSubRegionId = 0
  if not IsEmptyTable(UIObjs) then
    for k, UI in pairs(UIObjs) do
      if UI.CurGuideChainId == self.TrackingQuestChainId then
        UI:Show("TrackQuest")
        EventManager:FireEvent(EventID.UpdateMiniMap, UI:GetName(), "Task", "Add")
      end
    end
  end
end

function Component:HandleQuestChainDoing_QuestComplete(ServerParamTable)
  local QuestChainId = ServerParamTable.QuestChainId
  if DataMgr.QuestChain[QuestChainId] and DataMgr.QuestChain[QuestChainId].QuestNpcId then
    MissionIndicatorManager:ReactiveMissionIndicatorByRegionMap(DataMgr.QuestChain[QuestChainId].QuestNpcId)
  end
  
  local function CallBack(Ret, RewardBox)
    self:HandleRemoveBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Quest_GetQuestSuccess"))
    self.logger.debug("ZJT_ HandleQuestChainDoing_QuestComplete ", Ret)
    local TaslBar = TaskUtils:GetTaskBarWidget()
    if 0 == self.TrackingQuestChainId then
      if TaslBar and QuestChainId > 0 then
        local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType(QuestChainId)
        if IconTexture then
          TaslBar.Icon_GuidePoint:SetBrushResourceObject(IconTexture)
        end
      end
    elseif TaslBar and self.TrackingQuestChainId > 0 then
      local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType(self.TrackingQuestChainId)
      if IconTexture then
        TaslBar.Icon_GuidePoint:SetBrushResourceObject(IconTexture)
      end
    end
  end
  
  self:HandleAddBlackScreenOnDelivery(ServerParamTable.bIsPlayBlackScreenOnComplete, ServerParamTable.QuestChainId, ServerParamTable.QuestId)
  self:CallServer("HandleQuestChainDoing_QuestComplete", CallBack, ServerParamTable)
end

function Component:NotifyActiveQuestChainEnd(QuestChainId)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    DebugPrint("LHQ@@@NotifyActiveQuestChainEnd:", Avatar.TrackingQuestChainId)
  end
  self.logger.debug("ZJT_ ServerCallClient NotifyActiveQuestChainEnd ", QuestChainId)
  local SpecialQuestIds = DataMgr.SpecialQuestId2QuestChainId[QuestChainId]
  if SpecialQuestIds then
    for _, SpecialQuestId in pairs(SpecialQuestIds) do
      ClientEventUtils:TryInterruptSpecialQuestEvent(SpecialQuestId, "ServerNotifyEnd")
    end
  end
  local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
  if ClientQuestChain then
    ClientQuestChain:StopStoryline()
  end
  local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
  GameMode:ClearRegionActorData("QuestChainId", QuestChainId, EDestroyReason.QuestChainClear, function(Target, Key, Value)
    return Target.QuestChainId == Value
  end)
  local TaslBar = TaskUtils:GetTaskBarWidget()
  if TaslBar then
    TaslBar:SwitchTaskBarContentByTracking(true, true)
  end
  local Indicators = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(QuestChainId, "Task")
  if IsEmptyTable(Indicators) == false then
    for _, Indicator in pairs(Indicators) do
      if Indicator then
        Indicator:CloseIndicator()
      end
    end
  end
end

function Component:CheckHaveSuccQuestDeliver(QuestChain, QuestId)
  local QuestChainInfo = DataMgr.STLExportQuestChain[QuestChain]
  local QuestInfo = QuestChainInfo.Quests[QuestId]
  local QuestDeliverInfo = QuestInfo.SuccQuestDeliver
  if not QuestInfo.SuccQuestDeliver then
    return false
  end
  if 1 == QuestDeliverInfo.DeliverType then
    if not self:CheckSubRegionId(QuestDeliverInfo.Id) then
      return false
    end
  elseif 2 == QuestDeliverInfo.DeliverType then
    if not self:DungeonIdCheck(QuestDeliverInfo.Id) then
      return false
    end
  else
    return false
  end
  return true
end

function Component:HandleAddBlackScreenOnDelivery(bIsPlayBlackScreenOnComplete, QuestChain, QuestId)
  if bIsPlayBlackScreenOnComplete and self:CheckHaveSuccQuestDeliver(QuestChain, QuestId) then
    DebugPrint("gyy@HandleAddBlackScreenOnDelivery ", QuestChain, QuestId)
    self:AddStoryBlackScreenOnDelivery()
  end
end

function Component:HandleRemoveBlackScreenOnDelivery(bIsPlayBlackScreenOnComplete, QuestChain, QuestId)
  if bIsPlayBlackScreenOnComplete and self:CheckHaveSuccQuestDeliver(QuestChain, QuestId) then
    DebugPrint("gyy@HandleRemoveBlackScreenOnDelivery ", QuestChain, QuestId)
    self:RemoveStoryBlackScreenOnDelivery()
  end
end

function Component:GMSuccQuestComplete(Ret, QuestId, QuestChainId, TargetCompleteQuestIds, RewardBox, TargetClientVarParams)
  if Ret ~= ErrorCode.RET_SUCCESS then
    self.logger.error("ZJT_ 11111111 GMSuccQuestComplete 失败 ", Ret, QuestId, QuestChainId, TargetCompleteQuestIds, RewardBox, TargetClientVarParams)
    return
  end
  PrintTable({RewardBox = RewardBox}, 10)
  local TaskChainConfig = DataMgr.QuestChain[QuestChainId]
  if next(RewardBox) and TaskChainConfig.QuestReward and TaskChainConfig.QuestReward[QuestId] and nil ~= RewardBox and next(RewardBox) ~= nil and not RewardBox.bEmpty then
    UIUtils.ShowGetItemPage(nil, nil, nil, RewardBox)
  end
  self:HandleClientQuestCompleteEvent(Ret, false, QuestId, QuestChainId, TargetCompleteQuestIds, TargetClientVarParams)
end

function Component:SelectStoryOption(OptionId)
  self.SelectedKeyOption = self.SelectedKeyOption or {}
  self.SelectedKeyOption[OptionId] = true
end

function Component:IsStoryOptionSelected(OptionId)
  self.SelectedKeyOption = self.SelectedKeyOption or {}
  return self.SelectedKeyOption[OptionId] == true
end

function Component:GetIsSubmitComplete(QuestChainId, SubmitId)
  local QuestChain = self.QuestChains[QuestChainId]
  if not QuestChain or not QuestChain:IsDoing() then
    return false
  end
  local SubmitData = DataMgr.QuestTurnInItem[SubmitId]
  if not SubmitData or not SubmitData.QuestId then
    return false
  end
  if QuestChain.DoingQuestId ~= SubmitData.QuestId then
    return false
  end
  return QuestChain.SubmitQuestId:HasValue(SubmitId)
end

function Component:GetIsSpecialQuestSubmitComplete(SpecialQuestId, SubmitId)
  local SpecialQuest = self.SpecialQuestData[SpecialQuestId]
  if not SpecialQuest or not SpecialQuest:IsDoing() then
    return false
  end
  local SubmitData = DataMgr.QuestTurnInItem[SubmitId]
  if not SubmitData or not SubmitData.SpecialQuestId then
    return false
  end
  if SpecialQuestId ~= SubmitData.SpecialQuestId then
    return false
  end
  return SpecialQuest.SubmitQuestId:HasValue(SubmitId)
end

function Component:SubmitQuestItems(SubmitId, InCallback)
  self.logger.debug("SubmitQuestItems Begin", SubmitId)
  
  local function Callback(Ret)
    if InCallback then
      InCallback(ErrorCode:Check(Ret))
    end
    self.logger.debug("SubmitQuestItems ", Ret, SubmitId)
  end
  
  self:CallServer("SubmitQuestItems", Callback, SubmitId)
end

function Component:ShowQuestItems(ShowQuestId, TargetResourceId, InCallback)
  self.logger.debug("ShowQuestItems Begin", ShowQuestId, TargetResourceId)
  
  local function Callback(Ret)
    if InCallback then
      InCallback(ErrorCode:Check(Ret))
    end
    self.logger.debug("ShowQuestItems ", Ret, ShowQuestId, TargetResourceId)
  end
  
  self:CallServer("ShowQuestItems", Callback, ShowQuestId, TargetResourceId)
end

function Component:CheckQuestItemsOwned(SubmitId)
  if not SubmitId then
    DebugPrint("CheckQuestItemOwned: SubmitId is nil")
    return false
  end
  local SubmitData = DataMgr.QuestTurnInItem[SubmitId]
  if not SubmitData then
    DebugPrint("CheckQuestItemOwned: SubmitData not found for SubmitId", SubmitId)
    return false
  end
  if SubmitData.ItemIds then
    for i, ItemId in ipairs(SubmitData.ItemIds) do
      local Count = SubmitData.ItemCounts[i] or 1
      local HasCount = self:GetResourceNum(ItemId)
      if Count <= HasCount then
        return true
      end
    end
  end
  return false
end

function Component:GiveUpQuestChain(QuestChainId)
  self.logger.debug("GiveUpQuestChain Begin", QuestChainId)
  
  local function Callback(Ret)
    self.logger.debug("GiveUpQuestChain Callback ", Ret)
    if not ErrorCode:Check(Ret) then
      return
    end
    local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
    GameMode:ClearRegionActorData("QuestChainId", QuestChainId, EDestroyReason.QuestChainClear, function(Target, Key, Value)
      return Target.QuestChainId == Value
    end)
    self:TryRestartClientQuestChainStoryline(QuestChainId)
    EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "GiveUpQuestChain", QuestChainId)
    EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "GiveUpQuestChain", QuestChainId)
    EventManager:FireEvent(EventID.TriggerFlexibleActive, "GiveUpQuestChain")
  end
  
  self:CallServer("GiveUpQuestChain", Callback, QuestChainId)
end

function Component:NotifyChooseQuestChapterUnlock(NeedUnlockChapterIdList)
  self.logger.debug("NotifyChooseQuestChapterUnlock begin", NeedUnlockChapterIdList and table.concat(NeedUnlockChapterIdList, ", "))
  local FilteredGroup = ChapMutexUtils.FilterGroupByExternalDoing(self, NeedUnlockChapterIdList)
  self.logger.debug("NotifyChooseQuestChapterUnlock, FilteredGroup", FilteredGroup and table.concat(FilteredGroup, ", "))
  if #FilteredGroup <= 0 then
    return
  end
  local Added = self.ChapMutexQueueMgr and self.ChapMutexQueueMgr:Enqueue(FilteredGroup, "server_notify")
  if Added then
    self.IsChapMutexChoosing = true
    self.ChapMutexQueueMgr:Process()
  end
end

function Component:ChooseQuestChapterUnlock(ChapterId, InCallback)
  self.logger.debug("ChooseQuestChapterUnlock Begin", ChapterId)
  if not ChapterId then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Consumable_NotChoose"))
    return
  end
  
  local function Callback(Ret)
    self.logger.debug("ChooseQuestChapterUnlock Callback ", Ret, ChapterId)
    if Ret == ErrorCode.RET_SUCCESS then
      UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Quest_ChapterSelect_Toast"))
    end
    if InCallback then
      InCallback()
    end
  end
  
  self:CallServer("ChooseQuestChapterUnlock", Callback, ChapterId)
end

function Component:UnlockQuestChapterForce(ChapterId, InCallback)
  self.logger.debug("UnlockQuestChapterForce Begin", ChapterId)
  
  local function Callback(Ret)
    self.logger.debug("UnlockQuestChapterForce Callback ", Ret, ChapterId)
    if InCallback then
      InCallback(Ret, ChapterId)
    end
  end
  
  self:CallServer("UnlockQuestChapterForce", Callback, ChapterId)
end

function Component:NotifyClearSTLNode(QuestChainIdList)
  self.logger.debug("NotifyClearSTLNode", QuestChainIdList)
  if not QuestChainIdList then
    return
  end
  for _, QuestChainId in pairs(QuestChainIdList) do
    local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
    if ClientQuestChain then
      ClientQuestChain:StopStoryline()
    end
  end
end

function Component:UnlockQuestChainAdvance(QuestChainId, InCallback)
  self.logger.debug("UnlockQuestChainAdvance Begin", QuestChainId)
  
  local function Callback(Ret)
    self.logger.debug("UnlockQuestChainAdvance Callback ", Ret, QuestChainId)
    if InCallback then
      InCallback(Ret, QuestChainId)
    end
  end
  
  self:CallServer("UnlockQuestChainAdvance", Callback, QuestChainId)
end

function Component:HandleQuestStart(QuestChainId, QuestId)
  self:TryRemoveStoryBlackScreenOnSucc(QuestChainId, QuestId)
end

function Component:HandleQuestFinish(QuestChainId, Node, OutPortNames, Result)
  if not Result then
    self:AddToWaitingRestartList(QuestChainId, Node.QuestId)
    if Node.bIsPlayBlackScreenOnFail then
      self:AddStoryBlackScreenOnFail()
    end
  elseif Node.bIsPlayBlackScreenOnComplete then
    local WaitingQuest = {}
    local QuestChainInfo = DataMgr.STLExportQuestChain[QuestChainId]
    if Node.QuestId == QuestChainInfo.EndQuestId then
      local QuestChainCInfo = DataMgr.ConditionId2QuestChainId[QuestChainId]
      if QuestChainCInfo then
        for QuestChainId, value in pairs(QuestChainCInfo) do
          local Avatar = GWorld:GetAvatar()
          local QuestChain = Avatar.QuestChains:GetQuestChain(QuestChainId)
          if QuestChain.IfAutoStart then
            table.insert(WaitingQuest, QuestChainId)
          end
        end
      end
    else
      local nextQuestInfo = QuestChainInfo.Quests[Node.QuestId]
      local nextQuestIds = nextQuestInfo.nextQuestIds
      for _, OutPortName in pairs(OutPortNames) do
        if nextQuestIds[OutPortName] then
          table.insert(WaitingQuest, nextQuestIds[OutPortName])
        end
      end
    end
    self:AddStoryBlackScreenOnSucc(WaitingQuest)
  end
end

function Component:AddToWaitingRestartList(QuestChainId, QuestId)
  table.insert(self.QuestChainsNeedRestart, {QuestChainId = QuestChainId, QuestId = QuestId})
end

function Component:AddStoryBlackScreen(ExtralInfo)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if not UIManager:IsCommonBlackScreenExist(ExtralInfo.HandleName) then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    local Params = {}
    Params.BlackScreenHandle = ExtralInfo.HandleName
    Params.InAnimationPlayTime = ExtralInfo.InTime or 0
    Params.OutAnimationPlayTime = ExtralInfo.OutTime or 0
    if IsValid(Player) then
      Player:AddDisableInputTag(ExtralInfo.HandleName)
    end
    UIManager:SetBannedActionCallback("BlackScreen", true, ExtralInfo.HandleName)
    UIManager:ShowCommonBlackScreen(Params)
  end
  
  local function BlackUIFadeOut()
    if ExtralInfo.TimeOverCallback then
      local Obj = ExtralInfo.TimeOverCallback.Obj
      local Func = ExtralInfo.TimeOverCallback.Func
      local Params = ExtralInfo.TimeOverCallback.Params
      Func(Obj, Params)
    end
    self:RemoveStoryBlackScreen(ExtralInfo.HandleName)
  end
  
  GWorld.GameInstance:AddTimer(ExtralInfo.ContinueTime or 10, BlackUIFadeOut, false, nil, ExtralInfo.HandleName, true)
end

function Component:RemoveStoryBlackScreen(HandleName)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if UIManager:IsCommonBlackScreenExist(HandleName) then
    GWorld.GameInstance:RemoveTimer(HandleName)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if IsValid(Player) then
      Player:RemoveDisableInputTag(HandleName)
    end
    UIManager:SetBannedActionCallback("BlackScreen", false, HandleName)
    UIManager:HideCommonBlackScreen(HandleName)
  end
end

function Component:AddStoryBlackScreenOnFail()
  local ExtralInfo = {
    HandleName = "StoryBlackScreenOnFail"
  }
  self:AddStoryBlackScreen(ExtralInfo)
end

function Component:RemoveStoryBlackScreenOnFail()
  local HandleName = "StoryBlackScreenOnFail"
  self:RemoveStoryBlackScreen(HandleName)
end

function Component:AddStoryBlackScreenOnSucc(WaitingQuest)
  if not self.WaitingQuest then
    self.WaitingQuest = {}
  end
  local AddFlag = false
  for _, Id in pairs(WaitingQuest) do
    if not self.WaitingQuest[Id] then
      self.WaitingQuest[Id] = 1
      AddFlag = true
    end
  end
  if AddFlag then
    local ExtralInfo = {
      HandleName = "StoryBlackScreenOnSucc",
      TimeOverCallback = {
        Obj = self,
        Func = self.RemoveWaitingQuest
      }
    }
    self:AddStoryBlackScreen(ExtralInfo)
  end
end

function Component:RemoveWaitingQuest()
  self.WaitingQuest = nil
end

function Component:TryRemoveStoryBlackScreenOnSucc(QuestChainId, QuestId)
  if not self.WaitingQuest or not self.WaitingQuest[QuestChainId] and not self.WaitingQuest[QuestId] then
    return
  end
  self.WaitingQuest[QuestChainId] = nil
  self.WaitingQuest[QuestId] = nil
  if not next(self.WaitingQuest) then
    self:RemoveStoryBlackScreenOnSucc()
  end
end

function Component:RemoveStoryBlackScreenOnSucc()
  local HandleName = "StoryBlackScreenOnSucc"
  self:RemoveWaitingQuest()
  self:RemoveStoryBlackScreen(HandleName)
end

function Component:AddStoryBlackScreenOnDelivery()
  local ExtralInfo = {
    HandleName = "StoryBlackScreenOnDelivery"
  }
  self:AddStoryBlackScreen(ExtralInfo)
end

function Component:RemoveStoryBlackScreenOnDelivery()
  local HandleName = "StoryBlackScreenOnDelivery"
  self:RemoveStoryBlackScreen(HandleName)
end

function Component:TryRestartQuestChains()
  DebugPrint("QuestMgr TryRestartQuestChains")
  local Flag = false
  local RestartQuestChains = {}
  for _, Info in pairs(self.QuestChainsNeedRestart) do
    Flag = true
    table.insert(RestartQuestChains, Info)
  end
  if Flag then
    DebugPrint("QuestMgr RestartQuestChains")
    for _, Info in pairs(RestartQuestChains) do
      if self.ClientQuestChains[Info.QuestChainId] then
        self:TryRestartClientQuestChainStoryline(Info.QuestChainId, Info.QuestId)
      end
    end
    self:RemoveStoryBlackScreenOnFail()
  end
  self.QuestChainsNeedRestart = {}
end

function Component:PrintQuestChainsNeedRestart()
  for _, Info in pairs(self.QuestChainsNeedRestart) do
    DebugPrint("QuestchainId,QuestId: ", Info.QuestChainId, Info.QuestId)
  end
end

function Component:GetResurgencePointInfo()
  if not self.TrackingQuestChainId then
    return
  end
  local CurrentRegionId = self:GetCurrentRegionId()
  if not CurrentRegionId or CurrentRegionId <= 0 then
    return
  end
  local ClientQuestChain = self:GetClientQuestChain(self.TrackingQuestChainId)
  if not ClientQuestChain then
    return
  end
  return ClientQuestChain:GetResurgencePointInfo(CurrentRegionId)
end

function Component:GetTrackingStoryNode()
  local TrackingClientQuestChain = self:GetTrackingClientQuestChain()
  if not TrackingClientQuestChain then
    return
  end
  return TrackingClientQuestChain:GetDoingStoryNode()
end

function Component:IsDeadTriggerQuestFail()
  local TrackingStoryNode = self:GetTrackingStoryNode()
  if not TrackingStoryNode then
    return
  end
  return TrackingStoryNode.bDeadTriggerQuestFail
end

function Component:FailTrackingQuest()
  local TrackingClientQuestChain = self:GetTrackingClientQuestChain()
  if not TrackingClientQuestChain then
    return
  end
  TrackingClientQuestChain:FailDoingQuest()
end

function Component:GetTrackingClientQuestChain()
  if not self.TrackingQuestChainId or self.TrackingQuestChainId <= 0 then
    return
  end
  return self:GetClientQuestChain(self.TrackingQuestChainId)
end

function Component:IsCanStartClientQuestChainStoryline()
  if IsStandAlone(GWorld.GameInstance) or IsClient(GWorld.GameInstance) then
    return true
  end
  return false
end

function Component:ClientQuestChainsHandleInLoading()
  if self:IsCanStartClientQuestChainStoryline() == false then
    return
  end
  self:StopAllClientQuestChainStoryline()
end

function Component:CreateQuestDetails(QuestChainId)
  local QuestChainInfo = DataMgr.QuestChain[QuestChainId]
  if nil == QuestChainInfo then
    DebugPrint("Warning: QuestMgr.CreateQuestDetails: QuestChainInfo is Empty")
    return nil
  end
  local FileName = QuestChainInfo.StoryPath
  if nil == FileName then
    DebugPrint("Warning: QuestMgr.CreateQuestDetails: FileName is Empty")
    return nil
  end
  local ClientQuestChain = self:GetOrCreateClientQuestChain(QuestChainId)
  if not ClientQuestChain then
    DebugPrint("Warning: QuestMgr.CreateQuestDetails: FileName is Empty")
    return nil
  end
  local Storyline = ClientQuestChain:GetStoryline()
  Storyline = Storyline or StorylineUtils.BuildStoryline(FileName)
  if nil == Storyline then
    DebugPrint("Warning: QuestMgr.CreateQuestDetails: Storyline is Empty")
    return nil
  end
  return FQuestDetails:New(Storyline)
end

function Component:GetClientQuestChainStoryline(QuestChainId)
  local ClientQuestChain = self:GetClientQuestChain(QuestChainId)
  if not ClientQuestChain then
    return
  end
  return ClientQuestChain:GetStoryline()
end

function Component:IsGuideNodeRunning()
  for _, ClientQuestChain in pairs(self.ClientQuestChains) do
    if ClientQuestChain:IsGuideNodeRunning() then
      return true
    end
  end
  return false
end

function Component:PrintClientQuestChainStorylineInfo()
  for _, ClientQuestChain in pairs(self.ClientQuestChains) do
    ClientQuestChain:PrintStorylineInfo()
  end
end

function Component:OnDestroy()
  GWorld.StoryMgr.ClientQuestChains = self.ClientQuestChains
end

function Component:PlayTrackingQuestChainBGM(QuestChainId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local AudioMgr = AudioManager(GWorld.GameInstance)
  if not AudioMgr then
    return
  end
  local BGMTable = Avatar:GetQuestChainBGMSuitBase(QuestChainId)
  if not BGMTable or not BGMTable:IsEmpty() then
  end
  local BGMParams = Avatar:GetQuestChainBGMParamsSuitBase(QuestChainId)
  if not BGMParams or not BGMParams:IsEmpty() then
  end
end

function Component:StopTrackingQuestChainBGM(QuestChainId, bNeedRemove)
  local AudioMgr = AudioManager(GWorld.GameInstance)
  if not AudioMgr then
    return
  end
end

return Component
