local TimeUtils = require("Utils.TimeUtils")
local ServerTimerSyncComponent = DungeonClass.Class()
ServerTimerSyncComponent.__Component__ = {}

function ServerTimerSyncComponent:BeginPlay()
  if self.TimerInfoList == nil then
    self.TimerInfoList = {}
  end
end

function ServerTimerSyncComponent:EndPlay()
  self:RemoveAllSyncTimer()
end

function ServerTimerSyncComponent:AddSyncTimer(_TimerHandle, _TotalTime, _DeleteCallback, _EndCallback)
  if self:HasSyncTimer(_TimerHandle) then
    return
  end
  local _BeginTimeStamp = TimeUtils.NowTime()
  local TimerInfo = {
    TimerHandle = _TimerHandle,
    TotalTime = _TotalTime,
    BeginTimeStamp = _BeginTimeStamp,
    DeleteCallback = _DeleteCallback,
    EndCallback = _EndCallback
  }
  self.TimerInfoList[_TimerHandle] = TimerInfo
  self:NotifyGameModeDungeonEvent("OnAddSyncTimer", _TimerHandle, _BeginTimeStamp, _TotalTime)
  local RealHandle = self:AddTimer(_TotalTime, function()
    self:RemoveSyncTimer(_TimerHandle, false, true)
  end)
  self.TimerInfoList[_TimerHandle].RealHandle = RealHandle
  print("ServerTimerSyncComponent:AddSyncTimer, TimerHandle", _TimerHandle, "TotalTime", _TotalTime)
end

function ServerTimerSyncComponent:RemoveSyncTimer(TimerHandle, IsDelete, IsEnd)
  if not self:HasSyncTimer(TimerHandle) then
    return
  end
  if not IsEnd then
    local RealHandle = self.TimerInfoList[TimerHandle].RealHandle
    self:RemoveTimer(RealHandle)
  end
  local TimerInfo = self.TimerInfoList[TimerHandle]
  if IsDelete and TimerInfo.DeleteCallback then
    TimerInfo.DeleteCallback()
  end
  if IsEnd and TimerInfo.EndCallback then
    TimerInfo.EndCallback()
  end
  self.TimerInfoList[TimerHandle] = nil
  self:NotifyGameModeDungeonEvent("OnRemoveSyncTimer", TimerHandle)
  print("ServerTimerSyncComponent:RemoveSyncTimer, TimerHandle", TimerHandle)
end

function ServerTimerSyncComponent:GetTimeElapsed(TimerHandle)
  if not self:HasSyncTimer(TimerHandle) then
    return 0
  end
  local TimerInfo = self.TimerInfoList[TimerHandle]
  local NowTime = TimeUtils.NowTime()
  return NowTime - TimerInfo.BeginTimeStamp
end

function ServerTimerSyncComponent:GetTimeRemaining(TimerHandle)
  if not self:HasSyncTimer(TimerHandle) then
    return 0
  end
  local TimerInfo = self.TimerInfoList[TimerHandle]
  local TimeElapsed = self:GetTimeElapsed(TimerHandle)
  return TimerInfo.TotalTime - TimeElapsed
end

function ServerTimerSyncComponent:HasSyncTimer(TimerHandle)
  if self.TimerInfoList == nil then
    self.TimerInfoList = {}
  end
  return self.TimerInfoList[TimerHandle] ~= nil
end

function ServerTimerSyncComponent:RemoveAllSyncTimer()
  for TimerHandle, _ in pairs(self.TimerInfoList) do
    self:RemoveSyncTimer(TimerHandle, false, false)
  end
end

DungeonClass.AssembleComponents(ServerTimerSyncComponent)
return ServerTimerSyncComponent
