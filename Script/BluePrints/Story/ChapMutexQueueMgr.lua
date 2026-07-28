local ChapMutexUtils = require("Utils.ChapMutexUtils")
local GameFlowUtils = require("Utils.GameFlowUtils")
local ChapMutexQueueMgr = {}
local FLOW_CHANNEL = "ChapterMutexSelect"

local function LogDebug(...)
  local Args = {
    ...
  }
  for Index = 1, #Args do
    Args[Index] = tostring(Args[Index])
  end
  DebugPrint("[ChapMutexQueue] " .. table.concat(Args, " "))
end

function ChapMutexQueueMgr.New(Owner, OnChapMutexQueueDrained)
  local Self = setmetatable({}, {__index = ChapMutexQueueMgr})
  Self.Owner = Owner
  Self.TaskQueue = {}
  Self.TaskKeySet = {}
  Self.IsProcessing = false
  Self.NeedTriggerAfterDrain = false
  Self.OnChapMutexQueueDrained = OnChapMutexQueueDrained
  Self.FlowId = nil
  Self.FlowReady = false
  return Self
end

function ChapMutexQueueMgr:IsBusy()
  return self.IsProcessing
end

function ChapMutexQueueMgr:SetNeedTriggerAfterDrain(NeedTrigger)
  self.NeedTriggerAfterDrain = true == NeedTrigger
end

function ChapMutexQueueMgr:StartFlowIfNeeded()
  if self.FlowId then
    return
  end
  self.FlowReady = false
  local Handled = false
  local FlowId = GameFlowUtils:AddFlow(FLOW_CHANNEL, {
    GWorld.GameInstance,
    function(_, flowId)
      self.FlowReady = true
      self.FlowId = flowId
      Handled = true
      LogDebug("Flow started", FLOW_CHANNEL, flowId)
      self:Process()
    end
  })
  if not FlowId then
    self.FlowReady = true
    LogDebug("Flow start failed", FLOW_CHANNEL)
    return
  end
  if true == Handled then
    return
  end
  self.FlowId = FlowId
  LogDebug("Flow queued", FLOW_CHANNEL, FlowId)
end

function ChapMutexQueueMgr:StopFlowIfNeeded()
  if self.FlowId then
    GameFlowUtils:RemoveFlow(self.FlowId)
    LogDebug("Flow removed", FLOW_CHANNEL, self.FlowId)
  end
  self.FlowId = nil
  self.FlowReady = false
end

function ChapMutexQueueMgr:Enqueue(NeedUnlockChapterIdList, Source)
  local WasIdle = 0 == #self.TaskQueue and not self.IsProcessing
  local Key, Normalized = ChapMutexUtils.NormalizeTaskList(NeedUnlockChapterIdList)
  if not Key then
    LogDebug("Enqueue dropped invalid list", Source)
    return false
  end
  if self.TaskKeySet[Key] then
    LogDebug("Enqueue dropped duplicated key", Key, Source)
    return false
  end
  self.TaskKeySet[Key] = true
  table.insert(self.TaskQueue, {
    Key = Key,
    NeedUnlockChapterIdList = Normalized,
    Source = Source or "unknown"
  })
  LogDebug("Enqueue success", Key, Source, #self.TaskQueue)
  if WasIdle then
    self:StartFlowIfNeeded()
  end
  return true
end

function ChapMutexQueueMgr:FinishTask(Task)
  if Task and Task.Key then
    self.TaskKeySet[Task.Key] = nil
  end
  self.IsProcessing = false
  LogDebug("FinishTask", Task.Key)
  self:Process()
end

function ChapMutexQueueMgr:Process()
  LogDebug("Process", self.FlowReady, self.IsProcessing)
  if not self.FlowReady then
    return
  end
  if self.IsProcessing then
    return
  end
  local Task = table.remove(self.TaskQueue, 1)
  if not Task then
    LogDebug("Drained", self.NeedTriggerAfterDrain)
    if self.Owner and self.OnChapMutexQueueDrained then
      self.OnChapMutexQueueDrained(self.Owner, self.NeedTriggerAfterDrain)
    end
    if self.NeedTriggerAfterDrain then
      self.NeedTriggerAfterDrain = false
    end
    self:StopFlowIfNeeded()
    return
  end
  self.IsProcessing = true
  LogDebug("Dequeue", Task.Key, Task.Source, #self.TaskQueue)
  local NeedUnlockChapterIdList = Task.NeedUnlockChapterIdList
  if not NeedUnlockChapterIdList or #NeedUnlockChapterIdList <= 0 then
    self:FinishTask(Task)
    return
  end
  ChapMutexUtils.ShowChooseChapterPopup(NeedUnlockChapterIdList, function(ChapterId)
    LogDebug("Chosen", Task.Key, ChapterId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      self:FinishTask(Task)
      return
    end
    Avatar:ChooseQuestChapterUnlock(ChapterId, function()
      self:FinishTask(Task)
    end)
  end, function()
    LogDebug("Cancelled", Task.Key)
    self:FinishTask(Task)
  end)
end

return ChapMutexQueueMgr
