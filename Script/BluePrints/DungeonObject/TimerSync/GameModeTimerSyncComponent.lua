local TimeUtils = require("Utils.TimeUtils")
local GameModeTimerSyncComponent = DungeonClass.Class()
GameModeTimerSyncComponent.__Component__ = {}

function GameModeTimerSyncComponent:BeginPlay()
  if self.TimerInfoList == nil then
    self.TimerInfoList = {}
  end
end

function GameModeTimerSyncComponent:OnNotifyGameModeDungeonEvent_OnAddSyncTimer(_TimerHandle, _BeginTimeStamp, _TotalTime)
  if self:HasSyncTimer(_TimerHandle) then
    return
  end
  local NewTimerInfo = {
    TimerHandle = _TimerHandle,
    TotalTime = _TotalTime,
    ServerBeginTimeStamp = _BeginTimeStamp
  }
  NewTimerInfo.LocalEndTimeStamp = TimeUtils.NowTime() + _TotalTime
  NewTimerInfo.RemainTime = _TotalTime
  self.TimerInfoList[_TimerHandle] = NewTimerInfo
  print("GameModeTimerSyncComponent:OnAddSyncTimer, TimerHandle", _TimerHandle, "TotalTime", _TotalTime)
  self.GameMode:TriggerDungeonComponentFun("OnSyncTimerAdd", _TimerHandle)
  
  local function Callback()
    local TimerInfo = self.TimerInfoList[_TimerHandle]
    if TimerInfo then
      local LocalCurrentTimeStamp = TimeUtils.NowTime()
      TimerInfo.RemainTime = TimerInfo.LocalEndTimeStamp - LocalCurrentTimeStamp
      print("GameModeTimerSync Tick TimerHandel", _TimerHandle, " RemainTime", TimerInfo.RemainTime)
      self.GameMode:TriggerDungeonComponentFun("OnSyncTimerTick", TimerInfo.RemainTime, _TimerHandle)
    else
      self.GameMode:RemoveTimer(_TimerHandle)
    end
  end
  
  self.GameMode:AddTimer(0.1, Callback, true, 0, _TimerHandle, true)
  self.CProperty:AddDungeonObjectTimerStruct(_TimerHandle, _TotalTime)
end

function GameModeTimerSyncComponent:OnNotifyGameModeDungeonEvent_OnRemoveSyncTimer(TimerHandle)
  if not self:HasSyncTimer(TimerHandle) then
    return
  end
  print("GameModeTimerSyncComponent:OnRemoveSyncTimer, TimerHandle", TimerHandle)
  self.GameMode:TriggerDungeonComponentFun("OnSyncTimerRemoveRemove", TimerHandle)
  self.TimerInfoList[TimerHandle] = nil
  self.GameMode:RemoveTimer(TimerHandle)
  self.CProperty:RemoveDungeonObjectTimerStruct(TimerHandle)
end

function GameModeTimerSyncComponent:HasSyncTimer(TimerHandle)
  if self.TimerInfoList == nil then
    self.TimerInfoList = {}
  end
  return self.TimerInfoList[TimerHandle] ~= nil
end

DungeonClass.AssembleComponents(GameModeTimerSyncComponent)
return GameModeTimerSyncComponent
