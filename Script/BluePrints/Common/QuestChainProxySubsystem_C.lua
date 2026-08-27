require("UnLua")
local FQuestChainProxy = require("BluePrints.Client.Quest.QuestChainProxy")
local QuestChainProxySubsystem = Class()

function QuestChainProxySubsystem:Initialize_Lua()
  self.QuestChainProxys = {}
end

function QuestChainProxySubsystem:Deinitialize_Lua()
  DebugPrint("gyy@QuestChainProxySubsystem:Deinitialize_Lua")
  self:StopAllQuestChainProxyStoryline()
  self.QuestChainProxys = {}
end

function QuestChainProxySubsystem:CreateQuestChainProxys(QuestChains)
  for QuestChainId, QuestChain in pairs(QuestChains) do
    self.QuestChainProxys[QuestChainId] = FQuestChainProxy(QuestChainId)
  end
end

function QuestChainProxySubsystem:GetOrCreateQuestChainProxy(QuestChainId, QuestChains)
  if not QuestChainId then
    return
  end
  if not self.QuestChainProxys[QuestChainId] then
    local QuestChain = QuestChains[QuestChainId]
    if not QuestChain then
      return
    end
    self.QuestChainProxys[QuestChainId] = FQuestChainProxy(QuestChainId)
  end
  return self.QuestChainProxys[QuestChainId]
end

function QuestChainProxySubsystem:GetQuestChainProxy(QuestChainId)
  if not QuestChainId then
    return
  end
  return self.QuestChainProxys[QuestChainId]
end

function QuestChainProxySubsystem:RemoveQuestChainProxy(QuestChainId)
  local QuestChainProxy = self.QuestChainProxys[QuestChainId]
  if QuestChainProxy then
    QuestChainProxy:StopStoryline()
    self.QuestChainProxys[QuestChainId] = nil
  end
end

function QuestChainProxySubsystem:TryStartQuestChainProxyStoryline(QuestChainId, QuestId, NodeId, QuestChains, HandleQuestStart, HandleQuestFinish)
  local QuestChainProxy = self:GetOrCreateQuestChainProxy(QuestChainId, QuestChains)
  if not QuestChainProxy then
    return
  end
  if QuestChainProxy:StartStoryline(QuestId, NodeId) then
    QuestChainProxy:AddStartQuestCallback(HandleQuestStart.Obj, HandleQuestStart.Func)
    QuestChainProxy:AddFinishQuestCallback(HandleQuestFinish.Obj, HandleQuestFinish.Func)
  end
end

function QuestChainProxySubsystem:TryRestartQuestChainProxyStoryline(QuestChainId, QuestId, NodeId, QuestChains, HandleQuestStart, HandleQuestFinish)
  local QuestChainProxy = self:GetOrCreateQuestChainProxy(QuestChainId, QuestChains)
  if not QuestChainProxy then
    return
  end
  if QuestChainProxy:RestartStoryline(QuestId, NodeId) then
    QuestChainProxy:AddStartQuestCallback(HandleQuestStart.Obj, HandleQuestStart.Func)
    QuestChainProxy:AddFinishQuestCallback(HandleQuestFinish.Obj, HandleQuestFinish.Func)
  end
end

function QuestChainProxySubsystem:StopQuestChainProxyStoryline(QuestChainId)
  local QuestChainProxy = self:GetQuestChainProxy(QuestChainId)
  if not QuestChainProxy then
    return
  end
  QuestChainProxy:StopStoryline()
end

function QuestChainProxySubsystem:StopAllQuestChainProxyStoryline()
  for _, QuestChainProxy in pairs(self.QuestChainProxys) do
    QuestChainProxy:StopStoryline()
  end
end

function QuestChainProxySubsystem:FinishQuestChainProxyStoryline(QuestChainId)
  local QuestChainProxy = self:GetQuestChainProxy(QuestChainId)
  if not QuestChainProxy then
    return
  end
  QuestChainProxy:FinishStoryline()
end

function QuestChainProxySubsystem:ContinueQuest(QuestChainId)
  local QuestChainProxy = self:GetQuestChainProxy(QuestChainId)
  if QuestChainProxy then
    QuestChainProxy:StartQuest(QuestChainProxy:GetDoingQuestId())
  end
end

function QuestChainProxySubsystem:IsStorylineRunning(QuestChainId)
  local QuestChainProxy = self:GetQuestChainProxy(QuestChainId)
  if QuestChainProxy and QuestChainProxy:IsStorylineRunning() then
    return true
  end
  return false
end

function QuestChainProxySubsystem:GetQuestChainProxyStoryline(QuestChainId)
  local QuestChainProxy = self:GetQuestChainProxy(QuestChainId)
  if not QuestChainProxy then
    return
  end
  return QuestChainProxy:GetStoryline()
end

function QuestChainProxySubsystem:IsGuideNodeRunning()
  for _, QuestChainProxy in pairs(self.QuestChainProxys) do
    if QuestChainProxy:IsGuideNodeRunning() then
      return true
    end
  end
  return false
end

function QuestChainProxySubsystem:PrintQuestChainProxyStorylineInfo()
  for _, QuestChainProxy in pairs(self.QuestChainProxys) do
    QuestChainProxy:PrintStorylineInfo()
  end
end

function QuestChainProxySubsystem:GetResurgencePointInfo(TrackingQuestChainId, CurrentRegionId)
  if not TrackingQuestChainId then
    return
  end
  if not CurrentRegionId or CurrentRegionId <= 0 then
    return
  end
  local QuestChainProxy = self:GetQuestChainProxy(TrackingQuestChainId)
  if not QuestChainProxy then
    return
  end
  return QuestChainProxy:GetResurgencePointInfo(CurrentRegionId)
end

function QuestChainProxySubsystem:IsDeadTriggerQuestFail(TrackingQuestChainId)
  local TrackingStoryNode = self:GetTrackingStoryNode(TrackingQuestChainId)
  if not TrackingStoryNode then
    return
  end
  return TrackingStoryNode.bDeadTriggerQuestFail
end

function QuestChainProxySubsystem:GetTrackingStoryNode(TrackingQuestChainId)
  local TrackingQuestChainProxy = self:GetTrackingQuestChainProxy(TrackingQuestChainId)
  if not TrackingQuestChainProxy then
    return
  end
  return TrackingQuestChainProxy:GetDoingStoryNode()
end

function QuestChainProxySubsystem:FailTrackingQuest(TrackingQuestChainId)
  local TrackingQuestChainProxy = self:GetTrackingQuestChainProxy(TrackingQuestChainId)
  if not TrackingQuestChainProxy then
    return
  end
  TrackingQuestChainProxy:FailDoingQuest()
end

function QuestChainProxySubsystem:GetTrackingQuestChainProxy(TrackingQuestChainId)
  if not TrackingQuestChainId or TrackingQuestChainId <= 0 then
    return
  end
  return self:GetQuestChainProxy(TrackingQuestChainId)
end

function QuestChainProxySubsystem:IsCanStartQuestChainProxyStoryline()
  if IsStandAlone(GWorld.GameInstance) or IsClient(GWorld.GameInstance) then
    return true
  end
  return false
end

function QuestChainProxySubsystem:QuestChainProxysHandleInLoading()
  if self:IsCanStartQuestChainProxyStoryline() == false then
    return
  end
  self:StopAllQuestChainProxyStoryline()
end

function QuestChainProxySubsystem:RemoveAllCallback(Obj)
  for _, QuestChainProxy in pairs(self.QuestChainProxys) do
    QuestChainProxy:RemoveStartQuestCallback(Obj)
    QuestChainProxy:RemoveFinishQuestCallback(Obj)
  end
end

return QuestChainProxySubsystem
