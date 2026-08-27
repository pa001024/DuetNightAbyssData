local Class = _G.TypeClass
local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local QuestChainProxy = Class("QuestChainProxy")
local STLogType = UE.EStoryLogType.STL

function QuestChainProxy:Init(QuestChainId)
  self.QuestChainId = QuestChainId
  self.Storyline = nil
end

function QuestChainProxy:GetQuestChain()
  local Avatar = GWorld:GetAvatar()
  return Avatar and Avatar.QuestChains and Avatar.QuestChains[self.QuestChainId]
end

function QuestChainProxy:GetQuestChainId()
  return self.QuestChainId
end

function QuestChainProxy:GetState()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.State
end

function QuestChainProxy:IsLock()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsLock()
end

function QuestChainProxy:IsUnlock()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsUnlock()
end

function QuestChainProxy:IsDoing()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsDoing()
end

function QuestChainProxy:IsFinish()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsFinish()
end

function QuestChainProxy:IsStop()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:IsStop()
end

function QuestChainProxy:GetStoryPath()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.StoryPath
end

function QuestChainProxy:GetDoingQuestId()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.DoingQuestId
end

function QuestChainProxy:GetAssumeFinish()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain:GetAssumeFinish()
end

function QuestChainProxy:GetStoryline()
  return self.Storyline
end

function QuestChainProxy:IsStorylineRunning()
  return self.Storyline ~= nil
end

function QuestChainProxy:StartStoryline(QuestId, NodeId, Payload)
  if self:IsStorylineRunning() then
    DebugPrint("QuestChainProxy:StartStoryline:Storyline Already Exit", self:GetStoryPath(), QuestId, NodeId, Payload)
    return
  end
  local StoryPath = self:GetStoryPath()
  if not StoryPath or "" == StoryPath then
    DebugPrint("QuestChainProxy:StartStoryline:StoryPath Is Empty", QuestId, NodeId, Payload)
    return
  end
  QuestId = QuestId or self:GetDoingQuestId()
  
  local function EndCallback()
    self:OnStorylineFinished()
  end
  
  local function StopCallback()
    self:OnStorylineStopped()
  end
  
  local Storyline = StorylineUtils.BuildStoryline(StoryPath, EndCallback, StopCallback, Payload)
  if not Storyline then
    local Message = "Story不存在" .. [[

FileName:]] .. StoryPath
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, STLogType, "Story不存在", Message)
    return
  end
  DebugPrint("QuestChainProxy:StartStoryline", StoryPath, QuestId, NodeId, EndCallback, StopCallback, Payload)
  self.Storyline = Storyline
  Storyline:SetCurrentSTLData(self:GetCurrentSTLData())
  Storyline:StartStory(tonumber(QuestId), NodeId, true)
  return true
end

function QuestChainProxy:FinishStoryline()
  if not self:IsStorylineRunning() then
    return
  end
  self.Storyline:FinishStory()
end

function QuestChainProxy:StopStoryline()
  if not self:IsStorylineRunning() then
    return
  end
  self.Storyline:StopStory()
end

function QuestChainProxy:RestartStoryline(QuestId, NodeId, Payload)
  self:StopStoryline()
  return self:StartStoryline(QuestId, NodeId, Payload)
end

function QuestChainProxy:OnStorylineStopped(Storyline)
  self:ClearStoryline()
end

function QuestChainProxy:OnStorylineFinished(Storyline)
  self:ClearStoryline()
end

function QuestChainProxy:ClearStoryline()
  self.Storyline = nil
end

function QuestChainProxy:FailDoingQuest()
  local DoingStoryNode = self:GetDoingStoryNode()
  if not DoingStoryNode then
    return
  end
  DoingStoryNode:FailQuest()
end

function QuestChainProxy:GetDoingStoryNode()
  if not self.Storyline then
    return
  end
  local DoingQuestId = self:GetDoingQuestId()
  if not DoingQuestId then
    return
  end
  return self.Storyline:GetStoryNode(DoingQuestId)
end

function QuestChainProxy:GetResurgencePointInfo(CurrentRegionId)
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

function QuestChainProxy:StartQuest(QuestId)
  if self.Storyline then
    self.Storyline:StartStory(QuestId)
  end
end

function QuestChainProxy:AddFinishQuestCallback(Obj, Func)
  if self.Storyline then
    self.Storyline:AddFinishNodeCallback(Obj, Func)
  end
end

function QuestChainProxy:RemoveFinishQuestCallback(Obj)
  if self.Storyline then
    self.Storyline:RemoveFinishNodeCallback(Obj)
  end
end

function QuestChainProxy:AddStartQuestCallback(Obj, Func)
  if self.Storyline then
    self.Storyline:AddStartNodeCallback(Obj, Func)
  end
end

function QuestChainProxy:RemoveStartQuestCallback(Obj)
  if self.Storyline then
    self.Storyline:RemoveStartNodeCallback(Obj)
  end
end

function QuestChainProxy:IsGuideNodeRunning()
  if not self:IsStorylineRunning() then
    return false
  end
  return self.Storyline:IsGuideNodeRunning()
end

function QuestChainProxy:PrintStorylineInfo()
  if self.Storyline then
    self.Storyline:PrintInfo()
  end
end

function QuestChainProxy:GetCurrentSTLData()
  local QuestChain = self:GetQuestChain()
  return QuestChain and QuestChain.Suit
end

return QuestChainProxy
