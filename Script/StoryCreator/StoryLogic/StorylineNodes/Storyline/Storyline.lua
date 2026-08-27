local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local STLogType = UE.EStoryLogType.STL
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local ImpressionController = require("BluePrints.Story.Talk.Controller.ImpressionController")
local Storyline = Class("StoryCreator.StoryLogic.StorylineNodes.Storyline.BaseStoryline")

function Storyline:Init(StorylineData, FileName, EndCallback, StopCallback, Payload)
  Storyline.Super.Init(self, StorylineData, FileName, EndCallback, StopCallback, Payload)
  self.Data = StorylineData
  self.FileName = FileName
  self.FilePath = FileName
  self.EndCallback = EndCallback
  self.StopCallback = StopCallback
  self.Payload = Payload
  self.RunningNodeList = {}
  self.FinishedNodeList = {}
  self.bLockRunningNodeList = false
  self.OnStartNodeCallbacks = {}
  self.OnFinishNodeCallbacks = {}
  self:SetCurrentSTLData()
  self:BuildStoryline()
end

function Storyline:BuildStoryline()
  for NodeId, NodeData in pairs(self.Data.storyNodeData) do
    local Node = StorylineUtils.CreateStoryNode(NodeData.type, self)
    if Node.IsStartNode then
      self:SetStartNode(Node)
    elseif Node.IsEndNode then
      self:SetEndNode(Node)
    elseif Node.IsSuccessNode then
      self:SetSuccessNode(Node)
    elseif Node.IsFailNode then
      self:SetFailNode(Node)
    end
    Node:BuildNode(NodeId, NodeData, nil)
    self:AddNode(NodeId, Node)
  end
  if not self:GetStartNode() then
    local Message = "任务链没有StartStoryNode连线" .. [[

FileName:]] .. self.FileName
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链没有StartStoryNode连线", Message)
    return
  end
  self.QuestChainId = self._StartNode.QuestChainId or 0
  DebugPrint("StorylineBuilder BuildStoryline QuestChainId", self.QuestChainId)
  self:BuildAdjacencyMap(self.Data.lineData, "startStory", "endStory")
  self.QuestIdNodeList = {}
  for _, Node in pairs(self:GetNodes()) do
    if Node.QuestId then
      self.QuestIdNodeList[Node.QuestId] = Node
    end
  end
end

function Storyline:StartStory(QuestId, NodeId, UseData)
  DebugPrint("Storyline StartStory QuestId:", QuestId, ",NodeId:", NodeId)
  if self.HasStarted then
    self.StartedNode = self.QuestIdNodeList[QuestId]
    self:StartNode(self.StartedNode, NodeId)
    return
  end
  if QuestId and 0 ~= QuestId then
    self.StartedNode = self.QuestIdNodeList[QuestId]
    if not self.StartedNode then
      local Message = "任务Id不存在" .. [[

FileName:]] .. self.FileName .. [[

QuestChainId:]] .. self.QuestChainId .. [[

QuestId:]] .. QuestId
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务Id不存在", Message)
      self:FinishStory()
      return
    end
    if self.QuestChainId and 0 ~= self.QuestChainId then
      local Avatar = GWorld:GetAvatar()
      if Avatar and Avatar:IsQuestFinished(QuestId) then
        self.StartedNode:Finish("Success")
        return
      end
    end
  else
    self.StartedNode = self._StartNode
  end
  DebugPrint("Storyline Start", self.QuestChainId)
  self.RunningNodeList = {}
  self.HasStarted = true
  self.HasFinished = false
  self:ResetChangedInfo()
  if UseData then
    self:UseCurrentSTLData()
  end
  self:StartNode(self.StartedNode, NodeId)
end

function Storyline:StartNode(Node, NodeId)
  if self.HasFinished then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，开始节点失败", Message)
    return
  end
  if self.bLockRunningNodeList then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已锁定，开始节点失败", Message)
    return
  end
  if Node.HasStarted then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "节点已开始，开始节点失败", Message)
    return
  end
  for _, Callback in ipairs(self.OnStartNodeCallbacks) do
    Callback.Func(Callback.Obj, self.QuestChainId, Node.QuestId)
  end
  Node.HasStarted = true
  Node.HasFinished = false
  self.RunningNodeList[Node.Key] = Node
  DebugPrint("----------------------------------------------------------StartNode ", Node:ToString())
  Node:Start(self, NodeId)
end

function Storyline:FinishNode(Node, OutPortNames, Result)
  if self.HasFinished then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Storyline 已结束，完成节点失败", Message)
    return
  end
  if self.bLockRunningNodeList then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已锁定，完成节点失败", Message)
    return
  end
  if Node.HasFinished then
    local Message = string.format([[
FileName: %s
NodeInfo: %s]], self.FileName, Node:ToString())
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "节点已完成，完成节点失败", Message)
    return
  end
  Node.HasFinished = true
  Node.HasStarted = false
  table.insert(self.FinishedNodeList, Node)
  self.RunningNodeList[Node.Key] = nil
  DebugPrint("----------------------------------------------------------FinishNode", Result, Node:ToString())
  self:OnStoryNodeFinish(Node, OutPortNames, Result)
  for _, Callback in ipairs(self.OnFinishNodeCallbacks) do
    Callback.Func(Callback.Obj, self.QuestChainId, Node, OutPortNames, Result)
  end
  if Node == self._EndNode then
    if false == self._EndNode:GetEndResult() then
      self:StopStory()
    else
      self:FinishStory()
    end
    return
  end
  if not self.QuestChainId or 0 == self.QuestChainId then
    local HaveFailOutPort = self:CheckHaveOutPort(OutPortNames, "Fail")
    local HaveNextNode = self:CheckHaveNextNode(Node, OutPortNames)
    if false == Result and false == HaveNextNode and HaveFailOutPort then
      self._EndNode:SetEndResult(false)
      self:StartNode(self._EndNode)
    else
      for _, OutPortName in pairs(OutPortNames) do
        local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
        if NodeInfoList then
          for _, NextNodeInfo in pairs(NodeInfoList) do
            local NextNode = NextNodeInfo.Node
            self:StartNode(NextNode)
          end
        end
      end
    end
  end
end

function Storyline:FinishStory(IgnoreFinishClear)
  if self.HasFinished then
    local Message = "任务链已结束" .. [[

FileName:]] .. self.FileName .. [[

QuestChainId:]] .. self.QuestChainId
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "任务链已结束", Message)
    return
  end
  self.HasFinished = true
  self.HasStarted = false
  self:ClearStory(IgnoreFinishClear)
  self:OnFinish()
  self:ClearVariable()
  DebugPrint("Storyline Finish", self.QuestChainId)
  if self.EndCallback then
    self:EndCallback()
  end
end

function Storyline:StopStory(IgnoreFinishClear)
  self.HasFinished = true
  self.HasStarted = false
  self:ClearStory(IgnoreFinishClear)
  self:RollbackCurrentSTLData()
  self:OnStop()
  if self.StopCallback then
    self:StopCallback()
  end
end

function Storyline:ClearStory(IgnoreFinishClear)
  self.bLockRunningNodeList = true
  local RunningNodes = {}
  for _, Node in pairs(self.RunningNodeList) do
    table.insert(RunningNodes, Node)
  end
  for _, Node in pairs(RunningNodes) do
    if Node.StopQuest then
      Node:StopQuest(IgnoreFinishClear)
    end
    Node.HasFinished = true
    Node.HasStarted = false
    self:OnStoryNodeStop(Node)
    table.insert(self.FinishedNodeList, Node)
  end
  self.bLockRunningNodeList = false
  self.RunningNodeList = {}
  self:ClearNodeCallbacks()
end

function Storyline:ClearVariable()
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  if StorySubsystem then
    StorySubsystem:ClearGlobalQuestVarsByQuestChainId(self.QuestChainId)
  end
end

function Storyline:CheckHaveNextNode(Node, OutPortNames)
  for _, OutPortName in pairs(OutPortNames) do
    local NodeInfoList = self:GetNextNodeInfoListByPortName(Node, OutPortName)
    if NodeInfoList then
      return true
    end
  end
  return false
end

function Storyline:CheckHaveOutPort(OutPortNames, TargetOutPortName)
  for _, OutPortName in pairs(OutPortNames) do
    if OutPortName == TargetOutPortName then
      return true
    end
  end
  return false
end

function Storyline:GetPayload(Key)
  return self.Payload and self.Payload[Key]
end

function Storyline:AddPayload(Key, Value)
  if not self.Payload then
    self.Payload = {}
  end
  self.Payload[Key] = Value
end

function Storyline:ClearNodeCallbacks()
  self.OnStartNodeCallbacks = {}
  self.OnFinishNodeCallbacks = {}
end

function Storyline:AddFinishNodeCallback(Obj, Func)
  table.insert(self.OnFinishNodeCallbacks, {Obj = Obj, Func = Func})
end

function Storyline:RemoveFinishNodeCallback(Obj)
  for i = #self.OnFinishNodeCallbacks, 1, -1 do
    if self.OnFinishNodeCallbacks[i].Obj == Obj then
      table.remove(self.OnFinishNodeCallbacks, i)
    end
  end
end

function Storyline:AddStartNodeCallback(Obj, Func)
  table.insert(self.OnStartNodeCallbacks, {Obj = Obj, Func = Func})
end

function Storyline:RemoveStartNodeCallback(Obj)
  for i = #self.OnStartNodeCallbacks, 1, -1 do
    if self.OnStartNodeCallbacks[i].Obj == Obj then
      table.remove(self.OnStartNodeCallbacks, i)
    end
  end
end

function Storyline:RecoverOnIncomplete(StoryNode, bRecoverBGM)
  local QuestChainId = self.QuestChainId
  local QuestId = StoryNode.QuestId
  if QuestChainId > 0 and QuestId > 0 then
    local Avatar = GWorld:GetAvatar()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if Avatar and GameMode then
      local TaskInfo = {
        TaskChainId = QuestChainId,
        TaskId = QuestId,
        IsChainLastTask = StoryNode.bIsEndQuest,
        IsChapterEnd = StoryNode.bIsEndChapter
      }
      Avatar:DoRefreshTaskItemUIInfo("Add", TaskInfo)
      GameMode:RecoverDataByQuestChainId(QuestChainId, QuestId)
    end
  end
  if bRecoverBGM then
    AudioManager(GWorld.GameInstance):RecoverLastSTLBGM()
  end
end

function Storyline:OnStoryNodeStop(Node)
  if Node.Questline then
    self:RecoverOnIncomplete(Node, false)
  end
end

function Storyline:OnStoryNodeFinish(StoryNode, OutPortNames, Result)
  local Questline = StoryNode.Questline
  if not Questline then
    return
  end
  local QuestChainId = self.QuestChainId
  local QuestId = StoryNode.QuestId
  local STLData = Questline:GetSTLData()
  local ConfirmFullfill = Questline:GetConfirmFullfill()
  local Avatar = GWorld:GetAvatar()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not Avatar then
    DebugPrint("Avatar Is nil")
  end
  if not GameMode then
    DebugPrint("GameMode Is nil")
  end
  if true ~= Result then
    DebugPrint("----------------------------------------------------------Storyline:OnStoryNodeFinish(Fail)", StoryNode:ToString())
    self:RecoverOnIncomplete(StoryNode, true)
    return
  end
  if QuestId > 0 and Avatar and Avatar:IsQuestFinished(QuestId) then
    return
  end
  DebugPrint("----------------------------------------------------------Storyline:OnStoryNodeFinish(Success)", StoryNode:ToString())
  GWorld.UploadQuestChainData = true
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if 0 ~= StoryNode.JumpId then
    TaskUtils:RemoveQuestInterfaceJump(QuestId)
  end
  if QuestChainId > 0 and QuestId > 0 and Avatar and GameMode and not TaskUtils:CheckSpecialTaskDoing() then
    local RegionUpdateDatas = GameMode:GetRegionQuestChainUpdateData(QuestChainId)
    local RegionQuestCommonUpdateDatas = GameMode:GetRegionQuestCommonUpdateData(QuestId)
    GameMode:UpdateQuestRegionDatas(QuestChainId, RegionUpdateDatas)
    self:SetSpecialLoadingId(StoryNode)
    local Location = PlayerCharacter:GetSafeLocation()
    if Location == FVector(0, 0, 0) then
      local LastRegionLocation = Avatar.LastRegionData:GetLocation()
      if LastRegionLocation and next(LastRegionLocation) then
        Location = FVector(LastRegionLocation.X, LastRegionLocation.Y, LastRegionLocation.Z)
      end
    end
    local Rotation = PlayerCharacter.CurrentRotation
    local QuestCoordinate = {
      LastRegionId = PlayerCharacter:GetRegionId(Location),
      Location = {
        X = Location.X,
        Y = Location.Y,
        Z = Location.Z
      },
      Rotation = {
        Pitch = Rotation.Pitch,
        Yaw = Rotation.Yaw,
        Roll = Rotation.Roll
      }
    }
    local STLExportInfo = DataMgr.STLExportQuestChain[QuestChainId]
    local IsPreQuest = false
    if STLExportInfo and STLExportInfo.Quests[QuestId] ~= nil and STLExportInfo.Quests[QuestId].IsPreQuest then
      IsPreQuest = STLExportInfo.Quests[QuestId].IsPreQuest
    end
    local ServerParamTable = {}
    ServerParamTable.QuestChainId = QuestChainId
    ServerParamTable.QuestId = QuestId
    ServerParamTable.TriggerType = CommonConst.QuestState.Success
    ServerParamTable.TargetId = nil
    ServerParamTable.TargetCount = nil
    self:SaveCurrentSTLData(STLData)
    ServerParamTable.STLData = STLData or {}
    ServerParamTable.RegionQuestDatas = RegionUpdateDatas or {}
    ServerParamTable.QuestCoordinate = QuestCoordinate or {}
    ServerParamTable.QuestCommonDatas = RegionQuestCommonUpdateDatas or {}
    ServerParamTable.SelectRes = ConfirmFullfill
    ServerParamTable.bIsPlayBlackScreenOnComplete = StoryNode.bIsPlayBlackScreenOnComplete
    ServerParamTable.ManualTrigger = nil
    ServerParamTable.NextId = OutPortNames[1]
    if IsPreQuest then
      Avatar:HandleQuestChainDoing_QuestComplete(ServerParamTable)
    else
      Avatar:CompleteQuestSuccess(ServerParamTable)
    end
    AudioManager(GWorld.GameInstance):ClearSTLBGM()
    local TaskInfo = {
      TaskChainId = QuestChainId,
      TaskId = QuestId,
      IsChainLastTask = StoryNode.bIsEndQuest,
      IsChapterEnd = StoryNode.bIsEndChapter
    }
    Avatar:DoRefreshTaskItemUIInfo("Delete", TaskInfo)
  end
  if TaskUtils:CheckSpecialTaskDoing() and StoryNode.QuestDescription ~= "" and "" ~= StoryNode.QuestDeatil then
    TaskUtils:UpdateSpecialTaskInfo("DeleteSpecialTaskInfo", nil)
  end
  local TalkTriggerId = self:GetPayload("TalkTriggerId")
  ImpressionController:SetTalkTriggerComplete(TalkTriggerId)
  PlayerCharacter:SavePlayerSkillUsedTimes()
  GWorld.UploadQuestChainData = false
end

function Storyline:SetSpecialLoadingId(StoryNode)
  local Id = StoryNode.QuestDeliverId
  local LoadingId = StoryNode.QuestDeliverLoadingId
  if Id and LoadingId and DataMgr.SubRegion[Id] and DataMgr.RegionLoading[LoadingId] then
    GWorld.GameInstance.QuestDeliverId = Id
    GWorld.GameInstance.QuestDeliverLoadingId = LoadingId
  end
end

function Storyline:OnStop()
  for i = #self.FinishedNodeList, 1, -1 do
    local Node = self.FinishedNodeList[i]
    if Node.HasFinished then
      Node:OnStop()
    end
  end
  self.FinishedNodeList = {}
end

function Storyline:OnFinish()
  for i = #self.FinishedNodeList, 1, -1 do
    local Node = self.FinishedNodeList[i]
    if Node.HasFinished then
      Node:OnFinish()
    end
  end
  self.FinishedNodeList = {}
end

function Storyline:GetStoryNode(QuestId)
  return self.QuestIdNodeList[QuestId]
end

function Storyline:IsGuideNodeRunning()
  if self.HasFinished then
    return false
  end
  for _, StoryNode in pairs(self.RunningNodeList or {}) do
    if StoryNode.IsGuideNodeRunning and StoryNode:IsGuideNodeRunning() then
      return true
    end
  end
  return false
end

function Storyline:PrintInfo()
  DebugPrint("---------------------------StorylineInfo---------------------------")
  DebugPrint("QuestchainId: ", self.QuestChainId)
  for _, StoryNode in pairs(self.RunningNodeList) do
    if StoryNode.PrintInfo then
      StoryNode:PrintInfo()
    end
  end
  DebugPrint("---------------------------StorylineInfo---------------------------")
end

function Storyline:UpdateCurrentSTLData(SuitSubType, SuitKey, UpdateParam)
  if not self.CurrentSTLData then
    self.CurrentSTLData = {}
  end
  if SuitSubType == CommonConst.QuestSuit.HideUIInScreen then
    local IsHide = UpdateParam.IsHide
    local Tag = UpdateParam.Tag
    if not self.ChangedInfo[SuitSubType] then
      self.ChangedInfo[SuitSubType] = {}
    end
    if not self.ChangedInfo[SuitSubType][SuitKey] then
      self.ChangedInfo[SuitSubType][SuitKey] = 1
    end
    if not self.CurrentSTLData[SuitSubType] then
      self.CurrentSTLData[SuitSubType] = {}
    end
    if not self.CurrentSTLData[SuitSubType][SuitKey] then
      self.CurrentSTLData[SuitSubType][SuitKey] = {}
    end
    local TagSet = self.CurrentSTLData[SuitSubType][SuitKey]
    if IsHide then
      TagSet[Tag] = 1
    else
      TagSet[Tag] = nil
    end
  elseif SuitSubType == CommonConst.QuestSuit.ContinuedGuide then
    local IsHide = UpdateParam.IsHide
    local Tag = UpdateParam.Tag
    if not self.ChangedInfo[SuitSubType] then
      self.ChangedInfo[SuitSubType] = {}
    end
    if not self.ChangedInfo[SuitSubType][SuitKey] then
      self.ChangedInfo[SuitSubType][SuitKey] = 1
    end
    if not self.CurrentSTLData[SuitSubType] then
      self.CurrentSTLData[SuitSubType] = {}
    end
    if not self.CurrentSTLData[SuitSubType][SuitKey] then
      self.CurrentSTLData[SuitSubType][SuitKey] = {}
    end
    local TagSet = self.CurrentSTLData[SuitSubType][SuitKey]
    if IsHide then
      TagSet[Tag] = nil
    else
      TagSet[Tag] = 1
    end
  end
end

function Storyline:SetCurrentSTLData(CurrentSTLData)
  self.CurrentSTLData = CurrentSTLData and CurrentSTLData:save_dump(CurrentSTLData) or {}
end

function Storyline:ResetChangedInfo()
  self.ChangedInfo = {}
end

function Storyline:UseCurrentSTLData()
  if not self.CurrentSTLData then
    return
  end
  if self.CurrentSTLData.HideUIInScreen then
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if GameMode and GameMode.HideUIInScreen then
      for UIName, HideTags in pairs(self.CurrentSTLData.HideUIInScreen) do
        for HideTag, _ in pairs(HideTags) do
          GameMode:HideUIInScreen(UIName, true, HideTag)
        end
      end
    end
  end
  if self.CurrentSTLData.ContinuedGuide then
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if GameMode and GameMode.SetContinuedPCGuideVisibility then
      for ActionName, HideTags in pairs(self.CurrentSTLData.ContinuedGuide) do
        for HideTag, _ in pairs(HideTags) do
          GameMode:SetContinuedPCGuideVisibility(ActionName, false, HideTag)
        end
      end
    end
  end
end

function Storyline:RollbackCurrentSTLData()
  if not self.CurrentSTLData then
    return
  end
  if self.CurrentSTLData.HideUIInScreen then
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if GameMode and GameMode.HideUIInScreen then
      for UIName, HideTags in pairs(self.CurrentSTLData.HideUIInScreen) do
        for HideTag, _ in pairs(HideTags) do
          GameMode:HideUIInScreen(UIName, false, HideTag)
        end
      end
    end
  end
  if self.CurrentSTLData.ContinuedGuide then
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if GameMode and GameMode.SetContinuedPCGuideVisibility then
      for ActionName, HideTags in pairs(self.CurrentSTLData.ContinuedGuide) do
        for HideTag, _ in pairs(HideTags) do
          GameMode:SetContinuedPCGuideVisibility(ActionName, true, HideTag)
        end
      end
    end
  end
end

function Storyline:SaveCurrentSTLData(STLData)
  for SuitSubType, SuitKeys in pairs(self.ChangedInfo) do
    if SuitSubType == CommonConst.QuestSuit.HideUIInScreen then
      for SuitKey, _ in pairs(SuitKeys) do
        local HideTags = self.CurrentSTLData[SuitSubType][SuitKey]
        STLData:SaveSuitUpdateData("UpdateSuitKey2Table", CommonConst.SuitType.QuestSuit, CommonConst.QuestSuit.HideUIInScreen, SuitKey, HideTags)
      end
    elseif SuitSubType == CommonConst.QuestSuit.ContinuedGuide then
      for SuitKey, _ in pairs(SuitKeys) do
        local ShowTags = self.CurrentSTLData[SuitSubType][SuitKey]
        STLData:SaveSuitUpdateData("UpdateSuitKey2Table", CommonConst.SuitType.QuestSuit, CommonConst.QuestSuit.ContinuedGuide, SuitKey, ShowTags)
      end
    end
  end
end

return Storyline
