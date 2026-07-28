local Class = _G.TypeClass
local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local ClientQuestChain = Class("ClientQuestChain")
local STLogType = UE.EStoryLogType.STL

function ClientQuestChain:Init(QuestChainId)
  self.QuestChainId = QuestChainId
  self.Storyline = nil
end

function ClientQuestChain:GetQuestChain()
  local Avatar = GWorld:GetAvatar()
  return Avatar and Avatar.QuestChains and Avatar.QuestChains[self.QuestChainId]
end

function ClientQuestChain:GetQuestChainId()
  return self.QuestChainId
end

function ClientQuestChain:GetState()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.State
end

function ClientQuestChain:IsLock()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsLock()
end

function ClientQuestChain:IsUnlock()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsUnlock()
end

function ClientQuestChain:IsDoing()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsDoing()
end

function ClientQuestChain:IsFinish()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsFinish()
end

function ClientQuestChain:IsStop()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsStop()
end

function ClientQuestChain:GetStoryPath()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.StoryPath
end

function ClientQuestChain:GetDoingQuestId()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.DoingQuestId
end

function ClientQuestChain:GetAssumeFinish()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:GetAssumeFinish()
end

function ClientQuestChain:GetStoryline()
  return self.Storyline
end

function ClientQuestChain:IsStorylineRunning()
  return self.Storyline ~= nil
end

function ClientQuestChain:StartStoryline(QuestId, NodeId, Payload)
  if self:IsStorylineRunning() then
    DebugPrint("ClientQuestChain:StartStoryline:Storyline Already Exit", self:GetStoryPath(), QuestId, NodeId, Payload)
    return
  end
  local StoryPath = self:GetStoryPath()
  if not StoryPath or "" == StoryPath then
    DebugPrint("ClientQuestChain:StartStoryline:StoryPath Is Empty", QuestId, NodeId, Payload)
    return
  end
  if GWorld.StoryMgr.bEnableStory == false then
    local Title = "STL 已禁用"
    local Message = string.format("试图在禁用时运行新的 STL %s", StoryPath)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, Title, Message)
  end
  QuestId = QuestId or self:GetDoingQuestId()
  
  local function EndCallback()
    self:OnStorylineFinished()
  end
  
  local function StopCallback()
    self:OnStorylineStopped()
  end
  
  local Storyline = StorylineUtils.BuildStoryline(StoryPath, EndCallback, StopCallback)
  if not Storyline then
    local Message = "Story不存在" .. [[

FileName:]] .. StoryPath
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Story不存在", Message)
    return
  end
  DebugPrint("ClientQuestChain:StartStoryline", StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
  self.Storyline = Storyline
  Storyline:StartStory(tonumber(QuestId), NodeId)
  return true
end

function ClientQuestChain:FinishStoryline()
  if not self:IsStorylineRunning() then
    return
  end
  self.Storyline:FinishStory()
  self:ClearStoryline()
end

function ClientQuestChain:StopStoryline()
  if not self:IsStorylineRunning() then
    return
  end
  self.Storyline:Stop()
  self:ClearStoryline()
end

function ClientQuestChain:RestartStoryline(QuestId, NodeId, Payload)
  self:StopStoryline()
  return self:StartStoryline(QuestId, NodeId, Payload)
end

function ClientQuestChain:OnStorylineStopped(Storyline)
  self:ClearStoryline()
end

function ClientQuestChain:OnStorylineFinished(Storyline)
  self:ClearStoryline()
end

function ClientQuestChain:ClearStoryline()
  self.Storyline = nil
end

function ClientQuestChain:FailDoingQuest()
  local DoingStoryNode = self:GetDoingStoryNode()
  if not DoingStoryNode then
    return
  end
  DoingStoryNode:FailQuest()
end

function ClientQuestChain:CheckQuestIdIsInStory(TargetQuestId)
  local StoryPath = self:GetStoryPath()
  if not StoryPath or "" == StoryPath then
    return false
  end
  local FileData = StorylineUtils.GetFileData(StoryPath)
  if nil == FileData then
    DebugPrint("Warning: ClientQuestChain.CheckQuestIdIsInStory: FileData is Empty")
    return false
  end
  for _, Node in pairs(FileData.storyNodeData) do
    if Node and nil ~= Node.propsData.QuestId and Node.propsData.QuestId == TargetQuestId then
      return true
    end
  end
  return false
end

function ClientQuestChain:GetDoingStoryNode()
  if not self.Storyline then
    return
  end
  local DoingQuestId = self:GetDoingQuestId()
  if not DoingQuestId then
    return
  end
  return self.Storyline:GetStoryNode(DoingQuestId)
end

function ClientQuestChain:GetResurgencePointInfo(CurrentRegionId)
  local StoryNode = self:GetDoingStoryNode()
  if not StoryNode then
    return
  end
  local QuestChain = self:GetQuestChain()
  local DoingQuestId = self:GetDoingQuestId()
  local Storyline = self.Storyline
  if StoryNode.ResurgencePoint ~= "" then
    local PointInfo = GuidePointLocData[StoryNode.ResurgencePoint]
    if not PointInfo then
      local Message = "StoryNode中配置的复活点在QuestGuidePointLoc表中不存在" .. [[

FileName:]] .. QuestChain.StoryPath .. [[

QuestChainId:]] .. Storyline.QuestChainId .. [[

QuestId:]] .. DoingQuestId .. [[

ResurgencePoint:]] .. StoryNode.ResurgencePoint
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.STL, "StoryNode中配置的复活点在QuestGuidePointLoc表中不存在", Message)
      return
    end
    if not PointInfo.SubRegionId or PointInfo.SubRegionId <= 0 then
      local Message = "StoryNode中配置的复活点在QuestGuidePointLoc表中无SubRegionId" .. [[

FileName:]] .. QuestChain.StoryPath .. [[

QuestChainId:]] .. Storyline.QuestChainId .. [[

QuestId:]] .. DoingQuestId .. [[

ResurgencePoint:]] .. StoryNode.ResurgencePoint
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.STL, "StoryNode中配置的复活点在QuestGuidePointLoc表中无SubRegionId", Message)
      return
    end
    if DataMgr.SubRegion[CurrentRegionId].RegionId == DataMgr.SubRegion[PointInfo.SubRegionId].RegionId then
      local GameState = UE.UGameplayStatics.GetGameState(GWorld.GameInstance)
      local NewTargetPoint = GameState:GetTargetPoint(StoryNode.ResurgencePoint)
      if UE.IsValid(NewTargetPoint) then
        return {
          Transform = NewTargetPoint:GetTransform(),
          FailBlackScreenText = StoryNode.FailBlackScreenText,
          FadeInTime = StoryNode.FadeInTime,
          FadeOutTime = StoryNode.FadeOutTime,
          ContinueTime = StoryNode.ContinueTime
        }
      else
        DebugPrint("gyy@ Use ResurgencePoint, NewTargetPoint is not valid")
        return
      end
    else
      DebugPrint("gyy@ Use ResurgencePoint, CurrentRegionId and TargetRegionId are not equal")
      return
    end
  else
    if not StoryNode.bUseQuestCoordinate then
      return
    end
    local QuestCoordinate = QuestChain.QuestCoordinate
    if not QuestCoordinate then
      return
    end
    local TargetRegionId = QuestCoordinate.SubRegionId
    if not TargetRegionId or TargetRegionId < 0 then
      return
    elseif 0 == TargetRegionId then
      local Message = "任务链中的第一个任务，想要使用复活功能需要配置复活点位" .. [[

FileName:]] .. QuestChain.StoryPath .. [[

QuestChainId:]] .. Storyline.QuestChainId .. [[

QuestId:]] .. DoingQuestId
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.STL, "任务链中的第一个任务，想要使用复活功能需要配置复活点位", Message)
      return
    end
    if DataMgr.SubRegion[CurrentRegionId].RegionId ~= DataMgr.SubRegion[TargetRegionId].RegionId then
      DebugPrint("gyy@ CurrentRegionId and TargetRegionId are not equal")
      return
    end
    if QuestCoordinate.StartIndex > 0 then
      local GameMode = UE.UGameplayStatics.GetGameMode(GWorld.GameInstance)
      local LevelLoader = GameMode:GetLevelLoader()
      local LevelId = LevelLoader:GetLevelIdByRegionId(QuestCoordinate.SubRegionId)
      local TargtePoint = LevelLoader:GetStartPointByManager(LevelId, QuestCoordinate.StartIndex)
      if UE.IsValid(TargtePoint) then
        return {
          Transform = TargtePoint:GetTransform(),
          FailBlackScreenText = StoryNode.FailBlackScreenText,
          FadeInTime = StoryNode.FadeInTime,
          FadeOutTime = StoryNode.FadeOutTime,
          ContinueTime = StoryNode.ContinueTime
        }
      else
        DebugPrint("gyy@ Use StartIndex, TargtePoint is not valid")
        return
      end
    else
      local TargetTransform = UE.UKismetMathLibrary.MakeTransform(UE.FVector(QuestCoordinate.Location[1], QuestCoordinate.Location[2], QuestCoordinate.Location[3]), UE.FRotator(QuestCoordinate.Rotation[1], QuestCoordinate.Rotation[2], QuestCoordinate.Rotation[3]), UE.FVector(1, 1, 1))
      return {
        Transform = TargetTransform,
        FailBlackScreenText = StoryNode.FailBlackScreenText,
        FadeInTime = StoryNode.FadeInTime,
        FadeOutTime = StoryNode.FadeOutTime,
        ContinueTime = StoryNode.ContinueTime
      }
    end
  end
end

function ClientQuestChain:StartQuest(QuestId)
  if self.Storyline then
    self.Storyline:StartStory(QuestId)
  end
end

function ClientQuestChain:AddFinishQuestCallback(Obj, Func)
  if self.Storyline then
    self.Storyline:AddFinishNodeCallback(Obj, Func)
  end
end

function ClientQuestChain:RemoveFinishQuestCallback(Obj)
  if self.Storyline then
    self.Storyline:RemoveFinishNodeCallback(Obj)
  end
end

function ClientQuestChain:AddStartQuestCallback(Obj, Func)
  if self.Storyline then
    self.Storyline:AddStartNodeCallback(Obj, Func)
  end
end

function ClientQuestChain:RemoveStartQuestCallback(Obj)
  if self.Storyline then
    self.Storyline:RemoveStartNodeCallback(Obj)
  end
end

function ClientQuestChain:IsGuideNodeRunning()
  if not self:IsStorylineRunning() then
    return false
  end
  return self.Storyline:IsGuideNodeRunning()
end

function ClientQuestChain:PrintStorylineInfo()
  if self.Storyline then
    self.Storyline:PrintInfo()
  end
end

return ClientQuestChain
